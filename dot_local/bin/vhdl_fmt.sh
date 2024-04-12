#!/bin/bash
set -euo pipefail

if ! which emacs &> /dev/null ; then
    echo "Please install emacs to format vhdl."
    exit 1
fi

# yoinked from https://github.com/InES-HPMM/emacs-vhdl-formatter-vscode/blob/main/src/extension.ts
eval_lisp='
(let
    (vhdl-file-content next-line)
    (while
        (setq
            next-line
            (ignore-errors (read-from-minibuffer ""))
        )
        (setq
            vhdl-file-content
            (concat vhdl-file-content next-line "\n")
        )
    )
    (with-temp-buffer
        (vhdl-mode)
        (setq vhdl-basic-offset 2)
        (insert vhdl-file-content)
        (vhdl-beautify-region
            (point-min)
            (point-max)
        )
        (princ (buffer-string))
    )
)'

emacs --batch --eval "$eval_lisp"
