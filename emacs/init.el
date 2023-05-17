(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(eglot marginalia)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

(set-face-attribute 'default nil :height 250)

(icomplete-mode)

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

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package magit
  :ensure t
  :bind
  ("C-x g" . 'magit-status))

(use-package company
  :ensure t
  :init
  (global-company-mode)
  ;; Don't enable for now, too slow...
  ;; (setq company-backends
  ;; 	(mapcar '(lambda (backend)
  ;; 		   (append (if (consp backend) backend (list backend)) '(:with company-yasnippet)))
  ;; 		company-backends))
  :bind
  ("C-c y" . 'company-yasnippet)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1))

(use-package eglot
  :ensure t
  :custom
  (add-to-list '((c++-mode c-mode) "clangd")))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode))
