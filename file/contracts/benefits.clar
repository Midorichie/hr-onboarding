;; benefits.clar -- contract for managing employee benefits
 
;; Import the onboarding trait
;; Use the trait from the onboarding contract using the correct path
(use-trait onboarding-contract .onboarding-trait.onboarding-trait)
 
;; Define benefits map
(define-map employee-benefits
  { employee: principal }
  {
    health-plan: (string-ascii 64),
    retirement-plan: (string-ascii 64),
    pto-days: uint,
    benefits-status: (string-ascii 20),
    last-updated: uint
  })
 
;; Define eligible employees map
(define-map eligible-employees
  { employee: principal }
  { eligible: bool })
 
;; Constants
(define-constant ERR-UNAUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-NOT-ELIGIBLE (err u403))
(define-constant ERR-INVALID-INPUT (err u400))
(define-constant STATUS-ENROLLED "ENROLLED")
(define-constant STATUS-PENDING "PENDING")
(define-constant STATUS-TERMINATED "TERMINATED")

;; Maximum allowed PTO days
(define-constant MAX-PTO-DAYS u365)
 
;; Reference to contract owner principal
(define-data-var contract-owner principal tx-sender)
 
;; Check if caller is contract owner
(define-private (is-contract-owner)
  (is-eq tx-sender (var-get contract-owner)))

;; Check if principal is not tx-sender (to prevent self-modification)
(define-private (is-valid-principal (emp principal))
  (not (is-eq emp tx-sender)))

;; Check if PTO days are within acceptable range
(define-private (is-valid-pto-days (days uint))
  (<= days MAX-PTO-DAYS))

;; Check if string is not empty
(define-private (is-non-empty-string (value (string-ascii 64)))
  (> (len value) u0))
 
;; Set employee as eligible - owner only
(define-public (set-employee-eligible (emp principal) (eligible bool))
  (begin
    (asserts! (is-contract-owner) ERR-UNAUTHORIZED)
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (ok (map-set eligible-employees { employee: emp } { eligible: eligible }))))
 
;; Check if employee is eligible
(define-private (is-eligible (emp principal))
  (default-to false (get eligible (map-get? eligible-employees { employee: emp }))))
 
;; Enroll employee in benefits
(define-public (enroll-employee
    (onboarding-contract <onboarding-contract>)
    (emp principal)
    (health-plan (string-ascii 64))
    (retirement-plan (string-ascii 64))
    (pto-days uint))
  (begin
    ;; Validate all inputs
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (asserts! (is-non-empty-string health-plan) ERR-INVALID-INPUT)
    (asserts! (is-non-empty-string retirement-plan) ERR-INVALID-INPUT)
    (asserts! (is-valid-pto-days pto-days) ERR-INVALID-INPUT)
    
    ;; Check employee exists and is eligible 
    (let ((employee-details (try! (contract-call? onboarding-contract get-employee-details emp))))
      (asserts! (is-some employee-details) ERR-NOT-FOUND)
      (asserts! (is-eligible emp) ERR-NOT-ELIGIBLE)
      (asserts! (is-eq (get status (unwrap! employee-details ERR-NOT-FOUND)) "ACTIVE") ERR-NOT-ELIGIBLE)
      (ok (map-set employee-benefits
          { employee: emp }
          {
            health-plan: health-plan,
            retirement-plan: retirement-plan,
            pto-days: pto-days,
            benefits-status: STATUS-ENROLLED,
            last-updated: block-height
          })))))
 
;; Get benefits details
(define-read-only (get-benefits (emp principal))
  (begin
    (asserts! (or (is-eq tx-sender emp) (is-contract-owner)) ERR-UNAUTHORIZED)
    (ok (map-get? employee-benefits { employee: emp }))))
 
;; Update PTO allocation
(define-public (update-pto (emp principal) (pto-days uint))
  (begin
    (asserts! (is-contract-owner) ERR-UNAUTHORIZED)
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (asserts! (is-valid-pto-days pto-days) ERR-INVALID-INPUT)
    (let ((benefits-data (unwrap! (map-get? employee-benefits { employee: emp }) ERR-NOT-FOUND)))
      (ok (map-set employee-benefits
          { employee: emp }
          (merge benefits-data {
            pto-days: pto-days,
            last-updated: block-height
          }))))))
 
;; Terminate benefits
(define-public (terminate-benefits (emp principal))
  (begin
    (asserts! (is-contract-owner) ERR-UNAUTHORIZED)
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (let ((benefits-data (unwrap! (map-get? employee-benefits { employee: emp }) ERR-NOT-FOUND)))
      (ok (map-set employee-benefits
          { employee: emp }
          (merge benefits-data {
            benefits-status: STATUS-TERMINATED,
            last-updated: block-height
          }))))))
