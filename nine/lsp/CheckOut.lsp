(load "PriceRules.lsp")

(defclass CheckOut ()
  ((Total :accessor Total :initform 0)
   (State :accessor State :initform nil)))

(defgeneric scan (checkout str))

(defun apply-discount (rules str)
  (values 0 str))

(defun apply-standard (rules rest)
  (reduce #'+
          (mapcar
           (lambda (tkn) (loop
                            for rule in rules
                            when (equalp (Element rule) tkn)
                            sum (UnitPrice rule)))
           rest)))

(defun apply-rules (rules str)
  (multiple-value-bind (total rest) (apply-discount rules (coerce str 'list))
    (+ total (apply-standard rules rest))))

(defmethod scan ((checkout Checkout) str)
  (setf (State checkout) (cons str (State checkout)))
  (setf (Total checkout) (apply-rules rules (State Checkout)))
  checkout)

(defun initial-checkout ()
  (make-instance 'CheckOut))
