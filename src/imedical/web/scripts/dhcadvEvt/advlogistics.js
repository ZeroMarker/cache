/// Description: 后勤不良事件
var RepDate=formatDate(0); //系统的当前日期
$(function(){

	InitButton(); 			// 绑定保存提交按钮 包医
	InitReport(recordId);  		//加载报表信息  包医
});

// 绑定保存提交按钮
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveMedReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveMedReport(1);
	})
}
function SaveMedReport(flag){
	
	if($('#PatName').val()==""){
		$.messager.alert("提示:","患者姓名为空，请输登记号或病案号回车选择记录录入患者信息！");	
		return false;
	}
	// 保存前,对页面必填项进行检查
	if(!checkRequired()){
		return;
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
