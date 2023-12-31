var appConfig = {
    operDeptList: null,
    moduleCode: "Config.OperApplication"
};

function initPage() {
    appConfig.operDeptList = getOperDeptList();
    initOperDeptConfig();
    initAppOrderOptions();
    // initLocalAnaType();
    initButtons();
    loadConfig();
}

function initOperDeptConfig() {
    if (appConfig.operDeptList) {
        $(".operdept").combobox({
            valueField: "RowId",
            textField: "Description",
            data: appConfig.operDeptList
        });
    }
}

function getOperDeptList() {
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindLocationOld",
        Arg1: "",
        Arg2: "OP^EMOP^OUTOP",
        Arg3: session.HospID,
        ArgCnt: 3
    }, "json");
    return result;
}

function initAppOrderOptions() {
    $("#AppArcim").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMasterItem";
            param.Arg1 = param.q ? param.q : "";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });
    $("#OperQualificationCareType").combobox({
        valueField:"RowId",
        textField:"Description",
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=CLCLS.BLL.Admission;
            param.QueryName="FindCarPrvTp";
            param.ArgCnt=0;
        },
        multiple:true,
        rowStyle:"checkbox"
    });
}

function initLocalAnaType() {
    $("#LocalAnaType").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindAnaestType";
            param.ArgCnt = 0;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        multiple: true,
        rowStyle: "checkbox"
    });
}

function initButtons() {
    $("#btnSave").linkbutton({
        onClick: saveConfig
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            window.location.reload();
        }
    });
}

function saveConfig() {
    var configFormData = $("#configForm").serializeJson();
    var moduleId = session.ModuleID;
    var configList = [];
    for (var field in configFormData) {
        var dataRowId = $("#" + field).attr("data-rowid");
        var dataValue = configFormData[field];
        if (!dataRowId && !dataValue) continue;
        if (field == "AppArcim") { //手术申请医嘱赋值需特殊处理  YuanLin 20210106
            var AppArcimId = dhccl.runServerMethodNormal(ANCLS.BLL.ConfigQueries, "GetAppArcimIdByDesc", dataValue);
            if (AppArcimId !== "") dataValue = AppArcimId;
        }
		if (field == "OperQualificationCareType"){
			var CareTypeArr=$("#OperQualificationCareType").combobox("getValues");
            dataValue = CareTypeArr.join(",");
        }
        configList.push({
            RowId: dataRowId ? dataRowId : "",
            DataKey: field,
            DataValue: dataValue ? dataValue : "",
            DataModule: moduleId,
            ClassName: ANCLS.Config.DataConfig,
            HospitalID: session.HospID
        });
    }

    if (configList.length > 0) {
        dhccl.saveDatas(ANCSP.DataListService, {
            jsonData: dhccl.formatObjects(configList)
        }, function(data) {
            if (data.indexOf("S^") == 0) {
                $.messager.alert("提示", "配置信息保存成功。", "info");
                loadConfig();
            } else {
                $.messager.alert("提示", "配置信息保存失败，原因：" + data, "error");
            }
        });
    }
}

function loadConfig() {
    var configList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindDataConfigurations",
        Arg1: "",
        Arg2: session.ModuleID,
        Arg3: session.HospID,
        ArgCnt: 3
    }, "json");
    if (configList && configList.length > 0) {
        for (var i = 0; i < configList.length; i++) {
            var config = configList[i];
            var selector = "#" + config.DataKey;
            if ($(selector).hasClass("hisui-combobox")) {
                $(selector).combobox("setValue", config.DataValue);
                if (config.DataKey == "AppArcim") { //手术申请医嘱赋值需特殊处理,否则前台显示医嘱Id YuanLin 20210106
                    var AppArcimDesc = dhccl.runServerMethodNormal(ANCLS.BLL.ConfigQueries, "GetAppArcimDesc", config.DataValue);
                    if (AppArcimDesc !== "") $(selector).combobox("setValue", AppArcimDesc);
                }
				if (config.DataKey == "OperQualificationCareType"){
					var CareTypeArr=config.DataValue.split(",");
					$("#OperQualificationCareType").combobox("setValues",CareTypeArr);
				}
            } else if ($(selector).hasClass("hisui-timespinner")) {
                $(selector).timespinner("setValue", config.DataValue);
            } else {
                $(selector).val(config.DataValue);
            }
            $(selector).attr("data-rowid", config.RowId);
        }
    }
}

$(document).ready(initPage);