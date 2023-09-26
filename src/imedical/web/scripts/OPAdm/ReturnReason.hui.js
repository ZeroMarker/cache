var PageLogicObj={
	m_ReturnReasonTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//表格数据初始化
	ReturnReasonTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_ReturnReasonTabDataGrid=InitReturnReasonTabDataGrid();
}
function InitEvent(){
	$("#Bfind").click(ReturnReasonTabDataGridLoad)
}
function InitReturnReasonTabDataGrid() {
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }/*,{
        text: '授权医院',
        iconCls: 'icon-house',
        handler: function() {
	        var row=PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('getSelected');
			if (!row){
				$.messager.alert("提示","请选择一行！")
				return false
			}
			GenHospWin("DHC_OPReturnReason",row.RowID);
	    }
    }*/];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:''},
		{field:'Code',title:'退号原因编码',width:300},
		{field:'Desc',title:'退号原因描述',width:300},
		{field:'DateFrom',title:'开始日期',width:300},
		{field:'DateTo',title:'结束日期',width:300}
    ]]
	var ReturnReasonTabDataGrid=$("#ReturnReasonTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return ReturnReasonTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Code"])
	$("#name").val(row["Desc"])
	$HUI.datebox("#StartDate").setValue(row["DateFrom"])
	$HUI.datebox("#EndDate").setValue(row["DateTo"])
}
function ReturnReasonTabDataGridLoad(){
	var Code=$("#code").val()
	var Desc=$("#name").val()
	$.q({
		ClassName:"web.DHCOPReturnReason",
		QueryName:"FindOPReturnReasonInfo",
		Code:Code,
		Desc:Desc,
		Pagerows:PageLogicObj.m_ReturnReasonTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ReturnReasonTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function AddClickHandle(){
	var Code=$("#code").val()
	var Desc=$("#name").val()
	var DateFrom=$HUI.datebox("#StartDate").getValue()
	var DateTo=$HUI.datebox("#EndDate").getValue()
	if(!CheckData()) return false;
	$.cm({
		ClassName:"web.DHCOPReturnReason",
		MethodName:"AddData",
		code:Code,
		desc:Desc,
		DateFrom:DateFrom,
		DateTo:DateTo,
		dataType:"text"
	},function(rtn){
		if(rtn=="0"){
			$.messager.alert("提示","保存成功!")
			ClearData()
			ReturnReasonTabDataGridLoad()
		}else{
			$.messager.alert("提示","保存失败,"+rtn)
			return false
		}
	})
}
function DelClickHandle(){
	var row=PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var RowId=row["RowID"]
	$.cm({
		ClassName:"web.DHCOPReturnReason",
		MethodName:"DeleteData",
		RowID:RowId
	},function(rtn){
		if(rtn=="0"){
			$.messager.alert("提示","删除成功!")
			ClearData()
			ReturnReasonTabDataGridLoad()
			var oldIndex=PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('getRowIndex',row);
			PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('unselectRow',oldIndex);
		}else{
			$.messager.alert("提示","删除失败!")
			return false
		}
	})
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_ReturnReasonTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择一行！")
		return false
	}
	var RowId=row["RowID"]
	var Code=$("#code").val()
	var Desc=$("#name").val()
	var DateFrom=$HUI.datebox("#StartDate").getValue()
	var DateTo=$HUI.datebox("#EndDate").getValue()
	if(!CheckData()) return false;
	$.cm({
		ClassName:"web.DHCOPReturnReason",
		MethodName:"UpdateData",
		RowID:RowId,
		code:Code,
		desc:Desc,
		DateFrom:DateFrom,
		DateTo:DateTo,
		dataType:"Text"
	},function(rtn){
		if(rtn=="0"){
			$.messager.alert("提示","更新成功!")
			ClearData()
			ReturnReasonTabDataGridLoad()
		}else{
			$.messager.alert("提示","更新失败,"+rtn)
			return false
		}
	})
}
 function CheckData()
 {
	var Code=$("#code").val()
	var Desc=$("#name").val()
	var StDate=$HUI.datebox("#StartDate").getValue()
	if (Code==""){alert("请输入退号原因编码");return false}
	if (Desc==""){alert("请输入退号原因描述");return false}
	if (StDate==""){$.messager.alert("提示","请输入开始日期!");return false;}
	return true

 }
function ClearData(){
	$("#code").val("")
	$("#name").val("")
	$HUI.datebox("#StartDate").setValue("")
	$HUI.datebox("#EndDate").setValue("")
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