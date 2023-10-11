/// Description: 用药事件报告单
/// Creator: yuliping
/// CreateDate: 2018-08-31
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	
	InitButton(); 			// 绑定保存提交按钮 包医
	InitReport(recordId);//加载页面信息	
	addDomMethod();   //界面增加特殊元素的dom操作
})
function InitButton()
{
	
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}
//qqa 2018-12-03 对于界面个别元素控制，单独增加
function addDomMethod(){
	//事件发生日期
	$("#drughapdate-94692").on("click",enabDate);
	$("#drughapdate-94693").on("click",disDate);
	
	/// 医院药物标准作业流程
	var tempckid="";
	$("input[type='checkbox'][id^='hospDrugFlow']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='hospDrugFlow']").each(function(){
				if($("#"+this.id).is(':checked')&&(tempckid.indexOf(this.id)<0)){
					if((tempckid.split("-").length==2)&&(this.id!=tempckid)){
						$("#"+this.id).removeAttr("checked");
						$("#hospDrugFlow-94830-94837").nextAll(".lable-input").val("");
						$("#hospDrugFlow-94830-94837").nextAll(".lable-input").hide();
					}
					if((tempckid.split("-").length==3)&&(this.id.split("-").length!=3)){
						$("#"+this.id).removeAttr("checked");
					}
				}
			})
		}
	})
	/// 此事件发生后的立即处理（可多选）
	var tempckid="";
	$("input[type='checkbox'][id^='drugHandle']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='drugHandle']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))&&(tempckid.indexOf(this.id)<0)){
					$("#"+this.id).removeAttr("checked");
				}
			})
		}
	})
}

function enabDate(){
	$("#drughapdate-94692-94731").datetimebox("enable");
}

function disDate(){
	$("#drughapdate-94692-94731").datetimebox("setValue","");	
	$("#drughapdate-94692-94731").datetimebox("disable");
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

function SaveReport(flag,status){
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
