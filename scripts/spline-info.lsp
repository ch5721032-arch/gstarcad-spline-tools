;; spline-info.lsp - Report degree and length of the selected splines
;; Command: SPLINFO
(defun c:SPLINFO ( / ss i en ed deg len )
  (vl-load-com)
  (setq ss (ssget '((0 . "SPLINE"))))
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq en (ssname ss i) ed (entget en))
        (setq deg (cdr (assoc 71 ed)))
        (setq len (vlax-curve-getDistAtParam en (vlax-curve-getEndParam en)))
        (princ (strcat "\nSpline " (itoa (1+ i))
                       ": degree=" (itoa (if deg deg 0))
                       "  length=" (rtos (if len len 0.0) 2 4)))
        (setq i (1+ i))
      )
    )
    (princ "\nNothing selected.")
  )
  (princ)
)
