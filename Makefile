include make.in

MD=$(MYDEBIAN_MAN_DIR)/$(MYDEBIAN_MAN_MD)
GZ=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_MAN_GZ)
HTML=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_MAN_HTML)
BODY=$(MYDEBIAN_MAN_DIR)/body.md
HEADER=$(MYDEBIAN_MAN_HEADER)

SRC=$(MYDEBIAN_SRC_DIR)/$(MYDEBIAN_NAME).sh
BIN=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_NAME)

DESTDIR=$(HOME)
PREFIX=.local

.PHONY: clean doc

all: $(BIN)

$(BIN): $(SRC)
	cp $< $@
	chmod +x $@

doc: 
	$(shell cat $(HEADER) $(BODY) > $(MD))
	pandoc --standalone --from markdown --to man $(MD) -o $(GZ)
	pandoc --standalone --from man --to html $(GZ) -o $(HTML)

test: $(BIN)
	$(BIN) --version

install: $(BIN)
	cp $(BIN) $(DESTDIR)/$(PREFIX)/bin/
	cp $(GZ) $(DESTDIR)/$(PREFIX)/share/man/man$(MYDEBIAN_MAN_SEC)/

uninstall: $(BIN)
	rm $(DESTDIR)/$(PREFIX)/bin/$(MYDEBIAN_NAME)
	rm $(DESTDIR)/$(PREFIX)/share/man/man$(MYDEBIAN_MAN_SEC)/$(MYDEBIAN_NAME)*

clean:
	rm -rf $(MYDEBIAN_BUILD_DIR)/*
