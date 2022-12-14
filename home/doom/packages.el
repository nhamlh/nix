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
