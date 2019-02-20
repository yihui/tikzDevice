SUDO := $(shell groups | grep -q docker || echo sudo -E)
IMAGE := "tikzdevice/ci"
PWD := $(shell pwd)
UID := $(shell id -u):$(shell id -g)

DOCKER_OPTS := --rm -u $(UID) -e HOME=/tmp -v $(PWD):/mnt -w /mnt

PKG_VERSION = $(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME = $(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)
PKG_TAR = $(PKG_NAME)_$(PKG_VERSION).tar.gz


docker-build:
	$(SUDO) docker build -t $(IMAGE) docker

docker-pull:
	$(SUDO) docker pull $(IMAGE)

docker-push:
	$(SUDO) docker push $(IMAGE)


info:
	$(SUDO) docker run $(DOCKER_OPTS) $(IMAGE) Rscript -e "sessionInfo()"

build:
	$(SUDO) docker run $(DOCKER_OPTS) $(IMAGE) R CMD build --compact-vignettes=gs+qpdf .

check:
	$(SUDO) docker run $(DOCKER_OPTS) $(IMAGE) R CMD check --no-manual $(PKG_TAR)

test:
	$(SUDO) docker run $(DOCKER_OPTS) $(IMAGE) Rscript -e \
	   'install.packages("$(PKG_TAR)", repos = NULL); testthat::test_dir("tests", stop_on_failure = TRUE)'

covr:
	$(SUDO) docker run $(DOCKER_OPTS) $(IMAGE) Rscript -e "covr::codecov()"

clean:
	rm -rf $(PKG_TAR) $(PKG_NAME).Rcheck/
