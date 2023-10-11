/// Description: 压疮报告单
/// Creator: congyue
/// CreateDate: 2017-12-19
var eventtype="";
var PatOrignin="",PatOrignout="";
$(document).ready(function(){
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum(); 	 		//时间校验
	InitCheckRadio();			//加载界面checkbox radio 元素勾选控制
	InitReport(recordId);		//加载页面信息
	GetAsseInfo();				// 赋值给页面的评价信息 cy 2018-04-17
	
});
// 表单控制
function ReportControl(){
	
	//压疮部位  来源 院外带入 labelUlcerPart-95158-95163-95170
	$("input[type=radio][id^='UlcerPart-95158-95163-95170.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrignin=this.value;
		}
	});
	$("input[type=radio][id^='UlcerPart-95158-95163-95171.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrignout=this.value;
		}
	});	
	
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});	
	//部位 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	})

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
	var HedNurEvaRecId=""; 
	if(PatOrignin=="院内发生"){
		HedNurEvaRecId=GetAssessRecordID("UlcerHeaNurEvaluate");
	}
	if(PatOrignout=="院外带入"){
		HedNurEvaRecId=GetAssessRecordID("UlcOutHeaNurEvaluate");
	}
	$("#HeadNurEvaBut").on("click",function(){ 
		if(PatOrignin=="院内发生"){
			showAssessmentWin("UlcerHeaNurEvaluate",HedNurEvaRecId);
		}
		if(PatOrignout=="院外带入"){
			showAssessmentWin("UlcOutHeaNurEvaluate",HedNurEvaRecId);
		}
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
		showPatOutcomWin("UlcPatOutcomform");
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
	 if(!(checkother()&&checkRequired())){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}
	SaveReportCom(flag);
}
//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	// 2021-05-25 cy str
	runClassMethod("web.DHCADVCOMMON","GetNurMarkInfo",{'EpisodeID':EpisodeID},
	function(Data){ 
		if(Data!=""){
			var dataarr=Data.replace(/(^\s*)|(\s*$)/g,"").split("$$");
			var HospScoreList=dataarr[2]; // 入院时压疮分析评分表 ^ 评分
			var OccScoreList=dataarr[3]; // 发生时压疮分析评分表 ^ 评分
			var UseUlcerRiskpointtab=HospScoreList.split("^")[0];				// 压疮风险评分表
			if((UseUlcerRiskpointtab!="")&&(UseUlcerRiskpointtab!=undefined)){
				RepSetValue("UseUlcerRiskpointtab","radio",UseUlcerRiskpointtab);
				RepSetRead("UseUlcerRiskpointtab","radio",1);
			}else {
				RepSetValue("UseUlcerRiskpointtab","radio","");
				RepSetRead("UseUlcerRiskpointtab","radio",0);
			}
				
			var HospUlcerRiskScore=HospScoreList.split("^")[1];					// 入院时压疮评分
	      	if((HospUlcerRiskScore!="")&&(HospUlcerRiskScore!=undefined)){
				RepSetValue("HospUlcerRiskScore","input",HospUlcerRiskScore);
				RepSetRead("HospUlcerRiskScore","input",1);	
				ChkHospUlcerRiskLev(HospUlcerRiskScore);
			}else {
				RepSetValue("HospUlcerRiskScore","input","");
				RepSetRead("HospUlcerRiskScore","input",0);		
			}	
			var OccurUlcerRiskScore=OccScoreList.split("^")[1];					// 发生时压疮评分
	      	if((OccurUlcerRiskScore!="")&&(OccurUlcerRiskScore!=undefined)){
				RepSetValue("OccurUlcerRiskScore","input",OccurUlcerRiskScore);
				RepSetRead("OccurUlcerRiskScore","input",1);		
				ChkOccurUlcerRiskLev(OccurUlcerRiskScore);
			}else {
				RepSetValue("OccurUlcerRiskScore","input","");
				RepSetRead("OccurUlcerRiskScore","input",0);		
			}
		}	
	
	},"text",false);
	// 2021-05-25 cy end
	$("#from").form('validate'); 
	InitCheckRadio();
}
//检查界面勾选其他，是否填写输入框
function checkother(){
	
	//压疮部位  来源 院外带入 labelUlcerPart-95158-95163-95170
	var PatOrign="",PatOrignList="",OrignErr="";
	 $("input[type=radio][id^='UlcerPart-95158-95163-95170.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrign=this.value;
		}
	});
		
	$("input[type=radio][id^='UlcerPart-95158-95163-']").each(function(){
		if ($(this).is(':checked')){
			if(this.id.split("-").length==4){
				var PatOrignList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				PatOrign=this.value;
				
				$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatOrignList=this.value
					}
				});
				if((radiorowid=="UlcerPart-95158-95163-95171")&&(PatOrignList=="")){
					$.messager.alert($g("提示:"),$g("【压疮来源】勾选【院外带入】，请勾选院外相应内容！"));	
					OrignErr=-1;
					return false;
				}		
				
			}
		}
	});
	if (PatOrign==""){
		$.messager.alert($g("提示:"),$g("【压疮来源】未勾选，请勾选相应内容！"));	
		OrignErr=-1;
		return false;
	}
	if(OrignErr=="-1"){
		return false;
	}
	//压疮部位 部位   
	var PatReason="",PartErr=0,radiorownum="";
	$("input[type=radio][id^='UlcerPart-95158-95166-']").each(function(){
		if(this.id.split("-").length==4){
			var PatReasonList="";
			if ($(this).is(':checked')){
				var radiorowid=this.id.split(".")[0];
				radiorownum=this.id.split(".")[1];
				PatReason=this.value;
				$("input[type=checkbox][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatReasonList=this.value
					}
				});
				if((PatReason=="title")&&($("input[name$='.93932."+radiorownum+"'][class='lable-input']").val()=="")){ //UlcerPart-95158-95166-95182
					$.messager.alert($g("提示:"),$g("【压疮部位】勾选其他，请填写相应内容！"));	
					PartErr=-1;
					return false;
				}		
				if ((PatReason!="枕部")&&(PatReason!="骶尾部")&&(PatReason!="title")&&(PatReasonList=="")){
					$.messager.alert($g("提示:"),$g("【压疮部位】勾选'"+PatReason+"'，请勾选相应内容！"));	
					PartErr=-1;
					return false;
				}
				
			 }
		}
	});
	if(PartErr=="-1"){
		return false;
	}
	if(PatReason==""){
		$.messager.alert($g("提示:"),$g("【压疮部位】未勾选内容，请勾选相应内容！"));	
		return false;
	}
	
	return true;
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
				$('#HospUlcerRiskScore').val(""); // 入院压疮风险评分
				$('#HospUlcerRiskScore').css("background-color","#D4D0C8");
				$('#HospUlcerRiskScore').attr("readonly","readonly"); // 入院压疮风险评分
				$("label[data-parref='HospUlcerRiskLev']").css("color","#D4D0C8")
				$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");  // 压疮风险等级
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",true);  // 压疮风险等级
				
			}else{
				$('#PatAdmADLScore').attr("readonly",false); // 入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
				$('#HospUlcerRiskScore').attr("readonly",false); // 入院压疮风险评分
				$('#HospUlcerRiskScore').css("background-color","#fff");
				$("label[data-parref='HospUlcerRiskLev']").css("color","#000")
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",false);  // 压疮风险等级
			}
		}
	})
	//压疮部位  来源
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",false);

	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",true);
	}	
	//耳廓
	if($("input[type=radio][id^='UlcerPart-95158-95166-95173.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",true);
	}
	//肩胛部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95174.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",true);
	}	
	//肘部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95175.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",true);
	}
	 //髂前上棘
	if($("input[type=radio][id^='UlcerPart-95158-95166-95176.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",true);
	}
	//髋部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95177.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",true);
	}
	//膝部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95179.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",true);
	}
	//踝部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95180.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",true);
	}
	//足跟部
	if($("input[type=radio][id^='UlcerPart-95158-95166-95181.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",true);
	}
	//其他
	if($("input[type=radio][id^='UlcerPart-95158-95166-95182.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93730'][class='lable-input']").val("");  //清空其他内容
		$("input[name$='.93730'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93730'][class='lable-input']").hide();  
	}		
}
//勾选 radio 子元素可以勾选，取消勾选时，子元素取消勾选且不可以勾选
function InitRadio(id){
	//来源  院外带入 
	var radiorowid=id.split(".")[0];
	var radiorownum=id.split(".")[1];
	//压疮部位  来源
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.'][id$='"+radiorownum+"']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").removeAttr("checked");
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",true);
	}
	 //部位 
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	if(checkrowid.indexOf("95166")>0){
		if($("input[type=radio][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").is(':checked')){
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
			$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").removeAttr("checked");
			if (checkrowid!=="UlcerPart-95158-95166-95182"){
				$("input[name$='.93932."+checkrownum+"'][class='lable-input']").val("");  //清空其他内容
				$("input[name$='.93932."+checkrownum+"'][class='lable-input']").hide();  
			}
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
			$("input[type=checkbox][id^='"+checkrowid+"'][id$='."+checkrownum+"']").attr("disabled",false);
			
		}else{
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
		} 	 
	}
	// 患者来源
	if(id.indexOf("PatOrigin-label")>=0){
		if ((id!="PatOrigin-label-94335")){
				$('#PatAdmADLScore').val(""); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //入院时ADL得分
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //自我照顾能力
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //自我照顾能力
				$('#HospUlcerRiskScore').val(""); // 入院压疮风险评分
				$('#HospUlcerRiskScore').css("background-color","#D4D0C8");
				$('#HospUlcerRiskScore').attr("readonly","readonly"); // 入院压疮风险评分
				$("label[data-parref='HospUlcerRiskLev']").css("color","#D4D0C8")
				$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");  // 压疮风险等级
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",true);  // 压疮风险等级
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //入院时ADL得分
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //自我照顾能力
				$('#HospUlcerRiskScore').attr("readonly",false); // 入院压疮风险评分
				$('#HospUlcerRiskScore').css("background-color","#fff");
				$("label[data-parref='HospUlcerRiskLev']").css("color","#000")
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",false);  // 压疮风险等级
			}
	}
	
	//使用压疮评分表
	if (id.indexOf("UseUlcerRiskpointtab-")>=0){
		$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
		RepSetValue("HospUlcerRiskScore","input","");
		$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
		RepSetValue("OccurUlcerRiskScore","input","");
	}
	
	
}
function InitCheck(id){
	
	
}

