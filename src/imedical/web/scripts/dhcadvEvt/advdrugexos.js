///Description: 药物外渗专项报告单
///Creator: lp
///Creatdate: 18-5-18
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	InitCheckRadio();			//加载界面checkbox radio 元素勾选控制
	InitButton();				// 初始化按钮
	CheckTimeorNum();  			// 数字,时间 输入校验
	ReportControl();			// 表单控制 
	InitReport(recordId);//加载页面信息
	//InitLayoutHtml(); //初始化页面布局 18-1-20
})
function InitButton(){
	// 保存
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	
	// 提交
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
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
			InitCheckRadio();
		});
	});
	
	
	
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
//控制页面元素事件
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
	
	//发泡性
	if($('#DrugExosStimInt-846').is(':checked')){
		$('#DrugExosStimInt-846-851').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-846-851').attr('readonly','readonly');
		$('#DrugExosStimInt-846-851').val("");
	}
	//刺激性
	if($('#DrugExosStimInt-847').is(':checked')){
		$('#DrugExosStimInt-847-854').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-847-854').attr('readonly','readonly');
		$('#DrugExosStimInt-847-854').val("");		
	}
	//非发泡性
	if($('#DrugExosStimInt-848').is(':checked')){
		$('#DrugExosStimInt-848-857').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-848-857').attr('readonly','readonly');
		$('#DrugExosStimInt-848-857').val("");		
	}
	//其他
	if($('#DrugExosStimInt-849').is(':checked')){
		$('#DrugExosStimInt-849-860').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-849-860').attr('readonly','readonly');
		$('#DrugExosStimInt-849-860').val("");		
	}
	
	
	//红肿
	if($('#DrugExosPuncExos-882-884').is(':checked')){
		$('#DrugExosPuncExos-882-884-886').attr('disabled',false);	
		$('#DrugExosPuncExos-882-884-900').attr('disabled',false);
	}else{
		$('#DrugExosPuncExos-882-884-886').attr("disabled",true);
		$('#DrugExosPuncExos-882-884-900').attr("disabled",true);
		$('#DrugExosPuncExos-882-884-886').val("");
		$('#DrugExosPuncExos-882-884-900').val("");		
	}
	//疼痛
	if($('#DrugExosPuncExos-905-907').is(':checked')){
		$('#DrugExosPuncExos-905-907-909').attr('disabled',false);	
	}else{
		$('#DrugExosPuncExos-905-907-909').attr('disabled',true);
		$('#DrugExosPuncExos-905-907-909').val("");			
	}
	//溃疡
	if($('#DrugExosPuncExos-917-919').is(':checked')){
		$('#DrugExosPuncExos-917-919-921').attr('disabled',false);
		$('#DrugExosPuncExos-917-919-923').attr('disabled',false);
	}else{
		$('#DrugExosPuncExos-917-919-921').attr('disabled',true);	
		$('#DrugExosPuncExos-917-919-923').attr('disabled',true);
		$('#DrugExosPuncExos-917-919-921').val("");
		$('#DrugExosPuncExos-917-919-923').val("");		
	}
	//科室是否发生过类似的事件 是否控制单选
	$("input[type=checkbox][id^='DeptIfOccSimEvent-']").click(function(){
		var tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][id^='DeptIfOccSimEvent-']").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
	//科室是否发生过类似的事件 是
	if($('#DeptIfOccSimEvent-94119').is(':checked')){
		$('#DeptIfOccSimEvent-94119-94120').attr('disabled',false);
	}else{
		$('#DeptIfOccSimEvent-94119-94120').val("");
	}
	//科室是否发生过类似的事件 否
	if($('#DeptIfOccSimEvent-94121').is(':checked')){
		$('#DeptIfOccSimEvent-94119-94120').val("");
	}else{
		$('#DeptIfOccSimEvent-94119-94120').attr('disabled',false);
	}
	//科室是否发生过类似的事件 是 本年度（次）
	$("#DeptIfOccSimEvent-94119-94120").bind("blur",function(){
		if($("#DeptIfOccSimEvent-94119-94120").val()!=""){
			$("#DeptIfOccSimEvent-94119").prop("checked",true) ;
			$('#DeptIfOccSimEvent-94121').removeAttr("checked");
		}
	})
	
}
function InitLayoutHtml(){
	///刺激强度的药物名称宽度
	$('#DrugExosStimInt-846-851,#DrugExosStimInt-847-854,#DrugExosStimInt-848-857,#DrugExosStimInt-849-860').css('max-width','300px');	
	//其他情况说明
	$('#DrugExosAssother').css('max-width','300px');
	
	//$('#OccurBefDealMethod').find("label").eq(0).css("color","red");
	$('#OccurAfterDealMethod').find("label").eq(0).css("color","red");
	$('#PatSafeGroupResult-label').css("color","blue");
	
	$('#DeptIfOccSimEvent').find("label").eq(0).css("color","red");
	
	//alert(LgGroupDesc)
	//15以下
		if((LgGroupDesc.indexOf("护士长")<0)&(LgGroupDesc!="护理部")){
			//护士张填写 start
			$("label[data-parref='OccurAfterDealMethod']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='OccurAfterDealMethod']").attr("disabled",true);  
			$("label[data-parref='DeptIfOccSimEvent']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='DeptIfOccSimEvent']").attr("disabled",true);
			$("#DeptIfOccSimEvent-94119-94120").css("background-color","#D4D0C8");
			$("#DeptIfOccSimEvent-94119-94120").attr("readonly","readonly");
			
			$("label[data-parref='NurReasonCase']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='NurReasonCase']").attr("disabled",true);  
			$("label[data-parref='NurCorrectAction']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='NurCorrectAction']").attr("disabled",true); 
			$("label[data-parref='NurDisposition']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='NurDisposition']").attr("disabled",true); 
			$("#NurHeadNurse").css("background-color","#D4D0C8");
			$("#NurHeadNurse").attr("readonly","readonly"); 
			$("#NurSignDate").datetimebox({disabled:true});
			//护士张填写 end
			
			//护理部填写 start
			$("label[data-parref^='PatSafeGroupResult-label']").css("color","#D4D0C8");
			$("input[type=radio][id^='PatSafeGroupResult-label']").attr("disabled",true);
			$("input[type=input][id^='PatSafeGroupResult-label']").css("background-color","#D4D0C8");
			$("input[type=input][id^='PatSafeGroupResult-label']").attr("disabled",true);

			$("#NurTeamReferPerson").css("background-color","#D4D0C8");
			$("#NurTeamReferPerson").attr("disabled",true);
			$("#ReferDate").datetimebox({disabled:true});
			//护理部填写 end
			
		}else{
			if(LgGroupDesc.indexOf("护士长")>0){
				//护理部填写 start
				$("label[data-parref^='PatSafeGroupResult-label']").css("color","#D4D0C8");
				$("input[type=radio][id^='PatSafeGroupResult-label']").attr("disabled",true);
				$("input[type=input][id^='PatSafeGroupResult-label']").css("background-color","#D4D0C8");
				$("input[type=input][id^='PatSafeGroupResult-label']").attr("disabled",true);

				$("#NurTeamReferPerson").css("background-color","#D4D0C8");
				$("#NurTeamReferPerson").attr("disabled",true);
				$("#ReferDate").datetimebox({disabled:true});
				//护理部填写 end 	
			}
			if(LgGroupDesc=="护理部"){
				//护士张填写 start
				$("label[data-parref='OccurAfterDealMethod']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='OccurAfterDealMethod']").attr("disabled",true);  
				$("label[data-parref='DeptIfOccSimEvent']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='DeptIfOccSimEvent']").attr("disabled",true);
				$("#DeptIfOccSimEvent-94119-94120").css("background-color","#D4D0C8");
				$("#DeptIfOccSimEvent-94119-94120").attr("readonly","readonly");
				
				$("label[data-parref='NurReasonCase']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='NurReasonCase']").attr("disabled",true);  
				$("label[data-parref='NurCorrectAction']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='NurCorrectAction']").attr("disabled",true); 
				$("label[data-parref='NurDisposition']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='NurDisposition']").attr("disabled",true); 
				$("#NurHeadNurse").css("background-color","#D4D0C8");
				$("#NurHeadNurse").attr("readonly","readonly"); 
				$("#NurSignDate").datetimebox({disabled:true});
				//护士张填写 end	
			}
			
		}
}

