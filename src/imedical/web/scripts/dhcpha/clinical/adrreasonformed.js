/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ������Ӧ������ҩԭ���ֵ��ά��

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
	$('#adrreasonformeddg').datagrid({
		title:'������Ӧ������ҩԭ��'+titleNotes,
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
                $("#adrreasonformeddg").datagrid('endEdit', editRow); 
            } 
            $("#adrreasonformeddg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#adrreasonformeddg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            //findAdrReasonForMed(this.id+"^"+$('#'+this.id).val()); //���ò�ѯ
            findAdrReasonForMed(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findAdrReasonForMed(); //���ò�ѯ
    });
    
    $('#adrreasonformeddg').datagrid({
		url:url+'?action=QueryAdrReasonForMed',	
		queryParams:{
			params:''}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#adrreasonformeddg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#adrreasonformeddg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#adrreasonformeddg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#adrreasonformeddg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdrReasonForMed',{"params":rows[0].ID}, function(data){
					$('#adrreasonformeddg').datagrid('reload'); //���¼���
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
		$("#adrreasonformeddg").datagrid('endEdit', editRow);
	}

	var rows = $("#adrreasonformeddg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#adrreasonformeddg').datagrid('reload');
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveAdrReasonForMed',{"params":rowstr},function(data){
		$('#adrreasonformeddg').datagrid('reload'); //���¼���
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
function findAdrReasonForMed()
{
	var adrReasonForMedCode=$('#code').val();
	var adrReasonForMedDesc=$('#desc').val();
	var params=adrReasonForMedCode+"^"+adrReasonForMedDesc;
	$('#adrreasonformeddg').datagrid('load',{params:params}); 
}