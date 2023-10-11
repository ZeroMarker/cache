$(function () {
    setSysMenuDoingSth("病历界面加载中...");
    patInfo.ipAddress = getIpAddress();
    setResize();
    initPnlButton();
    initHisTools();
    initDocumentEditor();
});

function setResize(){
    var resourceDisplay = common.getUserConfig("resourceDisplay");
    if (resourceDisplay){
        resourceDisplay = parseFloat(resourceDisplay);
    } else{
        resourceDisplay = parseFloat(sysOption.resourceDisplay);
    }
    resourceDisplay = isNaN(resourceDisplay)?((screen.availWidth) * 0.382):((resourceDisplay>1)?(resourceDisplay):(($("#main").width()) * resourceDisplay));
    $("#resRegion").panel("resize", {
        width: resourceDisplay
    });
    $("body").layout("resize");
}

function initDocumentEditor(){
    var sthmsg = "病历正在初始化...";
    setSysMenuDoingSth(sthmsg);
    try {
        emrService.initDocument();
        if (sthmsg == getSysMenuDoingSth()) {
            setSysMenuDoingSth("");
        }
    } catch (error) {
        setSysMenuDoingSth("");
        $.messager.alert("发生错误","initDocumentEditor" + error.message || error,"error");
    }
    if (!hisLog) {
        hisLog = new HisLogEx();
    }
    hisLog.login();
}

// 更新病历页面内容
function switchEMRContent(args){
    HisTools.closeHislinkWindow();
    emrService.cleanDoc();
    //全局参数替换
    patInfo.patientID = args.papmi;
    patInfo.episodeID = args.adm;
    patInfo.mradm = args.mradm;
    common.getSavedRecords();
    common.getFirstTmpl();
    common.getEMRVersionID();
    //刷新CDSS
    if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.init)){
        cdsstool.init(patInfo.episodeID,patInfo.patientID);
    }
    initDocumentEditor();
    // 刷新资源区
    HisTools.refreshResFrame();
}

///  外部接口
// 平台刷新
function xhrRefresh(refreshArgs) {
    if (refreshArgs.adm == patInfo.episodeID){
        // 医生站"总览&打印"界面上，签名按钮传入InstanceID，跳转到指定病历实例
        if ('undefined' != typeof refreshArgs.InstanceID){
            var documentID = refreshArgs.InstanceID;
            var docParam = common.getSavedRecordBydocumentID(documentID);
            if (!docParam){
                showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                return;
            }
            var tabID = docParam.docCode + "-" + docParam.documentID;
            if ("1" === docParam.serial){
                tabID = docParam.docCategoryCode;
            }
            emrTemplate.updateTabRecordByDocParam(docParam);
            var tabIndex = "";
            var tabs = emrTemplate.tmplsTabs.tabs("tabs");
            $.each(tabs, function (index,tab) {
                if (tabID === tab.panel("options").id){
                    tabIndex = index;
                    return false;
                }
            });
            if (tabIndex){
                emrTemplate.tmplsTabs.tabs("select", tabIndex);
            }
        }else{
            var currentTab = emrTemplate.tmplsTabs.tabs('getSelected');
            if (currentTab) {
                var selectIdx = emrTemplate.tmplsTabs.tabs('getTabIndex', currentTab);
                var tabRecord = emrTemplate.getTabRecord(selectIdx);
                emrTemplate.closeAllTabs();
                emrTemplate.loadTmplTabs(envVar.savedRecords, tabRecord);
            }
        }
        return;
    }
    switchEMRContent(refreshArgs);
    //emrService.saveConfirm(true,[],refreshArgs,switchEMRContent,false);
}
// 诊疗TAB切换离开时
var chartOnBlur = function () {
    eventSave("switchTab","",false);
    document.getElementById('chartOnBlur').focus();
    return true;
}

// 诊疗TAB切换进入时
var chartOnFocus = function () {
    return true;
}
// 平台调用，检查病历是否发生变化
var checkModifiedBeforeUnload = function (){
    var result = false;
    var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:[]},product: envVar.product});
    if ("fail" === command.result){
        showEditorMsg({msg:"获取待保存病历集合失败！具体原因请查看F12输出",type:"error"});
        console.log(command);
    }else{
        if (command.params){
            result = true;
        }
    }
    return result;
}

function setSysMenuDoingSth(sthmsg) {
    if ("undefined" != typeof dhcsys_getmenuform) {
        if ("undefined" != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || "";
            if ("" != DoingSth)
                DoingSth.value = sthmsg || "";
        }
    }
}

function getSysMenuDoingSth() {
    if ("undefined" != typeof dhcsys_getmenuform) {
        if ("undefined" != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || "";
            if ("" != DoingSth)
                return DoingSth.value || "";
        }
    }
    return "";
}

///在头菜单上添加回调方法，供平台调用，用以实现病历有修改时离开页面，提示是否保存
function setDoingSthSureCallback(flag) {
    var win = websys_getMenuWin();
    //设置确定取消的回调方法
    if (flag)
    {
        //平台点击确定时调用
        win.DoingSthSureCallback = function(){
            //判断保存权限||串患者
            if (isConsistent()){
                var documentID = emrService.getCurrentDocumentID();
                var rtn = privilege.getPrivilege(documentID);
                if ("1" === rtn.canSave){
                    var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:[documentID]},product: envVar.product});
                    if ("fail" === command.result){
                        showEditorMsg({msg:"获取待保存病历集合失败！具体原因请查看F12输出",type:"error"});
                        console.log(command);
                    }
                    if (command.params){
                        var docParams = common.getTemplateDataByDocumentID([documentID]);
                        if (!docParams){
                            showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                        }else{
                            // 失效签名
                            if ("Y" == sysOption.isRevokeSign){
                                emrService.doRevokeSignedDocument(docParams);
                            }else{
                                var commandJson = EmrEditor.syncExecute({action:"SAVE_DOCUMENT",product: envVar.product});
                                // 保存成功后调用
                                if ("fail" != commandJson.result) {
                                    var docParam = common.getRecordBydocumentID(commandJson.params.currentDocumentID);
                                    if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
                                        cdsstool.getData(docParam,"Save");
                                    }
                                }
                            }
                        }
                    }
                }
            }
            var win = websys_getMenuWin()
            win.DoingSthSureCallback = "";
            win.DoingSthCancelCallback = "";
            setSysMenuDoingSth("");
        }
        //平台点击取消时调用
        win.DoingSthCancelCallback = function(){
            if (envVar.lockedID){
                common.unLock(envVar.lockedDocumentID);
            }
            var win = websys_getMenuWin()
            win.DoingSthSureCallback = "";
            win.DoingSthCancelCallback = "";
            setSysMenuDoingSth("");
        };
    }
    else
    {
        win.DoingSthSureCallback = "";
        win.DoingSthCancelCallback = "";
    }
}
