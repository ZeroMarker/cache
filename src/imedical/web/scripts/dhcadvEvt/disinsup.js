/**
*Description:	消毒供应不良事件
*Creator: 		cy
*CreDate: 		2021-07-27
**/
$(document).ready(function(){
	InitButton();				// 初始化按钮
	ReportControl();			// 表单控制   	
	InitReport(recordId);	// 加载页面信息
	InitCheckRadio();
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
	// 其它医疗缺陷 input (有值显示，无值隐藏) 
	var MedTypeOth= $('#advMedicalReportType-label-97195-97894').val();
	if(MedTypeOth!=""){
		 $('#advMedicalReportType-label-97195-97894').show();
	}else{
	     $('#advMedicalReportType-label-97195-97894').hide();
	}
	
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	// 其它医疗缺陷 input(默认隐藏 勾选显示) 
	$('#advMedicalReportType-label-97195').click(function () { 
		if ($(this).is(':checked')){
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
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输登记号或病案号回车选择记录录入患者信息！"));	
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
		$.messager.alert($g("提示:"),$g("签名失败！"));	
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
