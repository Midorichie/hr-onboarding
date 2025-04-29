;; onboarding.clar -- implements the onboarding-trait for employee onboarding
 
;; Import the trait definition
(impl-trait .onboarding-trait.onboarding-trait)
 
;; Define employee map
(define-map employees
  { employee: principal }
  {
    name: (string-ascii 256),
    role: (string-ascii 256),
    date-hired: (string-ascii 20),
    status: (string-ascii 20),
    doc-hash: (string-ascii 64)
  })
 
;; Constants
(define-constant ERR-UNAUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-INPUT (err u400))
(define-constant STATUS-PENDING "PENDING")
(define-constant STATUS-ACTIVE "ACTIVE")
(define-constant STATUS-TERMINATED "TERMINATED")
 
;; Reference to contract owner principal
(define-data-var contract-owner principal tx-sender)
 
;; Check if caller is contract owner
(define-private (is-contract-owner)
  (is-eq tx-sender (var-get contract-owner)))

;; Check if principal is valid (not tx-sender)
(define-private (is-valid-principal (emp principal))
  (not (is-eq emp tx-sender)))

;; Check if string is not empty
(define-private (is-non-empty-string (value (string-ascii 256)))
  (> (len value) u0))

;; Check if shorter string is not empty
(define-private (is-valid-short-string (value (string-ascii 64)))
  (> (len value) u0))
 
;; Get employee details - trait implementation
(define-read-only (get-employee-details (emp principal))
  (ok (map-get? employees { employee: emp })))
 
;; Register a new employee - trait implementation
(define-public (register-employee
    (emp principal)
    (name (string-ascii 256))
    (role (string-ascii 256))
    (date-hired (string-ascii 20))
    (doc-hash (string-ascii 64)))
  (begin
    (asserts! (is-contract-owner) ERR-UNAUTHORIZED)
    ;; Validate all inputs
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (asserts! (is-non-empty-string name) ERR-INVALID-INPUT)
    (asserts! (is-non-empty-string role) ERR-INVALID-INPUT)
    (asserts! (is-valid-short-string date-hired) ERR-INVALID-INPUT)
    (asserts! (is-valid-short-string doc-hash) ERR-INVALID-INPUT)
    
    (asserts! (is-none (map-get? employees { employee: emp })) ERR-ALREADY-EXISTS)
    (map-set employees
      { employee: emp }
      {
        name: name,
        role: role,
        date-hired: date-hired,
        status: STATUS-PENDING,
        doc-hash: doc-hash
      })
    (ok emp)))
 
;; Approve an employee - trait implementation
(define-public (approve-employee (emp principal))
  (begin
    (asserts! (is-contract-owner) ERR-UNAUTHORIZED)
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (let ((employee-data (unwrap! (map-get? employees { employee: emp }) ERR-NOT-FOUND)))
      (asserts! (is-eq (get status employee-data) STATUS-PENDING) ERR-UNAUTHORIZED)
      (ok (map-set employees
          { employee: emp }
          (merge employee-data { status: STATUS-ACTIVE }))))))
 
;; Terminate an employee - trait implementation
(define-public (terminate-employee (emp principal))
  (begin
    (asserts! (is-contract-owner) ERR-UNAUTHORIZED)
    (asserts! (is-valid-principal emp) ERR-INVALID-INPUT)
    (let ((employee-data (unwrap! (map-get? employees { employee: emp }) ERR-NOT-FOUND)))
      (asserts! (not (is-eq (get status employee-data) STATUS-TERMINATED)) ERR-UNAUTHORIZED)
      (ok (map-set employees
          { employee: emp }
          (merge employee-data { status: STATUS-TERMINATED }))))))
