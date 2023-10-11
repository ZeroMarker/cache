EditPluginManager.prototype.getOperAppData = function () {
    var icuaId = dhccl.getQueryString("icuaId");

    var result = dhccl.runServerMethodNormal("web.DHCICUCom", "GetIcuaInfo", icuaId);
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
            //currentPatient.Diagnosis = patBaseInfoArr[13];
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
                currentPatient.ICUAPreHospitalAdmDate = patInfoArr[48]; // 入其他医院时�?
                currentPatient.ICUPMIsEstimatedBirthdate = patInfoArr[49]; // 是否估计出生日期
                currentPatient.ICUPMEthnicity = patInfoArr[50]; //种族
                currentPatient.ICUAArriveAssistance = patInfoArr[51]; //基础心肺疾病
                currentPatient.ICUANoninvasVentilationHour = patInfoArr[52]; //无创呼吸机（小时�?
                currentPatient.ICUAMechanVentilationHour = patInfoArr[53]; //有创呼吸机（小时�?
                currentPatient.ICUACrrtHour = patInfoArr[54]; //CRRT（小时）
                currentPatient.ICUAVasoactiveDrugHour = patInfoArr[55]; //�?管活性药（小时）
                currentPatient.ICUAHavePronePositionDay = patInfoArr[56]; //有俯卧位（天�?
                currentPatient.ICUAIsBrainstemDeath = patInfoArr[57]; //是否脑死�?
                currentPatient.ICUAIsOrganDonation = patInfoArr[58]; //是否器官捐赠
                currentPatient.ICUALimitedTreatment = patInfoArr[59]; //限制治疗
                currentPatient.ICUANEHour = patInfoArr[60]; //去甲肾上腺素（小时）
                currentPatient.ICUAEpiHour = patInfoArr[61]; //肾上腺素（小时）
                currentPatient.ICUADAHour = patInfoArr[62]; //多巴胺（小时�?
                currentPatient.ICUADobuHour = patInfoArr[63]; //多巴酚丁胺（小时�?
                currentPatient.ICUASourceType = patInfoArr[64]; //收治类型
                currentPatient.ICUWardID = patInfoArr[65]; //icu病区ID
                currentPatient.ICULocID = patInfoArr[66]; //icu科室ID
                currentPatient.ICULinkLocIDStr = patInfoArr[67]; //icu科室关联科室ID
                currentPatient.InWardDays = patInfoArr[68]; //入科室天�?
                currentPatient.ICUCanRestart = patInfoArr[69]; //当前记录是否能够再开始监�?
            }
        }
    }
    return currentPatient;
}

EditPluginManager.prototype.getOperDatas = function () {
    var sheetId = this.getICUSheetId();
    var icuDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: "web.DHCICUData",
        QueryName: "FindICUDataBySheetId",
        Arg1: sheetId,
        ArgCnt: 1
    }, "json");
    return icuDatas;
}

