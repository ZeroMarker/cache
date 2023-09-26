/** sufan 
  * 2018-04-09
  *
  * ��λ���͹���ά��
 */
var NodeDr =getParam("NodeDr");  ///��λID

var editRow="" ;
///��ʼ����������
function initPageDefault(){
	
	initTypeList();		/// ��ʼ������datagrid
	initButton();  		/// ��ʼ���¼�
}

/// ��ʼ������datagrid
function initTypeList()
{
	
	var Typeeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",
			//required:true,
			panelHeight:"auto",  //���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#typelist").datagrid('getEditor',{index:editRow,field:'TypeDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#typelist").datagrid('getEditor',{index:editRow,field:'TypeId'});
				$(ed.target).val(option.id); 
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
		{field:"NodeTypeId",title:'NodeTypeId',width:100,hidden:true,editor:textEditor},
		{field:"TypeId",title:'TypeId',width:100,hidden:true,editor:textEditor},
		{field:"TypeDesc",title:'��������',width:220,align:'center',editor:Typeeditor},
		{field:"NodeId",title:'NodeId',width:220,hidden:true,editor:textEditor},
	]];
	///  ����datagrid  
	var option = {
		singleSelect : true,
	 	 onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#typelist").datagrid('endEdit', editRow); 
            } 
            $("#typelist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkLinkType&MethodName=QueryWorkLinkType&NodeId="+NodeDr;
	new ListComponent('typelist', columns, uniturl, option).Init(); 
}
/// ��ʼ���¼�
function initButton(){

	 ///  ���Ӹ�λ
	$('#insert').bind("click",insertRow);
	
	///  �����λ
	$('#save').bind("click",saveRow);
	
	///  ɾ����λ
	$('#delete').bind("click",deleteRow);
}

/// ���Ӹ�λ
function insertRow()
{
	if(NodeDr=="")
	{
		$.messager.alert("��ʾ","����ѡ���λ�б�!");
		return;
	}
	if(editRow>="0"){
		$("#typelist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#typelist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {NodeTypeId: '',TypeId:'',TypeDesc:'',NodeId: ''}
	});
    
	$("#typelist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// �����λ
function saveRow()
{
	if(editRow>="0"){
		$("#typelist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#typelist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].TypeDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�и�λ����Ϊ�գ�"); 
			return false;
		}
		var tmp=NodeDr +"^"+ rowsData[i].NodeTypeId +"^"+ rowsData[i].TypeId +"^"+ rowsData[i].TypeDesc +"^"+ rowsData[i].NodeId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISWorkLinkType","SaveNodeLinkType",{"params":params},function(jsonString){
		if(jsonString=="0")
		{
			$('#typelist').datagrid('reload'); //���¼���
		}
		
	});
}

/// ɾ����λ
function deleteRow()
{
	var rowsData = $("#typelist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISWorkLinkType","DelNodeLinkType",{"NodeTypeId":rowsData.NodeTypeId},function(data){
					$('#typelist').datagrid('reload'); //���¼���
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