/// author:     bianshuai
/// date:       2016-04-11
/// descript:   �����¼���Ԫ�ض��ս���JS

var editRow = ""; editDRow = "";
$(function(){
	
	//��ʼ�����չ�ϵ�б�
	InitdgMainList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
})

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
	$HUI.combobox("#formname",{
		url:LINK_CSP+"?ClassName=web.DHCADVFormName&MethodName=listCombo",
		valueField:'value',
		textField:'text',
		mode:'remote',
		blurValidValue:true,
		onSelect:function(option){

	    }	
	})

	$("div#tb a:contains('����')").bind("click",insertRow);
	$("div#tb a:contains('ɾ��')").bind("click",deleteRow);
	$("div#tb a:contains('����')").bind("click",saveRow);
	
    $('#code,#desc').bind('keypress',function(event){   //sufan 2019-11-04 ���Ӽ�������
        if(event.keyCode == "13")    
        {
            finddglist();
        }
    });
    
    $('#find').bind('click',function(event){
         finddglist();
    });
    $('#reset').bind('click',function(event){
	     $("#code,#desc").val("");
	     $HUI.combobox("#formname").setValue("")
         finddglist();
    });
    
	
}

///��ʼ�������б�
function InitdgMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	/// Ԫ��Combobox
	var FormDicEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:"",
			//required:true,
			//panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				/// Ԫ������
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// Ԫ�ش���
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicCode'});
				$(ed.target).val(option.code);
				/// Ԫ��ID
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	/// �ֶ�Combobox
	var FormFieldEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormField",
			//required:true,
			//panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				/// Ԫ������
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldDesc'});
				$(ed.target).combobox('setValue', option.text);
				/// Ԫ�ش���
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldCode'});
				$(ed.target).val(option.code);
				/// Ԫ��ID
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FieldID'});
				$(ed.target).val(option.value); 
			}
		}
	}
	
	/// ��Combobox
	var FormEditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonForm",
			//required:true,
			//panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormNameCode'});
				$(ed.target).val(option.code);
				
				///���ü���ָ��
				var FormID=option.value;  //Ԫ��
				var FormDicDesced=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicDesc'});
				$(FormDicDesced.target).combobox('setValue', "");
				var unitUrl=LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=jsonFormDic&FormID="+FormID;
				$(FormDicDesced.target).combobox('reload',unitUrl);
				var FormDicCodeed=$("#dgMainList").datagrid('getEditor',{index:editRow,field:'FormDicCode'});
				$(FormDicCodeed.target).val("");
			}
		}
	}
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'FieldID',title:'�ֶ�ID',width:120,editor:textEditor,hidden:true},
		{field:'FieldCode',title:'�ֶδ���',width:120,editor:textEditor},
		{field:'FieldDesc',title:'�ֶ�����',width:120,editor:FormFieldEditor},
		{field:'FormNameCode',title:'������',width:220,editor:textEditor,hidden:true},
		{field:'FormNameDesc',title:'������',width:220,editor:FormEditor},
		{field:'FormDicID',title:'Ԫ��ID',width:120,editor:textEditor,hidden:true},
		{field:'FormDicCode',title:'Ԫ�ش���',width:220,editor:textEditor},
		{field:'FormDicDesc',title:'Ԫ������',width:120,editor:FormDicEditor}
	]];
	/**
	 * ����datagrid
	 */
	$('#dgMainList').datagrid({
		columns:columns,
		fit:true,
		title:'', //�����¼���Ԫ�ض��չ�ϵ
		//nowrap:false,
		url:'dhcapp.broker.csp?ClassName=web.DHCADVFormDicContrast&MethodName=QryDicContrast',
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
		singleSelect : true,
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#dgMainList").datagrid('endEdit', editRow); 
            } 
            $("#dgMainList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
		onLoadSuccess:function(data){
		}
	});
	
	//var uniturl = LINK_CSP+"?ClassName=web.DHCADVFormDicContrast&MethodName=QryDicContrast";
	//var dgMainListComponent = new ListComponent('dgMainList', columns, uniturl, option);
	//dgMainListComponent.Init();
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
		
		if(rowsData[i].FieldID==""){
			$.messager.alert("��ʾ","�ֶβ���Ϊ��!"); 
			return false;
		}
		if(rowsData[i].FormDicID==""){
			$.messager.alert("��ʾ","Ԫ�ز���Ϊ��!"); 
			return false;
		}
		
		//row: {ID:'', FieldID:'', FieldCode:'', FieldDesc:'', FormID:'', FormNameCode:'', FormNameDesc:'', FormDicID:'', FormDicCode:'', FormDicDesc:''}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].FieldID +"^"+ rowsData[i].FormDicCode +"^"+ rowsData[i].FormNameCode;
		dataList.push(tmp);
	}
	
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCADVFormDicContrast","saveContrast",{"mListData":params},function(jsonString){

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
		//row: {ID:'', FieldID:'', FieldCode:'', FieldDesc:'', FormCode:'', FormNameDesc:'', FormID:'', FormNameDesc:''}
		row: {ID:'', FieldID:'', FieldCode:'', FieldDesc:'', FormNameCode:'',FormNameDesc:'', FormDicID:'', FormDicCode:'', FormDicDesc:''}
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
				runClassMethod("web.DHCADVFormDicContrast","delContrast",{"ID":rowsData.ID},function(jsonString){
					if (jsonString == -1){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
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

// ��ѯ
function finddglist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var formname=$HUI.combobox("#formname").getValue();
	var params=code+"^"+desc+"^"+formname;
	$('#dgMainList').datagrid('load',{params:params}); 
}