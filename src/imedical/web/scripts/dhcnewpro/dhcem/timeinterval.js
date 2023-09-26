/// author:    yangyongtao
/// date:      2019-09-16
/// descript:  ԤԼʱ��ά��

var editRow = ""; editDRow = "";
var ActFlagArr = [{"value":"Y","text":"��"},{"value":"N","text":"��"}];
var ModuleArr = [{"value":"Doc","text":"ҽ�����"},{"value":"Nur","text":"��ʿ���"}];  /// ,{"value":"Inf","text":"��ҺԤԼ"}

$(function(){
	///��Ժ������
	MoreHospSetting("DHC_EmTimeInterval");

	/// ��ʼ������Ĭ����Ϣ
	InitDefault();
	
	/// ��ʼ����ѯ��Ϣ�б�
	InitDetList();
	
	/// ��ʼ�����水ť�¼�
	InitWidListener();
})

///��Ժ������
function MoreHospSetting(tableName){
	hospComp = GenHospComp(tableName);
	hospComp.options().onSelect = ReloadMainTable;
}

/// ��ʼ������Ĭ����Ϣ
function InitDefault(){

}

/// ����Ԫ�ؼ����¼�
function InitWidListener(){

	$('div#tb a:contains("����")').bind("click",insertRow);
	$('div#tb a:contains("ɾ��")').bind("click",deleteRow);
	$('div#tb a:contains("����")').bind("click",saveRow);
	
}

/// ��ʼ����ѯ��Ϣ�б�
function InitDetList(){
	
	/**
	 * �ı��༭��
	 */
	var textEditor = {
		type:'text',		//���ñ༭��ʽ
		options:{
			required:true	//���ñ༭��������
		}
	}
	
	/**
	 * ʱ��༭��
	 */
	var sttimeEditor = {	//������Ϊ�ɱ༭
		type:'combobox',	//���ñ༭��ʽ
		options:{
			valueField:'value',
			textField:'text',
			mode:'remote',
			url:$URL +"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimes",
			required:true,
			editable:false,
			//panelHeight:'auto',  //���������߶��Զ�����
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'StartTime'});
				$(ed.target).val(option.value);					//����value
			} 	
		}
	}
	
	var endtimeEditor = {	//������Ϊ�ɱ༭
		type:'combobox',	//���ñ༭��ʽ
		options:{
			valueField:'value',
			textField:'text',
			mode:'remote',
			url:$URL +"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimes",
			required:true,
			editable:false,
			//panelHeight:'auto',  //���������߶��Զ�����
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'EndTime'});
				$(ed.target).val(option.value);					//����value
			}
		}
	}
	
	/**
	 * combobox�༭��
	 */
	var activeEditor = {
		type:'combobox',	//���ñ༭��ʽ
		options:{
			data:ActFlagArr,
			valueField:'value',
			textField:'text',
			panelHeight:'auto',		//���������߶��Զ�����
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'ActCode'});
				$(ed.target).val(option.value);					//����value
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'ActDesc'});
				$(ed.target).combobox('setValue',option.text);	//����Desc
			}
		}
	}
	
	var HospEditor = {		//������Ϊ�ɱ༭
		/// ���
		type:'combobox',	//���ñ༭��ʽ
		options:{
			valueField:'value',
			textField:'text',
			url:$URL +"?ClassName=web.DHCAPPCommonUtil&MethodName=GetHospDs",
			//required:true,
			panelHeight:'auto',  //���������߶��Զ�����
			onSelect:function(option){
				/// ��������ֵ
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'HospID'});
				$(ed.target).val(option.value);
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'HospDesc'});
				$(ed.target).combobox('setValue',option.text);
			} 	
		}
	}
		
	/**
	 * combobox�༭��
	 */
	var ModuleEditor = {
		type:'combobox',	//���ñ༭��ʽ
		options:{
			data:ModuleArr,
			valueField:'value',
			textField:'text',
			panelHeight:'auto',		//���������߶��Զ�����
			onSelect:function(option){
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'ModuleID'});
				$(ed.target).val(option.value);					//����value
				var ed = $('#dgMainList').datagrid('getEditor',{index:editRow,field:'Module'});
				$(ed.target).combobox('setValue',option.text);	//����Desc
			}
		}
	}
	
	/**
	 * ����columns
	 */
	var columns = [[
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Code',title:'����',width:100,editor:textEditor},
		{field:'Desc',title:'����',width:200,editor:textEditor},
		{field:'StartTime',title:'��ʼʱ��',width:150,editor:sttimeEditor},
		{field:'EndTime',title:'����ʱ��',width:150,editor:endtimeEditor},
		{field:'ActCode',title:'aitActCode',width:100,editor:textEditor,hidden:true},
		{field:'ActDesc',title:'�Ƿ����',width:100,editor:activeEditor},
		{field:'HospID',title:'HospID',width:100,editor:textEditor,hidden:true},
		{field:'HospDesc',title:'ҽԺ',width:300,editor:HospEditor,hidden:true},
		{field:'ModuleID',title:'ModuleID',width:100,editor:textEditor,hidden:true},
		{field:'Module',title:'ģ��',width:120,editor:ModuleEditor}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		//title:'ԤԼ��Դά��',
		//nowrap:false,
		singleSelect:true,
	    onDblClickRow:function(rowIndex, rowData){	//˫��ѡ���б༭
            if ((editRow != "")||(editRow == "0")){
                $('#dgMainList').datagrid('endEdit',editRow);
            }
            $('#dgMainList').datagrid('beginEdit',rowIndex);
            editRow = rowIndex;
        }
	};
	var params="";
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = hospID;
	var uniturl = $URL +"?ClassName=web.DHCEMTimeInterval&MethodName=QryEmTimeInterval&Params="+params;
	var dgMainListComponent = new ListComponent('dgMainList',columns,uniturl,option);
	dgMainListComponent.Init();
	
}

