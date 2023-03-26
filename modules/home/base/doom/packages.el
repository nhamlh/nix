;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! auto-dim-other-buffers)
(package! visual-fill-column)
(package! org-roam-server)
(package! protobuf-mode)
(package! ob-mermaid)
(package! auto-dim-other-buffers)
(package! cue-mode)
(package! devdocs)

(unpin! org-roam)
(package! websocket)
(package! org-roam-ui :recipe (:host github :repo "org-roam/org-roam-ui" :files ("*.el" "out")))

;; doom uses a little old format-all package, unpit to use up-to-date version
;;(unpin! format-all)

;; It seems that some magit dependencies break with Emacs 28, as the function
;; defvar-keymap is only added in Emacs 29. The solution is to pin an older
;; version of the packages, as Doom currently does not support Emacs 29.
;; https://emacs.stackexchange.com/questions/75827/doom-emacs-error-running-hook-global-git-commit-mode-because-void-variable
(package! transient
      :pin "c2bdf7e12c530eb85476d3aef317eb2941ab9440"
      :recipe (:host github :repo "magit/transient"))

(package! with-editor
          :pin "bbc60f68ac190f02da8a100b6fb67cf1c27c53ab"
          :recipe (:host github :repo "magit/with-editor"))
