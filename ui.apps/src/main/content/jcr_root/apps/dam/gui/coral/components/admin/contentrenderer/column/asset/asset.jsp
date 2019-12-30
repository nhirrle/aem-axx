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
%><%@page import="org.apache.sling.api.resource.Resource,
				  com.adobe.granite.security.user.util.AuthorizableUtil,
                  org.apache.commons.lang.StringUtils,
				  com.day.cq.dam.commons.util.UIHelper,
                  java.util.Date,
                  java.util.Calendar"%><%
%><%@include file="/libs/dam/gui/coral/components/admin/contentrenderer/base/init/assetBase.jsp"%><%
%><%@include file="/libs/dam/gui/coral/components/admin/contentrenderer/column/common/common.jsp"%><%
String name = resource.getName();

boolean isOmniSearchRequest = request.getAttribute(IS_OMNISEARCH_REQUEST) != null ? (boolean) request.getAttribute(IS_OMNISEARCH_REQUEST) : false;

boolean showOriginalIfNoRenditionAvailable = (request!=null && request.getAttribute("showOriginalIfNoRenditionAvailable")!=null) ? (Boolean)request.getAttribute("showOriginalIfNoRenditionAvailable") : false;
boolean showOriginalForGifImages = (request!=null && request.getAttribute("showOriginalForGifImages")!=null) ? (Boolean)request.getAttribute("showOriginalForGifImages") : false;
String thumbnailUrl = getCloudThumbnailUrl(asset, 48, showOriginalIfNoRenditionAvailable, showOriginalForGifImages);
if(thumbnailUrl == null || thumbnailUrl.isEmpty()){
    thumbnailUrl = request.getContextPath() + requestPrefix
            + getThumbnailUrl(asset, 48, showOriginalIfNoRenditionAvailable, showOriginalForGifImages)
            + "?ch_ck=" + ck + requestSuffix;
}
//Override default thumbnail for set when there is manual thumbnail defined
if (dmSetManualThumbnailAsset != null) {
    thumbnailUrl = getCloudThumbnailUrl(asset, 1280, showOriginalIfNoRenditionAvailable, showOriginalForGifImages);
    if(thumbnailUrl == null || thumbnailUrl.isEmpty()){
        thumbnailUrl = request.getContextPath() + requestPrefix
                + getThumbnailUrl(asset, 1280, showOriginalIfNoRenditionAvailable, showOriginalForGifImages)
                + "?ch_ck=" + ck + requestSuffix;
    }
}

String assetActionRels = StringUtils.join(
  UIHelper.getAssetActionRels(
    UIHelper.ActionRelsResourceProperties.create(isAssetExpired, isSubAssetExpired, isContentFragment, 
      isArchive, isSnippetTemplate, isDownloadable, isStockAsset, isStockAssetLicensed, isStockAccessible, canFindSimilar),
    UIHelper.ActionRelsUserProperties.create(hasJcrRead, hasJcrWrite, hasAddChild, canEdit, canAnnotate, isDAMAdmin),
    UIHelper.ActionRelsRequestProperties.create(isOmniSearchRequest,isLiveCopy)), 
  " ");

request.setAttribute("actionRels", actionRels.concat(" " + assetActionRels));

attrs.add("itemscope", "itemscope");
attrs.add("data-item-title", resourceTitle);
attrs.add("data-item-type", type);

if (resource.getChild("subassets")!=null){
     attrs.add("variant", "drilldown");
}
request.setAttribute("com.adobe.assets.meta.attributes", metaAttrs);

%><coral-columnview-item <%= attrs.build() %>>
<cq:include script = "meta.jsp"/>
    <coral-columnview-item-thumbnail><%
        if (isArchive) {
            %><coral-icon icon="fileZip" size="S"></coral-icon><%
        } else {%>
            <img src="<%= xssAPI.getValidHref(thumbnailUrl) %>" alt="" itemprop="thumbnail" style="vertical-align: middle; width: auto; height: auto; max-width: 3rem; max-height: 3rem;"><%
        }%>
    </coral-columnview-item-thumbnail>
    <coral-columnview-item-content>
        <%-- AXX: Begin of custom code --%>
        <%
            String statusAsString = "";
            if (asset != null) {
                com.day.cq.replication.ReplicationStatus replicationStatus = asset.adaptTo(Resource.class).adaptTo(com.day.cq.replication.ReplicationStatus.class);
                if (replicationStatus.isActivated()) {
                    statusAsString = "published";
                    Calendar lastModifiedDate = Calendar.getInstance();
                    lastModifiedDate.setTimeInMillis(asset.getLastModified());
                    if (replicationStatus.getLastPublished().before(lastModifiedDate)) {
                        statusAsString = "modified";
                    }
                }
                else if (replicationStatus.isDeactivated()) {
                    statusAsString = "deactivated";
                }
            }
        %>
        <a class="axx-ribbon <%= !statusAsString.isEmpty() ? "axx-ribbon--" + statusAsString : "" %>" title="<%= statusAsString.isEmpty() ? "Never published" : StringUtils.capitalize(statusAsString)%>"></a>
        <%-- AXX: End of custom code --%>
        <div class="foundation-collection-item-title" itemprop="title" title="<%= xssAPI.encodeForHTMLAttr(resourceTitle) %>">
            <%= xssAPI.encodeForHTML(resourceTitle) %>
        </div><%
        if (name != null && !name.equals(resourceTitle)) {
            %><div class="foundation-layout-util-subtletext">
                <%= xssAPI.encodeForHTML(name) %>
            </div><%
        }%>
    </coral-columnview-item-content>
    <cq:include script = "applicableRelationships.jsp"/>
    <cq:include script = "link.jsp"/>
	<meta itemprop="lastmodified" content="<%= lastModified %>">
    <meta itemprop="lastmodifiedby" content="<%= xssAPI.encodeForHTMLAttr(lastModifiedBy) %>">
</coral-columnview-item><%!
//Add private methods here
%>