//时间 数字校验
function CheckTimeorNum(){
	//数字输入校验  
	//压疮面积 UlcerPart-95158-95189-94247
	chknum("UlcerPart-95158-95189-94247",1);
	chknum("UlcerPart-95158-95189-94249",1);
	chknum("UlcerPart-95158-95189-94251",1);
	
	// 手术 小时
	chknum("OpeDuration",1,0);
	// 使用压疮风险评分表  
	// 入院压疮风险评分 
	chknum("HospUlcerRiskScore",0);
	$('#HospUlcerRiskScore').live("keyup",function(){
		ChkHospUlcerRiskLev(this.value);
	})
		
	// 发生压疮时风险评分
	chknum("OccurUlcerRiskScore",0);
	$('#OccurUlcerRiskScore').live("keyup",function(){
		ChkOccurUlcerRiskLev(this.value);
	})

}

function add_event(){
	AllStyle("textarea","",100);
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	CheckTimeorNum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	
	//来源  院外带入 
	var orign="";
	$("input[type=radio][id^='UlcerPart-95158-95163']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			orign=this.value;
			var list=$("input[type=radio][id^='UlcerPart-95158-95163-95170."+checkrownum+"']:checked").val();
			if((this.id.split("-").length==4)){
				$("input[type=radio][id^='"+checkrowid+".']").click();		
			}else if(this.id.split("-").length==5){
				$("input[type=radio][id^='"+checkrowid+"']").click();
			}
		}
	})
	
	//部位 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	}) 
}

