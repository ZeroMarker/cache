/// 对外处理
var HisTools;

function initHisTools() {
    HisTools = new function () {
        this.closeHislinkWindow = function () {
            HisTools.hislinkWindow.closeAll();
        };
        this.refreshResFrame = function () {
            // 刷新资源区
            HisTools.dataTabs.refresh();
            HisTools.hislinkWindow.closeAll();
        };
    };
    ///  弹窗
    HisTools["hislinkWindow"] = new function() {
        this.show = function(mWidth, mHeight) {
            var closeDialogFlag = function(returnValue){
                if (returnValue){
                    if ("true" != modalDialogArgs.directOpen){
                        modalDialogArgs.confirmCallback();
                    }
                }
                modalDialogArgs = "";
            }
            
            var src = "emr.bs.op.hislink.window.csp?src="+modalDialogArgs.src+"&isShowConfirmButton=Y";
            if (!mWidth || !mHeight){
                mWidth = window.screen.availWidth - 200;
                mHeight = window.screen.availHeight - 250;
                if ("true" === modalDialogArgs.directOpen){
                    src = modalDialogArgs.src;
                }
            }
            if (src.indexOf('?') != -1) {
                src = src + '&MWToken='+getMWToken();
            } else {
                src = src + '?MWToken='+getMWToken();
            }
            var content = "<iframe id='hislinkFrame' scrolling='auto' frameborder='0' src='"+src+"' style='width:100%;height:100%;'></iframe>";
            createModalDialog(modalDialogArgs.dialogID,modalDialogArgs.title,mWidth,mHeight,"hislinkFrame",content,closeDialogFlag);
        }

        this.closeAll = function() {
            if (isExistVar(modalDialogArgs.dialogID)) {
                if (modalDialogArgs.dialogID){
                    $HUI.dialog("#"+modalDialogArgs.dialogID).close();
                }
                modalDialogArgs = "";
            }
            return;
        }

        /// 接收编辑器发出的事件，打开链接单元
        this.openUnitLink = function (args, unitLink) {
// unitLink {url,"Title":"医嘱录入","src":"","Method":"switchTabByEMR","IsDirectOpen":""}
// args {code,url,writeBack}
            function writeBack(){
                var documentID = emrService.getCurrentDocumentID();
                if ("" === documentID){
                    return;
                }
                var args = {
                    action: modalDialogArgs.method,
                    params: {
                        episodeID: patInfo.episodeID,
                        ssgroupID: patInfo.ssgroupID
                    },
                    product: envVar.product
                };
                var content = common.getLinkData(args);
                if (!content){
                    showEditorMsg({msg:"没有获取到待更新的数据！",type:"info"});
                    return;
                }
                var commandJson = emrService.updateLinkData(documentID, "", [{code: modalDialogArgs.code,writeBack: modalDialogArgs.writeBack,checked: JSON.parse(content)}]);
                if ("fail" === commandJson.result) {
                    showEditorMsg({msg:"更新"+modalDialogArgs.url+"链接单元数据失败！",type:"error"});
                    return;
                }else{
                    eventSave("updataInsByEmr","",false);
                }
            }

            modalDialogArgs = args;
            modalDialogArgs.title = unitLink.title;
            modalDialogArgs.src = replaceLinkParams(unitLink.src);
            modalDialogArgs.method = unitLink.method;
            modalDialogArgs.directOpen = unitLink.directOpen;
            modalDialogArgs.dialogID = "hislink"; // 弹窗是否关闭标识
            modalDialogArgs.confirmCallback = writeBack;
            eventSave("openUnitlink","",false);
            this.show();
        }
    };
    /// 资源区
    HisTools["dataTabs"] = new function () {
        var $dataTabs = $("#dataTabs");
        var lastSelectedDataTab = 0;

        function onSelect(title, index) {
            lastSelectedDataTab = index;
            var tab = $dataTabs.tabs("getSelected");
            if (0 === tab.find("iframe").length){
                return;
            }

            var iframe = tab.find("iframe")[0];
            if ("" == $(iframe).attr("src")) {
                if (isExistVar($(iframe).attr("src"))) {
                    $(iframe).attr("src", replaceLinkParams($(iframe).attr("lnk")));
                }
            } else {
                var iframeName = iframe.name;
                var frame = document.getElementById(iframeName).contentWindow;
                if (frame) {
                    var fnReLoadLabInfo = frame.ReLoadLabInfo;
                    if (isExistFunc(fnReLoadLabInfo)) {
                        fnReLoadLabInfo();
                    } else if ("Y" == $(iframe).attr("refreshOnSelect")) {
                        if (isExistVar($(iframe).attr("src"))) {
                            $(iframe).attr("src", replaceLinkParams($(iframe).attr("lnk")));
                        }
                    }
                }
            }
        }

        $dataTabs.tabs({
            //plain: true,
            narrow: false,
            pill: true,
            justified: true,
            onSelect: function (title, index) {
                onSelect(title, index);
            }
        });

        function addTabs(data) {
            if (!data || 0 == data.length) {
                return;
            }
            for (var idx = 0, max = data.length; idx < max; idx++) {
                var item = data[idx];
                var _content = "";
                if (isExistVar(item.content) && item.content) {
                    _content = '<iframe id="' + item.frame + '" name="' + item.frame + '" src="" style="width:100%;height:100%;"'
                    var zoom = item.zoom || '';
                    if (zoom){
                        _content += 'zoom:' + zoom + '%';
                    }
                    var scrolling = item.scrolling || "no";
                    _content += '" frameborder="0" scrolling="' + scrolling;
                    _content += '" lnk="' + item.content + '" refreshOnSelect="' + item.refreshOnSelect + '"></iframe>';
                }

                $dataTabs.tabs("add", {
                    id: item.name,
                    title: emrTrans(item.title),
                    selected: 0 == idx, //lastSelectedDataTab == idx,
                    fit: true,
                    content: _content,
                    href: item.href
                });
            };
        }
        

        addTabs(sysOption.resourceTabs);

        this.refresh = function () {
            var tabs = $dataTabs.tabs("tabs");
            for (var idx = tabs.length - 1; idx > -1; idx--) {
                $dataTabs.tabs("close",idx);
            }

            addTabs(sysOption.resourceTabs);
        }

        this.switchDataTab = function (tabName) {
            var tab = $dataTabs.tabs("getSelected");
            if (tabName === tab.panel("options").title){
                return;
            }

            $.each($dataTabs.tabs("tabs"), function (idx, item) {
                if (tabName === item.panel("options").title) {
                    $dataTabs.tabs("select", idx);
                    return false;
                }
            });
        }
        
        this.addQualityTab = function (tabName, tabData) {
            if ($dataTabs.tabs("exists",tabName)){
                $dataTabs.tabs("select",tabName);
            }else{
                if (isExistVar(tabData)) {
                    $dataTabs.tabs("add",tabData);
                }
            }
        }
    };
}

