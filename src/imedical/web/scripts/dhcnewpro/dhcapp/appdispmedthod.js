/// Creator: sufan
/// CreateDate: 2016-4-15
//  Descript:�����ֵ�ά��

var editRow="";editparamRow="";  //��ǰ�༭�к�
var dataArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];

$(function(){
	var Eventeditor={  //������Ϊ�ɱ༭
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
				var ed=$("#medthodlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#medthodlist").datagrid('getEditor',{index:editRow,field:'adhospdr'});
				$(ed.target).val(option.value); 
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
				var ed=$("#medthodlist").datagrid('getEditor',{index:editRow,field:'apactiveflag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
			} 
		}

	}

	// ����columns
	var columns=[[
		{field:"adcode",title:'����',width:120,editor:texteditor},
		{field:"addesc",title:'����',width:120,editor:texteditor},
	    {field:'adactiveflag',title:'�Ƿ����',align:'center',width:120,editor:Flageditor},
		{field:'hospdesc',title:'ҽԺ',width:220,editor:Eventeditor},
		{field:"adhospdr",title:'adhospdr',width:100,align:'center',editor:texteditor,hidden:true},
		{field:"adrowid",title:'ID',width:100,align:'center',hidden:true}
	]];
	/*
	// ����datagrid
	$('#medthodlist').datagrid({
		title:'�����ֵ�ά��',
		url:LINK_CSP+'?ClassName=web.DHCAPPDispMedthod&MethodName=QueryMedthod',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:5,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0) { 
                $("#medthodlist").datagrid('endEdit', editRow); 
            } 
            $("#medthodlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	});
	*/
	/// bianshuai 2017-01-01 �޸ģ�����1.3.6��ҳ��ˢ���쳣
 	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow === 0) { 
                $("#medthodlist").datagrid('endEdit', editRow); 
            } 
            $("#medthodlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	
 	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPDispMedthod&MethodName=QueryMedthod";
	new ListComponent('medthodlist', columns, uniturl, option).Init();
	
 	//��ť���¼�
	$('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrStatus(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
            findAdrStatus(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findAdrStatus(); //���ò�ѯ
    });
    

})

// ��������
function insertRow(){
		
	if(editRow>="0"){
		/// ��֤��ǰ��
		if(!$("#medthodlist").datagrid('validateRow', editRow)){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!");
			return;
		}
		$("#medthodlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#medthodlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {adrowid:'', adcode:'', addesc:'', adactiveflag:'Y', adhospdr:'',hospdesc:''}
	});
	$("#medthodlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#medthodlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPDispMedthod","DelMedthod",{"params":rowsData.adrowid},function(jsonString){
					if (jsonString=="-11")
					{
						$.messager.alert("��ʾ","�ô������Ѿ�ʹ�ã�����ɾ��!")
						}
					$('#medthodlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#medthodlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#medthodlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		/// ��֤��ǰ��
		if((rowsData[i].adcode=="")||(rowsData[i].addesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!");
			$('#medthodlist').datagrid('reload'); //���¼���			
			return false;
		}
		if (rowsData[i].adhospdr==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!");
			$('#medthodlist').datagrid('reload'); //���¼���			
			return false;
			}
		var tmp=rowsData[i].adrowid +"^"+ rowsData[i].adcode +"^"+ rowsData[i].addesc +"^"+ rowsData[i].adactiveflag +"^"+ rowsData[i].adhospdr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPDispMedthod","SaveMedthod",{"params":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#medthodlist').datagrid('reload'); //���¼���
		/*if(jsonString==0){
			//$.messager.alert("��ʾ","����ɹ�!"); 
			$('#medthodlist').datagrid('reload'); //���¼���
		}else if(jsonString==-99){
			$.messager.alert("��ʾ","�����ظ�!"); 
			$('#medthodlist').datagrid('reload'); //���¼���
		}else{
			$.messager.alert("��ʾ","����ʧ��!"); 
			$('#medthodlist').datagrid('reload'); //���¼���
			}*/
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ��ѯ
function findAdrStatus()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#medthodlist').datagrid('load',{params:params}); 
}



