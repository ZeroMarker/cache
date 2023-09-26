///Description:包医职业暴露不良事件报告单 
///Creator:    wangxuejian  
///CreatDate:  2018-05-20   
var RepDate=formatDate(0);               //系统的当前日期
$(document).ready(function(){
	ReportControl();                    //表单界面的控制	
	InitButton();               		//保存(包含了input隐藏框的验证)
	InitReport(recordId);           //加载报表信息

})

// 绑定保存、提交按钮
function InitButton()
{
	if (RepStaus!=""){
		if(winflag==2){
			/// 评估按钮显示 意味着有评估权限，所以职业暴露显示暴露者评估按钮
			if($("#AssessmentBut").is(":visible")){ 
				$("#ExpoAssBut").show(); //显示评价按钮 2020-02-20
			}
		}
		$("#ExpoFolBut").show(); //显示暴露者随访按钮
		$("#AssessmentBut").hide(); //2019-07-26  隐藏医疗类型与没有原因分析的护理类型的评估按钮
	}
	$("#SaveBut").on("click",function()
	{
	    SaveReport(0)                    //职业暴露事件表单的保存
	})
	$("#SubmitBut").on("click",function()
	{
	   SaveReport(1)
	})
	var ExpAssTreId=GetAssessRecordID("ExpAssTreatment"); 
	if(ExpAssTreId!=""){
		$("#ExpoAssBut").show();
	}
	$("#ExpoAssBut").on("click",function(){ 
		showAssessmentWin("ExpAssTreatment",ExpAssTreId);
	})
	var ExpFlupFormId=GetAssessRecordID("ExposerFlupForm"); 
	$("#ExpoFolBut").on("click",function(){ 
		showAssessmentWin("ExposerFlupForm",ExpFlupFormId);
	})
	
	
	
}

function ReportControl()    //表单界面的控制
{
	  //预防接种（如果预防接种选择是，则疫苗名称可以输入，如果选择否，则疫苗名称不能进行输入）
	 $("input[type=radio][id^='OccuExpVaccination']").each(function()
	 {
	    $(this).click(function()
	    {
	      if($(this).is(':checked'))
	      {
		     var id=this.id;
		     if(id=="OccuExpVaccination-97007")
		     {
			     RepSetRead("OccuExpVaccineName","input",2);  //疫苗名称
			    $('#OccuExpVaccineName').css("background-color","#fff");
		     }else
			 {
			    $('#OccuExpVaccineName').val("");                 //疫苗名称
			    $('#OccuExpVaccineName').css("background-color","#D4D0C8");
			    RepSetRead("OccuExpVaccineName","input",1);
			 }
		   }
	     })
	  })
	/*2018-06-06 有删除增加的table类型*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-10px","margin-right":"8px"})
	/// 暴露次数
	chknum("ExposeTimes",0,1);
	$('#ResponSex').combobox({editable:false});
}

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
//2018-04-14 关闭窗口
function CloseAsseWin(){
	$('#assewin').window('close');
}
