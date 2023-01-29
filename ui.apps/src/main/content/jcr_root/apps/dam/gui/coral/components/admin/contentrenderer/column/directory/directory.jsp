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
--%>
<%
%><%
%><%@page import="org.apache.sling.api.resource.Resource,
				  java.util.Iterator"%><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0"%><%
%><%@include file="/libs/dam/gui/coral/components/admin/contentrenderer/base/init/directoryBase.jsp"%><%
%><%@include file="/libs/dam/gui/coral/components/admin/contentrenderer/column/common/common.jsp"%><%

    String directoryActionRels = StringUtils.join(UIHelper.getDirectoryActionRels(hasJcrRead, hasModifyAccessControl, hasJcrWrite, hasReplicate, isMACShared, isCCShared, isRootMACShared, isMPShared, isRootMPShared, isLiveCopy, hasAddChild, hasRemoveNode, hasModifyProperties), " ");

    String name = resource.getName();
    request.setAttribute("actionRels", actionRels.concat(" " + directoryActionRels));

    attrs.add("itemscope", "itemscope");
    attrs.add("data-item-title", resourceTitle);
    attrs.add("data-item-type", type);

    if (hasChildren(resource)) {
        attrs.add("variant", "drilldown");
    }

    request.setAttribute("com.adobe.assets.meta.attributes", metaAttrs);

%><coral-columnview-item <%= attrs %>>
    <cq:include script = "meta.jsp"/>
    <coral-columnview-item-thumbnail>
        <coral-icon icon="folder" alt=""></coral-icon>
    </coral-columnview-item-thumbnail>
    <coral-columnview-item-content>
        <%-- AXX: Begin of custom code --%>
        <%
            String statusAsString = "";
            if (resource != null) {
                com.day.cq.replication.ReplicationStatus replicationStatus = resource.adaptTo(com.day.cq.replication.ReplicationStatus.class);
                if (replicationStatus.isActivated()) {
                    statusAsString = "published";
                    if (replicationStatus.getLastPublished().before(org.apache.jackrabbit.commons.JcrUtils.getLastModified(resource.adaptTo(Node.class)))) {
                        statusAsString = "modified";
                    }
                }
                else if (replicationStatus.isDeactivated()) {
                    statusAsString = "deactivated";
                }
            }
        %>
        <a class="axx-ribbon <%= !statusAsString.isEmpty() ? "axx-ribbon--" + statusAsString : "" %>" title="<%= statusAsString.isEmpty() ? "Never published" : org.apache.commons.lang3.StringUtils.capitalize(statusAsString)%>"></a>
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
</coral-columnview-item><%!
    //Add private methods here
%>
