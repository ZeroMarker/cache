var PageLogicObj={
	m_RBCASStatusDataGrid:""
};
$(function(){
	//��ʼ��
	Init();
	//���ط������������
	RBCASStatusDataGridLoad();
});
function Init(){
	PageLogicObj.m_RBCASStatusDataGrid=InitRBCASStatusDataGrid();
}
function InitRBCASStatusDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    }, 
    /*
    {
    	//������ɾ��,Ӳ����
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function() {DelClickHandle();}
    },*/
     {
        text: '����',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    }];
	var Columns=[[ 
		{field:'Tid',hidden:true,title:''},
		{field:'Tcode',title:'����',width:300},
		{field:'Tname',title:'����',width:300},
		//{field:'TStartDate',title:'��ʼ����',width:300},
		//{field:'TEndDate',title:'��������',width:300}
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
				$("#code").attr({title: "Ӳ���벻������¡�",disabled: "disabled"});
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
			//$.messager.alert("��ʾ","���ӳɹ�!");
			PageLogicObj.m_RBCASStatusDataGrid.datagrid('uncheckAll');
			RBCASStatusDataGridLoad();
			ClearData();
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function UpdateClickHandle(){
	var row=PageLogicObj.m_RBCASStatusDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ���µ���!");
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
			//$.messager.alert("��ʾ","���³ɹ�!");
			ClearData();
			PageLogicObj.m_RBCASStatusDataGrid.datagrid('updateRow',{
				index: PageLogicObj.m_RBCASStatusDataGrid.datagrid("getRowIndex",row),
				row: {
					Tcode: code,
					Tname: name,
				}
			});
		}else{
			$.messager.alert("��ʾ","����ʧ��!�����ظ�!");
			return false;
		}
	});
}
function DelClickHandle(){
	var row=PageLogicObj.m_RBCASStatusDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ������!");
		return false;
	}
	$.messager.confirm("��ʾ","�������������ɾ��,�Ƿ�ȷ��ɾ��?",function(r){
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
					$.messager.alert("��ʾ","ɾ��ʧ��!"+rtn);
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
function RBCASStatusDataGridLoad(){
	$.q({
	    ClassName : "web.DHCRBCASStatus",
	    QueryName : "FindRBCASStatus",
	    Pagerows:PageLogicObj.m_RBCASStatusDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_RBCASStatusDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}