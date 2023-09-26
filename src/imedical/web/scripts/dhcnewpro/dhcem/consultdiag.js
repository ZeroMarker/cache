/// author:    bianshuai
/// date:      2018-06-21
/// descript:  MDT�����ֵ�ά��

var editRow = ""; editDRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ����ѯ��Ϣ�б�
	InitMainList();
	
	/// ��ʼ�����水ť�¼�
	InitWidListener();
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
}

///��ʼ�������б�
function InitMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ���
	var MRCEditor={
		type:'combogrid',
		options:{
			    fitColumns:true,
			    fit: true,//�Զ���С
			    showHeader:false,  
				pagination : true,
				panelWidth:600,
				textField:'MrDesc',
				mode:'remote',
				url: $URL+"?ClassName=web.DHCEMConsultCom&MethodName=GetMRCICDDx",
				columns:[[
				    {field:'MRCID',title:'ID',width:100,hidden:true},
				    {field:'MRCCode',title:'����',width:100},
				    {field:'MRCDesc',title:'����',width:300}
				]],
				onSelect:function(rowIndex, rowData) {
					
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MrID'});
					$(ed.target).val(rowData.MRCID);
					var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MrCode'});
					$(ed.target).val(rowData.MRCCode);
    			}		   
			}
		}
		
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'MrID',title:'MrID',width:100,editor:textEditor,align:'center',hidden:true},
		{field:'MrCode',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'MrDesc',title:'����',width:300,editor:MRCEditor,align:'center'},
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsultDiag&MethodName=QryConsultDiag";
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}

	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].MrID==""){
			$.messager.alert("��ʾ","��ϲ���Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].MrID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsultDiag","Save",{"mListData":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', MrID:'', MrDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsultDiag","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#main').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })