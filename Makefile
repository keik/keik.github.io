all: clean html dist/CNAME

deploy: all
	@sh -c '\
    git add -f dist && \
    TID=$$(git write-tree --prefix dist) && \
    git reset dist && \
    CID=$$(git commit-tree -p master -m "Update" $$TID) && \
    git update-ref refs/heads/master $$CID && \
    git push origin master'

html: node_modules dist ${wildcard src/*.html}
	@${foreach \
		HTML, ${filter %.html, $?}, \
		node_modules/.bin/html-minifier $(HTML)\
			--collapse-whitespace \
			--minify-css \
			--minify-js \
			--output dist/${notdir $(HTML)} \
	;}

dist/CNAME: src/CNAME
	@cp src/CNAME dist/CNAME

dist:
	@mkdir -p dist

clean:
	@rm -rf dist

node_modules: package.json
	@npm install

.PHONY: all html clean
