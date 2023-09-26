var PageLogicObj={
	m_CardQryTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	//表格数据初始化
	CardQryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_CardQryTabDataGrid=InitCardQryTabDataGrid();
}
function InitCardQryTabDataGrid(){
	var Columns=[[ 
		{field:'TCardType',title:'卡类型',width:100},
		{field:'CardNo',title:'卡号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PAPMNo',title:'登记号',width:100},
		{field:'OperName',title:'操作员',width:90},
		{field:'CardStatus',title:'当时卡状态',width:90},
		{field:'OperDate',title:'操作时间',width:150},
		{field:'ComIP',title:'办理机器',width:180},
		{field:'AppName',title:'申请人姓名',width:100},
		{field:'AppAddress',title:'申请人地址',width:100},
		{field:'AppIDType',title:'申请人证件类型',width:100},
		{field:'AppIDNo',title:'申请人证件号码',width:160},
		{field:'AppTelNo',title:'申请人电话号码',width:120},
		{field:'Remark',title:'备注',width:80},
		{field:'TPoliticalLevel',title:'患者级别',width:80},
		{field:'TSecretLevel',title:'患者密级',width:80}
    ]]
	var CardQryTabDataGrid=$("#CardQryTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'No',
		columns :Columns,
		onClickRow:function(index, row){
			SetSelRowData(row);
		}
	});
	return CardQryTabDataGrid;
}
function InitEvent(){
	$('#Bfind').click(CardQryTabDataGridLoad);
}
function PageHandle(){
	$("#StDate,#EndDate").datebox('setValue',ServerObj.CurDay);
	InitUserCodeA();
}
function CardQryTabDataGridLoad(){
	$.q({
	    ClassName : "web.UDHCAccCardManage",
	    QueryName : "ReadCardExInfo",
	    CardNo:$("#CardNo").val(), UserCode:"", StDate:$("#StDate").datebox('getValue'), 
	    EndDate:$("#EndDate").datebox('getValue'), CardStatus:"", UserCodeA:$("#UserCodeA").lookup('getText'),
	    Pagerows:PageLogicObj.m_CardQryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardQryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function InitUserCodeA(){
	$("#UserCodeA").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'代码',
        textField:'姓名',
        columns:[[  
            {field:'代码',title:'',hidden:true},
			{field:'姓名',title:'名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.UDHCOPOtherLB',QueryName: 'ReadSSUser'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{CTCode:desc});
	    },
	    onSelect:function(index, rec){
		}
    });
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}