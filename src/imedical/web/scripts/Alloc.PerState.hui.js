var PageLogicObj={
	m_AllocPerStateTabDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	//���ط���״̬�������
	AllocPerStateTabDataGridLoad();
});
function Init(){
	PageLogicObj.m_AllocPerStateTabDataGrid=InitAllocPerStateTabDataGrid();
}
function InitAllocPerStateTabDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '����',
        iconCls: 'icon-save',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'����',width:300},
		{field:'Tname',title:'����',width:300},
		{field:'Tmemo',title:'��ע',width:300},
		{field:'Tshowname',title:'��ʾ����',width:300}
    ]]
	var AllocPerStateTabDataGrid=$("#AllocPerStateTab").datagrid({
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
		idField:'Tid',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
			$("#code,#name").attr("disabled",true);
		},
		onUnselect:function(index, row){
			$("#code,#name,#memo,#showname").val("");
			$("#code,#name").attr("disabled",false);
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_AllocPerStateTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_AllocPerStateTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_AllocPerStateTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return AllocPerStateTabDataGrid;
}
function SetSelRowData(row){
	$("#code").val(row["Tcode"]);
	$("#name").val(row["Tname"]);
	$("#memo").val(row["Tmemo"]);
	//if (row["Tshowname"]!=""){
		$("#showname").val(row["Tshowname"]);
	//}else{
		//$("#showname").val(row["Tname"]);
	//}
}
function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	var name=$("#name").val();
	var memo=$("#memo").val();
	var showname=$("#showname").val();
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"insertPerState",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		showname:showname
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���ӳɹ�!");
			PageLogicObj.m_AllocPerStateTabDataGrid.datagrid('uncheckAll');
			AllocPerStateTabDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_AllocPerStateTabDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
		return false;
	}
	if (!CheckDataValid()) return false;
	var code=$("#code").val();
	if (code!=row["Tcode"]){
		$.messager.alert("��ʾ","�ѱ���Ĵ��벻���޸�");
		$("#code").val(row["Tcode"]);
		return false;
		}
	var name=$("#name").val();
	if (name!=row["Tname"]){
		$.messager.alert("��ʾ","�ѱ�������Ʋ����޸�,ֻ���޸���ʾ����");
		$("#code").val(row["Tname"]);
		return false;
		}
	var memo=$("#memo").val();
	var showname=$("#showname").val();
	$.cm({
		ClassName:"web.DHCExaBorough",
		MethodName:"updatePerState",
		itmjs:"",
		itmjsex:"",
		code:code,
		name:name,
		memo:memo,
		showname:showname,
		rowid:row["Tid"]
	},function(rtn){
		if (rtn=="0"){
			$.messager.alert("��ʾ","���³ɹ�!");
			PageLogicObj.m_AllocPerStateTabDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_AllocPerStateTabDataGrid.datagrid("getRowIndex",row),
				row: {
					Tcode: code,
					Tname: name,
					Tmemo:memo,
					Tshowname:showname
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
	$("#showname").val("");
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
	var showname=$("#showname").val();
	if (showname==""){
		$.messager.alert("��ʾ","����д��ʾ����!","info",function(){$("#showname").focus();});
		return false;
	}
	return true;
}
function AllocPerStateTabDataGridLoad(){
	$.q({
	    ClassName : "web.DHCExaBorough",
	    QueryName : "UFindDHCPerState",
	    depid : "",
	    Pagerows:PageLogicObj.m_AllocPerStateTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_AllocPerStateTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}