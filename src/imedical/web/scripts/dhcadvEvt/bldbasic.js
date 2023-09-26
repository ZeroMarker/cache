/// Creator: congyue
/// CreateDate: 2016-01-13
//  Descript: ��Ѫ���������ֵ�ά��
 
var editRow="";  //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
var typeArray= [{"value":"A","text":"��������"}, {"value":"B","text":"�ٴ�֢״"}];
$(function(){
	//Type����
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:typeArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ID
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'TypeID'});
				$(ed.target).val(option.value); 
				///��������
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue',option.text); 
			} 
		}
	}
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'����',width:160,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor},
		{field:'TypeID',title:'����ID',width:100,editor:texteditor,hidden:true},
		//{field:'Type',title:'����',width:300,editor:typeEditor},
		{field:"Type",title:'����',width:300,editor:texteditor,
			editor: {  //������Ϊ�ɱ༭
				type: 'combobox',//���ñ༭��ʽ
		options: {
			data:typeArray,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ID
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'TypeID'});
				$(ed.target).val(option.value); 
				///��������
				var ed=$("#bldbasdg").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue',option.text); 
			} 
		}
			}
		}
	]];
	
	// ����datagrid
	$('#bldbasdg').datagrid({
		title:'',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
        	if ((editRow != "")||(editRow == "0")) {
            	$("#bldbasdg").datagrid('endEdit', editRow); 
			} 
            $("#bldbasdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	initScroll("#bldbasdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            queryBldBasic(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         queryBldBasic(); //���ò�ѯ
    });
    
    $('#bldbasdg').datagrid({
		url:url+'?action=QueryBldBasic',	
		queryParams:{
			params:""}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#bldbasdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#bldbasdg").datagrid('insertRow', {//��ָ�����������ݣ�appendRow�������һ����������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: '',TypeID: '',Type: ''}
	});
	$("#bldbasdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#bldbasdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelBldBasic',{"params":rows[0].ID}, function(data){
					if(data==0){
						$.messager.alert('��ʾ','ɾ���ɹ�');	
					}else if(data==-1){
						$.messager.alert('��ʾ','�����ݴ���ʹ����Ϣ������ɾ��');	
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}
					$('#bldbasdg').datagrid('reload'); //���¼���
				});
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

// ����༭��
function saveRow()
{
	if(editRow>="0"){
		$("#bldbasdg").datagrid('endEdit', editRow);
	}

	var rows = $("#bldbasdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")||(rows[i].Type=="")){
			$.messager.alert("��ʾ","�б�����δ��д�����ʵ!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].TypeID
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("&&");
	//��������
	$.post(url+'?action=SaveBldBasic',{"params":rowstr},function(data){
		if(data==0){
			$.messager.alert('��ʾ','�����ɹ�');
		}else if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ������','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��	
		}else {
			$.messager.alert('��ʾ','����ʧ��','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
		$('#bldbasdg').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'validatebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

// ��ѯ
function queryBldBasic()
{
	var bldBasicCode=$('#code').val();
	var bldBasicDesc=$('#desc').val();
	var params=bldBasicCode+"^"+bldBasicDesc;
	$('#bldbasdg').datagrid('load',{params:params}); 
}