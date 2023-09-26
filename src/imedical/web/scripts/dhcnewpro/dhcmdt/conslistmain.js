//===========================================================================================
// ���ߣ�      qqa
// ��д����:   2019-04-23
// ����:	   �����ѯ����
//===========================================================================================

var showModel="1";
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// ҳ���ʼ������
function initPageDefault(){
		
	initCombobox();	  /// ��ʼ��combobox
	
	initDatagrid();	  /// ��ʼ��datagrid
	
	initMethod();     /// ���¼�
	
	multi_Language(); /// ������֧��
}

function initCombobox(){

	/// ��ʼ����
	$HUI.datebox("#startDate").setValue(GetCurSystemDate(-7));
	
	/// ��������
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	/// ����״̬
	$HUI.combobox("#consStatus",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})	
	
	/// ���Ѳ��� 
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        qryConsList();
	    }	
	})
	
	$("#bt_make").linkbutton('disable'); /// ����ť
	$("#bt_acc").linkbutton('disable');  /// ������ť
	$("#bt_exe").linkbutton('disable');  /// ִ�а�ť
}

function initDatagrid(){
	///  ����columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'���Ѳ���',width:140},
		{field:'PrvDesc',title:'�ű�',width:120},
		{field:'PreTime',title:'ԤԼʱ��',width:180},
		{field:'PayMony',title:'�շ�״̬',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "δ�շ�"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatus',title:'����״̬',width:80,align:'center',formatter:
			function (value, row, index){
				if (value == "����"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'isAccFlag',title:'�Ƿ����',width:80,align:'center'},
		{field:'PatNo',title:'����ID',width:100},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60},
		{field:'PatAge',title:'����',width:60},
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatDiag',title:'���',width:140},
		{field:'CstRLoc',title:'����������',width:120},
		{field:'CstRUser',title:'�������ҽʦ',width:100},
		{field:'CstRTime',title:'����ʱ��',width:160},
		{field:'CstTrePro',title:'��Ҫ����',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'�������ɼ�Ҫ��',width:400,formatter:SetCellField},
		{field:'CstLocArr',title:'�μӻ������',width:220},
		{field:'CstPrvArr',title:'�μӻ���ҽʦ',width:220},
		{field:'CstNPlace',title:'����ص�',width:200},
		{field:'PrintFlag',title:'��ӡ',width:80,align:'center',formatter:
			function (value, row, index){
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">�Ѵ�ӡ</font>'}
				else {return '<font style="color:red;font-weight:bold;">δ��ӡ</font>'}
			}
		},
		{field:'ID',title:'ID',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100}
	]];
	
	var option = {
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
			setConsNum(data); /// ����ʾ��Ϣ
		},
		onDblClickRow: function (rowIndex, rowData) {
			showMdtDetail(rowData.EpisodeID, rowData.ID);
        },
       	onClickRow:function (rowIndex, rowData) {
			// setEprFromData(rowData);
        },
        rowStyler:function(rowIndex, rowData){
			if (rowData.AuditFlag == "����"){
				return 'background-color:pink;';
			}
		}
	};
	/// ��������
	var param = getParams();
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtQuery&Params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init(); 
	
}

function showMdtDetail(EpisodeID,mdtID){
	var Link = "dhcmdt.write.csp?EpisodeID="+EpisodeID +"&ID="+mdtID; //+"&seeCstType=1";
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-paper',
		closed:"true"
	};

	$("#mdtPopFrame").attr("src",Link);
	new WindowUX($g('MDT����鿴'), 'mdtPopWin', 950, (window.screen.availHeight - 150), option).Init();
	
}

function setConsNum(data){
	
	// ��������
	var cstUserNumText = $("#cstUserNum").linkbutton("options").text;
	if (cstUserNumText != ""){
		$('#cstUserNum').linkbutton({ text: cstUserNumText.split("(")[0] + "(" + data.IsCstUserNum +")" });
	}
	// ���˻���
	var IsCsUserNumText = $("#csUserNum").linkbutton("options").text;
	if (IsCsUserNumText != ""){
		$('#csUserNum').linkbutton({ text: IsCsUserNumText.split("(")[0] + "(" + data.IsCsUserNum +")" });
	}
	// �������
	var cstUserNumText = $("#GroupUserNum").linkbutton("options").text;
	if (IsCsUserNumText != ""){
		$('#GroupUserNum').linkbutton({ text: cstUserNumText.split("(")[0] + "(" + data.IsGroupUserNum +")" });
	}

//	$("#cstUserNum").html("��������(" + data.IsCstUserNum +")");
//	$(".l-btn-text:contains('���˻���')").html("���˻���(" + data.IsCsUserNum +")");
//	$(".l-btn-text:contains('�������')").html("�������(" + data.IsGroupUserNum +")");	
	return;
}

