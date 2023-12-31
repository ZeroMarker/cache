/**
 * 麻醉5.0数据上下文
 * @param {} opts 
 */
function SheetContext(opts){
    this.opts = opts;

    this.moduleId = null;
    this.templateId = null;
    this.sheetData = null;
    this.sheet = null;
    
    this.init();
}

SheetContext.prototype = {
    constructor : SheetContext,

    init: function(){
        this.moduleId = dhccl.getQueryString("moduleId");
        if (!this.moduleId && session){
            this.moduleId = session.ModuleID;
        }
        this.sessionData = {
            UserID : session.UserID,
            GroupID: session.GroupID,
            HospDesc : session.HospDesc,
            ArchiveServerIP : session.ArchiveServerIP,
            ArchiveServerPort : session.ArchiveServerPort,
            OPSID : session.OPSID,
            RecordSheetID: session.RecordSheetID,
            ModuleID: session.ModuleID
        };
    },

    loadSheetData: function(onSuccess, isLoadDefault){
        var $this = this;
        if (this.moduleId) {
            $.ajax({
                url: ANCSP.MethodService,
                async: true,
                data: {
                    ClassName: "DHCAN.BLL.PrintTemplate",
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
            url: '../DHCAN.BLL.PrintTemplate.cls',
            async: false,
            cache: false,
            data: {
                Action: 'SavePrintTemplate',
                RowId: $this.templateId,
                DataModule: $this.moduleId,
                JSONData: sheetDataStr,
                UpdateUser: $this.sessionData.UserID
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

        var archiveCode = dhccl.getQueryString("archiveCode");
        if(archiveCode){
            this.saveArchiveTemplate(archiveCode);
        }
    },

    saveArchiveTemplate: function(archiveCode){
        var sheetDataStr = this.getSheetDataStr();
        var ip = session.ArchiveServerIP;
        var port = session.ArchiveServerPort;
        var url = "http://" + ip + ":" + port + "/saveArchiveTemplate";
        $.ajax({
            url: url,
            async: true,
            data: {
                archiveCode: archiveCode,
                sheetDataStr: sheetDataStr
            },
            dataType: "text",
            type: "post",
            success: function (data) {
                var result = $.trim(data);
                if (result.indexOf("S^") >= 0) {
                    $.messager.popover({
                        msg: "保存归档模板成功",
                        type: "success"
                    });
                } else {
                    $.messager.alert("提示", "保存归档模板失败，原因：" + result, "error");
                }
            },
            error: function(){
                $.messager.popover({
                    msg: "保存归档模板失败",
                    type: "error"
                });
            }
        });
    },

    templateArchive: function(opts){
        var archiveServerUrl = "http://" + opts.ip + ":" + opts.port + "/templateArchives";
        var value = {
            valueObject : opts.valueObject,
            tableValuesArray : opts.tableValuesArray
        };

        $.ajax({
            url: archiveServerUrl,
            async: true,
            data: {
                "type": opts.type,
                "id": opts.id,
                "date": opts.date,
                "filename": opts.filename,
                "pageWidth": opts.pageWidth,
                "pageHeight": opts.pageHeight,
                "archiveCode": opts.archiveCode,
                "valueStr": JSON.stringify(value)
            },
            dataType: "text",
            type: "POST",
            success: function (data, textStatus) {
                $.messager.alert("提示", "归档成功" + data, "info");
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var errorMsg = archiveServerUrl + "无法连接！请检查归档服务器！";
                $.messager.alert("提示", "归档失败:" + errorMsg, "error");
            }
        });
    },

    getCommonConstData: function(){
        var appData = null;
        var opsId = this.sessionData.OPSID;
        if(opsId){
            var operAppDataArr = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.OperScheduleList,
                QueryName: "FindOperScheduleList",
                Arg1: "",
                Arg2: "",
                Arg3: "",
                Arg4: opsId,
                ArgCnt: 4
            }, "json");
            if (operAppDataArr && operAppDataArr.length && operAppDataArr.length > 0) {
                appData = operAppDataArr[0];
            }
        }
        return appData;
    },

    getUserFillData: function(){
        var recordSheetID = this.sessionData.RecordSheetID;
        var operDatas = null;
        if(recordSheetID){
            operDatas = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.OperData,
                QueryName: "FindOperDataBySheet",
                Arg1: recordSheetID,
                ArgCnt: 1
            }, "json");
        }
        return operDatas;
    },

    saveUserFillData: function(userFillData, onSave){
        if (!userFillData || !userFillData.length || userFillData.length <= 0) {
            $.messager.alert("提示", "无需要保存数据!", "info");
            return;
        }

        var recordSheetID = this.sessionData.RecordSheetID;
        var userID = this.sessionData.UserID;
        var needSaveData = [];
        for(var i = 0; i < userFillData.length; i++){
            needSaveData.push({
                RowId: userFillData[i].rowId,
                RecordSheet: recordSheetID,
                DataItem:  userFillData[i].code,
                DataItemDesc:  userFillData[i].desc,
                DataValue: userFillData[i].value,
                DataScore: userFillData[i].score,
                DataNote:  userFillData[i].dataNote,
                UpdateUserID: userID,
                ClassName: ANCLS.Model.OperData
            });
        }
        var jsonData = dhccl.formatObjects(needSaveData);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            ClassName: ANCLS.BLL.OperData,
            MethodName: "SaveOperDatas"
        }, function (data) {
            dhccl.showMessage(data, "保存", null, null, function () {
                if (onSave) onSave(data);
            });
        });
    },

    getSignatureData: function(){
        var recordSheetID = this.sessionData.RecordSheetID;
        var signatureList = null;
        if(recordSheetID){
            signatureList = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.CA.SignatureService,
                QueryName: "FindSignature",
                Arg1: recordSheetID,
                ArgCnt: 1
            }, "json");
        }
        return signatureList;
    },

    getSignImageByCode: function (signCode) {
        var signImage = "";
        var recordSheetID = this.sessionData.RecordSheetID;
        if(recordSheetID){
            signImage = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "GetSignImage", recordSheetID, signCode);
        }
        return signImage;
    },

    getSheetPermission: function(){
        var $this = this;
        var sheetElements = dhccl.getDatas(ANCSP.MethodService, {
            ClassName: ANCLS.BLL.SheetSettings,
            MethodName: "GetSheetElements",
            Arg1: $this.sessionData.ModuleID,
            Arg2: $this.sessionData.GroupID,
            Arg3: $this.sessionData.UserID,
            ArgCnt: 3
        }, "json");

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
            url: '../DHCAN.BLL.PrintTemplate.cls',
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

        var JScriptData = dhccl.runServerMethodNormal("DHCAN.BLL.PrintTemplate", "GetJScriptData", this.moduleId);
        return JScriptData;
    }
}