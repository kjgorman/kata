(defclass Rule ()
  ((Element :accessor Element :initarg :element)
   (UnitPrice :accessor UnitPrice :initarg :unitprice)
   (Deal :accessor Deal :initarg :deal)))

(defun create-rule (elem unit-price deal)
  (make-instance 'Rule :element elem :unitprice unit-price :deal deal))

(defclass Deal ()
  ((DealElement :accessor DealElement :initarg :dealelement)
   (Quantity :accessor Quantity :initarg :quantity)
   (BatchPrice :accessor BatchPrice :initarg :batchprice)))

(defun create-deal (elem qty batch-price)
  (make-instance 'Deal :dealelement elem :quantity qty :batchprice batch-price))

;; export the rules
(defvar rules
   (list
    (create-rule #\D 15 nil)
    (create-rule #\C 20 nil)
    (create-rule #\B 30 '(create-deal #\B 2 45))
    (create-rule #\A 50 '(create-deal #\A 3 130))))