function qrySelfSend(type){
	
	if(type=="1"){
		$('#bt_acc').linkbutton({text:$g('����')});
		if($("#cstUserNum").hasClass("btn-select")) return;
		$("#csUserNum").removeClass("btn-select");
		$("#cstUserNum").addClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#bt_cancel").linkbutton('enable');  /// ȡ�����ﰴť
		$("#bt_acc").linkbutton('disable');  /// ������ť
		$("#bt_exe").linkbutton('disable');  /// ִ�а�ť
		$("#bt_make").linkbutton('disable'); /// ����ť
		$("#bt_Revisionexp").linkbutton('enable');  /// �޸�ר��
		
		$("#bt_make").show(); /// ����ť
		$("#bt_acc").show();  /// ������ť
		$("#bt_exe").show();  /// ִ�а�ť	
		$("#bt_cancel").show();	
		$("#bt_Revisionexp").show();  /// �޸�ר��
	}
	
	if(type=="2"){
		$('#bt_acc').linkbutton({text:$g('����')});
		if($("#csUserNum").hasClass("btn-select")) return;
		$("#cstUserNum").removeClass("btn-select");
		$("#csUserNum").addClass("btn-select");
		$("#GroupUserNum").removeClass("btn-select");
		$("#bt_Revisionexp").linkbutton('disable');  /// �޸�ר��
		$("#bt_exe").linkbutton('disable');
		$("#bt_acc").linkbutton('enable');  /// ������ť
		$("#bt_exe").linkbutton('enable');  /// ִ�а�ť
		$("#bt_make").linkbutton('enable'); /// ����ť
		
		$("#bt_make").show(); /// ����ť
		$("#bt_acc").show();  /// ������ť
		$("#bt_exe").show();  /// ִ�а�ť	
		$("#bt_cancel").show();
		$("#bt_Revisionexp").show();  /// �޸�ר��
	}
	
	if(type=="3"){
		if($("#GroupUserNum").hasClass("btn-select")) return;
		$("#cstUserNum").removeClass("btn-select");
		$("#csUserNum").removeClass("btn-select");
		$("#GroupUserNum").addClass("btn-select");
		$("#bt_Revisionexp").hide();  /// �޸�ר��
	    
		$("#bt_acc").hide();  /// ������ť
		$("#bt_exe").hide();  /// ִ�а�ť	
		$("#bt_cancel").hide();	
		$("#bt_make").hide();	
			
	}
	showModel = type;
	qryConsList();
	return;
}

function qryConsList(){
	var params = getParams();
	$("#PatList").datagrid("load",{"Params":params}); 
}

function getParams(){
	var params="";
	var stDate = $HUI.datebox("#startDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();
	var argLocID = "";
	var argPatNo = $("#regNo").val();
	var PatName = $("#PatName").val();
	var argDisGrp = $HUI.combobox("#mdtDisGrp").getValue();
	var consStatus = $HUI.combobox("#consStatus").getValue();
	
	var LgUserID  = session['LOGON.USERID'];
	params = stDate+"^"+endDate+"^"+argLocID+"^"+argPatNo+"^"+(argDisGrp||"")+"^"+(consStatus||"")+"^"+showModel+"^"+LgUserID +"^"+ PatName +"^^"+ HasCenter;
	return params;	
}

/// �ǼǺ�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#regNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  �ǼǺŲ�0
			$("#regNo").val(GetWholePatNo(PatNo));
		}
		qryConsList();  /// ��ѯ
	}
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCMDTCom","GetPatRegNoLen",{},function(jsonString){

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

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

function initMethod(){
	$("#regNo").bind('keypress',PatNo_KeyPress);
}


