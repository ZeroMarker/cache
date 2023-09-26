/**
	*Description: 医疗投诉、纠纷登记表 
	*Creator: yangyongtao
	*CreateDate: 2018-03-09
**/
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	InitButton();				// 初始化按钮
	reportControl();			// 表单控制   	
	InitDisReport(recordId);	// 加载页面信息

})


function InitButton(){
	
	// 保存
	$("#SaveBut").on("click",function(){
		SaveDisputeReport(0);
	})
	
	// 提交
	$("#SubmitBut").on("click",function(){
		SaveDisputeReport(1);
	})
}

// 表单控制
function reportControl(){
	
	// 复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');		
		});
	});
	
	// 科室签字 时间控制
	chkdate("LocDateTime");
	// 医务部签字 时间控制
	chkdate("MedServiceTime");
	// 院领导签字 时间控制
	chkdate("LeaderTime");
		
}

	
//报告保存
function SaveDisputeReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输入登记号/病案号回车选择记录录入患者信息！");	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
	
}

//加载报表信息
function InitDisReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');				
	} 
}

//病人信息赋值（回车事件）
function InitPatInfo(EpisodeID)
{
	
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate');
}



