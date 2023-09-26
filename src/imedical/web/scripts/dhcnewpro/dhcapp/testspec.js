/// Descript: ����걾�ֵ�ά��
/// Creator : yuliping
/// Date    : 2017-07-08
var editRow="";
/// ҳ���ʼ������
function initPageDefault(){
	
	initTestItem();       	/// ��ʼҳ��DataGrid��������Ŀ
	
	//ͬʱ������������󶨻س��¼�
    $('#ATSCode,#ATSDesc').bind('keypress',function(event){
	    
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#datagrid','formid':'#queryForm'}) //���ò�ѯ
        }
    });
	
}
///��������Ŀ
function initTestItem(){
	
	var Hospeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto" , //���������߶��Զ�����,
			required: true
		}
	}
	
	var atsflag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"��"},{"value":"N","text":"��"}],
			
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'ActiveFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
		}
	}
	var mulflag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"��"},{"value":"N","text":"��"}],
			
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlag'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#datagrid").datagrid('getEditor',{index:editRow,field:'MulFlagCode'});
				$(ed.target).val(option.value); 
			} 
			
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
	
	var columns=[[
		{field:"ATSCode",title:'��Ŀ����',width:150,editor:textEditor},
		{field:"ATSDesc",title:'��Ŀ����',width:150,editor:textEditor},
		{field:"CatDesc",title:'�걾��������',width:140,editor:catEditor},
		{field:"HospDesc",title:'ҽԺ��ʶ',width:200,editor:Hospeditor},
		{field:"ActiveFlag",title:'�Ƿ����',width:80,align:'center',editor:atsflag},
		{field:"ActiveFlagCode",title:'ActiveFlagCode',width:80,align:'center',editor:textEditor},
		{field:"CatDr",title:'CatDr',width:20,hidden:'true',align:'center'},
		{field:"HospDr",title:'HospDr',width:20,hidden:'true',align:'center'},
		{field:"ATSid",title:'ATSid',width:20,hidden:'true',align:'center'},
		{field:"MulFlag",title:'��ѡ',width:80,align:'center',editor:mulflag},
		{field:"MulFlagCode",title:'MulFlagCode',width:80,align:'center',editor:textEditor}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            onClickRow(rowIndex,rowData) 
            editRow=rowIndex;
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPTestSpec&MethodName=ListAPPTestSpec";
	new ListComponent('datagrid', columns, uniturl, option).Init(); 
}
function addRow(){
	commonAddRow({'datagrid':'#datagrid',value:{'HospDesc':'2','ActiveFlag':'Y','ActiveFlagCode':'Y','MulFlag':'Y','MulFlagCode':'Y'}})
	editRow=0;
}
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
}
function save(){
	saveByDataGrid("web.DHCAPPTestSpec","SaveUpdTestSpec","#datagrid",function(data){
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
		 runClassMethod("web.DHCAPPTestSpec","RemoveTestSpec",{'Id':row.ATSid},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
