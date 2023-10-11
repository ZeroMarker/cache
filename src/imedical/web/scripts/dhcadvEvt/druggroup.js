/// Description: 群伤不良事件
var RepDate=formatDate(0); //系统的当前日期
$(function(){

	InitButton(); 			// 绑定保存提交按钮 
	ReportControl();
	InitReport(recordId);  		//加载报表信息 
	CheckTimeorNum();	               //时间校验 
	

});

// 绑定保存提交按钮
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveGroupRep(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveGroupRep(1);
	})
}
//表单控制
function ReportControl(){
	// 首例用药日期
	chkdate("FirstDrugDate");
	// 首例发生日期
	chkdate("FirstHappenDate");
}

function SaveGroupRep(flag){
	
	///保存前,对页面必填项进行检查
	if(!(checkother()&&checkRequired())){
		return;
	}
	//var repCode="advDrugGroup"   //wxj 2021-02-02    保存的时候传报告Code 看是否获取病人就诊号
	EpisodeID="";
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
	//InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}

//时间 数字校验
function CheckTimeorNum(){
	//时间输入校验
	// 首例用药日期时间
	chktime("FirstDrugTime","FirstDrugDate");
	// 首例发生日期时间
	chktime("FirstHappenTime","FirstHappenDate");
	
	//数字输入校验  
	// 用药人数
	chknum("UseDrugNumber",0);
	// 发生不良事件人数
	chknum("DverseEventsNum",0);
	// 严重不良事件人数
	chknum("SeriousEventsNum",0);
	// 死亡人数
	chknum("DeathNum",0);
	
}
///判断输血列表是否为空 sufan 2019-11-14
function checkother()
{
	
	chkdate("FirstDrugDate");
	// 首例发生日期
	chkdate("FirstHappenDate");
	// 首例用药日期时间
	chktime("FirstDrugTime","FirstDrugDate");
	// 首例发生日期时间
	chktime("FirstHappenTime","FirstHappenDate");
	
	// 首例用药日期
	var FirstDrugDate=$('#FirstDrugDate').datebox('getValue');
	// 首例发生日期
	var FirstHappenDate=$('#FirstHappenDate').datebox('getValue');
	// 首例用药时间
	var FirstDrugTime=$('#FirstDrugTime').val();
	// 首例发生时间
	var FirstHappenTime=$('#FirstHappenTime').val();
	var reg = new RegExp(":","g")
	FirstDrugTime=FirstDrugTime==undefined?"":FirstDrugTime.replace(reg,"");
	FirstHappenTime=FirstHappenTime==undefined?"":FirstHappenTime.replace(reg,"");
	if(!compareSelTowTime(FirstDrugDate,FirstHappenDate)){
		$.messager.alert($g("提示:"),$g("首例用药日期应小于首例发生日期，请重新填写日期！"));
		return false;
	}
	if((FirstDrugDate==FirstHappenDate)&&(FirstDrugTime>FirstHappenTime)){
		$.messager.alert($g("提示:"),$g("首例用药时间应小于首例发生时间，请重新填写时间！"));
		return false;
	}
	// 用药人数
	var UseDrugNumber=$('#UseDrugNumber').val();
	// 发生不良事件人数
	var DverseEventsNum=$('#DverseEventsNum').val();
	// 严重不良事件人数
	var SeriousEventsNum=$('#SeriousEventsNum').val();
	// 死亡人数
	var DeathNum=$('#DeathNum').val();
	if((UseDrugNumber!="")&&(DverseEventsNum!="")&&(parseInt(DverseEventsNum)>parseInt(UseDrugNumber))){
		$.messager.alert($g("提示:"),$g("发生不良事件人数大于用药人数，请重新填写！"));
		return false;
	}
	if((DverseEventsNum!="")&&(SeriousEventsNum!="")&&(parseInt(SeriousEventsNum)>parseInt(DverseEventsNum))){
		$.messager.alert($g("提示:"),$g("严重不良事件人数大于发生不良事件人数，请重新填写！"));
		return false;
	}
	if((DverseEventsNum!="")&&(DeathNum!="")&&(parseInt(DeathNum)>parseInt(DverseEventsNum))){
		$.messager.alert($g("提示:"),$g("死亡人数大于发生不良事件人数，请重新填写！"));
		return false;
	}
	
	return true;
}
