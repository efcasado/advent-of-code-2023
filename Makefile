.PHONY: all force

SHELL = BASH_ENV=.rc /bin/bash --noprofile
DIRS = $(patsubst %/,%,$(sort $(dir $(wildcard */*))))

all: $(DIRS)

$(DIRS): force
	@echo "== Day $@ ====="
	@echo "  Part 1 (sample): `cat $@/sample_input | elixir $@/1.exs`"
	@echo "  Part 1:          `cat $@/input | elixir $@/1.exs`"
	@echo "  Part 2 (sample): `cat $@/sample_input | elixir $@/2.exs`"
	@echo "  Part 2:          `cat $@/input | elixir $@/2.exs`"
