/// Description: 用药错误报告单
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
$(document).ready(function(){
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	CheckTimeorNum();  //时间校验
	InitCheckRadio();//加载界面checkboxradio在父元素没有勾选的情况下，子元素不可勾选，填写
	InitReport(recordId);//加载页面信息
    GetAsseInfo();// 赋值给页面的评价转归信息
	
});
// 表单控制
function ReportControl(){
	//复选框按钮事件
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
}
//按钮控制与方法绑定
function InitButton(){
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //显示转归按钮		
		if(winflag==2){
			/// 评估按钮显示 意味着有评估权限，所以管路滑脱显示护士长评价按钮
			if($("#AssessmentBut").is(":visible")){ 
				$("#HeadNurEvaBut").show(); //显示评价按钮 2018-04-13 cy 评价界面
			}
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // 根据配置显示评价按钮 2019-07-25 cy
			}
		} 
		$("#AssessmentBut").hide(); //2019-07-26  隐藏医疗类型与没有原因分析的护理类型的评估按钮
	}
	// 护士长评价
	var HedNurEvaRecId=GetAssessRecordID("DrugHeaNurEvaluate");  
	$("#HeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("DrugHeaNurEvaluate",HedNurEvaRecId);
	})
	// 科护士长评价
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
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
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
		$.messager.alert("提示:","患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！");	
		return false;
	}
	///保存前,对页面必填项进行检查
	if(!(checkRequired()&&checkother())){
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
	InitCheckRadio();
}
//检查界面勾选其他，是否填写输入框
function checkother(){

	//错误类型 给药时间错误
	var dosetimeerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94617']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94617-94204").val()=="")||($("#DrugUseErrType-94617-94205").val()=="")){
				dosetimeerr=-1;
			}
		}
	})
	if(dosetimeerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'给药时间错误'，请填写内容！");	
		return false;
	}
	//错误类型 给药途径错误
	var dosewayerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94618']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94618-94208").val()=="")||($("#DrugUseErrType-94618-94209").val()=="")){
				dosewayerr=-1;
			}
		}
	})
	if(dosewayerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'给药途径错误'，请填写内容！");	
		return false;
	}
	//错误类型 遗漏给药
	var missdose=0;
	$("input[type=checkbox][id^='DrugUseErrType-94619']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94619-94212").val()=="")||($("#DrugUseErrType-94619-94213").val()=="")){
				missdose=-1;
			}
		}
	})
	if(missdose==-1){
		$.messager.alert("提示:","【错误类型】勾选'遗漏给药'，请填写内容！");	
		return false;
	}
	//错误类型 输液速度错误
	var infusionspeed=0;
	$("input[type=checkbox][id^='DrugUseErrType-94620']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94620-94215").val()=="")||($("#DrugUseErrType-94620-94216").val()=="")){
				infusionspeed=-1;
			}
		}
	})
	if(infusionspeed==-1){
		$.messager.alert("提示:","【错误类型】勾选'输液速度错误'，请填写内容！");	
		return false;
	}
	//错误类型 剂量错误
	var dosageerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94621']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94621-94219").val()=="")||($("#DrugUseErrType-94621-94220").val()=="")){
				dosageerr=-1;
			}
		}
	})
	if(dosageerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'剂量错误'，请填写内容！");	
		return false;
	}
	//错误类型 剂型错误
	var dosageformerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94622']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94622-94223").val()=="")||($("#DrugUseErrType-94622-94224").val()=="")){
				dosageformerr=-1;
			}
		}
	})
	if(dosageformerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'剂型错误'，请填写内容！");	
		return false;
	}
	//错误类型 药物错误
	var drugerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94623']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94623-94227").val()=="")||($("#DrugUseErrType-94623-94228").val()=="")){
				drugerr=-1;
			}
		}
	})
	if(drugerr==-1){
		$.messager.alert("提示:","【错误类型】勾选'药物错误'，请填写内容！");	
		return false;
	}
	
	return true;
}

