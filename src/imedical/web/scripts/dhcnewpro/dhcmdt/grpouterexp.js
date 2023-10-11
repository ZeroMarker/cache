//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2020-08-18
// ����:	   MDT���ֹ���Ժ��ר��JS
//===========================================================================================

var editRow = "";
var grpID = "";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
		
/// ҳ���ʼ������
function initPageDefault(){

	InitParams();      /// ��ʼ������
	InitComponents();  /// ��ʼ���������
	InitMainList();    /// ��ʼ���б�
}

/// ��ʼ��ҳ�����
function InitParams(){
	
	var rowData = parent.$("#main").datagrid("getSelected");
	if (rowData == null) {
		return;
	}
	grpID = rowData.ID;   /// MDTС��ID
}

/// ��ʼ���������
function InitComponents(){
	

}

/// ��ʼ�����ؽ����б�
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
	
	var rowData = parent.$("#main").datagrid("getSelected");
	var HospID = rowData.HospID;  
	
	// ��Ժר��
	var OutExpEditor = {
		type:'combogrid',
		options:{
			required : true,
			id:'ID',
			fitColumns:false,
			fit: true,//�Զ���С
			pagination : true,
			panelWidth:580,
			textField:'userName', 
			mode:'remote',
			url:$URL+'?ClassName=web.DHCMDTExpertMan&MethodName=JsQryExpMan&GropHospID='+HospID+"&MWToken="+websys_getMWToken(),
			columns:[[
				{field:'ID',title:'ID',width:100,hidden:true},
				{field:'userCode',title:'����',width:100,align:'center'},
				{field:'userName',title:'����',width:160,align:'left'},
				{field:'userSex',title:'�Ա�',width:60,align:'center'},
				{field:'prvTp',title:'ְ��',width:100,align:'center'},
				{field:'locDesc',title:'����',width:160,align:'left'},
				{field:'phone',title:'��ϵ�绰',width:100,align:'left'},
				{field:'hospDesc',title:'ҽԺ',width:200,align:'center',hidden:true}
			]],
			onSelect:function(rowIndex, rowData) {
				fillValue(rowIndex, rowData);
			}	
		}
	};
	
	///  ����columns
	var columns=[[
		{field:'grpID',title:'grpID',width:100,hidden:true},
		{field:'ID',title:'ID',width:100},
		{field:'userID',title:'userID',width:100,hidden:true,editor:textEditor},
		{field:'userCode',title:'����',width:100,align:'center',editor:textEditor},
		{field:'userName',title:'����',width:160,align:'left',editor:OutExpEditor},
		{field:'userSex',title:'�Ա�',width:100,align:'center',editor:textEditor},
		{field:'prvTp',title:'ְ��',width:100,align:'center',editor:textEditor},
		{field:'locDesc',title:'����',width:160,align:'left'},
		{field:'outHosp',title:'ҽԺ',width:160,align:'left'},
		{field:'phone',title:'��ϵ�绰',width:120,align:'left'},
		{field:'hospDesc',title:'ҽԺ',width:200,align:'center',hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		headerCls:'panel-header-gray',
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){

		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
	    
            if ((editRow != "")||(editRow == "0")) { 
                $("#main").datagrid('endEdit', editRow); 
            } 
            $("#main").datagrid('beginEdit', rowIndex); 
            editRow = rowIndex;
            
			SetCellDisEnable(editRow); /// �����в��ɱ༭

        },
		onLoadSuccess:function(data){

		}
	};
	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCMDTGroup&MethodName=JsQryGrpOutExp&Parref="+ grpID+"&MWToken="+websys_getMWToken();
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
		
		if(rowsData[i].userID==""){
			$.messager.alert("��ʾ","ר�Ҳ���Ϊ��!"); 
			return false;
		}
		var tmp = rowsData[i].ID +"^"+ rowsData[i].grpID +"^"+ rowsData[i].userID;
		dataList.push(tmp);
	}
	
	var mListData=dataList.join("$$");

	//��������
	runClassMethod("web.DHCMDTGroup","saveOutExp",{"mParam":mListData},function(jsonString){

		if (jsonString == "-1"){
			$.messager.alert('��ʾ','ר���ظ�,���ʵ�����ԣ�','warning');
			return;	
		}else if (jsonString != 0){
			$.messager.alert('��ʾ','����ʧ�ܣ�','warning');
			return;
		}
		$('#main').datagrid('reload'); //���¼���
	})
}

/// ��������
function insertRow(){
	
	var rowData = parent.$("#main").datagrid("getSelected");
	if (rowData == null) {
		$.messager.alert("��ʾ","����ѡ��MDTС��!");
		return;
	}
	var ID = rowData.ID;   /// MDTС��ID

	if(editRow>="0"){
		$("#main").datagrid('endEdit', editRow);//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $("#main").datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].userCode == ""){
			$('#main').datagrid('selectRow',0);
			$("#main").datagrid('beginEdit',0);//�����༭������Ҫ�༭����
			return;
		}
	}
	
	$("#main").datagrid('insertRow', {
		index: 0, // ������0��ʼ����
		row: {grpID:ID, ID:'', userID:'', userCode:'', userName:'', userSex:'', prvTp:'', special:'', idCard:'', locDesc:'', phone:'',hospDesc:''}
	});
	$("#main").datagrid('beginEdit', 0);//�����༭������Ҫ�༭����
	editRow=0;
	
	SetCellDisEnable(editRow); /// �����в��ɱ༭
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTGroup","deleteOutExp",{"ID":rowsData.ID},function(jsonString){
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

/// ����ȡֵ����
function fillValue(rowIndex, rowData){
		
	if (rowData == null) return;
	/// ר��ID
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userID'});
	$(ed.target).val(rowData.ID);
	/// ����
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userCode'});
	$(ed.target).val(rowData.userCode);
	/// ����
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userName'});
	$(ed.target).val(rowData.userName);
	/// �Ա�
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'userSex'});
	$(ed.target).val(rowData.userSex);
	/// ְ��
	var ed=$("#main").datagrid('getEditor',{index:editRow, field:'prvTp'});
	$(ed.target).val(rowData.prvTp);
}

/// �����в��ɱ༭
function SetCellDisEnable(rowIndex){
	
	SetDisEnable(rowIndex, "userSex");   /// �����в��ɱ༭
	SetDisEnable(rowIndex, "prvTp");     /// �����в��ɱ༭
	SetDisEnable(rowIndex, "userCode");  /// �����в��ɱ༭
}

/// �����в��ɱ༭
function SetDisEnable(rowIndex, fieldName){
	
	// �õ���Ԫ�����,indexָ��һ��,field�������е��Ǹ�һ��
	var cellEdit = $("#main").datagrid('getEditor', {index:rowIndex, field:fieldName});
	cellEdit.target.prop('readonly',true); // ��ֵ�ı������ֻ��
}

//��չ datagrid combogrid ���Ե�editor 2016-07-24
$(function(){
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
})
/// �Զ�����ҳ�沼��
function onresize_handler(){
	
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {

	
	/// �Զ�����ҳ�沼��
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })