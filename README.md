# AEM - Author Experience Extensions (aem-axx)

AEM - Author Experience Extensions is intended to simplify the daily life of authors using Adobe Experience Manager.


## Core Features

- Publish status of pages and assets directly visibile in column view
- Doubleclick to edit a page
- View as published directly from AEM Sites
- View component names without hovering

## Screenshots

![Screenshot of AEM AXX Sites](bin/aem-axx-sites.jpg?raw=true)

![Screenshot of AEM AXX Editor](bin/aem-axx-editor.jpg?raw=true)


## Technical Hints

The CRX-Package overlays very few AEM files. 
It has been tested with an **AEM Cloud instance** (v2023.1.10675.20230113T110236Z-220900) in latest Firefox, Chrome and Edge.

AEM 6.5 is NOT supported (anymore).

In case of any issue, the CRX-Package can just be uninstalled and everything works as before.

The following files have been overlayed:

- cq/gui/components/coral/admin/page/columnitem/columnitem.jsp : Contains a few custom code-lines to add ribbons to siteadmin
- dam/gui/coral/components/admin/contentrenderer/column/asset/asset.jsp: Contains a few custom code-lines to add ribbons to aem-assets in column-view
- dam/gui/coral/components/admin/contentrenderer/column/directory/directory.jsp: Contains a few custom code-lines to add ribbons to aem-assets in column-view
- wcm/core/content/sites/.content.xml : Adds view as published button

## How to install

Just download the [CRX-Package](/nhirrle/aem-axx/releases/latest/download) and install it on your local AEM instance or embed it when installing it for aem cloud.
