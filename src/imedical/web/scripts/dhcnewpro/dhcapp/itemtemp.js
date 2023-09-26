/// bianshuai
/// 2016-04-11
/// ע������ģ���ֵ�ά��

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

	/**
	 * ע������ģ���ֵ�
	 */
	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
	/**
	 * ע��������ϸ
	 */
	$("div#dtb a:contains('����')").bind("click",saveItmTmpNotes);
	$("div#dtb a:contains('���')").bind("click",clearItmTmpNotes);
	$("div#dtb a:contains('ɾ��')").bind("click",delItmTmpNotes);
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
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitActCode'});
				$(ed.target).val(option.value);  //����value
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitActDesc'});
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
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitHospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'aitHospID'});
				$(ed.target).val(option.value); 
			} 
	
		}
	}
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'aitID',title:'aitID',width:100,hidden:true},
		{field:'aitCode',title:'����',width:100,editor:textEditor},
		{field:'aitDesc',title:'����',width:160,editor:textEditor},
		{field:'aitActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'aitActDesc',title:'�Ƿ����',width:100,align:'center',editor:activeEditor},
		{field:'aitHospID',title:'aitHospID',width:100,editor:textEditor,hidden:true},
		{field:'aitHospDesc',title:'ҽԺ',width:200,editor:HospEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
        onClickRow:function(rowIndex, rowData){
			GetItemTempNotes(rowData.aitID);
	    },
		onLoadSuccess:function(data){
			var rows = $("#dgMainList").datagrid('getRows');
			if (rows.length != "0"){
				$('#dgMainList').datagrid('selectRow',0);
				var rowData = $('#dgMainList').datagrid('getSelected');
				GetItemTempNotes(rowData.aitID);
			}
		}
	};
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPNotItemTemp&MethodName=QueryAppItemTemp";
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
		
		if((rowsData[i].aitCode=="")||(rowsData[i].aitDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		if(rowsData[i].aitHospID==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].aitID +"^"+ rowsData[i].aitCode +"^"+ rowsData[i].aitDesc +"^"+ rowsData[i].aitActCode +"^"+ rowsData[i].aitHospID;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");

	//��������
	runClassMethod("web.DHCAPPNotItemTemp","saveItmTemp",{"ItmTempDataList":params},function(jsonString){

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
		if (rowsData[0].aitCode == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#dgMainList").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {aitID:'', aitCode:'', aitDesc:'', aitActCode:'Y', aitActDesc:'��', aitHospID:'', aitHospDesc:''}
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
				runClassMethod("web.DHCAPPNotItemTemp","delItmTemp",{"ID":rowsData.aitID},function(jsonString){
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

/// ����
function saveItmTmpNotes(){

	var rowsMData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsMData == null){
		$.messager.alert("��ʾ", "����ѡ��ģ���ֵ䣬Ȼ������ӣ�");
		return;
	}

	var itemTempId = $("#itemTempId").val();   		///�ӱ�ID
	var itemTempDesc = $("#itemTempDesc").val(); 	///ע��������������
	var params=itemTempId +"^"+ rowsMData.aitID +"^"+ itemTempDesc;

	//��������
	runClassMethod("web.DHCAPPNotItemTemp","saveItmTempD",{"ItmTempDataList":params},function(jsonString){
		if (jsonString == 0){
			$.messager.alert("��ʾ", "����ɹ���");
			GetItemTempNotes(rowsMData.aitID);
		}else{
			$.messager.alert("��ʾ", "����ʧ�ܣ�");
		}
	})
}

/// ɾ��ѡ��ע��������
function delItmTmpNotes(){
	
	var rowsMData = $("#dgMainList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsMData == null){
		$.messager.alert("��ʾ", "����ѡ��ģ���ֵ䣬Ȼ������ӣ�");
		return;
	}
	
	var itemTempId = $("#itemTempId").val();   		///�ӱ�ID
	if (itemTempId == ""){
		$.messager.alert("��ʾ", "ɾ��ʧ��,ʧ��ԭ��:����Ϊ�գ�");
		return;
	}
	$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			runClassMethod("web.DHCAPPNotItemTemp","delItmTempD",{"ID":itemTempId},function(jsonString){
				if (jsonString == 0){
					$.messager.alert("��ʾ", "ɾ���ɹ���");
					GetItemTempNotes(rowsMData.aitID);
				}else{
					$.messager.alert("��ʾ", "ɾ��ʧ�ܣ�");
				}
			})
		}
	});
}

/// ȡģ���ֵ�����
function GetItemTempNotes(aitID){
	
	$("#itemTempId").val('');     ///�ӱ�ID
	$('#itemTempDesc').html('');  ///���

	/// ��ѯ����
	runClassMethod("web.DHCAPPNotItemTemp","GetItemTempNotes",{"aitID":aitID},function(jsonString){

		if (jsonString != null){
			//var jsonObj = jQuery.parseJSON(jsonString);
			var jsonObj = jsonString;
			$('#itemTempId').val(jsonObj.itemTempId);  ///ע������ID
			$('#itemTempDesc').val(jsonObj.itemTempDesc.replace(new RegExp("<br>","g"),"\r\n"));  ///ע������    ///sufan  2017-02-16  �޸�IE8�س���������
		}
	})
}

/// ���
function clearItmTmpNotes(){

	$("#itemTempDesc").val('');
}

