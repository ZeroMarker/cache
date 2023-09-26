/** Descript  : �����Ŀ����ά��
 *  Creator   : sufan
 *  CreatDate : 2017-07-06
 */
var editRow = ""; 

/// ҳ���ʼ������
function initPageDefault(){
	
	initCatlist();       	/// ��ʼҳ��DataGrid����״̬��
	initButton();           /// ҳ��Button���¼�	
}

///��������Ŀ�����б� 
function initCatlist(){
	
	// ҽԺ
	var Hospeditor={		//������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#TestCatlist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#TestCatlist").datagrid('getEditor',{index:editRow,field:'HospDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �ı��༭��
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"ACCode",title:'�������',width:160,align:'center',editor:textEditor},
		{field:"ACDesc",title:'��������',width:160,align:'center',editor:textEditor},
		{field:"HospDesc",title:'ҽԺ',width:220,align:'center',editor:Hospeditor},
		{field:"HospDr",title:'ҽԺID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"ACRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow == 0){ 
                $("#TestCatlist").datagrid('endEdit', editRow); 
            } 
            $("#TestCatlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestCat&MethodName=QueryTestCat&HospID='+LgHospID;
	new ListComponent('TestCatlist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ���Ӽ����Ŀ����
	$('#insert').bind("click",insertCatRow);
	
	///  ��������Ŀ����
	$('#save').bind("click",saveCatRow);
	
	///  ɾ�������Ŀ����
	$('#delete').bind("click",deleteCatRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findCatlist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findCatlist(); //���ò�ѯ
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findCatlist(); //���ò�ѯ
    }); 
}

/// ��������Ŀ����
function insertCatRow(){

	if(editRow>="0"){
		$("#TestCatlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#TestCatlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ACRowID:'',ACCode:'',ACDesc:'',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#TestCatlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������Ŀ����
function saveCatRow(){
	
	if(editRow>="0"){
		$("#TestCatlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#TestCatlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].ACCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].ACDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"ҽԺΪ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].ACRowID +"^"+ rowsData[i].ACCode +"^"+ rowsData[i].ACDesc +"^"+ rowsData[i].HospDr ;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPTestCat","SaveTestCat",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#TestCatlist').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function deleteCatRow(){
	
	var rowsData = $("#TestCatlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTestCat","DeleteTestCat",{"ACRowID":rowsData.ACRowID},function(jsonString){
					$('#TestCatlist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findCatlist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#TestCatlist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
