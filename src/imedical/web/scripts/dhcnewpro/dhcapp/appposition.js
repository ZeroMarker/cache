/// Creator: sufan
/// CreateDate: 2016-4-13
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
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'hospdesc'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'aphospdr'});
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
				var ed=$("#positionlist").datagrid('getEditor',{index:editRow,field:'apactiveflag'});
				$(ed.target).combobox('setValue', option.value);  //�����Ƿ����
			} 
		}

	}

	// ����columns
	var columns=[[
		{field:"apcode",title:'����',width:100,editor:texteditor},
		{field:"apdesc",title:'����',width:100,editor:texteditor},
	    {field:'apactiveflag',title:'�Ƿ����',width:120,align:'center',editor:Flageditor},
	    {field:"aphospdr",title:'aphospdr',width:100,align:'center',editor:texteditor,hidden:true},
		{field:'hospdesc',title:'ҽԺ',width:220,editor:Eventeditor},
		{field:"aprowid",title:'ID',width:70,align:'center',hidden:true}
	]];
	/*
	// ����datagrid
	$('#positionlist').datagrid({
		title:'��λ�ֵ�ά��',
		url:LINK_CSP+'?ClassName=web.DHCAPPPosition&MethodName=QueryPosition' ,
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
                $("#positionlist").datagrid('endEdit', editRow); 
            } 
            $("#positionlist").datagrid('beginEdit', rowIndex); 
            
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
            if ((editRow != "")||(editRow === 0)) { 
                $("#positionlist").datagrid('endEdit', editRow); 
            } 
            $("#positionlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	
 	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPPosition&MethodName=QueryPosition";
	new ListComponent('positionlist', columns, uniturl, option).Init();
	
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
		$("#positionlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#positionlist").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {aprowid:'', apcode:'', apdesc:'', apactiveflag:'Y',aphospdr:'',hospdesc:''}
	});
	$("#positionlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#positionlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPPosition","DelPosition",{"params":rowsData.aprowid},function(jsonString){
					$('#positionlist').datagrid('reload'); //���¼���
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
		$("#positionlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#positionlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].apcode=="")||(rowsData[i].apdesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		if (rowsData[i].aphospdr==""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].aprowid +"^"+ rowsData[i].apcode +"^"+ rowsData[i].apdesc +"^"+ rowsData[i].apactiveflag +"^"+ rowsData[i].aphospdr;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPPosition","SavePosition",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#positionlist').datagrid('reload'); //���¼���
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
	$('#positionlist').datagrid('load',{params:params}); 
}



