var PageLogicObj={
	m_CardUniteQueryTabDataGrid:""
}; 
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//表格数据初始化
	CardUniteQueryTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_CardUniteQueryTabDataGrid=InitCardUniteQueryTabDataGrid();
}
function InitCardUniteQueryTabDataGrid(){
	var Columns=[[ 
		{field:'TOldRegNo',title:'旧登记号',width:100},
		{field:'TNewRegNo',title:'新登记号',width:100},
		{field:'TName',title:'姓名',width:130},
		{field:'TSex',title:'性别',width:50},
		{field:'TDob',title:'出生日期',width:100},
		{field:'TDate',title:'合并日期',width:150},
		{field:'TUser',title:'合并人',width:90},
		{field:'TCancelDate',title:'撤销日期',width:150},
		{field:'TCancelUser',title:'撤销人',width:80},
		{field:'TPoliticalLevel',title:'病人级别',width:80},
		{field:'TSecretLevel',title:'病人密级',width:80},
		{field:'TUnitReason',title:'卡合并原因',width:130}
    ]]
	var CardUniteQueryTabDataGrid=$("#CardUniteQueryTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,
		rownumbers:true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'TOldRegNo',
		columns :Columns
	});
	return CardUniteQueryTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(CardUniteQueryTabDataGridLoad);
	$('#BCancelUnit').click(CancelUnitclickHandle);
}
function CardUniteQueryTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCPATCardUnite",
	    QueryName : "CardUniteQuery",
	    StartDate:$("#StartDate").datebox('getValue'),
	    EndDate:$("#EndDate").datebox('getValue'),
	    Name:$("#Name").val(),
	    Pagerows:PageLogicObj.m_CardUniteQueryTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardUniteQueryTabDataGrid.datagrid('unselectAll');
		PageLogicObj.m_CardUniteQueryTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function CancelUnitclickHandle(){
	var row=PageLogicObj.m_CardUniteQueryTabDataGrid.datagrid('getSelected');
	if (!row) {
		$.messager.alert("提示","请选择需要撤销的记录!")
		return false;
	}
	var CancelDate=row['TCancelDate'];
	if (CancelDate!=""){
		$.messager.alert("提示",'已经撤销合并,不需要再次操作!')
		return false;
	}
	var NewRegNo=row['TNewRegNo'];
	var OldRegNo=row['TOldRegNo'];
	$.messager.confirm('确认对话框', "确实要撤销'"+OldRegNo+"'合并到'"+NewRegNo+"'吗?", function(r){
		if (r){
		    $.cm({
			    ClassName : "web.DHCPATCardUnite",
			    MethodName : "CardConverse",
			    OldRegNo:OldRegNo, RegNo:NewRegNo,
			    dataType:"text"
			},function(rtn){
				if (rtn==""){
					$.messager.alert("提示","撤销合并成功!","info",function(){
						CardUniteQueryTabDataGridLoad();
					});
				}else{
					$.messager.alert("提示",rtn);
				}
			}); 
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