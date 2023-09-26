/*
ģ��:		������Һ����
��ģ��:		������Һ����-��Һ�������÷�ά��
Creator:	hulihua
CreateDate:	2016-12-16
*/

var editRow = ""; editDRow = ""; polid = "";
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){

	//��ʼ������Ĭ����Ϣ
	InitDefault();

	//��ʼ�������÷��б�
	InitLinkUseList();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	polid=getParam("polid");  ///��Һ�������ID
}

///��ʼ�������÷��б�
function InitLinkUseList(){	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	//������Ϊ�ɱ༭
	var tempEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			valueField: "value",
			textField: "text",
			url: url+'?action=GetAllInstrucList',  
			onSelect:function(option){
				var ed=$("#linkuseMainList").datagrid('getEditor',{index:editRow,field:'InstrucDr'});
				$(ed.target).val(option.value);  					//�����÷�ID
				var ed=$("#linkuseMainList").datagrid('getEditor',{index:editRow,field:'Instruc'});
				$(ed.target).combobox('setValue', option.text);  	//�����÷�Desc
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor,hidden:true},
		{field:'InstrucDr',title:'InstrucDr',width:100,editor:textEditor,hidden:true},
		{field:'Instruc',title:'�÷�',width:300,editor:tempEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	$('#linkuseMainList').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaLinkInstruc&params='+polid,
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[10,20,30],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#linkuseMainList").datagrid('endEdit', editRow); 
            } 
            $("#linkuseMainList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
}

/// ����༭��
function saveRow(){
	
	if(polid==""){		
		$.messager.alert('��ʾ','��ѡ����Ҫά������Һ���࣡')
		return;	
	}
	
	if(editRow>="0"){
		$("#linkuseMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#linkuseMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Instruc=="")||(rowsData[i].Instruc==null)){
			$.messager.alert("��ʾ","��Ҫ�������÷�����Ϊ��!"); 
			return false;
		}

		var tmp=polid+"^"+rowsData[i].ID+"^"+rowsData[i].InstrucDr;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVALinkInstruc",params)
	if(data!=""){
		if(data==-1){
			$.messager.alert("��ʾ","��Ҫ�������÷�Ϊ��,���ܱ���!"); 
		}else if(data==-2){	
			$.messager.alert('��ʾ','����ʧ��!',"error");		
		}else if(data==-11){	
			$.messager.alert('��ʾ','���÷���ά��!');		
		}else{	
			$.messager.alert('��ʾ','���³ɹ�!');
			$("#linkuseMainList").datagrid('reload');		
		}
	}
}

/// ��������
function insertRow(){
	if(polid==""){		
		$.messager.alert('��ʾ','��ѡ����Ҫά������Һ���࣡')
		return;	
	}
	
	if(editRow>="0"){
		$("#linkuseMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#linkuseMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {POLID:'', POLMinVolume:'', POLMaxVolume:''}
	});
	$("#linkuseMainList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){			
	if ($("#linkuseMainList").datagrid('getSelections').length != 1) {		
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	
	var rowsData = $("#linkuseMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����ѡ��������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				if (rowsData.ID!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVALinkInstruc",rowsData.ID)
					if(data!=""){
						if(data==-1){
							$.messager.alert("��ʾ","û��ѡ����Ҫɾ���ļ�¼!"); 
						}else if(data==-2){	
							$.messager.alert('��ʾ','ɾ��ʧ��!');		
						}else{	
							$.messager.alert('��ʾ','ɾ���ɹ�!');		
						}
						$("#linkuseMainList").datagrid('reload');
					}
				}else{
					var rowIndex = $('#linkuseMainList').datagrid('getRowIndex', rowsData);
     				$('#linkuseMainList').datagrid('deleteRow', rowIndex);  
				}
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

