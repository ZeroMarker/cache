/// Descript: ���ҽ��ά��
/// Creator : sufan
/// Date    : 2017-02-07
var cat =getParam("cat");  ///ҽ����ID 
var editRow = ""; editTRow = "";
/// ҳ���ʼ������
function initPageDefault(){
	initprintlist();       	/// ��ʼҳ��DataGrid��ӡģ��
	initButton();          ///  ҳ��Button���¼�	
}
///������ 
function initprintlist(){
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"APTTemp",title:'��ӡģ��',width:300,align:'center',editor:textEditor},
		{field:"CatDr",title:'CatDr',width:170,align:'center',hidden:'true',editor:textEditor},
		{field:"APTRowId",title:'ID',width:150,align:'center',hidden:'true',editor:textEditor}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != "") { 
                $("#printlist").datagrid('endEdit', editRow); 
            } 
            $("#printlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPOtherOpt&MethodName=QueryPrintTemp&ItmID="+cat;
	new ListComponent('printlist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ���Ӵ�ӡģ��
	$('#insert').bind("click",insertRow);
	
	///  �����ӡģ��
	$('#save').bind("click",saveRow);
	
	///  ɾ����ӡģ��
	$('#delete').bind("click",deleteRow);
}

/// ��������Ŀ��λ��
function insertRow(){
	if (cat=="")
	{
		$.messager.alert("��ʾ","����ѡ�����!");
		return false;
		}
	if(editRow>="0"){
		$("#printlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#printlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {APTRowId: '',APTTemp:'',CatDr: ''}
	});
    
	$("#printlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������Ŀ��λ
function saveRow(){
	
	if(editRow>="0"){
		$("#printlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#printlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if (rowsData[i].APTTemp=="")
		{
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"��ģ������Ϊ�գ�");
			return false;
			}
		var tmp=rowsData[i].APTRowId +"^"+ cat +"^"+ rowsData[i].APTTemp ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPOtherOpt","SavePrint",{"params":params},function(jsonString){
		
		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���');
		}
		if (jsonString=="-12")
		{
			$.messager.alert('��ʾ','�÷����ѹ�����ģ�壡');
			}
		$('#printlist').datagrid('reload'); //���¼���
		
	});
}

/// ɾ��
function deleteRow(){
	
	var rowsData = $("#printlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPOtherOpt","DeletePrtTemp",{"APTRowID":rowsData.APTRowId},function(jsonString){
					$('#printlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
