/// Description:器械不良事件
var RepDate=formatDate(0); //系统的当前日期
$(function(){

	InitButton(); 					// 绑定保存提交按钮 包医
	reportControl(); 				// 表单控制    包医
	InitCheckRadio();				//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	InitReportInfo(recordId);  		//加载报表信息  包医
	InitLayoutHtml();
});

function InitLayoutHtml(){
	$('#MedEventInfomation-97766').css('padding-bottom','22px');	
	$('#MedEventInfomation-97801').css('padding-bottom','22px');
}

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
		$.messager.alert($g("提示")+":",$g("患者姓名为空")+"，"+$g("请输入登记号/病案号回车选择记录录入患者信息")+"！");
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}

//表单控制
function reportControl(){
	
	// 发现日期控制
	chkdate("FindDate");
	// 死亡时间控制
	chkdate("MedNewEventResult-97739-97915");
	
	// 生产日期控制
	chkdate("MedAllDate-97762");
	
	// 停用日期控制
	chkdate("MedAllDate-97763");
	
	// 植入日期控制
	chkdate("MedAllDate-97764");
	
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	
}
//加载报表信息
function InitReportInfo(recordId)
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
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//事件后果勾选非死亡,死亡时间清空 
	$("input[type=radio][id^='MedNewEventResult-']").each(function(){
		if ($(this).is(':checked')){
			if(this.id=="MedNewEventResult-97739"){
				var DeathDate=$('#MedNewEventResult-97739-97915').datebox('getValue');
				RepSetRead("MedNewEventResult-97739-97915","datebox",0);
				RepSetValue("MedNewEventResult-97739-97915","datebox",DeathDate); 	//死亡日期
			}else{
				RepSetValue("MedNewEventResult-97739-97915","datebox",""); 	//死亡日期
			}
		}
	})
}
function checkother()
{
	var FindDate=$("#FindDate").datebox('getValue');
	var OccurDate=$("#OccurDate").datebox('getValue');
	if(!compareSelTowTime(FindDate,OccurDate)){
		$.messager.alert($g("提示")+":",$g("【日期】发生日期不能小于发现日期")+"！");
		return false;
	}
	var deadflag=0
	$("input[type=radio][id^='MedNewEventResult-']").each(function(){
		if ($(this).is(':checked')){
			if((this.id=="MedNewEventResult-97739")&&($("#MedNewEventResult-97739-97915").datebox('getValue')=="")){
				deadflag=-1;
					
			}
		}
	})
	if(deadflag=="-1")
	{
		$.messager.alert($g("提示")+":",$g("请选择死亡时间")+"！");
		return false;
	}
	
	var effDate=$("#MedAllDate-97761").datebox('getValue');
	var proDate=$("#MedAllDate-97762").datebox('getValue');
	var stopdate=$("#MedAllDate-97763").datebox('getValue');
	var impDate=$("#MedAllDate-97764").datebox('getValue');
	if(!compareSelTowTime(proDate,impDate)){
		$.messager.alert($g("提示")+":",$g("【日期】植入日期不能小于生产日期")+"！");
		return false;
	}
	if(!compareSelTowTime(impDate,stopdate)){
		$.messager.alert($g("提示")+":",$g("【日期】停用日期不能小于植入日期")+"！");
		return false;
	}
	if(!compareSelTowTime(proDate,effDate)){
		$.messager.alert($g("提示")+":",$g("【日期】有效期至不能小于生产日期")+"！");
		return false;
	}
	return true;
}
function DateTimecontrast(stDateTime,endDateTime)
{
	var ret=1;
	var reg = new RegExp(":","g")
	var stDate=stDateTime.split(" ")[0];
	var stTime=stDateTime.split(" ")[1]==undefined?"":stDateTime.split(" ")[1].replace(reg,"");
	var endDate=endDateTime.split(" ")[0];
	var endTime=endDateTime.split(" ")[1]==undefined?"":endDateTime.split(" ")[1].replace(reg,"");
	if((stDate!="")&&(endDate!="")&&(stDate>endDate)){
		ret=0;
	}else if((stDate==endDate)&&(stTime>endTime)){
		ret=0
	}else{
		ret=1;
	}
	return ret;
}
