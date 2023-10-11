/// Description: 一次性医疗用品不良事件报告单
/// Creator: congyue
/// CreateDate: 2017-12-18
var eventtype=""
var RepDate=formatDate(0); //系统的当前日期
$(document).ready(function(){
	ReportControl();			// 表单控制  	
	InitButton();				// 初始化按钮
	InitReport(recordId);//加载页面信息
	
});
// 表单控制
function ReportControl(){
	// 停用日期控制
	chkdate("DisMedThingDeactivateDate");
	// 植入日期（若植入）控制
	chkdate("DisMedThingImlantDate");
}
//按钮控制与方法绑定
function InitButton(){
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
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
	})}

//加载报表信息
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){	
	}else{
    	$("#from").form('validate');			
	}
}
//报告保存
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("提示:"),$g("患者姓名为空，请输入登记号或病案号回车选择记录录入患者信息！"));	
		return false;
	}
	if(!compareSelTowTime($('#DisMedThingImlantDate').datebox('getValue'),$('#DisMedThingDeactivateDate').datebox('getValue')))
	{
		$.messager.alert($g("提示:"),$g("【植入日期】不能大于【停用日期】！"));
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
			//var  patientNO=getRePatNo(patientNO);
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
}
//登记号回车事件
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
/* //确认审批  2018-04-24
function FormConfirmAudit()
{	
	var NextLoc="";  //$('#matadrNextLoc').combobox('getValue');
	var LocAdvice="";  //$('#matadrLocAdvice').val();
	var params=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode;   //参数串
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':params},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
		}
		if(jsonString.ErrCode == 0){
			window.parent.CloseWinUpdate();
			window.parent.Query();
		}
	},"json");
		
}
//撤销审批 2018-04-24
function FormCancelAuditBt()
{	var NextLoc="" //$('#matadrNextLoc').combobox('getValue');
	var LocAdvice="" //$('#matadrLocAdvice').val();
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("提示:","报告为驳回报告，且未驳回给当前登录人，无权限撤销审核！");
		return;
	}
	var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode;   //参数串
	//alert(params);
	//保存数据
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
	function(jsonString){ 
		//var resobj = jQuery.parseJSON(jsonString);
		//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  获取行数 区分哪一行操作出错
		if(jsonString.ErrCode < 0){
			$.messager.alert("提示:","审核错误,错误原因:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"第"+errnum+"条数据"
		}
		if(jsonString.ErrCode == 0){
			window.parent.CloseWinUpdate();
			window.parent.Query();
		}
	},"json");
		
}
 */
