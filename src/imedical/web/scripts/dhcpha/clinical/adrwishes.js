/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ���Ը�ֵ��ά��

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫���м��ɱ༭]</span>';
$(function(){
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'����',width:160,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];
	
	// ����datagrid
	$('#adrwishesdg').datagrid({
		title:'���Ը'+titleNotes,
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
             if ((editRow != "")||(editRow=="0")) { 
                $("#adrwishesdg").datagrid('endEdit', editRow); 
            } 
            $("#adrwishesdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#adrwishesdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrWishes(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
            findAdrWishes(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findAdrWishes(); //���ò�ѯ
    });
    
    $('#adrwishesdg').datagrid({
		url:url+'?action=QueryAdrWishes',	
		queryParams:{
			params:''}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#adrwishesdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#adrwishesdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrwishesdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#adrwishesdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrWishes',{"params":rows[0].ID}, function(data){
					$('#adrwishesdg').datagrid('reload'); //���¼���
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
		$("#adrwishesdg").datagrid('endEdit', editRow);
	}

	var rows = $("#adrwishesdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#adrwishesdg').datagrid('reload');
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveAdrWishes',{"params":rowstr},function(data){
		$('#adrwishesdg').datagrid('reload'); //���¼���
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
function findAdrWishes()
{
	var adrWishesCode=$('#code').val();
	var adrWishesDesc=$('#desc').val();
	var params=adrWishesCode+"^"+adrWishesDesc;
	$('#adrwishesdg').datagrid('load',{params:params}); 
}