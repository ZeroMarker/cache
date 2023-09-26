/**
* author :    QuNianpeng
* date:       2017-7-8
* descript:   �����˲��������ֵ����
*/


/// ҳ���ʼ������
function initPageDefault(){
	initDgList();  		// ��ʼҳ��DataGrid���������
	initButton();		// ��ʼ����ť
}

/// ��������
function initDgList(){
	
	var hospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto"  //���������߶��Զ�����			
		}
	}
	
	var accFlag={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			data:[{"value":"Y","text":"Y"},{"value":"N","text":"N"}],			
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
		{field:"accRowId",title:'ID',width:20,hidden:'true',align:'center'},
		{field:"accCode",title:'�������',width:150,align:'center',editor:textEditor},
		{field:"accDesc",title:'��������',width:170,align:'center',editor:textEditor},
		{field:"accHospDesc",title:'ҽԺ',width:200,align:'center',editor:hospEditor},
		{field:"accHospDr",title:'ҽԺID',width:40,align:'center',hidden:'true'},
		{field:"accActiveFlag",title:'�Ƿ����',width:60,align:'center',editor:accFlag}		
	]];
	
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            onClickRow(rowIndex,rowData) 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPCaseClass&MethodName=QueryCaseClass";
	new ListComponent('caseclassdg', columns, uniturl, option).Init(); 	
	
	
}

//����һ��
function addRow(){
	commonAddRow({'datagrid':'#caseclassdg',value:{'accHospDesc':'2','accActiveFlag':'Y'}})
}

//�޸���
function onClickRow(index,row){
	CommonRowClick(index,row,"#caseclassdg");
}
//����
function save(){
	saveByDataGrid("web.DHCAPPCaseClass","SaveCaseClass","#caseclassdg",function(data){
			if(data==0){
				//$.messager.alert("��ʾ","����ɹ�!");
				$("#caseclassdg").datagrid('reload');
			}else if(data==-1){
				$.messager.alert('��ʾ','����ʧ��:'+data)
			}else{	
				$.messager.alert("��ʾ","�����Ѵ���,�����ظ�����!"); 
				$("#caseclassdg").datagrid('reload');				
			}
		});	
}


//ɾ��һ��
function deleteRow(){
	
	if ($("#caseclassdg").datagrid('getSelections').length != 1) {
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
	    if (r){
		    var row =$("#caseclassdg").datagrid('getSelected');     
			 runClassMethod("web.DHCAPPCaseClass","DeleteCaseClass",{'accRowId':row.accRowId},function(data){ $('#caseclassdg').datagrid('load'); })
	    }    
	}); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	// ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findCaseList(); //���ò�ѯ
    });
    
    //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findCaseList(); //���ò�ѯ
    });   
     
     
   	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
	    findCaseList();
    });	 
    
}

// ��ѯ
function findCaseList()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#caseclassdg').datagrid('load',{params:params}); 
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })