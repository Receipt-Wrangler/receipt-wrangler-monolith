# Write .npmrc
echo "@receipt-wrangler:registry=https://npm.pkg.github.com/" > $HOME/.npmrc
echo "//npm.pkg.github.com/:_authToken=$GH_PACKAGE_READ_TOKEN_DESKTOP" > $HOME/.npmrc
