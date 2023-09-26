/// Description: 其他不良事件
$(function(){
	InitButton(); 	// 绑定保存提交按钮 
	InitReport(recordId);  		//加载报表信息  
});

// 绑定保存提交按钮
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}
function SaveReport(flag){
	///保存前,对页面必填项进行检查
	if(!(checkRequired())){
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

