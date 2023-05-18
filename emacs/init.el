(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rainbow-delimiters paredit modus-themes lsp-ui lsp-mode yasnippet company magit which-key ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; builtins
(use-package emacs
  :config
  ;; completion
  (fido-vertical-mode)
  ;; always use electric pairs
  (electric-pair-mode)
  ;; look 'n feel
  (set-face-attribute 'default nil :height 200)
  (when (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode)))
(use-package eglot
  :bind
  (:map eglot-mode-map
	;; code actions
	("C-c l a" . eglot-code-actions)
	("C-c l i" . eglot-code-action-organize-imports)
	("C-c l q" . eglot-code-action-quickfix)
	("C-c l e" . eglot-code-action-extract)
	("C-c l l" . eglot-code-action-inline)
	("C-c l r" . eglot-code-action-rewrite)
	;; formatting
	("C-c l f" . eglot-format-buffer)
	;; misc
	("C-c l v" . eglot-find-declaration)
	;; TODO: move these to the global mode map with different binds?
	;; diagnostics
	("C-c l d" . eldoc)
	("C-c l b" . flymake-show-buffer-diagnostics)
	("C-c l p" . flymake-show-project-diagnostics))
  :config
  ;; needed for overload suggestions
  (add-to-list 'eglot-server-programs
	       '(c++-mode . ("clangd" "--completion-style=detailed")))
  ;; setup hook for C++
  (add-hook 'c++-mode-hook 'eglot-ensure))

(use-package modus-themes
  :ensure t
  :bind
  ("<f5>" . 'modus-themes-toggle)
  :config
  (load-theme 'modus-operandi-tinted :no-confirm)
  (setq modus-themes-to-toggle
	'(modus-operandi-tinted modus-vivendi-tinted)))

(use-package paredit
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package ace-window
  :ensure t
  :bind
  ("M-o" . 'ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package avy
  :ensure t
  :bind
  ("M-g s" . 'avy-goto-word-0)
  ("M-g f" . 'avy-goto-line)
  ("M-g d" . 'avy-goto-char))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package magit
  :ensure t
  :bind
  ("C-x g" . 'magit-status))

(use-package company
  :ensure t
  :init
  (global-company-mode)
  :bind
  ("C-c y" . 'company-yasnippet)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1))


(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode))

