/** Descript  : ����ȡ����Ϣά��
 *  Creator   : sufan
 *  CreatDate : 2017-07-06
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];

/// ҳ���ʼ������
function initPageDefault(){
	initcutbaslist();       	/// ��ʼҳ��DataGrid����״̬��
	initButton();           /// ҳ��Button���¼�	
}

///����״̬�б� 
function initcutbaslist(){
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
				var ed=$("#cutbaslist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#cutbaslist").datagrid('getEditor',{index:editRow,field:'HospDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �Ƿ����
	var Flageditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:ActiveArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#cutbaslist").datagrid('getEditor',{index:editRow,field:'ACFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#cutbaslist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
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
		{field:"ACCode",title:'����',width:200,editor:textEditor},
		{field:"ACDesc",title:'����',width:200,editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"ACFlag",title:'�Ƿ����',width:80,align:'center',editor:Flageditor},
		{field:"HospDesc",title:'ҽԺ',width:200,align:'center',editor:Hospeditor},
		{field:"HospDr",title:'ҽԺID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"ACRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow === 0){ 
                $("#cutbaslist").datagrid('endEdit', editRow); 
            } 
            $("#cutbaslist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPCutBas&MethodName=QueryCutBas&HospID='+LgHospID;
	new ListComponent('cutbaslist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ��������״̬
	$('#insert').bind("click",insertCbRow);
	
	///  ��������״̬
	$('#save').bind("click",saveCbRow);
	
	///  ɾ������״̬
	$('#delete').bind("click",deleteCbRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findCblist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findCblist(); //���ò�ѯ
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findCblist(); //���ò�ѯ
    }); 
}

/// ��������״̬
function insertCbRow(){

	if(editRow>="0"){
		$("#cutbaslist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#cutbaslist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ACRowID:'',ACCode:'',ACDesc:'',FlagCode:'Y',ACFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#cutbaslist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������״̬
function saveCbRow(){
	
	if(editRow>="0"){
		$("#cutbaslist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#cutbaslist").datagrid('getChanges');
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
		var tmp=rowsData[i].ACRowID +"^"+ rowsData[i].ACCode +"^"+ rowsData[i].ACDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPCutBas","SaveCutBas",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#cutbaslist').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function deleteCbRow(){
	
	var rowsData = $("#cutbaslist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPCutBas","DeleteCutBas",{"ACRowID":rowsData.ACRowID},function(jsonString){
					$('#cutbaslist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findCblist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#cutbaslist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
