/*
ģ��:		������Һ����
��ģ��:		������Һ����-��Һ������ҩƷ��Һ����ά��
Creator:	hulihua
CreateDate:	2016-12-16
*/

var editRow = ""; editDRow = ""; polid = "";
var dataArray = [{"value":"1","text":'����'}, {"value":"2","text":'����'}];
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){

	//��ʼ������Ĭ����Ϣ
	InitDefault();

	//��ʼ������ҩƷ��Һ�����б�
	InitLinkDrugCatList();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	polid=getParam("polid");  ///��Һ�������ID
}

///��ʼ������ҩƷ��Һ�����б�
function InitLinkDrugCatList(){	
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
			url: url+'?action=GetAllPHCPivaCatList',  
			onSelect:function(option){
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'PivaCatDr'});
				$(ed.target).val(option.value);  					//�����÷�ID
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'PivaCat'});
				$(ed.target).combobox('setValue', option.text);  	//�����÷�Desc
			}
		}
	}
	
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'RelationValue'});
				$(ed.target).val(option.value);  
				var ed=$("#linkdrugcatMainList").datagrid('getEditor',{index:editRow,field:'RelationFlag'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}

	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,editor:textEditor,hidden:true},
		{field:'RelationValue',title:'RelationValue',width:100,editor:textEditor,hidden:true},
		{field:'RelationFlag',title:'��ϵ',align:'center',width:120,editor:Flageditor},
		{field:'PivaCatDr',title:'PivaCatDr',width:100,editor:textEditor,hidden:true},
		{field:'PivaCat',title:'ҩƷ��Һ����',width:300,editor:tempEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	$('#linkdrugcatMainList').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaLinkPivaCat&params='+polid,
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
                $("#linkdrugcatMainList").datagrid('endEdit', editRow); 
            } 
            $("#linkdrugcatMainList").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
	$('#linkdrugcatMainList').datagrid('loadData',{total:0,rows:[]}); 
}

/// ����༭��
function saveRow(){
	
	if(polid==""){		
		$.messager.alert('��ʾ','��ѡ����Ҫά������Һ���࣡')
		return;	
	}
	
	if(editRow>="0"){
		$("#linkdrugcatMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#linkdrugcatMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].PivaCat=="")||(rowsData[i].PivaCat==null)){
			$.messager.alert("��ʾ","��Ҫ������ҩƷ��Һ���಻��Ϊ��!"); 
			return false;
		}
		if((rowsData[i].RelationFlag=="")||(rowsData[i].RelationFlag==null)){
			$.messager.alert("��ʾ","������ϵ����Ϊ��!"); 
			return false;
		}

		var tmp=polid+"^"+rowsData[i].ID+"^"+rowsData[i].PivaCatDr+"^"+rowsData[i].RelationValue;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVALinkItm",params)
	if(data!=""){
		if(data==-1){
			$.messager.alert("��ʾ","��Ҫ������ҩƷ��Һ���Ϊ��,���ܱ���!"); 
		}else if(data==-2){	
			$.messager.alert('��ʾ','����ʧ��!');		
		}else if(data==-3){	
			$.messager.alert('��ʾ','��Ҫ�����Ĺ�����ϵΪ��,���ܱ���!');		
		}else if(data==-11){	
			$.messager.alert('��ʾ','�Ѵ��ڸ�ҩƷ��Һ����Ĺ�����ϵ,���ܱ���!');		
		}
		else{	
			$.messager.alert('��ʾ','���³ɹ�!');
			$("#linkdrugcatMainList").datagrid('reload');		
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
		$("#linkdrugcatMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#linkdrugcatMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', PivaCatDr:'', PivaCat:'',RelationFlag:''}
	});
	$("#linkdrugcatMainList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){			
	if ($("#linkdrugcatMainList").datagrid('getSelections').length != 1) {		
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	
	var rowsData = $("#linkdrugcatMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				if (rowsData.ID!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVALinkItm",rowsData.ID)
					if(data!=""){
						if(data==-1){
							$.messager.alert("��ʾ","û��ѡ����Ҫɾ���ļ�¼!"); 
						}else if(data==-2){	
							$.messager.alert('��ʾ','ɾ��ʧ��!');		
						}else{	
							$.messager.alert('��ʾ','ɾ���ɹ�!');		
						}
						$("#linkdrugcatMainList").datagrid('reload');
					}
				}else{
				         var rowIndex = $('#linkdrugcatMainList').datagrid('getRowIndex', rowsData);
         				$('#linkdrugcatMainList').datagrid('deleteRow', rowIndex);  
				}
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

