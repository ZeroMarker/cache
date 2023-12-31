var appConfig={
    operDeptList:null,
    moduleCode:"Config.OperApplication"
};

function initPage(){
    appConfig.operDeptList=getOperDeptList();
    initOperDeptConfig();
    initAppOrderOptions();
    initButtons();
    loadConfig();
}

function initOperDeptConfig(){
    if(appConfig.operDeptList){
        $(".operdept").combobox({
            valueField:"RowId",
            textField:"Description",
            data:appConfig.operDeptList
        });
    }
}

function getOperDeptList(){
    var result = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindLocationOld",
        Arg1: "",
        Arg2: "OP^EMOP^OUTOP",
        ArgCnt: 2
    }, "json");
    return result;
}

function initAppOrderOptions(){
    $("#AppArcim").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission;
            param.QueryName = "FindMasterItem";
            param.Arg1 = param.q?param.q:"";
            param.ArgCnt = 1;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });
}

function initButtons(){
    $("#btnSave").linkbutton({
        onClick:saveConfig
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });
}

function saveConfig(){
    var configFormData=$("#configForm").serializeJson();
    var moduleId=session.ModuleID;
    var configList=[];
    for(var field in configFormData){
        var dataRowId=$("#"+field).attr("data-rowid");
        var dataValue=configFormData[field];
        if(!dataRowId && !dataValue) continue;
        configList.push({
            RowId:dataRowId?dataRowId:"",
            DataKey:field,
            DataValue:dataValue?dataValue:"",
            DataModule:moduleId,
            ClassName:ANCLS.Config.DataConfig
        });
    }

    if(configList.length>0){
        dhccl.saveDatas(ANCSP.DataListService,{
            jsonData:dhccl.formatObjects(configList)
        },function(data){
            if(data.indexOf("S^")==0){
                $.messager.alert("提示","配置信息保存成功。","info");
                loadConfig();
            }else{
                $.messager.alert("提示","配置信息保存失败，原因："+data,"error");
            }
        });
    }
}

function loadConfig(){
    var configList=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.ConfigQueries,
        QueryName:"FindDataConfigurations",
        Arg1:"",
        Arg2:session.ModuleID,
        ArgCnt:2
    },"json");
    if(configList && configList.length>0){
        for(var i=0;i<configList.length;i++){
            var config=configList[i];
            var selector="#"+config.DataKey;
            if($(selector).hasClass("hisui-combobox")){
                $(selector).combobox("setValue",config.DataValue);
            }else if($(selector).hasClass("hisui-timespinner")){
                $(selector).timespinner("setValue",config.DataValue);
            }else{
                $(selector).val(config.DataValue);
            }
            $(selector).attr("data-rowid",config.RowId);
        }
    }
}

$(document).ready(initPage);