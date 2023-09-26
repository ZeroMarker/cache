/// Description: 医疗护理风险防范(堵漏/隐患)事件报告单
/// Creator: congyue
/// CreateDate: 2017-12-15
var eventtype=""
$(document).ready(function(){
	InitCheckRadio();			//加载界面checkbox radio 元素勾选控制
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum();  //时间校验
	InitReport(recordId);//加载页面信息
});
// 表单控制
function ReportControl(){
	// 堵漏科室
	chkcombobox("WallLoc","dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId="+LgHospID);
	// 单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
}

//按钮控制与方法绑定
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

//加载报表信息
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){	
	}else{
    	$("#from").form('validate');			
	}
}
//报告保存
function SaveReport(flag)
{
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
	//事件造成的结果   患者住院天数
	if($('#IfWLBehavior-93873').is(':checked')){
		RepSetRead("WLMan","input",0);
		RepSetRead("WLManWorkLife","input",0);
		var WallLoc=$('#WallLoc').combobox('getValue');
		RepSetRead("WallLoc","combobox",0);
		RepSetValue("WallLoc","combobox",WallLoc); 	// 堵漏人科室
		RepSetRead("WLBehavior","textarea",0);
	
	}else{
		RepSetValue("WLMan","input","");
		RepSetRead("WLMan","input",1);
		RepSetValue("WLManWorkLife","input","");
		RepSetRead("WLManWorkLife","input",1);
		RepSetRead("WallLoc","combobox",1);
		RepSetValue("WallLoc","combobox","");
		RepSetValue("WLBehavior","textarea","");
		RepSetRead("WLBehavior","textarea",1);
	}	
}

//时间 数字校验
function CheckTimeorNum(){
	//数字输入校验  WallWorkYears
	//工作年限(年)
	chknum("WLManWorkLife",1);

}

