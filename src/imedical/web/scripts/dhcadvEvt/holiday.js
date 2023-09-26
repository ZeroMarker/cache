var editRow="";  //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
var Active=[{"value":"������","text":'������'}, {"value":"�ڼ���","text":'�ڼ���'}];

var StDate=formatDateD(0) //����ȵ�01-01
var EndDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(function(){
	
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
			///��������ֵ
				var ed=$("#holiday").datagrid('getEditor',{index:editRow,field:'Flag'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	
	     
	// ����columns
	var columns=[[
		{field:"Date",title:'����',width:150,editor:dateditor},
		{field:'Flag',title:'�Ƿ�ڼ���',width:80,editor:activeEditor},
		{field:"ID",title:'ID',width:70,align:'center'},
	]];
	
// ����datagrid
	$('#holiday').datagrid({
		title:'�ڼ����ֵ�ά��',
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
                $("#holiday").datagrid('endEdit', editRow); 
            } 
            $("#holiday").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	
    //initScroll("#holiday");//��ʼ����ʾ���������
    $("#stdate").datebox("setValue", StDate);  //Init��ʼ����
	$("#enddate").datebox("setValue", EndDate);  //Init��������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#find').bind("click",Query);  //�����ѯ

    var params=StDate+"^"+EndDate
    $('#holiday').datagrid({
		url:url+'?action=QueryHoliday',
		queryParams:{
			params:params}
	});
	
})

//��ѯ
function Query()
{
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����                 
	var params=StDate+"^"+EndDate;
    $('#holiday').datagrid('load',{params:params}); 		

}


 // ��������
function insertRow()
{
	if(editRow>="0"){
		$("#holiday").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#holiday").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Date:'',Flag:''}
	});
	$("#holiday").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#holiday").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelHoliday',{"params":rows[0].ID}, function(data){
                    if(data==0){
						$.messager.alert('��ʾ','ɾ���ɹ�');		
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}

					$('#holiday').datagrid('reload'); //���¼���
					
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
		$("#holiday").datagrid('endEdit', editRow);
	}

	var rows = $("#holiday").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Date=="")||(rows[i].Flag=="")){
			$.messager.alert("��ʾ","���ڲ���Ϊ��!"); 
			return false;
			fush();
		}
		var tmp=rows[i].ID+"^"+rows[i].Date+"^"+rows[i].Flag;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveHoliday',{"params":rowstr},function(data){
	   if(data==0){
			$.messager.alert("��ʾ","����ɹ�!");		
		}else if((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
		}
			$('#holiday').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}


var dateditor={
	type: 'datebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

