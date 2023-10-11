
function initPage() {
    initMenuGroup();
}

function initMenuGroup() {
    var menuItems = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "web.DHCICUCModule",
        QueryName: "FindMenuItem",
        Arg1: "",
        ArgCnt: 1
    }, "json");
    if (menuItems && menuItems.length > 0) {
        var menuItemsGroups = dhccl.group(menuItems, "MainItemDesc");
        if (menuItemsGroups && menuItemsGroups.length > 0) {
            var htmlArr = [];
            for (var i = 0; i < menuItemsGroups.length; i++) {

                var menuItemsGroup = menuItemsGroups[i];
                if (!menuItemsGroup.id || menuItemsGroup.data.length < 1) continue;
                var firstMenuItem = menuItemsGroup.data[0];
                htmlArr.push("<div title='" + firstMenuItem.MainItemDisplayName + "' data-options='collapsible:false,collapsed:false' class='menugroup-list'><ul class='i-menugroup'>");
                for (var j = 0; j < menuItemsGroup.data.length; j++) {
                    var menuItem = menuItemsGroup.data[j];
                    htmlArr.push("<li><a class='navi-tab' id='" + menuItem.RowId + "' href='#' data-title='" + menuItem.DisplayName + "' data-url='" + menuItem.Url + "' data-modulecode='" + menuItem.ModuleCode + "' data-exp='" + menuItem.Exp + "'>" + menuItem.DisplayName + "</a></li>");
                }
                htmlArr.push("</ul></div>");
            }
            $("#menuGroupReg").append(htmlArr.join(""));
            $("#menuGroupReg").accordion({
                border: true,
                multiple: true,
                fit: true
            });
        }
    }
    var icuaId = dhccl.getQueryString("icuaId");
    $("ul.i-menugroup>li>a").each(function(index, item) {
        if ($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
        var moduleCode = $(item).attr("data-modulecode");
        var moduleId = $(item).attr("id");
        var userId = dhccl.getQueryString("userId");
        var dataUrl = $(item).attr("data-url") + "?icuaId=" + icuaId + "&userId=" + userId + "&moduleId=" + moduleId;
        var dataTitle = $(item).attr("data-title");
        var dataExp = $(item).attr("data-exp");
        var target = $(item).attr("target");

        var menuIndex = parseInt($(item).attr("data-menuindex"));
        if (dataUrl && dataUrl !== "" && dataTitle && dataTitle !== "") {
            if (target === "_blank") {
                $(item).attr("href", dataUrl);
            } else {
                $(item).attr("href", "javascript:addTab('" + dataTitle + "','" + dataUrl + "')");
            }
        }
    });

    $(".open-all").click(function() {
        var menuGroup = $(this).attr("data-menugroup"),
            selector = "ul." + menuGroup + ">li>a";
        var firstIndex = 0;
        $(selector).each(function(index, item) {
            if ($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
            var dataUrl = $(item).attr("data-url") + "?icuaId=" + icuaId;
            var dataTitle = $(item).attr("data-title");
            var menuIndex = parseInt($(item).attr("data-menuindex"));
            if (dataUrl && dataUrl !== "" && dataTitle && dataTitle !== "") {
                if (index === 0) firstIndex = index
                addTabNew(dataTitle, dataUrl, menuIndex);
            }
        });
        $("#tabsReg").tabs("select", "术前访视");
    });

    $(".close-all").click(function() {
        var menuGroup = $(this).attr("data-menugroup"),
            selector = "ul." + menuGroup + ">li>a";
        $(selector).each(function(index, item) {
            if ($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
            var dataUrl = $(item).attr("data-url") + "?icuaId=" + icuaId;
            var dataTitle = $(item).attr("data-title");
            var menuIndex = parseInt($(item).attr("data-menuindex"));
            if (dataUrl && dataUrl !== "" && dataTitle && dataTitle !== "") {
                $("#tabsReg").tabs("close", dataTitle);
            }
        });
    });
}

function selectTab(title) {
    var tabPanel = $("#tabsReg");
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var menuItem = $("#menuGroupReg").find('a[data-title="' + title + '"]');
        if (menuItem[0]) {
            if (!menuItem.find('span')[0]) menuItem.append('<span></span>');
            menuItem.find('span').click();
        }
    }
}

function addTab(title, href, closeable) {
    var tabPanel = $("#tabsReg"),
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var content = "未实现";
        if (href) {
	        if ('undefined'!==typeof websys_getMWToken){
						href += "&MWToken="+websys_getMWToken()
				}
            content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: content
        });
    }
}

function addTabNew(title, href, index, closeable) {
    var tabPanel = $("#tabsReg"),
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var content = "未实现";
        if (href) {
	         if ('undefined'!==typeof websys_getMWToken){
						href += "&MWToken="+websys_getMWToken()
				}
            content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: content,
            index: index
        });
    }
}

function closeCurrentTab() {
    var selectedTab = $("#tabsReg").tabs("getSelected"),
        selectedIndex = $("#tabsReg").tabs("getTabIndex", selectedTab);
    $("#tabsReg").tabs("close", selectedIndex);
}


$(document).ready(initPage);