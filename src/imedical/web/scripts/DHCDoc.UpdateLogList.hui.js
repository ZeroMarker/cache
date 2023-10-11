var PageLogicObj={
	m_RowId:"",
	m_ClassName:"web.DHCDocDataChangeLog"
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent()
	DataListLoad();
})
function Init(){
	//初始化界面上ComboBox
	InitComboBox()
	InitClassNameCombo()
	InitDataGrid()
	$("#datefrom").datebox("setValue",ServerObj.CurrentDate);
	//InitLookup()
}
function InitEvent(){
	//定义新增按钮事件
	//$("#Save").bind("click",AddClick)
	$("#BFind").bind("click",DataListLoad)
}
function InitDataGrid(){
	var Columns=[[ 
		{field:'id', title: 'ID',  width:30},   
		{field:'ClassNameDesc', title: '功能描述',  width:100},
		{field:'ObjectReference',title : '对象ID', width:80},
        {field:'ObjectDesc',title : '对象描述', width:100},
        {field:'ChangeDetail',title : '修改内容', width:400,showTip:true,tipWidth:450},
		{field:'UpdateUserDR',title : '操作人', width:70},
		{field:'OperateType',title : '操作类型', width:70,
			formatter: function(value,row,index){
				if (value=="A"){
					var btn = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png"/><span style="vertical-align:top;padding-left:5px;">新增</span>';
				}else if (value=="U"){
					var btn = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png"/><span style="vertical-align:top;padding-left:5px;">修改</span>';
				}else if (value=="D"){
					var btn = '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png"/><span style="vertical-align:top;padding-left:5px;">删除</span>';
				}
				return btn;
			}
		},
		{field:'IPAddress',title : '操作人IP', width:120},
		{field:'UpdateDate',title : '操作日期', width:90},
		{field:'UpdateTime',title : '操作时间', width:80}
	]];
	var dataGrid=$("#DataList").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		idField:'id',
		columns :Columns,
		onDblClickRow:function(index, rowData){
			PageLogicObj.m_RowId=rowData["ID"]
			DataGridSelect(PageLogicObj.m_RowId)
			$("#Win").dialog("open")
			$("#Win").dialog("center")
		},
		onSelect:function(index,rowData){
			PageLogicObj.m_RowId=rowData["ID"]
		}
	});
	dataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	return dataGrid;
}
function DataListLoad(){
	//ClassN As %String, OBJDESC As %String, UserDR As %String, datefrom As %String, dateto As %String, dizzyDesc As %String, OperateTypeD
	$.cm({
	    ClassName : PageLogicObj.m_ClassName,
	    QueryName : "GetOperateLogList",
		ClassN:$("#ClassName").combobox('getValue'),
		OBJDESC:$("#ObjectDesc").val(),
		UserDR:$("#UpdateUserDR").val(),
		datefrom:$("#datefrom").datebox('getValue'),
		dateto:$("#dateto").datebox('getValue'),
		dizzyDesc:$("#fuzzyserch").val(),
		OperateTypeD:$("#OperateType").combobox('getValue'),
	    rows:99999
	},function(GridData){
		$("#DataList").datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#DataList").datagrid("clearSelections")
	});
}
function InitComboBox(){
	var cbox = $HUI.combobox("#OperateType", {
		valueField: 'id',
		textField: 'text', 
		editable:true,
		data: [{    
		    "id":"A",    
		    "text":"新增"   
		},{    
		    "id":"D",    
		    "text":"删除"   
		},{    
		    "id":"U",    
		    "text":"修改" 
		}] 
   });
}

function InitClassNameCombo(){
	var cbox = $HUI.combobox("#ClassName", {
		valueField: 'ClassName',
		textField: 'ClassName', 
		editable:true,
		delay:"500",
		mode:"local",       //"remote",
		url:$URL+"?ClassName=web.DHCDocDataChangeLog&QueryName=GetClassNameList&rows=999999",
		filter: function(q, row){
            var opts = $(this).combobox('options');
            return row[opts.textField].indexOf(q) == 0;
        },
		loadFilter:function(data){
		    return data['rows'];
		}
 	});
}