var surgicalListUrl = "";
$(document).ready(function() {

    var modulePermissions = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindModulePermission",
        Arg1: session.GroupID,
        Arg2: "Y",
        ArgCnt: 2
    }, "json", false);
    GenerateMenus(modulePermissions);
    if (surgicalListUrl && surgicalListUrl != "") {
        addTab("手术列表", surgicalListUrl, false);
    }
    //$('body').layout('collapse', 'west');
    //layoutsetting();
});


function layoutsetting() {
    setTimeout(function() {
        $('body').layout('collapse', 'west');
    }, 0);
}

function GenerateMenus(data) {
    if (data && data.length > 0) {
        $.each(data, function(index, dataItem) {
            if (!dataItem.ParentModule || dataItem.ParentModule == "null" || dataItem.ParentModule == "") {
                $("#menuGroup").accordion("add", {
                    id: "Menu" + dataItem.RowId,
                    title: dataItem.DataModuleDesc,
                    iconCls: dataItem.Icon,
                    selected: false
                });
            }
        });

        $("#menuGroup").accordion("select", 0);

        $.each(data, function(index, dataItem) {
            if (!dataItem.ParentModule || dataItem.ParentModule == "null" || dataItem.ParentModule == "") {
                $("#Menu" + dataItem.RowId).append("<div id='SubMenu" + dataItem.RowId + "' style='overflow:auto;padding:0px;'></div>");
                GenerateSubMenus("SubMenu" + dataItem.RowId, dataItem.DataModule, data);
            }
        });
    }
}

function GenerateSubMenus(mainMenuId, parentModuleId, data) {
    if (data && data.length > 0) {
        $.each(data, function(index, dataItem) {
            if (dataItem.ParentModule && dataItem.ParentModule > 0 && dataItem.ParentModule == parentModuleId) {

                var url = dataItem.Url + "?moduleId=" + dataItem.DataModule;
                if (dataItem.DataModuleCode == "OperationList") {
                    surgicalListUrl = url;
                }
                var content = "<div class='nav-item'><a href='javascript:addTab(&quot;" + dataItem.DataModuleDesc + "&quot;,&quot;" + url + "&quot;)' id='" + dataItem.DataModuleCode + "'>" + dataItem.DataModuleDesc + "</a></div>";
                $("#" + mainMenuId).append(content);
            }
        });
    }
}

function addTab(title, href, closeable) {
    var tabPanel = $("#mainTabs"),
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var content = "未实现";
        if (href) {
            content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: content
                //href:content
        });
    }
}

function closeCurrentTab() {
    var selectedTab = $("#mainTabs").tabs("getSelected"),
        selectedIndex = $("#mainTabs").tabs("getTabIndex", selectedTab);
    $("#mainTabs").tabs("close", selectedIndex);
}