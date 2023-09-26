var PageLogicObj={
	m_RBCASStatusDataGrid:""
};
$(function(){
	//初始化
	Init();
	//加载分诊区表格数据
	RBCASStatusDataGridLoad();
});
function Init(){
	PageLogicObj.m_RBCASStatusDataGrid=InitRBCASStatusDataGrid();
}
function InitRBCASStatusDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, 
    /*
    {
    	//不允许删除,硬代码
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() {DelClickHandle();}
    },*/
     {
        text: '更新',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'代码',width:300},
		{field:'Tname',title:'名称',width:300},
		//{field:'TStartDate',title:'开始日期',width:300},
		//{field:'TEndDate',title:'结束日期',width:300}
    ]]
	var RBCASStatusDataGrid=$("#tabRBCASStatus").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
			if (" N S R TR F A AR PS AUD ".indexOf(" "+row["Tcode"]+" ")!=-1) {
				$("#code").attr({title: "硬代码不允许更新。",disabled: "disabled"});
			}else{
				$("#code").attr({title: ""}).removeAttr("disabled");
			}
		},
		onUnselect:function(index, row){
			$("#code,#name,#StartDate,#EndDate").val("");
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RBCASStatusDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RBCASStatusDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RBCASStatusDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return RBCASStatusDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Tcode"]);
	$("#name").val(row["Tname"]);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	
	$.cm({
		ClassName:"web.DHCRBCASStatus",
		MethodName:"InsertRBCASStatus",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
	},function(rtn){
		if (rtn=="0"){
			//$.messager.alert("提示","增加成功!");
			PageLogicObj.m_RBCASStatusDataGrid.datagrid('uncheckAll');
			RBCASStatusDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("提示","增加失败!代码重复!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_RBCASStatusDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的行!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	$.cm({
		ClassName:"web.DHCRBCASStatus",
		MethodName:"UpdateRBCASStatus",
		itmjs:"",
		itmjsex:"",
		rowid:row["Tid"],
		code:code,
		name:name,
	},function(rtn){
		if (rtn=="0"){
			//$.messager.alert("提示","更新成功!");
			ClearData();
			PageLogicObj.m_RBCASStatusDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_RBCASStatusDataGrid.datagrid("getRowIndex",row),
				row: {
					Tcode: code,
					Tname: name,
				}
			});
		}else{
			$.messager.alert("提示","更新失败!代码重复!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_RBCASStatusDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.messager.confirm("提示","基础数据请谨慎删除,是否确认删除?",function(r){
		if(r){
			$.cm({
				ClassName:"web.DHCRBCASStatus",
				MethodName:"DelRBCASStatus",
				itmjs:"",
				itmjsex:"",
				rid:row["Tid"]
			},function(rtn){
				if (rtn=="0"){
					ClearData();
					PageLogicObj.m_RBCASStatusDataGrid.datagrid('uncheckAll');
					RBCASStatusDataGridLoad();
				}else{
					$.messager.alert("提示","删除失败!"+rtn);
					return false;
				}
			});
				
		}	
	});
}
function ClearData(){
	$("#code").val("");
	$("#name").val("");
}
function CheckDataValid(){
	var code=$("#code").val();
	if (code==""){
		$.messager.alert("提示","请填写代码!","info",function(){$("#code").focus();});
		return false;
	}
	var name=$("#name").val();
	if (name==""){
		$.messager.alert("提示","请填写名称!","info",function(){$("#name").focus();});
		return false;
	}
	return true;
}
function RBCASStatusDataGridLoad(){
	$.q({
	    ClassName : "web.DHCRBCASStatus",
	    QueryName : "FindRBCASStatus",
	    Pagerows:PageLogicObj.m_RBCASStatusDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBCASStatusDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}