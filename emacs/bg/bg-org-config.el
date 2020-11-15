;; GENERAL
(setq org-directory "~/org")

;; MODULES
(setq org-modules
      '(ol-bbdb
	ol-bibtex
	ol-docview
	ol-eww
	ol-gnus
	org-habit
	ol-info
	ol-irc
	ol-mhe
	ol-rmail
	ol-w3m))

;; MOBILEORG
(setq org-mobile-inbox-for-pull "~/org/inbox.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

;; GLOBAL KEYBINDS
(define-key global-map (kbd "C-c x") 'org-capture)

;; LOCAL KEYBINDS
(eval-after-load "org"
  '(progn
     (define-key org-mode-map (kbd "C-c a") 'org-agenda)
     (define-key org-mode-map (kbd "C-c l") 'org-store-link)))

;; AGENDA FILES
(setq org-agenda-files `(,org-directory))
(setq org-agenda-skip-scheduled-if-done t)

;; CAPTURE
(setq org-default-notes-file (concat org-directory "/inbox.org"))

;; DRAWERS
(setq org-clock-into-drawer t)

;; REFILING AND ARCHIVES
(setq org-refile-targets '((org-agenda-files :maxlevel . 5)))
(setq org-refile-use-outline-path 'file)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-outline-path-complete-in-steps nil) ;; for ivy?

(setq org-archive-location (concat org-directory "/archive.org::* %s"))

;; AUTOMATIC LOGGING
(setq org-log-into-drawer t)
(setq org-log-done 'note)
(setq org-log-reschedule 'note)

;; DEPENDENCY TRACKING
(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-track-ordered-property-with-tag t)
(setq org-agenda-dim-blocked-tasks t)

;; TODO STATES AND TAGS
(setq org-todo-keywords
      '((sequence "TODO(t)"
		  ;; "NEXT(n)"
		  "PROJECT(p)"
		  "WAITING(w)"
		  "SOMEDAY(s)"
		  "|"
		  "DONE(d)")))
(setq org-todo-keyword-faces
      '(;; ("NEXT"    . "navy")
	("PROJECT" . "blue violet")
	("WAITING" . "coral")
	("SOMEDAY" . "deep pink")))

(setq org-tag-alist '(("HOME"          . ?m)
		      ("ORGMODE"       . ?o)
		      ("DEVELOPMENT"   . ?e)
		      ("HABIT"         . ?h)
		      ("WEEKLY"        . ?w)
		      ("WEEKLYREVIEW"  . ?r)))

;; IDS AND LINKS
(setq org-id-link-to-org-use-id t)
(setq org-id-locations-file (concat org-directory "/.org-id-locations"))

;; ATTACHMENTS
(setq org-attach-store-link-p t)

;; EXPORT
(setq org-export-backends '(ascii beamer html icalendar latex md odt))
(setq org-latex-pdf-process
      '("/Library/TeX/texbin/pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; CAPTURE TEMPLATES
;; TODO

;; CUSTOM FUNCTIONS

;; TODO: re-evalutate if needed?
;; (defun bg/org-add-ids-to-headlines-in-file ()
;;   "Add ID properties to all headlines in the current file which
;;    do not already have one."
;;   (interactive)
;;   (org-map-entries 'org-id-get-create))
;; (add-hook 'org-mode-hook
;; 	  (lambda ()
;; 	    (add-hook 'before-save-hook
;; 		      'bg/org-add-ids-to-headlines-in-file nil 'local)))

(provide 'bg-org-config)
