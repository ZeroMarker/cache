/**
*Description:	包医医疗不良事件报告单
*Creator: 		Qunianpeng
*CreDate: 		2018-05-25
**/
$(document).ready(function(){
	InitButton();				// 初始化按钮
	ReportControl();			// 表单控制   	
	InitReport(recordId);	// 加载页面信息
})
// 初始化按钮
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
// 表单控制
function ReportControl(){
	// 复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');		
		});
	});
	// 其它医疗缺陷(默认隐藏) 
	$('#advMedicalReportType-label-97195-97894').hide();
	$('#advMedicalReportType-label-97195').click(function () { 
		var $isChecked = $("#advMedicalReportType-label-97195").is(":checked");
		if($isChecked){
			 $('#advMedicalReportType-label-97195-97894').show();
		}else{
		     $('#advMedicalReportType-label-97195-97894').hide();
		}
	}); 
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
		$.messager.alert("提示:","患者姓名为空，请输登记号或病案号回车选择记录录入患者信息！");	
		return false;
	}
	// 保存前,对页面必填项进行检查
	if(!checkRequired()){
		return;
	}
	var caflag=dhcsys_getcacert();  //ca认证
	if(caflag.IsSucc){
		SaveReportCom(flag);
	}else{
		$.messager.alert("提示:","签名失败！");	
		return false;
	}
	
}
//病人信息赋值（回车事件）
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
