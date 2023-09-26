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
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'Hosp'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	
	var ctLocEditor = {
		type:'combobox',
		options:{
			id:'comboboxid',
			valueField:'value',
			mode:'remote',
			textField:'text',
			required:true,
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=QryEmConsLoc",
			required:true,
			editable:false,
			onSelect: function () {
				//��ȡѡ�е�ֵ
				var varSelect = $(this).combobox('getValue');
	 			var varEditor = $('#dgMainList').datagrid('getEditor', { index: editRow, field: 'LocID' });
				$(varEditor.target).val(varSelect);//�������ֵ
			}
		}
	}
	
	var provTpEditor= {
		type:'combobox',
		options:{
			id:'comboboxid',
			valueField:'value',
			mode:'remote',
			textField:'text',
			url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonPrvTp",
			required:true,
			editable:false,
			onSelect: function () {
				//��ȡѡ�е�ֵ
				var varSelect = $(this).combobox('getValue');	
	 			var varEditor = $('#dgMainList').datagrid('getEditor', { index: editRow, field: 'CarPrvTpID' });
				$(varEditor.target).val(varSelect);//�������ֵ
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'id',title:'ID',width:200,hidden:true,align:'center'},
		{field:'Loc',title:'����',width:200,editor:ctLocEditor,align:'center'},
		{field:'LocID',title:'����ID',width:200,hidden:true,editor:textEditor,align:'center'},
		{field:'CarPrvTp',title:'ְ��',width:200,editor:provTpEditor,align:'center'},
		{field:'CarPrvTpID',title:'ְ��ID',width:200,hidden:true,editor:textEditor,align:'center'},
		{field:'Hosp',title:'ҽԺ',width:200,editor:HospEditor,align:'center'},
		{field:'HospID',title:'HospID',width:200,hidden:true,editor:textEditor,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTReqJurisdiction&MethodName=QryList";
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
		if(rowsData[i].HospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].CarPrvTpID +"^"+ rowsData[i].HospID ;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTReqJurisdiction","save",{"mParam":params},function(jsonString){

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
		row: {ID:'', ctLoc:'', ctLocID:'', provTp:'', provTpID:'', HospDesc:'', HospID:''}
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
				runClassMethod("web.DHCMDTReqJurisdiction","delete",{"ID":rowsData.ID},function(jsonString){
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