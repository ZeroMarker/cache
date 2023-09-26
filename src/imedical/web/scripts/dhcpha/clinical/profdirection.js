/// Creator:    bianshuai
/// CreateDate: 2016-03-04
//  Descript:   רҵ����ά��

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
$(function(){
	
	$("#insert").bind("click",insertRow);
	$("#delete").bind("click",deleteRow);
	$("#save").bind("click",saveRow);
	
	InitProDirecList();    //��ʼ��רҵ�����б�
	
})
//��ʼ��רҵ�����б�
function InitProDirecList()
{


	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,align:'center'},
		{field:"Code",title:'����',width:160,editor:texteditor},
		{field:'Desc',title:'����',width:300,editor:texteditor}
	]];

	/**
	 * ����datagrid
	 */
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#prodirList").datagrid('endEdit', editRow); 
            } 
            $("#prodirList").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	};

	var prodirListComponent = new ListComponent('prodirList', columns, '', option);
	prodirListComponent.Init();
	
    queryProDirDetail();
	initScroll("#prodirList");//��ʼ����ʾ���������

	
}
 /**
  * ��ѯ��ѯ����
  */
function queryProDirDetail(){
	
	//1�����datagrid 
	$('#prodirList').datagrid('loadData', {total:0,rows:[]});
		
	$('#prodirList').datagrid({
		url:url + "?action=QueryProDirect",	
		queryParams:{
			params:""}
	});
}

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#prodirList").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#prodirList").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ID: '',Code:'',Desc: ''}
	});
	$("#prodirList").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#prodirList").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=delProDirect',{"proDirectID":rows[0].ID}, function(data){
					$('#prodirList').datagrid('reload'); //���¼���
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
		$("#prodirList").datagrid('endEdit', editRow);
	}

	var rows = $("#prodirList").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].Code=="")||(rows[i].Desc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			$('#prodirList').datagrid('reload'); 
			return false;
		}
		//QueryProDirect   2018-7-25 hzg
		//���淽����ȡ������  
		var datas="";
		$.ajax({
		url:url+"?action=QueryProDirect",
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
		var favdata = eval("("+datas+")");
		var allRows=favdata.rows;
		for(var j=0;j<allRows.length;j++){
					if((rows[i].Code==allRows[j].Code)){
							$.messager.alert("��ʾ","ģ���Ѵ��ڣ�������ά��!");
							$('#prodirList').datagrid('reload');
							return true;
				}			
					}
		var tmp=rows[i].ID+"^"+rows[i].Code+"^"+rows[i].Desc;
		
		dataList.push(tmp);	
		
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=saveProDirect',{"params":rowstr},function(data){
		$.messager.alert("��ʾ","����ɹ�!"); //**�޸����ӱ���ɹ���ʾ
		$('#prodirList').datagrid('reload'); //���¼���
	});
}



var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}