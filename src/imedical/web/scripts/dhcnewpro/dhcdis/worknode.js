/** sufan 
  * 2018-04-09
  *
  * ���͸�λά��
 */
var editRow="" ;
///��ʼ����������
function initPageDefault(){
	
	initNodeList();		/// ��ʼ������datagrid
	initButton();  		/// ��ʼ���¼�
}
var dataArray=[{value:0,text:"��ͨ��λ"},{value:1,text:"�����λ"}]
/// ��ʼ������datagrid
function initNodeList()
{
	var Typeeditor={  //������Ϊ�ɱ༭
		type: 'combobox',//���ñ༭��ʽ
		options: {
			data:dataArray,
			valueField: "value", 
			textField: "text",
			panelHeight:"auto",  //���������߶��Զ�����
			editable:false, 
			onSelect:function(option){
				///��������ֵ
				var ed=$("#worknodelist").datagrid('getEditor',{index:editRow,field:'NodeType'});
				$(ed.target).combobox('setValue', option.text);  //�����Ƿ����
				var ed=$("#worknodelist").datagrid('getEditor',{index:editRow,field:'NodeTypeCode'});
				$(ed.target).val(option.value);  //�����Ƿ����
			} 
		}

	}
	
	/// �ı��༭��
	var textEditor={
		type: 'text',		 //���ñ༭��ʽ
		options: {
			required: true   //���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"NodeCode",title:'��λ����',width:220,align:'center',editor:textEditor},
		{field:"NodeDesc",title:'��λ����',width:220,align:'center',editor:textEditor},
		{field:"NodePerNum",title:'��λ�������',width:120,align:'center',editor:textEditor},
		{field:"NodeTypeCode",title:'NodeTypeCode',width:120,hidden:'true',editor:textEditor},
		{field:"NodeType",title:'��λ����',width:120,align:'center',editor:Typeeditor},
		{field:"NodeRowId",title:'ID',width:100,hidden:'true',align:'center'}
	]];
	///  ����datagrid  
	var option = {
		singleSelect : true,
	 	 onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#worknodelist").datagrid('endEdit', editRow); 
            } 
            $("#worknodelist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNode&MethodName=QueryDisNode";
	new ListComponent('worknodelist', columns, uniturl, option).Init(); 
}
/// ��ʼ���¼�
function initButton(){

	 ///  ���Ӹ�λ
	$('#insert').bind("click",insertRow);
	
	///  �����λ
	$('#save').bind("click",saveRow);
	
	///  ɾ����λ
	$('#delete').bind("click",deleteRow);
	
	///  ��ѯ
	$('#find').bind("click",findNodeist);
	
	//ͬʱ������������󶨻س��¼�
    $('#code,#desc').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            findNodeist(); //���ò�ѯ
        }
    });
    
     //���ð�ť�󶨵����¼�
    $('#reset').bind('click',function(event){
	    $('#code').val("");
	    $('#desc').val("");
        findNodeist(); //���ò�ѯ
    }); 
}

/// ���Ӹ�λ
function insertRow()
{
	if(editRow>="0"){
		$("#worknodelist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#worknodelist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {NodeRowId: '',NodeCode:'',NodeDesc: '',NodePerNum:'',NodeTypeCode:''}
	});
    
	$("#worknodelist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// �����λ
function saveRow()
{
	if(editRow>="0"){
		$("#worknodelist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#worknodelist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].NodeCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�д���Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].NodeDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"������Ϊ�գ�"); 
			return false;
		}
		if(rowsData[i].NodeTypeCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�и�λ����Ϊ�գ�"); 
			return false;
		}
		var tmp=rowsData[i].NodeRowId +"^"+ rowsData[i].NodeCode +"^"+ rowsData[i].NodeDesc +"^"+ rowsData[i].NodePerNum +"^"+ rowsData[i].NodeTypeCode;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//alert(params)
	//��������
	runClassMethod("web.DHCDISWorkNode","SaveDisNode",{"params":params},function(jsonString){
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#worknodelist').datagrid('reload'); //���¼���
	});
}

/// ɾ����λ
function deleteRow()
{
	var rowsData = $("#worknodelist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISWorkNode","DelDisNode",{"NodeRowId":rowsData.NodeRowId},function(data){
					$('#worknodelist').datagrid('reload'); //���¼���
				}) 
			}
		});
	}else{
		 $.messager.alert('��ʾ','��ѡ��Ҫɾ������','warning');
		 return;
	}
}

/// ��ѯ
function findNodeist()
{
	var code=$('#code').val();
	var desc=$('#desc').val();
	var params=code+"^"+desc;
	$('#worknodelist').datagrid('load',{params:params}); 
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })