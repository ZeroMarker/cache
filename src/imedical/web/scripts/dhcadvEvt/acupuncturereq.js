/// Description:锐器伤填报表单
/// Creator: yangyongtao
/// CreateDate: 2018-10-11
var eventtype=""
$(document).ready(function(){
	ReportControl();			// 表单控制
	InitButton(); 			// 绑定保存提交按钮 包医
	InitReport(recordId);//加载页面信息


});
// 表单控制
function ReportControl(){
	
	
	///控制受伤位置号码
	chknum("InjuryLocatNo",0,1,64);
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio(this);
		});
	});
}
function InitButton()
{
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}

//报告保存
function SaveReport(flag)
{
	if(($('#PatName').val()=="")&&($("#PatName").is(":visible"))){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号回车选择记录录入患者信息！"));	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(flag==1){
		if(!(checkRequired())){
			return;
		}
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



//combobox单选控制
function InitCheckRadio(obj){
	
	id=$(obj).attr("id")
	parref=$(obj).parent().attr("data-parref")

	/* ///患者信息是否必填
	if(id.indexOf("PatInfoIfRequest-")>=0){
		if($(obj).is(":checked")){
		  $("input[id^='PatInfoIfRequest-']").not("#"+id).removeAttr("checked")	
		}
	} */
	

	///2.被刺伤前是否接种过乙肝疫苗
	if(id.indexOf("IfHepBVaccine-")>=0){
                 $("input[id^='IfHepBVaccine-']").not("input[id*='IfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
	}
	
	///接种过乙肝疫苗请回答注射时间
	if(id.indexOf("IfHepBVaccine-98082-98089-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfHepBVaccine-98082-98089-']").not("#"+id).removeAttr("checked")
			$("#IfHepBVaccine-98082").attr("checked",true)
			$("input[id^='IfHepBVaccine-']").not("input[id*='IfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
		}else{
			$("#IfHepBVaccine-98082").attr("checked",false)
		}
	}
	   
	
	///3.是否经过职业防护、正规操作技能培训
	 if(id.indexOf("IfSkillTrain-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfSkillTrain-']").not("#"+id).removeAttr("checked")
		}	
	}
	///4.操作者是否知道病人的带病情况
	 if(id.indexOf("IfPatDisease-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfPatDisease-']").not("#"+id).removeAttr("checked")
		}	
	}
    ///5.操作者用手习惯为
	 if(id.indexOf("HandHabit-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='HandHabit-']").not("#"+id).removeAttr("checked")
		}	
	}
	///6.受伤者是否为锐器最初使用者
	 if(id.indexOf("SharpFirUser-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='SharpFirUser-']").not("#"+id).removeAttr("checked")
		}	
	}
	///1.导致伤害的锐器物种类
	if(id.indexOf("SharpKinds-")>=0){
		if($(obj).is(":checked")){ 
		   if(id!="SharpKinds-98123"){
			 $("#SharpKinds-98123").next().next().val("");
		     $("#SharpKinds-98123").next().next().hide();
			 $("input[id^='SharpKinds-']").not("#"+id).removeAttr("checked")
		   }else{
			 $("input[id^='SharpKinds-']").not("#"+id).removeAttr("checked")
		   }
		}	  
	}
	///2.锐器的最初目的
	if(id.indexOf("SharpFirPurpose-")>=0){
		if($(obj).is(":checked")){ 
		   if(id!="SharpFirPurpose-98140"){
			 $("#SharpFirPurpose-98140").next().next().val("");
		     $("#SharpFirPurpose-98140").next().next().hide();
			 $("input[id^='SharpFirPurpose-']").not("#"+id).removeAttr("checked")
		   }else{
			 $("input[id^='SharpFirPurpose-']").not("#"+id).removeAttr("checked")
		   }
		}	  
	}
	///3.锐器是否被血污染
	if(id.indexOf("IfSharpBlood-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfSharpBlood-']").not("#"+id).removeAttr("checked")
		}	
	}
	
	///5.伤害的发生有无不正确的操作：
	if(id.indexOf("IfOperCorrect-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfOperCorrect-']").not("#"+id).removeAttr("checked")
		}	
	}
	///6.如果受伤人与病人有关，请选择病人的带病情况
	if(id.indexOf("PatCondition-label-")>=0){
		if($(obj).is(":checked")){ 
		    if((id=="PatCondition-label-98155")||(id=="PatCondition-label-98156")||(id=="PatCondition-label-98157")){
				   $("input[id^='PatCondition-label-']").not("#"+id).removeAttr("checked")
				   $("#PatCondition-label-98162").next().next().val("");
				   $("#PatCondition-label-98162").next().next().hide();
			}else{
				   $("input[id='PatCondition-label-98155']").not("#"+id).removeAttr("checked")
				   $("input[id='PatCondition-label-98156']").not("#"+id).removeAttr("checked")
				   $("input[id='PatCondition-label-98157']").not("#"+id).removeAttr("checked")
			}
		 }	
	}
	
	///7.伤害发生环节  $("input[id^='OccurInjuryLink-"+idArr[1]+"']").not("#"+id).removeAttr("checked")
	if(id.indexOf("OccurInjuryLink-")>=0){
		 if($(obj).is(":checked")){
                $("input[id^='OccurInjuryLink-']").not("input[id*='OccurInjuryLink-"+ id.split("-")[1] +"']").removeAttr("checked")
	     }
	}
			  
	///2、锐器穿透了
	if(id.indexOf("Sharpen-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='Sharpen-']").not("#"+id).removeAttr("checked")
		}	
	}
	///3、受伤后伤口处理情况
	if(id.indexOf("WoundManage-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='WoundManage-']").not("#"+id).removeAttr("checked")
		}	
	}
}
