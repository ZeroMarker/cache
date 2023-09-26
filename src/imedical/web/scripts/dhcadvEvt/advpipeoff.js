/// Description: 管路滑脱报告单
/// Creator: congyue
/// CreateDate: 2017-12-15
var eventtype=""
$(document).ready(function(){
	
	InitCheckRadio();			//加载界面checkbox radio 元素勾选控制
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum();  			//时间校验
	InitReport(recordId);		//加载页面信息
	GetAsseInfo();				// 赋值给页面的评价信息  cy 2018-04-17
});
// 表单控制
function ReportControl(){
	// 复选框按钮事件
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
			InitRadio(this.id);
		});
	});
	// 置管日期控制
	chkdate("TubeDate");
	
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

	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
	//护士长评价
	var HedNurEvaRecId=GetAssessRecordID("POHeaNurEvaluate");
	$("#HeadNurEvaBut").on("click",function(){
		showAssessmentWin("POHeaNurEvaluate",HedNurEvaRecId);
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
		$.messager.alert("提示:","患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！");	
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
	
	// 患者既往是否发生过管路滑脱事件 次数
	if($("input[type=radio][id='PipeOther-94517-94527']").is(':checked')){
		var PipeOthNum=$('#lablePipeOther-94517-94527 input:last-child').val();
		var TextNum=PipeOthNum.replace(/\D/g,'');
		if(TextNum.indexOf(".")< 0 && TextNum !=""){//此处控制的是如果没有小数点，首位不能为类似于 01、02的金额 
	    	TextNum= parseInt(TextNum); 
	    } 
	    if(((PipeOthNum+"")!=(TextNum+""))||(TextNum<2)){
		    $.messager.alert("提示:","【患者既往是否发生过管路滑脱事件】勾选'次数'，数据填写不规范,请填写大于1的整数！");	
			return false;
		}

	}	
	//采取措施
	var PipeTakeStepsoth=0;
	$("input[type=checkbox][id^='PipeTakeSteps']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93859'][class='lable-input']").val()=="")){
				PipeTakeStepsoth=-1;
			}
			if((this.value=="诊断性检查")&&($("#PipeTakeSteps-94536-94258").val()=="")){
				PipeTakeStepsoth=-2;
			}
		}	
	})
	if(PipeTakeStepsoth==-2){
		$.messager.alert("提示:","【采取措施】勾选'诊断性检查'，请填写内容！");	
		return false;
	}
	if(PipeTakeStepsoth==-1){
		$.messager.alert("提示:","【采取措施】勾选'其他'，请填写内容！");	
		return false;
	}
	
	//并发症 
	var PipeComploth=0,PipeCompl="",PipeList="";
	$("input[type=radio][id='PipeComplication-94540']").each(function(){
		if ($(this).is(':checked')){
			PipeCompl=this.value;
		}
	})
	if(PipeCompl=="有"){
		$("input[type=checkbox][id^='PipeComplication-94540']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PipeList=this.value
			}
		})
		if (PipeList==""){
			$.messager.alert("提示:","【并发症】勾选'有'，请勾选相应内容！");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='PipeComplication-94540-94541']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93546'][class='lable-input']").val()=="")){
				PipeComploth=-1; //出血为空
			}
		}
	})
	
	if(PipeComploth==-1){
		$.messager.alert("提示:","【并发症】勾选'出血'，请填写内容！");	
		return false;
	}
	$("input[type=checkbox][id^='PipeComplication-94540-94548']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93553'][class='lable-input']").val()=="")){
				PipeComploth=-2; //其他内容为空
			}
		}	
	})
	if(PipeComploth==-2){
		$.messager.alert("提示:","【并发症】勾选'其他'，请填写内容！");	
		return false;
	}
	// 【并发症】 '出血'
	var PipeCompNum=$('#lablePipeComplication-94540-94541 input:last-child').val()==undefined?"":$('#lablePipeComplication-94540-94541 input:last-child').val();
	if(PipeCompNum!=""){
		var TextNum=PipeCompNum.replace(/\D/g,'');
		if(TextNum.indexOf(".")< 0 && TextNum !=""){//此处控制的是如果没有小数点，首位不能为类似于 01、02的金额 
	    	TextNum= parseInt(TextNum); 
	    } 
	    if(((PipeCompNum+"")!=(TextNum+""))||(TextNum<1)){
		    $.messager.alert("提示:","【并发症】勾选'出血'，数据填写不规范,请填写大于0的整数！");	
			return false;
		}

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
	/// 事件发生时有无陪伴者在场  勾选 "无" "不知道"时 清空并隐藏 "其他"输入框
	if(id.indexOf("AccompnayNear-")>=0){
		if((id=="AccompnayNear-94998")||(id=="AccompnayNear-94999")){
			$("#AccompnayNear-94991-94996").nextAll(".lable-input").val("");
			$("#AccompnayNear-94991-94996").nextAll(".lable-input").hide();
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
	
}
//时间 数字校验
function CheckTimeorNum(){
	//入院时ADL得分
	chknum("PatAdmADLScore",1,0,100);
	$('#PatAdmADLScore').live("keyup",function(){
		RepSetRead("PatSelfCareAbility-","radio",0);  //自我照顾能力
		if((this.value>100)||(this.value=="")){
			$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='PatSelfCareAbility-94346']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='PatSelfCareAbility-94347']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='PatSelfCareAbility-94345']").click();	
		}
		RepSetRead("PatSelfCareAbility-","radio",1);  //自我照顾能力
	})
	//发生前ADL得分
	chknum("OccurADLScore",1,0,100);
	$('#OccurADLScore').live("keyup",function(){
		RepSetRead("OccurPatSelfCareAbility-","radio",0);  //自我照顾能力
		if((this.value>100)||(this.value=="")){
			$("input[type=radio][id^='OccurPatSelfCareAbility-']").removeAttr("checked");
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94240']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94241']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94239']").click();	
		}
		RepSetRead("OccurPatSelfCareAbility-","radio",1);  //自我照顾能力
	})
	// Ramsay 评分
	chknum("consciousState-94977",1,0,100);
	// RASS评分
	chknum("consciousState-94978",1,0,100);	

}

//根据科室1查询科室2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //必须设置这个属性
	});   

}

//2018-04-16 评价界面数据加载
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	var PatOutcomRecId="";//转归表单记录id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"POHeaNurEvaluate"},
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
	if((HeadNurEvaRecId!="")&&(RepStaus!="填报")){SetRepInfo(HeadNurEvaRecId,"POHeaNurEvaluate");}
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
	if(FormCode=="POHeaNurEvaluate"){
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

function SetHeadNurInfo(data){
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
		//var HNElist="\n"+"记录"+(k+1)+"："
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
	
	//var result = List.replace(/记录/g, '<font color="red">记录</font>');
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
