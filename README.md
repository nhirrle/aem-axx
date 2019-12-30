# AEM - Author Experience Extensions (aem-axx)

AEM - Author Experience Extensions is intended to simplify the daily life of authors using Adobe Experience Manager. 
The aim of this project is to get some simple features back to Touch UI without having to involve any AEM developer. 
Just install it and be happy.  

![Screenshot of AEM AXX Sites](bin/aem-axx-sites.jpg?raw=true)

![Screenshot of AEM AXX Editor](bin/aem-axx-editor.jpg?raw=true)

## Core Features

- Publish status of pages and assets directly visibile in column view
- Doubleclick to edit a page
- View as published directly from AEM Sites
- View component names without hovering

## Technical Hints

The CRX-Package overlays very few AEM files. It has been tested with an out of the box instance of AEM 6.5.3, AEM 6.4.6, AEM 6.4.3 and AEM 6.4.2 in Firefox, Chrome, IE 11 and Edge. Still no software is 100% bugfree, so in case of any issue, the CRX-Package can just be uninstalled and everything works as before.

The following files have been overlayed:

- cq/gui/components/coral/admin/page/columnitem/columnitem.jsp : Contains a few custom code-lines to add ribbons to siteadmin
- dam/gui/coral/components/admin/contentrenderer/column/asset/asset.jsp: Contains a few custom code-lines to add ribbons to aem-assets in column-view
- dam/gui/coral/components/admin/contentrenderer/column/directory/directory.jsp: Contains a few custom code-lines to add ribbons to aem-assets in column-view
- wcm/core/content/sites/.content.xml : Adds view as published button

## How to install

Just download the [CRX-Package](bin/aem-axx-pkg-1.1.zip) and install it on your AEM instance.
