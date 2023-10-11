/// author:    xiaowenwu
/// date:      2020-03-06
/// descript:  �������б�
var CstID=""  //����ID
var PatientID=""  //����ID
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
/// ҳ���ʼ������
function initPageDefault(){
	
	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID

	///��ʼ��combobox������
	initCombobox();
	
	//��ʼ��������ϸ�б�
	InitlogDetailsList();
	
	///��ʼ���ֵ������б�
	InitDetailList();
	
	initBTN();
	
	$("#bt_DocFol").hide();  /// ����ҽ�����
	$("#bt_expopi").hide();  /// ר�����
	

	search(); 				  /// Ĭ�ϲ�ѯ
	//InitTime();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){

    CstID = getParam("CstID");              /// ����ID
    //PatientID=getParam("PatientID");    	/// ����ID
	
}


///��ʼ��combobox������
function initCombobox(){
	

}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

///��ʼ���ֵ���Ŀ�б�
function InitlogDetailsList(){
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'MCDate',title:'����',width:150,align:'center'},
		{field:'MDDiseases',title:'����',width:150,align:'center'},
		{field:'isFeedback',title:'�Ƿ���',width:90,align:'center'},
		{field:'FreebackNum',title:'��������',width:90,align:'center',hidden:true},
		{field:'MCLocDr',title:'����',width:120,align:'center'},
		{field:'PatNo',title:'�ǼǺ�',width:120,align:'center'},
		{field:'PatName',title:'����',width:120,align:'center'},
		{field:'PatSex',title:'�ձ�',width:80,align:'center'},
		{field:'PatBed',title:'����',width:80,align:'center'},
		{field:'MedicareNo',title:'סԺ��',width:120,align:'center'},
		{field:'CstRTime',title:'�������ʱ��',width:150,align:'center'},
		{field:'CstRUser',title:'������',width:80,align:'center'},
		{field:'ID',title:'ID',width:100,hidden:false,align:'center'},
		{field:'CstID',title:'CstID',width:100,hidden:true},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'MDT��������',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		toolbar:[],
		border:false,

        onClickRow:function(rowIndex, rowData){
	        $("#folText").text(rowData.FolText);
	        /// ����ר�һظ������б�
			$("#replyContent").datagrid('reload',{mID:rowData.ID});
			//setWaitFromData(rowData);
	    },
	    onLoadSuccess:function(data){
			if(data.rows.length){
				$('#logDetails').datagrid("selectRow",0);
				$("#replyContent").datagrid('reload',{mID:data.rows[0].ID});	
			}
			return;
		}
	    
	};
	var param = getParams();
	var uniturl = $URL+"?ClassName=web.DHCMDTWaitingListNew&MethodName=QryFolUpDetail&Params="+param+"&MWToken="+websys_getMWToken();
	new ListComponent('logDetails', columns, uniturl, option).Init();

}

//�жϵ�ǰ�û�
function setWaitFromData(rowData){
	var CstID = rowData.CstID;
	var IsPerFlag=GetIsPerFlag(CstID)
	if(IsPerFlag==1){
		$("#bt_DocFol").show();  /// ����ҽ�����
		$("#bt_expopi").hide();  /// ר�����	
	}
	if(IsPerFlag==2){
		$("#bt_DocFol").hide();  /// ����ҽ�����
		$("#bt_expopi").show();  /// ר�����	
	}
	
	
}

///��ʼ�������б�
function InitDetailList(){
	
	
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'mID',title:'mID',width:100,align:'center',hidden:true},
		{field:'DocID',title:'ר��',width:100,align:'center'},
		{field:'Advice',title:'����',width:500,align:'left'},
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		title:'ר�һظ�����',
		nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		toolbar:[],
		border:false,

	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTWaitingListNew&MethodName=QryReplyContent&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('replyContent', columns, uniturl, option).Init();
}

//��ʼ����ť�¼�	
function initBTN(){
	$("#searchBtn").on('click',function(){search();})
}


 /// ��ʼ��ִ��ʱ��
/*function InitTime(){
	
	runClassMethod("web.DHCEMNurExe","GetSystemTime",{},function(jsonObject){
		if (jsonObject != null){
			$HUI.datebox("#startDate").setValue(jsonObject["SystemDate"]); /// ִ������
			$("#endDate").val(jsonObject["SystemTime"]); /// ִ��ʱ��
		}
	},'json',false)
}
 */
function search(){
	var params = getParams();
	$("#logDetails").datagrid("load",{"params":params}); 
}

function getParams(){
	return CstID;
	var params="";
	var	startDate=$HUI.datebox("#startDate").getValue();	//��ʼ����
    var endDate=$HUI.datebox("#endDate").getValue();		//��������
    var Diseases=$HUI.combobox("#Diseases").getValue();		//���Ѳ���
    params = startDate +"^"+ endDate +"^"+Diseases+"^"+CstID;
	return params;	
}

//����ҽ�����
function  DocFolWin(){
	
	
	var rowData = $('#logDetails').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var CstID=rowData.CstID
	var MCDate=rowData.MCDate
	if(GetIsFloVis(CstID,MCDate)!=1){
		$.messager.alert("��ʾ:","��ǰ��������¼�����������MDT����������","warning");
		return;
	}
		
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ���������¼�����ԣ�","warning");
		return;
	}
	
	var mradm = "";
	var link = "dhcmdt.folupmain.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&ID="+rowData.CstID+"&McID="+rowData.ID+"&MWToken="+websys_getMWToken();
	//window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	commonShowWin({
		url: link,
		title: $g("MDT����"),
		width: 1300,
		height: 600
	})
}

//ר�����
function  ExpertOp(){
	var rowData = $('#logDetails').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","��ѡ������¼�����ԣ�","warning");
		return;
	}
	var mradm = "";
	var link = "dhcmdt.replymain.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&ID="+rowData.CstID+"&McID="+rowData.ID+"&MWToken="+websys_getMWToken();
	//window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	commonShowWin({
		url: link,
		title: $g("ר�����"),
		width: 1300,
		height: 600
	})
}


/// ��ǰ�û�Ȩ��
function GetIsPerFlag(CstID){

	var IsPerFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTFolUpVis","GetIsPerFlag",{"CstID":CstID,"LgParam":LgParam},function(jsonString){
		if (jsonString != ""){
			IsPerFlag = jsonString;
		}
	},'',false)
	return IsPerFlag
}

//��ǰ��¼�Ƿ���Է���
function GetIsFloVis(CstID,MCDate){
	var IsFloVis = ""; /// �Ƿ�������
	runClassMethod("web.DHCMDTFolUpVis","GetIsFloVis",{"CstID":CstID,"McDate":MCDate},function(jsonString){
		if (jsonString != ""){
			IsFloVis = jsonString;
		}
	},'',false)
	return IsFloVis
	
}


/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
