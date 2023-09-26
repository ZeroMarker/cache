/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ������Ŀά��

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
$(function(){
	
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'��������',width:160,editor:texteditor},
		{field:'Desc',title:'��������',width:300,editor:texteditor},
		{field:'CatDr',title:'OpCatID',width:160,hidden:true,editor:texteditor},
		{field:'CatDesc',title:'��������',width:300,editor:opcategroyeditor}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		//title:'������Ŀά��',
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
            if (editRow != "") { 
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#dg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //�������
	$('#opcategory').combobox({
		onShowPanel:function(){
			$('#opcategory').combobox('reload',url+'?action=SelOperCateGory')
		}
	});
	
	 //������Ŀ
	$('#opitem').combobox({
		onShowPanel:function(){
			$('#opitem').combobox('reload',url+'?action=SelOperItem')
		}
	});
    
    $('#dg').datagrid({
		url:url+'?action=QueryOperItem',	
		queryParams:{
			params:""}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: '',Category:''}
	});
	$("#dg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#dg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelOperItem',{"params":rows[0].ID}, function(data){
					$('#dg').datagrid('reload'); //���¼���
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
		$("#dg").datagrid('endEdit', editRow);
	}

	var rows = $("#dg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].CatDr;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveOperItem',{"params":rowstr},function(data){
		$('#dg').datagrid('reload'); //���¼���
	});
}


var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
	}
	
var opcategroyeditor={  //������Ϊ�ɱ༭
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//required: true,//���ñ༭��������
		valueField: "val", 
		textField: "text",
		url: url+'?action=SelOperCateGory',
		onSelect:function(option){
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'CatDr'});
			$(ed.target).val(option.val);  //���ÿ���ID
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'CatDesc'});
			$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
		}
	}
}

// ��ѯ
function query()
{
	var opitem=$('#opitem').combobox('getValue'); 
	var opcategory=$('#opcategory').combobox('getValue');
	//combobox ɾ�����ݺ�Ϊundefined
	if (opitem== undefined){opitem="";}
	if (opcategory== undefined){opcategory="";}
	var params=opitem+"^"+opcategory;
	$('#dg').datagrid('load',{params:params}); 
}