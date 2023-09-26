/** sufan 
  * 2018-04-09
  *
  * ��λ����λ�ù���ά��
 */
var NodeDr =getParam("NodeDr");  ///��λID
var editRow="" ;
///��ʼ����������
function initPageDefault(){
	
	ComboEditor(); 		/// ��ʼ���༭��
	initLocList();		/// ��ʼ������datagrid
	initButton();  		/// ��ʼ���¼�
}

/// ��ʼ������datagrid
function initLocList()
{
	var LocEditor={		//������Ϊ�ɱ༭
		type: 'combogrid',	//���ñ༭��ʽ
		options:{
			required : true,
			id : 'NodeLocId',
			fitColumns : true,
			fit : true,//�Զ���С  
			pagination : true,
			panelWidth : 450,
			textField : 'NodeName',
			mode : 'remote',
			url : 'dhcapp.broker.csp?ClassName=web.DHCDISNodeLinkLoc&MethodName=QueryNodeLoc',
			columns:[[
					{field:'NodeLocId',hidden:true},
					{field:'NodeName',title:'����',width:80},
					{field:'NodeCode',hidden:true,title:'����',width:60},
					{field:'NodeType',title:'����',width:40}
					]],
				onSelect:function(rowIndex, rowData) {
   					fillValue(rowIndex, rowData);
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
		{field:"NodeItmId",title:'NodeItmId',hidden:true,width:100,editor:textEditor},
		{field:"LocationId",title:'������λλ��Id',hidden:true,width:220,editor:textEditor},
		{field:"NodeCode",title:'������λλ��',width:220,align:'center',editor:LocEditor},
		{field:"LocFlagCode",title:'λ�ñ�ʶ����',hidden:true,width:220,editor:textEditor},
		{field:"LocFlag",title:'λ�ñ�ʶ',width:220,align:'center',editor:textEditor},
	]];
	///  ����datagrid  
	var option = {
		singleSelect : true,
	 	 onDblClickRow: function (rowIndex, rowData) {// ˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#locationlist").datagrid('endEdit', editRow); 
            } 
            $("#locationlist").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        },
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCDISNodeLinkLoc&MethodName=QueryNodeLinkLoc&NodeId="+NodeDr;
	new ListComponent('locationlist', columns, uniturl, option).Init(); 
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
		$("#locationlist").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	 
	$("#locationlist").datagrid('insertRow', {//��ָ����������ݣ�appendRow�������һ���������
		index: 0, // ������0��ʼ����
		row: {NodeItmId: '',LocationId:'',NodeCode:'',LocFlagCode: '',LocFlag:''}
	});
    
	$("#locationlist").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// �����λ
function saveRow()
{
	if(editRow>="0"){
		$("#locationlist").datagrid('endEdit', editRow);
	}
	var rowsData = $("#locationlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){

		if(rowsData[i].NodeCode==""){
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�й�����λλ�ã�"); 
			return false;
		}
		var tmp=NodeDr +"^"+ rowsData[i].LocationId +"^"+ rowsData[i].NodeCode +"^"+ rowsData[i].LocFlagCode +"^"+ rowsData[i].LocFlag +"^"+ rowsData[i].NodeItmId;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCDISNodeLinkLoc","SaveNodeLinkLoc",{"params":params},function(jsonString){
		
		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#locationlist').datagrid('reload'); //���¼���
	});
}

/// ɾ����λ
function deleteRow()
{
	var rowsData = $("#locationlist").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCDISNodeLinkLoc","DelNodeLinkLoc",{"NodeItmId":rowsData.NodeItmId},function(data){
					$('#locationlist').datagrid('reload'); //���¼���
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
	$('#locationlist').datagrid('load',{params:params}); 
}
function ComboEditor()
{
	 $.extend($.fn.datagrid.defaults.editors, {
			combogrid: {
				init: function(container, options){
					var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
					input.combogrid(options);
					return input;
				},
				destroy: function(target){
					$(target).combogrid('destroy');
				},
				getValue: function(target){
					return $(target).combogrid('getText');
				},
				setValue: function(target, value){
					$(target).combogrid('setValue', value);
					
				},
				resize: function(target, width){
					$(target).combogrid('resize',width);
				}
			}
	});
}
function fillValue(rowIndex, rowData)
{
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'LocationId'});			//��ĿID��ֵ
	$(ed.target).val(rowData.NodeLocId);
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'NodeCode'});			//��Ŀ������ֵ
	$(ed.target).val(rowData.NodeName);
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'LocFlagCode'});			//����
	$(ed.target).val(rowData.NodeCode);
	var ed=$("#locationlist").datagrid('getEditor',{index:editRow, field:'LocFlag'});			//��ʶ
	$(ed.target).val(rowData.NodeType);
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })