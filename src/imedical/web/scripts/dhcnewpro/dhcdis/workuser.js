/** sufan 
  * 2018-04-09
  *
  * ��λ��Ա����ά��
 */
var NodeDr =getParam("NodeDr");  ///��λID
var editRow="" ;
///��ʼ����������
function initPageDefault(){
	
	initUserList();		/// ��ʼ������datagrid
	initButton();  		/// ��ʼ���¼�
}

/// ��ʼ������datagrid
function initUserList()
{
	
	var Usereditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser",
			//required:true,
			panelHeight:"400",  //���������߶��Զ�����
			mode:'remote',
			onSelect:function(option){
				///��������ֵ
				var ed=$("#userlist").datagrid('getEditor',{index:editRow,field:'UserDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#userlist").datagrid('getEditor',{index:editRow,field:'UserId'});
				$(ed.target).val(option.value); 
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
		{field:"NodeUserId",title:'NodeUserId',width:100,hidden:true,editor:textEditor},
		{field:"UserId",title:'UserId',width:100,hidden:true,editor:textEditor},
		{field:"UserDesc",title:'��Ա����',width:220,align:'center',editor:Usereditor},
		{field:"NodeId",title:'NodeId',width:220,hidden:true,editor:textEditor},
	]];
	///  ����datagrid  
	var option = {
		singleSelect : true,
	 	onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#userlist").datagrid('endEdit', editRow); 
            } 
            $("#userlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNodeLinkUser&MethodName=QueryWorkLinkUser&NodeId="+NodeDr;
	new ListComponent('userlist', columns, uniturl, option).Init(); 
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
		$("#userlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#userlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {NodeUserId: '',UserId:'',UserDesc:'',NodeId: ''}
	});
    
	$("#userlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// �����λ
function saveRow()
{
	if(editRow>="0"){
		$("#userlist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#userlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].UserDesc==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"����Ա����Ϊ�գ�"); 
			return false;
		}
		var tmp= rowsData[i].NodeUserId +"^"+ NodeDr +"^"+ rowsData[i].UserId +"^"+ rowsData[i].UserDesc +"^"+ rowsData[i].NodeId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//alert(params)
	//��������
	runClassMethod("web.DHCDISWorkNodeLinkUser","SaveNodeLinkUser",{"params":params},function(jsonString){
		//alert(jsonString)
		if(jsonString=="0")
		{
			$('#userlist').datagrid('reload'); //���¼���
		}
		
	});
}

/// ɾ����λ
function deleteRow()
{
	var rowsData = $("#userlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISWorkNodeLinkUser","DelNodeLinkUser",{"NodeUserId":rowsData.NodeUserId},function(data){
					$('#userlist').datagrid('reload'); //���¼���
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