//根据科室1查询科室2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //必须设置这个属性
	});   

}

//检查table中的必填
//如果填写了长款高，后面的信息都为必填，除了气味
function checkTableRequired(){
	var errMsg=""
	
	$("#UlcerPart").next().find("tbody tr").each(function(i){
		var rowMsg=""
		// 来源
		var str=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(0));
		if(str.length==0){
			rowMsg=rowMsg+"来源,"
		}
		// 部位
		var str1=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(1));
		if(str1.length==0){
			rowMsg=rowMsg+"部位,"
		}
		// 压疮分期
		var str2=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(2));
		if(str2.length==0){
			rowMsg=rowMsg+"压疮分期,"
		}
		// 面积
		var str3=$(this).children('td').eq(3).find("input").val()
		if(str3.length==0){
			rowMsg=rowMsg+"面积,"
		}
		// 颜色
		var str4=$(this).children('td').eq(4).find("input").val()
		if(str4.length==0){
			rowMsg=rowMsg+"颜色,"
		}
		// 气味
		var str5=$(this).children('td').eq(5).find("input").val()
		if(str5.length==0){
			rowMsg=rowMsg+"气味,"
		}
		if((str.length==0)&&(str1.length==0)&&(str2.length==0)&&(str3.length==0)&&(str4.length==0)&&(str5.length==0)){
			rowMsg="";
		}
		if(rowMsg!=""){
			errMsg=errMsg+"\n"+rowMsg+"不能为空."
		}	
	
	})
	if(errMsg!=""){
		//$("html,body").stop(true);$("html,body").animate({scrollTop: $("#UlcerPart").offset().top}, 1000);
		$.messager.alert($g("提示:"),errMsg);
	}
	return errMsg;
}
//2018-04-16 评价界面数据加载
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="",OutHeadNurEvaRecId="";	 
	var PatOutcomRecId="";//转归表单记录id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"UlcerHeaNurEvaluate"},
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
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"UlcOutHeaNurEvaluate"},
	function(data){ 
			 OutHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"UlcPatOutcomform"},
	function(data){ 
			 PatOutcomRecId=data
	},"text",false)
	if((HeadNurEvaRecId!="")&&(RepStaus!="填报")){SetRepInfo(HeadNurEvaRecId,"UlcerHeaNurEvaluate");}
	if((LocHeadNurEvaRecId!="")&&((RepStaus=="科护士长审核")||(RepStaus=="护理部审核"))){SetRepInfo(LocHeadNurEvaRecId,"LocHeaNurEvaluate");}
	if((NurDepEvaRecId!="")&&(RepStaus=="护理部审核")){SetRepInfo(NurDepEvaRecId,"NurDepEvaluate");}
	if((OutHeadNurEvaRecId!="")&&(RepStaus!="填报")){SetRepInfo(OutHeadNurEvaRecId,"UlcOutHeaNurEvaluate");}
	//转归数据获取
	if((PatOutcomRecId!="")){SetRepInfo(PatOutcomRecId,"UlcPatOutcomform");}
}
//2018-04-16 给表单界面评价内容赋值
function SetRepInfo(FormRecId,FormCode){
	var data="" ;
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
		{'ADVFormRecDr':FormRecId},
		function(datalist){ 
			 data=datalist
	},"json",false)
	if((FormCode=="UlcerHeaNurEvaluate")&&(PatOrignin=="院内发生")){
		SetHeadNurInfo(data);
	}
	if(FormCode=="LocHeaNurEvaluate"){
		SetLocHeaNurInfo(data);
	}
	if(FormCode=="NurDepEvaluate"){
		SetNurDepInfo(data);
	}
	if((FormCode=="UlcOutHeaNurEvaluate")&&(PatOrignout=="院外带入")){
		SetOutHeadNurInfo(data);
	}
	//转归数据赋值
	if(FormCode=="UlcPatOutcomform"){
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
	var ListHeadNurEva=""; 
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
	var HNheightlen=(HNrow+HeadNurEvaluatelen)*18;
	$("#FormCauseAnalysis").css({
		"height":HNheightlen
	});
	$('#FormCauseAnalysis').val(List);
	$('#FormCauseAnalysis').append('<div id="HeadNurEvaluate"></div>');
	$('#HeadNurEvaluate').html(ListHeadNurEva);
}
//院外压疮
function SetOutHeadNurInfo(data)
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
	var ListHeadNurEva=""; 
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
	
	var UlcNurImpMeasures=radioValue("UlcNurImpMeasures-label-94930,UlcNurImpMeasures-label-94931",data); 
	if(UlcNurImpMeasures!=""){List=List+"\n院外压疮：护理措施落实效果："+UlcNurImpMeasures+"。";}
	var UlcNurImpMeasuresoth=$g(data["UlcNurImpMeasures-label-94932-94933"]);  //未落实 未落实原因： 
	if ((UlcNurImpMeasuresoth!="")){
		List=List+"\n院外压疮：护理措施落实效果：未落实 未落实原因："+UlcNurImpMeasuresoth+"。";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n护理记录书写："+ManaIfStandard+"。";}
	
	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
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
	var List="";
	//患者转归 UlcPatOutcom
	var UlcPatOutcom=$g(data["UlcPatOutcom"]);
	var UlcPatOutcomlen=UlcPatOutcom.length; //护士长评价个数
	var UlcPatOutcomList="";
	for(var k=0;k<UlcPatOutcomlen;k++){
		var POlist="\n记录"+(k+1)+"："
		var POpart=$g(UlcPatOutcom[k]["UlcPatOutcom-94937-94940-94943"]); //压疮部位
		if(POpart!=""){POlist=POlist+"压疮部位："+POpart+"；";}  
		var POobject=$g(radioValue("UlcPatOutcom-94937-94942-94944,UlcPatOutcom-94937-94942-94945,UlcPatOutcom-94937-94942-94946,UlcPatOutcom-94937-94942-94947",UlcPatOutcom[k])); //疮面转归
		if(POobject!=""){POlist=POlist+"疮面转归："+POobject+"。";}
		UlcPatOutcomList=UlcPatOutcomList+POlist
	}
	if(UlcPatOutcomList!=""){List=List+UlcPatOutcomList;}
	var POrow=0
	var POList=List.split("\n")
	var POlen=POList.length;
	for(i=0;i<POlen;i++){
		POrow=POrow+parseInt(POList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var POheightlen=(POrow)*18;
	$("#FormPatOutcom").css({
		"height":POheightlen
	});
	$('#FormPatOutcom').val(List);

}
function ChkHospUlcerRiskLev(value){
	RepSetRead("HospUlcerRiskLev-","radio",0);
	if($("input[type=radio][id='UseUlcerRiskpointtab-94929']").is(':checked')){  // Braden
		if((value>18)||(value=="")||(value<1)){
			$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("提示:"),$g("【使用压疮风险评分表】勾选'Braden' ，请输入1-18的整数"));
			}
			RepSetValue("HospUlcerRiskScore","input","");
		}else if((value<=9)){
			$("input[type=radio][id^='HospUlcerRiskLev-94936']").click();	// 极高危
		}
		if((value>=10)&&(value<=12)){
			$("input[type=radio][id^='HospUlcerRiskLev-94937']").click();  // 高危	
		}
		if((value>=13)&&(value<=14)){
			$("input[type=radio][id^='HospUlcerRiskLev-94938']").click();	 // 中危
		}
		if((value>=15)&&(value<=18)){
			$("input[type=radio][id^='HospUlcerRiskLev-94939']").click();	 // 轻危
		}
		RepSetRead("HospUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94930']").is(':checked')){  // Norton 
		if((value>14)||(value=="")||(value<1)){
			$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("提示:"),$g("【使用压疮风险评分表】勾选'Norton' ，请输入1-14的整数"));
			}
			RepSetValue("HospUlcerRiskScore","input","");
		}else if((value<=8)){
			$("input[type=radio][id^='HospUlcerRiskLev-94936']").click();	// 极高危
		}
		if((value>8)&&(value<=12)){
			$("input[type=radio][id^='HospUlcerRiskLev-94937']").click();  // 高危	
		}
		if((value>12)&&(value<=14)){
			$("input[type=radio][id^='HospUlcerRiskLev-94939']").click();	 // 轻危
		}
		RepSetRead("HospUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94931']").is(':checked')){  // Waterlow 
		if((value>100)||(value=="")||(value<1)){
			$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("提示:"),$g("【使用压疮风险评分表】勾选'Waterlow' ，请输入1-100的整数"));
			}
			RepSetValue("HospUlcerRiskScore","input","");
		}else if((value>=20)){
			$("input[type=radio][id^='HospUlcerRiskLev-94936']").click();	// 极高危
		}
		if((value>=15)&&(value<=19)){
			$("input[type=radio][id^='HospUlcerRiskLev-94937']").click();  // 高危	
		}
		if((value>=1)&&(value<=14)){
			$("input[type=radio][id^='HospUlcerRiskLev-94939']").click();	 // 轻危
		}
		RepSetRead("HospUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94932']").is(':checked')){  // 其他
		
	}else{
		$.messager.alert($g("提示:"),$g("请勾选【使用压疮风险评分表】"));
	}
}
function ChkOccurUlcerRiskLev(value){
	RepSetRead("OccurUlcerRiskLev-","radio",0);
	if($("input[type=radio][id='UseUlcerRiskpointtab-94929']").is(':checked')){  // Braden
		if((value>18)||(value=="")||(value<1)){
			$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("提示:"),$g("【使用压疮风险评分表】勾选'Braden' ，请输入1-18的整数"));
			}
			RepSetValue("OccurUlcerRiskScore","input","");
		}else if((value<=9)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94943']").click();	// 极高危
		}
		if((value>=10)&&(value<=12)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94944']").click();  // 高危	
		}
		if((value>=13)&&(value<=14)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94945']").click();	 // 中危
		}
		if((value>=15)&&(value<=18)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94946']").click();	 // 轻危
		}
		RepSetRead("OccurUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94930']").is(':checked')){  // Norton 
		if((value>14)||(value=="")||(value<1)){
			$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("提示:"),$g("【使用压疮风险评分表】勾选'Norton' ，请输入1-14的整数"));
			}
			RepSetValue("OccurUlcerRiskScore","input","");
		}else if((value<=8)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94943']").click();	// 极高危
		}
		if((value>8)&&(value<=12)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94944']").click();  // 高危	
		}
		if((value>12)&&(value<=14)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94946']").click();	 // 轻危
		}
		RepSetRead("OccurUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94931']").is(':checked')){  // Waterlow 
		if((value>100)||(value=="")||(value<1)){
			$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("提示:"),$g("【使用压疮风险评分表】勾选'Waterlow' ，请输入1-100的整数"));
			}
			RepSetValue("OccurUlcerRiskScore","input","");
		}else if((value>=20)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94943']").click();	// 极高危
		}
		if((value>=15)&&(value<=19)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94944']").click();  // 高危	
		}
		if((value>=1)&&(value<=14)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94946']").click();	 // 轻危
		}
		RepSetRead("OccurUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94932']").is(':checked')){  // 其他
		
	}else{
		$.messager.alert($g("提示:"),$g("请勾选【使用压疮风险评分表】"));
	}
}
