.PHONY: all force

SHELL = BASH_ENV=.rc /bin/bash --noprofile
DIRS = $(patsubst %/,%,$(sort $(dir $(wildcard */*))))

all: $(DIRS)

$(DIRS): force
	@echo "Day $@ Part 1 (sample): `cat $@/sample_input | elixir $@/1.exs`"
	@echo "Dat $@ Part 1:          `cat $@/input | elixir $@/1.exs`"
	@echo "Day $@ Part 2 (sample): `cat $@/sample_input | elixir $@/2.exs`"
	@echo "Day $@ Part 2:          `cat $@/input | elixir $@/2.exs`"
