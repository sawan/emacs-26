;;; -*- lexical-binding: t -*-

;; http://milkbox.net/note/single-file-master-emacs-configuration/
;;;; package.el
(require 'package)

(setq package-user-dir "~/.emacs.d/elpa/")
(setq package-list-archives ())
(setq package-archives '(
             ("gnu" . "https://elpa.gnu.org/packages/")
             ("melpa" . "https://melpa.org/packages/")
             ("melpa-stable" . "https://stable.melpa.org/packages/")
             ;; ("marmalade" . "https://marmalade-repo.org/packages/")
))


(package-initialize)

(defun mp-install-rad-packages ()
  "Install only the sweetest of packages."
  (interactive)
  (package-refresh-contents)
  (mapc #'(lambda (package)
            (unless (package-installed-p package)
              (package-install package)))
        '(
          browse-kill-ring
          magit
          paredit
          undo-tree
          bm
          pos-tip
          yasnippet
          rainbow-delimiters
          rainbow-mode
          fastnav
          hungry-delete
          visual-regexp
          visual-regexp-steroids
          key-chord
          yaml-mode
          color-moccur
          table
          iedit
          multiple-cursors
          macrostep
          jedi
          elpy
          expand-region
          hydra
          autopair
          wrap-region
          move-text
          beacon
          boxquote
          ov
          paradox
          kaolin-themes
          flx
          ivy
          ivy-hydra
          smex
          avy
          )))

(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))

