<%--
  ADOBE CONFIDENTIAL

  Copyright 2015 Adobe Systems Incorporated
  All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and may be covered by U.S. and Foreign Patents,
  patents in process, and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%
%><%@include file="/libs/granite/ui/global.jsp"%><%
%><%@page session="false"%><%
%><%@page import="com.adobe.granite.security.user.util.AuthorizableUtil,
                  com.adobe.granite.ui.components.AttrBuilder,
                  com.adobe.granite.ui.components.Tag,
                  com.day.cq.wcm.api.Page,
                  com.day.cq.wcm.api.PageManager,
                  com.day.cq.wcm.api.Template,
                  com.day.cq.wcm.msm.api.LiveRelationshipManager,
                  com.day.cq.dam.api.Asset,
                  com.adobe.cq.wcm.launches.utils.LaunchUtils,
                  com.day.cq.commons.jcr.JcrConstants,
                  org.apache.commons.lang.StringUtils,
                  org.apache.jackrabbit.util.Text,
                  org.apache.jackrabbit.commons.jackrabbit.authorization.AccessControlUtils,
                  org.apache.jackrabbit.oak.spi.security.privilege.PrivilegeConstants,
                  org.apache.sling.api.resource.ResourceResolver,
                  org.apache.sling.api.resource.ValueMap,
                  org.apache.sling.api.SlingHttpServletRequest,
                  org.apache.sling.api.request.RequestProgressTracker,
                  javax.jcr.RepositoryException,
                  javax.jcr.Session,
                  javax.jcr.security.AccessControlManager,
                  javax.jcr.security.Privilege,
                  java.util.Arrays,
                  java.util.ArrayList,
                  java.util.Calendar,
                  java.util.Collection,
                  java.util.Collections,
                  java.util.Iterator,
                  java.util.List,
                  java.util.function.Supplier,
                  com.day.cq.commons.thumbnail.ThumbnailProviderManager,
                  javax.jcr.Node,
                  com.day.cq.commons.thumbnail.ThumbnailProvider,
                  java.util.Map,
                  java.util.HashMap,
                  org.slf4j.Logger,
                  com.adobe.cq.ui.admin.siteadmin.components.ui.UIHelper" %>
<%@ page import="org.apache.sling.api.resource.Resource" %>
<%

    RequestProgressTracker progressTracker = slingRequest.getRequestProgressTracker();

    AccessControlManager acm = null;
    try {
        acm = resourceResolver.adaptTo(Session.class).getAccessControlManager();
    } catch (RepositoryException e) {
        log.warn("Unable to get access manager", e);
    }

    progressTracker.log("completed analytics determination");

    Page cqPage = resource.adaptTo(Page.class);

    boolean isInLaunch = LaunchUtils.isLaunchBasedPath(resource.getPath()) && cqPage != null;

    progressTracker.log("completed launch handling");

    String title = "";
    String name = null;
    String actionRels = StringUtils.join(getActionRels(resource, cqPage, acm, isInLaunch, slingRequest, progressTracker,log), " ");


    progressTracker.log("completed actionrel computation");

    if (cqPage != null) {
        String cqPageTitle = cqPage.getTitle();
        if (StringUtils.isEmpty(cqPageTitle)) {
            // Fallback to name for the title
            title = cqPage.getName();
        }
        else {
            // Get both name and title if title exists
            title = cqPageTitle;
            name = cqPage.getName();
        }
    }
    else {
        ValueMap vm = resource.getValueMap();
        title = vm.get(JcrConstants.JCR_CONTENT + "/" + JcrConstants.JCR_TITLE, vm.get(JcrConstants.JCR_TITLE, String.class));
        if (StringUtils.isEmpty(title)) {
            // Fallback to name for the title
            title = resource.getName();
        }
        else {
            // Get both name and title if title exists
            name = resource.getName();
        }
    }

    progressTracker.log("completed getting name and title");

    LiveRelationshipManager liveRelationshipManager = resourceResolver.adaptTo(LiveRelationshipManager.class);
    boolean isLiveCopy = liveRelationshipManager.hasLiveRelationship(resource);

    progressTracker.log("completed MSM status evaluation");

    Tag tag = cmp.consumeTag();
    AttrBuilder attrs = tag.getAttrs();

    attrs.add("itemscope", "itemscope");
    attrs.add("data-timeline", true);
    attrs.add("data-cq-page-livecopy", isLiveCopy);
    attrs.add("data-foundation-picker-collection-item-text", resource.getPath());

    if (hasChildren(resource)) {
        attrs.add("variant", "drilldown");
    }