EditPluginManager.prototype.saveOperDatas = function (onSave) {
    var icuaId = dhccl.getQueryString("icuaId");
    var userId = dhccl.getQueryString("userId");
    var moduleId = dhccl.getQueryString("dataModuleId");
    var sheetId = this.getICUSheetId();
    if(!sheetId){
        $.messager.alert("错误","sheetId为空，不能保存！","error");
    }

    var $this = this;
    var formOperDatas = [];
    for (var i = 0; i < this.pluginList.length; i++) {
        var plugin = this.pluginList[i];
        var nowValue = plugin.getValue();
        var dataNote = "";
        if (plugin.dataSource == "OperSchedule" || plugin.dataSource == "imgsign") continue;
        if (plugin.dataSource == "barCode" || plugin.dataSource == "Signature") continue;
        if (plugin.editType == "checkbox" && plugin.areaItem.Group) continue;
        if (plugin.editType == "qrCode") continue;
        if (plugin.areaItem.GetValueMethod || plugin.areaItem.SaveValueMethod) continue;

        var rowId = plugin.RowId;
        var originalValue = plugin.originalValue;
        if (plugin.editType == "combobox") dataNote = plugin.getPrintValue();
        if (this.operAppData[plugin.code]) continue;
        if (originalValue || nowValue) {
            formOperDatas.push({
                RowId: rowId,
                ICUSheet: sheetId,
                ItemCode: plugin.code,
                ItemDesc: plugin.areaItem.Desc,
                ItemValue: nowValue,
                UpdateUser: userId,
                Note: dataNote
            });
        }
    }

    var groupList = this.getGroupCodeList();
    for (var i = 0; i < groupList.length; i++) {
        var groupCode = groupList[i];
        var groupValue = this.getGroupCheckboxValue(groupCode);
        var rowId = groupValue.rowId;
        var nowValue = groupValue.value;
        formOperDatas.push({
            RowId: rowId,
            ICUSheet: sheetId,
            ItemCode: groupCode,
            ItemDesc: groupCode,
            ItemValue: nowValue,
            UpdateUser: userId,
            Note: ""
        });
    }

    if (!formOperDatas || !formOperDatas.length || formOperDatas.length <= 0) {
        $.messager.alert("提示", "无需要保存数�?", "info");
        return;
    }

    var jsonData = dhccl.formatObjects(formOperDatas);
    dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData,
        ClassName: "web.DHCICUData",
        MethodName: "SaveICUDatas"
    }, function (data) {
        if (onSave) {
            $this.setValues();
            onSave(data);
        } else {
            dhccl.showMessage(data, "保存", null, null, function () {
                $this.setValues();
            });
        }
    });
}

EditPluginManager.prototype.getSignatureList = function () {
    return [];
}

EditPluginManager.prototype.setSheetPermission = function () {

}

EditPluginManager.prototype.getICUSheetId = function () {
    var icuaId = dhccl.getQueryString("icuaId");
    var userId = dhccl.getQueryString("userId");
    var moduleId = dhccl.getQueryString("dataModuleId");

    var sheetId = "";
    $.ajax({
        url: ANCSP.MethodService,
        async: false,
        data: {
            ClassName: "web.DHCICUData",
            MethodName: "GetSheetIdByDataModule",
            Arg1: moduleId,
            Arg2: icuaId,
            Arg3: userId,
            ArgCnt: 3
        },
        type: "post",
        success: function (data) {
            sheetId = $.trim(data);
        }
    });
    return sheetId;
}

$(initPage);

function initPage() {
    let moduleId = dhccl.getQueryString("dataModuleId");
    if (moduleId) {
        $.ajax({
            url: ANCSP.MethodService,
            async: true,
            data: {
                ClassName: "web.DHCICUCPrintTemplate",
                MethodName: "GetPrintTemplate",
                Arg1: moduleId,
                ArgCnt: 1
            },
            type: "post",
            success: function (data) {
                let result = $.trim(data);
                if (result) {
                    templateId = result.split("^")[0];
                    let sheetData = $.parseJSON(result.split("^")[1]);
                    initTemplate(sheetData);
                } else {
                    $.messager.alert("错误", "未配置打印模�?", "error");
                }
            }
        });
    }
}

