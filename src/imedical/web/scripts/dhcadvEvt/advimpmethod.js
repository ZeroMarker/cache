var editRow="";editparamRow="";  //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
//var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫���м��ɱ༭]</span>';
//var titleNotes2='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;"></span>';
var Active = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];
$(function(){
	     
	//�Ƿ���ñ�־
	var activeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Active,
			valueField: "value", 
			textField: "text",
			//required:true,
			panelHeight:"auto" //���������߶��Զ�����
		}
	}
	//ҽԺ //hxy 2019-07-01
	var hospEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
			valueField: "value", 
			textField: "text",
			//required:true,
			//editable:false, //hxy 2019-07-04 ����յĻ�����պ���ʾ��׼ȷ
			//panelHeight:"auto" //���������߶��Զ�����
			onSelect:function(option){
				var Hosped=$("#advimp").datagrid('getEditor',{index:editRow,field:'Hosp'});
				$(Hosped.target).val(option.text);  //����ҽԺ
				var HospIDed=$("#advimp").datagrid('getEditor',{index:editRow,field:'HospID'});
				$(HospIDed.target).val(option.value);  //����ҽԺID
			}
		}
	}
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:70,align:'center'},
		{field:"Code",title:'����',width:120,editor:texteditor},
		{field:'Desc',title:'����',width:200,editor:texteditor},
		{field:'Active',title:'�Ƿ����',width:80,formatter:formatLink,editor:activeEditor},
		{field:'Hosp',title:'ҽԺ',width:200,editor:hospEditor}, //hxy 2019-07-01
		{field:'HospID',title:'ҽԺID',width:80,editor:'text',hidden:true} //hxy 2019-07-01
	]];
	
// ����datagrid
	$('#advimp').datagrid({
		title:'',//�����¼��Ľ�����
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
                $("#advimp").datagrid('endEdit', editRow); 
            } 
            $("#advimp").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
       
	});
	
    initScroll("#advimp");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    $('#find').bind("click",Query);  //�����ѯ

    
    $('#advimp').datagrid({
		url:url+'?action=QueryAdvImp',
		queryParams:{
			params:''}
	});
	
	$('#hospDrID').combobox({ //hxy 2019-07-20 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	}) //ed
	
})

//��ѯ
function Query()
{
	var aimeCode=$('#code').val();
	var aimeDesc=$('#desc').val();
	var hospDrID=$('#hospDrID').combobox('getValue');  //hxy 2019-07-20  
	if(hospDrID==undefined){hospDrID=""}               
	var params=aimeCode+"^"+aimeDesc+"^"+hospDrID;
		//alert(params)
    $('#advimp').datagrid('load',{params:params}); 		

}




 // ��������
function insertRow()
{
	if(editRow>="0"){
		$("#advimp").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	var rows = $("#advimp").datagrid('getChanges');
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
	} 
	
	$("#advimp").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc:'',Active:'Y',Hosp:LgHospID,HospID:LgHospID} //hxy 2019-07-01 LgHospID
	});
	$("#advimp").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#advimp").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelAdvImp',{"params":rows[0].ID}, function(data){
                    if(data==0){
						$.messager.alert('��ʾ','ɾ���ɹ�');	
					}else if(data==-1){
						$.messager.alert('��ʾ','�����ݴ���ʹ����Ϣ������ɾ��');	
					}else{
						$.messager.alert('��ʾ','ɾ��ʧ��');
					}

					$('#advimp').datagrid('reload'); //���¼���
					
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
		$("#advimp").datagrid('endEdit', editRow);
	}

	var rows = $("#advimp").datagrid('getChanges');
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
			fush();
		}
		if((rows[i].Hosp=="")||(rows[i].HospID=="")){
			$.messager.alert("��ʾ","Ժ������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+rows[i].Active+"^"+rows[i].Hosp+"^"+rows[i].HospID; //hxy 2019-07-01
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveAdvImp',{"params":rowstr},function(data){
		
		if ((data == -1)||((data == -2))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			//return;	//2017-03-17 ����ʧ�ܣ�ˢ���ֵ��	
		}
			$('#advimp').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'validatebox',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}
//YNת���Ƿ�
function formatLink(value,row,index){
	if (value=='Y'){
		return '��';
	} else {
		return '��';
	}
}
