/*
ģ��:		������Һ����
��ģ��:		������Һ����-��Һ�������շ���ά��
Creator:	hulihua
CreateDate:	2016-12-20
*/
var editRow = ""; editDRow = ""; polid = "";
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){
	///��ʼ����Һ����б�
	InitPivaCatList()		
	///��ʼ���շ����б�
	InitPIVAcatOrderList();
	///��ʼ�������շ���ҽ���б�
	$('#pivacatlist').datagrid('loadData',{total:0,rows:[]});
})

///��Һ����б�
function InitPivaCatList(){
	//����columns
	var columns=[[
	    {field:"PolId",title:'ID',width:20,align:'center',hidden:true},
	    {field:"PolDesc",title:'��Һ��������',width:360,align:'center'}
	]];  
    //����datagrid	
    $('#pivacatlist').datagrid({    
        url:url+'?action=GetPHCPivaCatList',
        fit:true,
	    border:false,
	    singleSelect:true,
	    rownumbers:true,
	    nowrap:false,
        columns:columns,
        pageSize:10,  // ÿҳ��ʾ�ļ�¼����
	    pageList:[10,20,30,50],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onLoadError:function(data){
			$.messager.alert("����","��������ʧ��,��鿴������־!","warning");
			$('#pivacatlist').datagrid('loadData',{total:0,rows:[]});
		},
		onClickRow:function(rowIndex, rowData){
	        polid=rowData.PolId;
	        Query();		
	    }
    });
}

///�շ����б�
function InitPIVAcatOrderList(){
	
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
			mode:'remote',  // yunhaibao20170205,����������combo�����첽,����������̨,queryname is q
			delay:500,
			url: url+'?action=GetAllDrugOrderList',  
			onSelect:function(option){
				var ed=$("#pivacatorderlist").datagrid('getEditor',{index:editRow,field:'OrderDescDr'});
				$(ed.target).val(option.value);  					
				var ed=$("#pivacatorderlist").datagrid('getEditor',{index:editRow,field:'OrderDesc'});
				$(ed.target).combobox('setValue', option.text);  
			}
		}
	}
	
	//����columns
	var columns=[[
	    {field:'ID',title:'ID',width:100,editor:textEditor,hidden:true},
		{field:'OrderDescDr',title:'InstrucDr',width:100,editor:textEditor,hidden:true},
		{field:"OrderDesc",title:'�շ���ҽ��',width:360,align:'center',editor:tempEditor},
		{field:"OrderQty",title:'����',width:100,align:'right',editor:textEditor}
	]];  
	/**
	 * ����datagrid
	 */
	$('#pivacatorderlist').datagrid({
		title:'',
		url:url+'?action=GetPHCPivaLinkOrder&params='+polid,
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
                $("#pivacatorderlist").datagrid('endEdit', editRow); 
            } 
            $("#pivacatorderlist").datagrid('beginEdit', rowIndex); 
            
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
		$("#pivacatorderlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#pivacatorderlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].OrderDesc=="")||(rowsData[i].OrderDesc==null)){
			$.messager.alert("��ʾ","��Ҫ�������շ���ҽ������Ϊ��!"); 
			return false;
		}
		if((rowsData[i].OrderQty=="")||(rowsData[i].OrderQty==null)||(rowsData[i].OrderQty==0)||(rowsData[i].OrderQty==undefined)){
			$.messager.alert("��ʾ","��Ҫ�������շ���ҽ����������Ϊ�ջ�Ϊ0!"); 
			return false;
		}

		var tmp=polid+"^"+rowsData[i].ID+"^"+rowsData[i].OrderDescDr+"^"+rowsData[i].OrderQty;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVALinkOrder",params)
	if(data!=""){
		if(data==-1){
			$.messager.alert("��ʾ","��Ҫ�������շ���Ϊ��,���ܱ���!"); 
		}else if(data==-2){	
			$.messager.alert('��ʾ','����ʧ��!');		
		}else if(data==-11){	
			$.messager.alert('��ʾ','���շ����Ѵ���!');		
		}else{	
			$.messager.alert('��ʾ','���³ɹ�!');
			$("#pivacatorderlist").datagrid('reload');		
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
		$("#pivacatorderlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#pivacatorderlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', OrderDescDr:'', OrderDesc:'',OrderQty:''}
	});
	$("#pivacatorderlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){			
	if ($("#pivacatorderlist").datagrid('getSelections').length != 1) {		
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	
	var rowsData = $("#pivacatorderlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����ѡ��������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				if (rowsData.ID!=""){
					var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","DeletePIVALinkOrder",rowsData.ID)
					if(data!=""){
						if(data==-1){
							$.messager.alert("��ʾ","û��ѡ����Ҫɾ���ļ�¼!"); 
						}else if(data==-2){	
							$.messager.alert('��ʾ','ɾ��ʧ��!');		
						}else{	
							$.messager.alert('��ʾ','ɾ���ɹ�!');		
						}
						$("#pivacatorderlist").datagrid('reload');
					}
				}else{
					var rowIndex = $('#pivacatorderlist').datagrid('getRowIndex', rowsData);
     				$('#pivacatorderlist').datagrid('deleteRow', rowIndex);  
				}
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

///�����շ���ҽ����ѯ
function Query(){
	var params=polid;
	$('#pivacatorderlist').datagrid('load',{params:params}); 	 
}