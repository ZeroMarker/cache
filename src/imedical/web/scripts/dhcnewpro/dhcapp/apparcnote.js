
/// bianshuai
/// 2016-04-11
/// ���ҽ����ע������

var editRow = ""; editDRow = ""; itmmastid = "";
$(function(){

	//��ʼ������Ĭ����Ϣ
	InitDefault();

	//��ʼ����ѯ��Ϣ�б�
	InitDetList();

	//��ʼ�����水ť�¼�
	InitWidListener();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	itmmastid=getParam("itmmastid");  ///ҽ����ID
}


/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	/**
	 * ע������ģ���ֵ�
	 */
	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
}

///��ʼ�������б�
function InitDetList(){
	
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
			url: LINK_CSP+"?ClassName=web.DHCAPPNotItemTemp&MethodName=jsonNoteItemTemp&HospID="+LgHospID,  
			onSelect:function(option){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'itemTempId'});
				$(ed.target).val(option.value);  //���ò���ID
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'itemTempDesc'});
				$(ed.target).combobox('setValue', option.text);  //���ò���Desc
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'itemTempId',title:'itemTempId',width:100,editor:textEditor,hidden:true},
		{field:'itemTempDesc',title:'ע������',width:300,editor:tempEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		//title:'���ҽ����ע������',
		//nowrap:false,
		border:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);
			}
		}
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcNote&MethodName=QueryAppArcNote&itmmastid="+itmmastid+"&HospID="+LgHospID;
	var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	dgMainListComponent.Init();
}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);
	}

	var rowsData = $("#dgMainList").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	if (itmmastid == ""){
		$.messager.alert("��ʾ","��ѡ��һ��ѡ��!"); 
		return;	
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].itemTempId==""){
			$.messager.alert("��ʾ","ע�������Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ itmmastid +"^"+ rowsData[i].itemTempId;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPArcNote","saveArcNote",{"anArcNoteDataList":params},function(jsonString){
		if (jsonString == 1){
			$.messager.alert('��ʾ','����ʧ��:�����ظ���','warning');
		}
		$('#dgMainList').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if (itmmastid == ""){
		$.messager.alert("��ʾ","��ѡ��һ��ѡ��!"); 
		return;	
	}
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', itemTempId:'', itemTempDesc:''}
	});
	$("#dgMainList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArcNote","delArcNote",{'anID':rowsData.ID},function(jsonString){
					$('#dgMainList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