%><coral-columnview-item <%= attrs %>>
    <coral-columnview-item-thumbnail><%
        String thumbnailUrl = null;
        ThumbnailProviderManager tpm = sling.getService(ThumbnailProviderManager.class);

        if (cqPage != null) {
            thumbnailUrl = getThumbnailUrl(cqPage, 48, 48, tpm);
        } else {
            Asset asset = resource.adaptTo(Asset.class);

            if (asset != null) {
                String assetTitle = asset.getMetadataValue("dc:title");

                if (assetTitle != null) {
                    name = title;
                    title = assetTitle;
                }

                thumbnailUrl = getThumbnailUrl(resource, 48, 48);
            }
        }

        if (thumbnailUrl != null) {
    %><img class="foundation-collection-item-thumbnail is-thumbnail-lazy-loaded" src="data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPScxLjEnIGlkPSdzcGVjdHJ1bS1pY29uLTE4LVdlYlBhZ2UnIHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZycgeG1sbnM6eGxpbms9J2h0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsnIHg9JzBweCcgeT0nMHB4JyB2aWV3Qm94PScwIDAgMTggMTgnIHN0eWxlPSdlbmFibGUtYmFja2dyb3VuZDpuZXcgMCAwIDE4IDE4OycgeG1sOnNwYWNlPSdwcmVzZXJ2ZScgaGVpZ2h0PScxOHB4JyB3aWR0aD0nMThweCc+PHN0eWxlIHR5cGU9J3RleHQvY3NzJz4gLnN0MCU3QmZpbGw6JTIzNEI0QjRCOyU3RCUwQTwvc3R5bGU+PHBhdGggY2xhc3M9J3N0MCcgZD0nTTEsMi41djEzQzEsMTUuOCwxLjIsMTYsMS41LDE2aDE1YzAuMywwLDAuNS0wLjIsMC41LTAuNXYtMTNDMTcsMi4yLDE2LjgsMiwxNi41LDJoLTE1QzEuMiwyLDEsMi4yLDEsMi41eiBNMTYsMTVIMlY1aDE0VjE1eicvPjwvc3ZnPgo="
           data-thumbnail-url="<%= xssAPI.getValidHref(request.getContextPath() + thumbnailUrl) %>" alt="" itemprop="thumbnail"><%
    } else {
    %><coral-icon class="foundation-collection-item-thumbnail" icon="folder"></coral-icon><%
        }
        progressTracker.log("completed thumbnail detection");
    %></coral-columnview-item-thumbnail>
    <coral-columnview-item-content>
        <%-- AXX: Begin of custom code --%>
        <%
            String status = "";
            if (cqPage != null) {
                com.day.cq.replication.ReplicationStatus replicationStatus = cqPage.adaptTo(com.day.cq.replication.ReplicationStatus.class);
                if (replicationStatus.isActivated()) {
                    status = "published";
                    if (replicationStatus.getLastPublished().before(cqPage.getLastModified())) {
                        status = "modified";
                    }
                }
                else if (replicationStatus.isDeactivated()) {
                    status = "deactivated";
                }
            }
        %>
        <a class="axx-ribbon <%= !status.isEmpty() ? "axx-ribbon--" + status : "" %>" title="<%= status.isEmpty() ? "Never published" : StringUtils.capitalize(status)%>"></a>
        <%-- AXX: End of custom code --%>
        <div class="foundation-collection-item-title" itemprop="title" title="<%= xssAPI.encodeForHTMLAttr(title) %>">
            <%= xssAPI.encodeForHTML(title) %>
        </div><%
        if (name != null && !name.equals(title)) {
    %><div class="foundation-layout-util-subtletext">
        <%= xssAPI.encodeForHTML(name) %>
    </div><%
        }%>
    </coral-columnview-item-content>

    <meta class="foundation-collection-quickactions" data-foundation-collection-quickactions-rel="<%= xssAPI.encodeForHTMLAttr(actionRels) %>">
    <link rel="admin" href="<%= xssAPI.getValidHref(request.getContextPath() + "/sites.html" + Text.escapePath(resource.getPath()))%>"><%

    progressTracker.log("completed actionrel handling");
    if (cqPage != null && cqPage.getLastModified() != null) {

        String key = "columnitem.jsp_FORMATTED_NAMES";
        Map<String,String> formattedNamesMap = (Map<String,String>) slingRequest.getAttribute(key);
        if (formattedNamesMap == null) {
            formattedNamesMap = new HashMap<>();
            slingRequest.setAttribute(key,formattedNamesMap);
        }
        String formattedName = formattedNamesMap.get(cqPage.getLastModifiedBy());
        if (formattedName == null) {
            progressTracker.log("resolve user id from repo");
            formattedName = AuthorizableUtil.getFormattedName(resourceResolver, cqPage.getLastModifiedBy());
            formattedNamesMap.put(cqPage.getLastModifiedBy(), formattedName);
        }

%><meta itemprop="lastmodified" content="<%= cqPage.getLastModified().getTimeInMillis() %>">
    <meta itemprop="lastmodifiedby" content="<%= xssAPI.encodeForHTML(formattedName) %>"><%
    }
    progressTracker.log("completed lastModified handling");
