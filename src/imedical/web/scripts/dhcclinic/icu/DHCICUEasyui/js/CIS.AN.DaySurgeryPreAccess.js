
var anaestConsent = {
    operSchedule: null
};

var EpisodeID=dhccl.getQueryString("EpisodeID");
var OPSID="";
var opsId = dhccl.getQueryString("opsId");

if(!(opsId>0))
{
    //alert(EpisodeID)
    opsId=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOpsIdByAdmId",EpisodeID,"");
    OPSID=opsId;
}
//alert(opsId)
var operApplication="";
var sheetId="";
//session.RecordSheetID;
if(sheetId=="")
{
    session.RecordSheetID=dhccl.runServerMethodNormal("CIS.AN.BL.RecordSheet","GetRecordSheetIdByModCode",opsId,"AN_ANS_018",session.UserID);
}
//alert( sheetId+"|"+session.RecordSheetID)
$(document).ready(function() {
    $("#IsCanDayOper").combobox({
        valueField:"code",
        textField:"desc",
        editable:false,
        data:[{
            code:"Y",
            desc:"是"
        },{
            code:"N",
            desc:"否"
        }]
    });
   
    initPage();
    
});

/**
 * 调用所有页面元素初始化函数
 */
function initPage() {
    setDefaultPatInfo();
    initDelegates();
    initDefaultValue();
   
    //signCommon.loadSignature();
}
function setDefaultPatInfo()
{
	
	OPSID=opsId;
	/*
    var banner=operScheduleBanner.init('#patinfo_banner', {});
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json", true, function(appDatas) {
        if (appDatas && appDatas.length > 0) {
           
            banner.loadData(appDatas[0]);
            $("#btnOperList").hide();
            operApplication=appDatas[0];
            operDataManager.initFormData(loadApplicationData(operApplication));
            operDataManager.setCheckChange();
        }
    });
    */
     dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json", true, function(patDatas) {
             var patStr=patDatas[0];
            
              $("#PatName").prop("innerText",patStr.PatName);
              
              $("#RegNo").prop("innerText",patStr.RegNo);
             
              $("#MedcareNo").prop("innerText",patStr.MedcareNo);
            
              $("#PatAge").prop("innerText",patStr.PatAge);
             
              $("#PatDeptDesc").prop("innerText",patStr.PatDeptDesc);
              
              $("#AdmReason").prop("innerText",patStr.AdmReason);
              $("#PatGender").prop("innerText",patStr.PatGender);
              $("#PatWardDesc").prop("innerText",patStr.PatWardDesc);
             
              $("#PatBedCode").prop("innerText",patStr.PatBedCode);
                var PatGender=patStr.PatGender;
              $("#patSeximg").prop("innerText","");
              if(PatGender=="男"){
                var imghtml="<img src='../service/dhcanop/img/man.png' style='margin-top:-5px'/>";
                $("#patSeximg").append(imghtml);
            }else if(PatGender=="女"){
                var imghtml="<img src='../service/dhcanop/img/woman.png' />";
                $("#patSeximg").append(imghtml);
            }
            $("#EpisodeID").val(patStr.EpisodeID);
            $("#PatDeptID").val(patStr.PatDeptID);
            $("#PatWardID").val(patStr.PatWardID);
            $("#PatBedID").val(patStr.PatBedID);
            $("#PatDOB").val(patStr.PatDOB);
            $("#CardID").val(patStr.CardID);

            $("#AdmDate").val(patStr.AdmDate);
            operDataManager.initFormData(loadApplicationData(patStr));
            operDataManager.setCheckChange();

            })


}
/**
 * 初始化所有按钮单击事件
 */
function initDelegates() {
    
    
    $("#btnSave").linkbutton({
        onClick: function() {
			 var retAnAudit=dhccl.runServerMethodNormal("web.DHCANAdaptor","UpdateOperCircle",OPSID,session.UserID,"3");
            operDataManager.saveOperDatas();
            //$.messager.alert("提示","保存成功","info");
            
            window.parent.closePreDaySurgery();
        }
    });

    var curOpStatus=dhccl.runServerMethodNormal("CIS.AN.BL.DaySurgery","GetOpStatusCode",OPSID);
   // alert(OPSID+"|"+curOpStatus)
    if(curOpStatus!="DaySurgery")
    {
        $("#btnSave").linkbutton("disable");
        $("#btnSave").css('background-color','#555555');
    }
    $("#btnClose").linkbutton({
        onClick: function() {
            window.parent.closePreDaySurgery();
        }
    });
}

function msg(value, name) {
	var signCode = $(this).attr("id");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
            signCommon.loadSignature();
}

function initDefaultValue(){

    
}

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    //alert(operApplication)
    anaestConsent.operSchedule = operApplication;
     $("#PreAnaMethod").val(operApplication.PrevAnaMethodDesc);
    $("#PatName").text(operApplication.PatName);
    $("#PatGender").text(operApplication.PatGender);
    $("#PatAge").text(operApplication.PatAge);
    $("#PatDeptDesc").text(operApplication.PatDeptDesc);
    $("#PatBedCode").text(operApplication.PatBedCode);
    $("#MedcareNo").text(operApplication.MedcareNo);
   
   $("#PlanOperDesc").val(operApplication.PlanOperDesc);
    $("#PrevDiagnosisDesc").val(operApplication.PrevDiagnosisDesc);
   
   $("#PrevAnaMethodDesc").text(operApplication.PrevAnaMethodDesc);
    $("#OperDate").text(operApplication.OperDate);
    
}

