#!/bin/bash
# Add sytws and sytws2122 remotes in your machine!
cd ../website && \
#git init . &&\
#git remote add origin git@github.com:ULL-MII-SYTWS-2122/ULL-MII-SYTWS-2122.github.io.git && \
#touch .nojekyll && \
git add . && \
git ci -am 'new build' && \
git push --force sytws main && \
git push --force sytws2122 main