AUTHOR=$(git log HEAD^..HEAD --pretty=format:"%an")
echo "Latest commit pushed by:" $AUTHOR

if [[ $AUTHOR != "Travis-CI" ]]; then
	echo -e "Incrementing verison number, pushing to kit and publishing to NPM."

	# copy the scripts folder to the travis' home folder.
	cp -R scripts $HOME/scripts

	cd $HOME

	git config --global user.name "Travis-CI"
	git config --global user.email "webkomold@abakus.no"

	# clone the repo to travis' home-folder, replace the cloned scripts with the new ones:
	git clone --quiet https://${GH_TOKEN}@github.com/webkom/ababot-scripts.git > /dev/null
	cd ababot-scripts
	cp -Rf $HOME/scripts/* scripts

	# increment version number and commit it:
	npm version patch

	# push the version-increment commit:
	git push -fq origin master > /dev/null

	npm publish --email="webkom@abakus.no" --_auth=${NPM_TOKEN}

	echo -e "Done."
fi
