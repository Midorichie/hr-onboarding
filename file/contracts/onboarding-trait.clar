;; onboarding-trait.clar -- defines the trait interface for the onboarding contract
 
;; Define the trait for the onboarding contract
(define-trait onboarding-trait
  (
    ;; Get employee details - returns employee information or error
    (get-employee-details (principal)
      (response
        (optional {
          name: (string-ascii 256),
          role: (string-ascii 256),
          date-hired: (string-ascii 20),
          status: (string-ascii 20),
          doc-hash: (string-ascii 64)
        })
        uint
      )
    )
   
    ;; Register a new employee
    (register-employee
      (
        principal
        (string-ascii 256)
        (string-ascii 256)
        (string-ascii 20)
        (string-ascii 64)
      )
      (response principal uint)
    )
   
    ;; Approve an employee
    (approve-employee (principal) (response bool uint))
   
    ;; Terminate an employee
    (terminate-employee (principal) (response bool uint))
  )
)
