var PageLogicObj={
	m_AllocFirstCodeTabDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	//���ط������ȼ����
	AllocFirstCodeTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_AllocFirstCodeTabDataGrid=InitAllocFirstCodeTabDataGrid();
}
function InitAllocFirstCodeTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }/*,{
        text: '����',
        iconCls: 'icon-translate-word',
        handler: function() {
         	var SelectedRow = PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('getSelected');
			if (!SelectedRow){
			$.messager.alert("��ʾ","��ѡ����Ҫ�������!","info");
			return false;
			}
			CreatTranLate("User.DHCFirstCode","FirstcName",SelectedRow["Tname"])
			        }
     }*/];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'����',width:300},
		{field:'Tname',title:'����',width:300},
		{field:'Tmemo',title:'��ע',width:300}
    ]]
	var AllocFirstCodeTabDataGrid=$("#AllocFirstCodeTab").datagrid({
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
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			$("#code,#name,#memo").val("");
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return AllocFirstCodeTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Tcode"]);
	$("#name").val(row["Tname"]);
	$("#memo").val(row["Tmemo"]);
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertFirstCode",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���ӳɹ�!");
			PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('uncheckAll');
			AllocFirstCodeTabDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"updateFirstCode",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		rowid:row["Tid"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���³ɹ�!");
			PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid("getRowIndex",row),
				row: {
					Tcode: code,
					Tname: name,
					Tmemo:memo
				}
			});
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function ClearData(){
	$("#code").val("");
	$("#name").val("");
	$("#memo").val("");
}
function CheckDataValid(){
	var code=$("#code").val();
	if (code==""){
		$.messager.alert("��ʾ","����д����!","info",function(){$("#code").focus();});
		return false;
	}
	var name=$("#name").val();
	if (name==""){
		$.messager.alert("��ʾ","����д����!","info",function(){$("#name").focus();});
		return false;
	}
	return true;
}
function AllocFirstCodeTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindDHCFirstCode",
	    Pagerows:PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_AllocFirstCodeTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}