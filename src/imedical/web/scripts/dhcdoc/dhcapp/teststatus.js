/** Descript  : ��������״̬��ά��
 *  Creator   : sufan
 *  CreatDate : 2017-07-06
 */
var editRow = ""; 
var ActiveArray = [{"value":"Y","text":'��'}, {"value":"N","text":'��'}];

/// ҳ���ʼ������
function initPageDefault(){
	
	initStatuslist();       /// ��ʼҳ��DataGrid����״̬��
	initButton();           /// ҳ��Button���¼�	
}

///����״̬�б� 
function initStatuslist(){
	
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
				var ed=$("#Statuslist").datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#Statuslist").datagrid('getEditor',{index:editRow,field:'HospDr'});
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
				var ed=$("#Statuslist").datagrid('getEditor',{index:editRow,field:'APSFlag'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#Statuslist").datagrid('getEditor',{index:editRow,field:'FlagCode'});
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
		{field:"APSCode",title:'״̬����',width:120,editor:textEditor},
		{field:"APSDesc",title:'״̬����',width:160,editor:textEditor},
		{field:"FlagCode",title:'FlagCode',width:80,hidden:'true',align:'center',editor:textEditor},
		{field:"APSFlag",title:'�Ƿ����',width:80,align:'center',editor:Flageditor},
		{field:"APSNotes",title:'״̬˵��',width:140,editor:textEditor},
		{field:"HospDesc",title:'ҽԺ',width:200,editor:Hospeditor},
		{field:"HospDr",title:'ҽԺID',width:60,hidden:'true',align:'center',editor:textEditor},
		{field:"APSRowID",title:'ID',width:20,hidden:'true',align:'center'}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
            if (editRow != ""||editRow === 0) { 
                $("#Statuslist").datagrid('endEdit', editRow); 
            } 
            $("#Statuslist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+'?ClassName=web.DHCAPPTestStatus&MethodName=QueryTestStatus&HospID='+LgHospID;
	new ListComponent('Statuslist', columns, uniturl, option).Init(); 
}

/// ҳ�� Button ���¼�
function initButton(){
	
	///  ��������״̬
	$('#insert').bind("click",insertStatusRow);
	
	///  ��������״̬
	$('#save').bind("click",saveStatusRow);
	
	///  ɾ������״̬
	$('#delete').bind("click",deleteStatusRow);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findStatuslist(); //���ò�ѯ
        }
    });
    
     // ���Ұ�ť�󶨵����¼�
    $('#find').bind('click',function(event){
         findStatuslist(); //���ò�ѯ
    });
    
    //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findStatuslist(); //���ò�ѯ
    }); 
}

/// ��������״̬
function insertStatusRow(){

	if(editRow>="0"){
		$("#Statuslist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#Statuslist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {APSRowID:'',APSCode:'',APSDesc:'',FlagCode:'Y',APSFlag:'Y',APSNotes:'',HospDr:LgHospID,HospDesc:LgHospID}
	});
    
	$("#Statuslist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}
///��������״̬
function saveStatusRow(){
	
	if(editRow>="0"){
		$("#Statuslist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#Statuslist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].APSCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].APSDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].HospDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"ҽԺΪΪ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].APSRowID +"^"+ rowsData[i].APSCode +"^"+ rowsData[i].APSDesc +"^"+ rowsData[i].HospDr +"^"+ rowsData[i].FlagCode +"^"+ rowsData[i].APSNotes;
		dataList.push(tmp);
	} 
	var params=dataList.join("$$");
	//��������
	runClassMethod("web.DHCAPPTestStatus","SaveTestStatus",{"params":params},function(jsonString){
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#Statuslist').datagrid('reload'); //���¼���
	});
}

/// ɾ��
function deleteStatusRow(){
	
	var rowsData = $("#Statuslist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPTestStatus","DeleteTestStatus",{"APSRowID":rowsData.APSRowID},function(jsonString){
					$('#Statuslist').datagrid('reload'); //���¼���
				})
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}
// ��ѯ
function findStatuslist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#Statuslist').datagrid('load',{params:params}); 
}	 
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
