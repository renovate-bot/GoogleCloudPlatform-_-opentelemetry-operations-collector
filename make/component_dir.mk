TOOLS_DIR = $(PWD)/.tools
MDATAGEN_BIN = $(TOOLS_DIR)/mdatagen

.PHONY: update-otel-components
update-components: export OTEL_VERSION := $(OTEL_VERSION)
update-components: export OTEL_CONTRIB_VERSION := $(OTEL_CONTRIB_VERSION)
update-components: update-deps tidy-components update-mdatagen generate-components

.PHONY: update-mdatagen
update-mdatagen: tools-dir
	cd internal/tools && \
		go get -u go.opentelemetry.io/collector/cmd/mdatagen@$(OTEL_VERSION) && \
		GOBIN=$(TOOLS_DIR) go install go.opentelemetry.io/collector/cmd/mdatagen

.PHONY: update-deps
update-deps:
	TARGET="update-components" $(MAKE) target-all-modules

.PHONY: generate-components
generate-components:
	TARGET="generate" $(MAKE) target-all-modules

.PHONY: tidy-components
tidy-components:
	TARGET="tidy" $(MAKE) target-all-modules

.PHONY: test-components
test-components:
	TARGET="test" $(MAKE) target-all-modules

.PHONY: target-all-modules
target-all-modules:
ifndef TARGET
	@echo "No TARGET defined."
else
	go list -f "{{ .Dir }}" -m | grep ".*$(PWD).*" | grep -v ".*internal/tools.*" |\
		GOWORK=off \
		PATH="$(TOOLS_DIR):${PATH}" \
		xargs -t -I '{}' $(MAKE) -C {} $(TARGET)
endif

# This is a PHONY target cause if you make it as a normal recipe
# it gets very confused because the creation date of the .tools
# directory is newer than the tools inside it.
.PHONY: tools-dir
tools-dir:
	@mkdir -p $(TOOLS_DIR)
