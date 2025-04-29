;; onboarding.clar -- employee onboarding contract

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
(define-constant STATUS-PENDING "PENDING")

;; Register a new employee
(define-public (register-employee 
    (emp principal) 
    (name (string-ascii 256)) 
    (role (string-ascii 256)) 
    (date-hired (string-ascii 20)) 
    (doc-hash (string-ascii 64)))
  (ok (map-set employees
      { employee: emp }
      { 
        name: name,
        role: role,
        date-hired: date-hired,
        status: STATUS-PENDING,
        doc-hash: doc-hash 
      })))
