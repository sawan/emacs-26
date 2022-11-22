;;; pulsar-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "pulsar" "pulsar.el" (0 0 0 0))
;;; Generated autoloads from pulsar.el

(autoload 'pulsar-pulse-line "pulsar" "\
Temporarily highlight the current line.
When `pulsar-pulse' is non-nil (the default) make the highlight
pulse before fading away.  The pulse effect is controlled by
`pulsar-delay' and `pulsar-iterations'.

Also see `pulsar-highlight-line' for a highlight without the
pulse effect." t nil)

(autoload 'pulsar-highlight-line "pulsar" "\
Temporarily highlight the current line.
Unlike `pulsar-pulse-line', never pulse the current line.  Keep
the highlight in place until another command is invoked.

Use `pulsar-highlight-face' (it is the same as `pulsar-face' by
default)." t nil)

(autoload 'pulsar-pulse-with-face "pulsar" "\
Produce NAME function to `pulsar--pulse' with FACE.

\(fn NAME FACE)" nil t)

(function-put 'pulsar-pulse-with-face 'lisp-indent-function 'function)

(autoload 'pulsar-highlight-dwim "pulsar" "\
Temporarily highlight the current line or active region.
The region may also be a rectangle.

For lines, do the same as `pulsar-highlight-line'." t nil)

(put 'pulsar-global-mode 'globalized-minor-mode t)

(defvar pulsar-global-mode nil "\
Non-nil if Pulsar-Global mode is enabled.
See the `pulsar-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `pulsar-global-mode'.")

(custom-autoload 'pulsar-global-mode "pulsar" nil)

(autoload 'pulsar-global-mode "pulsar" "\
Toggle Pulsar mode in all buffers.
With prefix ARG, enable Pulsar-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Pulsar mode is enabled in all buffers where
`pulsar--on' would do it.
See `pulsar-mode' for more information on Pulsar mode.

\(fn &optional ARG)" t nil)

(autoload 'pulsar-recenter "pulsar" "\
Produce command to pulse and recenter.
The symbol is NAME, DOC for the doc string, and ARG is passed to
`recenter'.

\(fn NAME DOC ARG)" nil t)

(function-put 'pulsar-recenter 'lisp-indent-function 'defun)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "pulsar" '("pulsar-")))

;;;***

;;;### (autoloads nil nil ("pulsar-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; pulsar-autoloads.el ends here