/// ������Ϣ
function PatBaseWin(){
	
	var rowData = $('#PatList').datagrid('getSelected');
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
	/// �°没��
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

function setEprFromData(rowData){
	var EpisodeID = rowData.AppAdmID;   //ԤԼ�Һ�
	var PatientID = rowData.PatientID;
	if(EpisodeID==""){
		return;	
	}
	setEprMenuForm (EpisodeID,PatientID,"","");
	return;
}

var setEprMenuForm = function(adm,papmi,mradm,canGiveBirth){
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		frm.mradm.value = mradm; 				//DHCDocMainView.EpisodeID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if (frm.canGiveBirth) frm.canGiveBirth.value = canGiveBirth;
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}

function cancelMdtCons(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	if (rowData.CstStatus != "����"){
		$.messager.alert('��ʾ',"��ǰ���뵥�Ƿ���״̬��������������","error");
		return;
	}
	
//	if(rowData.PayMony=="���շ�"){
//		$.messager.alert('��ʾ',"��ǰ���뵥�Ѿ��շѣ�������������","error");
//		return;
//	}
	var CstID =  rowData.ID;
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫ������ǰ����������', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","CancelMdtCons",{"CstID":CstID, "LgParam":LgParam},function(jsonString){

				if (jsonString < 0){
					if(jsonString==-2) {
						$.messager.alert("��ʾ:","��ǰ״̬�Ƿ���״̬����������");
					}else if(jsonString==-1){
						$.messager.alert("��ʾ:","���շ����벻������������д�˷����룡");
					}else if(jsonString==-3){
						$.messager.alert("��ʾ:","ҽ����ִ�У��뻤ʿ�ȳ���ִ�У�");
					}else{
						$.messager.alert("��ʾ:","��������ʧ�ܣ�ʧ��ԭ��:"+jsonString);
					}
				}else{
					$.messager.alert("��ʾ:","�����ɹ���","info");
					qryConsList();
				}
			},'text',false)
		}
	});
}


/// ����mdt����
function mdtSend(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (rowData.CstStatus != ""){
		$.messager.alert('��ʾ',"��ǰ״̬��Ϊ����״̬���������ͣ�","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID;
	var CstID = rowData.ID;
	
	/// ��֤�����Ƿ�����ҽ��
	TakOrdMsg = GetPatNotTakOrdMsg(EpisodeID);
	if (TakOrdMsg != ""){
		$.messager.alert("��ʾ:",TakOrdMsg,"warning");
		return;	
	}
	
	/// ����ж�
	if (GetMRDiagnoseCount(EpisodeID) == 0){
		$.messager.alert("��ʾ:","����û�����,����¼�룡","warning",function(){DiagPopWin()});
		return;	
	}
	
	/// ҽ�ƽ����ж�
	if (GetIsMidDischarged(EpisodeID) == 1){
		$.messager.alert("��ʾ:","�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����","warning");
		return;	
	}
	
	if (CstID == ""){
		$.messager.alert("��ʾ:","�뱣�����������ٷ��ͣ�","warning");
		return;
	}
	
	runClassMethod("web.DHCMDTConsult","SendCstNo",{"CstID": CstID, "LgParam":LgParam,"IpAddress":ClientIPAddress},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�ѷ��ͣ������ٴη��ͣ�","warning");
			return;
		}
		if (jsonString < 0){
			if(jsonString==-12){
				$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ�����Ѿ����е��մ˺ű𣬲������ٴ�ԤԼ��","warning");		
			}
			$.messager.alert("��ʾ:","�������뷢��ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			//isShowPageButton();     /// ��̬����ҳ����ʾ�İ�ť����
			$.messager.alert("��ʾ:","���ͳɹ���","info");
			qryConsList();
		}
	},'',false)
}


/// ��֤�����Ƿ�����ҽ��
function GetPatNotTakOrdMsg(EpisodeID){

	var NotTakOrdMsg = "";
	/// ��֤�����Ƿ�����ҽ��
	runClassMethod("web.DHCAPPExaReport","GetPatNotTakOrdMsg",{"LgGroupID":LgGroupID,"LgUserID":LgUserID,"LgLocID":LgLocID,"EpisodeID":EpisodeID},function(jsonString){

		if (jsonString != ""){
			NotTakOrdMsg = jsonString;
		}
	},'',false)

	return NotTakOrdMsg;
}

/// ��ȡ���˵���ϼ�¼��
function GetMRDiagnoseCount(EpisodeID){

	var Count = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetMRDCount",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			Count = jsonString;
		}
	},'',false)

	return Count;
}

