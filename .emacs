;(require 'package)
;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(add-to-list 'load-path "~/.emacs.d/lisp")
(load-file "~/.emacs.d/lisp/oracle.el")

; #########

; Mac key bindings
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

; Hide the tool bar
(tool-bar-mode 0)

; Don't show startup window
(setq inhibit-startup-message t)

;; ; Change color scheme
;; (set-background-color "black")
;; (set-foreground-color "white")

; Turn on column display mode
(add-to-list 'column-number-mode 1)

; get help
(global-set-key [(f1)] (lambda () (interactive) (manual-entry (current-word))))

; auto-indent new lines
(define-key global-map (kbd "RET") 'newline-and-indent)

; goto-line
(global-set-key "\C-l" 'goto-line)

; previous window
(global-set-key "\C-x\S-O" 'previous-multiframe-window)


; highlight matching parentheses next to cursor
(require 'paren)(show-paren-mode t)

; highlight region between mark and point
(transient-mark-mode t)

; highlight incremental search
;(setq search-highlight t)

; Moving cursor down at bottom scrolls only a single line, not half page
(setq scroll-step 1)
(setq scroll-conservatively 5)
(global-set-key [delete] 'delete-char)

; press Ctrl+Enter to auto-expand partial strings
(global-set-key [C-return]         'dabbrev-expand)
(define-key esc-map [C-return]     'dabbrev-completion)
(setq dabbrev-case-replace nil)

; Reload the current file while remembering the cursor position
(defun reload-file ()
  (interactive)
  (let ((curr-scroll (window-vscroll)))
    (find-file (buffer-name))
    (set-window-vscroll nil curr-scroll)
    (message "Reloaded file")))
(global-set-key "\C-c\C-r" 'reload-file)

; Save Session
(desktop-save-mode 1)

; Load cscope
(require 'xcscope)
(cscope-setup)

;; ####### GOLANG SUPPORT ########

(setq exec-path (append exec-path '("/Users/Asif/gocode" "/usr/local/go/bin")))

;; auto-load go modes and helpers
(require 'go-mode-load)
(require 'go-flymake)
(require 'go-flycheck)
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "/Users/Asif/.emacs.d/ac-dict")
(ac-config-default)
(require 'auto-complete-config)
(require 'go-autocomplete)
(require 'go-eldoc)

;;(require 'go-oracle)
;;(require 'go-errcheck)
;;(autoload 'flycheck-mode "flycheck" "run ze flycheck" nil)

; map F7 to grep
(global-set-key [(f7)] 'grep)
(setq grep-command "grep -R -n -e --include='*.go' *")

;; run gofmt before save
;; (add-hook 'before-save-hook 'gofmt-before-save)

;; use M-. to jump to definition
;; (add-hook 'go-mode-hook (lambda ()
;;                           (local-set-key (kbd \"M-.\") 'godef-jump)))

;; From https://github.com/codemac/config/blob/master/emacs.d/boot.org
(require 'projectile)

 ; this is the default, don't need to set it
 ;(set projectile-indexing-method 'alien)

 (projectile-global-mode)

 (defun cm/projectile-dirlocals-hook (dir)
   (cond ((equal dir 'mesa)
          (setq process-environment
                 (append '("GOPATH=/Users/Asif/gocode/src/mesa/go"
                           ;; "GOOS=linux"
                           ;; "GOARCH=amd64"
                           "GOBIN=/Users/Asif/gocode/src/mesa/bin/linux_amd64"
                           "IGROOT=/tmp/igroot")
                         process-environment)))))

(defun gofmt ()
 "Pipe the current buffer through the external tool `gofmt`.
Replace the current buffer on success; display errors on failure."

 (interactive)
 (let ((srcbuf (current-buffer)))
   (with-temp-buffer
     (let ((outbuf (current-buffer))
           (errbuf (get-buffer-create "*Gofmt Errors*"))
           (coding-system-for-read 'utf-8)    ;; use utf-8 with subprocesses
           (coding-system-for-write 'utf-8))
       (with-current-buffer errbuf (erase-buffer))
       (with-current-buffer srcbuf
         (save-restriction
           (let (deactivate-mark)
             (widen)
             (if (= 0 (shell-command-on-region (point-min) (point-max) "gofmt"
                                               outbuf nil errbuf))
                 ;; gofmt succeeded: replace the current buffer with outbuf,
                 ;; restore the mark and point, and discard errbuf.
                 (let ((old-mark (mark t)) (old-point (point)))
                   (erase-buffer)
                   (insert-buffer-substring outbuf)
                   (goto-char (min old-point (point-max)))
                   (if old-mark (push-mark (min old-mark (point-max)) t))
                   (kill-buffer errbuf))

               ;; gofmt failed: display the errors
               (display-buffer errbuf)))))

       ;; Collapse any window opened on outbuf if shell-command-on-region
       ;; displayed it.
       ;; NO! Don't do that< cm!
       ;;(delete-windows-on outbuf)
))))
;; END From https://github.com/codemac/config/blob/master/emacs.d/boot.org

; M-x compile to compile Go code
; will execute: go build -v && go test -v && go vet
(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  ; Go Oracle
  (go-oracle-mode))

;; ####### MD SUPPORT ########

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . gfm-mode))
(setq markdown-command "redcarpet")

;; ########

;; (defun insert-big-comment (&optional cmntstr)
;;   "Add a figlet comment for the given text"
;;   (interactive
;;    (list
;;     (read-string "Enter string to comment: ")))

;;   (save-excursion
;;     (let ((start (point))
;; 	  (bigstr (shell-command-to-string (format "figlet %s" cmntstr)))
;; 	  (comment-style 'multi-line))
;;       (insert bigstr)
;; ; remove the last blank line... amazing how hard this is to do
;; ; safely (ie prove it's blank).
;;       (let ((killend (point)))
;; 	(previous-line 1)
;; 	(kill-region (point) killend))
;; ; comment the region, but also add a missing final return for the
;; ; block comment style.  Place an easy-to-find char that we'll delete
;; ; later... because comment-region requires a non-blank-line.
;;       (insert "x\n")
;;       (comment-region start (point))
;;       (save-excursion
;; 	; now delete our marker
;; 	(re-search-backward "x" start)
;; 	(let ((killend (+ (point) 1)))
;; 	  (beginning-of-line)
;; 	  (kill-region (point) killend)))
;;       )))

;; Cool Tricks
;; ; Startup Stuff
;; (split-window-horizontally)   ;; want two windows at startup 
;; (other-window 1)              ;; move to other window
;; (shell)                       ;; start a shell
;; (rename-buffer "shell-first") ;; rename it
;; (other-window 1)              ;; move back to first window 

;;; bind compile to F9
;;(global-set-key [(f9)] 'compile)

;;; bind tags-search to F3
;;(c-set-key [(f3)] (lambda () (interactive) (tags-search (current-word))))

; close the compilation window for a successful compilation
;; (setq compilation-finish-function
;;       (lambda (buf str)
;;         (if (string-match "exited abnormally" str)
;;             ;;there were errors
;;             (message "compilation errors, press C-x ` to visit")
;;           ;;no errors, make the compilation window go away in 0.5 seconds
;;           (run-at-time 0.5 nil 'delete-windows-on buf)
;;           (message "NO COMPILATION ERRORS!"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(column-number-mode (quote (1)))
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; (setq c-default-style "linux")
(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/ubuntu-trusty/")
                                       filename))
                (setq indent-tabs-mode t)
                (c-set-style "linux-tabs-only")))))
