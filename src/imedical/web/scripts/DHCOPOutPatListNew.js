var OrdListColumns="";
var PatListDataGrid="";
$(function(){

	//初始化列表
	InitPatList();
	
	//$('#CallButton').click(CallHandler)
	///RegQue^AllPatient^ArrivedQue^Consultation^Report^RegFinish
	$('#RegQueButton').click(function(){
		LoadPatList("RegQue");
	});
	$('#ArrivedQueButton').click(function(){
		LoadPatList("ArrivedQue");
	});
	$('#RegFinishButton').click(function(){
		LoadPatList("RegFinish");
	});
	$('#ConsultationButton').click(function(){
		LoadPatList("Consultation");
	});
	
});


function InitPatList(){
	OrdListColumns=[[
		{ field: 'EpisodeID', hidden:true},
		{ field: 'PatientID', hidden:true},
		{ field: 'mradm', hidden:true},
		{ field: 'LocSeqNo', title: '顺序号', width: 60,sortable: true,formatter: 
			function(value,row,index){
				return reservedToHtml(value)
			}
        }, 
		{ field: 'PAPMINO', title: '门诊号', width: 60,sortable: true}, 
		{ field: 'PAPMIName', title: '病人姓名', width: 60,sortable: true,formatter:
		  function(value,row,index){
				return reservedToHtml(value)
		  }
		},
		{ field: 'PAPMISex', title: '性别', width: 60,sortable: true}, 
		{ field: 'Age', title: '年龄', width: 60,sortable: true}, 
		{ field: 'RegDoctor', title: '号别', width: 60,sortable: true}, 
		{ field: 'PAAdmReason', title: '病人类型', width: 60,sortable: true}, 
		{ field: 'PAAdmDate', title: '就诊日期', width: 60,sortable: true}, 
		{ field: 'PAAdmTime', title: '就诊时间', width: 60,sortable: true}, 
		{ field: 'Diagnosis', title: '诊断', width: 60,sortable: true}, 
		{ field: 'PAAdmDocCodeDR', title: '医生', width: 60,sortable: true}, 
		{ field: 'WalkStatus', title: '状态', width: 60,sortable: true}, 
		{ field: 'PAAdmPriority', title: '优先级', width: 60,sortable: true}
	]];
	/*
	PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,
	PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%String,
	PAAdmTime:%String,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,
	PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,
	FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,
	PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,
	ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,
	LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,
	ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,
	PriorityCode:%String,Called:%String,RegDocDr:%String,TPoliticalLevel:%String,TSecretLevel:%String,RegRangeTime
	*/
	
	PatListDataGrid=$('#PatList').datagrid({
		width : "800px",
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"EpisodeID",
		singleSelect: true,
		pageList : [15,50,100,200],
		columns :OrdListColumns,
		onClickRow:function(rowIndex, rowData){
			$('#ReCallPatList').datagrid('clearSelections');
			///选中事件
		},
		onDblClickRow:function(rowIndex, rowData){
			///双击选中事件
			//此处可做选中病人然后关闭窗口，并刷新主页面的方法
			var EpisodeID=rowData.EpisodeID;
			var PatientID=rowData.PatientID;
			var mradm=EpisodeID;
			if ((EpisodeID=="")||(PatientID=="")||(mradm=="")){
				return
			}
			//todo _patientID, _episodeID, _mradm
			SelectPat(PatientID, EpisodeID, mradm);
		},
		loadError:function(xhr,status,error){
			alert("DHCOPOutPatListNew.js-err:"+status+","+error);
			//xhr：XMLHttpRequest 对象；status：错误类型，字符串类型；error：exception对象
		},
		rowStyler: function(index,row){
		}
	});
	LoadPatList("RegQue");
	
	
}
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}

function LoadPatList(CheckName){
	var queryParams = new Object();
	/*queryParams.ClassName ='web.DHCDocOutPatientList';
	queryParams.QueryName ='FindLocDocCurrentAdm';
	var IPAddress=GetComputerIp()
	queryParams.Arg1 =session['LOGON.CTLOCID'];
	queryParams.Arg2 =session['LOGON.USERID'];
	queryParams.Arg3=IPAddress;
	queryParams.Arg4="";
	queryParams.Arg5="";
	queryParams.Arg6="";
	queryParams.Arg7="";
	queryParams.Arg8="";
	queryParams.Arg9="";
	queryParams.Arg10="";
	queryParams.Arg11="";
	queryParams.Arg12="";
	queryParams.Arg13=CheckName;
	queryParams.ArgCnt =13;*/
	
		//Type As %String = 0, PatientNo As %String = "", Name As %String = "", 
	//MedicalNo As %String = "", PAADMType As %String = "I", CardNo As %String = "", 
	//OutStartDate As %Date = "", OutEndDate As %Date = "", OutArrivedQue As %String = "", OutRegQue As %String = "", 
	//OutConsultation As %String = "", OutAllPatient As %String = "", AdmReqNo As %String = "", MarkID
    if(CheckName=="ArrivedQue"){
		var ArrivedQue="on"
	}else{
		var ArrivedQue=""	
	}
	if(CheckName=="RegQue"){
		var RegQue="on"
	}else{
		var RegQue=""	
	}
	if(CheckName=="Consultation"){
		var Consultation="on"
	}else{
		var Consultation=""	
	}	
    queryParams.ClassName ='web.DHCDocMainOut';
	queryParams.QueryName ='FindCurrentAdmProxy';
	queryParams.Arg1 ="";
	queryParams.Arg2 ="";
	queryParams.Arg3="";
	queryParams.Arg4="";
	queryParams.Arg5=PAADMType ;
	queryParams.Arg6="";
	queryParams.Arg7="";
	queryParams.Arg8="";
	queryParams.Arg9=ArrivedQue;
	queryParams.Arg10=RegQue;
	queryParams.Arg11=Consultation;
	queryParams.Arg12="";
	queryParams.Arg13="";
	queryParams.Arg14="";
	queryParams.ArgCnt =14;
	debugger;
	var opts = PatListDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	PatListDataGrid.datagrid('load', queryParams);
	
}

function SelectPat(_patientID, _episodeID, _mradm){
	var returnValue = new Object();
	returnValue.PatientID = _patientID;
	returnValue.EpisodeID = _episodeID;
	returnValue.MRAdm = _mradm;
	window.returnValue = returnValue;
    closeWindow();
}

function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

function GetComputerIp()
{
	var ipAddr="";
	try
	{
	   var obj = new ActiveXObject("rcbdyctl.Setting");
	   ipAddr=obj.GetIPAddress;
	   obj = null;
	}
	catch(e)
	{
	   //alert("Exception");
	}
	return ipAddr;
}