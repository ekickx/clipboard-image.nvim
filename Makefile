.PHONY: test prepare macos-prepare download-img

download-img:
	@if [ ! -f "./test/expected.png" ]; then \
		curl -fLo test/expected.png https://link.ekickx.vercel.app/clipboard-image.nvim/test_expected.png; \
	fi

prepare: download-img
	@if [ ! -d "./vendor/plenary.nvim" ]; then \
		mkdir -p vendor; \
		git clone --depth=1 https://github.com/nvim-lua/plenary.nvim vendor/plenary.nvim; \
	fi

macos-prepare:
	@brew update && \
	brew install pngpaste

test: prepare
	@nvim \
		--headless \
		--noplugin \
		-u test/minimal_init.vim \
		-c "PlenaryBustedDirectory test/ { minimal_init = './test/minimal_init.vim' }"

lint:
	luacheck lua/
