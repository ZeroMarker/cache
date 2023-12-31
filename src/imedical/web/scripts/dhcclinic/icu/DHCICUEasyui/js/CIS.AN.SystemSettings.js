var operListMenu;
function initPage(){
    initMenuGroup();
}


function initMenuGroup(){
    var menuCode = "OPSSMenu";
    var menuItems = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindMenuItemForGroup",
        Arg1: session.GroupID,
        Arg2: menuCode,
        ArgCnt: 2
    }, "json");
    if (menuItems && menuItems.length > 0) {
        var menuItemsGroups = dhccl.group(menuItems, "MainItemDesc");
        if (menuItemsGroups && menuItemsGroups.length > 0) {
            $("#menuGroupReg").accordion({
                border: false,
                // multiple: true,
                fit: true,

            });
            for (var i = 0; i < menuItemsGroups.length; i++) {
                var htmlArr = [];
                var menuItemsGroup = menuItemsGroups[i];
                if (!menuItemsGroup.id || menuItemsGroup.data.length < 1) continue;
                var firstMenuItem = menuItemsGroup.data[0];
                
                htmlArr.push("<ul class='i-menugroup'>");
                for (var j = 0; j < menuItemsGroup.data.length; j++) {
                    var menuItem = menuItemsGroup.data[j];
                    htmlArr.push("<li><a id='" + menuItem.MenuItemCode + "' href='#' data-title='" + menuItem.DisplayName + "' data-url='" + menuItem.Url + "' data-modulecode='" + menuItem.ModuleCode + "' data-exp='" + menuItem.Exp + "'>" + menuItem.DisplayName + "</a></li>");
                }
                htmlArr.push("</ul></div>");
                var opts={
                    title:firstMenuItem.MainItemDisplayName,
                    content:htmlArr.join(""),
                    // collapsible:false,
                    // collapsed:false,
                    bodyCls:"group-body",
                    border:false
                };
                if(i===0){
                    opts.tools=[{
                        iconCls:'layout-button-left',
                        handler:function(){

                        }
                    }];
                }
                $("#menuGroupReg").accordion("add",opts);
                
            }
            $("#menuGroupReg").accordion("select",0);
            //$("#menuGroupReg").append(htmlArr.join(""));
            
        }
    }
    $("ul.i-menugroup>li>a").each(function(index,item){
        if($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
        var dataUrl=$(item).attr("data-url");
        var dataTitle=$(item).attr("data-title");
        var dataExp=$(item).attr("data-exp");
        var target=$(item).attr("target");
        
        if(dataExp && dataExp!==""){
            dataUrl+=dataExp;
        }
        var menuIndex=parseInt($(item).attr("data-menuindex"));
        if(dataUrl && dataUrl!=="" && dataTitle && dataTitle!==""){
            if(target==="_blank"){
                $(item).attr("href",dataUrl);
            }else{
                $(item).attr("href","javascript:addTabNew('"+dataTitle+"','"+dataUrl+"','')");
            }
            
        }
        
    });
}


function initTabs(){
    // var opsId=dhccl.getQueryString("opsId");
    // addTab("信息总览","dhcan.totalview.csp?opsId="+opsId,false);
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

function addTabNew(title, href, index,closeable) {
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
            content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: content,
            index:index
                //href:content
        });
    }
}

function closeCurrentTab() {
    var selectedTab = $("#tabsReg").tabs("getSelected"),
        selectedIndex = $("#tabsReg").tabs("getTabIndex", selectedTab);
    $("#tabsReg").tabs("close", selectedIndex);
}

$(document).ready(initPage);