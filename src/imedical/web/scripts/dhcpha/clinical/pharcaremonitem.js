/// Creator: bianshuai
/// CreateDate: 2015-04-23
//  Descript: ҩѧ�໤��Ŀά��

var editRow="";  //��ǰ�༭�к�
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;color:red;">[˫���м��ɱ༭]</span>';
$(function(){
	
	// ����columns
	var columns=[[
		{field:"monItmID",title:'monItmID',width:70,align:'center'},
		{field:"monItmCode",title:'����',width:100,editor:texteditor},
		{field:'monItmDesc',title:'����',width:200,editor:texteditor},
		{field:'monLevID',title:'MonLevID',width:70,editor:texteditor,hidden:true},
		{field:'monLevel',title:'����',width:100,editor:monLevelEditor},
		{field:'monSubClassID',title:'monSubClassID',width:70,editor:texteditor,hidden:true},
		{field:'monSubClass',title:'ѧ�Ʒ���',width:200,editor:monSubClassEditor}
	]];
	
	// ����datagrid
	$('#dg').datagrid({
		//title:'�໤��Ŀ'+titleNotes,
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
                $("#dg").datagrid('endEdit', editRow); 
            } 
            $("#dg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#dg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('a:contains("����")').bind('click',insertRow); 
   /*  $('a:contains("ɾ��")').bind('click',deleteRow); */
    $('a:contains("����")').bind('click',saveRow);
    $('a:contains("��ѯ")').bind('click',queryMonItem);
    
    //�໤����
	$('#MonLevel').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		onShowPanel:function(){
			$('#MonLevel').combobox('reload',url+'?action=SelMonLevel')
		}
	});
	
	//ѧ�Ʒ���
	$('#monSubClass').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		onShowPanel:function(){
			$('#monSubClass').combobox('reload',url+'?action=SelMonSubClass')
		}
	});
	    
    $('#dg').datagrid({
		url:url+'?action=QueryMonItem',	
		queryParams:{ monSubClassId:"", monLevId:""}
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
		row: {monItmID: '',monItmCode:'',monItmDesc: '',monLevID:'',monLevel: '',monSubClassID:'',monSubClass: ''}
	});
	$("#dg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	/* $.messager.alert('��ʾ','<font style="color:red;font-weight:bold;">�������ɾ������,����ϵ��Ϣ�ƣ�лл��</font>','warning');
	return; */

	var rows = $("#dg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelMonItem',{"params":rows[0].monItmID}, function(data){
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
	for(var i=0;i<rows.length;i++){
		if((rows[i].monItmDesc=="")||(rows[i].monLevID=="")||(rows[i].monSubClassID=="")||(rows[i].monItmCode=="")||(rows[i].monLevel==undefined)||(rows[i].monSubClass==0)){
			$.messager.alert("��ʾ","<font style='color:red;font-weight:bold;'>����/����/����/ѧ�Ʒ���</font>��һ�����Ϊ�ա����ʵ��,����!"); 
			//$('#dg').datagrid('reload');
			return false;
		}
		//���淽����ȡ������   hzg 2018-7-25
		var datas="";
		$.ajax({
		url:url+"?action=QueryMonItem",
		//ҳ��1��������datagrid����������������������Ҫ��ȡ�ж����datagrid��һ����
		data: {
			page: "1",rows: '9999'
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
					if((rows[i].monItmCode==allRows[j].monItmCode)&&(rows[i].monItmDesc==allRows[j].monItmDesc)&&(rows[i].monLevID==allRows[j].monLevID)&&(rows[i].monSubClassID==allRows[j].monSubClassID)){
							$.messager.alert("��ʾ","ģ���Ѵ��ڣ�������ά��!");
							$('#dg').datagrid('reload');
							return true;
						}
					}
		var tmp=rows[i].monItmID+"^"+rows[i].monItmCode+"^"+rows[i].monItmDesc+"^"+rows[i].monLevID+"^"+rows[i].monSubClassID;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveMonItm',{"params":rowstr},function(data){
		$('#dg').datagrid('reload'); //���¼���
	});
}

// �༭��
var texteditor={
	type: 'text',//���ñ༭��ʽ
	options: {
		required: true //���ñ༭��������
	}
}

//������Ϊ�ɱ༭
var monLevelEditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//required: true,//���ñ༭��������
		panelHeight:"auto",  //���������߶��Զ�����
		valueField: "value", 
		textField: "text",
		url: url+'?action=SelMonLevel',
		onSelect:function(option){
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monLevID'});
			$(ed.target).val(option.value);  //���ÿ���ID
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monLevel'});
			$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
		}
	}
}

//������Ϊ�ɱ༭
var monSubClassEditor={
	type: 'combobox',//���ñ༭��ʽ
	options: {
		//required: true,//���ñ༭��������
		panelHeight:"auto",  //���������߶��Զ�����
		valueField: "value", 
		textField: "text",
		url: url+'?action=SelMonSubClass',
		onSelect:function(option){
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monSubClassID'});
			$(ed.target).val(option.value);  //���ÿ���ID
			var ed=$("#dg").datagrid('getEditor',{index:editRow,field:'monSubClass'});
			$(ed.target).combobox('setValue', option.text);  //���ÿ���Desc
		}
	}
}

// ��ѯ
function queryMonItem()
{
	var monSubClassId=$('#monSubClass').combobox('getValue');   //ѧ�Ʒ���ID
	var monLevId=$('#MonLevel').combobox('getValue'); //�໤����ID
     if($('#monSubClass').combobox('getText')=="") //wangxuejian 2016-09-22  ɾ���Ժ�monSubClassId���ܻ᷵��0���ж�monSubClassID������Ϊ��
	{
		monSubClassId=""
	}
	if( $('#MonLevel').combobox('getText')=="")
	{
		 monLevId=""
	}
	$('#dg').datagrid('load',{ monSubClassId:monSubClassId, monLevId:monLevId}); 
}