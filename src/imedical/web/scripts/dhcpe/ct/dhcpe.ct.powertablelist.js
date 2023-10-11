
/*
 * FileName: dhcpe.ct.powertablelist.js
 * Author: xy
 * Date: 2021-08-02
 * Description: ��Ǽ���Ȩά��
 */
 
 var lastIndex = "";
var EditIndex = -1;

 $(function(){
		
	InitCombobox();
	
	InitPowerTableListGrid();
	
	//��ѯ
     $('#BFind').click(function(){
    	BFind_click();
    });
    
    //����
     $('#BAdd').click(function(){
    	BAdd_click();
    });
    
    //�޸�
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
    //����
     $('#BSave').click(function(){
    	BSave_click();
    });
	   
	    
})

//��ѯ
function BFind_click(){
	
	$("#PowerTableListGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.PowerTable",
			QueryName:"SearchPowerTableList",
			Code:$("#TabCode").val(),
			Desc:$("#TabDesc").val(),
			Type:$("#PowerType").combobox('getValue'),
			ClsCode:$("#ClsCode").val(),
			ParCode:$("#ParCode").val(),
			
		});	
}

//����
function BAdd_click()
 {
	lastIndex = $('#PowerTableListGrid').datagrid('getRows').length - 1;
	$('#PowerTableListGrid').datagrid('selectRow', lastIndex);
	var selected = $('#PowerTableListGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TPTLRowid == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#PowerTableListGrid').datagrid('appendRow', {
		TPTLRowid: '',
		TTabCode: '',
		TTabDesc: '',
		TPowerType: '',
		TPowerTypeID:'',
		TTabClsCode:'',
		TTabParCode:'',
		
			});
	lastIndex = $('#PowerTableListGrid').datagrid('getRows').length - 1;
	$('#PowerTableListGrid').datagrid('selectRow', lastIndex);
	$('#PowerTableListGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#PowerTableListGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#PowerTableListGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#PowerTableListGrid').datagrid('beginEdit', thisIndex);
		$('#PowerTableListGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#PowerTableListGrid').datagrid('getSelected');

		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPowerType'  
			});
			
		$(thisEd.target).combobox('select', selected.TPowerTypeID);  
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabDesc'  
			});
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabCode'  
			});
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabClsCode'  
			});
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabParCode'  
			});
		 
		
	}
 }

//����
function BSave_click()
{
	$('#PowerTableListGrid').datagrid('acceptChanges');
	var selected = $('#PowerTableListGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TPTLRowid == "") {
			if ((selected.TTabCode == "undefined") || (selected.TTabDesc == "undefined") ||(selected.TPowerType=="undefined")||(selected.TTabClsCode == "undefined")||(selected.TTabCode == "") ||(selected.TTabDesc == "")||(selected.TPowerType == "")||	(selected.TTabClsCode == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				LoadPowerTableList();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.PowerTable",
				MethodName: "InsertPowerTable",
				TabCode: selected.TTabCode,
				TabDesc: selected.TTabDesc,
				PowerType: selected.TPowerType,
				ClsCode: selected.TTabClsCode,
				ParCode: selected.TTabParCode	
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', '����ʧ��:'+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('��ʾ', '����ɹ�', 'success');
					
				}
			
				
				LoadPowerTableList();
			});
		} else {
			$('#PowerTableListGrid').datagrid('selectRow', EditIndex);
			var selected = $('#PowerTableListGrid').datagrid('getSelected');
		if ((selected.TTabCode == "undefined") || (selected.TTabDesc == "undefined") ||(selected.TPowerType=="undefined")||(selected.TTabClsCode == "undefined")|| (selected.TTabCode == "") || (selected.TTabDesc == "")||(selected.TPowerType == "")||(selected.TTabClsCode == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				LoadPowerTableList();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.PowerTable",
				MethodName: "UpdatePowerTable",
				PTLRowid: selected.TPTLRowid,
				TabCode: selected.TTabCode,
				TabDesc: selected.TTabDesc,
				PowerType: selected.TPowerType,
				ClsCode: selected.TTabClsCode,
				ParCode: selected.TTabParCode
				
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', '�޸�ʧ��:'+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('��ʾ', '�޸ĳɹ�', 'success');
					
				}
			
				LoadPowerTableList();
			});
		}
	}
}

function LoadPowerTableList()
{
	 $("#PowerTableListGrid").datagrid('reload');
}



//��/˽/�ܿ�����  �����б�ֵ
	
var PowerTypeData = [{
		id: 'G',
		text: '����'
	}, {
		id: 'S',
		text: '˽��'
	}, {
		id: 'C',
		text: '�ܿ�'
	}, {
		id: 'A',
		text: '����˽��'
}];
		
	
var PowerTableListColumns = [[
	{
		field:'TPTLRowid',
		title:'TPTLRowid',
		hidden:true
	},{
		field:'TTabCode',
		width: '200',
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TTabDesc',
		width: '200',
		title:'������',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{  
		field:'TTabClsCode',
		width: '300',
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TPowerType',
		title:'��/˽/�ܿ�����',
		width:250,
		sortable:true,
		resizable:true,
		editor: {
			type:'combobox',
			options: {	
				valueField: 'id',
				textField: 'text',
				data: PowerTypeData,
				required: true
			}
		}
   },{
		field:'TTabParCode',
		width: '200',
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox'
		}
	},{
		field:'TPowerTypeID',
		title:'TPowerTypeID',
		hidden:true
	}
			
]];
		

function InitPowerTableListGrid(){
	

		
	// ��ʼ��DataGrid
	$('#PowerTableListGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: PowerTableListColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.PowerTable",
			QueryName:"SearchPowerTableList",
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


function InitCombobox()
{
			
	// ��/˽/�ܿ�����
	$HUI.combobox("#PowerType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:PowerTypeData
	});
	
}