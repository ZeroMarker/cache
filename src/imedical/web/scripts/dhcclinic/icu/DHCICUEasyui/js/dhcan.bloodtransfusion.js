$(document).ready(function () {
    initDHCCLCommon();
    var columns = [
        [{
                field: "BarCode",
                title: "储血编码",
                width: 100
            },
            {
                field: "BloodCategory",
                title: "血液种类",
                width: 120
            },
            {
                field: "ABORH",
                title: "血型",
                width: 120,
                formatter: function (value, row, index) {
                    var ret = row.BloodType;
                    if (ret && ret !== "") {
                        if (ret.indexOf("型") < 0) {
                            ret = ret + "型";
                        }
                        if (row.RH && row.RH !== "") {
                            ret = ret + " Rh(D)：" + row.RH;
                        }
                    }
                    return ret;
                }
            },
            {
                field: "Unit",
                title: "用量",
                width: 80
            },
            {
                field: "ExecProvDesc",
                title: "输血执行者",
                width: 100
            },
            {
                field: "CheckProvDesc",
                title: "核对者",
                width: 80
            },
            {
                field: "TransStartDT",
                title: "输血开始时间",
                width: 160,
                editor:{
                    type:"datetimebox"
                }
            },
            {
                field: "TransEndDT",
                title: "输血结束时间",
                width: 160,
                editor:{
                    type:"datetimebox"
                }
            },
            {
                field: "CrossMatching",
                title: "交叉配血",
                width: 100
            },
            {
                field: "MatchingProvDesc",
                title: "配血者",
                width: 80
            },
            {
                field: "GrantProvDesc",
                title: "发血者",
                width: 80
            },
            {
                field: "MatchingDT",
                title: "配血时间",
                width: 160
            },
            {
                field: "FetchProv",
                title: "取血者",
                width: 80
            },
            {
                field: "FetchDT",
                title: "取血时间",
                width: 80
            }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#bloodTransBox"),
        gridColumns: columns,
        gridTitle: "患者输血记录",
        gridTool: "#boxTool",
        form: $("#dataForm"),
        modelType: ANCLS.Model.BloodTransRecord,
        queryType: ANCLS.BLL.BloodTransfusion,
        queryName: "FindBloodTransRecord",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnSave"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        onSubmitCallBack:changeParam,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        headerCls: "panel-header-gray",
        onBeforeLoad: function (param) {
            param.Arg1 = session.RecordSheetID;
            param.ArgCnt = 1;
        },
        onLoadSuccess:function(recordDatas){
            if(recordDatas && recordDatas.rows && recordDatas.rows.length>0){
                var recordData=recordDatas.rows[0];
                $("#RetestABO").combobox("setText",recordData.ABO?recordData.ABO:"");
                $("#RetestRH").combobox("setText",recordData.RH?recordData.RH:"");
                $("#TestProv").val(recordData.TestProvDesc);
            }
        }
    });

    loadBloodTransfusion();

    $("#btnTransAppInfo").linkbutton({
        onClick: function () {
            $("#transAppDialog").dialog("open");
        }
    });

    $("#btnExecSign,#btnCheckSign").linkbutton({
        onClick: function () {
            if (dhccl.hasRowSelected($("#bloodTransBox"), true)) {
                var selectedRow = $("#bloodTransBox").datagrid("getSelected");
                var signCode = $(this).attr("data-signcode");
                var originalData = JSON.stringify(selectedRow);
                var signView = new SignView({
                    container: "#signContainer",
                    originalData: originalData,
                    signCode: signCode,
                    saveCallBack:saveSignedData
                });
                signView.initView();
                signView.open();
            }

        }
    });

    $("#btnQuery").linkbutton({
        onClick:function(){
            dataForm.datagrid.datagrid("reload");
        }
    });

    $("#BloodBarCode").focus(function(){
        try{
            bloodComm.OpenCom("COM1","115200");
            scanCode="Blood";
            // window.parent.CLCom.receiveData("test");
            // window.parent.CLCom.receiveData(window.addEquipRecord);
        }catch(ex){
            alert(ex.message);
        }
        
    });

    //dhccl.disableEditControls("#btnQuery,#btnSave,#BloodBarCode");
});

var bloodComm;
var scanCode;
function initDHCCLCommon(){
    bloodComm=document.getElementById("bloodComm");
    window.parent.closeComm(closeComm);
}