function initTemplate(data) {
    var sheet = data.Sheet;

    var canvas = document.getElementById("myCanvas");
    var displaySheet = new DisplaySheet({
        canvas: canvas,
        sheet: sheet,
        editMode: true,
        onPageResize: function(){
            HIDPI();
        },
        ratio: {
            x: 14 / 12,
            y: 14 / 12,
            fontRatio: 14 / 12
        }
    });
    displaySheet.editPluginManager.setSheetPermission();

    if (displaySheet.getPageCount() > 1) {
        setPageButtonState();

        $("#btnNextPage").linkbutton({
            onClick: function () {
                var nextPageNo = displaySheet.getNextPageNo();
                if (nextPageNo) {
                    displaySheet.setCurrentPage(nextPageNo);
                }
                var currentPageNo = displaySheet.getCurrentPageNo();
                displaySheet.editPluginManager.showCurrentPageEditPlugin(currentPageNo);
                setPageButtonState();
            }
        });

        $("#btnPrePage").linkbutton({
            onClick: function () {
                var prePageNo = displaySheet.getPrePageNo();
                if (prePageNo) {
                    displaySheet.setCurrentPage(prePageNo);
                }
                var currentPageNo = displaySheet.getCurrentPageNo();
                displaySheet.editPluginManager.showCurrentPageEditPlugin(currentPageNo);
                setPageButtonState();
            }
        });
    } else {
        $("#pageInfo").hide();
        $("#btnNextPage").hide();
        $("#btnPrePage").hide();
    }

    $("#btnSave").linkbutton({
        onClick: function () {
            displaySheet.editPluginManager.saveOperDatas();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: function () {
            var valueObject = displaySheet.editPluginManager.getValueObject();
            var tableValuesArray = null;
            var lodopPrintView = window.LodopPrintView.instance;
            if (!lodopPrintView) {
                lodopPrintView = window.LodopPrintView.init({
                    sheetData: sheet,
                    valueObject: valueObject
                });
            }else{
                lodopPrintView.setPrintData(valueObject, tableValuesArray);
            }
            lodopPrintView.print();
        }
    });

    $("#btnSaveAndPrint").linkbutton({
        onClick: function () {
            displaySheet.editPluginManager.saveOperDatas(function(msg){
                if (msg.indexOf("S^") === 0){
                    $.messager.confirm('提示', "保存成功，是否打印？", function(r){
                        if (r){
                            $("#btnPrint").click();
                        }
                    });
                }else{
                    $.messager.alert("提示", "保存失败:" + msg, "error");
                }
            });
        }
    });

    $("#btnArchive").linkbutton({
        onClick: function () {
            if (!displaySheet.editPluginManager.checkRequired()) return;

            var curOperSchedule = displaySheet.editPluginManager.operAppData;
            var valueObject = displaySheet.editPluginManager.getValueObject();
            var lodopPrintView = window.LodopPrintView.instance;
            if (!lodopPrintView) {
                lodopPrintView = window.LodopPrintView.init({
                    sheetData: sheet,
                    valueObject: valueObject
                });
            }
            lodopPrintView.archive({
                ip: session.ArchiveServerIP,
                port: session.ArchiveServerPort,
                type: "AN",
                id: curOperSchedule.OPSID,
                date: curOperSchedule.OperDate,
                filename: session.ModuleDesc + ".pdf",
                patName: curOperSchedule.PatName,
                moduleName: session.ModuleDesc
            });
        }
    });

    $("#btnRefresh").linkbutton({
        onClick: function () {
            window.location.reload();
        }
    });

    $("#btnSheetSetting").linkbutton({
        onClick: function () {
            var elements = displaySheet.editPluginManager.getSheetSettingData();
            var sheetSettings = new SheetSettings({
                title: $(document).attr("title"),
                moduleId: session.ModuleID,
                elements: elements,
                closeCallBack: function () {
                    window.location.reload();
                }
            });
            sheetSettings.open();
        }
    });

    function setPageButtonState() {
        var pageInfo = "当前�? + displaySheet.getCurrentPageNo() + "�?�? + displaySheet.getPageCount() + "�?;
        $("#pageInfo").html(pageInfo);
        if (displaySheet.isFirstPage()) {
            $("#btnNextPage").linkbutton("enable");
            $("#btnPrePage").linkbutton("disable");
        } else if (displaySheet.isLastPage()) {
            $("#btnNextPage").linkbutton("disable");
            $("#btnPrePage").linkbutton("enable");
        } else {
            $("#btnNextPage").linkbutton("enable");
            $("#btnPrePage").linkbutton("enable");
        }
    }

    function HIDPI() {
        var ratio = window.devicePixelRatio || 1;
        var canvas = document.getElementById("myCanvas");
        var context = canvas.getContext("2d");
        var oldWidth = canvas.width;
        var oldHeight = canvas.height;
        canvas.width = oldWidth * ratio;
        canvas.height = oldHeight * ratio;
        canvas.style.width = oldWidth + "px";
        canvas.style.height = oldHeight + "px";
        context.scale(ratio, ratio);
    }

}