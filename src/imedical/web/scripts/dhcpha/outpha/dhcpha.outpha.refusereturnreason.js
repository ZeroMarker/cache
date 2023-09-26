/*
ģ��:����ҩ��
��ģ��:����ҩ��-�ܾ���ҩԭ��ά��
createdate:2016-06-13
creator:yunhaibao
*/
var editRow="";  //��ǰ�༭�к�
var url="dhcpha.outpha.returnrefusereason.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:14px;font-family:Mictosoft YaHei;color:#800000;"><˫���м��ɱ༭></span>';
$(function(){
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center',hidden:true},
		{field:"Code",title:'����',width:160,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];
	
	// ����datagrid
	$('#reasongrid').datagrid({
		title:'�ܾ���ҩԭ��ά��'+titleNotes,
		url:url+'?action=QueryReason',
		fit:true,
		striped:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow=="0")) { 
                $("#reasongrid").datagrid('endEdit', editRow); 
            } 
            $("#reasongrid").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#reasongrid");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').on('click',insertRow); 
    $('#delete').on('click',deleteRow);
    $('#save').on('click',saveRow);
    $('#reasongrid').datagrid("reload");
})

// ��������
function insertRow()
{
	var row = $('#reasongrid').datagrid('getData').rows[0];
	//if(row["ID"]==""){
	//	return ;
	//}
	if(editRow>="0"){
		$("#reasongrid").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#reasongrid").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#reasongrid").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#reasongrid").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DeleteReason',{"params":rows[0].ID}, function(data){
					$('#reasongrid').datagrid('reload'); //���¼���
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
		$("#reasongrid").datagrid('endEdit', editRow);
	}
	var rows = $("#reasongrid").datagrid('getChanges');
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
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		var existret=tkMakeServerCall("web.DHCOUTPHA.PHRRefuseReason","CheckRefuseReason",rows[i].ID,rows[i].Code,rows[i].Desc)
		if (existret=="-1"){
			$.messager.alert("��ʾ",rows[i].Code+",�����Ѵ���,����ά���ظ�����!","info"); 
			return false;
		}else if (existret=="-2"){
			$.messager.alert("��ʾ",rows[i].Desc+",�����Ѵ���,����ά���ظ�����!","info"); 
			return false;
		} 
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveReason',{"params":rowstr},function(data){
		$('#reasongrid').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}