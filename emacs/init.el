(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(use-package rainbow-delimiters paredit modus-themes lsp-ui lsp-mode yasnippet company magit which-key ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Ensure packages get installed on new system...
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; auto-formatting support (for eglot, below)
(defun eglot-format-on-save ()
  (when (and (memq 'eglot--managed-mode minor-mode-list)
	     (memq this-command '(save-buffer save-some-buffers)))
    (eglot-format-buffer)))

;; builtins
(use-package emacs
  :config
  ;; completion
  (fido-vertical-mode)
  ;; always use electric pairs
  (electric-pair-mode)
  ;; look 'n feel
  (setq mac-command-modifier 'control)
  (column-number-mode)
  (set-face-attribute 'default nil :height
		      (if (eq system-type 'darwin) 150 185))
  (when (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode))
  :hook
  (c++-mode . (lambda ()
		(define-key c++-mode-map
			    (kbd "C-c o")
			    'ff-find-other-file))))
(use-package eglot
  :init
  (add-hook 'after-save-hook #'eglot-format-on-save)
  :config
  ;; needed for overload suggestions
  (add-to-list 'eglot-server-programs
	       '(c++-mode . ("clangd" "--completion-style=detailed")))
  (setq-default eglot-workspace-configuration
		'(:pylsp
		  (:plugins (:flake8          (:enabled t)
			     :pycodesytle     (:enabled :json-false)
			     :jedi_completion (:include_params t
					       :fuzzy t)
		             :pylint          (:enabled :json-false)
			     :black           (:enabled     t
					       :line_length 79)
			     :pylsp_mypy      (:enabled t)))))
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
  :hook
  (c++-mode . eglot-ensure)
  (python-mode . eglot-ensure))

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-operandi-tinted :no-confirm)
  (setq modus-themes-to-toggle
	'(modus-operandi-tinted modus-vivendi-tinted))
  :bind
  ("<f5>" . 'modus-themes-toggle))

(use-package paredit
  :ensure t
  :hook
  (emacs-lisp-mode . enable-paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(use-package ace-window
  :ensure t
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind
  ("M-o" . 'ace-window))

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
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  :bind
  ("C-c y" . 'company-yasnippet))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode))


(setq semantic-refactor-local-package
      "/home/brian/.emacs.d/external/semantic-refactor/")
(when (file-directory-p semantic-refactor-local-package)
  (add-to-list 'load-path semantic-refactor-local-package)
  (use-package srefactor
    :ensure nil
    :hook
    (c-mode   . (lambda ()
	          (semantic-mode)
	          (define-key c-mode-map
			      (kbd "M-RET")
			      'srefactor-refactor-at-point)))
    (c++-mode . (lambda ()
	          (semantic-mode)
	          (define-key c++-mode-map
			      (kbd "M-RET")
			      'srefactor-refactor-at-point)))))

