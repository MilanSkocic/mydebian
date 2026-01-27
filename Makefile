include make.in


SRC=$(MYDEBIAN_SRC_DIR)/$(MYDEBIAN_NAME).sh
BIN=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_NAME)
MAN=$(MYDEBIAN_MAN_DIR)/$(MYDEBIAN_MAN_NAME)
HTML=$(MYDEBIAN_MAN_DIR)/$(MYDEBIAN_MAN_NAME).html
PDF=$(MYDEBIAN_MAN_DIR)/$(MYDEBIAN_MAN_NAME).pdf

DESTDIR=
PREFIX=$(HOME)/.local

.PHONY: clean doc

all: $(BIN)

$(BIN): $(SRC)
	cp $< $@
	chmod +x $@

doc: $(BIN) 
	$(BIN) --help > $(MAN).txt
	txt2man -s 1 -t $(MYDEBIAN_NAME) -v "User commands" -r $(MYDEBIAN_VERSION) $(MAN).txt > $(MAN)
	man -Thtml -l $(MAN) > $(HTML) 
	man -Tpdf -l $(MAN) > $(PDF) 

docs: doc
	rm -fv docs/$(MAN)
	rm -fv docs/$(HTML)
	cp -rfv $(MAN) docs/
	cp -rfv $(HTML) docs/

show_man: doc
	man $(MAN)
	
test: $(BIN)
	$(BIN) --version
	$(BIN) --help

install: $(BIN)
	cp $(BIN) $(DESTDIR)/$(PREFIX)/bin/
	cp $(MAN) $(DESTDIR)/$(PREFIX)/share/man/man$(MYDEBIAN_MAN_SEC)/

uninstall: $(BIN)
	rm $(DESTDIR)/$(PREFIX)/bin/$(MYDEBIAN_NAME)
	rm $(DESTDIR)/$(PREFIX)/share/man/man$(MYDEBIAN_MAN_SEC)/$(MYDEBIAN_NAME)*

clean:
	rm -rf $(MYDEBIAN_BUILD_DIR)/*
