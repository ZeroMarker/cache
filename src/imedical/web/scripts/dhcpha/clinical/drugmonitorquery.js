/// Creator: bianshuai
/// CreateDate: 2015-1-29
//  Descript: 监护信息查询

var url="dhcpha.clinical.action.csp";

$(function(){
	$("#stdate").datebox("setValue", formatDate(-2));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//病区
	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
	});
	
	//科室
	$('#dept').combobox({
		onShowPanel:function(){
			$('#dept').combobox('reload',url+'?action=SelAllLoc&loctype=E')
		}
	});
	
	//监护级别
	$('#monLevel').combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		onShowPanel:function(){
		//	$('#monLevel').combobox('reload',url+'?action=GetLevelComb')
			$('#monLevel').combobox('reload',url+'?action=SelMonLevel') //qunianpeng 2016-08-10
		}
	});
	
	//登记号回车事件
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
	
	$('a:contains("查询")').bind("click",Query); //日志
	 
	//初始化病人列表
	InitPatList();
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var WardID=$('#ward').combobox('getValue');    //病区ID
	var LocID=$('#dept').combobox('getValue');     //科室ID
	var MonLevel=$('#monLevel').combobox('getValue');  //监护级别
	if (typeof LocID=="undefined"){LocID="";}
	if (typeof WardID=="undefined"){WardID="";}
	if (typeof MonLevel=="undefined"){MonLevel="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+MonLevel+"^"+PatNo;

	$('#maindg').datagrid({
		url:url+'?action=QueryPhaCare',	
		queryParams:{
			params:params}
	});
}

///补0病人登记号
function GetWholePatID(RegNo)
{    
	if (RegNo=="") {
		return RegNo;
	}
	var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON","GetPatRegNoLen");
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('错误提示',"登记号输入错误！");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patno").val(RegNo);
}

//初始化病人列表
function InitPatList()
{
	//定义columns
	var columns=[[
		{field:'MonDetail',title:'详细信息',width:100,align:'center',formatter:setCellUrl},
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:120},
		{field:'monCount',title:'监护次数',width:120,align:'center'},
		{field:'monWard',title:'病区',width:280},
		{field:'monWardID',title:'monWardID',width:100,hidden:true},
		{field:'monLocID',title:'monLocID',width:100,hidden:true},
		{field:'monLocDesc',title:'科室',width:240},
		{field:'monSubClassId',title:'monSubClassId',width:100,hidden:true},
		{field:'monSubClass',title:'学科分类',width:240},
		{field:'monAdmID',title:'monAdmID',width:100,hidden:true}
	]];
	
	//定义datagrid
	$('#maindg').datagrid({
		title:'病人列表',
		fit:true,
		nowrap:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // 每页显示的记录条数
		pageList:[40,80],   // 可以设置每页记录条数的列表
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		pagination:true
	});
	
	initScroll("#maindg");//初始化显示横向滚动条
        $('#maindg').datagrid('loadData', {total:0,rows:[]});
}

///设置编辑连接
function setCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showEditWin("+rowData.monAdmID+","+rowData.monSubClassId+")'>详细信息</a>";
}

function showEditWin(monAdmID,monSubClassId){

	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:"监护信息查询",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.pharcarequery.csp?monAdmID='+monAdmID+'&monSubClassId='+monSubClassId+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}