/// ��ȡҽ�ƽ����־
function GetIsMidDischarged(EpisodeID){

	var MidDischargedFlag = 0;
	/// ����ҽ��վ���ж�
	runClassMethod("web.DHCAPPExaReport","GetIsMidDischarged",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonString != ""){
			MidDischargedFlag = jsonString;
		}
	},'',false)

	return MidDischargedFlag;
}


/// ������ϴ���
function DiagPopWin(){
	
	var lnk = "diagnosentry.v8.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm;
	window.showModalDialog(lnk, "_blank", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
}

/// ��������
function mdtHandleWin(FlagCode){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var stCode = "";  /// MDT����״̬
	if (FlagCode == "P") stCode = (HasCenter == 1)?"30":"20";
	if (FlagCode == "E") stCode = "40";
	if ((FlagCode != "L")&(GetIsOperFlag(rowData.ID, stCode) != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������иò�����","warning");
		return;
	}
	
	var WriType=""; WidthFlag = 0; isShowModel = 1;
	if (FlagCode == "P") WriType = "P";
	if (FlagCode == "E") WriType = "E";
	if (FlagCode == "L") isShowModel = 3;
	var Link = "dhcmdt.execonclusion.csp?EpisodeID="+rowData.EpisodeID +"&ID="+rowData.ID +"&WriType="+WriType+"&showModel="+isShowModel;
	mdtPopWin(FlagCode, Link); /// ����MDT���ﴦ����
}

/// ����MDT���ﴦ����
function mdtPopWin(FlagCode, Link){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-w-paper',
		closed:"true"
	};
	if (FlagCode == "H"){
		new WindowUX($g('���ﴦ��'), 'newRefOpWin', 600, 290, option).Init();
	}else if (FlagCode == "R"){
		$("#mdtPopAccFrame").attr("src",Link);
		new WindowUX($g('MDT�޸�ҽ��'), 'mdtPopAccWin', (window.screen.availWidth - 100), 520, option).Init();
	}else{
		$("#mdtPopAccFrame").attr("src",Link);
		var WinTitle = "";
		if (FlagCode == "L"){
			WinTitle = $g("���ﲡ��");
		}else{
			WinTitle = FlagCode == "P"?$g("����"):$g("ִ��");
		}
		new WindowUX(WinTitle||$g('MDT��������'), 'mdtPopAccWin', 1100, (window.screen.availHeight - 150), option).Init();
	}
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

/// ����
function AcceptCstNo(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (rowData.CstStatus == "����"){
		$.messager.alert('��ʾ',"��ǰ�����ѽ��գ������ظ�����!","error");
		return;
	}
	
//	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
//		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д��������","warning");
//		return;
//	}
	var stCode = (HasCenter == 1)?"30^40":"20^40";
	if (GetIsTakOperFlag(rowData.ID, stCode) != "1"){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������иò�����","warning");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","AcceptCstMas",{"CstID":CstID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������н��ղ�����","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","���뵥�ѽ��գ������ٴν��գ�","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","�����������ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","���ճɹ���","info");
			$("#newRefOpWin").window("close");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

/// ���ﴦ��
function mdtCsHandle(){

	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}

	var stCode = (HasCenter == 1)?"30^40":"20^40";
	if (GetIsTakOperFlag(rowData.ID, stCode) != "1"){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������иò�����","warning");
		return;
	}
		
//	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
//		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д��������","warning");
//		return;
//	}
	
	$("#CstRefReason").val(rowData.CsDocRes);    /// ���ܲμ�ԭ��
	var FlagCode="H";
	mdtPopWin(FlagCode, ""); /// ����MDT���ﴦ����
}

/// �ܾ��μӻ���
function RefCstNo(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д��������","warning");
		return;
	}
	
	var CstRefReason = $("#CstRefReason").val(); /// ���ܲμ�ԭ��
	if (CstRefReason == ""){
		$.messager.alert('��ʾ',"����д�����ܲμ�ԭ��!","error");
		return;
	}
	
	var CstID =  rowData.ID;
	runClassMethod("web.DHCMDTConsult","RefCstMas",{"CstID":CstID, "LgUserID":LgUserID, "CstNote":CstRefReason},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","����Ȩ�޲�����ǰ�����뵥��","warning");
			return;
		}
		if (jsonString == -2){
			$.messager.alert("��ʾ:","���뵥�Ǵ�����״̬����������оܾ��ղ�����","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","��������ܾ�ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			//$.messager.alert("��ʾ:","�ܾ��ɹ���","info");
			$("#CstRefReason").val("");    /// ���ܲμ�ԭ��
			$("#newRefOpWin").window("close");
			$('#PatList').datagrid('reload');
		}
	},'',false)	
}

/// �Ƿ��������
function GetIsOperFlag(CstID, stCode){

	var IsModFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTConsult","GetIsOperFlag",{"CstID":CstID, "stCode":stCode},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// �Ƿ��������
function GetIsTakOperFlag(CstID, stCodes){

	var IsModFlag = ""; /// �Ƿ������޸�
	runClassMethod("web.DHCMDTConsult","GetIsTakOperFlag",{"CstID":CstID, "stCodes":stCodes},function(jsonString){

		if (jsonString != ""){
			IsModFlag = jsonString;
		}
	},'',false)
	return IsModFlag
}

/// ��ҳ�����
function reLoadMainPanel(EpisodeID){
	
	$('#PatList').datagrid('reload');
	$("#mdtPopAccWin").window("close");
//	if (EpisodeID){
//		OpenEmr(EpisodeID);
//	}
}

/// �򿪲��˵��Ӳ�������
function OpenEmr(EpisodeID){
	
	/// �°没��
	var link = "websys.chartbook.hisui.csp?&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&ChartBookID=70&PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&WardID=";
	window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// ��ӡ
function Print(){
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	var mCstID = rowData.ID;
	window.open("dhcmdt.printconsmdtopin.csp?CstID="+mCstID);
	
	$("#PatList").datagrid("reload");
	return;
}

/// ����MDT���ﴦ����
function mdtHandle(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	if ((GetIsOperFlag(rowData.ID, "20") != "1")&(GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
		return;
	}
	var Link=""
	Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;

	mdtPopWin("R", Link); /// ����MDT���ﴦ����
}

/// �޸�ר��
function modProWin(){
	
	var rowData = $('#PatList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if ((GetIsOperFlag(rowData.ID, "20") != "1")&(GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
		return;
	}
	
	var Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;
	commonShowWin({
		url: Link,
		title: $g("�޸�ר��"),
		width: 1200,
		height: 590
	})	
}

/// ������֧��
function multi_Language(){
	
	$g("��ʾ");
	$g("����ѡ��һ�м�¼!");
	$g("���뵥��ǰ״̬����������д˲�����");
	$g("��������ܾ�ʧ�ܣ�ʧ��ԭ��:");
	$g("���뵥�Ǵ�����״̬����������оܾ��ղ�����");
	$g("����Ȩ�޲�����ǰ�����뵥��");
	$g("����д�����ܲμ�ԭ��!");
	$g("���뵥��ǰ״̬����������д��������");
	$g("���뵥��ǰ״̬����������иò�����");
	$g("���ճɹ���");
	$g("�����������ʧ�ܣ�ʧ��ԭ��:");
	$g("���뵥�ѽ��գ������ٴν��գ�");
	$g("���뵥�Ǵ�����״̬����������н��ղ�����");
	$g("���뵥��ǰ״̬����������иò�����");
	$g("���ͳɹ���");
	$g("�������뷢��ʧ�ܣ�ʧ��ԭ��:");
	$g("�������뷢��ʧ�ܣ�ʧ��ԭ�����Ѿ����е��մ˺ű𣬲������ٴ�ԤԼ��");
	$g("���뵥�ѷ��ͣ������ٴη��ͣ�");
	$g("�뱣�����������ٷ��ͣ�");
	$g("�˲�������ҽ�ƽ���,������ҽ���ٿ�ҽ����");
	$g("����û�����,����¼�룡");
	$g("��ǰ״̬��Ϊ����״̬���������ͣ�");
	$g("ȡ���ɹ���");
	$g("��������ʧ�ܣ�ʧ��ԭ��:");
	$g("�Ѿ�ԤԼ�ɹ������벻��������");
	$g("��ǰ״̬�Ƿ���״̬����������");
	$g("��ȷ��Ҫȡ����ǰ����������");
	$g("ȷ�϶Ի���");
	$g("��ǰ���뵥�Ѿ��շѣ�������������");
	$g("��ǰ���뵥�Ƿ���״̬��������������");
	$g("��ѡ������¼�����ԣ�");
	$g("������ʾ");
	$g("�ǼǺ��������");
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
