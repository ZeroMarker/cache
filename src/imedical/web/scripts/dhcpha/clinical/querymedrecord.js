///Creator:sufan
///date:2016/10/28
var url="dhcpha.clinical.action.csp";
var StatusArray = [{ "value": "Save", "text": $g('完成') }];
var HospID=session['LOGON.HOSPID']
function initPageDefault()
{
	initMedrecordlist();   // 初始化药历列表
	initButton();		   // 初始化页面的按钮
	initCombobox();		   // 初始化页面的下拉框
	GetDateStr();		   // 初始化时间
}
///定义datagrid
function initMedrecordlist()
{
	//  定义columns
	var columns=[[
		{field:'PatientID',title:$g('病人ID'),width:80,align:'center',hidden:'true'},
		{field:'Admdr',title:$g('就诊号'),width:80,align:'center',hidden:'true'},
		{field:'Patno',title:$g('登记号'),width:80,align:'center'},
		{field:'PatName',title:$g('姓名'),width:80,align:'center'},
		{field:'SexDesc',title:$g('性别'),width:60,align:'center'},
		{field:'PatAge',title:$g('年龄'),width:60,align:'center'},
		{field:'CtlocDesc',title:$g('就诊科室'),width:100,align:'center'},
		{field:'WardDesc',title:$g('就诊病区'),width:100,align:'center'},
		{field:"MainDiag",title:$g('诊断'),width:300,align:'center'},
		{field:'Episodtype',title:$g('病人类型'),width:60,align:'center'},
		{field:'status',title:$g('药历状态'),width:100,align:'center'},
		{field:"Createuser",title:$g('药师'),width:200,align:'center'},
		{field:'operate',title:$g('操作'),width:100,align:'center',formatter:getpatientrecord},
	]];
	// 初始化 datagrid
	$('#medrecordlist').datagrid({
		title:'',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:20,  		// 每页显示的记录条数
		pageList:[20,40],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		pagination:true
	});
	$('#medrecordlist').datagrid('loadData', {total:0,rows:[]}); 
}

/// 初始化按钮
function initButton()
{
	// 查询按钮
	$('a:contains('+$g("查询")+')').bind("click",querymedrecord);
	
	// 回车事件
	$("#patno").bind("keypress",function(event){
		if(event.keyCode==13)
		{
			var patno=$("#patno").val();
			getpatno(patno);    // 补全登记号
			querymedrecord();
			}
		});
}

/// 补全登记号位数
function getpatno(patno)
{
	if(patno!=""){
	var patnolen=patno.length;
	var len=10-patnolen
	for (var i=0;i<len;i++)
	{
		patno="0"+patno;
		}
	$("#patno").val(patno)
	}
}

/// 初始化combobox
function initCombobox()
{
	// 药历状态
	var StatusCombobox = new ListCombobox("statue",'',StatusArray,{panelHeight:"auto",editable:false});
	StatusCombobox.init();
	//$("#statue").combobox("setValue","Save");
   
	// 病区
	/*var uniturl = LINK_CSP+"?ClassName=web.DHCCM.QueryPatient&MethodName=";	
	var url = uniturl+"SelAllWard";
	new ListCombobox("wing",url,'').init();
	$("#wing").combobox("setValue");*/
	 $('#wing').combobox({
		mode:'remote',	
		onShowPanel:function(){ //liubeibei 2018/7/3 支持拼音码和汉字
			$('#wing').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+HospID+'  ')			
		}
	});
}

/// 查询
function querymedrecord()
{
	var stdate=$("#stdate").datebox("getValue");
	var enddate=$("#enddate").datebox("getValue");
	var medicalno=$("#idnum").val();
	var patno=$("#patno").val();
	var ward=$("#wing").combobox("getText");
	var statues=$("#statue").combobox("getValue");
	params=stdate+"^"+enddate+"^"+medicalno+"^"+ward+"^"+patno+"^"+statues+"^"+HospID;
	$('#medrecordlist').datagrid(
		{
			url:'dhcapp.broker.csp?ClassName=web.DHCCM.QueryPatient&MethodName=QueryMedRecord',	
			queryParams:{
			params:params}
			});
}

/// 设置日期
function GetDateStr() 
{ 
	var now=new Date();			// 当前日期
	var y = now.getFullYear();
	var m = now.getMonth()+1;             
	var d = now.getDate(); 
	if (m<=9)
	{
		var m="0"+m;
		}
	if (d<=9)
	{
		var d="0"+d;
		}
	var startdate=y + "-" + m + "-" + d;
	$("#enddate").datebox("setValue",startdate);
	var lastdate=new Date(now.getTime()-1*24*3600*1000)   // 当前日期的前一天
	var year=lastdate.getFullYear();
	var month=lastdate.getMonth()+1;
	var day=lastdate.getDate();
	if (month<=9)
	{
		var month="0" + month;
		}
	if (day<=9)
	{
		var day="0" + day;
		}
	var enddate=year + "-" + month + "-" + day
	$("#stdate").datebox("setValue",enddate);
} 

// 操作
function getpatientrecord(value, rowData, rowIndex)
{   
	patientID=rowData.PatientID
	episodeID=rowData.Admdr
	patientName=rowData.PatName
	episodeType=rowData.Episodtype
	episodeLocID=rowData.AdmDocId
	statues=rowData.status
	/* if (statues=="在建")
	{
			var html = "";
			html = "<a href='#' style='margin:0px 5px;font-weight:bold;color:#DCDCDC;text-decoration:none;'>查看药历列表</a>";
		}
	else{
			var html = "";
			html = "<a href='#' onclick=\"newCreateConsultWin('"+patientID+"','"+episodeID+"','"+patientName+"','"+episodeType+"','"+episodeLocID+"')\" style='margin:0px 5px;font-weight:bold;color:blue;text-decoration:none;'>查看药历列表</a>";
    
    	} */
    	var html = "";
			html = "<a href='#' onclick=\"newCreateConsultWin('"+patientID+"','"+episodeID+"','"+patientName+"','"+episodeType+"','"+episodeLocID+"')\" style='margin:0px 5px;font-weight:bold;color:blue;text-decoration:none;'>"+$g("查看药历列表")+"</a>";
    return html;
}

function newCreateConsultWin(patientID,episodeID,patientName,episodeType,episodeLocID)
{
	if($('#winonline').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="winonline"></div>');
	$('#winonline').window({
		title:patientName+"-"+$g('药历列表'),
		collapsible:true,
		border:false,
		closed:"true",
		width:1370,
		height:600,
		minimizable : false,
		maximizable : false,
		collapsible:true		
	});
	$('#winonline').window('open');
	var iframe='<iframe id="scanrecord" scrolling="yes" width=100% height=100%  frameborder="0" src=""></iframe>';
		$('#winonline').html(iframe);
		LoadBrowsePage(patientID,episodeID,episodeType,episodeLocID);
	
	
}

/// 加载病历浏览页面
function LoadBrowsePage(patientID,episodeID,episodeType,episodeLocID)
{
	var url = "dhcpha.clinical.drugbrows.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+episodeLocID+"&AdmType="+episodeType;
	$('#scanrecord').attr("src",url);
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })