all: clean html public/CNAME

html: node_modules public ${wildcard src/*.html}
	@${foreach \
		HTML, ${filter %.html, $?}, \
		node_modules/.bin/html-minifier $(HTML)\
			--collapse-whitespace \
			--minify-css \
			--minify-js \
			--output public/${notdir $(HTML)} \
	;}

public/CNAME: src/CNAME
	@cp src/CNAME public/CNAME

public:
	@mkdir -p public

clean:
	@rm -rf public

node_modules: package.json
	@npm install

.PHONY: all html clean
