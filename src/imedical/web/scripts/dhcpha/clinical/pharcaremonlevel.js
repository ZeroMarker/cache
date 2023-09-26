/// Creator: bianshuai
/// CreateDate: 2015-04-23
//  Descript: ҩѧ�໤����ά��

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
$(function(){
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'����',width:160, editor:texteditor},
		{field:'Desc',title:'����',width:200, editor:texteditor},
		{field:'Color',title:'��ɫ',width:50, editor:'color', 
			styler:function(value,row,index){
				return 'color:'+ value +';background-color:'+ value +';';
			}
		}
	]];
	
	//����datagrid
	$('#dg').datagrid({
		//title:'�໤����ά��',
		url:url+'?action=QueryMonLevel',  // qunianpeng 2016-08-01
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
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
        onLoadSuccess:function(data){
	        
	    }
	});
	
	initScroll("#dg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
 /*    $('#delete').bind('click',deleteRow); */
    $('#save').bind('click',saveRow);

    $('#dg').datagrid({
		url:url+'?action=QueryMonLevel',	
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
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#dg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	/*$.messager.alert('��ʾ','<font style="color:red;">�������ɾ������,����ϵ��Ϣ�ƣ�лл��</font>','warning');
	return;*/
	
	var rows = $("#dg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelMonLevel',{"params":rows[0].ID}, function(data){
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
			$('#dg').datagrid('reload');
			return false;
		}
		var datas="";
		$.ajax({
			url:url+"?action=QueryMonLevel",
			//ҳ��1��������datagrid����������������������Ҫ��ȡ�ж����datagrid��һ����
			data: {
				page: "1",rows: '100'
			},
			type: "POST",
			async: false,//true,
			//dataType: "json",
			success: function (data,rows) {
				if(data){
					datas=data;
				}
			 }

		});		
		//getallRows(datas,rows[i]);
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
			if((rows[i].Code==allRows[j].Code)&&(rows[i].ID!=allRows[j].ID)){
				$.messager.alert("��ʾ","�����Ѵ��ڣ�������ά��!");
				$('#dg').datagrid('reload');
				return true;
			}
			if((rows[i].Desc==allRows[j].Desc)&&(rows[i].ID!=allRows[j].ID)){
				$.messager.alert("��ʾ","�����Ѵ��ڣ�������ά��!");
				$('#dg').datagrid('reload');
				return true;
			}
		}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc+"^"+(rows[i].Color||"");
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveMonLevel',{"params":rowstr},function(data){
		$.messager.alert("��ʾ","����ɹ�!"); //**�޸����ӱ���ɹ���ʾ
		$('#dg').datagrid('reload'); //���¼���
	});
}


var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

