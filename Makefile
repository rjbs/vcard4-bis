DRAFT  = draft-ietf-calext-vcard4-bis-00
BUILD  = build/$(DRAFT)
IMAGE  = vcard4-bis-tools

# RFC 2045 and RFC 4288 are cited only inside ABNF comments, where
# kramdown-rfc can't make a cross-reference, so xml2rfc thinks they're unused.
SILENCE = --silence 'Unused reference: There seems to be no reference to [RFC2045]' \
          --silence 'Unused reference: There seems to be no reference to [RFC4288]'

.PHONY: all xml html txt clean docker-build

all: html txt

docker-build:
	docker build -t $(IMAGE) docker

$(BUILD).xml: $(DRAFT).md
	mkdir -p build
	docker run --rm -v $$(pwd):/work -w /work $(IMAGE) \
	    kramdown-rfc $(DRAFT).md > $(BUILD).xml

$(BUILD).html: $(BUILD).xml
	docker run --rm -v $$(pwd):/work -w /work $(IMAGE) \
	    xml2rfc $(SILENCE) --html -o $(BUILD).html $(BUILD).xml

$(BUILD).txt: $(BUILD).xml
	docker run --rm -v $$(pwd):/work -w /work $(IMAGE) \
	    xml2rfc $(SILENCE) --text -o $(BUILD).txt $(BUILD).xml

xml: $(BUILD).xml
html: $(BUILD).html
txt: $(BUILD).txt

clean:
	rm -f $(BUILD).xml $(BUILD).html $(BUILD).txt
