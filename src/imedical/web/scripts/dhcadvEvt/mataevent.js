/// Creator: congyue
/// CreateDate: 2015-10-21
//  Descript: �����Ŀά��

var editRow="";  //��ǰ�༭�к�
var url="dhcadv.repaction.csp";
//dhcadv.mataevent.csp
var Flag = [{"value":"Y","text":'Y'}, {"value":"N","text":'N'}];
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫���м��ɱ༭]</span>';
$(function(){
	
	//��־
	var flagEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:Flag,
			valueField: "value", 
			textField: "text",
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				
				var ed=$("#mataeventdg").datagrid('getEditor',{index:editRow,field:'ItemActiveFlag'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	//��λ
	var uomEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selUom',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#mataeventdg").datagrid('getEditor',{index:editRow,field:'ItemUom'});
				$(ed.target).combobox('setValue', option.text);  
			} 
		}
	}
	//���
	var typeEditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:url+'?action=selType',
			required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#mataeventdg").datagrid('getEditor',{index:editRow,field:'Type'});
				$(ed.target).combobox('setValue', option.text); 
			} 
		}
	}
	// ����columns
	var columns=[[
		{field:"MataID",title:'ID',width:95,align:'center'},
		{field:"ItemCode",title:'����',width:200,editor:texteditor,align:'center'},
		{field:'ItemDesc',title:'����',width:200,editor:texteditor,align:'center'},
		{field:'ItemVal',title:'��������',width:200,editor:texteditor,align:'center'},
		{field:'ItemUom',title:'��λ',width:200,editor:uomEditor,align:'center'},
		{field:'ItemActiveFlag',title:'���ñ�־',width:200,editor:flagEditor,align:'center'},
		{field:'Type',title:'���',width:200,editor:typeEditor,align:'center'}
	]];
	
	// ����datagrid
	$('#mataeventdg').datagrid({
		title:'�����Ŀ����'+titleNotes,
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
            	$("#mataeventdg").datagrid('endEdit', editRow); 
			}
            $("#mataeventdg").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex; 
        }
	});
	
	initScroll("#mataeventdg");//��ʼ����ʾ���������
 
 	//��ť���¼�
    $('#insert').bind('click',insertRow); 
    $('#delete').bind('click',deleteRow);
    $('#save').bind('click',saveRow);
    
    //ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            queryMataEvent(); //���ò�ѯ
        }
    });
    
    // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         queryMataEvent(); //���ò�ѯ
    });
    
    $('#mataeventdg').datagrid({
		url:url+'?action=QueryMataEvent',	
		queryParams:{
			params:""}
	});
})

// ��������
function insertRow()
{
	if(editRow>="0"){
		$("#mataeventdg").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	$("#mataeventdg").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {MataID:'',ItemCode:'',ItemDesc:'',ItemVal:'',ItemUom:'',ItemActiveFlag:'',Type:''}
	});
	$("#mataeventdg").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

// ɾ��ѡ����
function deleteRow()
{
	var rows = $("#mataeventdg").datagrid('getSelections'); //ѡ��Ҫɾ������
	if (rows.length > 0) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				$.post(url+'?action=DelMaEvent',{"params":rows[0].MataID}, function(data){

					$('#mataeventdg').datagrid('reload'); //���¼���
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
		$("#mataeventdg").datagrid('endEdit', editRow);
	}
	var rows = $("#mataeventdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].ItemCode=="")||(rows[i].ItemDesc=="")){
			$.messager.alert("��ʾ","�������������Ϊ��!"); 
			return false;
		}
		var tmp=rows[i].MataID+"^"+rows[i].ItemCode+"^"+rows[i].ItemDesc+"^"+rows[i].ItemVal+"^"+rows[i].ItemUom+"^"+rows[i].ItemActiveFlag+"^"+rows[i].Type;
		dataList.push(tmp);
	} 
	var rowstr=dataList.join("||");

	//��������
	$.post(url+'?action=SaveMaEvent',{"params":rowstr},function(data){
		$('#mataeventdg').datagrid('reload'); //���¼���
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
function queryMataEvent()
{
	var maItemCode=$('#code').val();
	var maItemDesc=$('#desc').val();
	var params=maItemCode+"^"+maItemDesc;
	$('#mataeventdg').datagrid('load',{params:params}); 
}