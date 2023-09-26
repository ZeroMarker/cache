/// author:    bianshuai
/// date:      2016-04-11
/// descript:  ��������״̬�ֵ�ά��

var editRow = ""; editDRow = "";
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

}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

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
	
	var ActFlagArr = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
	//������Ϊ�ɱ༭
	var activeEditor={
		type: 'combobox',     //���ñ༭��ʽ
		options: {
			data: ActFlagArr,
			valueField: "value",
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue', option.text);  //����Desc
			}
		}
	}
	
	/// ҽԺ
	var HospEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:$URL+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'Code',title:'����',width:100,editor:textEditor,align:'center'},
		{field:'Desc',title:'����',width:200,editor:textEditor,align:'center'},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'ActDesc',title:'�Ƿ����',width:100,editor:activeEditor,align:'center'},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true,align:'center'},
		{field:'HospDesc',title:'ҽԺ',width:300,editor:HospEditor,hidden:true,align:'center'} //hxy 2019-09-18
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		//title:'��������״̬�ֵ�',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCEMConsStatus&MethodName=QryEmConsStatus";
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
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].Code=="")||(rowsData[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		/*if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}*/ //hxy 2019-09-18
		var tmp=rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsStatus","save",{"mParam":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#dgMainList').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#dgMainList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#dgMainList").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', Code:'', Desc:'', ActCode:'Y', ActDesc:'��', HospID:'', HospDesc:''}
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
				runClassMethod("web.DHCEMConsStatus","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','�����Ѻ�ҽ�����,����ɾ����','warning');
					}
					$('#dgMainList').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}