/// Creator: bianshuai
/// CreateDate: 2014-11-11
//  Descript: ��ҩ�����ֵ��ά��

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[˫���м��ɱ༭]</span>';
$(function(){
	
	// ����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'����',width:160,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];
	
	// ����datagrid
	$('#drgsugdicdg').datagrid({
		title:'��ҩ�����ֵ��ά��'+titleNotes,
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
                $("#drgsugdicdg").datagrid('endEdit', editRow); 
            } 
            $("#drgsugdicdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#drgsugdicdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            find(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         find(); //���ò�ѯ
    });
    
    $('#drgsugdicdg').datagrid({
		url:url+'?action=QueryDrgSugDic',	
		queryParams:{
			params:''}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#drgsugdicdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#drgsugdicdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#drgsugdicdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#drgsugdicdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelDrgSugDic',{"params":rows[0].ID}, function(data){
					$('#drgsugdicdg').datagrid('reload'); //���¼���
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
		$("#drgsugdicdg").datagrid('endEdit', editRow);
	}

	var rows = $("#drgsugdicdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#drgsugdicdg').datagrid('reload');
			return false;
		}
		//���淽����ȡ������   hzg 2018-7-25
		var datas="";
		$.ajax({
		url:url+"?action=QueryDrgSugDic",
		//ҳ��1��������datagrid����������������������Ҫ��ȡ�ж����datagrid��һ����
		data: {
			page: "1",rows: '100'
			},
		type: "POST",
		async: false,//true,
		//dataType: "json",
		success: function (data,rows) {
			//getallRows(datas,rows[i])
			if(data){
				datas=data;
				}
			 }

		});		
		//getallRows(datas,rows[i]);
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
			if((rows[i].Code==allRows[j].Code)&&(rows[i].Desc==allRows[j].Desc)){
				$.messager.alert("��ʾ","ģ���Ѵ��ڣ�������ά��!");
							$('#drgsugdicdg').datagrid('reload');
							return true;
				}
					}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveDrgSugDic',{"params":rowstr},function(data){
		$.messager.alert("��ʾ","����ɹ�!"); //**�޸����ӱ���ɹ���ʾ
		$('#drgsugdicdg').datagrid('reload'); //���¼���
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
function find()
{
	var adrStatusCode=$('#code').val();
	var adrStatusDesc=$('#desc').val();
	var params=adrStatusCode+"^"+adrStatusDesc;
	$('#drgsugdicdg').datagrid('load',{params:params}); 
}