///Description:  院感不良事件报告单
///Creator:      wangxuejian  
///CreatDate:    2018-05-21 
var RepDate=formatDate(0);             //系统的当前日期
$(document).ready(function()
{   
	InitButton();             		  //保存
	InitReport(recordId);         //加载报表信息  
})

// 绑定保存、提交按钮
function InitButton()
{
	$("#SaveBut").on("click",function()
	{
	   SaveReport(0)                            
	})
	$("#SubmitBut").on("click",function()
	{
	   SaveReport(1)
	})
}

function SaveReport(flag)
{
   if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号/病案号回车选择记录录入患者信息！"));	
		return false;
	}
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