function closeComm(){
    bloodComm.CloseComm();
}

function saveSignedData(signData){
    var selectedRow = $("#bloodTransBox").datagrid("getSelected");
    var transRecord={
        RowId:selectedRow.RowId,
        ClassName:ANCLS.Model.BloodTransRecord
    };
    if(signData.SignCode==="ExecSign"){
        transRecord.ExecProvCertID=signData.UserCertID;
        transRecord.ExecTimeStamp=signData.SignTimeStamp;
        transRecord.ExecSignData=signData.SignData?signData.SignData:""
    }else if(signData.SignCode==="CheckSign"){
        transRecord.CheckProvCertID=signData.UserCertID;
        transRecord.CheckTimeStamp=signData.SignTimeStamp;
        transRecord.CheckSignData=signData.SignData?signData.SignData:""
    }
    var transRecords=[];
    transRecords.push(transRecord);
    dhccl.saveDatas(ANCSP.DataListService,{
        jsonData:dhccl.formatObjects(transRecords)
    });
}

function initDefaultValue(dataForm) {

}

function changeParam(param){
    var curDate=new Date();
    var transStartDTStr=$("#TransStartDT").datetimebox("getValue");
    var transEndDTStr=$("#TransEndDT").datetimebox("getValue");
    if(transStartDTStr && transStartDTStr!==""){
        var transStartDT=curDate.tryParse(transStartDTStr);
        if(transStartDT instanceof Date){
            param.TransStartDate=transStartDT.format("yyyy-MM-dd");
            param.TransStartTime=transStartDT.format("HH:mm:ss");
        }
    }else{
        param.TransStartDate="";
        param.TransStartTime="";
    }
    if(transEndDTStr && transEndDTStr){
        var transEndDT=curDate.tryParse(transEndDTStr);
        if(transEndDT instanceof Date){
            param.TransEndDate=transEndDT.format("yyyy-MM-dd");
            param.TransEndTime=transEndDT.format("HH:mm:ss");
        }
    }else{
        param.TransEndDate="";
        param.TransEndTime="";    
    }
    
}

function loadBloodTransfusion() {
    var transDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.BloodTransfusion,
        QueryName: "FindBloodTransfusion",
        Arg1: session.RecordSheetID,
        ArgCnt: 1
    }, "json");
    var transCmpts = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.BloodTransfusion,
        QueryName: "FindBloodTransCmpt",
        Arg1: session.RecordSheetID,
        ArgCnt: 1
    }, "json");
    if (transDatas && transDatas.length > 0) {
        var transData = transDatas[0];


        $("#ABO").text(transData.ABO ? transData.ABO : "");
        $("#RH").text(transData.RH ? transData.RH : "");
        $("#TransReason").text(transData.Purpose ? transData.Purpose : "");
        $("#TransHistory").text(transData.TransHistory ? transData.TransHistory : "");
        $("#TransNature").text(transData.Nature ? transData.Nature : "");
        $("#Diagnosis").text(transData.ABO ? transData.Diagnosis : "");
        $("#PlanTransTime").text(transData.PlanTransDT ? transData.PlanTransDT : "");
        $("#HGB").text(transData.HGB ? transData.HGB : "");
        $("#HCT").text(transData.HCT ? transData.HCT : "");
        $("#PLT").text(transData.PLT ? transData.PLT : "");
        $("#HBsAg").text(transData.HBsAg ? transData.HBsAg : "");
        $("#HBsAb").text(transData.HBsAb ? transData.HBsAb : "");
        $("#HBeAg").text(transData.HBeAg ? transData.HBeAg : "");
        $("#HBeAb").text(transData.HBeAb ? transData.HBeAb : "");
        $("#HCVAb").text(transData.HCVAb ? transData.HCVAb : "");
        $("#HIVAb").text(transData.HIVAb ? transData.HIVAb : "");
        $("#TPAb").text(transData.Syphilis ? transData.Syphilis : "");
        if (transCmpts && transCmpts.length > 0) {
            var transCmptArr = [];
            for (var i = 0; i < transCmpts.length; i++) {
                var transCmpt = transCmpts[i];
                if (transCmptArr.length > 0) transCmptArr.push(splitchar.comma);
                transCmptArr.push(transCmpt.Component + " " + transCmpt.Volume + " " + transCmpt.Unit);
            }
            $("#TransComponents").text(transCmptArr.join(splitchar.empty));
        }
    }
}