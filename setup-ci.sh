# Write .npmrc
echo "@receipt-wrangler:registry=https://npm.pkg.github.com/" > /app/receipt-wrangler-desktop/.npmrc
echo "//npm.pkg.github.com/:_authToken=$GH_PACKAGE_READ_TOKEN_DESKTOP" > /app/receipt-wrangler-desktop/.npmrc
