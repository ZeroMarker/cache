/*
Creator:LiangQiang
CreatDate:2016-01-15
Description:知识库监测查询
*/
var url='dhcpha.clinical.ckbaction.csp' ;
var levelArray=[{ "value":"", "text": "全部" },{ "value": "C", "text": "管制" },{ "value": "W", "text": "警示" },{ "value": "S", "text": "提示" }]; 


function BodyLoadHandler()
{	
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  
	
	$('#admLoc').combobox({
		mode:"remote",
		onShowPanel:function(){
			//$('#admLoc').combobox('reload',url+'?action=SelAllLoc')
			$('#admLoc').combobox('reload',url+'?action=GetAllLocNewVersion')
		}
	}); 
	
	// 管理级别
	$('#levelMan').combobox({
		panelHeight:"auto", 
		data:levelArray
	});  
	$('#levelMan').combobox('setValue',""); //设置combobox默认值
	
	//目录
	$('#label').combobox({
		onShowPanel:function(){
			$('#label').combobox('reload',url+'?action=GetLabel');
		}
 	});  
	$('#label').combobox('setText',"全部"); //设置combobox默认值
	
	$('#Find').bind("click",Query);  //点击查询
	$('#reset').bind("click",Reset);  // 重置	

	var columns =[[  
		      {field:'adm',title:'就诊id',width:50,hidden:true}, 
		      {field:'patNo',title:'登记号',width:80,align:'center',hidden:true},
              {field:'patName',title:'病人姓名',width:80,align:'center'},
			  {field:'medicalNo',title:'病案号',width:80,hidden:true}, 
			  {field:'admLocDesc',title:'就诊科室',width:160},
			  {field:'admDate',title:'就诊日期',width:80,align:'center'},
			  {field:'arcDesc',title:'医嘱名称',width:200},
              {field:'doseQty',title:'剂量',width:60,align:'center'},
			  {field:'unitDesc',title:'剂量单位',width:60,align:'center'},
			  {field:'instrDesc',title:'用法',width:80,align:'center'},
			  {field:'phFreqDesc',title:'频率',width:80,align:'center'},
			  {field:'course',title:'疗程',width:60,align:'center'},
			  {field:'rmanf',title:'生产厂家',width:200},
			  {field:'speciFaction',title:'规格',width:80},
			  {field:'labelDesc',title:'目录',width:80,align:'center'},
			  {field:'level',title:'管理级别',width:80,align:'center'},
			  {field:'trueMsg',title:'提示信息',width:300,showTip:true,tipWidth:450},
			  {field:'rowId',title:'rowId',hidden:true}
			  ]];

    $HUI.datagrid('#libdatagrid',{
		title:'',
		url:url+'?action=QueryLibOrdData',
		fit:true,
		rownumbers:true,
		showFooter:true,
		columns:columns,
		pageSize:100,  
		pageList:[100],   
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		singleSelect:true,
		idField:'rowid',
		striped: true, 
		pagination:true
		//nowrap:false
/* 		onLoadSuccess : function (data) {
		    if (data.total == 0) {
		        $('#libdatagrid').datagrid('insertRow', {
		            row : {}
		        });
		        $("tr[datagrid-row-index='0']").css({
		            "visibility" : "hidden"
		        });
		    }
		} */	
		
	});
	$('#libdatagrid').datagrid('loadData', {total:0,rows:[]}); 
	initScroll("#libdatagrid");//初始化显示横向滚动条
}


//查询
function Query()
{
    var stDate=$('#stdate').datebox('getValue');
	var endDate=$('#enddate').datebox('getValue');		//截止日期
	var levelMan=$('#levelMan').combobox('getValue');	//管理级别
	var label=$('#label').combobox('getValue'); 		//目录
	var labelDesc=$('#label').combobox('getText'); 	
	var admLoc=$('#admLoc').combobox('getValue'); 		//就诊科室
	if (admLoc === undefined){
		admLoc = "";
	}
	
 	var params=stDate+"^"+endDate+"^"+levelMan+"^"+label+"^"+labelDesc+"^"+admLoc; 
 	
	$('#libdatagrid').datagrid({
		url:url+'?action=QueryLibOrdData',	
		queryParams:{
			params:params}
	});
	$('#libdatagrid').datagrid('loadData', {total:0,rows:[]});  
}

/// Description:	查询条件重置
/// Creator:		QuNianpeng
/// CreateDate:		2017-09-18
function Reset()
{
	$("#stdate").datebox("setValue", formatDate(-1));  
	$("#enddate").datebox("setValue", formatDate(0));  
	
	$('#levelMan').combobox('setValue',"");
	$('#label').combobox('setValue',"");
	$('#admLoc').combobox('setValue',"");
	$('#label').combobox('setText',"全部"); //设置combobox默认值
	Query();
}

