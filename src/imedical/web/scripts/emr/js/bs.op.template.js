$(function () {
    emrTemplate.tmplsTabs = $("#tmplsTabs");
    emrTemplate.tmplsTabs.tabs({
        onSelect: function (title, index) {
            if (emrTemplate.isLoading){
                return;
            }
            emrTemplate.isLoading = true;
            try {
                emrService.saveConfirm(true,[],index,function(index){
                    var docParam = emrTemplate.getTabRecord(index);
                    if (docParam){
                        emrService.loadDoc(docParam, false);
                        if (index != emrTemplate.tmplsTabs.tabs("getTabIndex",emrTemplate.tmplsTabs.tabs("getSelected"))){
                            emrTemplate.tmplsTabs.tabs("select", index);
                        }
                    }else{
                        showEditorMsg({msg:"未查到要显示的病历数据，请检查！",type:"info"});
                    }
                });
            } catch(error){
                //showEditorMsg({msg:"emrTemplate的onSelect:" + error.message || error,type:"error"});
                $.messager.alert("发生错误","emrTemplate的onSelect:" + error.message || error,"error");
            } finally {
                emrTemplate.isLoading = false;
            }
        }
    });
});

var emrTemplate = {
    tmplsTabs: null,
    isLoading: false,
    addTab: function (tabID, txt, isSelected){
        isSelected = isSelected || false;
        var isExist = false;
        var tabs = emrTemplate.tmplsTabs.tabs("tabs");
        $.each(tabs,function(index,tab){
            var id = tab.panel("options").id;
            if (id === tabID){
                isExist = true;
                if (isSelected){
                    emrTemplate.tmplsTabs.tabs("select",index);
                }
                return false;
            }
        });
        if (isExist){
            return isExist;
        }

        emrTemplate.tmplsTabs.tabs("add", {
            id: tabID,
            title: txt,
            selected: isSelected
        });
        return isExist;
    },
    selectTmplTab: function (tabID) {
        var isSelected = false;
        var tabIndex = "";
        var tabs = emrTemplate.tmplsTabs.tabs("tabs");
        $.each(tabs, function (index,tab) {
            isSelected = tabID === tab.panel("options").id;
            if (isSelected){
                tabIndex = index;
                return false;
            }
        });
        if (tabIndex){
            emrTemplate.isLoading = true;
            emrTemplate.tmplsTabs.tabs("select", tabIndex);
            emrTemplate.isLoading = false;
        }
        return isSelected;
    },
    unselectTmplTab: function () {
        var tabs = emrTemplate.tmplsTabs.tabs("tabs");
        $.each(tabs, function (index,tab) {
            emrTemplate.tmplsTabs.tabs("unselect", index);
        });
    },
    updateCurrentTitle: function() {
        /*var tab = emrTemplate.tmplsTabs.tabs("getSelected");
        var printStatus = "（已打印）";
        var newTitle = tab.panel("options").title;
        if (newTitle.indexOf(printStatus) == "-1") {
            newTitle = newTitle + printStatus;
            $("#tmplsTabs").tabs("update", {
                tab: tab,
                options: {
                    title: newTitle
                }
            });
        }*/
    },
    updateTabRecordByDocParam: function (docParam) {
        var flag = false;
        var tabID = docParam.docCode + "-" + docParam.documentID;
        if ("1" === docParam.serial){
            tabID = docParam.docCategoryCode;
        }
        $.each(envVar.savedRecords,function(index,item){
            if ("-1" != tabID.indexOf("-")) {
                flag = tabID === (item.docCode + "-" + item.documentID);
            }else{
                if ("1" != item.serial) {
                    return true;
                }
                flag = tabID === item.docCategoryCode;
            }
            if (flag) {
                envVar.savedRecords[index] = docParam;
                return false;
            }
        });
        return flag;
    },
    getTabRecord: function (index) {
        var rtn = "";
        var tab = emrTemplate.tmplsTabs.tabs("getTab", index);
        if (null == tab){
            return rtn;
        }
        var tabID = tab.panel("options").id;
        var flag = false;
        $.each(envVar.savedRecords,function(index,item){
            if ("-1" != tabID.indexOf("-")) {
                flag = tabID === (item.docCode + "-" + item.documentID);
            }else{
                if ("1" != item.serial) {
                    return true;
                }
                flag = tabID === item.docCategoryCode;
            }
            if (flag) {
                rtn = item;
                return false;
            }
        });
        return rtn;
    },
    closeCurTmplsTab: function () {
        var tab = emrTemplate.tmplsTabs.tabs("getSelected");
        if (!tab){
            return;
        }
        var index = emrTemplate.tmplsTabs.tabs("getTabIndex", tab);
        emrTemplate.tmplsTabs.tabs("close", index);
    },
    //关闭指定的tab
    closeTmplsTab: function (tmpltId, insId) {
        /*var tabId = this.getTabId(tmpltId, insId);
        var len = emrTemplate.tmplsTabs.tabs("tabs").length;
        for (var idx = len - 1; idx > -1; idx--) {
            if (this.tmplsTabs.tabs("getTab", idx).panel("options").id === tabId) {
                this.tmplsTabs.tabs("close", idx);
                return len - 1;
            }
        }*/
    },
    closeAllTabs: function () {
        emrTemplate.isLoading = true;
        try {
            var len = emrTemplate.tmplsTabs.tabs("tabs").length;
            for (var j = len - 1; j > -1; j--) {
                emrTemplate.tmplsTabs.tabs("close", j);
            }
        } catch(error){
            //showEditorMsg({msg:"emrTemplate的closeAllTabs:" + error.message || error,type:"error"});
        } finally {
            emrTemplate.isLoading = false;
        }
    },
    //加载模板Tab
    loadTmplTabs: function (savedRecords, docParam) {
        emrTemplate.isLoading = true;
        try {
            savedRecords.forEach(function(item,index){
                var tabID = item.docCode + "-" + item.documentID;
                var title = item.docName;
                var isSelected = false;
                if ("1" === item.serial){
                    tabID = item.docCategoryCode;
                    title = item.docCategoryName;
                    if ("1" === docParam.serial){
                        isSelected = tabID === docParam.docCategoryCode;
                    }
                }else{
                    isSelected = tabID === (docParam.docCode + "-" + docParam.documentID);
                }
                emrTemplate.addTab(tabID, title, isSelected);
            });
        } catch (error) {
            //showEditorMsg({msg:"emrTemplate的loadTmplTabs:" + error.message || error,type:"error"});
        } finally {
            emrTemplate.isLoading = false;
        }
    }
};