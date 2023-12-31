var operListMenu;
function initPage(){
    initMenuGroup();
}


function initMenuGroup(){
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