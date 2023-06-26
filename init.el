;; package setup

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; use-package setup
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)


;; GENERAL

;; files and folder
(setq create-lockfiles nil)
(setq backup-directory-alist '(("." . "~/.emacs_backup")))
(setq default-directory "~/github.com/yassinehaddoudi")
(setq-default tab-width 4)

;; browser
(setq browse-url-browser-function 'browse-url-default-windows-browser)

;;; delete nasty hidden white spaces at the end of lines
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; windows specific
(setq explicit-shell-file-name "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
(setq explicit-powershell.exe-args '("-Command" "-" )) ; interactive, but no command prompt

;; UI

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq display-line-numbers 'relative)

;; font
(setq default-frame-alist '((font . "Go Mono 14")))
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; theme
(load-theme 'tango-dark t)


;; PACKAGES

;; vim keybindings
;; (use-package evil)
;; (evil-mode t)

;; autopair: (),{} default enabled
(electric-pair-mode t)

;; treesit
;;(require 'treesit)

;; LSP
;; eglot package
(use-package eglot
  :hook
  (emacs-lisp-mode . eglot-ensure)
  (c-mode . eglot-ensure)
  (go-mode . eglot-ensure)
  (rust-mode . eglot-ensure)
  (js-mode . eglot-ensure))
;; completion
;;(add-hook 'after-init-hook 'global-company-mode)

;; move-text package
(use-package move-text)
(move-text-default-bindings)

;; vertico.el package
(use-package vertico
  :init
  (vertico-mode))

(use-package fzf
  :bind
    ;; Don't forget to set keybinds!
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        ;; fzf/grep-command "rg --no-heading -nH"
        fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))




;; KEYBINDINGS

;; start and end of line with whitespace
(global-set-key (kbd "M-a") 'back-to-indentation)
(global-set-key (kbd "M-e") (lambda ()
							  (interactive)
							  (move-end-of-line 1)
							  (delete-horizontal-space)))

;; highlight/mark sexp
(global-set-key (kbd "C-M-y") 'mark-sexp)

;; undo keybindings C-x u or C-x C-u
(global-set-key (kbd "C-x C-u") 'undo)

;; next error
(global-set-key (kbd "C-x e") 'flymake-goto-next-error)

;; move-text keybindings
(global-set-key (kbd "M-k") 'move-text-up)
(global-set-key (kbd "M-j") 'move-text-down)

;; screen motion keybindings
(defun window-half-height ()
  (max 1 (/ (1- (window-height (selected-window))) 2)))

(defun scroll-down-half ()
  (interactive)
  (next-line (window-half-height))
  (recenter))

(defun scroll-up-half ()
  (interactive)
  (previous-line (window-half-height))
  (recenter))

(global-set-key (kbd "C-p") 'previous-line)
(global-set-key (kbd "C-n") 'next-line)
(global-set-key (kbd "M-p") 'scroll-up-half)
(global-set-key (kbd "M-n") 'scroll-down-half)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rg company treesit-auto rust-mode exec-path-from-shell lsp evil evil-mode vertico use-package move-text magit goto-chg go-mode drag-stuff))
 '(warning-suppress-types '((use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
