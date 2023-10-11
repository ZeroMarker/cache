///Description: 医技检查不良事件报告单
///Creator: sufan
///Creatdate: 2018-12-04
var RepDate=formatDate(0); 
$(document).ready(function(){
	reportControl();			// 表单控制  
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

function reportControl()
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
	/// 1.发生不良事件/错误的名称(四选一)
	if(!(id.indexOf("AdvEventErr")<0)){
		$("input[type='checkbox'][id^='AdvEventErr-']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 2.发生不良事件的主要事由/要素(八选一)
	if(!(id.indexOf("MajorCausesAdv")<0)){
		$("input[type='checkbox'][id^='MajorCausesAdv']").each(function(){
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
	var AdvEventList="",AdvEventErr="";
	$("input[type=checkbox][id^='AdvEventErr-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					AdvEventList=this.value;
				}
			});
			if ((this.value!="")&&(AdvEventList=="")){
				$.messager.alert($g("提示:"),$g("【发生不良事件/错误的名称】勾选'"+this.value+"'，请勾选相应内容！"));	
				AdvEventErr=-1;
				return false;
			}
		}
	})
	if(AdvEventErr=="-1"){
		return false;
	}
	/// 2.发生不良事件的主要事由/要素(八选一)
	var MajorCausesList="",MajorCausesErr="";
	$("input[type=checkbox][id^='MajorCausesAdv-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					MajorCausesList=this.value;
				}
			});
			if ((this.value!="")&&(MajorCausesList=="")){
				$.messager.alert($g("提示:"),$g("【发生不良事件的主要事由/要素】勾选'"+this.value+"'，请勾选相应内容！"));	
				MajorCausesErr=-1;
				return false;
			}
		}
	})
	if(MajorCausesErr=="-1"){
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
