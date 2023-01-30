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

### Cloud SDK Installation

For testing purposes locally you can just download the [CRX-Package](/nhirrle/aem-axx/releases/latest/download) and install it on your local AEM instance

### AEM Cloud installation

With AEM Cloud you cannot install this package with CRX Package Manager as /apps in immutable. 

Instead, you will need to embed the package to your source-code:

1. Configure a local file system repository to your all/pom.xml  
```
    <repositories>
        <repository>
            <id>project.local</id>
            <name>project</name>
            <url>file:${project.basedir}/repository</url>
            <releases>
                <enabled>true</enabled>
                <updatePolicy>never</updatePolicy>
            </releases>
        </repository>
    </repositories>
```

2. Add dependency to the all/pom.xml
```
    <dependency>
        <groupId>ch.aem-devs</groupId>
        <artifactId>aem-axx-pkg</artifactId>
        <version>1.2</version>
        <type>zip</type>
    </dependency>
```

3. Define the dependency to the embed block within the filevault-package-maven-plugin configuration 
```
    <plugin>
        <groupId>org.apache.jackrabbit</groupId>
        <artifactId>filevault-package-maven-plugin</artifactId>
        <extensions>true</extensions>
        <configuration>
            <group>my-package</group>
            <packageType>container</packageType>
            <skipSubPackageValidation>true</skipSubPackageValidation>
            <embeddeds>
                <embedded>
                    <groupId>ch.aem-devs</groupId>
                    <artifactId>aem-axx-pkg</artifactId>
                    <type>zip</type>
                    <target>/apps/aem-axx-packages/application/install</target>
                </embedded>
                ....
            </embeddeds>
            ...
```
4. Download latest [CRX-Package](https://github.com/nhirrle/aem-axx/releases/latest) from Github.
5. Run following command from the AEM project source root to add the package to the local git repo. Replace {aem-axx-pkg.path} with the path to the file you downloaded in step 4.:
```
mvn org.apache.maven.plugins:maven-install-plugin:3.1.0:install-file -Dfile={aem-axx-pkg.path} -DlocalRepositoryPath=./all/repository/ -Dpackaging=zip -DgeneratePo
m=true
```
6. Confirm that package installation succeeds by running `mvn clean install -PautoSinglePackage` on your local AEM instance.
6. Commit and push the changes to your adobe git, afterwards run a deployment with Cloud Manager.
