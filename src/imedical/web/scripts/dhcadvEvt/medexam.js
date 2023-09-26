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
		$.messager.alert("提示:","患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！");	
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
	/// 1.发生不良事件/错误的名称(四选一)
	var tempckid="";
	$("input[type='checkbox'][id^='AdvEventErr']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='AdvEventErr']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
	/// 2.发生不良事件的主要事由/要素(八选一)
	var tempckid="";
	$("input[type='checkbox'][id^='MajorCausesAdv']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='MajorCausesAdv']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					//$("[id$='-"+this.id.split("-")[1]+"']div:not([id^='-"+this.id.split("-")[0]+"'])").html("");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
	/// 3.事件当事人可能相关的因素
	var tempckid="";
	$("input[type='checkbox'][id^='PosRelFactors']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='PosRelFactors']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					//$("[id$='-"+this.id.split("-")[1]+"']div:not([id^='-"+this.id.split("-")[0]+"'])").html("");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
	/// 4.预防此类事件与错误再次发生的方法与措施
	var tempckid="";
	$("input[type='checkbox'][id^='MedPreEvent']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='MedPreEvent']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					//$("[id$='-"+this.id.split("-")[1]+"']div:not([id^='-"+this.id.split("-")[0]+"'])").html("");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
}

