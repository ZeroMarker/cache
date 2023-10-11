/// Description: 意外事件报告单
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
$(document).ready(function(){
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum();  			//时间校验
	InitCheckRadio();			//加载界面checkbox radio 元素勾选控制
	InitReport(recordId);		//加载页面信息
	GetAsseInfo();				// 赋值给页面的评价信息
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
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
	
}
//按钮控制与方法绑定
function InitButton(){
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //显示转归按钮		
		if(winflag==2){
			/// 评估按钮显示 意味着有评估权限，所以管路滑脱显示护士长评价按钮
			if($("#AssessmentBut").is(":visible")){ 
				$("#HeadNurEvaBut").show(); //显示评价按钮 2018-04-13 cy 评价界面
			}
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
		} 
		$("#AssessmentBut").hide(); //2019-07-26  隐藏医疗类型与没有原因分析的护理类型的评估按钮
	}
	// 护士长评价
	var HedNurEvaRecId=GetAssessRecordID("AccidentHeaNurEvaluate");  
	$("#HeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("AccidentHeaNurEvaluate",HedNurEvaRecId);
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
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
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
	if(!(checkRequired()&&checkother())){
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
	InitCheckRadio();
}
//检查界面勾选其他，是否填写输入框
function checkother(){

	//事件造成的结果
	var AFResultoth=0,AFResult="",AFResultList="";
	$("input[type=checkbox][id='AFResult-94566']").each(function(){
		if ($(this).is(':checked')){
			AFResult=this.value;
		}
	})
	if(AFResult=="患者住院天数"){
		$("input[type=radio][id^='AFResult-94566']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				AFResultList=this.value
			}
		})
		if (AFResultList==""){
			$.messager.alert($g("提示:"),$g("【事件造成的结果】勾选'患者住院天数'，请勾选相应内容！"));	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='AFResult-94567']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94097'][class='lable-input']").val()=="")){
				AFResultoth=-1; 
			}
		}
	})
	if(AFResultoth==-1){
		$.messager.alert($g("提示:"),$g("【事件造成的结果】勾选'其他'，请填写内容！"));	
		return false;
	}
	
	//患者意外事件处理经过
	var PatEventProoth=0,PatEventPro="",PatEventProList="";
	$("input[type=checkbox][id='PatEventProcess-95021']").each(function(){
		if ($(this).is(':checked')){
			PatEventPro=this.value;
		}
	})
	if(PatEventPro=="立即通知"){
		$("input[type=checkbox][id^='PatEventProcess-95021']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatEventProList=this.value
			}
		})
		if (PatEventProList==""){
			$.messager.alert($g("提示:"),$g("【患者意外事件处理经过】勾选'立即通知'，请勾选相应内容！"));	
			return false;
		}
	}
	$("input[type=checkbox][id^='PatEventProcess-95033']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94100'][class='lable-input']").val()=="")){
				PatEventProoth=-1; 
			}
		}
	})
	$("input[type=checkbox][id^='PatEventProcess-95034']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94101'][class='lable-input']").val()=="")){
				PatEventProoth=-2; 
			}
		}
	})
	
	if(PatEventProoth==-1){
		$.messager.alert($g("提示:"),$g("【患者意外事件处理经过】勾选'医疗或护理措施'，请填写内容！"));	
		return false;
	}
	if(PatEventProoth==-2){
		$.messager.alert($g("提示:"),$g("【患者意外事件处理经过】勾选'其他'，请填写内容！"));	
		return false;
	}	
	return true;
}
//勾选 radio 子元素可以勾选，取消勾选时，子元素取消勾选且不可以勾选
function InitRadio(id){

	if(id.indexOf("PatOrigin-label")>=0){
		if ((id!="PatOrigin-label-94335")){
				$('#PatAdmADLScore').val(""); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //入院时ADL得分
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //自我照顾能力
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //自我照顾能力
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
			}
	}
}

