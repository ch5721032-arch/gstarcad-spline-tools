;; polyline-to-spline.lsp - Convert polylines to spline-fit curves
;; Command: PL2SPL
(defun c:PL2SPL ( / ss i en )
  (setq ss (ssget '((0 . "LWPOLYLINE,POLYLINE"))))
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq en (ssname ss i))
        (command "_.PEDIT" en "_S" "")
        (setq i (1+ i))
      )
      (princ (strcat "\n" (itoa (sslength ss)) " polylines converted to spline fit."))
    )
    (princ "\nNothing selected.")
  )
  (princ)
)
