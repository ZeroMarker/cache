/// Description:血液/体液暴露事件
/// Creator: yangyongtao
/// CreateDate: 2018-10-11
var eventtype=""
$(document).ready(function(){
	ReportControl();			// 表单控制
	InitButton();				// 初始化按钮
	InitReport(recordId);		//加载页面信息
	//BldFluInitUI(); //控制界面默认勾选内容

});
// 表单控制
function ReportControl(){
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio(this);
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
//控制界面默认勾选内容
function BldFluInitUI(){
	$("#RepDept-98359").attr("checked",true)  //医院感染管理科
	$("#RepDept-98359").attr({disabled:true})
}

//报告保存
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输入登记号回车选择记录录入患者信息！");	
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

//combobox单选控制
function InitCheckRadio(obj){
	
	id=$(obj).attr("id")

	
	
	///2、是否接种过乙肝疫苗
	if(id.indexOf("BldIfHepBVaccine-")>=0){
		 if($(obj).is(":checked")){
                 $("input[id^='BldIfHepBVaccine-']").not("input[id*='BldIfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
	     }
	}
	
	///接种过乙肝疫苗请回答注射时间
	if(id.indexOf("BldIfHepBVaccine-98843-98844-")>=0){
		if($(obj).is(":checked")){
				$("input[id^='BldIfHepBVaccine-98843-98844-']").not("#"+id).removeAttr("checked")
				$("#BldIfHepBVaccine-98843").attr("checked",true)
				$("input[id^='IfHepBVaccine-']").not("input[id*='IfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
		}else{
			    $("#BldIfHepBVaccine-98843").attr("checked",false)	
		}
	}
	   
	
	///3.是否经过职业防护培训
	 if(id.indexOf("BldIfSkillTrain-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='BldIfSkillTrain-']").not("#"+id).removeAttr("checked")
		}	
	}
	///4.操作者是否知道患者的带病情况
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
	///6.操作时正确佩戴防护用品
	 if(id.indexOf("IfAdornProtectArtic-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfAdornProtectArtic-']").not("#"+id).removeAttr("checked")
		}	
	}
	///7.如果暴露人与患者有关，请选择患者的带病情况
	if(id.indexOf("ExPatCondition-")>=0){
		if($(obj).is(":checked")){ 
		    if((id=="ExPatCondition-98856")||(id=="ExPatCondition-98857")||(id=="ExPatCondition-98858")){
				   $("input[id^='ExPatCondition-']").not("#"+id).removeAttr("checked")
				   $("#ExPatCondition-98863").next().next().val("");
				   $("#ExPatCondition-98863").next().next().hide();
			}else{
				   $("input[id='ExPatCondition-98856']").not("#"+id).removeAttr("checked")
				   $("input[id='ExPatCondition-98857']").not("#"+id).removeAttr("checked")
				   $("input[id='ExPatCondition-98858']").not("#"+id).removeAttr("checked")
			}
		 }	
	}
	
	///2、暴露后发生的情况
	 if(id.indexOf("OccuExpAfter-")>=0){
		if($(obj).is(":checked")){
			if(id!="OccuExpAfter-98876"){
			    $("#OccuExpAfter-98876").next().next().val("");
			    $("#OccuExpAfter-98876").next().next().hide();
			    $("input[id^='OccuExpAfter-']").not("#"+id).removeAttr("checked")	
			}else{
			   $("input[id^='OccuExpAfter-']").not("#"+id).removeAttr("checked")
			}
		}	
	}

	
}