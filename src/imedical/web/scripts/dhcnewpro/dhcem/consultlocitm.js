/// author:    bianshuai
/// date:      2018-08-28
/// descript:  ������רҵ/ָ֢����ά��

var editRow = "";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
/// ҳ���ʼ������
function initPageDefault(){
	
	
	///��Ժ������
	MoreHospSetting("DHC_EmConsLocItm");
	
	//��ʼ���б�
	InitMainList();
	
	//��ʼ�����水ť�¼�
	InitWidListener();
}

	///��Ժ������
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}


function ReloadMainTable(){
	var params="";
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = hospID;
	
	
	$HUI.datagrid('#main').load({
		Params:params
	})
	return ;
}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){
	
}

///��ʼ���б�
function InitMainList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor={
		type: 'text',//���ñ༭��ʽ
		options: {
			required: true //���ñ༭��������
		}
	}
	
	// ���ұ༭��
	var LocEditor = {
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			mode:'remote',
			enterNullValueClear:false,
			onSelect:function(option) {
				/// ����ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'LocID'});
				$(ed.target).val(option.value);

				/// ����
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'LocDesc'});
				$(ed.target).combobox('setValue', option.text);
			},onShowPanel:function(){
				var HospID = $HUI.combogrid("#_HospList").getValue();	 /// Ժ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'LocDesc'});
				//var unitUrl = $URL + "?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID;
				var unitUrl = $URL + "?ClassName=web.DHCEMConsultCom&MethodName=JsonLocList&HospID="+HospID+"&LType=CONSULT"; //hxy 2020-09-22
				$(ed.target).combobox('reload',unitUrl);
			}	   
		}
	}
	
	// ��רҵ�༭��
	var MarEditor = {
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			onSelect:function(option) {
				/// ��רҵID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MarID'});
				$(ed.target).val(option.value);
				/// ��רҵ
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MarDesc'});
				$(ed.target).combobox('setValue', option.text);
			},onShowPanel:function(){
				var HospID = $HUI.combogrid("#_HospList").getValue();/// Ժ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'MarDesc'});
				var unitUrl = $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&HospID="+ HospID +"&mCode=MAR";
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	// ָ��༭��
	var ItmEditor = {
		type: 'combobox',//���ñ༭��ʽ
		options:{
			valueField: "value", 
			textField: "text",
			enterNullValueClear:false,
			onSelect:function(option) {
				/// ָ��ID
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ItmID'});
				$(ed.target).val(option.value);
				/// ָ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
				$(ed.target).combobox('setValue', option.text);
			},onShowPanel:function(){
				var HospID = $HUI.combogrid("#_HospList").getValue();/// Ժ��
				var ed=$("#main").datagrid('getEditor',{index:editRow,field:'ItmDesc'});
				var unitUrl = $URL + "?ClassName=web.DHCEMConsDicItem&MethodName=jsonConsItem&HospID="+ HospID  +"&mCode=IND";
				$(ed.target).combobox('reload',unitUrl);
			}		   
		}
	}
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'left'},
		{field:'LocID',title:'LocID',width:100,editor:textEditor,hidden:true},
		{field:'LocDesc',title:'����',width:200,editor:LocEditor,align:'left'},
		{field:'MarID',title:'MarID',width:100,editor:textEditor,hidden:true},
		{field:'MarDesc',title:'��רҵ',width:200,editor:MarEditor,align:'left'},
		{field:'ItmID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'ItmDesc',title:'ָ��',width:600,editor:ItmEditor,align:'left'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'',
		//nowrap:false,
		singleSelect : true,
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
        }
	};
	
	var HospID = $HUI.combogrid("#_HospList").getValue();
	var params=HospID;
	var uniturl = $URL+"?ClassName=web.DHCEMConsLocItem&MethodName=QryEmConsLocItem&Params="+params;
	new ListComponent('main', columns, uniturl, option).Init();

}

/// ����༭��
function saveRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);
	}
	
	var rowsData = $("#main").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if(rowsData[i].LocID == ""){
			$.messager.alert("��ʾ","���Ҳ���Ϊ��!"); 
			return false;
		}
		if(rowsData[i].MarID == ""){
			$.messager.alert("��ʾ","��רҵ����Ϊ��!"); 
			return false;
		}
		if(rowsData[i].ItmID == ""){
			$.messager.alert("��ʾ","ָ�벻��Ϊ��!"); 
			return false;
		}
		var tmp=rowsData[i].ID +"^"+ rowsData[i].LocID +"^"+ rowsData[i].MarID +"^"+ rowsData[i].ItmID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCEMConsLocItem","save",{"mParam":mListData},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert('��ʾ','�����ظ�,���ʵ�����ԣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}

	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if ((rowsData[0].LocID == "")||(rowsData[0].MarID=="")||(rowsData[0].ItmID=="")){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			$.messager.alert('��ʾ','��༭�������ݣ�','warning');
			return;
		}
	}

	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {ID:'', LocID:'', LocDesc:'', MarID:'', MarDesc:'', ItmID:'', ItmDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCEMConsLocItem","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('��ʾ','ɾ��ʧ�ܣ�','warning');
					}
					$('#main').datagrid('reload'); //���¼���
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