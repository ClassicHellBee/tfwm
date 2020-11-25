# tfwm - tiny fork window manager
#   (C)opyright Luca L.

include config.mk

SRC = bar.c client.c dev.c draw.c event.c main.c util.c
OBJ = ${SRC:.c=.o}
MAN1 = tfwm.1 
BIN = tfwm

all: config tfwm
	@echo finished

config:
	@echo tfwm build options:
	@echo "LIBS     = ${LIBS}"
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: tfwm.h

tfwm: ${OBJ}
	@echo LD $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f tfwm *.o core

dist: clean
	mkdir -p tfwm-${VERSION}
	cp -R Makefile README LICENSE config.mk *.h *.c ${MAN1} tfwm-${VERSION}
	tar -cf tfwm-${VERSION}.tar tfwm-${VERSION}
	gzip tfwm-${VERSION}.tar
	rm -rf tfwm-${VERSION}

install: all
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f ${BIN} ${DESTDIR}${PREFIX}/bin
	@echo installed executable files to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	@cp -f ${MAN1} ${DESTDIR}${MANPREFIX}/man1
	@echo installed manual pages to ${DESTDIR}${MANPREFIX}/man1

uninstall:
	for i in ${BIN}; do \
		rm -f ${DESTDIR}${PREFIX}/bin/`basename $$i`; \
	done
	for i in ${MAN1}; do \
		rm -f ${DESTDIR}${MANPREFIX}/man1/`basename $$i`; \
	done