(setq exec-path (append exec-path '("/opt/local/bin")))

;;;; init.el

(add-to-list 'load-path "~/.emacs.d/vendors/")
(add-to-list 'load-path "~/.emacs.d/vendors/DrewsLibraries/")
(add-to-list 'load-path "~/.emacs.d/vendors/revbufs.el")
(add-to-list 'load-path "~/.emacs.d/vendors/breadcrumb.el")
(add-to-list 'load-path "~/.emacs.d/vendors/kill-lines.el")
(add-to-list 'load-path "~/.emacs.d/vendors/emacros.el")
(add-to-list 'load-path "~/.emacs.d/vendors/no-easy-keys.el")
(add-to-list 'load-path "~/.emacs.d/vendors/moccur-edit.el")
(add-to-list 'load-path "~/.emacs.d/vendors/revbufs.el")
;; (add-to-list 'load-path "~/.emacs.d/vendors/flex.el")

(require 'filetree)
(require 'visual-regexp)
(require 'revbufs)
(require 'magit)
(require 'kill-lines)
(require 'multiple-cursors)
(require 'moccur-edit)
(require 'thing-edit)
(require 'no-easy-keys)
;; (require 'flex)

(no-easy-keys)

;; start native Emacs server ready for client connections                  .
(add-hook 'after-init-hook 'server-start)

;;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-selection-wrap-around t)

(defun sv-company-mode-keys ()
  (interactive)
  (define-key company-active-map (kbd "<return>") 'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") 'company-select-next)
  (define-key company-active-map (kbd "<backtab>") 'company-select-previous)

  (setq completion-styles '(orderless))
  (setq orderless-matching-styles '(orderless-regexp))
  (setq ivy-re-builders-alist '((t . orderless-ivy-re-builder))))


;; https://oremacs.com/2017/12/27/company-numbers/
(setq company-show-numbers t)

(let ((map company-active-map))
  (mapc
   (lambda (x)
     (define-key map (format "%d" x) 'ora-company-number))
   (number-sequence 0 9))
  (define-key map " " (lambda ()
                        (interactive)
                        (company-abort)
                        (self-insert-command 1)))
  (define-key map (kbd "<return>") nil))

(defun ora-company-number ()
  "Forward to `company-complete-number'.

Unless the number is potentially part of the candidate.
In that case, insert the number."
  (interactive)
  (let* ((k (this-command-keys))
         (re (concat "^" company-prefix k)))
    (if (cl-find-if (lambda (s) (string-match re s))
                    company-candidates)
        (self-insert-command 1)
      (company-complete-number (string-to-number k)))))

(global-company-fuzzy-mode 1)
;; (setq company-fuzzy-sorting-backend 'flex)
(setq company-fuzzy-sorting-backend 'alphabetic)

(global-disable-mouse-mode)

(require 'autopair)
(autopair-global-mode)

(defun bigger-text ()
  (interactive)
  (text-scale-increase 2.5)
  )

(defun slightly-bigger-text ()
  (interactive)
  (text-scale-adjust 0)
  (text-scale-adjust 1.35)
  )

(defun smaller-text ()
  (interactive)
  (text-scale-decrease 2.5)
)

(defun minibuffer-text-size ()
  (setq-local  face-remapping-alist
               '((default :height 1.5))))

(defun echo-area-text-size()
;; https://www.emacswiki.org/emacs/EchoArea
  ;; Most strange.....
  (with-current-buffer (get-buffer " *Echo Area 0*")
    (setq-local face-remapping-alist
                '((default (:height 1.5 variable-pitch)))))
)

(add-hook 'find-file-hook 'bigger-text)
(add-hook 'minibuffer-setup-hook 'minibuffer-text-size)
(echo-area-text-size)

(wrap-region-mode t)
(beacon-mode)

(defun really-kill-emacs ()
  "Like `kill-emacs', but ignores `kill-emacs-hook'."
  (interactive)
  (let (kill-emacs-hook)
    (kill-emacs)))

;; save history
(savehist-mode 1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(setq savehist-file "~/.emacs.d/savehist")

;; use y/n for all yes-no answers
(defalias 'yes-or-no-p 'y-or-n-p)
;; less beeping
(setq-default visible-bell t)

;; control how Emacs backup files are handled
(setq
 backup-directory-alist '(("." . "~/.emacs.d/saves"))
 delete-old-versions t
 kept-new-versions 20
 kept-old-versions 10
 version-control t
 backup-by-copying t)

;; delete trailing whitespace before file is saved
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; columns
(column-number-mode 1)
(display-time)

;; use ibuffers for buffer listing
(defalias 'list-buffers 'ibuffer)
(setq ibuffer-default-sorting-mode 'major-mode)
(setq ibuffer-default-sorting-mode 'recency)
;; (add-hook 'ibuffer-mode-hook 'ibuffer-do-sort-by-recency)

;; Split windows horizontally by default
(setq split-width-threshold nil)

;; control how to move between windows
(windmove-default-keybindings 'meta)

(global-visual-line-mode t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

;; wrap lines at 80 columns
(setq-default fill-column 120)
(add-hook 'find-file-hook 'turn-on-auto-fill)

;; orderless
(require 'orderless)
(setq completion-styles '(orderless))

;; ivy
(ivy-mode 1)
(setq ivy-re-builders-alist '((t . orderless-ivy-re-builder)))
(setq ivy-display-style 'fancy)
(add-to-list 'ivy-highlight-functions-alist '(orderless-ivy-re-builder . orderless-ivy-highlight))

;;(ivy-historian-mode 1)

(counsel-mode 1)

;; (require 'ivy-posframe)
;; display at `ivy-posframe-style'
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-bottom-left)))
;; (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
;; (ivy-posframe-mode 1)

(ivy-explorer-mode 1)
(setq ivy-explorer-message-function 'ivy-explorer--lv-message)

(global-set-key "\C-s" 'swiper)
(global-set-key "\M-i" 'complete-symbol)

;; (require 'ivy-rich)
;; (ivy-rich-mode 1)
(setq ivy-format-function #'ivy-format-function-line)
(setq ivy-initial-inputs-alist nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))

;;;; desktop
;; Auto save desktop as well during buffer auto-save
(require 'desktop)
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")
(desktop-save-mode 1)
(add-hook 'auto-save-hook (lambda () (desktop-save-in-desktop-dir)))

;; enable paren highliting for all files
(add-hook 'find-file-hook (lambda()
                            (show-paren-mode t)))

;; display path to file in frame title
;(setq-default mode-line-format
(setq-default frame-title-format
              (list '((buffer-file-name " %f"
                (dired-directory
                dired-directory
                (revert-buffer-function " %b"
                                        ("%b - Dir:  " default-directory)))))))

;;;; utility functions
(defun dos2unix ()
  "Not exactly but it's easier to remember"
  (interactive)
  (set-buffer-file-coding-system 'unix 't))

(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (point-min)
                             (point-max)
                             "python -m json.tool"
                             (buffer-name) t)))

;; http://emacs.stackexchange.com/a/13122
(require 'ov)
(defun highlight-duplicate-lines-in-region-or-buffer ()
  (interactive)
  (ov-clear)
  (let* (
        ($beg (if mark-active (region-beginning) (point-min)))
        ($end (if mark-active (region-end) (point-max)))
        ($st (buffer-substring-no-properties $beg $end))
        ($lines)
        ($dup))
  (deactivate-mark t)
  (save-excursion
    (goto-char $beg)
    (while (< (point) $end)
      (let* (($b (point))
             ($e (point-at-eol))
             ($c (buffer-substring-no-properties $b $e))
             ($a (assoc $c $lines)))
        (when (not (eq $b $e))
          (if $a
              (progn
                (setq $dup (cons $b $dup))
                (setq $dup (cons (cdr $a) $dup)))
            (setq $lines
                  (cons (cons $c $b) $lines)))))
      (forward-line 1))
    (mapc (lambda ($p)
            (ov-set (ov-line $p) 'face '(:foreground "red")))
          (sort (delete-dups $dup) '<)))))

(defhydra hydra-dup-lines ()
  "Duplicate lines"
  ("h" highlight-duplicate-lines-in-region-or-buffer :color red)
  ("n" ov-goto-next :color red)
  ("p" ov-goto-previous :color red)
  ("c" ov-clear :color blue)
  ("q" nil :color blue)
  )

;; http://www.emacswiki.org/emacs-en/PosTip
(defun describe-function (function)
   "Display the full documentation of FUNCTION (a symbol) in tooltip."
   (interactive (list (function-called-at-point)))
   (if (null function)
       (pos-tip-show
        "** You didn't specify a function! **" '("red"))
     (pos-tip-show
      (with-temp-buffer
        (let ((standard-output (current-buffer)))
          (prin1 function)
          (princ " is ")
          (describe-function-1 function)
          (buffer-string)))
      nil nil nil 0)))

(defun count-string-matches (strn)
  "Return number of matches STRING following the point.
Continues until end of buffer.  Also display the count as a message."
  (interactive (list (read-string "Enter string: ")))
  (save-excursion
    (let ((count -1))
      (while
          (progn
            (setq count (1+ count))
            (search-forward strn nil t)))
      (message "%d matches" count)
      count)))

;; http://www.emacswiki.org/emacs/BasicNarrowing
(defun replace-regexp-in-region (start end)
  (interactive "*r")
  (save-excursion
    (save-restriction
      (let ((regexp (read-string "Regexp: "))
            (to-string (read-string "Replacement: ")))
        (narrow-to-region start end)
        (goto-char (point-min))
        (while (re-search-forward regexp nil t)
          (replace-match to-string nil nil))))))


;; https://www.emacswiki.org/emacs/ReBuilder
(defun reb-query-replace (to-string)
  "Replace current RE from point with `query-replace-regexp'."
  (interactive
   (progn
     (reb-quit)
     (barf-if-buffer-read-only)
     (list (query-replace-read-to (reb-target-binding reb-regexp)
                                  "Query replace"  t))))
  (with-current-buffer reb-target-buffer
    (query-replace-regexp (reb-target-binding reb-regexp) to-string)))

(defun reb-beginning-of-buffer ()
  "In re-builder, move target buffer point position back to beginning."
  (interactive)
  (set-window-point (get-buffer-window reb-target-buffer)
                    (with-current-buffer reb-target-buffer (point-min))))

(defun reb-end-of-buffer ()
  "In re-builder, move target buffer point position back to beginning."
  (interactive)
  (set-window-point (get-buffer-window reb-target-buffer)
                    (with-current-buffer reb-target-buffer (point-max))))


;; edit files as root
(defun sudo-find-file (file-name)
  (interactive "Find file (sudo): ")
  (find-file (concat "/sudo::" file-name)))

(defun delete-this-file ()
  (interactive)
  (or (buffer-file-name) (error "no file is currently being edited"))
  (when (yes-or-no-p "Really delete this file?")
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun djcb-duplicate-line (&optional commentfirst)
  "comment line at point; if COMMENTFIRST is non-nil, comment the original"
  (interactive)
  (beginning-of-line)
  (push-mark)
  (end-of-line)
  (let ((str (buffer-substring (region-beginning) (region-end))))
    (when commentfirst
      (comment-region (region-beginning) (region-end)))
    (insert
     (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
    (forward-line -1)))

;; http://tsdh.wordpress.com/2007/06/22/zapping-to-strings-and-regexps/
(defun th-zap-to-string (arg str)
  "Same as `zap-to-char' except that it zaps to the given string
instead of a char."
  (interactive "p\nsZap to string: ")
  (kill-region (point) (progn
                         (search-forward str nil nil arg)
                         (point))))

(defun th-zap-to-regexp (arg regexp)
  "Same as `zap-to-char' except that it zaps to the given regexp
instead of a char."
  (interactive "p\nsZap to regexp: ")
  (kill-region (point) (progn
                         (re-search-forward regexp nil nil arg)
                         (point))))

(defun replace-in-buffer ()
"Replace text in whole buffer. Change OLD string to NEW string"
  (interactive)
  (save-excursion
    (replace-string (read-string "OLD string:")
                    (read-string "NEW string:")
                    nil
                    (point-min)
                    (point-max))))

;; jump to matching parenthesis -- currently seems to support () and []
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis. Else go to the
   opening parenthesis one level up."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1))
        (t
         (backward-char 1)
         (cond ((looking-at "\\s\)")
                (forward-char 1) (backward-list 1))
               (t
                (while (not (looking-at "\\s("))
                  (backward-char 1)
                  (cond ((looking-at "\\s\)")
                         (message "->> )")
                         (forward-char 1)
                         (backward-list 1)
                         (backward-char 1)))
                  ))))))

(global-set-key (kbd "<C-f10>") 'goto-match-paren)

(require 'hungry-delete)
(global-hungry-delete-mode)


;; no tabs by default. modes that really need tabs should enable
;; indent-tabs-mode explicitly. makefile-mode already does that, for
;; example.
(setq-default indent-tabs-mode nil)

;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))
            nil ))


;; http://emacsredux.com/blog/2013/05/22/smarter-navigation-to-the-beginning-of-a-line/
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

(global-set-key (kbd "C-a") 'smarter-move-beginning-of-line)


;; http://emacsredux.com/blog/2013/06/15/open-line-above/
(defun smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(defun smart-open-line ()
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode."
  (interactive)
  (move-end-of-line nil)
  (newline-and-indent))

(defun kill-line-remove-blanks (&optional arg)
"Delete current line and remove blanks after it"
    (interactive "p")
    (kill-whole-line arg)
    (back-to-indentation))

(global-set-key [(control return)] 'smart-open-line)
(global-set-key [(control shift return)] 'smart-open-line-above)

;; DrewsLibraries from EmacsWiki
; crosshairs
(require 'crosshairs)
(global-set-key (kbd "<M-f12>") 'flash-crosshairs)
(crosshairs-toggle-when-idle t)


;; Indent HTML, XML
(defun jta-reformat-xml ()
  "Reformats xml to make it readable (respects current selection)."
  (interactive)
  (save-excursion
    (let ((beg (point-min))
          (end (point-max)))
      (if (and mark-active transient-mark-mode)
          (progn
            (setq beg (min (point) (mark)))
            (setq end (max (point) (mark))))
        (widen))
      (setq end (copy-marker end t))
      (goto-char beg)
      (while (re-search-forward ">\\s-*<" end t)
        (replace-match ">\n<" t t))
      (goto-char beg)
      (indent-region beg end nil))))

;; http://endlessparentheses.com/implementing-comment-line.html and
(defun endless/comment-line-or-region (n)
  "Comment or uncomment current line and leave point after it.
  With positive prefix, apply to N lines including current one.
  With negative prefix, apply to -N lines above.
  If region is active, apply to active region instead."
  (interactive "p")
  (if (use-region-p)
      (comment-or-uncomment-region
       (region-beginning) (region-end))
    (let ((range
           (list (line-beginning-position)
                 (goto-char (line-end-position n)))))
      (comment-or-uncomment-region
       (apply #'min range)
       (apply #'max range)))
    (forward-line 1)
    (back-to-indentation)))

(defun comment-and-next-line()
  (interactive)
  (comment-dwim-2)
  (next-line))

(global-set-key (kbd "M-;") #'comment-and-next-line)

(defun yank-n-times (n)
  "yank n number of times."
  (interactive "nPaste how many times? ")
  (setq last-kill (current-kill 0 t))
  (dotimes 'n (insert last-kill)))

(defun xah-select-current-line ()
  "Select current line.
URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2015-02-07
"
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))

(defun xah-append-to-register-1 ()
  "Append current line or text selection to register 1.
When no selection, append current line with newline char.
See also: `xah-paste-from-register-1', `copy-to-register'.

URL `http://ergoemacs.org/emacs/elisp_copy-paste_register_1.html'
Version 2015-12-08"
  (interactive)
  (let ($p1 $p2)
    (if (region-active-p)
        (progn (setq $p1 (region-beginning))
               (setq $p2 (region-end)))
      (progn (setq $p1 (line-beginning-position))
             (setq $p2 (line-end-position))))
    (append-to-register ?1 $p1 $p2)
    (with-temp-buffer (insert "\n")
                      (append-to-register ?1 (point-min) (point-max)))
    (message "Appended to register 1: 「%s」." (buffer-substring-no-properties
                                                $p1 $p2))))
(defun xah-paste-from-register-1 ()
  "Paste text from register 1.
See also: `xah-copy-to-register-1', `insert-register'.
URL `http://ergoemacs.org/emacs/elisp_copy-paste_register_1.html'
Version 2015-12-08"
  (interactive)
  (when (use-region-p)
    (delete-region (region-beginning) (region-end)))
  (insert-register ?1 t))

(defun xah-clear-register-1 ()
  "Clear register 1.
See also: `xah-paste-from-register-1', `copy-to-register'.

URL `http://ergoemacs.org/emacs/elisp_copy-paste_register_1.html'
Version 2015-12-08"
  (interactive)
  (progn
    (copy-to-register ?1 (point-min) (point-min))
    (message "Cleared register 1.")))

;;;; emacros
;; Emacros http://thbecker.net/free_software_utilities/emacs_lisp/emacros/emacros.html
(require 'emacros)
(setq emacros-global-dir "~/.emacs.d")
;; Load predefined macros
(add-hook 'after-init-hook 'emacros-load-macros)

;;;; Tramp
(require 'tramp)
(setq  tramp-completion-reread-directory-timeout 0)
(add-hook 'tramp-mode-hook
          #'(setq ag-executable "~/bin/ag"))

;; (setq tramp-verbose 10)
;; (setq tramp-debug-buffer t)
;; (require 'trace)
;;      (dolist (elt (all-completions "tramp-" obarray 'functionp))
;;        (trace-function-background (intern elt)))
;;      (untrace-function 'tramp-read-passwd)
;;      (untrace-function 'tramp-gw-basic-authentication)

;; clean up after Tramp
(add-hook 'kill-emacs-hook '(lambda nil
                              (tramp-cleanup-all-connections)
                              (tramp-cleanup-all-buffers) ))

(require 'exec-path-from-shell)
(exec-path-from-shell-copy-env "SSH_AGENT_PID")
(exec-path-from-shell-copy-env "SSH_AUTH_SOCK")
(exec-path-from-shell-copy-env "PATH")

;; Eshell
(defun eshell-new(shell-name)
  "Open a new instance of eshell."
  (interactive "seshell-name: ")
  (eshell 'N)
  (switch-to-buffer "*eshell*")
  (rename-buffer shell-name))

;;;; Setup some MS Windows specific stuff
(defun windows-crap ()
  (interactive)
  (when (window-system) 'w32
        (setq tramp-default-method "plink")
        (add-to-list 'tramp-remote-path "~/bin")

        (setq w32-pass-lwindow-to-system nil)
        (setq w32-lwindow-modifier 'super) ; Left Windows key

        (setq w32-pass-rwindow-to-system nil)
        (setq w32-rwindow-modifier 'super) ; Right Windows key

        (setq explicit-shell-file-name "c:/msys64/cygwin64/bin/bash.exe")
        (setq shell-file-name "bash.exe")
        (setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
        (setenv "SHELL" shell-file-name)
        (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

        ;; Make this behave the same was as on Mac OS X
        (global-set-key (kbd "s-s") 'save-buffer))
)

;;;; key-chord
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define emacs-lisp-mode-map "eb" 'eval-buffer)
(key-chord-define emacs-lisp-mode-map "ed" 'eval-defun)
(key-chord-define emacs-lisp-mode-map "er" 'eval-region)


;; buffer-flip
;; key to begin cycling buffers.  Global key.
(global-set-key (kbd "M-<tab>") 'buffer-flip)

;; transient keymap used once cycling starts
(setq buffer-flip-map
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "M-<tab>")   'buffer-flip-forward)
        (define-key map (kbd "M-S-<tab>") 'buffer-flip-backward)
        (define-key map (kbd "M-ESC")     'buffer-flip-abort)
        map))

;; buffers matching these patterns will be skipped
(setq buffer-flip-skip-patterns
      '("^\\*helm\\b"
        "^\\*swiper\\*$"
        "^shell-.*$"))

;; This only seems to work in GUIs
(when (display-graphic-p)
  ;;;; bm.el config
  (require 'bm)

  ;; reload bookmarks
  (setq bm-restore-repository-on-load t)

  ;; ask for annotation upon defining a bookmark
  (setq-default bm-annotate-on-create t)

  ;; bookmark indicator
  (setq bm-highlight-style 'bm-highlight-only-fringe)

  ;; make bookmarks persistent as default
  (setq-default bm-buffer-persistence t)

  ;; Loading the repository from file when on start up.
  (add-hook' after-init-hook 'bm-repository-load)

  ;; Restoring bookmarks when on file find.
  (add-hook 'find-file-hooks 'bm-buffer-restore)

  ;; Saving bookmark data on killing a buffer
  (add-hook 'kill-buffer-hook 'bm-buffer-save)

  ;; Restore on revert
  (add-hook 'after-revert-hook #'bm-buffer-restore)

  ;; Saving the repository to file when on exit.
  ;; kill-buffer-hook is not called when emacs is killed, so we
  ;; must save all bookmarks first.
  (add-hook 'kill-emacs-hook '(lambda nil
                                (bm-buffer-save-all)
                                (bm-repository-save)))

  (setq bm-marker 'bm-marker-right)

  (setq bm-highlight-style 'bm-highlight-line-and-fringe)

  (defhydra hydra-bookmarks ()
    "Bookmarks"
    ("<return>" bm-toggle "toggle" :color blue)
    ("<RETURN>" bm-toggle "toggle" :color blue)
    ("t" bm-toggle "toggle" :color blue)
    ("n" bm-next   "next"   :color red)
    ("p" bm-previous "previous" :color red)
    ("s" bm-show "show" :color blue)
    ("S" bm-show-all "SHOW" :color blue)
    ("c" bm-remove-all-current-buffer "clear" :color blue)
    ("l" bm-bookmark-line "line" :color blue)
    ("r" bm-bookmark-regexp "regex" :color blue)
    ("w" bm-save "save" :color blue)
    ("q" nil :color red)
    )

  (defun bm()
    (interactive)
    (hydra-bookmarks/body))
)

;; http://acidwords.com/posts/2017-10-19-closing-all-parentheses-at-once.html
(defun close-all-parentheses ()
  (interactive "*")
  (let ((closing nil))
    (save-excursion
      (while (condition-case nil
         (progn
           (backward-up-list)
           (let ((syntax (syntax-after (point))))
             (case (car syntax)
               ((4) (setq closing (cons (cdr syntax) closing)))
               ((7 8) (setq closing (cons (char-after (point)) closing)))))
           t)
           ((scan-error) nil))))
    (apply #'insert (nreverse closing))))



;;;; undo-tree
;; http://www.dr-qubit.org/emacs.php#undo-tree
;; hot damn.....
(require 'undo-tree)
(global-undo-tree-mode t)
(setq undo-tree-visualizer-relative-timestamps t)
(setq undo-tree-visualizer-timestamps t)

;; http://whattheemacsd.com/my-misc.el-02.html
;; Keep region when undoing in region
(defadvice undo-tree-undo (around keep-region activate)
  (if (use-region-p)
      (let ((m (set-marker (make-marker) (mark)))
            (p (set-marker (make-marker) (point))))
        ad-do-it
        (goto-char p)
        (set-mark m)
        (set-marker p nil)
        (set-marker m nil))
    ad-do-it))

;;;; iedit
(require 'iedit)
;; http://www.masteringemacs.org/articles/2012/10/02/iedit-interactive-multi-occurrence-editing-in-your-buffer/
(defun iedit-defun (arg)
  "Starts iedit but uses \\[narrow-to-defun] to limit its scope."
  (interactive "P")
  (if arg
      (iedit-mode)
    (save-excursion
      (save-restriction
        (widen)
        ;; this function determines the scope of `iedit-start'.
        (narrow-to-defun)
        (if iedit-mode
            (iedit-done)
          ;; `current-word' can of course be replaced by other
          ;; functions.
          (iedit-start (current-word)))))))


;;https://emacs.stackexchange.com/questions/2146/how-to-open-and-rename-several-multi-term-buffers-on-start-up
(require 'multi-term)
(defun init-multi-term (new-name)
  (let ((mt-buffer-name "*terminal<1>*"))
    (multi-term)
    (with-current-buffer mt-buffer-name
      (rename-buffer new-name))))

(defun sv-mt (shell-name)
  (interactive "sshell-name: ")
  (init-multi-term shell-name))

;; https://emacs.stackexchange.com/questions/37904/how-do-i-work-out-what-the-problem-is-with-the-emacs-package-system/56067#56067
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-max-one-liner-length 120)
 '(custom-safe-themes
   '("00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "443e2c3c4dd44510f0ea8247b438e834188dc1c6fb80785d83ad3628eadf9294" "3e200d49451ec4b8baa068c989e7fba2a97646091fd555eca0ee5a1386d56077" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "f5b6be56c9de9fd8bdd42e0c05fecb002dedb8f48a5f00e769370e4517dde0e8" "b290c815faa375c1e84973e8c71309459d84e33ad51ded96667f6b62027d8ce8" "351473429145eddc87779a0d9700261073fe480c1e4e35b066a01d6a10c0eedb" "9549755e996a2398585714b0af745d2be5387ecf7ec299ff355ec6bef495be88" "33ea268218b70aa106ba51a85fe976bfae9cf6931b18ceaf57159c558bbcd1e6" "171d1ae90e46978eb9c342be6658d937a83aaa45997b1d7af7657546cae5985b" "f00a605fb19cb258ad7e0d99c007f226f24d767d01bf31f3828ce6688cbdeb22" "3c7a784b90f7abebb213869a21e84da462c26a1fda7e5bd0ffebf6ba12dbd041" "733ef3e3ffcca378df65a5b28db91bf1eeb37b04d769eda28c85980a6df5fa37" "d516f1e3e5504c26b1123caa311476dc66d26d379539d12f9f4ed51f10629df3" "e266d44fa3b75406394b979a3addc9b7f202348099cfde69e74ee6432f781336" "076ee9f2c64746aac7994b697eb7dbde23ac22988d41ef31b714fc6478fee224" "2b502f6e3bf0cba42fe7bf83a000f2d358a7020a7780a8682fcfed0c9dbffb5f" "7922b14d8971cce37ddb5e487dbc18da5444c47f766178e5a4e72f90437c0711" "6128465c3d56c2630732d98a3d1c2438c76a2f296f3c795ebda534d62bb8a0e3" "11cc65061e0a5410d6489af42f1d0f0478dbd181a9660f81a692ddc5f948bf34" "06ed754b259cb54c30c658502f843937ff19f8b53597ac28577ec33bb084fa52" "a4395e069de3314001de4e139d6a3b1a83dcf9c3fdc68ee7b13eef6c2cba4ae3" "d9a28a009cda74d1d53b1fbd050f31af7a1a105aa2d53738e9aa2515908cac4c" "73320ccc14ab4987fe2e97cfd810b33a1f4a115f5f056c482c3d38a4429e1705" "620b9018d9504f79344c8ef3983ea4e83d209b46920f425240889d582be35881" "0c6a36393d5782839b88e4bf932f20155cb4321242ce75dc587b4f564cb63d90" "4e9e56ec06ede9857c876fea2c44b75dd360cd29a7fe927b706c45f804f7beff" "c9415c9f5a5ed67914d1d64a0ea7d743ef93516f1f2c8501bc5ffb87af2066d3" "7236acec527d58086ad2f1be6a904facc9ca8bf81ed1c19098012d596201b3f1" "afd761c9b0f52ac19764b99d7a4d871fc329f7392dfc6cd29710e8209c691477" "d4f8fcc20d4b44bf5796196dbeabec42078c2ddb16dcb6ec145a1c610e0842f3" "9e39a8334e0e476157bfdb8e42e1cea43fad02c9ec7c0dbd5498cf02b9adeaf1" "6a0d7f41968908e25b2f56fa7b4d188e3fc9a158c39ef680b349dccffc42d1c8" "bb28b083fe1c61848c10c049be076afc572ea9bee6e1f8dc2631c5ee4f7388c8" "7e5d400035eea68343be6830f3de7b8ce5e75f7ac7b8337b5df492d023ee8483" "fc0fe24e7f3d48ac9cf1f87b8657c6d7a5dd203d5dabd2f12f549026b4c67446" "8ce796252a78d1a69e008c39d7b84a9545022b64609caac98dc7980d76ae34e3" "9f9450547564423166a7d2de976c9ca712293170415ec78ed98d198748b44a90" "67ea2e2549ab1ba9b27a4fc3c78353225d6fd155a69292dc6f7d3286bd8d3a82" "3a78cae35163bb71df460ebcfdebf811fd7bc74eaa15428c7e0bccfd4f858d30" "df01ad8d956b9ea15ca75adbb012f99d2470f33c7b383a8be65697239086672e" "d04406d092bf8c6b0859a2b83f72db6c6444519a7f1f24199d1ca495393f477b" "53993d7dc1db7619da530eb121aaae11c57eaf2a2d6476df4652e6f0bd1df740" "f7b0f2d0f37846ef75157f5c8c159e6d610c3efcc507cbddec789c02e165c121" "2f945b8cbfdd750aeb82c8afb3753ebf76a1c30c2b368d9d1f13ca3cc674c7bc" "ed573618e4c25fa441f12cbbb786fb56d918f216ae4a895ca1c74f34a19cfe67" "b69323309e5839676409607f91c69da2bf913914321c995f63960c3887224848" "43b219a31db8fddfdc8fdbfdbd97e3d64c09c1c9fdd5dff83f3ffc2ddb8f0ba0" "a7928e99b48819aac3203355cbffac9b825df50d2b3347ceeec1e7f6b592c647" "054e929c1df4293dd68f99effc595f5f7eb64ff3c064c4cfaad186cd450796db" "58c2c8cc4473c5973e77f4b78a68c0978e68f1ddeb7a1eb34456fce8450be497" "0eb3c0868ff890b0c4ee138069ce2a8936a8a69ba150efa6bfb9fb7c05af5ec3" "f47f2c6b2052c81ecf8f2da64f481a92b53a3fd17680b054ea9b81c916dee4b9" "9b21a3576c9f2206be84863e24edc5384ac382d1292c6c998131dbc586ef7acc" "a9d67f7c030b3fa6e58e4580438759942185951e9438dd45f2c668c8d7ab2caf" "51043b04c31d7a62ae10466da95a37725638310a38c471cc2e9772891146ee52" "53760e1863395dedf3823564cbd2356e9345e6c74458dcc8ba171c039c7144ed" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "886fe9a7e4f5194f1c9b1438955a9776ff849f9e2f2bbb4fa7ed8879cdca0631" "2642a1b7f53b9bb34c7f1e032d2098c852811ec2881eec2dc8cc07be004e45a0" "ff829b1ac22bbb7cee5274391bc5c9b3ddb478e0ca0b94d97e23e8ae1a3f0c3e" "fa477d10f10aa808a2d8165a4f7e6cee1ab7f902b6853fbee911a9e27cf346bc" "11e0bc5e71825b88527e973b80a84483a2cfa1568592230a32aedac2a32426c1" "ef07cb337554ffebfccff8052827c4a9d55dc2d0bc7f08804470451385d41c5c" "6bc387a588201caf31151205e4e468f382ecc0b888bac98b2b525006f7cb3307" "7803ff416cf090613afd3b4c3de362e64063603522d4974bcae8cfa53cf1fd1b" "542e6fee85eea8e47243a5647358c344111aa9c04510394720a3108803c8ddd1" "669e02142a56f63861288cc585bee81643ded48a19e36bfdf02b66d745bcc626" "562c2a97808ab67d71c02d50f951231e4a6505f4014a01d82f8d88f5008bbe88" "bf5bdab33a008333648512df0d2b9d9710bdfba12f6a768c7d2c438e1092b633" "030346c2470ddfdaca479610c56a9c2aa3e93d5de3a9696f335fd46417d8d3e4" "571a762840562ec5b31b6a9d4b45cfb1156ce52339e188a8b66749ed9b3b22a2" "bd0c3e37c53f6515b5f5532bdae38aa0432a032171b415159d5945a162bc5aaa" "97b8bf2dacc3ae8ffbd6f0a76c606a659a0dbca5243e55a750cbccdad7efb098" "e396098fd5bef4f0dd6cedd01ea48df1ecb0554d8be0d8a924fb1d926f02f90f" "acfac6b14461a344f97fad30e2362c26a3fe56a9f095653832d8fc029cb9d05c" "37c5cf50a60548aa7e01dbe36fd8bb643af7502d55d26f000070255a6b21c528" "8ba0a9fc75f2e3b4c254183e814b8b7b8bcb1ad6ca049fde50e338e1c61a12a0" "59e82a683db7129c0142b4b5a35dbbeaf8e01a4b81588f8c163bd255b76f4d21" "2f524d307a2df470825718e27b8e3b81c0112dad112ad126805c043d7c1305c6" "5cdc1832748ae451c19a1546a4bc200750557a924f6124428272f114b6d28ac1" "a9ab62408cda1e1758d913734527a8fdbe6f22e1c06a104375456107063aff9c" "45a8b89e995faa5c69aa79920acff5d7cb14978fbf140cdd53621b09d782edcf" "fc65950aacea13c96940a2065ef9b8faefe7a4da44331adf22ea46f8c9b34cdd" "a0befffb88a6ef016010ee95e4799648f5aa6f0ab92cedb37868b97e45f85a13" "be327a6a477b07f76081480fb93a61fffaa8ddc2acc18030e725da75342b2c2e" "058b8c7effa451e6c4e54eb883fe528268467d29259b2c0dc2fd9e839be9c92e" "9a3366202553fb2d2ad1a8fa3ac82175c4ec0ab1f49788dc7cfecadbcf1d6a81" "78cb079a46e0b94774ed0cdc9bd2cde0f65a0b964541c221e10a7709e298e568" "d2868794b5951d57fb30bf223a7e46f3a18bf7124a1c288a87bd5701b53d775a" "3cacf6217f589af35dc19fe0248e822f0780dfed3f499e00a7ca246b12d4ed81" "f730a5e82e7eda7583c6526662fb7f1b969b60b4c823931b07eb4dd8f59670e3" "f6c0353ac9dac7fdcaced3574869230ea7476ff1291ba8ed62f9f9be780de128" "e4cbf084ecc5b7d80046591607f321dd655ec1bbb2dbfbb59c913623bf89aa98" default))
 '(elpy-syntax-check-command "/Users/sawanvithlani/.emacs.d/elpy/rpc-venv/bin/flake8")
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(origami-parser-alist
   '((java-mode . origami-java-parser)
     (c-mode . origami-c-parser)
     (c++-mode . origami-c-style-parser)
     (perl-mode . origami-c-style-parser)
     (cperl-mode . origami-c-style-parser)
     (js-mode . origami-c-style-parser)
     (js2-mode . origami-c-style-parser)
     (js3-mode . origami-c-style-parser)
     (go-mode . origami-c-style-parser)
     (php-mode . origami-c-style-parser)
     (python-mode . origami-parser-imenu-flat)
     (emacs-lisp-mode . origami-elisp-parser)
     (lisp-interaction-mode . origami-elisp-parser)
     (clojure-mode . origami-clj-parser)
     (triple-braces closure
                    ((regex . "\\(?:\\(?:{{{\\|}}}\\)\\)")
                     (end-marker . "}}}")
                     (start-marker . "{{{")
                     t)
                    (create)
                    #'(lambda
                        (content)
                        (let
                            ((positions
                              (origami-get-positions content regex)))
                          (origami-build-pair-tree create start-marker end-marker positions))))))
 '(package-selected-packages
   '(solarized-theme nano-theme quelpa-use-package use-package-hydra quelpa treemacs treemacs-all-the-icons treemacs-magit treemacs-tab-bar neotree doom-themes ivy-explorer flx-ido affe consult python-isort marginalia modus-themes orderless filetree buffer-expose all-the-icons-ivy-rich distinguished-theme material-theme shift-number ivy-posframe ivy-avy ivy-historian ivy-hydra sql-indent deft vue-mode vscode-dark-plus-theme all-the-icons-ibuffer anti-zenburn-theme berrys-theme cherry-blossom-theme espresso-theme jazz-theme slime slime-company brutalist-theme farmhouse-theme multi-term dumb-jump abyss-theme company-fuzzy disable-mouse exec-path-from-shell all-the-icons-ivy major-mode-hydra pretty-hydra monky frog-jump-buffer pinboard realgud realgud-ipdb buffer-flip string-inflection open-junk-file auto-highlight-symbol flucui-themes ivy-rich company-prescient ivy-prescient cyberpunk-2019-theme symbol-overlay ace-isearch ace-jump-buffer ample-theme atom-dark-theme atom-one-dark-theme blackboard-theme bubbleberry-theme calfw color-identifiers-mode company-nginx company-shell cyberpunk-theme danneskjold-theme defrepeater emacs-xkcd fancy-narrow fasd flash-region gandalf-theme gotham-theme nova-theme overcast-theme reykjavik-theme rimero-theme snazzy-theme tommyh-theme yaml-imenu comment-dwim-2 rg ace-window smex company-jedi avy-zap avy yaml-mode wrap-region visual-regexp-steroids undo-tree rainbow-mode rainbow-delimiters pos-tip paredit paradox ov origami multiple-cursors move-text magit macrostep key-chord kaolin-themes jedi iedit hungry-delete fastnav expand-region elpy csv-mode color-moccur browse-kill-ring boxquote bm beacon autopair))
 '(paradox-github-token t))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.sls$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.prod$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.model$" . yaml-mode))
(add-hook 'yaml-mode-hook '(lambda ()
                             (define-key yaml-mode-map
                               (kbd "RET") 'newline-and-indent)))

(elpy-enable)

(define-key elpy-mode-map (kbd "C-M-i") 'elpy-company-backend)
(define-key elpy-mode-map (kbd "M-k") 'counsel-company)


(defun python-add-debug-highlight ()
  "Adds a highlighter for use by `python-pdb-breakpoint-string'"
  (highlight-lines-matching-regexp "## DEBUG ##\\s-*$" 'hi-red-b))

(add-hook 'python-mode-hook 'python-add-debug-highlight)

(defvar python-pdb-breakpoint-string
  ;;"from pudb import set_trace;set_trace() ## DEBUG ##"
  "import ipdb,pprint;\
pp=pprint.PrettyPrinter(width=2,indent=2).pprint;\
ipdb.set_trace(); ## DEBUG ##"
  "Python breakpoint string used by `python-insert-breakpoint'")

(defun python-insert-breakpoint ()
  "Inserts a python breakpoint using `ipdb'"
  (interactive)
  ;; this preserves the correct indentation in case the line above
  ;; point is a nested block
  (insert python-pdb-breakpoint-string)
  (back-to-indentation)
)

(defun python-remove-debug-breaks ()
   "Removes all debug breakpoints"
   (flush-lines "\#\# DEBUG \#\#")
   (flush-lines "import ipdb")
   (flush-lines "pp = pprint")
   (flush-lines "ipdb.set"))

(defun ipdb ()
  (interactive)
  (save-excursion
  (python-insert-string python-pdb-breakpoint-string)))

(defun ripdb()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (python-remove-debug-breaks)))

(defun python-insert-string(in-string)
  "Inserts string"
  (interactive)
  (back-to-indentation)
  (split-line)
  (insert in-string)
  (python-indent-line)
  (backward-char 3))


(add-hook 'python-mode-hook 'python-remove-debug-breaks)


(defhydra hydra-breadcrumb ()
  "Breadcrumb"
  ("s" bc-set :color blue)
  ("n" bc-next :color red)
  ("p" bc-previous :color red)
  ("c" bc-clear :color red)
  ("l" bc-list :color blue)
  ("q" nil :color red)
  )


(defhydra hydra-avy (:post (forward-char))
  "Avy"
  ("l" avy-goto-line "line" :color blue)
  ("j" avy-goto-char-in-line :color blue)
  ("k" avy-goto-char   "char" :color blue)
  ("c" avy-goto-char-2 "char-2" :color blue)
  ("s" swiper "swiper" :color blue)
  ("p" sprint-forward "sprint-f" :color blue)
  ("P" sprint-backward "sprint-b ":color blue)
  ("W" avy-goto-word-1 "word-1" :color blue)
  ("w" avy-goto-word-0 "word-0" :color blue)
  ("z" avy-zap-to-char "Z" :color blue)

  ("n" next-line "n" :color red)
  ("p" previous-line "p" :color red)

  ("<return>" nil "quit" :color blue)
  ("<RETURN>" nil "quit" :color blue)
  ("<ESC>" nil "quit" :color blue)
  ("q" nil "quit")
  )

(global-set-key (kbd "<f1>") 'hydra-avy/body)

(defun mark-and-hydra()
  (interactive)
  (call-interactively 'set-mark-command)
  (hydra-avy/body))

(global-set-key (kbd "C-SPC") 'mark-and-hydra)


(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(global-set-key (kbd "C-x g") 'magit-status)

(defhydra hydra-er()
  "Expand Region"
  ("w" er/mark-word "word" :color red)
  ("s" er/mark-symbol "symbol" :color red)
  ("m" er/mark-method-call "method-call" :color red)
  ("q" er/mark-inside-quotes "i-quotes" :color red)
  ("p" er/mark-inside-pairs "i-pairs" :color red)
  ("P" er/mark-outside-pairs "o-pairs" :color red)
  ("f" er/mark-defun "function" :color red)
  ("l" thing-copy-line "line" :color blue)
  ("c" copy-region-as-kill "copy-region" :color blue)
  ("<return>" nil))

(defun h-er()
  (interactive)
  (hydra-er/body))

(defhydra hydra-text-commands ()
  "Text commands"

  ("C" avy-kill-ring-save-region "copy-region->KR" :color blue)
  ("c" avy-copy-region "copy-region" :color blue)
  ("w" thing-copy-word "copy-word" :color blue)
  ("l" thing-copy-line "copy-line"  :color blue)
  ("s" thing-copy-symbol "copy-symbol" :color blue)

  ("y" yank-n-times "multiple paste" :color blue )
  ("e" hydra-er/body "expand-region" :color blue)

  ("M" avy-move-region "move-region" :color blue)
  ("k" avy-kill-region "kill-region" :color blue)
  ("u" move-text-up "move-up" :color red)
  ("d" move-text-down "move-down" :color red)

  ("q" nil "quit"))

(global-set-key (kbd "<f2>") 'hydra-text-commands/body)


(defhydra hydra-lines ()
  "Lines"

  ("c" avy-copy-line "avy-copy-line" :color blue)
  ("l" thing-copy-line "copy-l" :color blue)
  ("r" avy-kill-ring-save-whole-line "copy->kr" :color blue)
  ("m" avy-move-line "move" :color blue)
  ("k" avy-kill-whole-line "kill" :color blue)

  ("e" thing-copy-to-line-end "copy-e" :color blue)
  ("b" thing-copy-to-line-beginning "copy-b" :color blue)

  ("D" djcb-duplicate-line "dup" :color red)
  ("C" thing-copy-line "dup" :color red)

  ("g" avy-goto-line "goto" :color red)

  ("C" xah-clear-register-1 "clear-r-1" :color red)
  ("s" xah-select-current-line "select" :color red)
  ("a" xah-append-to-register-1 "accumulate" :color red)
  ("i" xah-paste-from-register-1 "paste-r-1" :color blue)

  ("n" forward-line "forward")
  ("p" previous-line "backwards")
  ("u" move-text-up "move-up" :color red)
  ("d" move-text-down "move-down" :color red)

  ("h" highlight-duplicate-lines-in-region-or-buffer "dup-line" :color red)
  ("o" ov-clear "ov-clear")

  ("q" nil "quit")
  ("<return>" nil "quit" :color blue)
  ("<RETURN>" nil "quit" :color blue)
  ("<ESC>" nil "quit" :color blue)
)

(global-set-key (kbd "<f4>") 'hydra-lines/body)

(require 'highlight-symbol)
(defhydra hydra-highlight-symbol ()
  "Highlight symbol"
  ("h" highlight-symbol-at-point "highlight-toggle" :color red)
  ("n" highlight-symbol-next "next" :color red)
  ("p" highlight-symbol-prev "previous" :color red)
  ("r" highlight-symbol-remove-all "remove-all ":color blue)
  ("q" nil "quit"))

(global-set-key (kbd "<f3>") 'hydra-highlight-symbol/body)

;; https://www.reddit.com/r/emacs/comments/b1trp7/hydra_showcase_anyone/eiost6m?utm_source=share&utm_medium=web2x
(defhydra hydra-symbol-overlay (:color pink :hint nil :timeout 5)
      "
  _p_   ^^   _b_  back         _h_  highlight  _i_  isearch
_<_   _>_    _d_  definition   _R_  remove     _Q_  query-replace
  _n_   ^^   _w_  save         ^^              _r_  rename
"
      ("<"      symbol-overlay-jump-first)
      (">"      symbol-overlay-jump-last)
      ("p"      symbol-overlay-jump-prev)
      ("n"      symbol-overlay-jump-next)

      ("d"      symbol-overlay-jump-to-definition)
      ("b"      symbol-overlay-echo-mark)

      ("h" symbol-overlay-put :color blue)
      ("R" symbol-overlay-remove-all :color blue)

      ("w" symbol-overlay-save-symbol :color blue)
      ("t" symbol-overlay-toggle-in-scope)

      ("i" symbol-overlay-isearch-literally :color blue)
      ("Q" symbol-overlay-query-replace :color blue)
      ("r" symbol-overlay-rename  :color blue)
      ("q" nil))

;; https://www.masteringemacs.org/article/searching-buffers-occur-mode
(defun get-buffers-matching-mode (mode)
  "Returns a list of buffers where their major-mode is equal to MODE"
  (let ((buffer-mode-matches '()))
   (dolist (buf (buffer-list))
     (with-current-buffer buf
       (if (eq mode major-mode)
           (add-to-list 'buffer-mode-matches buf))))
   buffer-mode-matches))

(defun multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with this major mode."
  (interactive)
  (multi-occur
   (get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))

;; occur
;; http://oremacs.com/2015/01/26/occur-dwim/
(defun multi-occur-all-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))

(defun sane-occurs (occur-fn)
  "Call various `occur' with a sane default."
  (interactive)
  (push (if (region-active-p)
            (buffer-substring-no-properties
             (region-beginning)
             (region-end))
          (let ((sym (thing-at-point 'symbol)))
            (when (stringp sym)
              (regexp-quote sym))))
        regexp-history)
  (call-interactively occur-fn))

(defun occur-dwim ()
  (interactive)
  (sane-occurs 'occur))

(defun multi-occur-dwim ()
  (interactive)
  (sane-occurs 'multi-occur))

(defun multi-occur-in-mode-dwim ()
  (interactive)
  (sane-occurs 'multi-occur-in-this-mode))

(defun multi-occur-all-dwim ()
  (interactive)
  (sane-occurs 'multi-occur-all-buffers))

(add-hook 'occur-hook (lambda () (other-window 1)))

;; Keeps focus on *Occur* window, even when when target is visited via RETURN key.
;; See hydra-occur-dwim for more options.
(defadvice occur-mode-goto-occurrence (after
                                        occur-mode-goto-occurrence-advice
                                        activate)
  (other-window 1)
  (next-error-follow-minor-mode t)
  (hydra-occur-dwim/body))

(defadvice occur-edit-mode-finish (after occur-cease-edit-advice activate)
  (save-some-buffers))

(defun reattach-occur ()
  (if (get-buffer "*Occur*")
    (switch-to-buffer-other-window "*Occur*")
    (hydra-occur-dwim/body) ))

;; Used in conjunction with advice occur-mode-goto-occurrence this helps keep
;; focus on the *Occur* window and hides upon request in case needed later.
(defhydra hydra-occur-dwim ()
  "Occur mode"
  ("s" swiper-all "swiper-all" :color blue)
  ("o" occur-dwim "occur-dwim" :color red)
  ("m" multi-occur-dwim "multi-occur-dwim" :color red)
  ("a" multi-occur-all-dwim "multi-occur-all-dwin" :color red)
  ("M" multi-occur-in-mode-dwim "Mode multi-occur" :color red)
  ("n" occur-next "Next" :color red)
  ("p" occur-prev "Prev":color red)
  ("h" delete-window "Hide" :color blue)
  ("r" (reattach-occur) "Re-attach" :color red)
  ("q" delete-window "quit" :color blue))

(global-set-key (kbd "C-x o") 'hydra-occur-dwim/body)

;; https://github.com/abo-abo/hydra/wiki/Switch-to-buffer
(defun my/name-of-buffers (n)
  "Return the names of the first N buffers from `buffer-list'."
  (let ((bns
         (delq nil
               (mapcar
                (lambda (b)
                  (unless (string-match "^ \\|shell\-" (setq b (buffer-name b)))
                    b))
                (buffer-list)))))
    (subseq bns 1 (min (1+ n) (length bns)))))

;; Given ("a", "b", "c"), return "1. a, 2. b, 3. c".
(defun my/number-names (list)
  "Enumerate and concatenate LIST."
  (let ((i 0))
    (mapconcat
     (lambda (x)
       (format "%d. %s" (cl-incf i) x))
     list ", ")))

(defvar my/last-buffers nil)

(defun my/switch-to-buffer (arg)
  (interactive "p")
  (switch-to-buffer
   (nth (1- arg) my/last-buffers)))

(defun my/switch-to-buffer-other-window (arg)
  (interactive "p")
  (switch-to-buffer-other-window
   (nth (1- arg) my/last-buffers)))


(defhydra my/switch-to-buffer (:exit t
                               :body-pre (setq my/last-buffers
                               (my/name-of-buffers 5)))
"
Other buffers: %s(my/number-names my/last-buffers)
"
   ("<return>" (my/switch-to-buffer 0))
   ("<RETURN>" (my/switch-to-buffer 0))
   ("1" (my/switch-to-buffer 1))
   ("2" (my/switch-to-buffer 2))
   ("3" (my/switch-to-buffer 3))
   ("4" (my/switch-to-buffer 4))
   ("5" (my/switch-to-buffer 5))
   ("i" (counsel-ibuffer) "iBuffer")
   ("f" (find-file-at-point) "Find file")
   ("b" (counsel-switch-buffer) "Swi-buffer")
   ("B" (ibuffer) "I-buffer")
   ("o" ace-window "o-window")
   ("d" delete-other-windows "d-o-window")
   ("q" nil)
   )

(global-set-key (kbd "C-x b") 'my/switch-to-buffer/body)
(global-set-key (kbd "C-x C-b") 'my/switch-to-buffer/body)

;;;; fastnav
(require 'fastnav)
(defhydra hydra-fastnav ()
  "FastNav on chars"
  ("m" mark-to-char-forward "Mark forward" :color blue)
  ("M" mark-to-char-backward "Mark back" :color blue)
  ("r" replace-char-forward "Replace forward" :color blue)
  ("R" replace-char-backward "Replace back" :color blue)
  ("d" delete-char-forward "Delete forward" :color blue)
  ("D" delete-char-backward "Delete back" :color blue)
  ("i" insert-at-char-forward "Insert forward" :color blue)
  ("I" insert-at-char-backward "Insert back" :color blue)
  ("z" zap-up-to-char-forward "Zap up-to forward" :color blue)
  ("Z" zap-up-to-char-backward "Zap up-to backwards" :color blue)
  ("e" execute-at-char-forward "Execute forward" :color blue)
  ("E" execute-at-char-backward "Execute backwards" :color blue)
  ("s" th-zap-to-string "Zap to string" :color blue)
  ("p" th-zap-to-regexp "Zap to reg-exp" :color blue)
  ("q" nil "quit"))

(global-set-key (kbd "<f5>") 'hydra-fastnav/body)

(defun move-and-hydra(fn)
  (funcall fn 1)
  (hydra-move/body))

(defun hydra-move-post()
  (set-cursor-color "#ffffff"))

(setq hydra-hint-display-type 'posframe)
(setq hydra-hint-display-type 'lv)

;;; hmove

;; " ' insert.
;; . jump  to definition
;; copy line
;; switch to buffer
;; hydra poppin -- hydra-er, hydra-bm, hydra-buffer

(pretty-hydra-define hydra-move
  (:timeout 10
            :body-pre (set-cursor-color "#5BFF33")
            :post (hydra-move-post)
            :foreign-keys warn)

  ("Lines" (
            ("2" set-mark-command "Mark")
            ("3" copy-region-as-kill "Copy Region")
            ("4" up-n-lines )
            ("5" down-n-lines )
            ("a" smarter-move-beginning-of-line)
            ("e" move-end-of-line)
            ("n" next-line)
            ("p" previous-line)
            ("P" djcb-duplicate-line)
            ("C" thing-copy-line)
            ("g" avy-goto-line "goto-line")
            ("G" goto-line "goto-line-num")
            ("L" kill-whole-line)
            ("K" kill-visual-line)
            ("x" transpose-lines))

   "Avy" (
          ("o" avy-goto-char-in-line "goto-char-in-line" :blue)
          ("c" avy-goto-char-2 "goto-char-2")
          ("w" avy-goto-word-or-subword-1 "goto-word")
          ("6" avy-zap-to-char "zap-to-c")
          ("7" avy-zap-up-to-char "zap-up-to-c")
          ("y" yank "Paste" ))


   "Char-Word" (
                ("k" forward-char)
                ("f" forward-char)
                ("j" backward-char)
                ("l" forward-word)
                ("h" backward-word)
                ("D" kill-word)
                ("d" hungry-delete-forward)
                ("b" hungry-delete-backward)
                ("B" backward-kill-word)
                ("C-t" transpose-chars))

   "Buffer" (
             ("m" scroll-up-command)
             ("u" scroll-down-command)
             ("t" beginning-of-buffer)
             ("T" end-of-buffer)
             ("r" recenter-top-bottom "re-center")
             ("0" ace-window "ace-windows")
             ("9" my/switch-to-buffer/body "hydra-buffers" :exit t))
             ;; ("8" buffer-flip-forward "b-flip-f" )
             ;; ("7" buffer-flip-backward "b-flip-b" )
             ;; ("6" buffer-flip-abort "b-flip-abort" ))

   "Region" (
             ("v" eval-region :color blue)
             )

   "Extra" (
            ("." xref-find-definitions "goto")
            ("C-." pop-tag-mark "pop")
            ("s" save-buffer   "save")
            ("i" counsel-imenu "iM" )
            ("/" undo-tree-undo "undo")
            (";" comment-and-next-line "comment")
            (">" py-indent-right-and-next-line "i >")
            ("<" py-indent-left-and-next-line "i <")
            ("<tab>" indent-for-tab-command)
            ("z" bm-toggle "Bookmark")
            ("N" bm-next "Next Bookmark")
            ("R" hydra-er/body "hydra-eR" :exit t)
            ("E" elpy-black-fix-code "Black" :color red)
            ("Q" query-replace "Qrepl" :exit t)
            ("Y" counsel-yank-pop "Yank-pop" :color red))

   "Q" (
        ("<return>" newline-and-indent "quit" :color red)
        ("<RETURN>" newline-and-indent "quit" :color red)
        ("<ESC>" nil "quit" :color blue)
        ("=" nil "quit" :color blue)
        ("-" nil "quit" :color blue)
        ("q" nil "quit" :color blue)
        ("<SPC>" (insert " ") "quit" :color blue)
        ("," (insert ",") "," :color red)
        ("<backspace>" delete-backward-char "quit" :color blue))

   )
   )

;; http://whattheemacsd.com/key-bindings.el-02.html
;; Move more quickly
(defun down-n-lines ()
                  (interactive)
                  (ignore-errors (next-line 5)))

(defun up-n-lines ()
                  (interactive)
                  (ignore-errors (previous-line 5)))

;; (global-set-key (kbd "C-S-f")
                ;; (lambda ()
                  ;; (interactive)
                  ;; (ignore-errors (forward-char 10))))
;;
;; (global-set-key (kbd "C-S-b")
                ;; (lambda ()
                  ;; (interactive)
                  ;; (ignore-errors (backward-char 10))))
;;

(defun py-indent-right-and-next-line()
  (interactive "")
  (elpy-nav-indent-shift-right)
  (next-line 1))


(defun py-indent-left-and-next-line()
  (interactive "")
  (elpy-nav-indent-shift-left)
  (next-line 1))

(defun next-line-and-avy (n)
  (next-line n)
  (unless mark-active
    (avy-goto-line)))

(defun previous-line-and-avy (n)
  (previous-line n)
  (unless mark-active
    (avy-goto-line)))

(defun hydra-move-keys()
  (interactive)
  (global-set-key (kbd "C-n") (lambda() (interactive)
                                (move-and-hydra #'next-line)))
  (global-set-key (kbd "C-p") (lambda() (interactive)
                                (move-and-hydra #'previous-line)))
  (global-set-key (kbd "C-f") (lambda() (interactive)
                                (move-and-hydra #'forward-char)))
  (global-set-key (kbd "C-b") (lambda() (interactive)
                                (move-and-hydra #'backward-char)))
  (global-set-key (kbd "M-f") (lambda() (interactive)
                                (move-and-hydra #'forward-word)))
  (global-set-key (kbd "M-b") (lambda() (interactive)
                                (move-and-hydra #'backward-word))))

(defun hydra-move-no-keys()
  (interactive)
  (global-set-key (kbd "C-n") #'next-line)
  (global-set-key (kbd "C-p") #'previous-line)
  (global-set-key (kbd "C-f") #'forward-char)
  (global-set-key (kbd "C-b") #'backward-char)
  (global-set-key (kbd "M-f") #'forward-word)
  (global-set-key (kbd "M-b") #'backward-word))

(hydra-move-keys)

;; Meh key on Ergodox EZ
(global-set-key (kbd "C-M-S-g") #'hydra-move/body)
(global-set-key (kbd "C-M-S-a") #'hydra-avy/body)
(global-set-key (kbd "C-M-S-b") #'my/switch-to-buffer/body)
(global-set-key (kbd "C-M-S-f") #'find-file-at-point)
(global-set-key (kbd "C-M-S-x") #'counsel-M-x)
(global-set-key (kbd "C-M-S-s") #'save-buffer)
(global-set-key (kbd "C-M-S-m") #'hydra-bookmarks/body)
(global-set-key (kbd "C-M-S-w") #'ace-window)
(global-set-key (kbd "C-M-S-k") #'kill-buffer)


(global-origami-mode 1)

(defun origami-parser-imenu-flat (create)
    "Origami parser producing folds for each imenu entry, without nesting."
    (lambda (content)
      (let ((orig-major-mode major-mode))
        (with-temp-buffer
          (insert content)
          (funcall orig-major-mode)
          (let* ((items
                  (-as-> (imenu--make-index-alist t) items
                         (-flatten items)
                         (-filter 'listp items)))
                 (positions
                  (-as-> (-map #'cdr items) positions
                         (-map-when 'markerp 'marker-position positions)
                         (-filter 'natnump positions)
                         (cons (point-min) positions)
                         (-snoc positions (point-max))
                         (-sort '< positions)
                         (-uniq positions)))
                 (ranges
                  (-zip-pair positions (-map '1- (cdr positions))))
                 (fold-nodes
                  (--map
                   (-let*
                       (((range-beg . range-end) it)
                        (line-beg
                         (progn (goto-char range-beg)
                                (line-beginning-position)))
                        (offset
                         (- (min (line-end-position) range-end) line-beg))
                        (fold-node
                         (funcall create line-beg range-end offset nil)))
                     fold-node)
                   ranges)))
            fold-nodes)))))

(defhydra hydra-origami()
  "Origami"
  ("i" counsel-imenu)
  ("o" origami-open-node)
  ("c" origami-close-node)
  ("t" origami-toggle-node)
  ("O" origami-open-all-nodes "Open")
  ("C" origami-close-all-nodes "Close")
  ("p" origami-previous-fold)
  ("n" origami-next-fold)
  ("u" origami-undo "undo")
  ("r" origami-redo "redo")
  ("R" origami-reset "Reset")
  ("q" nil :color blue)
  ("<ESC>" nil :color blue)
  )

(defun h-ob()
  (interactive)
  (hydra-origami/body))


(defhydra hydra-macro (:hint nil :color pink
                             :pre
                             (when defining-kbd-macro
                                 (kmacro-end-macro 1)))
  "
  ^Create-Cycle^   ^Basic^           ^Insert^        ^Save^         ^Edit^
╭─────────────────────────────────────────────────────────────────────────╯
     ^_i_^           [_e_] execute    [_n_] insert    [_b_] name      [_'_] previous
     ^^↑^^           [_d_] delete     [_t_] set       [_K_] key       [_,_] last
 _j_ ←   → _l_       [_o_] edit       [_a_] add       [_x_] register
     ^^↓^^           [_r_] region     [_f_] format    [_B_] defun
     ^_k_^           [_m_] step
    ^^   ^^          [_s_] swap
"
  ("j" kmacro-start-macro :color blue)
  ("l" kmacro-end-or-call-macro-repeat)
  ("i" kmacro-cycle-ring-previous)
  ("k" kmacro-cycle-ring-next)
  ("r" apply-macro-to-region-lines)
  ("d" kmacro-delete-ring-head)
  ("e" kmacro-end-or-call-macro-repeat)
  ("o" kmacro-edit-macro-repeat)
  ("m" kmacro-step-edit-macro)
  ("s" kmacro-swap-ring)
  ("n" kmacro-insert-counter)
  ("t" kmacro-set-counter)
  ("a" kmacro-add-counter)
  ("f" kmacro-set-format)
  ("b" kmacro-name-last-macro)
  ("K" kmacro-bind-to-key)
  ("B" insert-kbd-macro)
  ("x" kmacro-to-register)
  ("'" kmacro-edit-macro)
  ("," edit-kbd-macro)
  ("q" nil :color blue))


(global-set-key (kbd "M-o") 'ace-window)


(require 'use-package)
(require 'quelpa-use-package)

(use-package nano-theme
  :ensure nil
  :defer t
  :quelpa (nano-theme
           :fetcher github
           :repo "rougier/nano-theme"))

;; SLIME
(setq inferior-lisp-program "/opt/local/bin/clisp")
(require 'slime)
(slime-setup '(slime-fancy))


;; (require 'major-mode-hydra)
;; (global-set-key (kbd "M-SPC") #'major-mode-hydra)

;; (major-mode-hydra-define emacs-lisp-mode nil
;;   ("Eval"
;;    (("b" eval-buffer "buffer")
;;     ("e" eval-defun "defun")
;;     ("r" eval-region "region"))
;;    "REPL"
;;    (("I" ielm "ielm"))
;;    "Test"
;;    (("t" ert "prompt")
;;     ("T" (ert t) "all")
;;     ("F" (ert :failed) "failed"))
;;    "Doc"
;;    (("d" describe-thing-at-point "thing-at-pt")
;;     ("f" describe-function "function")
;;     ("v" describe-variable "variable")
;;     ("i" info-lookup-symbol "info lookup"))))

;; (defvar jp-window--title (with-faicon "windows" "Window Management" 1 -0.05))

;; (pretty-hydra-define jp-window (:foreign-keys warn :title jp-window--title :quit-key "q")
;;   ("Actions"
;;    (("TAB" other-window "switch")
;;     ("x" ace-delete-window "delete")
;;     ("m" ace-delete-other-windows "maximize")
;;     ("s" ace-swap-window "swap")
;;     ("a" ace-select-window "select"))

;;    "Resize"
;;    (("h" move-border-left "←")
;;     ("j" move-border-down "↓")
;;     ("k" move-border-up "↑")
;;     ("l" move-border-right "→")
;;     ("n" balance-windows "balance")
;;     ("f" toggle-frame-fullscreen "toggle fullscreen"))

;;    "Split"
;;    (("b" split-window-right "horizontally")
;;     ("B" split-window-horizontally-instead "horizontally instead")
;;     ("v" split-window-below "vertically")
;;     ("V" split-window-vertically-instead "vertically instead"))

;;    "Zoom"
;;    (("+" zoom-in "in")
;;     ("=" zoom-in)
;;     ("-" zoom-out "out")
;;     ("0" jp-zoom-default "reset"))))

;; (all-the-icons-ivy-setup)



(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(setq debug-on-error t)
