var PageLogicObj={
	m_errCodeTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//加载表格数据
	errCodeTabDataGridLoad();
	$("#BFind").click(errCodeTabDataGridLoad);
});
function Init(){
	PageLogicObj.m_errCodeTabDataGrid=IniterrCodeTabDataGrid();
}
function IniterrCodeTabDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DelClickHandle();}
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }/*,{
        text: '翻译',
        iconCls: 'icon-translate-word',
        handler: function() {
         	var SelectedRow = PageLogicObj.m_errCodeTabDataGrid.datagrid('getSelected');
			if (!SelectedRow){
			$.messager.alert("提示","请选择需要翻译的行!","info");
			return false;
			}
			CreatTranLate("User.DHCDocErrCodeRegister","ECRDesc",SelectedRow["TDesc"])
			        }
     }*/
	 ];
	var Columns=[[ 
		{field:'TClassName',title:'类名',width:300},
		{field:'TCode',title:'代码',width:300},
		{field:'TDesc',title:'描述',width:300},
		{field:'TNotes',title:'详细说明',width:300}
    ]]
	var errCodeTabDataGrid=$("#errCodeTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 15,
		pageList : [15,100,200],
		idField:'TRowID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_errCodeTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_errCodeTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_errCodeTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}); 
	return errCodeTabDataGrid;
}
function SetSelRowData(row){
	$("#className").val(row["TClassName"]);
	$("#code").val(row["TCode"]);
	$("#desc").val(row["TDesc"]);
	$("#notes").val(row["TNotes"]);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var className=$("#className").val();
	var code=$("#code").val();
	var desc=$("#desc").val();
	var notes=$("#notes").val();
	$.cm({
		ClassName:"web.DHCDocErrCodeRegister",
		MethodName:"insertErrCode",
		className:className,
		code:code,
		desc:desc,
		notes:notes,
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '增加成功!',type:'success'});
			ClearData();
			PageLogicObj.m_errCodeTabDataGrid.datagrid('uncheckAll');
			errCodeTabDataGridLoad();
		}else{
			$.messager.alert("提示","增加失败!记录重复!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_errCodeTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的行!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var className=$("#className").val();
	var code=$("#code").val();
	var desc=$("#desc").val();
	var notes=$("#notes").val();
	$.cm({
		ClassName:"web.DHCDocErrCodeRegister",
		MethodName:"updateErrCode",
		className:className,
		code:code,
		desc:desc,
		notes:notes,
		rowid:row["TRowID"],
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '更新成功!',type:'success'});
			PageLogicObj.m_errCodeTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_errCodeTabDataGrid.datagrid("getRowIndex",row),
				row: {
					TClassName: className,
					TCode: code,
					TDesc:desc,
					TNotes:notes
				}
			});
		}else{
			$.messager.alert("提示","更新失败!记录重复!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_errCodeTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的行!");
		return false;
	}
	$.cm({
		ClassName:"web.DHCDocErrCodeRegister",
		MethodName:"delErrCode",
		rowid:row["TRowID"],
		dataType:"text"
	},function(rtn){
		if (rtn=="0"){
			$.messager.popover({msg: '删除成功!',type:'success'});
			ClearData();
			PageLogicObj.m_errCodeTabDataGrid.datagrid('uncheckAll');
			errCodeTabDataGridLoad();
			//PageLogicObj.m_errCodeTabDataGrid.datagrid('deleteRow',PageLogicObj.m_errCodeTabDataGrid.datagrid("getRowIndex",row));
		}else{
			$.messager.alert("提示","删除失败!"+rtn);
			return false;
		}
	});
}
function ClearData(){
	$("#className,#code,#desc,#notes").val("");
}
function CheckDataValid(){
	var code=$("#className").val();
	if (code==""){
		$.messager.alert("提示","请填写类名!","info",function(){$("#className").focus();});
		return false;
	}
	var name=$("#code").val();
	if (name==""){
		$.messager.alert("提示","请填写代码!","info",function(){$("#code").focus();});
		return false;
	}
	var desc=$("#desc").val();
	if (desc==""){
		$.messager.alert("提示","请填写描述!","info",function(){$("#desc").focus();});
		return false;
	}
	return true;
}
function errCodeTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocErrCodeRegister",
	    QueryName : "Find",
	    clsName:$("#className").val(),
	 	code:$("#code").val(),
	 	desc:$("#desc").val(),
	 	notes:$("#notes").val(),
	    Pagerows:PageLogicObj.m_errCodeTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_errCodeTabDataGrid.datagrid('loadData',GridData);
	}); 
}