/// 平台调用
function updateEMRInstanceData(url, content, callback, episodeID) {
    //增加逻辑校验防止串患者
    if (isExistVar(episodeID)) {
        if (episodeID != patInfo.episodeID) {
            return;
        }  
    }

    var documentID = emrService.getCurrentDocumentID();
    if ("" === documentID){
        return;
    }
    var args = "";
    if ("allergic" === url){
        if (!isExistVar(content.UpdateEMR)||(true != content.UpdateEMR)){
            return;
        }
        var queryAllergiesList = "";
        if (isExistVar(content.QueryAllergiesList)){
            queryAllergiesList = content.QueryAllergiesList;
        }
        args = {
            action: "GET_ALLERGIC",
            params: {
                episodeID: patInfo.episodeID,
                queryAllergiesList: queryAllergiesList
            },
            product: envVar.product
        };
        content = common.getLinkData(args);
    }
    args = {
        url: url,
        writeBack: "replace",
        checked: JSON.parse(content)
    }
    var commandJson = emrService.updateLinkData(documentID, args);
    if ("fail" === commandJson.result) {
        showEditorMsg({msg:"更新"+url+"链接单元数据失败！",type:"error"});
        return;
    }else{
        if ("function" === typeof callBack) {
            callback();
        } else {
            eventSave("updateInsByDoc","",false);
        }
    }
}

/// 平台的方法
function invokeChartFun(tabName, funName) {
    var fn = this[funName];
    if ("function" === typeof fn) {
        var args = [];
        for (var i = 2, len = arguments.length; i < len; i++) {
            args.push(arguments[i]);
        }
        fn.apply(this, args);
    }
}

