///Creator:sufan
///date:2016/10/25
//页面初始化函数
function initPageDefault()
{
	initPatientlist();   // 初始化病人列表
	initCombobox();		 // 初始化页面的下拉框
	initButton();		 // 初始化按钮
}
function initPatientlist()
{
	///  定义columns
	var columns=[[
		{field:'PatientID',title:'病人ID',width:80,align:'center',hidden:'true'},
		{field:'PatNo',title:'登记号',width:80,align:'center'},
		{field:'PatName',title:'姓名',width:80,align:'center'},
		{field:'SexDesc',title:'性别',width:60,align:'center'},
		{field:'PatAge',title:'年龄',width:60,align:'center'},
		{field:"AdmDate",title:'就诊日期',width:100,align:'center'},
		{field:'CtlocDesc',title:'就诊科室',width:150,align:'center'},
		{field:'WardDesc',title:'就诊病区',width:150,align:'center'},
		{field:"MainDiag",title:'诊断',width:200,align:'center'},
		{field:'AdmDocName',title:'医生',width:100,align:'center'},
		{field:'PhaomResult',title:'重点患者标志',width:120,align:'center'},
		{field:'Statues',title:'药历状态',width:100,align:'center'}
	]];
	/// 初始化 datagrid
	$('#patientlist').datagrid({
		title:'',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:20,  // 每页显示的记录条数
		pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
}

/// 页面Combobox初始定义
function initCombobox()
{
	
	//病区
	var uniturl = LINK_CSP+"?ClassName=web.DHCCM.QueryPatient&MethodName=";	
	var url = uniturl+"SelAllWard";
	new ListCombobox("wing",url,'').init();
	$("#wing").combobox("setValue");
	
	//临床路径 
	var uniturl = LINK_CSP+"?ClassName=web.DHCSTPHCMCOMMON&MethodName=";	
	var url = uniturl+"ClinPathWayDic";
	new ListCombobox("pathway",url,'').init();
	$("#pathway").combobox("setValue");
}
function initButton()
{
	//查询按钮
	$('a:contains("查询")').bind("click",querypatientinfo);
	
	//登记号
	$("#patno").bind('keypress',function(event){       
        if(event.keyCode == "13"){
	        GetRegno();
            querypatientinfo();
          }
         });
}
function querypatientinfo()
{
	var Patno=$("#patno").val();
	var Pathway=$("#pathway").combobox("getText");
	var MedicalNum=$("#idnum").val();
	var Ward=$("#wing").combobox("getValue");
	var params=Patno+"^"+Pathway+"^"+MedicalNum+"^"+Ward;
	$('#patientlist').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCCM.QueryPatient&MethodName=GetPatientinfoByWard',	
			queryParams:{
			params:params}
			});
}

function resetasklist()
{
	$("#patno").val("");
	$("#pathway").combobox("setValue","");
	$("#idnum").val("");
	$("#wing").combobox("setValue","");
	querypatientinfo();
	//$('#patientlist').datagrid('loaddata',{total:0,rows:[]});
}
function GetRegno()
{
	var Patno=$("#patno").val();
	var Patnolen=Patno.length;
	var zerolen=10-Patnolen;
	for (var i=1;i<=zerolen;i++)
	{
		var Patno=0+Patno;
	}
	var Patno=$("#patno").val(Patno);
}

$(function(){ initPageDefault(); })