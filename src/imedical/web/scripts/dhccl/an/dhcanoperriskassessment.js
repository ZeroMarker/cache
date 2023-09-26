var opaId=dhccl.getUrlParam("opaId");
$(function(){
    initControls();
    initDelegates();
    if((opaId!=null)&&(opaId!=""))
    {
        var result=getPatientInfo(opaId);
        var patInfo=result.split("^");
        loadPatInfo(patInfo);
        var riskresult=getRiskAssessmentInfo(opaId);
        var riskAssessmentInfo=riskresult.split("^");
        loadRiskAssessmentInfo(riskAssessmentInfo);
    }

});
//初始化组件
function initControls(){
    var opbladetype=$HUI.combobox("#OpBladeType",{
        url:$URL+"?ClassName=web.DHCANOPRiskAssessment&QueryName=OPIncisionType&ResultSetType=array",
        valueField:"TypeId",
        textField:"TypeDesc",
        panelHeight:"auto",
        onSelect:function(record){
            var typeId=opbladetype.getValue();
            if((typeId==1)||(typeId==2))
            {
                $("#InfectedScore").val(0);
            }
            if((typeId==3)||(typeId==4))
            {
               $("#InfectedScore").val(1);
            }
            var InfectedScore=($("#InfectedScore").val()=="")?0:$("#InfectedScore").val();
            var ASAScore=($("#ASAScore").val()=="")?0:$("#ASAScore").val();
            var OpTimesScore=($("#OpTimesScore").val()=="")?0:$("#OpTimesScore").val();
            var sum=parseInt(InfectedScore)+parseInt(ASAScore)+parseInt(OpTimesScore);
            $("#SumScore").val(sum);
        },
        blurValidValue:true
    });
    var asaclass=$HUI.combobox("#ASAClass",{
        url:$URL+"?ClassName=web.DHCANOPRiskAssessment&QueryName=OPASAClass&ResultSetType=array",
        valueField:"TypeId",
        textField:"TypeDesc",
        panelHeight:"auto",
        onSelect:function(record){
            var typeId=asaclass.getValue();
            if((typeId==1)||(typeId==2))
            {
                $("#ASAScore").val(0);
            }
            if((typeId==3)||(typeId==4)||(typeId==5)||(typeId==6))
            {
               $("#ASAScore").val(1);
            }
            var InfectedScore=($("#InfectedScore").val()=="")?0:$("#InfectedScore").val();
            var ASAScore=($("#ASAScore").val()=="")?0:$("#ASAScore").val();
            var OpTimesScore=($("#OpTimesScore").val()=="")?0:$("#OpTimesScore").val();
            var sum=parseInt(InfectedScore)+parseInt(ASAScore)+parseInt(OpTimesScore);
            $("#SumScore").val(sum);
        },
        blurValidValue:true
    });
    var infected=$HUI.combobox("#Infected",{
        url:$URL+"?ClassName=web.DHCANOPRiskAssessment&QueryName=GetInfected&ResultSetType=array",
        valueField:"Id",
        textField:"Desc",
        panelHeight:"auto",
        blurValidValue:true
    });
    var optimes=$HUI.combobox("#OpTimes",{
        url:$URL+"?ClassName=web.DHCANOPRiskAssessment&QueryName=OpTimes&ResultSetType=array",
        valueField:"Id",
        textField:"Desc",
        panelHeight:"auto",
        onSelect:function(record){
            var typeId=optimes.getValue();
            if(typeId==1)
            {
                $("#OpTimesScore").val(0);
            }
            if(typeId==2)
            {
               $("#OpTimesScore").val(1);
            }
            var InfectedScore=($("#InfectedScore").val()=="")?0:$("#InfectedScore").val();
            var ASAScore=($("#ASAScore").val()=="")?0:$("#ASAScore").val();
            var OpTimesScore=($("#OpTimesScore").val()=="")?0:$("#OpTimesScore").val();
            var sum=parseInt(InfectedScore)+parseInt(ASAScore)+parseInt(OpTimesScore);
            $("#SumScore").val(sum);
        },
        blurValidValue:true
    });
    var optype=$HUI.combobox("#OPType",{
        url:$URL+"?ClassName=web.DHCANOPRiskAssessment&QueryName=GetOPType&ResultSetType=array",
        valueField:"Id",
        textField:"Desc",
        panelHeight:"auto",
        blurValidValue:true
    });
    var opdocsign=$HUI.combobox("#OpDocSign",{
        url:$URL+"?ClassName=web.DHCANCDocOperation&QueryName=FindOperationDoc&ResultSetType=array",
        valueField:"tDocId",
        textField:"tOperationDoc",
        onBeforeLoad:function(param){
            param.locDescOrId=param.q;
        },
        defaultFilter:4,
        blurValidValue:true
    });
    var andocsign=$HUI.combobox("#AnDocSign",{
        url:$URL+"?ClassName=web.UDHCANOPArrange&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param){
            param.needCtcpDesc="";
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
        },
        defaultFilter:4,
        blurValidValue:true
    });
    var circlenursesign=$HUI.combobox("#CircleNurseSign",{
        url:$URL+"?ClassName=web.UDHCANOPArrange&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param){
            param.needCtcpDesc="";
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="";
        },
        defaultFilter:4,
        blurValidValue:true
    });
}
//初始化事件信息
function initDelegates(){
    $("#btnSave").linkbutton({
	    height:30,
        onClick:saveRiskAssessmentInfo
    });
    $("#btnPrint").linkbutton({
        onClick:printRiskAssessmentInfo
    })
}