//页面关联设置
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		//给药时间错误
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').attr("readonly",false);//医嘱给药时间
			$('#DrugUseErrType-94617-94205').attr("readonly",false);//错误给药时间
		}
		//给药途径错误
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').attr("readonly",false);//医嘱给药途径
			$('#DrugUseErrType-94618-94209').attr("readonly",false);//错误给药途径
		}
		
	}else{
		///给药时间错误
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').val("");
			$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //医嘱给药时间
			$('#DrugUseErrType-94617-94205').val("");
			$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //错误给药时间
		}
		//给药途径错误
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').val("");
			$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //医嘱给药途径
			$('#DrugUseErrType-94618-94209').val("");
			$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //错误给药途径
		} 
	}
}
//页面初始加载checkbox,radio控制子元素不可以填写
function InitCheckRadio(){
	//给药时间错误
	if($('#DrugUseErrType-94617').is(':checked')){
		$('#DrugUseErrType-94617-94204').attr("readonly",false);//医嘱给药时间
		$('#DrugUseErrType-94617-94205').attr("readonly",false);//错误给药时间
	}else{
		$('#DrugUseErrType-94617-94204').val("");
		$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //医嘱给药时间
		$('#DrugUseErrType-94617-94205').val("");
		$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //错误给药时间
	}
	//给药途径错误
	if($('#DrugUseErrType-94618').is(':checked')){
		$('#DrugUseErrType-94618-94208').attr("readonly",false);//医嘱给药途径
		$('#DrugUseErrType-94618-94209').attr("readonly",false);//错误给药途径
	}else{
		$('#DrugUseErrType-94618-94208').val("");
		$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //医嘱给药途径
		$('#DrugUseErrType-94618-94209').val("");
		$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //错误给药途径
	}
	//遗漏给药
	if($('#DrugUseErrType-94619').is(':checked')){
		$('#DrugUseErrType-94619-94212').attr("readonly",false);//遗漏次数
		$('#DrugUseErrType-94619-94213').attr("readonly",false);//医嘱给药时间
	}else{
		$('#DrugUseErrType-94619-94212').val("");
		$('#DrugUseErrType-94619-94212').attr("readonly","readonly"); //遗漏次数
		$('#DrugUseErrType-94619-94213').val("");
		$('#DrugUseErrType-94619-94213').attr("readonly","readonly"); //医嘱给药时间
	}
	//输液速度错误 
	if($('#DrugUseErrType-94620').is(':checked')){
		$('#DrugUseErrType-94620-94215').attr("readonly",false);//药物名称
		$('#DrugUseErrType-94620-94216').attr("readonly",false);//错误给药速度
	}else{
		$('#DrugUseErrType-94620-94215').val("");
		$('#DrugUseErrType-94620-94215').attr("readonly","readonly"); //药物名称
		$('#DrugUseErrType-94620-94216').val("");
		$('#DrugUseErrType-94620-94216').attr("readonly","readonly"); //错误给药速度
	}
	//剂量错误  
	if($('#DrugUseErrType-94621').is(':checked')){
		$('#DrugUseErrType-94621-94219').attr("readonly",false);//医嘱给药剂量
		$('#DrugUseErrType-94621-94220').attr("readonly",false);//错误给药剂量
	}else{
		$('#DrugUseErrType-94621-94219').val("");
		$('#DrugUseErrType-94621-94219').attr("readonly","readonly"); //医嘱给药剂量
		$('#DrugUseErrType-94621-94220').val("");
		$('#DrugUseErrType-94621-94220').attr("readonly","readonly"); //错误给药剂量
	}
	//剂型错误 
	if($('#DrugUseErrType-94622').is(':checked')){
		$('#DrugUseErrType-94622-94223').attr("readonly",false);//医嘱给药剂型
		$('#DrugUseErrType-94622-94224').attr("readonly",false);//错误给药剂型
	}else{
		$('#DrugUseErrType-94622-94223').val("");
		$('#DrugUseErrType-94622-94223').attr("readonly","readonly"); //医嘱给药剂型
		$('#DrugUseErrType-94622-94224').val("");
		$('#DrugUseErrType-94622-94224').attr("readonly","readonly"); //错误给药剂型
	}
	//药物错误 
	if($('#DrugUseErrType-94623').is(':checked')){
		$('#DrugUseErrType-94623-94227').attr("readonly",false);//医嘱给药名称
		$('#DrugUseErrType-94623-94228').attr("readonly",false);//错误给药名称
	}else{
		$('#DrugUseErrType-94623-94227').val("");
		$('#DrugUseErrType-94623-94227').attr("readonly","readonly"); //医嘱给药名称
		$('#DrugUseErrType-94623-94228').val("");
		$('#DrugUseErrType-94623-94228').attr("readonly","readonly"); //错误给药名称
	}
	
	
}
//时间 数字校验
function CheckTimeorNum(){
	//时间输入校验
	//给药时间错误 医嘱给药时间
	chktime("DrugUseErrType-94617-94204");
	
	//给药时间错误 错误给药时间
	chktime("DrugUseErrType-94617-94205");
	
	//遗漏给药 医嘱给药时间
	chktime("DrugUseErrType-94619-94213");
	
	
	//数字输入校验
	//遗漏给药 遗漏次数
	chknum("DrugUseErrType-94619-94212");

}
/* //登记号自动补0
function getRePatNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//通过住院号（病案号）获取病人基本信息
function PatMedNoEnter(){
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("提示:","病人病案号不能为空！");
				return;
			}
			var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			var mycols = [[
				{field:'RegNo',title:'病人id',width:80},
				{field:'AdmTypeDesc',title:'就诊类型',width:60}, 
				{field:'AdmLoc',title:'就诊科室',width:120}, 
				{field:'AdmDate',title:'就诊日期',width:80},
				{field:'AdmTime',title:'就诊时间',width:70},
				{field:'Adm',title:'Adm',width:60,hidden:true} 
			]];
			var mydgs = {
				url:'dhcadv.repaction.csp'+'?action=GetAdmList&Input='+patientNO ,
				columns: mycols,  //列信息
				nowrap:false,
				pagesize:10,  //一页显示记录数
				table: '#admdsgrid', //grid ID
				field:'Adm', //记录唯一标识
				params:null,  // 请求字段,空为null
				tbar:null //上工具栏,空为null
			}
			var win=new CreatMyDiv(input,$("#PatMedicalNo"),"drugsfollower","460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
			win.init();
		}
	});
}
//获取病案号选择记录数据
function SetAdmIdTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID="";
	}
	InitPatInfo(EpisodeID);
} */
//根据科室1查询科室2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //必须设置这个属性
	});   

}
/*//登记号回车事件
function PatIDEnter(){
	$('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var PatID=$('#PatID').val();
			 if (PatID=="")
			 {
				 	$.messager.alert("提示:","病人登记号不能为空！");
					return;
			 }
			 var PatID=getRegNo(PatID);
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'就诊科室',width:220}, 
			 	{field:'AdmDate',title:'就诊日期',width:80},
			 	{field:'AdmTime',title:'就诊时间',width:80},
			 	{field:'RegNo',title:'病人id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+PatID ,
				 columns: mycols,  //列信息
				 pagesize:10,  //一页显示记录数
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //记录唯一标识
				 params:null,  // 请求字段,空为null
				 tbar:null //上工具栏,空为null
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});	
}
//获取登记号选择记录数据
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	InitPatInfo(EpisodeID);
	
}*/
//2018-04-16 评价界面数据加载 
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	var PatOutcomRecId="";//转归表单记录id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"DrugHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"PatOutcomform"},
	function(data){ 
			 PatOutcomRecId=data
	},"text",false)
	
	if((HeadNurEvaRecId!="")&&(RepStaus!="填报")){SetRepInfo(HeadNurEvaRecId,"DrugHeaNurEvaluate");}
	if((LocHeadNurEvaRecId!="")&&((RepStaus=="科护士长审核")||(RepStaus=="护理部审核"))){SetRepInfo(LocHeadNurEvaRecId,"LocHeaNurEvaluate");}
	if((NurDepEvaRecId!="")&&(RepStaus=="护理部审核")){SetRepInfo(NurDepEvaRecId,"NurDepEvaluate");}
	//转归数据获取
	if((PatOutcomRecId!="")){SetRepInfo(PatOutcomRecId,"PatOutcomform");}
}
//2018-04-16 给表单界面评价内容赋值
function SetRepInfo(FormRecId,FormCode){
	var data="" ;
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
		{'ADVFormRecDr':FormRecId},
		function(datalist){ 
			 data=datalist
	},"json",false)
	if(FormCode=="DrugHeaNurEvaluate"){
		SetHeadNurInfo(data);
	}
	if(FormCode=="LocHeaNurEvaluate"){
		SetLocHeaNurInfo(data);
	}
	if(FormCode=="NurDepEvaluate"){
		SetNurDepInfo(data);
	}
	//转归数据赋值
	if(FormCode=="PatOutcomform"){
		SetPatOutcomInfo(data);
	}
}
function SetHeadNurInfo(data)
{
	var List="";
	var MornRepMeetDate=$g(data["MornRepMeetDate"]); //晨会报告日期
	if(MornRepMeetDate!=""){List=List+"晨会报告日期："+MornRepMeetDate+"；";}
	var MornRepMeetTime=$g(data["MornRepMeetTime"]); //晨会报告时间
	if(MornRepMeetTime!=""){List=List+"晨会报告时间："+MornRepMeetTime+"；";}
	var MornRepMeetPlace=$g(data["MornRepMeetPlace"]); //晨会地点
	if(MornRepMeetPlace!=""){List=List+"晨会地点："+MornRepMeetPlace+"；";}
	var MornRepMeetpants=$g(data["MornRepMeetpants"]); //晨会人员
	if(MornRepMeetpants!=""){List=List+"晨会人员："+MornRepMeetpants+"；";}
	var MornRepMeetContent=$g(data["MornRepMeetContent"]); //晨会内容
	if(MornRepMeetContent!=""){List=List+"晨会内容："+MornRepMeetContent+"；";}
     
	var MeetDate=$g(data["MeetDate"]); //会议日期
	if(MeetDate!=""){List=List+"\n会议日期："+MeetDate+"；";}
	var MeetTime=$g(data["MeetTime"]); //会议时间
	if(MeetTime!=""){List=List+"会议时间："+MeetTime+"；";}
	var MeetPlace=$g(data["MeetPlace"]); //会议地点
	if(MeetPlace!=""){List=List+"会议地点："+MeetPlace+"；";}
	var Participants=$g(data["Participants"]); //参会人员
	if(Participants!=""){List=List+"参会人员："+Participants+"；";}
	
	//个案改进（对应要素集中原因）
	var CaseImprovement=$g(data["CaseImprovement"]); 
	if(CaseImprovement!=""){List=List+"\n个案改进（对应要素集中原因）：\n"+CaseImprovement;}

	//管理改进
	var ManaImprovement=$g(data["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",data); 
	if (ManaImprovement!=""){
		List=List+"\n管理改进：  制度、流程及规范制定或修订（"+ManaImprovementzdoth+"名称："+ManaImprovement+"）；";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",data); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		List=List+"\n管理改进："+ManaImprovementoth+"。"
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		List=List+ManaImprovementoth+"。";
	}
	//患者转归 PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	if(PatOutcom!=""){List=List+"\n 患者转归："+PatOutcom;}

	// 护士长效果评价
	var ListHeadNurEva="";                       // 护士长效果评价加粗字体
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //护士长评价个数
	var HeadNurEvaluateList="护士长效果评价：";
	for(var k=0;k<HeadNurEvaluatelen;k++){
		var HNElist="\n<font style='font-Weight:bold;'>记录"+(k+1)+"</font>："    
		//var HNElist="\n记录"+(k+1)+"："
		var HNEdate=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94393-94398"]); //督查时间
		if(HNEdate!=""){HNElist=HNElist+"督查时间："+HNEdate+"。";}
		var HNEobject=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94394-94399"]); //督查对象
		if(HNEobject!=""){HNElist=HNElist+"督查对象："+HNEobject+"。";}
		var HNEcontent=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94395-94400"]); //督查内容
		if(HNEcontent!=""){HNElist=HNElist+"督查内容："+HNEcontent+"。";}		
		var HNEresult=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94396-94401"]); //督查结果
		if(HNEresult!=""){HNElist=HNElist+"督查结果："+HNEresult+"。";}		
		var HNEpeople=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94397-94403"]); //督查人
		if(HNEpeople!=""){HNElist=HNElist+"督查人："+HNEpeople+"。";}		
		HeadNurEvaluateList=HeadNurEvaluateList+HNElist
	}
	if(HeadNurEvaluateList!=""){ListHeadNurEva=ListHeadNurEva+HeadNurEvaluateList;}
	var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",data); 
	if(AftImpMeasures!=""){List=List+"\n事件发生后整改措施落实效果："+AftImpMeasures+"。";}
	var AftImpMeasuresoth=$g(data["AftImpMeasures-94925-94927"]);  //未落实 未落实原因： 
	if ((AftImpMeasuresoth!="")){
		List=List+"\n事件发生后整改措施落实效果：未落实 未落实原因："+AftImpMeasuresoth+"。";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n护理记录书写："+ManaIfStandard+"。";}
	
	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var HNheightlen=(HNrow+HeadNurEvaluatelen)*18;
	$("#FormCauseAnalysis").css({
		"height":HNheightlen
	});
	$('#FormCauseAnalysis').val(List);
	$('#FormCauseAnalysis').append('<div id="HeadNurEvaluate"></div>');
	$('#HeadNurEvaluate').html(ListHeadNurEva);

}

//2018-05-09 转归信息赋值
function SetPatOutcomInfo(data)
{
	//患者转归 PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	var POrow=0
	var POList=PatOutcom.split("\n")
	var POlen=POList.length;
	for(i=0;i<POlen;i++){
		POrow=POrow+parseInt(POList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var POheightlen=(POrow+1)*18;
	$("#FormPatOutcom").css({
		"height":POheightlen
	});
	$('#FormPatOutcom').val(PatOutcom);

}
