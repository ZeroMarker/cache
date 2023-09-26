/// Creator: lbb
/// CreateDate:2020-02-24
/// Descript:��ѯ���ά��JS

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp"
var dataArray = [{ "value": "Y", "text": "��" }, { "value": "N", "text": "��" }]
$(function()
{
	$("#dg").datagrid({
		idField:"rowid",
		url: url+"?action=GetPhConIdenInfo",  
		rownumbers:true,
		striped: true,
		pageList : [15, 30, 45],   // ��������ÿҳ��¼�������б�
		pageSize : 15 ,  // ÿҳ��ʾ�ļ�¼����
		//fitColumns:true,
		//sortName: "rowid", //��ʼ�����ʱ���ݵ����� �ֶ� ��������ݿ��е��ֶ�������ͬ
		//sortOrder: "asc",
		singleSelect:true,
		fit: true,
		loadMsg: '���ڼ�����Ϣ...',
		columns: [[
		{	
			field:"rowid",
			title:"ID",
			width:50
			//hidden:true
		},{	
			field:"PhContCode",
			title:"����",
			width:200,
			editor:'text'
		},
		{
			field:"PhContDesc",
			title:"����",
			width:300,
			editor:'text'
		}]],
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")) { 
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        },
	    pagination: true

	})  
	
	//���÷�ҳ�ؼ�   
	$('#dg').datagrid('getPager').pagination({
		showPageList:false,
		beforePageText: '��',//ҳ���ı���ǰ��ʾ�ĺ��� 
		afterPageText: 'ҳ    �� {pages} ҳ',   
		displayMsg: '��ǰ��ʾ {from} - {to} ����¼   �� {total} ����¼'
	});
})

// ��ʽ��
function unitformatter(value, rowData, rowIndex){
    for (var i = 0; i < dataArray.length; i++){ 
        if (dataArray[i].value == value){ 
			if(value=="Y"){color="green";
			}else{
				color="red";}
			return '<span style="font-weight:bold;color:'+color+'">'+dataArray[i].text+'</span>';
        } 
    } 
}

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#dg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#dg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {rowid: '',PhContCode:'',PhContDesc: ''}
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
				$.post(url+'?action=DeletePhConIden',{"index":rows[0].rowid}, function(data){
					//��ȡdatagrid����   hezhigang  2018-7-20
					var rowsNew=$('#dg').datagrid('getRows').length;
					//rows<2��ʾ��ǰβҳȫ��ɾ���꣬�������ؼ�����ҳ
					if(rowsNew<2){
						$('#dg').datagrid('load');
					}else{
						$('#dg').datagrid('reload');
					}
					//$('#dg').datagrid('reload'); //���¼���
                    //rows.length=0;   //***�����ӵĴ���
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
		if((rows[i].PhContCode=="")||(rows[i].PhContDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			//$('#dg').datagrid('reload');
			return false;
		}
		//GetPhConBasInfo
		//���淽����ȡ������   hzg 2018-7-23
		var datas="";
		$.ajax({
			url:url+"?action=GetPhConIdenInfo",
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
			if((rows[i].PhContCode==allRows[j].PhContCode)&&(rows[i].PhContDesc==allRows[j].PhContDesc)){
				$.messager.alert("��ʾ","ģ���Ѵ��ڣ�������ά��!");
							//$('#dg').datagrid('reload');
							return true;
				}
				
					}

		var tmp=rows[i].rowid+"^"+rows[i].PhContCode+"^"+rows[i].PhContDesc;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");
	
	//��������
	$.post(url+'?action=UpdatePhConIden',{"dataList":rowstr},function(data){
		$.messager.alert("��ʾ","����ɹ�!"); //**�޸����ӱ���ɹ���ʾ
		$('#dg').datagrid('reload'); //���¼���
	});
}


// �޸�ѡ����
function modifyRow()
{
	var rows = $("#dg").datagrid('getSelections'); //ѡ��һ�н��б༭
	//ѡ��һ�еĻ������¼�
	if (rows.length == 1)
	{
		if(editRow!=""){
			$("#dg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
		}
		var index = $("#dg").datagrid('getRowIndex', rows[0]);//��ȡѡ���е�����
		$("#dg").datagrid('beginEdit',index);
		editRow=index;  //��¼��ǰ�༭��
	}else{
		$.messager.alert("��ʾ","��ѡ����༭��!");
	}
}


  
