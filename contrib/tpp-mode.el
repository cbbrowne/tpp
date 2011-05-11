;; tpp-mode.el - An Major mode for Emacs to editing TextPraesentionProgramm (tpp) - Files

;; Filename: tpp-mode.el
;; Author:   Christian Dietrich <stettberger@gmx.de>
;; Version:  0.1
;; License:  GNU General Public License

;; Installation:
;;
;;  1) Optionally, byte-compile this file
;;  2) Put this file in a directory Emacs can find
;;  3) Tell Emacs when to load this file
;;  4) Customize some variables for your system
;;
;; ad 1)
;;  Byte-compilation speeds up the load time for this mode
;;  and is therefore recommended. Just load this file into
;;  Emacs and select "Byte-compile This File" from the
;;  "Emacs-Lisp" main menu. This will create the compiled
;;  file with the extension "elc".
;;
;; ad 2)
;;  The directories that Emacs searches are given by the 
;;  load-path variable, which you can query within Emacs with
;;     ESC-x describe-variable RET load-path Ret
;;  To add a directory (eg. ~/.emacs) to load-path, add 
;;  the following code to your $HOME/.emacs file:
;;     (add-to-list 'load-path "~/elisp")
;;
;; ad 3)
;;  Add the following lines to your $HOME/.emacs file:
;;     (autoload 'tpp-mode "tpp-mode" "TPP mode." t)
;;     (add-to-list 'auto-mode-alist '("\\.tpp$" . tpp-mode))
;;  The first line tells Emacs to load tpp-mode.elc or
;;  tpp-mode.el when the command 'tpp-mode' is called.
;;  The second line tells emacs to invoke the command 'tpp-mode'
;;  when a file with a name ending on ".tpp" is opened.
;;
;; ad 4)
;;  Some variables might need adjustment to your local system
;;  environment. You can do it in your $HOME/.emacs file with 
;;  commands like
;;     (setq tpp-command     "xterm -e tpp")
;;     (setq tpp-helpcommand "cat /usr/local/share/doc/tpp/README  | xless")
;;  You can also set these variables interactively from the
;;  entry "Options" in the "TPP" main menu that is created
;;  when tpp-mode is entered.
;;
;; History:
;; 28.02.2005  Initial Release for Emacs
;; Thanks to:
;;
;; Christoph Dalitz:
;; He wrte the mgp-mode-cd.el, on which this script is based, Thanks


(defcustom tpp-mode-hook '()
  "*Hook for customising `tpp-mode'."
  :type 'hook
  :group 'Tpp)

;; custom variables
(defcustom tpp-command "xterm -e tpp"
  "tpp command line.
Must be adjusted according to the compilation options,
eg."
  :group 'Tpp)
(defcustom tpp-helpcommand "cat /usr/local/share/doc/tpp/README  | xless"
  "Command for display of TPP syntax documentation."
  :group 'Tpp)

;; shortcut key bindings
(defvar tpp-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-b") 'tpp-preview-file)
    (define-key map (kbd "C-c C-c") 'tpp-comment-region)
    (define-key map (kbd "C-c C-u") 'tpp-uncomment-region)
    map)
  "Mode map used for `tpp-mode'.")

;; main menu entry
(easy-menu-define
 tpp-mode-menu tpp-mode-map
 "Menu for `tpp-mode'."
 '("TPP"
   ["Preview Buffer" tpp-preview-file ]
   ["Comment Region" tpp-comment-region ]
   ["Uncomment Region" tpp-uncomment-region ]
   ["Syntax Help" (shell-command tpp-helpcommand) ]
   ["Options" (customize-group "Tpp") ]
))

;; Syntax Higlighting
(defvar tpp-mode-font-lock-keywords nil
  "Tpp keywords used by font-lock.")
(if tpp-mode-font-lock-keywords ()
  (let ()
    (setq tpp-mode-font-lock-keywords
	  (list 
	   ;; comments
	   (cons "^--##.*" 'font-lock-comment-face)
	   ;;Abstract - Options
	   (cons "^--author.*" 'font-lock-keyword-face)
	   (cons "^--title.*" 'font-lock-keyword-face)
	   (cons "^--date.*" 'font-lock-keyword-face)
	   ;; Local - Option
	   (cons "^--heading.*" 'font-lock-constant-face)
	   (cons "^--center.*" 'font-lock-constant-face)
	   (cons "^--right.*" 'font-lock-constant-face)
	   (cons "^--sleep.*" 'font-lock-constant-face)
	   (cons "^--exec.*" 'font-lock-constant-face)
	   (cons "^--huge.*" 'font-lock-constant-face)
	   (cons "^--newpage.*" 'font-lock-constant-face)
	   (cons "^--huge.*" 'font-lock-constant-face)
       ;; other format parameters
	   (cons "^--.*" 'font-lock-builtin-face)
	  ))
))



;; Functions
(defun tpp-preview-file ()
  "Previews current file with tpp"
  (interactive)
  (save-buffer)
  (shell-command
       (format "%s %s" tpp-command (shell-quote-argument buffer-file-name))))

(defun tpp-comment-region (start end)
  "Comments out the current region with '--## '."
  (interactive "r")
  (goto-char end) (beginning-of-line) (setq end (point))
  (goto-char start) (beginning-of-line) (setq start (point))
  (let ()
  (save-excursion
	(save-restriction
	  (narrow-to-region start end)
	  (while (not (eobp))
		(insert "--## ")
		(forward-line 1)))))
)

(defun tpp-uncomment-region (start end)
  "Remove '--## ' comments from current region."
  (interactive "r")
  (goto-char end) (beginning-of-line) (setq end (point))
  (goto-char start) (beginning-of-line) (setq start (point))
  (let ((prefix-len '5))
  (save-excursion
	(save-restriction
	  (narrow-to-region start end)
	  (while (not (eobp))
		(if (string= "--## "
					 (buffer-substring
					  (point) (+ (point) prefix-len)))
			(delete-char prefix-len))
		(forward-line 1)))))
)

;; The Modi Function
(defun tpp-mode ()
  "Major mode for editing tpp source.
Comments etc. are highlighted with font-lock. There are also a 
number of commands that make editing and working with TPP files 
more convenient. These commands are available from the main menu 
`TPP' or via the following shortcuts:

\\[tpp-preview-file]	- Run tpp on the current file.
\\[tpp-comment-region]	- Comments out the current region.
\\[tpp-uncomment-region]	- Uncomments the current region.
"
(interactive)
(kill-all-local-variables)
(setq major-mode 'tpp-mode)
(setq mode-name "tpp")
(use-local-map tpp-mode-map)
(make-local-variable 'font-lock-defaults)
(easy-menu-add tpp-mode-menu tpp-mode-map)
  (if (string-match "XEmacs\\|Lucid" emacs-version)
	  (progn (make-face 'font-lock-builtin-face)
			 (copy-face 'font-lock-preprocessor-face 'font-lock-builtin-face)))

(setq font-lock-defaults '(tpp-mode-font-lock-keywords
				 t t ((?_ . "w") (?. . "w"))))
;; let ispell skip '--'-directives
(make-local-variable 'ispell-skip-region-alists)
(add-to-list 'ispell-skip-region-alist (list "^--.*$"))
;; Hook ablaufen lassen
(run-hooks 'tpp-mode-hook)
)
;; End of tpp-mode.el