/// ����༭��
function saveRow(){
	
	if (editRow >= "0"){
		$('#dgMainList').datagrid('endEdit',editRow);
	}

	var rowsData = $('#dgMainList').datagrid('getChanges');
	if (rowsData.length <= 0){
		$.messager.alert("��ʾ","û�д��������ݣ�","warning");
		return;
	}
	var dataList = [];
	for (var i = 0;i < rowsData.length;i ++){
		
		if ((rowsData[i].Code == "")||(rowsData[i].Desc == "")){
			$.messager.alert("��ʾ","�������������Ϊ�գ�","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if ((rowsData[i].StartTime == "")||(rowsData[i].EndTime == "")){
			$.messager.alert("��ʾ","��ʼʱ������ʱ�䲻��Ϊ�գ�","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if (rowsData[i].HospID == ""){
			$.messager.alert("��ʾ","ҽԺ����Ϊ�գ�","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if (rowsData[i].StartTime >= rowsData[i].EndTime){
			$.messager.alert("��ʾ","��ʼʱ�䲻�ܴ��ڻ���ڽ���ʱ�䣡","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		if (rowsData[i].ModuleID == ""){
			$.messager.alert("��ʾ","ģ�鲻��Ϊ�գ�","warning");
			$('#dgMainList').datagrid('beginEdit',editRow);
			return false;
		}
		
		var tmp = rowsData[i].ID +"^"+ rowsData[i].Code +"^"+ rowsData[i].Desc +"^"+ rowsData[i].StartTime;
		tmp = tmp +"^"+ rowsData[i].EndTime +"^"+ rowsData[i].ActCode +"^"+ rowsData[i].HospID +"^"+ rowsData[i].ModuleID;
		dataList.push(tmp);
	}
	
	var params = dataList.join("$$");

	/// ��������
	runClassMethod("web.DHCEMTimeInterval","save",{"mParam":params},function(jsonString){

		if ((jsonString == "-1")||((jsonString == "-3"))){
			$.messager.alert("��ʾ","�����ظ������ʵ�����ԣ�","warning");
		}
		else if ((jsonString == "-2")||((jsonString == "-4"))){
			$.messager.alert("��ʾ","�����ظ������ʵ�����ԣ�","warning");
		}
		else if (jsonString == "-5"){
			$.messager.alert("��ʾ","ʱ������ظ������ʵ�����ԣ�","warning");
		}
		else if (jsonString == "0"){
			$.messager.alert("��ʾ","����ɹ���","info");
			$('#dgMainList').datagrid('reload');	//���¼���
		}
		else{
			$.messager.alert("��ʾ","����ʧ�ܣ�ʧ��ԭ��"+jsonString,"error");
		}
	})
}

/// ��������
function insertRow(){
	
	if (editRow >= "0"){
		$('#dgMainList').datagrid('endEdit',editRow);	//�����༭������֮ǰ�༭����
	}
	
	/// ����һ���Ƿ�Ϊ����
	var rowsData = $('#dgMainList').datagrid('getRows');
	if (rowsData.length != 0){
		if (rowsData[0].Code == ""){
			$('#dgMainList').datagrid('selectRow',0);
			$("#dgMainList").datagrid('beginEdit',0);	//�����༭������Ҫ�༭����
			return;
		}
	}
	var hospID = $HUI.combogrid("#_HospList").getValue();
	
	$('#dgMainList').datagrid('insertRow',{
		index:0,	//������0��ʼ����
		row:{ID:"",Code:"",Desc:"",ActCode:"Y",ActDesc:"��",HospID:hospID,HospDesc:hospID}
	});
	$('#dgMainList').datagrid('beginEdit',0);			//�����༭������Ҫ�༭����
	editRow = 0;
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $('#dgMainList').datagrid('getSelected');	//ѡ��Ҫɾ������
	if (rowsData == null){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ�����","warning");
		return;
	}
	if(rowsData.ID==""){
		$('#dgMainList').datagrid('deleteRow',0);
		return;
	}
	
	$.messager.confirm("��ʾ","��ȷ��Ҫɾ����Щ������",function(res){		//��ʾ�Ƿ�ɾ��
		if (res){
			runClassMethod("web.DHCEMTimeInterval","delete",{"ID":rowsData.ID},function(jsonString){
				if (jsonString == 0){
					$.messager.alert("��ʾ","ɾ���ɹ���","info");
					$('#dgMainList').datagrid('reload'); 		//���¼���
				}
				else{
					$.messager.alert("��ʾ","ɾ��ʧ�ܣ�ʧ��ԭ��"+ jsonString,"error");
				}
			})
		}
	});
}

function ReloadMainTable(){
	var params="";
	var hospID = $HUI.combogrid("#_HospList").getValue();
	params = hospID;
	
	
	$HUI.datagrid('#dgMainList').load({
		Params:params
	})
	return ;
}