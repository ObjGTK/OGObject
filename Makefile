include extra.mk

SUBDIRS = src tests

include buildsys.mk

check: tests
	${MAKE} -C tests -s run

install-extra:
	i=OGObject.oc; \
	packagesdir="${DESTDIR}$$(${OBJFW_CONFIG} --packages-dir)"; \
	${INSTALL_STATUS}; \
	if ${MKDIR_P} $$packagesdir && ${INSTALL} -m 644 $$i $$packagesdir/$$i; then \
		${INSTALL_OK}; \
	else \
		${INSTALL_FAILED}; \
	fi

uninstall-extra:
	i=OGObject.oc; \
	packagesdir="${DESTDIR}$$(${OBJFW_CONFIG} --packages-dir)"; \
	if test -f $$packagesdir/$$i; then \
		if rm -f $$packagesdir/$$i; then \
			${DELETE_OK}; \
		else \
			${DELETE_FAILED}; \
		fi \
	fi; \
	rmdir $$packagesdir >/dev/null 2>&1 || true