%></coral-columnview-item><%!

    private String getThumbnailUrl(Page page, int width, int height,
                                   ThumbnailProviderManager tpm) {
        String ck = "";

        ValueMap metadata = page.getProperties("image/file/jcr:content");
        if (metadata != null) {
            Calendar cal = metadata.get("jcr:lastModified", Calendar.class);
            if (cal != null) {
                ck = "" + (cal.getTimeInMillis() / 1000);
            }
        }

        Resource pageRsc = page.adaptTo(Resource.class);
        ThumbnailProvider tp = (tpm != null ? tpm.getThumbnailProvider(pageRsc) : null);
        Map<String, Object> addConf = new HashMap<String, Object>();
        addConf.put("doCenter", false);
        String thumbnailPath = (tp != null
                ? tp.getThumbnailPath(pageRsc, width, height, addConf)
                : null);
        if (thumbnailPath == null) {
            if (isPageWithOwnThumbnail(page)) {
                thumbnailPath = page.getPath();
            }
            else if (isPageWithThumbnail(page)) {
                thumbnailPath = page.getTemplate().getThumbnailPath();
            }
            else {
                thumbnailPath = PAGE_THUMBNAIL_PATH;
            }
        }
        return Text.escapePath(thumbnailPath) + ".thumb." + width + "." + height + ".png?ck=" + ck;
    }

    private static String getThumbnailUrl(Resource r, int width, int height) {
        return Text.escapePath(r.getPath()) + ".thumb." + width + "." + height + ".png";
    }

    private List<String> getActionRels(Resource resource, Page page, AccessControlManager acm, boolean isInLaunch,
                                       SlingHttpServletRequest slingRequest, RequestProgressTracker progressTracker, Logger log) {
        List<String> actionRels = new ArrayList<String>();

        // calculate all values upfront
        List<String> privilegeNames = new ArrayList<>();
        try {
            Privilege[] allPrivileges = acm.getPrivileges(resource.getPath());
            privilegeNames.addAll(Arrays.asList(AccessControlUtils.namesFromPrivileges(allPrivileges)));
            // resolve all privileges into their aggregates
            for (Privilege p: allPrivileges) {
                if (p.isAggregate()) {
                    privilegeNames.addAll(Arrays.asList(AccessControlUtils.namesFromPrivileges(p.getAggregatePrivileges())));
                }
            }
        } catch (RepositoryException e) {
            log.debug("caught repo exception while checking privileges for {}", resource.getPath(), e);
        }
        progressTracker.log("privileges resolved");

        // Resolve the privileges by their string reprensentation instead of using privileges (for performance reasons)
        // cannot use Privilege.JCJR_WRITE because that contains the namespaced version
        boolean hasWritePermission = privilegeNames.contains(PrivilegeConstants.JCR_WRITE);
        boolean canAddChildNodes = privilegeNames.contains(PrivilegeConstants.JCR_ADD_CHILD_NODES);
        boolean hasRemoveNodePrivilege = privilegeNames.contains(PrivilegeConstants.JCR_REMOVE_NODE);
        boolean hasLockManagement = privilegeNames.contains(PrivilegeConstants.JCR_LOCK_MANAGEMENT);
        boolean hasVersionManagementPrivilege = privilegeNames.contains(PrivilegeConstants.JCR_VERSION_MANAGEMENT);
        boolean hasReplicationPrivilege = privilegeNames.contains("crx:replicate");


        // Store the result of the privilege resolution of these static paths within the request context, so they
        // can be reused.
        boolean canAddLaunch = getOrSetFromRequest (slingRequest, "columnitem.jsp_CAN_ADD_LAUNCH",
                                                    () -> { return hasPrivilege(acm, "/content/launches", Privilege.JCR_ADD_CHILD_NODES);});
        boolean canReadWorkflowModels = getOrSetFromRequest(slingRequest,"columnitem.jsp_CAN_READ_WORKFLOW_MODELS",
                                                            () -> { return hasPrivilege(acm, "/etc/workflow/models", Privilege.JCR_READ); });

        boolean pageIsLocked = false;
        boolean pageCanUnlock = false;
        if (page != null) {
            pageIsLocked = page.isLocked();
            pageCanUnlock = page.canUnlock();
        }
        boolean canDeleteLockedPage = (page != null && pageIsLocked && pageCanUnlock) || (page != null && !pageIsLocked) || page == null;


        if (page != null && hasLockManagement) {
            if (!pageIsLocked) {
                actionRels.add("cq-siteadmin-admin-actions-lockpage-activator");
            } else if (pageCanUnlock) {
                actionRels.add("cq-siteadmin-admin-actions-unlockpage-activator");
            }
        }

        actionRels.add("cq-siteadmin-admin-actions-copy-activator");

        if (page != null) {
            actionRels.add("cq-siteadmin-admin-actions-edit-activator");
            if (hasWritePermission) {
                actionRels.add("cq-siteadmin-admin-actions-properties-activator");
            }
        }

        boolean showCreate = false;
        boolean showRestore = false;

        if (!resource.getPath().equals("/content") && canAddLaunch) {
            actionRels.add("cq-siteadmin-admin-createlaunch");
            showCreate = true;
        }

        if (canAddChildNodes) {
            if (page != null && UIHelper.resourceHasAllowedTemplates(resource, slingRequest)) {
                actionRels.add("cq-siteadmin-admin-createpage");
            }
            if (page == null) {
                actionRels.add("cq-siteadmin-admin-createfolder");
            }
            showCreate = true;
        }

        if (isInLaunch) {
            if (hasRemoveNodePrivilege && canDeleteLockedPage) {
                actionRels.add("cq-siteadmin-admin-actions-delete-activator");
            }

            if (showCreate) {
                actionRels.add("cq-siteadmin-admin-actions-create-activator");
            }
            actionRels.add("cq-siteadmin-admin-actions-promote-activator");
            return actionRels;
        }

        if (page != null) {
            if (hasVersionManagementPrivilege) {
                actionRels.add("cq-siteadmin-admin-actions-restore-activator");
                actionRels.add("cq-siteadmin-admin-restoreversion");
                actionRels.add("cq-siteadmin-admin-restoretree");
            }
        } else {
            // for nt:folder there are no properties to edit
            if (!resource.isResourceType("nt:folder") && hasWritePermission) {
                actionRels.add("cq-siteadmin-admin-actions-folderproperties-activator");
            }
        }

        if (hasRemoveNodePrivilege && canDeleteLockedPage) {
            actionRels.add("cq-siteadmin-admin-actions-move-activator");
            actionRels.add("cq-siteadmin-admin-actions-delete-activator");
        }

        if (hasReplicationPrivilege) {
            actionRels.add("cq-siteadmin-admin-actions-quickpublish-activator");
        }
        if (canReadWorkflowModels) {
            actionRels.add("cq-siteadmin-admin-actions-publish-activator");
        }

        if (page != null  && (!pageIsLocked || pageCanUnlock)) {
            actionRels.add("cq-siteadmin-admin-createworkflow");
            if (hasWritePermission) {
                actionRels.add("cq-siteadmin-admin-createversion");
            }
            showCreate = true;
        }

        if (canAddChildNodes) {
            actionRels.add("cq-siteadmin-admin-createlivecopy");
            actionRels.add("cq-siteadmin-admin-createsite");
            actionRels.add("cq-siteadmin-admin-createsitefromsitetemplate");
            actionRels.add("cq-siteadmin-admin-createcatalog");
            showCreate = true;
        }

        if (showCreate) {
            actionRels.add("cq-siteadmin-admin-actions-create-activator");
            actionRels.add("cq-siteadmin-admin-createlanguagecopy");
        }

        if(page!=null){
            ValueMap pageProperties = page.getProperties();
            if(pageProperties !=null && pageProperties.containsKey("cq:lastTranslationDone")){
                //this is translation page
                actionRels.add("cq-siteadmin-admin-actions-translation-update-memory");
            }
        }
        return actionRels;
    }

    private boolean getOrSetFromRequest(SlingHttpServletRequest slingRequest, String key, Supplier<Boolean> function) {
        boolean result = false;
        if (slingRequest.getAttribute(key) != null) {
            result = (Boolean) slingRequest.getAttribute(key);
        } else {
            result = function.get();
            slingRequest.setAttribute(key, result);
        }
        return result;
    }

    private boolean hasPrivilege(AccessControlManager acm, String path, String privilege) {
        if (acm != null) {
            try {
                Privilege p = acm.privilegeFromName(privilege);
                return acm.hasPrivileges(path, new Privilege[]{p});
            } catch (RepositoryException ignore) {
            }
        }
        return false;
    }

    private boolean hasChildren(Resource resource) {
        for (Iterator<Resource> it = resource.listChildren(); it.hasNext(); ) {
            Resource r = it.next();

            // don't consider repository nodes (e.g. rep:policy) or content resources as children (Timewarp incorrectly
            // exposes jcr:frozenNode as the page's content resource, hence we need to test for it at the moment)
            if (r.getName().startsWith("rep:") || r.getName().equals(JcrConstants.JCR_CONTENT)
                    || r.getName().equals(JcrConstants.JCR_FROZENNODE)) {
                continue;
            }
            return true;
        }

        return false;
    }

    private static final String GIF_MIMETYPE = "image/gif";
    private static final String PNG_MIMETYPE = "image/png";
    private static final String JPEG_MIMETYPE = "image/jpeg";
    private static final String PJPEG_MIMETYPE = "image/pjpeg";
    private static final String[] TUMBNAIL_POSTFIX = new String[]{
            "-thumbnail.gif",
            "-thumbnail.jpeg",
            "-thumbnail.png"
    };
    private static final String PAGE_THUMBNAIL_PATH = "/libs/cq/ui/widgets/themes/default/icons/240x180/page.png";

    private boolean isPageWithThumbnail(Page page) {
        return ((page != null)
                && (page.getTemplate() != null)
                && (page.getTemplate().getThumbnailPath() != null));
    }

    private boolean isPageWithOwnThumbnail(Page page) {
        try {
            if (page != null) {
                Resource imageResource = page.getContentResource("image");
                if (imageResource != null) {
                    Node imageNode = imageResource.adaptTo(Node.class);
                    if (imageNode != null) {
                        return imageNode.hasNode("file")
                                || imageNode.hasProperty("fileReference");
                    }
                }
            }
            return false;
        } catch (Exception ex) {
            return false;
        }
    }
%>
