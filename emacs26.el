;;; -*- lexical-binding: t -*-

;; http://milkbox.net/note/single-file-master-emacs-configuration/
;;;; package.el
(require 'package)

(setq package-user-dir "~/.emacs.d/elpa/")
(setq package-list-archives ())
(setq package-archives '(
	     ("gnu" . "https://elpa.gnu.org/packages/")
             ("melpa" . "http://melpa.milkbox.net/packages/")
	     ("melpa-stable" . "https://stable.melpa.org/packages/")
	     ("marmalade" . "http://marmalade-repo.org/packages/")
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
	  visual-regexp-steroids
	  beacon
	  boxquote
	  ov
	  paradox
	  kaolin-themes
	  flx
	  ivy
	  ivy-hydra
	  smex
	  counsel
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

;; start native Emacs server ready for client connections                  .
(add-hook 'after-init-hook 'server-start)
(setq server-socket-dir "~/.emacs.d/server/")

(add-hook 'after-init-hook 'global-company-mode)

(require 'magit)
(require 'kill-lines)
(require 'multiple-cursors)
(require 'moccur-edit)

(require 'no-easy-keys)
(no-easy-keys)

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

;; Split windows horizontally by default
(setq split-width-threshold nil)

;; control how to move between windows
(windmove-default-keybindings 'meta)

(global-visual-line-mode t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

;; wrap lines at 80 columns
(setq-default fill-column 80)
(add-hook 'find-file-hook 'turn-on-auto-fill)

;; ivy
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq ivy-re-builders-alist
      '((t . ivy--regex-fuzzy)))
(counsel-mode 1)
(global-set-key "\C-s" 'swiper)

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
  (set-buffer-file-coding-system 'unix 't) )


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

(global-set-key (kbd "M-;") #'endless/comment-line-or-region)

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

;;;; Setup some MS Windows specific stuff
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


;;;; key-chord
(require 'key-chord)
(key-chord-mode 1)
(key-chord-define emacs-lisp-mode-map "eb" 'eval-buffer)
(key-chord-define emacs-lisp-mode-map "ed" 'eval-defun)
(key-chord-define emacs-lisp-mode-map "er" 'eval-region)

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

;;;; fastnav
(require 'fastnav)
(global-set-key "\M-r" 'replace-char-forward)
(global-set-key "\M-R" 'replace-char-backward)
(global-set-key "\M-i" 'insert-at-char-forward)
(global-set-key "\M-I" 'insert-at-char-backward)
(global-set-key "\M-j" 'execute-at-char-forward)
(global-set-key "\M-J" 'execute-at-char-backward)
(global-set-key "\M-k" 'delete-char-forward)
(global-set-key "\M-K" 'delete-char-backward)
(global-set-key "\M-p" 'sprint-forward)
(global-set-key "\M-P" 'sprint-backward)

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

(defhydra hydra-breadcrumb ()
  "Breadcrumb"
  ("s" bc-set :color blue)
  ("n" bc-next :color red)
  ("p" bc-previous :color red)
  ("c" bc-clear :color red)
  ("l" bc-list :color blue)
  ("q" nil :color red)
  )


(defhydra hydra-avy ()
  "Avy"
  ("l" avy-goto-line "line" :color blue)
  ("L" avy-copy-line "copy-line" :color blue)

  ("C" avy-goto-char   "char" :color blue)
  ("c" avy-goto-char-2 "char-2" :color blue)

  ("r" avy-copy-region "copy-region" :color blue)
  ("R" avy-kill-ring-save-region "copy->KR" :color blue)

  ("m" avy-move-line "move-line" :color blue)
  ("M" avy-move-region "move-region" :color blue)

  ("w" avy-goto-word-1 "word-1" :color blue)
  ("W" avy-goto-word-0 "word-0" :color blue)

  ("k" avy-kill-region "kill-region" :color blue)
  ("K" avy-kill-whole-line "kill-line" :color blue)

  ("<return>" nil "quit" :color blue)
  ("<RETURN>" nil "quit" :color blue)
  ("<ESC>" nil "quit" :color blue)
  ("q" nil "quit")
  )

(global-set-key (kbd "<f1>") 'hydra-avy/body)
(global-set-key (kbd "s-w") 'avy-goto-word-or-subword-1)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(defhydra hydra-er()
  "Expand Region"
  ("w" er/mark-word "word" :color red)
  ("s" er/mark-symbol "symbol" :color red)
  ("m" er/mark-method-call "method-call" :color red)
  ("q" er/mark-inside-quotes "i-quotes" :color red)
  ("p" er/mark-inside-pairs "i-pairs" :color red)
  ("P" er/mark-outside-pairs "o-pairs" :color red)
  ("c" copy-region-as-kill "copy-region" :color blue)
  ("<return>" nil))

(defun er()
  (interactive)
  (hydra-er/body))


(defhydra hydra-text-commands ()
  "Text commands"
  ("c" copy-region-as-kill "copy-region" :color blue)
  ("w" thing-copy-word "copy-word" :color blue)
  ("l" thing-copy-line "copy-line"  :color blue)
  ("s" thing-copy-symbol "copy-symbol" :color blue)
  ("y" yank-n-times "multiple paste" :color blue )
  ("e" hydra-er/body "expand-region" :color blue)
  ("q" nil "quit"))

(global-set-key (kbd "<f2>") 'hydra-text-commands/body)


(defhydra hydra-lines (goto-map ""
                           :pre (linum-mode 1)
                           :post (linum-mode -1))
  "Lines"
  ("c" thing-copy-line "copy" :color blue)
  ("e" thing-copy-to-line-end "copy-end" :color blue)
  ("b" thing-copy-to-line-beginning "copy-begin" :color blue)
  ("D" djcb-duplicate-line "dup-line" :color red)
  ("g" goto-line "goto-line")
  ("m" set-mark-command "mark" :bind nil)
  ("s" xah-select-current-line "Select current" :color red)
  ("r" copy-region-as-kill "copy-region" :color blue)
  ("R" join-region "join-region" :color blue)
  ("n" forward-line "forward")
  ("p" previous-line "backwards")
  ("u" move-text-up "move-up" :color red)
  ("d" move-text-down "move-down" :color red)
  ("k" kill-lines "kill-lines" :color blue)
  ("l" linum-mode "linum" :color blue)
  ("x" kill-line-remove-blanks "kill-line-rb" :color blue)
  ("j" top-join-line "join-next-line" :color red)
  ("J" delete-indentation "join-prev-line" :color red)
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

(defhydra hydra-move
  (:timeout 5
	    :body-pre (set-cursor-color "#5BFF33")
	    :post (hydra-move-post))
  "move"
  ("a" smarter-move-beginning-of-line)
  ("e" move-end-of-line)
  ("n" next-line)
  ("p" previous-line)
  ("f" forward-char)
  ("b" backward-char)
  ("w" forward-word)
  ("q" backward-word)
  ("d" scroll-up-command)
  ("u" scroll-down-command)
  ("t" beginning-of-buffer)
  ("T" end-of-buffer)
  ("l" avy-goto-line "goto-line")
  ("c" avy-goto-char-2 "goto-char-2")
  ("r" recenter-top-bottom "re-center")
  ("<return>" nil "quit" :color blue)
  ("<RETURN>" nil "quit" :color blue)
  ("<ESC>" nil "quit" :color blue)

)

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
				(move-and-hydra #'next-line-and-avy)))
  (global-set-key (kbd "C-p") (lambda() (interactive)
				(move-and-hydra #'previous-line-and-avy)))
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

(global-set-key (kbd "s-z") #'hydra-move/body)


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
                         (-filter 'identity positions)
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
  ("i" helm-imenu)
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f730a5e82e7eda7583c6526662fb7f1b969b60b4c823931b07eb4dd8f59670e3" "f6c0353ac9dac7fdcaced3574869230ea7476ff1291ba8ed62f9f9be780de128" "e4cbf084ecc5b7d80046591607f321dd655ec1bbb2dbfbb59c913623bf89aa98" default)))
 '(package-selected-packages
   (quote
    (smex company-jedi avy-zap avy yaml-mode wrap-region visual-regexp-steroids undo-tree rainbow-mode rainbow-delimiters pos-tip paredit paradox ov origami multiple-cursors move-text magit macrostep key-chord kaolin-themes jedi iedit hungry-delete fastnav expand-region elpy csv-mode color-moccur browse-kill-ring boxquote bm beacon autopair)))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