//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//患者来源
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if ((id!="PatOrigin-label-94335")){
				$('#PatAdmADLScore').val(""); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //入院时ADL得分
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //自我照顾能力
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //自我照顾能力
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
			}
		}
	})
	//事件造成的结果   无
	$("input[type=checkbox][id^='AFResult-']").each(function(){
		$(this).click(function(){
			if(this.id=='AFResult-94565'){
				$('#AFResult-94566').removeAttr("checked");
				$("input[type=radio][id^='AFResult-94566-']").removeAttr("checked");
				$('#AFResult-94567').removeAttr("checked");
				$('#AFResult-94567').nextAll(".lable-input").hide();
			}else{
				$('#AFResult-94565').removeAttr("checked");
			}
					//事件造成的结果   患者住院天数
			if($('#AFResult-94566').is(':checked')){
				$("input[type=radio][id^='AFResult-94566-']").attr("disabled",false);
			}else{
				$("input[type=radio][id^='AFResult-94566-']").removeAttr("checked");
				$("input[type=radio][id^='AFResult-94566-']").attr("disabled",true);
			}
		});
	});
}
//时间 数字校验
function CheckTimeorNum(){	
	//数字输入校验  
	
}


//2018-04-16 评价界面数据加载
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	var PatOutcomRecId="";//转归表单记录id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"AccidentHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"PatOutcomform"},
	function(data){ 
			 PatOutcomRecId=data
	},"text",false)
	if((HeadNurEvaRecId!="")&&(RepStaus!="填报")){SetRepInfo(HeadNurEvaRecId,"AccidentHeaNurEvaluate");}
	if((LocHeadNurEvaRecId!="")&&((RepStaus=="科护士长审核")||(RepStaus=="护理部审核"))){SetRepInfo(LocHeadNurEvaRecId,"LocHeaNurEvaluate");}
	if((NurDepEvaRecId!="")&&(RepStaus=="护理部审核")){SetRepInfo(NurDepEvaRecId,"NurDepEvaluate");}
	//转归数据获取
	if((PatOutcomRecId!="")){SetRepInfo(PatOutcomRecId,"PatOutcomform");}
}
//2018-04-16 给表单界面评价内容赋值
function SetRepInfo(FormRecId,FormCode){
	var data="" ;
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
		{'ADVFormRecDr':FormRecId},
		function(datalist){ 
			 data=datalist
	},"json",false)
	
	if(FormCode=="AccidentHeaNurEvaluate"){
		SetHeadNurInfo(data);
	}
	if(FormCode=="LocHeaNurEvaluate"){
		SetLocHeaNurInfo(data);
	}
	if(FormCode=="NurDepEvaluate"){
		SetNurDepInfo(data);
	}
	//转归数据赋值
	if(FormCode=="PatOutcomform"){
		SetPatOutcomInfo(data);
	}
}

