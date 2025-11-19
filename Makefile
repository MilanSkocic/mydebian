include make.in

MD=$(MYDEBIAN_MAN_DIR)/$(MYDEBIAN_MAN_MD)
GZ=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_MAN_GZ)
HTML=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_MAN_HTML)
BODY=$(MYDEBIAN_MAN_DIR)/body.md
HEADER=$(MYDEBIAN_MAN_HEADER)

SRC=$(MYDEBIAN_SRC_DIR)/$(MYDEBIAN_NAME).sh
BIN=$(MYDEBIAN_BUILD_DIR)/$(MYDEBIAN_NAME)

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

clean:
	rm -rf $(MYDEBIAN_BUILD_DIR)/*
