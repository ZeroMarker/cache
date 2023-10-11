/// Description: 患者转运不良事件
/// Creator: guoguomin
/// CreateDate: 2017-12-15
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	InitButton();				// 初始化按钮
	ReportControl();			// 表单控制
	InitCheckRadio();
	CheckTimeorNum();		//时间校验
	InitReport(recordId);	//加载页面信息
	
});

function InitButton()
{
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //显示转归按钮		
		if(winflag==2){
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
		} 
	}
	var LocHeadNurEvaId=GetAssessRecordID("LocHeaNurEvaluate"); 
	if(LocHeadNurEvaId!=""){
		$("#LocHeadNurEvaBut").show();
	}
   	$("#LocHeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("LocHeaNurEvaluate",LocHeadNurEvaId);
	})
	// 护理部评价
	var NurDepEvaId=GetAssessRecordID("NurDepEvaluate");  
	if(NurDepEvaId!=""){
		$("#NurDepEvaBut").show();
	}
	$("#NurDepEvaBut").on("click",function(){ 
		showAssessmentWin("NurDepEvaluate",NurDepEvaId);
	})
	/// 转归界面
	$("#PatOutcomBut").on("click",function(){ 
		showPatOutcomWin("PatOutcomform");
	})
}
// 表单控制
function ReportControl(){
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
}
//加载报表信息
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');			
	} 
}
//报告保存
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！"));	
		return false;
	} 
	///保存前,对页面必填项进行检查
	 if(!checkRequired()){
		return;
	}
	SaveReportCom(flag);
}
//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	// 事件发生前用药
	$("input[type=checkbox][id^='EventBefoDrug-']").click(function(){
		var tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			if(tmpid=='EventBefoDrug-94928'){
				$("input[type=checkbox][id^='EventBefoDrug-'][id!='EventBefoDrug-94928']").removeAttr("checked");
				$('#EventBefoDrug-94932').nextAll(".lable-input").val("");
				$('#EventBefoDrug-94932').nextAll(".lable-input").hide();
			}else{
				$("input[type=checkbox][id='EventBefoDrug-94928']").removeAttr("checked");
			}
		}
	});
}

//时间 数字校验
function CheckTimeorNum(){
	// 数字输入校验
	// P 脉搏
	chknum("PatientStatus-94856-94858-94863",0);
	chknum("PatientStatus-94856-94871-94877",0);
	// R 呼吸
	chknum("PatientStatus-94856-94858-94866",0);
	chknum("PatientStatus-94856-94871-94880",0);
	// SpO2
	chknum("PatientStatus-94856-94858-94869",1,1,100);
	chknum("PatientStatus-94856-94871-94883",1,1,100);
	// BP
	checkBP("PatientStatus-94856-94858-94860");
	checkBP("PatientStatus-94856-94871-94874");
	
}
