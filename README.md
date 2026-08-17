# PUFood Web Version

This repository now contains only the **PUFood web app**.

## Project Structure

```text
.
├── README.md
└── web/
    ├── index.html
    └── data/
        └── outlets/
            ├── index.json
            └── *.json
```

## About the Web Version

- Static single-page web application in `web/index.html`
- Outlet data is loaded from the manifest at `web/data/outlets/index.json`
- Each outlet has its own JSON data file in `web/data/outlets/`

## Run Locally

From the repository root:

```bash
cd web
python -m http.server 8000
```

Then open `http://localhost:8000` in your browser.

You can also open `web/index.html` directly in a browser (`file://...`); outlet data is bundled for local-file usage.