//获取手术病人手术安全核查信息
function getPatientInfo(opaId){
    var result=$.m({
        ClassName:"web.DHCANOPRiskAssessment",
        MethodName:"GetPatientInfo",
        opaId:opaId
    },false);
    return result;
}
function getRiskAssessmentInfo(opaId){
    var result=$.m({
        ClassName:"web.DHCANOPRiskAssessment",
        MethodName:"GetRiskAssessmentInfo",
        opaId:opaId
    },false);
    return result;
}
function loadPatInfo(patInfo){
    $("#PatName").val(patInfo[0]);
    $("#PatSex").val(patInfo[1]);
    $("#PatAge").val(patInfo[2]);
    $("#PatLoc").val(patInfo[3]);
    $("#PatBedNo").val(patInfo[4]);
    $("#MedCareNo").val(patInfo[5]);
    $("#PatOpName").val(patInfo[6]);
}
function loadRiskAssessmentInfo(RiskAssessmentInfo){
    var opBladeTypeStr=RiskAssessmentInfo[0];
	var opBladeTypeInfo=opBladeTypeStr.split(":");
    $("#OpBladeType").combobox('setValue',opBladeTypeInfo[1]);
    var ASAClassStr=RiskAssessmentInfo[1];
	var ASAClassInfo=ASAClassStr.split(":");
    $("#ASAClass").combobox('setValue',ASAClassInfo[1]);
    var OpTimesStr=RiskAssessmentInfo[2];
	var OpTimesInfo=OpTimesStr.split(":");
    $("#OpTimes").combobox('setValue',OpTimesInfo[1]);
    var comOPTypeStr=RiskAssessmentInfo[3];
	var comOPTypeInfo=comOPTypeStr.split(":");
    $("#OPType").combobox('setValue',comOPTypeInfo[1]);      
    var InfectedStr=RiskAssessmentInfo[4];
	var InfectedInfo=InfectedStr.split(":");
    $("#Infected").combobox('setValue',InfectedInfo[1]); 
    var opDocSignStr=RiskAssessmentInfo[5];
	var opDocSignInfo=opDocSignStr.split(":");
    $("#OpDocSign").combobox('setValue',opDocSignInfo[1]); 
    var anDocSignStr=RiskAssessmentInfo[6];
	var anDocSignInfo=anDocSignStr.split(":");
    $("#AnDocSign").combobox('setValue',anDocSignInfo[1]); 
    var circleNurseSignStr=RiskAssessmentInfo[7];
	var circleNurseSignInfo=circleNurseSignStr.split(":");
    $("#CircleNurseSign").combobox('setValue',circleNurseSignInfo[1]); 
    var InfectedscoreStr=RiskAssessmentInfo[8];
	var InfectedscoreInfo=InfectedscoreStr.split(":");
    $("#InfectedScore").val(InfectedscoreInfo[1]);
    var ASAscoreStr=RiskAssessmentInfo[9];
    var ASAscoreInfo=ASAscoreStr.split(":");
    $("#ASAScore").val(ASAscoreInfo[1]);
    var OpTimesScoreStr=RiskAssessmentInfo[10];
    var OpTimesScoreInfo=OpTimesScoreStr.split(":");
    $("#OpTimesScore").val(OpTimesScoreInfo[1]);
    var SumScoreStr=RiskAssessmentInfo[11];
    var SumScoreInfo=SumScoreStr.split(":");
    $("#SumScore").val(SumScoreInfo[1]);
    var NNISRateStr=RiskAssessmentInfo[12];
    var NNISRateInfo=NNISRateStr.split(":");
    $("#NNISRate").val(NNISRateInfo[1]);
}

