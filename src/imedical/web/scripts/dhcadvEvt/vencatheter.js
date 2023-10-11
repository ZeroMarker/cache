/// Description:静脉导管并发症
/// Creator: hjh
/// CreateDate: 2020-12-15
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	InitReport(recordId);//加载页面信息
});

// 表单控制
function ReportControl(){
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// 置管日期
	chkdate("TubeDate");
}
//按钮控制与方法绑定
function InitButton(){
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

	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
	// 科护士长评价
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
//检查界面勾选其他，是否填写输入框
function checkother(){
	return true;
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	/// 静脉导管并发症 - 药物渗出
	if($("#CompVenousCa-3028").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3028-']").attr("disabled",false);
		$("input[type=checkbox][id^='CompVenousCa-3028-']").attr("disabled",false);
		$("input[id='CompVenousCa-3028-3042']").attr("readonly",false);
		$("input[id='CompVenousCa-3028-3803']").attr("readonly",false);
		$("input[id='CompVenousCa-3028-3804']").attr("readonly",false);
		$("input[id='CompVenousCa-3028-3805-3806']").attr("readonly",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3028-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3028-']").removeAttr("checked");
		$("input[type=checkbox][id^='CompVenousCa-3028-']").attr("disabled",true);
		$("input[type=checkbox][id^='CompVenousCa-3028-']").removeAttr("checked");
		
		$("input[id='CompVenousCa-3028-3042']").val("");
		$("input[id='CompVenousCa-3028-3803']").val("");
		$("input[id='CompVenousCa-3028-3804']").val("");
		$("input[id='CompVenousCa-3028-3805-3806']").val("");

		$("input[id='CompVenousCa-3028-3042']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3028-3803']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3028-3804']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3028-3805-3806']").attr("readonly","readonly");
	}
	
	/// 静脉导管并发症 - 静脉炎
	if($("#CompVenousCa-3029").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3029-']").attr("disabled",false);
		$("input[type=checkbox][id^='CompVenousCa-3029-']").attr("disabled",false);
		$("input[id='CompVenousCa-3029-3808']").attr("readonly",false);
		$("input[id='CompVenousCa-3029-3809']").attr("readonly",false);
		$("input[id='CompVenousCa-3029-3811']").attr("readonly",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3029-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3029-']").removeAttr("checked");
		$("input[type=checkbox][id^='CompVenousCa-3029-']").attr("disabled",true);
		$("input[type=checkbox][id^='CompVenousCa-3029-']").removeAttr("checked");
		
		$("input[id='CompVenousCa-3029-3808']").val("");
		$("input[id='CompVenousCa-3029-3809']").val("");
		$("input[id='CompVenousCa-3029-3811']").val("");

		$("input[id='CompVenousCa-3029-3808']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3029-3809']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3029-3811']").attr("readonly","readonly");
	}
	/// 静脉导管并发症 - 堵管
	if($("#CompVenousCa-3062").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3062-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3062-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3062-']").removeAttr("checked");
	}
	/// 静脉导管并发症 - 皮疹
	if($("#CompVenousCa-3063").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3063-']").attr("disabled",false);
		$("input[id='CompVenousCa-3063-3075-3076']").attr("readonly",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3063-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3063-']").removeAttr("checked");
		$("input[id='CompVenousCa-3063-3075-3076']").val("");
		$("input[id='CompVenousCa-3063-3075-3076']").attr("readonly","readonly");
	}
	/// 静脉导管并发症 - 导管破损
	if($("#CompVenousCa-3064").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3064-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3064-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3064-']").removeAttr("checked");
	}
	/// 静脉导管并发症 - 导管感染
	if($("#CompVenousCa-3065").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3065-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3065-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3065-']").removeAttr("checked");
	}
	/// 静脉导管并发症 - 脱管
	if($("#CompVenousCa-3765").is(':checked')){ 
		$("input[id='CompVenousCa-3765-3768']").attr("readonly",false);
	}else{
		$("input[id='CompVenousCa-3765-3768']").val("");
		$("input[id='CompVenousCa-3765-3768']").attr("readonly","readonly");
	}
	
	
}
//时间 数字校验
function CheckTimeorNum(){
	//时间输入校验
	// 置管时间
	chktime("TubeTime");
}
