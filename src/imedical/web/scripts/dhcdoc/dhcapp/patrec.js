/** Descript  : �����˲���ά��
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
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'HospDr'});
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
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'APFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#patreclist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
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
		{field:"APCode",title:'����',width:200,editor:textEditor},
		{field:"APDesc",title:'����',width:200,editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"APFlag",title:'�Ƿ����',width:80,align:'center',editor:Flageditor},
		{field:"HospDesc",title:'ҽԺ',width:200,editor:Hospeditor},
		{field:"HospDr",title:'ҽԺID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"APRowID",title:'ID',width:20,align:'center',hidden:'true'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow === 0){ 
                $("#patreclist").datagrid('endEdit', editRow); 
            } 
            $("#patreclist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPPatRec&MethodName=QueryPatRec&HospID='+LgHospID;
	new ListComponent('patreclist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ��������״̬
	$('#insert').bind("click",insertRecRow);
	
	///  ��������״̬
	$('#save').bind("click",saveRecRow);
	
	///  ɾ������״̬
	$('#delete').bind("click",deleteRecRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findMetlist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findReclist(); //���ò�ѯ
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findReclist(); //���ò�ѯ
    }); 
}

/// ��������״̬
function insertRecRow(){

	if(editRow>="0"){
		$("#patreclist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#patreclist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {APRowID:'',APCode:'',APDesc:'',FlagCode:'Y',APFlag:'Y',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#patreclist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������״̬
function saveRecRow(){
	
	if(editRow>="0"){
		$("#patreclist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#patreclist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].APCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].APDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"ҽԺΪ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].APRowID +"^"+ rowsData[i].APCode +"^"+ rowsData[i].APDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPPatRec","SavePatRec",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#patreclist').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function deleteRecRow(){
	
	var rowsData = $("#patreclist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPPatRec","DeletePatRec",{"APRowID":rowsData.APRowID},function(jsonString){
					$('#patreclist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findReclist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#patreclist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
