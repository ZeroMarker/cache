//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2018-07-18
// ����:	   MDT�����б�
//===========================================================================================

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	InitPatInfoPanel();
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(formatDate(0));
	/// ��������
	$HUI.datebox("#EndDate").setValue(formatDate(0));
	
	/// Mdt����
	$HUI.combobox("#MdtLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsMdtPat&MethodName=jsonListMdtLoc&HospID=2",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        QryEmPatList();
	    }	
	})
	
	/// Mdt���
	$HUI.combobox("#MdtDiag",{
		url:LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=jsonListWard&HospID=2",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        QryEmPatList();
	    }	
	})
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	
	///  ����columns
	var columns=[[
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60,align:'center'},
		{field:'PatAge',title:'����',width:70,align:'center'},
		{field:'PAAdmDepCodeDR',title:'�������',width:120},
		//{field:'PAAdmWard',title:'����',width:120,align:'center'},
		//{field:'PAAdmBed',title:'����',width:80,align:'center'}, 
		{field:'Diagnosis',title:'���',width:190},
		{field:'PAAdmDate',title:'��������',width:120,align:'center'},
		{field:'BillType',title:'��������',width:80,align:'center'},
		{field:'PAAdmDocCodeDR',title:'ҽ��',width:100,align:'center'},
		{field:'CareProv',title:'�ű�',width:100,align:'center'},
		{field:'CurStatus',title:'����״̬',width:100,align:'center'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
		},
	    onDblClickRow: function (rowIndex, rowData) {

        }
	};
	/// ��������
	var param = "^"+ session['LOGON.CTLOCID'] +"^E";
	var uniturl = $URL+"?ClassName=web.DHCEMConsMdtPat&MethodName=JsQryConsMdtPatList&params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init(); 
}

/// �ǼǺ�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		QryPatList();  /// ��ѯ
	}
}

/// ��ѯ
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var PatNo = $("#PatNo").val();    /// �ǼǺ�
	var MdtLoc = $HUI.combobox("#MdtLoc").getValue();
	if (MdtLoc == ""){
		MdtLoc = session['LOGON.CTLOCID'];
	}
	var params = PatNo +"^"+ MdtLoc +"^E^"+ StartDate +"^"+ EndDate;
	$("#PatList").datagrid("load",{"params":params}); 
}

/// ��дMDT����
function WriteMdt(){
	
	var rowsData = $("#PatList").datagrid('getSelected'); //ѡ��Ҫɾ������
	if (rowsData != null) {
		OpenMdtConsWin();
		$("#newWinFrame").attr("src","dhcem.consultmdt.csp?EpisodeID="+rowsData.EpisodeID +"&ConsID="+ rowsData.ConsID);
	}else{
		$.messager.alert('��ʾ','��ѡ��Ҫ��д����ļ�¼��','warning');
		return;
	}
}

/// ��MDT��дҳ��
function OpenMdtConsWin(){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('MDT����', 'MdtConsWin', '950', '550', option).Init();
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
