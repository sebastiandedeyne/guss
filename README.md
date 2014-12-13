# GuSS

*Gulp powered static site generator, based on jekyll and very opinionated*

## Installation

```
$ npm install
```

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
The following options can be set in `config.yml`:

- destination (**_site**)
- pretty_permalinks (**true**|false)
- server_port (**8000**)

## Future features
- Improved site config (enable multiple files to save actual data)
- Allow views without templates
- Add partial support for views
- Could use some better error handling to ensure the watch task breaks as little as possible
