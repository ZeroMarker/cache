/// Description: 职业暴露- 暴露评估与治疗方案
/// Creator: 
/// CreateDate: 2019-10-31
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="",AdmID="";
var userName="";
$(document).ready(function(){
	EvaRecordId=getParam("recordId");  //表单类型id
	LinkRecordId=getParam("LinkRecordId");  //关联表单记录ID
	AuditList=getParam("AuditList");  //审核串
	CancelAuditList=getParam("CancelAuditList");  //撤销审核串
	StaFistAuditUser=getParam("StaFistAuditUser");  //第一审批人
	StsusGrant=getParam("StsusGrant");  //审核标识
	RepStaus=getParam("RepStaus");  //报告状态
	WinCode=getParam("code");  //关联表单记录code
	AdmID=getParam("AdmID");  // AdmID
	reportControl();			// 表单控制  
	InitButton();				// 初始化按钮
	InitPatInfo(AdmID);
});

//获取病人信息
function InitPatInfo(AdmID){
	if(AdmID==""){return;}
	runClassMethod("web.DHCADVCOMMON","GetPatInfoJson",{'PatNo':'','EpisodeID':AdmID},
	function(Data){ 
		var PatNo=Data.PatNo;					// 登记号
		RepSetValue("PatNo","input",PatNo);
		RepSetRead("PatNo","input",1);
		var PatAge=Data.PatAge;				// 病人年龄
		RepSetValue("PatAge","input",PatAge);
		RepSetRead("PatAge","input",1);
		var PatSex=Data.PatSex;  				// 性别
		RepSetValue("PatSexRadio","radio",PatSex);
		RepSetRead("PatSexRadio","radio",1);
		
	},"json",false);
	
};
// 表单控制
function reportControl(){
	$("#left-nav").hide();
	$("#anchor").hide();
	$("#gotop").hide();
	$("#gologin").hide();
	$("#footer").hide();
	$("#assefooter").show();
	$("#from").css({
		"margin-left":"20px",
		"margin-right":"20px"
	});
	$('#AuditMessage').hide(); //2018-06-12 cy 审批信息展现
	// 确诊时间控制
	chkdate("DiagDate");
	// 开始用药时间间控制
	chkdate("PhaStartingDate");
	// 停止用药时间控制
	chkdate("PhaEndingDate");
	
	/* //复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	}) */
	if(EvaRecordId!=""){
		//HIV评估 不可编辑
		$("#AssPeoExpToHIV input").attr("readonly",'readonly');
		$("#DiagDate").datebox({"disabled":true});
		$("#AssRemarks").attr("readonly",'readonly');
		$("#AssPeoExpToHIV input[type=radio]").attr("disabled",true);  
		//治疗方案 不可编辑
		$("#PreTreAftExposure input").attr("readonly",'readonly');
		$("#PhaStartingDate").datebox({"disabled":true});
		$("#PhaEndingDate").datebox({"disabled":true});
		$("#OccExpDrugInfo").attr("readonly",'readonly');
		$("#ModTreatPlan").attr("readonly",'readonly');
		$("#SideEffect").attr("readonly",'readonly');
		$("#PreTreAftExposure input[type=radio]").attr("disabled",true); 
		//症状 不可编辑
		$("#Symptom-Panel input[type=radio]").attr("disabled",true); 
		$("#Symptom-Panel input").attr("readonly",'readonly');
		$("#SymRemarks").attr("readonly",'readonly');
	}
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //延时点击body
        $("body").click();
    },500)
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
}
//按钮控制与方法绑定
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
}
//报告评价保存
function SaveAsse(flag)
{
	 ///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVFormRecord","SaveRecord",
		{'user':LgUserID,
		 'formId':$("#formId").val(),
		 'formVersion':$("#formVersion").val(),
		 'par':loopStr("#from"),
		 'recordId':EvaRecordId,
		 'linkRecordId':LinkRecordId
		 },
		function(datalist){ 
			var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
			if (data[0]=="0") {
				window.parent.closeRepWindow();
				window.parent.location.reload();// 2018-11-20 cy 保存报告后，刷新父界面
			}else{
				return;
			}
		},"text")
			
}

//检查界面勾选其他，是否填写输入框
function checkother(){
	if((!compareSelTowTime(trsUndefinedToEmpty($("#PhaStartingDate").datebox('getValue')),trsUndefinedToEmpty($("#PhaEndingDate").datebox('getValue'))))&&(trsUndefinedToEmpty($("#PhaEndingDate").datebox('getValue'))!="")){
		$.messager.alert("提示:","【开始用药时间】不能大于【停止用药时间】！");
		return false;
	}
	return true;
}
//未填项默认为空
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}
