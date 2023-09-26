/// Descript: ���������ҽ������ά��
/// Creator : qunianpeng
/// Date    : 2017-03-19

var catID = "", editRow = "";

/// ҳ���ʼ������
function initPageDefault(){
			
	InitDefault();			/// ��ʼ������Ĭ����Ϣ
	initItmcatlist();	 	///	��ʼҳ��DataGridҽ�������
	initButton();           /// ҳ��Button���¼�	
}


///��ʼ������Ĭ����Ϣ
function InitDefault(){
	catID=getParam("itmmastid");  /// ҽ����ID
}

/// ҳ�� Button ���¼�
function initButton(){	

	///  ����ҽ������
	$('#insertcat').bind("click",insertcatRow);
	
	///  ����ҽ������
	$('#savecat').bind("click",savecatRow);
	
	///  ɾ��ҽ������
	$('#deletecat').bind("click",deletecatRow);
}

/// ��ʼ��ҽ�������б�
function initItmcatlist()
{
	var Cateditor={  		/// ������Ϊ�ɱ༭
		//���
		type: 'combobox',	/// ���ñ༭��ʽ
		options: {
			valueField: "value", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCAPPCommonUtil&MethodName=jsonArcItemCat",
			required:true,
			panelHeight:"280",  /// ���������߶��Զ�����
			onSelect:function(option){
				///��������ֵ
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDesc'});
				$(ed.target).combobox('setValue', option.text);
				var ed=$("#itemlist").datagrid('getEditor',{index:editRow,field:'CatDr'});
				$(ed.target).val(option.value); 
			} 
		}
	}
	
	/// �ı��༭��
	var textEditor={
		type: 'text',		/// ���ñ༭��ʽ
		options: {
			required: true  /// ���ñ༭��������
		}
	}
	// ����columns
	var columns=[[
		{field:"CatDesc",title:'ҽ������',width:300,editor:Cateditor},
		{field:"CatDr",title:'����ID',width:150,align:'center',hidden:'true',editor:textEditor},
		{field:"CatLinkID",title:'ItmID',width:150,align:'center',hidden:'true',editor:textEditor}
	]];
	///  ����datagrid  
	var option = {
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {	/// ˫��ѡ���б༭
            if (editRow != "") { 
                $("#itemlist").datagrid('endEdit', editRow); 
            } 
            $("#itemlist").datagrid('beginEdit', rowIndex); 
            
            editRow = rowIndex; 
        }
	};
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPArcCat&MethodName=QueryCatLink&ItmId="+catID;
	new ListComponent('itemlist', columns, uniturl, option).Init();
}
/// ����ҽ������
function insertcatRow()
{
	if (catID == ""){
		$.messager.alert("��ʾ","��ѡ��һ��ѡ��!"); 
		return;	
	}	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);	/// �����༭������֮ǰ�༭����
	}
	 
	$("#itemlist").datagrid('insertRow', {				/// ��ָ����������ݣ�appendRow�������һ���������
		index: 0, 										/// ������0��ʼ����
		row: {CatDesc: '',CatDr:'',CatLinkID: ''}
	});
	$("#itemlist").datagrid('beginEdit', 0);			/// �����༭������Ҫ�༭����
	editRow=0;
}

///��������Ŀ��λ
function savecatRow(){
	
	if(editRow>="0"){
		$("#itemlist").datagrid('endEdit', editRow);
	}
	
	var hospID = parent.$("#arccatlist").datagrid('getSelected').hospdr;  //����ҽԺID����ȡsession��ID��Ҫȡ����б�ѡ��ID

	var rowsData = $("#itemlist").datagrid('getChanges');  
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		if ((rowsData.CatDr=="")||(rowsData[i].CatDesc==""))
		{
			$.messager.alert("��ʾ","��ѡ��ҽ������!");
			return false;
		}
		
		var tmp=rowsData[i].CatLinkID +"^"+ catID +"^"+ rowsData[i].CatDesc +"^"+ rowsData[i].CatDr +"^"+ hospID;
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	//��������
	runClassMethod("web.DHCAPPArcCat","Save",{"params":params},function(jsonString){
		if (jsonString == "0"){
			$.messager.alert('��ʾ','����ɹ���');
		}
		if (jsonString=="-11")
		{
			$.messager.alert('��ʾ','��ҽ�������ѹ����������࣬������ѡ��');
			}
		$('#itemlist').datagrid('reload'); 					/// ���¼���
	});
}
/// ɾ��
function deletecatRow(){
	
	var rowsData = $("#itemlist").datagrid('getSelected');	/// ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {	/// ��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCAPPArcCat","DelCatLink",{"CatLinkId":rowsData.CatLinkID},function(jsonString){
					$('#itemlist').datagrid('reload'); 		/// ���¼���
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