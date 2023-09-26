/** sufan 
  * 2018-08-23
  *
  * 
 */
var NodeDr =getParam("NodeDr");  ///��λID
var editRow="" ;
///��ʼ����������
function initPageDefault(){
	
	initSerGroList();		/// ��ʼ������datagrid
	initButton();  		/// ��ʼ���¼�
}

/// ��ʼ������datagrid
function initSerGroList()
{
	
	var Groupeditor={  //������Ϊ�ɱ༭
		//���
		type: 'combobox',//���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCDISWorkNodeLinkGroup&MethodName=QuerySerGroup",
			//required:true,
			panelHeight:"200",  //���������߶��Զ�����
			mode:'remote',
			onSelect:function(option){
				///��������ֵ
				var ed=$("#nodeserglist").datagrid('getEditor',{index:editRow,field:'SerGroupIDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#nodeserglist").datagrid('getEditor',{index:editRow,field:'SerGroupId'});
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
		{field:"NodeGroId",title:'NodeGroId',width:100,hidden:true,editor:textEditor},
		{field:"SerGroupId",title:'SerGroupId',width:100,hidden:true,editor:textEditor},
		{field:"SerGroupIDesc",title:'������',width:220,align:'center',editor:Groupeditor},
		{field:"NodeDr",title:'NodeDr',width:220,hidden:true,editor:textEditor},
	]];
	///  ����datagrid  
	var option = {
		singleSelect : true,
	 	onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#nodeserglist").datagrid('endEdit', editRow); 
            } 
            $("#nodeserglist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISWorkNodeLinkGroup&MethodName=QueryWorkLinkGroup&NodeId="+NodeDr;
	new ListComponent('nodeserglist', columns, uniturl, option).Init(); 
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
		$("#nodeserglist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#nodeserglist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {NodeGroId: '',SerGroupId:'',SerGroupIDesc:'',NodeDr: NodeDr}
	});
    
	$("#nodeserglist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// �����λ
function saveRow()
{
	if(editRow>="0"){
		$("#nodeserglist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#nodeserglist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].SerGroupId==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�з�����Ϊ�գ�"); 
			return false;
		}
		var tmp= rowsData[i].NodeGroId +"^"+ rowsData[i].NodeDr +"^"+ rowsData[i].SerGroupId +"^"+ rowsData[i].SerGroupIDesc ;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISWorkNodeLinkGroup","SaveNodeGroup",{"params":params},function(jsonString){
		if(jsonString=="0")
		{
			$('#nodeserglist').datagrid('reload'); //���¼���
		}
		
	});
}

/// ɾ����λ
function deleteRow()
{
	var rowsData = $("#nodeserglist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISWorkNodeLinkGroup","DelNodeGroup",{"NodeGroupId":rowsData.NodeGroId},function(data){
					$('#nodeserglist').datagrid('reload'); //���¼���
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