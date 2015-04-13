all: rd

git:
	test "$$(git status --porcelain | wc -c)" = "0"

master: git
	test $$(git rev-parse --abbrev-ref HEAD) = "master"

inst/web: git master
	rm -rf inst/web
	git clone . inst/web
	cd inst/web && if ! git checkout gh-pages; then git checkout --orphan gh-pages && git commit --allow-empty -m "initial"; fi

gh-pages-build: staticdocs
	cd inst/web && git fetch && git merge --no-edit origin/master --strategy ours && git add . && git commit --amend --no-edit && git push -f origin gh-pages

gh-pages-push:
	git push -u origin gh-pages

rd: git
	Rscript -e "library(methods); devtools::document()"
	git add man/ NAMESPACE
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "document"

inst/NEWS.Rd: git NEWS.md
	Rscript -e "tools:::news2Rd('$(word 2,$^)', '$@')"
	sed -r -i 's/`([^`]+)`/\\code{\1}/g' $@
	git add $@
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "update NEWS.Rd"

tag:
	(echo Release v$$(sed -n -r '/^Version: / {s/.* ([0-9.-]+)$$/\1/;p}' DESCRIPTION); echo; sed -n '/^===/,/^===/{:a;N;/\n===/!ba;p;q}' NEWS.md | head -n -3 | tail -n +3) | git tag -a -F /dev/stdin v$$(sed -n -r '/^Version: / {s/.* ([0-9.-]+)$$/\1/;p}' DESCRIPTION)

bump-cran-desc: master rd
	crant -u 2 -C

bump-gh-desc: master rd
	crant -u 3 -C

bump-desc: master rd
	test "$$(git status --porcelain | wc -c)" = "0"
	sed -i -r '/^Version: / s/( [0-9.]+)$$/\1-0.0/' DESCRIPTION
	git add DESCRIPTION
	test "$$(git status --porcelain | wc -c)" = "0" || git commit -m "add suffix -0.0 to version"
	crant -u 4 -C

bump-cran: bump-cran-desc inst/NEWS.Rd tag

bump-gh: bump-gh-desc inst/NEWS.Rd tag

bump: bump-desc inst/NEWS.Rd tag

bootstrap_snap:
	curl -L https://raw.githubusercontent.com/krlmlr/r-snap-texlive/master/install.sh | sh
	curl -L https://raw.githubusercontent.com/krlmlr/r-snap/master/install.sh | sh

test:
	Rscript -e "devtools::check(document = FALSE, check_dir = '.', cleanup = FALSE)"
	! egrep -A 5 "ERROR|WARNING|NOTE" *.Rcheck/00check.log

covr:
	Rscript -e 'if (!requireNamespace("covr")) devtools::install_github("jimhester/covr"); covr::codecov()'

lintr:
	Rscript -e 'if (!requireNamespace("lintr")) devtools::install_github("jimhester/lintr"); lintr::lint_package()'

staticdocs: inst/web
	Rscript -e 'if (!requireNamespace("staticdocs")) devtools::install_github("gaborcsardi/staticdocs@crayon-colors"); staticdocs::build_site()'

view-docs:
	chromium-browser inst/web/index.html

wercker-build:
	wercker build --docker-host=unix://var/run/docker.sock --no-remove

wercker-deploy:
	wercker deploy --docker-host=unix://var/run/docker.sock --no-remove
