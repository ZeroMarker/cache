//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-07-10
// ����:	   mdtѡ�����ģ�����
//===========================================================================================
var DisGrpID = ""; /// ����ID
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   /// ����ID
	EpisodeID = getParam("EpisodeID");   /// ����ID
	DisGrpID = getParam("DisGrpID");   /// ����ID
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	///  ����columns
	 var ConsDetArr=[];
	 var makLocParams="";
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Text',title:'ģ������',width:600},
		{field:'Title',title:'ģ�����',width:180},
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		loadMsg:$g("���ڼ�����Ϣ"),
		rownumbers : true,
		singleSelect:false,
		pagination: true,
		iconCls:'icon-paper',
		bodyCls:'panel-header-gray',
		border:true,
		onLoadSuccess:function(data){
			$(".datagrid-header-check").html("");
		},
		onCheck: function (rowIndex,rowData){
		     var TmpData = rowData.Text;
		     ConsDetArr.push(TmpData);
		     var makLocParams = ConsDetArr.join(" ");
		     window.parent.$("#mdtPurpose").val(makLocParams);   /// ����Ŀ��
		},
		onUncheck: function (rowIndex,rowData){
		     var TmpData = rowData.Text;
		     ConsDetArr.push(TmpData);
		     for(var i=0;i<ConsDetArr.length;i++){
			     if(TmpData==ConsDetArr[i]){
				     delete ConsDetArr[i]
				     }
			     }
		     var makLocParams = ConsDetArr.join(" ");
		     window.parent.$("#mdtPurpose").val(makLocParams);   /// ����Ŀ��
		 }    
		     
	};
	/// ��������
	//var Type = "";
	var Type = DisGrpID;
	var uniturl = $URL+"?ClassName=web.DHCMDTOpiTemp&MethodName=QryOpiTemp&Type="+DisGrpID+"&LgParam="+LgParam+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init(); 
}

/// ɾ��ѡ����
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ��ģ��������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCMDTOpiTemp","delete",{"ID":rowsData.ID},function(jsonString){
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