/// Descript: ��������Ŀ�ֵ�ά��
/// Creator : yuliping
/// Date    : 2017-07-07
var editRow="";
/// ҳ���ʼ������
function initPageDefault(){
	
	
	
	//ͬʱ������������󶨻س��¼�
    $('#ATICode,#ATIDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //���ò�ѯ
        }
    });
	
}
/*///��������Ŀ
function initTestItem(){
	
	var Hospeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			required: true
		}
	}
	var ARCItmMast={  //������Ϊ�ɱ༭
		//���
		type:'combogrid',
		options: {
			required : true,
			//fitColumns:true,
			fit:true,//�Զ���С  
			pagination : true,
			panelWidth:600,
			idField: 'value',
			textField:'text',
			
			url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=getARCItmMast",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			columns:[[
				{field:'value',hidden:true},
				{field:'code',title:'����',width:60},
				{field:'text',title:'ҽ����',width:80}
				]]	
		}
	}
	var atsflag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"Y"},{"value":"N","text":"N"}],
			
			//required:true,
			panelHeight:"auto"  //���������߶��Զ�����
			
		}
	}
	var catEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=QueryArcCatList",
			//required:true,
			panelHeight:"auto"  //���������߶��Զ�����
			
		}
	}
	/// �ı��༭��
	var textEditor={
		type: 'validatebox',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	//ATICode^ATIDesc^ArcDesc^HospDesc^ActiveFlag^CatDesc^ArcDr^HospDr^CatDr^ATIid
	var columns=[[
		{field:"ATICode",title:'��Ŀ����',width:150,align:'center',editor:textEditor},
		{field:"ATIDesc",title:'��Ŀ����',width:150,align:'center',editor:textEditor},
		{field:"ArcDesc",title:'����ҽ����',width:170,align:'center',editor:{type:'combogrid',
									options: {
										required : true,
										//fitColumns:true,
										fit:true,//�Զ���С  
										pagination : true,
										panelWidth:600,
										idField: 'value',
										textField:'text',
										
										url:LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=getARCItmMast",
										//required:true,
										panelHeight:"auto",  //���������߶��Զ�����
										columns:[[
											{field:'value',hidden:true},
											{field:'code',title:'����',width:60},
											{field:'text',title:'ҽ����',width:80}
											]]	
									}}},
		{field:"HospDesc",title:'ҽԺ��ʶ',width:200,align:'center',editor:Hospeditor},
		{field:"ActiveFlag",title:'�Ƿ����',width:80,align:'center',editor:atsflag},
		{field:"CatDesc",title:'������',width:140,align:'center',editor:catEditor},
		{field:"ArcDr",title:'ArcDr',width:20,hidden:'true',align:'center'},
		{field:"HospDr",title:'HospDr',width:20,hidden:'true',align:'center'},
		{field:"CatDr",title:'CatDr',width:20,hidden:'true',align:'center'},
		{field:"ATIid",title:'ATIid',width:20,hidden:'true',align:'center'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            onClickRow(rowIndex,rowData) 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestItem&MethodName=ListAPPTestItem";
	new ListComponent('datagrid', columns, uniturl, option).Init(); 
}*/
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'HospDesc':'2','ActiveFlag':'Y'}})
}
function onClickRow(index,row){
	editRow = index;
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCAPPTestItem","SaveUpdTestItem","#datagrid",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#datagrid").datagrid('reload')
			}else if(data==1){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else if(data==2){
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#datagrid").datagrid('reload')
			}else{	
				$.messager.alert('��ʾ','����ʧ��:'+data)
				
			}
		});	
}



function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');     
		 runClassMethod("web.DHCAPPTestItem","RemoveTestItem",{'Id':row.ATIid},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}
///����ȡֵ����
function fillValue(rowIndex, rowData){

	$('#datagrid').datagrid('getRows')[editIndex]['ArcDesc']=rowData.text
	$('#datagrid').datagrid('getRows')[editIndex]['ArcDr']=rowData.value
	
}

/// combogrid ��� onChange ���ú���
function ChangeValue(newValue, oldValue){
	
	if (newValue == ""){
		$('#datagrid').datagrid('getRows')[editRow]['ArcDr']="";
	}
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
