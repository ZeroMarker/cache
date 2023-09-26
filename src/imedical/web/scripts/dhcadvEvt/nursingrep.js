/// Description: 护理不良事件
var RepDate=formatDate(0); //系统的当前日期
$(function(){

	InitCheckRadio();			//加载界面checkbox radio 元素勾选控制
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum();  			//时间校验
	InitReport(recordId);  		//加载报表信息  包医
});
// 表单控制
function ReportControl(){
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// 单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// 通知家属日期
	chkdate("FDIfNotiFamily-96520-96522");
	// 通知医生日期
	chkdate("FDEventDeal-96526-96529");
	// 医生看望患者日期
	chkdate("FDEventDeal-96526-96531");	
	
}
// 绑定保存提交按钮
function InitButton(){
	
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
function SaveReport(flag){
	if($('#PatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！");	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
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

//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}

//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	// 是否通知家属  是 
	if($('#FDIfNotiFamily-96520').is(':checked')){
		RepSetRead("FDIfNotiFamily-96520-96522","datebox",0);
	}else{
		RepSetRead("FDIfNotiFamily-96520-96522","datebox",1);
		RepSetValue("FDIfNotiFamily-96520-96522","datebox","");
	}
	// 是否通知家属  否 
	if($('#FDIfNotiFamily-96521').is(':checked')){
		RepSetRead("FDIfNotiFamily-96521-96524","input",0);
	}else{
		RepSetValue("FDIfNotiFamily-96521-96524","input","");
		RepSetRead("FDIfNotiFamily-96521-96524","input",1);
	}
	// 事件发生时处理  立即通知医生
	if($('#FDEventDeal-96526').is(':checked')){
		RepSetRead("FDEventDeal-96526-96529","datebox",0);
		RepSetRead("FDEventDeal-96526-96530","input",0);
		RepSetRead("FDEventDeal-96526-96531","datebox",0);
	}else{
		RepSetRead("FDEventDeal-96526-96529","datebox",1);
		RepSetValue("FDEventDeal-96526-96529","datebox","");
		RepSetValue("FDEventDeal-96526-96530","input","");
		RepSetRead("FDEventDeal-96526-96530","input",1);
		RepSetRead("FDEventDeal-96526-96531","datebox",1);
		RepSetValue("FDEventDeal-96526-96531","datebox","");
	}
		
	// 是否发生过类似事件  次数 
	if($('#FDIfOccSimEvent-96551').is(':checked')){
		$("#FDIfOccSimEvent-96551-96554").attr("readonly",false);
	}else{
		$("#FDIfOccSimEvent-96551-96554").val("");
		$("#FDIfOccSimEvent-96551-96554").attr("readonly","readonly");
	}	
}
//时间 数字校验
function CheckTimeorNum(){
	// 是否发生过类似事件  次数
	chknum("FDIfOccSimEvent-96551-96554",1,1);
	// T 体温
	chknum("PatVitSigns-96438",1);
	// P 脉搏
	chknum("PatVitSigns-96439",0);
	// R 呼吸
	chknum("PatVitSigns-96440",0);
	// BP
	checkBP("PatVitSigns-96441");

}
