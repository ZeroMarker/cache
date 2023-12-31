/**
 * 血透数据上下文
 * @param {} opts 
 */
function SheetContext(opts){
    this.opts = opts;

    this.bpprId = "";
    this.bpaId = "";

    this.moduleId = null;
    this.templateId = null;
    this.sheetId = null;

    this.sheetData = null;
    this.sheet = null;
    
    this.init();
}

SheetContext.prototype = {
    constructor : SheetContext,

    init: function(){
        this.bpprId = dhccl.getQueryString("bpprId");
        this.bpaId = dhccl.getQueryString("bpaId");

        if (this.bpprId === "null") this.bpprId = "";
        if (this.bpaId === "null") this.bpaId = "";

        this.userId = dhccl.getQueryString("userId");
        this.moduleId = dhccl.getQueryString("moduleId");
        this.sheetId = dhccl.runServerMethodNormal("web.DHCBPData", "GetSheetIdByDataModule", this.moduleId, this.bpprId, this.bpaId, this.userId);
    },

    loadSheetData: function(onSuccess, isLoadDefault){
        var $this = this;
        if (this.moduleId) {
            $.ajax({
                url: ANCSP.MethodService,
                async: true,
                data: {
                    ClassName: "web.DHCBPCPrintTemplate",
                    MethodName: "GetPrintTemplate",
                    Arg1: $this.moduleId,
                    ArgCnt: 1
                },
                type: "post",
                success: function (data) {
                    var result = $.trim(data);
                    if (result) {
                        var splitChar = String.fromCharCode(2);
                        $this.templateId = result.split(splitChar)[0];
                        try{
                            $this.sheetData = $.parseJSON(result.split(splitChar)[1]);
                            if(onSuccess) onSuccess($this.sheetData);
                        }catch(err){
                            console.error(err);
                            var len = result.length;
                            if(len > 100) len = 100;
                            $.messager.alert("提示", "加载数据错误，data:" + result.substring(0,len) + "...", "error", function(){
                                if(isLoadDefault){
                                    $.messager.confirm('询问','是否加载默认模板?',function(r){
                                        if (r){
                                            $this.loadDefaultSheetData(onSuccess);
                                        }
                                    });
                                }
                            });
                        }
                    } else {
                        if(isLoadDefault){
                            $this.loadDefaultSheetData(onSuccess);
                        }else{
                            $.messager.alert("提示", "无模板，请维护模板", "error");
                        }
                    }
                }
            });
        }else{
            $.messager.alert("提示", "数据模块ID为空！", "error");
        }
    },

    loadDefaultSheetData: function(onSuccess){
        $.getJSON("../service/dhcanop/data/PrintTemplate.json", function (sheetData) {
            if(onSuccess) onSuccess(sheetData);
        });
    },

    setSheetData: function(sheetData){
        this.sheetData = sheetData;
    },

    getSheetData: function(){
        return this.sheetData;
    },

    getSheetDataStr: function(){
        return JSON.stringify(this.sheetData)
    },

    saveSheetData: function(){
        if (this.moduleId == "") {
            $.messager.alert("提示", "数据模块ID为空！", "error");
            return;
        }
        var $this = this;
        var sheetDataStr = this.getSheetDataStr();
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../web.DHCBPCPrintTemplate.cls',
            async: false,
            cache: false,
            data: {
                Action: 'SavePrintTemplate',
                RowId: $this.templateId,
                DataModule: $this.moduleId,
                JSONData: sheetDataStr,
                UpdateUser: ""
            },
            success: function (ret) {
                var value = $.trim(ret);
                if(value.indexOf("S^") === 0){
                    $this.templateId = value.split('^')[1];
                    $.messager.popover({ msg: "上传成功", type: "success" });
                }else{
                    $.messager.alert("提示", "上传数据失败，原因：" + ret, "error");
                }
            },
            error: function (err) {
                $.messager.alert("提示", "上传数据失败，原因：" + err, "error");                     
            }
        });
    },

    getCommonConstData: function(){
        if ((this.bpprId == "") && (this.bpaId == "")) {
            $.messager.alert("提示", "监护Id为空！", "error");
            return {};
        }
        var result = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: "web.DHCBPCModule",
            QueryName: "FindBPArrangeById",
            Arg1: this.bpprId,
            Arg2: this.bpaId,
            ArgCnt: 2
        }, "json");
        
        if(result && result.length && result.length > 0){
            return result[0];
        }else{
            return {};
        }
    },

    getUserFillData: function(){
        var bpDatas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: "web.DHCBPData",
            QueryName: "FindBPDataBySheetId",
            Arg1: this.sheetId,
            ArgCnt: 1
        }, "json");
        if(bpDatas) return bpDatas;
        else return {}
    },

    saveUserFillData: function(userFillData, onSave){
        var $this = this;
        if (!userFillData || !userFillData.length || userFillData.length <= 0) {
            $.messager.alert("提示", "无需要保存数据!", "info");
            return;
        }

        if(this.sheetId == null || this.sheetId == ""){
            $.messager.alert("提示", "SheetId为空!", "info");
            return;
        }

        var needSaveData = [];
        for(var i = 0; i < userFillData.length; i++){
            needSaveData.push({
                RowId: userFillData[i].rowId,
                BPSheet: $this.sheetId,
                ItemCode:  userFillData[i].code,
                ItemDesc:  userFillData[i].desc,
                ItemValue: userFillData[i].value,
                UpdateUser: $this.userId,
                Note : userFillData[i].dataNote,
            });
        }
        var jsonData = dhccl.formatObjects(needSaveData);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            ClassName: "web.DHCBPData",
            MethodName: "SaveBPDatas"
        }, function (data) {
            dhccl.showMessage(data, "保存", null, null, function () {
                if (onSave) onSave(data);
            });
        });
    },

    getSignatureData: function(){
        var signatureList = null;
        return signatureList;
    },

    getSignImageByCode: function (signCode) {
        var signImage = "";
        return signImage;
    },

    getSheetPermission: function(){
        var sheetElements = [];
        return sheetElements;
    },

    saveJScriptData: function(JScriptData){
        if (this.templateId == "") {
            $.messager.alert("提示", "模板ID为空!", "error");
            return;
        }
        var $this = this;
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../web.DHCBPCPrintTemplate.cls',
            async: false,
            cache: false,
            data: {
                Action: 'SaveJScriptData',
                RowId: $this.templateId,
                JScriptData: JScriptData
            },
            success: function (ret) {
                var value = $.trim(ret);
                if(value.indexOf("S^") === 0){
                    $.messager.popover({ msg: "保存JS脚本成功", type: "success" });
                }else{
                    $.messager.alert("提示", "保存JS脚本失败，原因：" + ret, "error");
                }
            },
            error: function (err) {
                $.messager.alert("提示", "保存JS脚本失败，原因：" + err, "error");                     
            }
        });
    },

    getJScriptData: function(){
        if (this.moduleId == "") {
            $.messager.alert("提示", "数据模块ID为空!", "error");
            return;
        }

        var JScriptData = dhccl.runServerMethodNormal("web.DHCBPCPrintTemplate", "GetJScriptData", this.moduleId);
        return JScriptData;
    }
}