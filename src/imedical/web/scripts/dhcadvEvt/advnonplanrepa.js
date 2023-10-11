///Description: 非计划再次手术报告单
///Creator: lp
///Creatdate: 18-5-10
var RepDate=formatDate(0); 	//系统的当前日期
var Opename=""; // 手术名称 code
$(document).ready(function(){
	InitButton();				// 初始化按钮
	reportControl();			// 表单控制  	
	InitNonPlanReport(recordId);//加载页面信息
	InitLayoutHtml();			//初始化页面布局 18-1-20
})
function InitButton(){
	
	// 保存
	$("#SaveBut").on("click",function(){
		SavePipeReport(0);
	})
	
	// 提交
	$("#SubmitBut").on("click",function(){
		SavePipeReport(1);
	})	
	
}
// 表单控制
function reportControl(){
	// 原手术日期
	chkdate("NonPlanRepaTheOperDate");
	// 拟手术日期
	//chkdate("NonPlanRepaAgainOperDate");
	RepOpeEnter("NonPlanRepTheOperName");
	RepOpeEnter("NonPlanRepAgainOperName");

}

//加载报表病人信息
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}

//加载报表信息
function InitNonPlanReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//病人信息
    	$("#from").form('validate');			
	} 
}

//报告保存
function SavePipeReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！"));	
		return false;
	} 
	///保存前,对页面必填项进行检查
	 if(!checkRequired()){
		return;
	}

	SaveReportCom(flag);
}


function InitLayoutHtml(){
	$('#NonPlanRepaDiag').css('width','500px');
	$('#NonPlanRepaDiag').css('max-width','500px');
	$('#NonPlanRepaAgainOperRes-738').css('width','500px');
	$('#NonPlanRepaAgainOperRes-738').css('max-width','500px');
	$('#NonPlanRepaOperGoal').css('width','500px');
	$('#NonPlanRepaOperGoal').css('max-width','500px');
	$('#lableNonPlanRepaAgainOperRes-735-736 .lable-input').css({
		'float':'left',
		'margin-left':'50px',
		'width':'300px',
		'max-width':'300px'
	}
	)
}



function doOther(obj){
	//控制类别和轻重程度
	id=$(obj).attr("id")
	parref=$(obj).parent().attr("data-parref");
	if(parref.indexOf("MedAdvEventLev")>=0){
		if($(obj).attr("checked")=="checked"){
			$("label[data-parref='MedAdvInjuryLevByType']").show();
			$("label[data-parref='"+parref+"']").not("#lable"+id).children().removeAttr("checked");
			if(id=="MedAdvEventLev-641"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-654').hide();	
			}if(id=="MedAdvEventLev-642"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-653,#lableMedAdvInjuryLevByType-652,#lableMedAdvInjuryLevByType-651,#lableMedAdvInjuryLevByType-650').hide();	
			}if(id=="MedAdvEventLev-643"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-649,#lableMedAdvInjuryLevByType-648,#lableMedAdvInjuryLevByType-647').hide();	
			}if(id=="MedAdvEventLev-644"){
				$("label[data-parref='MedAdvInjuryLevByType']").not('#lableMedAdvInjuryLevByType-646').hide();	
			}
		}else{
			$("label[data-parref='MedAdvInjuryLevByType']").each(function(){
				$(this).show();	
			})
		}	
	}
}

