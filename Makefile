.PHONY: all

all:
	${THEOS}/toolchain/linux/iphone/bin/clang -F${THEOS}/vendor/lib -target arm64-apple-ios14.0 -target arm64-apple-darwin -isysroot ${THEOS}/sdks/iPhoneOS14.5.sdk -lobjc -framework UIKit -framework Foundation main.S -o abcd
	cp abcd ipa/Payload/abcd.app/;cd ipa;rm abcd.ipa;zip -r abcd.ipa .