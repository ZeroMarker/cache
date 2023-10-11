/// Description: 失禁性皮炎
/// Creator: guoguomin
/// CreateDate: 2017-12-15
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	
	InitButton();
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	CheckTimeorNum()
	InitReport(recordId);//加载页面信息
	
});
function InitButton()
{
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
	
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheck(this.id);
		});
	});
	//单选框按钮事件
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //显示转归按钮		
		if(winflag==2){
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
		} 
	}
	var LocHeadNurEvaId=GetAssessRecordID("LocHeaNurEvaluate"); 
	if(LocHeadNurEvaId!=""){
		$("#LocHeadNurEvaBut").show();
	}
   	$("#LocHeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("LocHeaNurEvaluate",LocHeadNurEvaId);
	})
	// 护理部评价
	var NurDepEvaId=GetAssessRecordID("NurDepEvaluate");  
	if(NurDepEvaId!=""){
		$("#NurDepEvaBut").show();
	}
	$("#NurDepEvaBut").on("click",function(){ 
		showAssessmentWin("NurDepEvaluate",NurDepEvaId);
	})
	/// 转归界面
	$("#PatOutcomBut").on("click",function(){ 
		showPatOutcomWin("PatOutcomform");
	})
	
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
	///保存前,对页面必填项进行检查
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
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
		/// 渗出液
	InitUIStatus("DermaExudate");
	/// 伤口感染
	InitUIStatus("WoundInfection");
	/// 组织坏死
	InitUIStatus("TissueNecrosis");
	/// 疼痛
	InitUIStatus("DermaPain");
	/// 润肤
	InitUIStatus("DermaSkin");
	/// 临床分级
	InitUIStatus("ClinicalScale");

}
// 失禁性皮炎来源
function InitCheck(id){
	if(id.indexOf("Resourse-")>=0){
		// 院外带入
		if(id=="Resourse-94674"){
			$("input[type=checkbox][id^='Resourse-94675']").removeAttr("checked"); 
		}
		// 院内发生
		if(id=="Resourse-94675"){
			$("#Resourse-94674").removeAttr("checked"); 
		}
		// 院内发生 科内
		if(id=="Resourse-94675-94677"){
			$("#Resourse-94675-94678").removeAttr("checked");
			$("#Resourse-94674").removeAttr("checked"); 
		}
		// 院内发生 其他科室
		if(id=="Resourse-94675-94678"){
			$("#Resourse-94675-94677").removeAttr("checked"); 
			$("#Resourse-94674").removeAttr("checked"); 
		}		
	}
}

//时间 数字校验
function CheckTimeorNum(){	
	//数字输入校验  
	// 皮炎大小
	chknum("DermaSize",1,1,100);
}

///初始化界面复选框 单选事件
function InitUIStatus(id)
{
	var tmpid="";
	$("input[type=checkbox][id^="+id+"]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][id^="+id+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