//通过就诊id获取病人手术基本信息
function RepOpeEnter(id){
	if((recordId!="")&&(recordId!=undefined)){
		return ;
	}else{
		$('#'+id).bind('keydown',function(event){
			if(event.keyCode == "13")    
			{
				if(EpisodeID==""){
					$.messager.alert($g("提示:"),$g("请先选择患者就诊记录！"));
					return;
				}
				if($("#admopegrid").length>0)
				{
				   $("#admopegrid").remove(); 
				}
				GetOpeGridWin(EpisodeID,id);
			}
		});
	}
	
}
//通过住院号（病案号）、登记号 获取病人基本信息
function GetOpeGridWin(EpisodeID,id){
	Opename=id;
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols = [[
		{field:'OPSID',title:$g('手术申请ID'),width:80},
		{field:'AppCareProvDesc',title:$g('申请医生'),width:60},
		{field:'OperDesc',title:$g('手术描述'),width:60}, 
		
		{field:'SourceTypeDesc',title:$g('手术类型'),width:120}, 
		{field:'StatusDesc',title:$g('手术状态'),width:80},
		{field:'OperDate',title:$g('手术开始日期'),width:70},
		{field:'ROperDuration',title:$g('手术时长'),width:70}
		
		//{field:'Adm',title:'Adm',width:60,hidden:true} 
	]];
	var mydgs = {
		//url:'dhcadv.repaction.csp'+'?action='+actiontype+'&Input='+patientNO+'&Type='+""+'&LgHospID='+LgHospID , //hxy 2020-02-18 +'&LgHospID='+LgHospID 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVINTERFACE&MethodName=QueryPatOpeList'+'&EpisodeID='+EpisodeID,
		columns: mycols,  //列信息
		nowrap:false,
		pagesize:10,  //一页显示记录数
		table: '#admdsgrid', //grid ID
		field:'OPSID', //记录唯一标识
		params:null,  // 请求字段,空为null
		tbar:null //上工具栏,空为null
	}
	var win=new CreatMyDiv(input,$("#"+id),"admopegrid","460px","335px","admdsgrid",mycols,mydgs,"","",SetPatOpeVal);	
	win.init();
}
//获取病案号/登记号选择记录数据
function SetPatOpeVal(Data)
{
	var OperDesc=Data.OperDesc;		//手术名称		
		var AppCareProvDesc=Data.AppCareProvDesc;  				// 手术医师
		var ROperDuration=Data.ROperDuration;					// 手术时长
		var OperDate=Data.OperDate;					// 手术开始日期
	if(Opename=="NonPlanRepTheOperName"){
		RepSetValue("NonPlanRepTheOperName","input",OperDesc); 
		RepSetRead("NonPlanRepTheOperName","input",1);
		RepSetValue("NonPlanRepaTheBthDoc","input",AppCareProvDesc);
		RepSetRead("NonPlanRepaTheBthDoc","input",1);
		RepSetValue("NonPlanRepaOperDurTime","input",ROperDuration);
		RepSetRead("NonPlanRepaOperDurTime","input",1);		
      	if(OperDate!=""){
			RepSetRead("NonPlanRepaTheOperDate","datebox",1);
			RepSetValue("NonPlanRepaTheOperDate","datebox",OperDate);
		}else {
			RepSetRead("NonPlanRepaTheOperDate","datebox",0);
			RepSetValue("NonPlanRepaTheOperDate","datebox","");
		}			
	}
	
	if(Opename=="NonPlanRepAgainOperName"){
		var NonPlanRepaTheOperDate=$("#NonPlanRepaTheOperDate").datebox("getValue");
		if(NonPlanRepaTheOperDate==""){
			$.messager.alert($g("提示:"),$g("请先选择患者原手术记录！"));
			return;
		}
		if((NonPlanRepaTheOperDate!="")&&(!compareSelTowTime(NonPlanRepaTheOperDate,OperDate))){
			$.messager.alert($g("提示:"),$g("再次手术日期不能小于原手术日期！"));
			return;
		}
		RepSetValue("NonPlanRepAgainOperName","input",OperDesc); 
		RepSetRead("NonPlanRepAgainOperName","input",1);
		RepSetValue("NonPlanRepaAgainBthDoc","input",AppCareProvDesc);
		RepSetRead("NonPlanRepaAgainBthDoc","input",1);
      	if(OperDate!=""){
			RepSetRead("NonPlanRepaAgainOperDate","datebox",1);
			RepSetValue("NonPlanRepaAgainOperDate","datebox",OperDate);
		}else {
			RepSetRead("NonPlanRepaAgainOperDate","datebox",0);
			RepSetValue("NonPlanRepaAgainOperDate","datebox","");
		}			
	}
	
}
