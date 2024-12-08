# Set an absolute path in the config file for WORK_DIR and DEPLOY_DIR
# DEPLOY_DIR is where the final image will be stored
# WORK_DIR is where all the data is stored before merged into an image
# WORK_DIR can use up to 20GB of storage space
# refer to https://github.com/RPi-Distro/pi-gen/blob/master/README.md

32bit:
	git clone https://github.com/RPi-Distro/pi-gen.git pi-gen-32bit
	rm -r pi-gen-32bit/stage2/EXPORT_IMAGE
	sudo ./pi-gen-32bit/build.sh -c config-32bit
	rm -rf pi-gen-32bit/

64bit:
	git clone -b arm64 https://github.com/RPi-Distro/pi-gen.git pi-gen-64bit
	rm -r pi-gen-64bit/stage2/EXPORT_IMAGE
	sudo ./pi-gen-64bit/build.sh -c config-64bit
	rm -rf pi-gen-64bit/

update_langs:
	@for lang in stage3/05-install-pwnagotchi/files/pwnagotchi/pwnagotchi/locale/*/; do\
		echo "updating language: $$lang ..."; \
		./scripts/language.sh update $$(basename $$lang); \
	done

compile_langs:
	@for lang in stage3/05-install-pwnagotchi/files/pwnagotchi/pwnagotchi/locale/*/; do\
		echo "compiling language: $$lang ..."; \
		./scripts/language.sh compile $$(basename $$lang); \
	done
