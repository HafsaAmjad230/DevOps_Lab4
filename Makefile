SRC_DIR := src
OUT_DIR := out
SOURCES := $(wildcard $(SRC_DIR)/*.txt)
OUTPUTS := $(patsubst $(SRC_DIR)/%.txt,$(OUT_DIR)/%.txt,$(SOURCES))

.PHONY: all check build test clean ci

all: ci

check:
	@echo "check: $(words $(SOURCES)) source file(s) in $(SRC_DIR)"

build: check $(OUTPUTS)

$(OUT_DIR)/%.txt: $(SRC_DIR)/%.txt
	@mkdir -p $(OUT_DIR)
	@echo "BUILD $< -> $@"
	@tr 'a-z' 'A-Z' < $< > $@

test: build
	@test -d $(OUT_DIR)
	@test -s $(OUT_DIR)/greeting.txt
	@echo "TEST PASSED"

clean:
	rm -rf $(OUT_DIR)

ci: clean build test

count: build ## report source files and built words
	@ls -1 $(SRC_DIR)/*.txt | wc -l
	@wc -w $(OUTPUTS) | tail -1
