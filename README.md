# Nerdy Day Trips!

# Building The Site

In the root of the repository, build the static pages to `_site` using:

```
docker run --rm --name jekyll -it -p 4000:4000 -v `pwd`:/srv/jekyll -v `pwd`/vendor/bundle:/usr/local/bundle jekyll/jekyll jekyll build
```

The persistence of the `/usr/local/bundle` directory allows future builds to
be quicker


Then push the `_site` folder to the gh-pages branch
