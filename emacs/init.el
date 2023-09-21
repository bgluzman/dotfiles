(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(subatomic-theme rust-mode use-package rainbow-delimiters paredit lsp-ui lsp-mode yasnippet company magit which-key ace-window)))
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
		      (if (eq system-type 'darwin) 150 300))
  (when (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode))
  :hook
  (c-mode . (lambda ()
	      (define-key c-mode-map
			  (kbd "C-c o")
			  'ff-find-other-file)))
  (c++-mode . (lambda ()
		(define-key c++-mode-map
			    (kbd "C-c o")
			    'ff-find-other-file))))

;; lsp configuration
(load-file (concat
	    (file-name-directory (file-truename load-file-name))
	    "eglot-config.el"))

(use-package subatomic-theme
  :ensure t
  :config
  (load-theme 'subatomic :no-confirm))

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
  (company-idle-delay 0.05)
  :bind
  ("C-c y" . 'company-yasnippet))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode))


(defun bg/yas-c-project-header ()
  (interactive)
  (yas-expand-snippet (yas-lookup-snippet "c-project-header")))
(defun bg/yas-cpp-project-header ()
  (interactive)
  (yas-expand-snippet (yas-lookup-snippet "c++-project-header")))

(defun bg/generate-cpp-sources (name namespace dir &optional is-class)
  (interactive (list (read-string "Name: ")
		     (read-string "Namespace: ")
		     (read-string "Directory: " (project-root (project-current)))))
  (let* ((header-file (concat dir "/" name ".hpp"))
	 (header-class-decl (if is-class (concat "class " name "{};\n") ""))
	 (header-contents (concat "#pragma once\n\nnamespace " namespace " {\n\n" header-class-decl "\n}  // namespace " namespace))
	 (source-file (concat dir "/" name ".cpp"))
	 (source-contents (concat "#include \"" name ".hpp\"\n\nnamespace " namespace " {\n\n}  // namespace " namespace)))
    (append-to-file header-contents nil header-file)
    (append-to-file source-contents nil source-file)    
    (message "Generated %s/%s.{h,cpp}" dir name)))

(defun bg/generate-cpp-class (name namespace dir)
  (interactive (list (read-string "Name: ")
		     (read-string "Namespace: ")
		     (read-string "Directory: " (project-root (project-current)))))
  (bg/generate-cpp-sources name namespace dir t))

(load-file "~/s/dotfiles/emacs/auxiliary.el")
