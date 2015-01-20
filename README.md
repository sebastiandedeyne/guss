# Guss

*Gulp powered static site generator, based on jekyll and very opinionated*

## Overview
Guss compiles the bootstrapped folders into a ready-for-production website. Each folder's content is treated differently.

```
views
```

Swig templated come here. Layouts can be registered in `views/_layouts`. Views van contain front matter which cascade to the top layout.

```
assets
```

Assets' contents get copied straight to the destination folder. Story your favicons, .htaccess, images, etc. here.

```
assets-static
```

Static assets behave the same as assets, but aren't watched for changes during development. This is useful to reduce long build times when including large files or php libraries.

```
css
```

Sass-files are automatically compiled, linked svg's are base64-encoded, css-files are copied.

```
js
```

Coffeescript files are automatically compiled. `gulp-include` is also enabled here, this is very useful to include dependencies from bower without adding bloat (take a look at `js/lib/jquery` for an example).

## Installation

```
$ npm install [&& bower install]
```

*Note: if you don't want to use bower, you'll have to remove the files in `js/lib` which include bower packages.*

## Usage

```
$ gulp build [--production]
```

Generate the site to the destination set in `config/gulpfile.coffee`. By default this is `_site`.

```
$ gulp serve
```

Serve the site at `http://localhost:8000` and watch for changes.

## Configuration
Configuration is stored in `config.site.yml` and/or `config.local.yml`. The local configuration file is gitignored for personal configuration. It's content overwrites the site configuration.

### Options
- destination (**_site**)
- pretty_permalinks (**true**|false)
- server_port (**8000**)
- livereload (**true**)

## Future features
- Upgrade to gulp 4.0
- Support partial views
