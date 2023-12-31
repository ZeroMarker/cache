/**
 * 重症数据上下文
 * @param {} opts 
 */
function SheetContext(opts){
    this.opts = opts;

    this.icuaId = null;
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
        this.icuaId = dhccl.getQueryString("icuaId");
        this.userId = dhccl.getQueryString("userId");
        this.moduleId = dhccl.getQueryString("moduleId");
        this.sheetId = dhccl.runServerMethodNormal("web.DHCICUData", "GetSheetIdByDataModule", this.moduleId, this.icuaId, this.userId);
    },

    loadSheetData: function(onSuccess, isLoadDefault){
        var $this = this;
        if (this.moduleId) {
            $.ajax({
                url: ANCSP.MethodService,
                async: true,
                data: {
                    ClassName: "web.DHCICUCPrintTemplate",
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
                            $.messager.alert("提示", "模板出现错误:" + err , "error", function(){
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
            url: '../web.DHCICUCPrintTemplate.cls',
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
        if (this.icuaId == "") {
            $.messager.alert("提示", "重症监护Id为空！", "error");
            return {};
        }
        var result = dhccl.runServerMethodNormal("web.DHCICUCom", "GetIcuaInfo", this.icuaId);
        var currentPatient = {};
        var resultArr = result.split('^');
        if (resultArr.length >= 4) {
            var patBaseInfoArr = resultArr[0].split(String.fromCharCode(3));
            if (patBaseInfoArr.length >= 25) {
                currentPatient.RegisterNo = patBaseInfoArr[0];
                currentPatient.DeptDesc = patBaseInfoArr[1];
                currentPatient.Gender = patBaseInfoArr[3];
                currentPatient.Name = patBaseInfoArr[4];
                currentPatient.BedNo = patBaseInfoArr[6];
                currentPatient.Age = patBaseInfoArr[7];
                currentPatient.WardDesc = patBaseInfoArr[8];
                currentPatient.DoctorName = patBaseInfoArr[11];
                currentPatient.MedicareNo = patBaseInfoArr[12];
                currentPatient.DOB = patBaseInfoArr[17];
            }
            if (patBaseInfoArr.length >= 27) {
                currentPatient.SecAlias = patBaseInfoArr[25];
                currentPatient.PatLevel = patBaseInfoArr[26];
            }

            var patInfoArr = resultArr[1].split(String.fromCharCode(3));
            if (patInfoArr.length >= 16) {
                currentPatient.AdmDate = patInfoArr[0];
                currentPatient.Diagnosis = patInfoArr[1];
                currentPatient.InICUDays = patInfoArr[2];
                currentPatient.EpisodeId = patInfoArr[3];
                currentPatient.WardId = patInfoArr[4];
                currentPatient.InWardDT = patInfoArr[7];
                currentPatient.IcuaId = patInfoArr[8];
                currentPatient.Height = patInfoArr[9];
                currentPatient.Weight = patInfoArr[10];
                currentPatient.PreDept = patInfoArr[11];
                currentPatient.PreWard = patInfoArr[12];
                currentPatient.ARF = patInfoArr[16];
                currentPatient.CHP = patInfoArr[17];
                if (patInfoArr.length > 18) {
                    currentPatient.ICUAResidentCtcpDr = patInfoArr[18];
                    currentPatient.ICUAAttendingCtcpDr = patInfoArr[19];
                    currentPatient.ICUASurgeryType = patInfoArr[20];
                    currentPatient.ICUAInfectedSite = patInfoArr[21];
                    currentPatient.ICUAShockType = patInfoArr[22];
                    currentPatient.ICUAEyeOpeningCLCSODr = patInfoArr[23];
                    currentPatient.ICUAVerbalResponseCLCSODr = patInfoArr[24];
                    currentPatient.ICUAMotorResponseCLCSODr = patInfoArr[25];
                    currentPatient.ICUAGlascowPoint = patInfoArr[26];
                    currentPatient.ICUAAPSPoint = patInfoArr[27];
                    currentPatient.ICUAAgePoint = patInfoArr[28];
                    currentPatient.ICUACHPPoint = patInfoArr[29];
                    currentPatient.ICUAApacheIIPoint = patInfoArr[30];
                    currentPatient.ICUADiagnosticCatCLCSODr = patInfoArr[31];
                    currentPatient.ICUADeathProbability = patInfoArr[32];

                    currentPatient.ICUALeaveCondition = patInfoArr[33]; //病人去向 20140314 whl
                    currentPatient.ICUALeaveDate = patInfoArr[34]; //出科日期20140314whl
                    currentPatient.ICUALeaveTime = patInfoArr[35]; //出科时间20140314whl

                    currentPatient.ICUAChargeNurseDr = patInfoArr[36]; //责任护士 by Lyn 20150427
                    currentPatient.ICUASupervisorNurseDr = patInfoArr[37]; //主管护士 by Lyn 20150427
                    currentPatient.ICUAHostpitalCode = patInfoArr[38]; //医院编码
                    currentPatient.ICUAResidence = patInfoArr[39]; // 住所来源
                    currentPatient.ICUAIsEstimatedHeight = patInfoArr[40]; // 是否估计身高
                    currentPatient.ICUAIsEstimatedWeight = patInfoArr[41]; // 是否估计体重
                    currentPatient.ICUAPregnant = patInfoArr[42]; // 妊娠情况
                    currentPatient.ICUAGestation = patInfoArr[43]; // 孕周
                    currentPatient.ICUADeliveryDate = patInfoArr[44]; // 分娩日期
                    currentPatient.ICUAPreDayCPR = patInfoArr[45]; // CPR
                    currentPatient.ICUASourceHospital = patInfoArr[46]; // 医院来源
                    currentPatient.ICUASourceLocationType = patInfoArr[47]; // 来源医院科室类型
                    currentPatient.ICUAPreHospitalAdmDate = patInfoArr[48]; // 入其他医院时间
                    currentPatient.ICUPMIsEstimatedBirthdate = patInfoArr[49]; // 是否估计出生日期
                    currentPatient.ICUPMEthnicity = patInfoArr[50]; //种族
                    currentPatient.ICUAArriveAssistance = patInfoArr[51]; //基础心肺疾病
                    currentPatient.ICUANoninvasVentilationHour = patInfoArr[52]; //无创呼吸机（小时）
                    currentPatient.ICUAMechanVentilationHour = patInfoArr[53]; //有创呼吸机（小时）
                    currentPatient.ICUACrrtHour = patInfoArr[54]; //CRRT（小时）
                    currentPatient.ICUAVasoactiveDrugHour = patInfoArr[55]; //血管活性药（小时）
                    currentPatient.ICUAHavePronePositionDay = patInfoArr[56]; //有俯卧位（天）
                    currentPatient.ICUAIsBrainstemDeath = patInfoArr[57]; //是否脑死亡
                    currentPatient.ICUAIsOrganDonation = patInfoArr[58]; //是否器官捐赠
                    currentPatient.ICUALimitedTreatment = patInfoArr[59]; //限制治疗
                    currentPatient.ICUANEHour = patInfoArr[60]; //去甲肾上腺素（小时）
                    currentPatient.ICUAEpiHour = patInfoArr[61]; //肾上腺素（小时）
                    currentPatient.ICUADAHour = patInfoArr[62]; //多巴胺（小时）
                    currentPatient.ICUADobuHour = patInfoArr[63]; //多巴酚丁胺（小时）
                    currentPatient.ICUASourceType = patInfoArr[64]; //收治类型
                    currentPatient.ICUWardID = patInfoArr[65]; //icu病区ID
                    currentPatient.ICULocID = patInfoArr[66]; //icu科室ID
                    currentPatient.ICULinkLocIDStr = patInfoArr[67]; //icu科室关联科室ID
                    currentPatient.InWardDays = patInfoArr[68]; //入科室天数
                    currentPatient.ICUCanRestart = patInfoArr[69]; //当前记录是否能够再开始监护
                }
            }
        }
        return currentPatient;
    },

    getUserFillData: function(){
        var icuDatas = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: "web.DHCICUData",
            QueryName: "FindICUDataBySheetId",
            Arg1: this.sheetId,
            ArgCnt: 1
        }, "json");
        return icuDatas;
    },

    saveUserFillData: function(userFillData, onSave){
        var $this = this;
        if (!userFillData || !userFillData.length || userFillData.length <= 0) {
            $.messager.alert("提示", "无需要保存数据!", "info");
            return;
        }

        var needSaveData = [];
        for(var i = 0; i < userFillData.length; i++){
            needSaveData.push({
                RowId: userFillData[i].rowId,
                ICUSheet: $this.sheetId,
                ItemCode:  userFillData[i].code,
                ItemDesc:  userFillData[i].desc ? userFillData[i].desc  : userFillData[i].code,
                ItemValue: userFillData[i].value,
                UpdateUser: $this.userId,
                Note : userFillData[i].dataNote,
            });
        }
        var jsonData = dhccl.formatObjects(needSaveData);
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: jsonData,
            ClassName: "web.DHCICUData",
            MethodName: "SaveICUDatas"
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
            url: '../web.DHCICUCPrintTemplate.cls',
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

        var JScriptData = dhccl.runServerMethodNormal("web.DHCICUCPrintTemplate", "GetJScriptData", this.moduleId);
        return JScriptData;
    }
}