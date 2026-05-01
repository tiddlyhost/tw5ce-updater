
EMPTIES_LOCATION=https://crosseye.github.io/TW5-CommunityEditions/
EMPTIES_DIR=./empties

# Use curl to fetch the empty file
.PRECIOUS: $(EMPTIES_DIR)/%.html
$(EMPTIES_DIR)/%.html:
	@mkdir -p $(EMPTIES_DIR)
	@curl -sL $(EMPTIES_LOCATION)/$*/empty/index.html -o $@

download-%: $(EMPTIES_DIR)/%.html
	@echo Downloaded $*

TH_DIR=../tiddlyhost-com
UPLOADER=$(TH_DIR)/examples/thost-uploader
DOWNLOAD_DIR=./backups

# Use the uploader script to upload it to Tiddlyhost
# Todo maybe: Only update if there are changes
update-%: download-%
	$(if $(CREDS_FILE),,$(error CREDS_FILE must be set))
	@mkdir -p $(DOWNLOAD_DIR)
	@DOWNLOAD_DIR="$(DOWNLOAD_DIR)" $(UPLOADER) \
	  tw5-ce-$* \
	  "$(EMPTIES_DIR)/$*.html" \
	  "$(shell base64 -d "$(CREDS_FILE)" | jq -r .username)" \
	  "$(shell base64 -d "$(CREDS_FILE)" | jq -r .password | base64 -d)"
	@echo Updated $*

# More editions here in future maybe
update: \
  update-recipes