function saveRiskAssessmentInfo(){
    var paraStr="opBladeType"+"$"+$("#OpBladeType").combobox("getText")+"^"+"ASAClass"+"$"+$("#ASAClass").combobox('getText')+"^"+"OpTimes"+"$"+$("#OpTimes").combobox('getText')+"^"+"comOPType"+"$"+$("#OPType").combobox("getText")+"^"+"Infected"+"$"+$("#Infected").combobox("getText")
		  +"^"+"opDocSign"+"$"+$("#OpDocSign").combobox("getText")+"^"+"anDocSign"+"$"+$("#AnDocSign").combobox('getText')+"^"+"circleNurseSign"+"$"+$("#CircleNurseSign").combobox("getText")+"^"+"Infectedscore"+"$"+$("#InfectedScore").val()+"^"+"ASAscore"+"$"+$("#ASAScore").val()
		  +"^"+"OpTimesScore"+"$"+$("#OpTimesScore").val()+"^"+"SumScore"+"$"+$("#SumScore").val()+"^"+"NNISRate"+"$"+$("#NNISRate").val();
    var result=$.m({
        ClassName:"web.DHCANOPRiskAssessment",
        MethodName:"SaveOrder",
        opaId:opaId,
        paraStr:paraStr,
        userId:session['LOGON.USERID']
    },false)
    if((result==" ")||(result==""))
    {
        $.messager.alert("提示","保存成功！","info");
        window.location.reload();
    }
}

function printRiskAssessmentInfo(){
    var lodop = getLodop();
    lodop.PRINT_INIT("打印手术风险评估");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printStyleCss = '<link rel="stylesheet" type="text/css" href="../scripts/dhccl/css/dhcanoperriskassessmentprint.css" />';
    var title = '<h2 style="margin-top:30px;text-align:center;letter-spacing:5px;">东华标准版数字化医院[总院]<br><h3 style="text-align:center;letter-spacing:5px;">手术风险评估</h3></h2>';
    $(":text").each(function(i, obj) {
        $(":text").eq(i).attr("value", obj.value);
    })
    var html = "<head>" + printStyleCss + "</head>" + "<body>" + title + $("#PatientInfoDetails").html() + $("#RiskAssessmentInfo").html() + "</body>";
    lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Width");
    lodop.ADD_PRINT_HTM(0, 0, "100%", "100%", html);
    lodop.PREVIEW();
    //lodop.PRINT ();

}