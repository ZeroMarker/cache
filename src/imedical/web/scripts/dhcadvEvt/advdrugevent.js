var editRow="";editparamRow="";  //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
$(function(){

      
	// ����columns 
	var columns=[[
		{field:"ID",title:'ID',width:70,align:'center'},
		{field:"Code",title:'����',width:120,editor:texteditor},
		{field:'Desc',title:'����',width:200,editor:texteditor},
	]];
	
// ����datagrid
	$('#advevent').datagrid({
		title:'',//�����¼�����
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
                $("#advevent").datagrid('endEdit', editRow); 
            } 
            $("#advevent").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	
    initScroll("#advevent");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#find').bind("click",Query);  //�����ѯ	

    
    $('#advevent').datagrid({
		url:url+'?action=QueryAdvEvent',
		queryParams:{
			params:''}
	});
	
})

//��ѯ
function Query()
{
	var advdeCode=$('#code').val();
	var advdeDesc=$('#desc').val();                 
	var params=advdeCode+"^"+advdeDesc;
    $('#advevent').datagrid('load',{params:params}); 	

}


 // ��������
function insertRow()
{
	if(editRow>="0"){
		$("#advevent").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	var rows = $("#advevent").datagrid('getChanges')
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
	} 
	
	$("#advevent").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc:''}
	});
	$("#advevent").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#advevent").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdvEvent',{"params":rows[0].ID}, function(data){
				    if(data==0){
						$.messager.alert('��ʾ','ɾ���ɹ�');	
					}else if(data==-1){
						$.messager.alert('��ʾ','�����ݴ���ʹ����Ϣ������ɾ��');	
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}
					$('#advevent').datagrid('reload'); //���¼���
					
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
		$("#advevent").datagrid('endEdit', editRow);
	}

	var rows = $("#advevent").datagrid('getChanges')
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
		dataList.push(tmp);
	} 
	var params=dataList.join("||");

	//��������
	$.post(url+'?action=SaveAdvEvent',{"params":params},function(data){
		
		if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��
		}
		$('#advevent').datagrid('reload'); //���¼���
		
	});
}

// �༭��
var texteditor={
	type: 'validatebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

