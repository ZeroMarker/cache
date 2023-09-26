/** Descript  : �������Ʒ���ά��
 *  Creator   : sufan
 *  CreatDate : 2018-01-04
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];

/// ҳ���ʼ������
function initPageDefault(){
	initDiaglist();       	/// ��ʼҳ��DataGrid����״̬��
	initButton();           /// ҳ��Button���¼�	
}

///����״̬�б� 
function initDiaglist(){
	// ҽԺ
	var Hospeditor={		//������Ϊ�ɱ༭
		type: 'combobox',	//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#tesdiaglist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#tesdiaglist").datagrid('getEditor',{index:editRow,field:'HospDr'});
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
				var ed=$("#tesdiaglist").datagrid('getEditor',{index:editRow,field:'ATFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#tesdiaglist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
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
		{field:"ATCode",title:'����',width:200,editor:textEditor},
		{field:"ATDesc",title:'����',width:200,editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"ATFlag",title:'�Ƿ����',width:80,align:'center',editor:Flageditor},
		{field:"HospDesc",title:'ҽԺ',width:200,editor:Hospeditor},
		{field:"HospDr",title:'ҽԺID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"ATRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow === 0){ 
                $("#tesdiaglist").datagrid('endEdit', editRow); 
            } 
            $("#tesdiaglist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTesDiag&MethodName=QueryTesDiag&HospID='+LgHospID;
	new ListComponent('tesdiaglist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ��������״̬
	$('#insert').bind("click",insertMetRow);
	
	///  ��������״̬
	$('#save').bind("click",saveMetRow);
	
	///  ɾ������״̬
	$('#delete').bind("click",deleteMetRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMetlist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findMetlist(); //���ò�ѯ
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findMetlist(); //���ò�ѯ
    }); 
}

/// ��������״̬
function insertMetRow(){

	if(editRow>="0"){
		$("#tesdiaglist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#tesdiaglist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {ATRowID:'',ATCode:'',ATDesc:'',FlagCode:'Y',ATFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#tesdiaglist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������״̬
function saveMetRow(){
	
	if(editRow>="0"){
		$("#tesdiaglist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#tesdiaglist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].ATCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].ATDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"ҽԺΪ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].ATRowID +"^"+ rowsData[i].ATCode +"^"+ rowsData[i].ATDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPTesDiag","SaveTesDiag",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#tesdiaglist').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function deleteMetRow(){
	
	var rowsData = $("#tesdiaglist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTesDiag","DeleteTesDiag",{"ATRowID":rowsData.ATRowID},function(jsonString){
					$('#tesdiaglist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findMetlist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#tesdiaglist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
