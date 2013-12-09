(load "PriceRules.lsp")

(defclass CheckOut ()
  ((Total :accessor Total :initform 0)
   (State :accessor State :initform nil)))

(defgeneric scan (checkout str))

(defun skip-while (lst pred)
  (let ((head (car lst)))
    (if (eql nil head)
        nil
        (if (funcall pred head)
            (skip-while (cdr lst) pred)
            lst))))

(defun applicable (rule str)
  (let ((d (Deal rule)))
    (if (not (eql nil d))
        (>= (count (DealElement (car d)) str) (Quantity (car d)))
        nil)))

(defun any-applicable (rules str)
  (let ((r (skip-while rules (lambda (r) (not (applicable r str))))))
    (if (not (eql r nil))
        (let ((d (Deal (car r))))
          (if (not (eql d nil))
              (car d)
              nil))
        nil)))

;; Applies as many of the discount rules as possible
;; returning the total value, and unconsumed elements
(defun apply-discount (rules str)
  (let ((d (any-applicable rules str)))
    (if (not (eql nil d))
      (let* ((batched-price (BatchPrice d))
             (rest (remove (DealElement d) str :count (Quantity d))))
        (multiple-value-bind (totl next) (apply-discount rules rest)
          (values (+ totl batched-price) next)))
      (values 0 str))))

;; Applies the standard price rules for all remaining
;; elements in the inputs
(defun apply-standard (rules rest)
  (reduce #'+
          (mapcar
           (lambda (tkn) (loop
                            for rule in rules
                            when (equalp (Element rule) tkn)
                            sum (UnitPrice rule)))
           rest)))

;; Applies the entire ruleset (both discounts and
;; standard pricing) to an input string
(defun apply-rules (rules str)
  (multiple-value-bind (total rest) (apply-discount rules (coerce str 'list))
    (+ total (apply-standard rules rest))))


;; Steps a checkout instance by one input value, by
;; recomputing the optimal total for the new state
(defmethod scan ((checkout Checkout) str)
  (setf (State checkout) (cons str (State checkout)))
  (setf (Total checkout) (apply-rules rules (State Checkout)))
  checkout)

(defun initial-checkout ()
  (make-instance 'CheckOut))
