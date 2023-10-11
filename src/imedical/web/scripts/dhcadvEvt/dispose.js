///Description: 治疗与处置使用与管理类
///Creator: cy
///Creatdate: 2021-06-22
var RepDate=formatDate(0); 
$(document).ready(function(){
	ReportControl();			// 表单控制  
	InitButton();				// 初始化按钮
	InitReport(recordId)
	
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

function ReportControl()
{
	// 复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');	
			InitCheckRadio(this.id);	
		});
	});
	
}
function InitCheckRadio(id){
	/// 1.发生不良事件/错误的名称
	if(!(id.indexOf("DispOccuEventName")<0)){
		$("input[type='checkbox'][id^='DispOccuEventName']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 2.发生不良事件的主要事由/要素
	if(!(id.indexOf("DispMainReason")<0)){
		$("input[type='checkbox'][id^='DispMainReason']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 3.事件当事人可能相关的因素
	if(!(id.indexOf("PosRelFactors")<0)){
		$("input[type='checkbox'][id^='PosRelFactors']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 4.预防此类事件与错误再次发生的方法与措施
	if(!(id.indexOf("MedPreEvent")<0)){
		$("input[type='checkbox'][id^='MedPreEvent']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
}
function checkother()
{
	/// 1.发生不良事件/错误的名称(四选一)
	var DispOccuEventNameList="",DispOccuEventNameErr="";
	$("input[type=checkbox][id^='DispOccuEventName-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					DispOccuEventNameList=this.value;
				}
			});
			if ((this.value!="")&&(DispOccuEventNameList=="")){
				$.messager.alert($g("提示:"),$g("【发生不良事件/错误的名称】勾选'"+this.value+"'，请勾选相应内容！"));	
				DispOccuEventNameErr=-1;
				return false;
			}
		}
	})
	if(DispOccuEventNameErr=="-1"){
		return false;
	}
	/// 2.发生不良事件的主要事由/要素(八选一)
	var DispMainReasonList="",DispMainReasonErr="";
	$("input[type=checkbox][id^='DispMainReason-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					DispMainReasonList=this.value;
				}
			});
			if ((this.value!="")&&(DispMainReasonList=="")){
				$.messager.alert($g("提示:"),$g("【发生不良事件的主要事由/要素】勾选'"+this.value+"'，请勾选相应内容！"));	
				DispMainReasonErr=-1;
				return false;
			}
		}
	})
	if(DispMainReasonErr=="-1"){
		return false;
	}
	/// 3.事件当事人可能相关的因素
	var PosRelFactorsList="",PosRelFactorsErr="";
	$("input[type=checkbox][id^='PosRelFactors-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					PosRelFactorsList=this.value;
				}
			});
			if ((this.value!="")&&(PosRelFactorsList=="")){
				$.messager.alert($g("提示:"),$g("【事件当事人可能相关的因素】勾选'"+this.value+"'，请勾选相应内容！"));	
				PosRelFactorsErr=-1;
				return false;
			}
		}
	})
	if(PosRelFactorsErr=="-1"){
		return false;
	}
	/// 4.预防此类事件与错误再次发生的方法与措施
	var MedPreEventList="",MedPreEventErr="";
	$("input[type=checkbox][id^='MedPreEvent-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					MedPreEventList=this.value;
				}
			});
			if ((this.value!="")&&(MedPreEventList=="")){
				$.messager.alert($g("提示:"),$g("【预防此类事件与错误再次发生的方法与措施】勾选'"+this.value+"'，请勾选相应内容！"));	
				MedPreEventErr=-1;
				return false;
			}
		}
	})
	if(MedPreEventErr=="-1"){
		return false;
	}
	
	return true;
}
