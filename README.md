# GstarCAD Spline Tools

Convert polylines to spline-fit curves, approximate splines with clean polylines, and report degree and length for a selection of splines.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Splines and polylines each have jobs they are good at. These commands convert a polyline to a spline fit in one step, replace splines with polylines sampled at 64 points so downstream tools can use them, and print degree and true length for any selection of splines.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/polyline-to-spline.lsp` | ;; polyline-to-spline.lsp - Convert polylines to spline-fit curves
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
 |
| `scripts/spline-to-pline.lsp` | ;; spline-to-pline.lsp - Approximate splines with polylines sampled at 64 points
;; Command: SPL2PL
(defun c:SPL2PL ( / ss i en len step d pts )
  (vl-load-com)
  (setq ss (ssget '((0 . "SPLINE"))))
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq en (ssname ss i))
        (setq len (vlax-curve-getDistAtParam en (vlax-curve-getEndParam en)))
        (if (and len (> len 0.0))
          (progn
            (setq step (/ len 64.0) d 0.0 pts nil)
            (while (< d len)
              (setq pts (cons (vlax-curve-getPointAtDist en d) pts))
              (setq d (+ d step))
            )
            (setq pts (cons (vlax-curve-getPointAtDist en len) pts))
            (setq pts (reverse pts))
            (command "_.PLINE")
            (foreach p pts (command p))
            (command "")
            (entdel en)
          )
        )
        (setq i (1+ i))
      )
      (princ (strcat "\nProcessed " (itoa (sslength ss)) " splines."))
    )
    (princ "\nNothing selected.")
  )
  (princ)
)
 |
| `scripts/spline-info.lsp` | ;; spline-info.lsp - Report degree and length of the selected splines
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
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.
