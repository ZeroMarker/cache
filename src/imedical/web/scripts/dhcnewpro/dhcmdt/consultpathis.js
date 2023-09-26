//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-04-19
// ����:	   mdt���ﴦ��
//===========================================================================================
var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mdtID = "";         /// ��������ID
var editSelRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var CstOutFlag = "N";   /// Ժ�ʻ����־
var CsNoType = "";      /// ���ﵥ������ ҽ��/��ʿ/MDT
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var TimesArr = [{"value":"1","text":'1'}, {"value":"2","text":'2'}, {"value":"3","text":'3'}, {"value":"4","text":'4'}, {"value":"5","text":'5'}
                 , {"value":"6","text":'6'}, {"value":"7","text":'7'}, {"value":"8","text":'8'}, {"value":"9","text":'9'}, {"value":"10","text":'10'}];
var LODOP="";
var del = String.fromCharCode(2);

/// ҳ���ʼ������
function initPageDefault(){
	
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	/// ��ʼ�����˻�����Ϣ
	InitPatInfoPanel();
	
	QryPatList();
	
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");
	
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// �������
	$HUI.combobox("#CstRLoc",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	/// ���Ѳ���
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})	
	
	$HUI.combobox("#TimesArr",{
		url:'',
		data : TimesArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'���Ѳ���',width:140},
		{field:'PrvDesc',title:'�ű�',width:120},
		{field:'PreTime',title:'ԤԼʱ��',width:140},
		{field:'PayMony',title:'�շ�״̬',width:80,formatter:
			function (value, row, index){
				if (value == "δ�շ�"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatusDesc',title:'����״̬',width:80,formatter:
			function (value, row, index){
				if (value == "����"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},{field:'PrintFlag',title:'��ӡ',width:80,align:'center',hidden:true,formatter:
			function (value, row, index){
				if (value.indexOf("Y")!=-1){return '<font style="color:green;font-weight:bold;">�Ѵ�ӡ</font>'}
				else {return '<font style="color:red;font-weight:bold;">δ��ӡ</font>'}
			}
		},{field:'PrintCons',title:'��ӡ��֪��',width:80,align:'center',formatter:
			function (value, row, index){
				
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">�Ѵ�ӡ</font>'}
				else {return '<font style="color:red;font-weight:bold;">δ��ӡ</font>'}
			}
		},
		{field:'PatNo',title:'�ǼǺ�',width:100},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60},
		{field:'PatAge',title:'����',width:60},
		{field:'MCTimes',title:'�ڼ��λ���',width:120},
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatDiag',title:'���',width:140},
		{field:'CstRLoc',title:'����������',width:120},
		{field:'CstRUser',title:'�������ҽʦ',width:100},
		{field:'CstRTime',title:'����ʱ��',width:160},
		{field:'CstLocArr',title:'�μӻ������',width:220},
		{field:'CstPrvArr',title:'�μӻ���ҽʦ',width:220},
		{field:'CstNPlace',title:'����ص�',width:200},
		{field:'ID',title:'ID',width:100},
		{field:'mdtMakResID',title:'mdtMakResID',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0){
				InsPageConsult({CstTrePro:"",CstPurpose:"",TreMeasures:""})
				return;
			}
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			$("#bmDetList").datagrid('selectRow',0)
			InsPageConsult(rowData);	
		
		},
		onClickRow: function (rowIndex, rowData) {
			InsPageConsult(rowData);
        },
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID);
        },
	};
	/// ��������
	var param = "^^^^" + PatientID +"^"+ EpisodeID +"^"+TimesArr;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetPatHisCons&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
  
  
}

/// ��ѯ
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// ��ʼ����
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// ��������
	var RLocID = $HUI.combobox("#CstRLoc").getValue()||"";       /// ��������
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// ���Ѳ���
	var TimesArr = $HUI.combobox("#TimesArr").getValue()||"";  /// ���Ѳ���
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ mdtDisGrp +"^"+ PatientID +"^"+ EpisodeID+"^"+TimesArr;
	$("#bmDetList").datagrid("load",{"Params":params});
}

/// ��дMDT����
function WriteMdt(EpisodeID, CstID){

		$("#newWinFrame").attr("src","dhcmdt.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID);
	
}
/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// �����¼
function InsPageConsult(jsonObj){
	
	$("#ConsTrePro").text($_TrsTxtToSymbol(jsonObj.CstTrePro));    /// ����ժҪ
	$("#ConsPurpose").text($_TrsTxtToSymbol(jsonObj.CstPurpose));  /// ����Ŀ��
	$("#TreMeasure").text($_TrsTxtToSymbol(jsonObj.TreMeasures));  /// ����Ŀ��
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

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