//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();

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

function doOther(obj){
}
//检查界面勾选其他，是否填写输入框
function checkother(){
	//穿刺部位药物外渗情况
	var DrugExosPuncExos=0;
	$("input[type=radio][id^='DrugExosPuncExos']").each(function(){
		if($(this).is(':checked')){
			if ((this.id=="DrugExosPuncExos-882-884")&&(($("#DrugExosPuncExos-882-884-886").val()=="")||($("#DrugExosPuncExos-882-884-900").val()==""))){
				DrugExosPuncExos=-1;
				return false;
			}
			if ((this.id=="DrugExosPuncExos-905-907")&&($("#DrugExosPuncExos-905-907-909").val()=="")){
				DrugExosPuncExos=-2;
				return false;
			}
			if ((this.id=="DrugExosPuncExos-917-919")&&(($("#DrugExosPuncExos-917-919-921").val()=="")||($("#DrugExosPuncExos-917-919-923").val()==""))){
				DrugExosPuncExos=-3;
				return false;
			}
		}
	})
	if(DrugExosPuncExos==-1){
		$.messager.alert($g("提示:"),$g("【穿刺部位药物外渗情况-红肿】勾选'有'，请填写内容！"));	
		return false;
	}
	if(DrugExosPuncExos==-2){
		$.messager.alert($g("提示:"),$g("【穿刺部位药物外渗情况-疼痛】勾选'有'，请填写内容！"));	
		return false;
	}
	if(DrugExosPuncExos==-3){
		$.messager.alert($g("提示:"),$g("【穿刺部位药物外渗情况-溃疡】勾选'有'，请填写内容！"));	
		return false;
	}
	
	//处理措施 根据药物性质给予 
	var DrugExosTM="",DrugExosTMList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-938']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTM=this.value;
		}
	})
	if(DrugExosTM=="根据药物性质给予"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-938-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMList=this.value
			}
		})
		if (DrugExosTMList==""){
			$.messager.alert($g("提示:"),$g("【处理措施】勾选'根据药物性质给予'，请勾选相应内容！"));	
			return false;
		}
	}
	//处理措施 根据药物性质给予  湿敷
	var DrugExosTMsf=0,DrugExosTMsfList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-938-939']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTMsf=this.value;
		}
	})
	if(DrugExosTMsf=="湿敷"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-938-939-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMsfList=this.value
			}
		})
		if (DrugExosTMsfList==""){
			$.messager.alert($g("提示:"),$g("【处理措施】勾选'根据药物性质给予-湿敷'，请勾选相应内容！"));	
			return false;
		}
	}
	
	//处理措施 根据药物性质给予  物理治疗
	var DrugExosTMwlzl=0,DrugExosTMwlzlList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-938-942']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTMwlzl=this.value;
		}
	})
	if(DrugExosTMwlzl=="物理治疗"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-938-942-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMwlzlList=this.value
			}
		}) 
		if (DrugExosTMwlzlList==""){
			$.messager.alert($g("提示:"),$g("【处理措施】勾选'根据药物性质给予-物理治疗'，请勾选相应内容！"));	
			return false;
		}
	}
	//处理措施 请会诊 
	var DrugExosTMHZ=0,DrugExosTMHZList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-947']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTMHZ=this.value;
		}
	})
	if(DrugExosTMHZ=="请会诊"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-947-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMHZList=this.value
			}
		})
		if (DrugExosTMHZList==""){
			$.messager.alert($g("提示:"),$g("【处理措施】勾选'请会诊'，请勾选相应内容！"));	
			return false;
		}
	}

	return true;
}
//时间 数字校验
function CheckTimeorNum(){	
	//数字输入校验  
	
	///控制穿刺部位药物外渗情况
	chknum("DrugExosPuncExos",1,1,100);
}