function SetHeadNurInfo(data)
{
	var List="";
	var MornRepMeetDate=$g(data["MornRepMeetDate"]); //晨会报告日期
	if(MornRepMeetDate!=""){List=List+"晨会报告日期："+MornRepMeetDate+"；";}
	var MornRepMeetTime=$g(data["MornRepMeetTime"]); //晨会报告时间
	if(MornRepMeetTime!=""){List=List+"晨会报告时间："+MornRepMeetTime+"；";}
	var MornRepMeetPlace=$g(data["MornRepMeetPlace"]); //晨会地点
	if(MornRepMeetPlace!=""){List=List+"晨会地点："+MornRepMeetPlace+"；";}
	var MornRepMeetpants=$g(data["MornRepMeetpants"]); //晨会人员
	if(MornRepMeetpants!=""){List=List+"晨会人员："+MornRepMeetpants+"；";}
	var MornRepMeetContent=$g(data["MornRepMeetContent"]); //晨会内容
	if(MornRepMeetContent!=""){List=List+"晨会内容："+MornRepMeetContent+"；";}
     
	var MeetDate=$g(data["MeetDate"]); //会议日期
	if(MeetDate!=""){List=List+"\n会议日期："+MeetDate+"；";}
	var MeetTime=$g(data["MeetTime"]); //会议时间
	if(MeetTime!=""){List=List+"会议时间："+MeetTime+"；";}
	var MeetPlace=$g(data["MeetPlace"]); //会议地点
	if(MeetPlace!=""){List=List+"会议地点："+MeetPlace+"；";}
	var Participants=$g(data["Participants"]); //参会人员
	if(Participants!=""){List=List+"参会人员："+Participants+"；";}
	//原因分析
	var CauseAnalysis=$g(data["CauseAnalysis-text"]); 
	if(CauseAnalysis!=""){List=List+"\n 原因分析：\n"+CauseAnalysis;}
   
   
	//个案改进（对应要素集中原因）
	var CaseImprovement=$g(data["CaseImprovement"]); 
	if(CaseImprovement!=""){List=List+"\n个案改进（对应要素集中原因）：\n"+CaseImprovement;}

	//管理改进
	var ManaImprovement=$g(data["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",data); 
	if (ManaImprovement!=""){
		List=List+"\n管理改进：  制度、流程及规范制定或修订（"+ManaImprovementzdoth+"名称："+ManaImprovement+"）；";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",data); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		List=List+"\n管理改进："+ManaImprovementoth+"。"
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		List=List+ManaImprovementoth+"。";
	}


	// 护士长效果评价
	var ListHeadNurEva="";                       // 护士长效果评价加粗字体
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //护士长评价个数
	var HeadNurEvaluateList="护士长效果评价：";
	for(var k=0;k<HeadNurEvaluatelen;k++){
		var HNElist="\n<font style='font-Weight:bold;'>记录"+(k+1)+"</font>："
		//var HNElist="\n记录"+(k+1)+"："
		var HNEdate=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94393-94398"]); //督查时间
		if(HNEdate!=""){HNElist=HNElist+"督查时间："+HNEdate+"。";}
		var HNEobject=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94394-94399"]); //督查对象
		if(HNEobject!=""){HNElist=HNElist+"督查对象："+HNEobject+"。";}
		var HNEcontent=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94395-94400"]); //督查内容
		if(HNEcontent!=""){HNElist=HNElist+"督查内容："+HNEcontent+"。";}		
		var HNEresult=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94396-94401"]); //督查结果
		if(HNEresult!=""){HNElist=HNElist+"督查结果："+HNEresult+"。";}		
		var HNEpeople=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94397-94403"]); //督查人
		if(HNEpeople!=""){HNElist=HNElist+"督查人："+HNEpeople+"。";}		
		HeadNurEvaluateList=HeadNurEvaluateList+HNElist
	}
	if(HeadNurEvaluateList!=""){ListHeadNurEva=ListHeadNurEva+HeadNurEvaluateList;}
	
	
	var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",data); 
	if(AftImpMeasures!=""){List=List+"\n事件发生后整改措施落实效果："+AftImpMeasures+"。";}
	var AftImpMeasuresoth=$g(data["AftImpMeasures-94925-94927"]);  //未落实 未落实原因： 
	if ((AftImpMeasuresoth!="")){
		List=List+"\n事件发生后整改措施落实效果：未落实 未落实原因："+AftImpMeasuresoth+"。";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n护理记录书写："+ManaIfStandard+"。";}
		
	
	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var HNheightlen=(HNrow+HeadNurEvaluatelen)*18;
	$("#FormCauseAnalysis").css({
		"height":HNheightlen
	});		
	$('#FormCauseAnalysis').val(List);
	$('#FormCauseAnalysis').append('<div id="HeadNurEvaluate"></div>');
	$('#HeadNurEvaluate').html(ListHeadNurEva);

}

//2018-05-09 转归信息赋值
function SetPatOutcomInfo(data)
{
	//患者转归 PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	var POrow=0
	var POList=PatOutcom.split("\n")
	var POlen=POList.length;
	for(i=0;i<POlen;i++){
		POrow=POrow+parseInt(POList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var POheightlen=(POrow+1)*18;
	$("#FormPatOutcom").css({
		"height":POheightlen
	});
	$('#FormPatOutcom').val(PatOutcom);

}
