//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-04-19
// ����:	   mdt���ﴦ��
//===========================================================================================
var mdtID = "";         /// ��������ID
var editSelRow = -1;
var isEditFlag = 0;     /// ҳ���Ƿ�ɱ༭
var CstOutFlag = "N";   /// Ժ�ʻ����־
var CsNoType = "";      /// ���ﵥ������ ҽ��/��ʿ/MDT
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var LODOP="";
var ItemTypeArr = [{"value":"N","text":$g("δ�շ�")}, {"value":"Y","text":$g("���շ�")}];
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
var del = String.fromCharCode(2);
var defaultCardTypeDr=""; /// Ĭ�Ͽ�����
var m_CCMRowID = "" ;
var m_CardNoLength = "";  /// ���ų���
var selMdtMakResID = ""; /// ��ǰѡ������ԴID

/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	
	/// ��ʼ�����ز����б�
	InitPatList();
	
	/// ��ʼ�����˻�����Ϣ
	InitPatInfoPanel();
	
	/// ��ʼ��Ĭ�Ͽ�����
	initCardTypeCombobox();
	
	multi_Language();
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	CsNoType = getParam("CsType");  /// ���ﵥ������
}

/// ��ʼ�����˻�����Ϣ
function InitPatInfoPanel(){
	
	/// ��ʼ����
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-7));
	
	/// ��������
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	//������
	$('#CardTypeDr').combobox({
		url:$URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=CardTypeDefineListBroker",
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		onChange: function (n,o) {
			var CardTypeDefArr = n.split("^");
	        m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
			m_CCMRowID = CardTypeDefArr[14];
			$('#PatCardNo').val("");
	        if (CardTypeDefArr[16] == "Handle"){
		    	$('#PatCardNo').attr("readOnly",false);
		    }else{
				$('#PatCardNo').attr("readOnly",true);
			}

		}
	})
	
	/// �������
	$HUI.combobox("#CstRLoc",{
		//url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonAllLoc&HospID="+LgHospID,
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	
	/// ����״̬
	$HUI.combobox("#consStatus",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=GetListMdtStatus&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	      
	    }	
	})	
	
	/// ���Ѳ���
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})
	/// �շ�״̬
	$HUI.combobox("#ChargeFlag",{
		url:'',
		data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	$HUI.combobox("#AuditFlag").setValue("N");
	
	/// �ǼǺ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
	///  ����
	$('#PatCardNo').bind('keypress',PatCardNo_KeyPress);
	
}

/// ���Żس�
function PatCardNo_KeyPress(e){
	
	if(e.keyCode == 13){
		var CardNo = $("#PatCardNo").val();
		if (CardNo == ""){
			return;
		}
		var CardNoLen = CardNo.length;
		if ((CardNo == "")||(m_CardNoLength < CardNoLen)){
			$.messager.alert("��ʾ:","�����������,������¼�룡");
			return;
		}

		/// ���Ų���λ��ʱ��0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		$("#PatCardNo").val(CardNo);

		///  ���ݿ���ȡ�ǼǺ�
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){

			if (jsonString ==-1){
				$.messager.alert("��ʾ:","��ǰ����Ч,�����ԣ�");
				return;

			}else{
				EmPatNo = jsonString;
			}
			
		},'text',false)
		if(EmPatNo == "") return;
		$("#PatNo").val(EmPatNo);		/// �ǼǺ�
		QryPatList();  /// ��ѯ
	}
}

/// ҳ��DataGrid��ʼ������ѡ�б�
function InitPatList(){
	///  ����columns
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'���Ѳ���',width:140},
		{field:'PrvDesc',title:'�ű�',width:120},
		{field:'PreTime',title:'ԤԼʱ��',width:180},
		{field:'PatName',title:'����',width:100},
		{field:'PatSex',title:'�Ա�',width:60},
		{field:'PatAge',title:'����',width:60},
		{field:'PatNo',title:'����ID',width:100},
		{field:'PayMony',title:'�շ�״̬',width:80,formatter:
			function (value, row, index){
				if (value == "δ�շ�"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatus',title:'����״̬',width:80,formatter:
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
		{field:'PatLoc',title:'�������',width:120},
		{field:'PatDiag',title:'���',width:140},
		{field:'CstRLoc',title:'����������',width:120},
		{field:'CstRUser',title:'�������ҽʦ',width:100},
		{field:'CstRTime',title:'����ʱ��',width:160},
		{field:'CstLocArr',title:'�μӻ������',width:220},
		{field:'CstPrvArr',title:'�μӻ���ҽʦ',width:220},
		{field:'MedicareNo',title:'������',width:120},
		{field:'PatTelH',title:'���˵绰',width:150},
		{field:'CstTrePro',title:'��Ҫ����',width:400,formatter:SetCellField},
		{field:'CstPurpose',title:'�������ɼ�Ҫ��',width:400,formatter:SetCellField},
		{field:'CstNPlace',title:'����ص�',width:200},
		{field:'ID',title:'ID',width:100},
		{field:'mdtMakResID',title:'mdtMakResID',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true},
		{field:'MakResDate',title:'ԤԼ����',width:100,hidden:true},
		{field:'prtime',title:'��ǰ����',width:100,hidden:true},
		{field:'CstCUser',title:'���ҽʦ',width:100},
		{field:'McNotes',title:'��ע',width:100}
	]];
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			BindTips(); /// ����ʾ��Ϣ
		},
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID, rowData.ID);
        },
        rowStyler:function(rowIndex, rowData){
			if((rowData.CstStatus!="����")&(rowData.CstStatus!="���")&(rowData.prtime>rowData.MakResDate)&(rowData.PreTime!="")){
				return 'background-color:	#FFC0CB;';
			}
		}
	};
	/// ��������
	var PatNo = $("#PatNo").val();
	var param = "^^^"+ PatNo +"^^^^^^^^"+ QryType;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetMdtAudit&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
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
	//var PatNo = $("#PatNo").val();    /// �ǼǺ�
	var PatNo = $("#PatNo").val();
	var RLocID = $HUI.combobox("#CstRLoc").getValue()||"";       /// ��������
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// ���Ѳ���
	var ChargeFlag = $HUI.combobox("#ChargeFlag").getValue()||"";  /// �շ�״̬
	var consStatus = $HUI.combobox("#consStatus").getValue()||"";
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ PatNo +"^"+ mdtDisGrp +"^^^^^"+ChargeFlag+"^"+consStatus +"^"+ QryType;
	$("#bmDetList").datagrid("load",{"Params":params}); 
}

/// ��дMDT����
function WriteMdt(EpisodeID, mdtID){

	var Link = "dhcmdt.write.csp?EpisodeID="+EpisodeID +"&ID="+mdtID+"&seeCstType=1";
	mdtPopWin(1, Link); /// ����MDT���ﴦ����
}

/// ����MDT���ﴦ����
function mdtPopWin(WidthFlag, Link){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		iconCls:'icon-w-paper',
		closed:"true"
	};
	var mdtWinTitle = "";
	if (WidthFlag == 2) mdtWinTitle = $g("����");
	if (WidthFlag == 3) mdtWinTitle = $g("ǩ��");
	if (WidthFlag == 4) mdtWinTitle = $g("MDT����ִ��");
	if (WidthFlag == 5) mdtWinTitle = $g("�޸���Դ");
	if (WidthFlag == 1){
		$("#mdtPopFrame").attr("src",Link);
		new WindowUX($g('MDT����鿴'), 'mdtPopWin', 950, (window.screen.availHeight - 150), option).Init();
	}else if (WidthFlag == 5){
		$("#mdtResFrame").attr("src",Link);
		new WindowUX(mdtWinTitle, 'mdtResWin', 910, 460, option).Init();
	}else{
		$("#mdtFrame").attr("src",Link);
		new WindowUX(mdtWinTitle||$g('MDT�޸�ҽ��'), 'mdtWin', 1400, 630, option).Init();
	}
}

/// ��ӡ
function Print(){
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('��ʾ',"��ǰ�����ѳ��������ܴ�ӡ!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	if(PrintWay==1){
	    window.open("dhcmdt.printconsmdtopin.csp?CstID="+mCstID);
	}else{
	    PrintCons(mCstID);  /// ��ӡ�������뵥	
	}
	
	$("#bmDetList").datagrid("reload");
	return;
}

/// ��ӡ��֪��
function printZQTYS(){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if (rowData.PayMony == "δ�շ�"){
		$.messager.alert('��ʾ',"��ǰ����δ�շѣ����ܴ�ӡ!","error");
		return;
	}
	
	if (GetIsOperFlag(rowData.ID, "10") == "1"){
		$.messager.alert('��ʾ',"��ǰ�����ѳ��������ܴ�ӡ!","error");
		return;
	}
	
	var mCstID = rowData.ID;
	
	// printConsent(mCstID);
	PrintCst_REQ(mCstID,mdtDisGrp);  /// ��ӡ�������뵥
	InsCsMasPrintFlag(mCstID,"Z"); ///�޸������ӡ�ֶ� 
	/// sendMsgToPat(mCstID); /// ��ӡ֪ͨ��ʱ������Ϣ
	$("#bmDetList").datagrid("reload");
	return;
}


/// �ܾ���������
function InsCsRefAuditNew(mdtID){
	
	var CstNote = "������˲�ͨ��";
	/// ����
	runClassMethod("web.DHCMDTConsult","InsCsRefAudit",{"mdtID":mdtID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ƿ���״̬�������������˲�����","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�����ɹ���","info");
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// �ܾ���������
function InsCsRefAudit(){
	
	var mdtID = $("#TmpID").val();          /// ���ػ���ID
	var CstNote = $("#CstRefReason").val(); /// ���ػ���ԭ��
	CstNote = $_TrsSymbolToTxt(CstNote);    /// �����������
	/// ����
	runClassMethod("web.DHCMDTConsult","InsCsRefAudit",{"mdtID":mdtID, "UserID":LgUserID, "CstNote":CstNote},function(jsonString){
		if (jsonString == -1){
			$.messager.alert("��ʾ:","���뵥�Ƿ���״̬����������в��ز�����","warning");
			return;
		}
		if (jsonString == 0){
			$.messager.alert("��ʾ:","�����ɹ���","info");
			$('#newRefOpWin').dialog('close');  /// �رղ��ش���
			$("#bmDetList").datagrid("reload");
		}
	},'',false)
}

/// ����MDT���ﴦ����
function mdtHandleWin(FlagCode){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	if ((FlagCode != "P")&(FlagCode != "U")&(FlagCode != "R")&(rowData.PayMony == "δ�շ�")){
		$.messager.alert('��ʾ',"��ǰ����δ�շѣ����ܽ��д˲���!","error");
		return;
	}
	
	if ((FlagCode == "P")&(GetIsOperFlag(rowData.ID, "20") != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬�����������"+ (FlagCode == "P"?"����":"��") +"������","warning");
		return;
	}

	var itmCodes = (HasCenter == 1)?"30^40":"20^40"; /// ��������ʱ�������ں���״̬�������޸���Դ
	if ((FlagCode == "R")&(GetIsTakOperFlag(rowData.ID, itmCodes) != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
		return;
	}
	
	var itmCodes = (HasCenter == 1)?"30":"20"; /// ��������ʱ�������ں���״̬������ǩ��
	if ((FlagCode == "W")&(GetIsOperFlag(rowData.ID, itmCodes) != "1")){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
		return;
	}

	var Link = ""; WidthFlag = 0;
	if (FlagCode == "P"){
		WidthFlag = 2;
		Link = "dhcmdt.makeresplan.csp?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID;
	}else if (FlagCode == "W"){
		WidthFlag = 3;
		Link = "dhcmdt.conssignin.csp?ID="+rowData.ID;
	}else if (FlagCode == "U"){
		Link = "dhcmdt.updconsdoc.csp?ID="+rowData.ID +"&DisGrpID="+ rowData.DisGrpID;
	}else if (FlagCode == "R"){
		selMdtMakResID = rowData.mdtMakResID; /// ��ԴID
		Link = "dhcmdt.makeresources.csp?ID="+rowData.ID +"&mdtMakResID="+rowData.mdtMakResID+"&DisGrpID="+ rowData.DisGrpID +"&EpisodeID="+ rowData.EpisodeID;
		$("#mdtID").val(rowData.ID);  /// mdt ����ID
		WidthFlag = 5;
	}else{
		Link = "dhcmdt.execonclusion.csp?EpisodeID="+rowData.EpisodeID +"&ID="+rowData.ID;
		WidthFlag = 1;
	}

	mdtPopWin(WidthFlag, Link); /// ����MDT���ﴦ����
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

/// �����Ŀ����ʾ��
function BindTips(){
	
	var html='<div id="tip" style="border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// ����뿪
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="CstTrePro"],td[field="CstPurpose"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// ����
function mdtSend(){
	
	$.messager.alert('������ʾ',"���ͳɹ���","success");
}

/// �˺�
function RetMakRes(){
	
	var rowData = $('#bmDetList').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	$.messager.confirm('ȷ�϶Ի���','�˺Ż��ͷŴ˺ű�ԤԼ��Դ������ֹͣ����ҽ������ȷ��Ҫ���д˲�����', function(r){
		if (r){
			/// ����
			runClassMethod("web.DHCMDTConsult","RetMakRes",{"CstID":rowData.ID, "LgParams":LgParam},function(jsonString){
				if (jsonString == -1){
					$.messager.alert("��ʾ:","���뵥��ǰ״̬������������˺Ų�����","warning");
					return;
				}
				if (jsonString == -2){
					$.messager.alert("��ʾ:","���շ����벻������������д�˷����룡","warning");
					return;
				}
				if (jsonString == -3){
					$.messager.alert("��ʾ:","ҽ����ִ�У��뻤ʿ�ȳ���ִ�У�","warning");
					return;
				}
				if (jsonString < 0){
					$.messager.alert("��ʾ:","�˺�ʧ�ܣ�","warning");
					return;
				}
				if (jsonString == 0){
					$.messager.alert("��ʾ:","�˺ųɹ���","info");
					$("#bmDetList").datagrid("reload");
				}
			},'',false)
		}
	});
}

/// �޸���Դʱ��
function TakMakResDate(){
	
	//if (!frames[2].GetPatMakRes()) return;
	if (!document.getElementById('mdtResFrame').contentWindow.GetPatMakRes()) return;
	var mdtID = $("#mdtID").val();  /// mdt ����ID
	var mdtPreData = $("#mdtPreDate").val();       /// ԤԼ����
	var mdtPreTime = $("#mdtPreTime").val();       /// ԤԼʱ��
	var mdtMakResID = $("#mdtMakResID").val();     /// �����ID
	if (mdtMakResID == selMdtMakResID){
		$.messager.alert("��ʾ:","����ѡ��ԤԼ��Դ��","warning");
		return;
	}
	var makResParams = mdtPreData +"^"+ mdtPreTime +"^"+ mdtMakResID;     /// �����ID
	$.messager.confirm('ȷ�϶Ի���','��ȷ��Ҫ������ʱ���޸�Ϊ��'+ mdtPreData +" "+ mdtPreTime +'��', function(r){
		if (r){
			runClassMethod("web.DHCMDTConsult","TakMakResDate",{"mdtID":mdtID, "LgParams":LgParam, "makResParams":makResParams},function(jsonString){
				if (jsonString == -1){
					$.messager.alert("��ʾ:","���뵥��ǰ״̬������������޸�ʱ�������","warning");
					return;
				}
				if (jsonString < 0){
					$.messager.alert("��ʾ:","�޸�ʧ�ܣ�ʧ��ԭ��"+ jsonString +"��","warning");
					return;
				}
				if (jsonString == 0){
					$.messager.alert("��ʾ:","�޸ĳɹ���","info");
					ClsWin(); /// �رմ���
					$("#bmDetList").datagrid("reload");
				}
			},'',false)
		}
	});
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

/// �رմ���
function ClsWin(){
	
	$("#mdtResWin").window("close"); 
}

/// ��ӡ֪ͨ��ʱ������Ϣ
function sendMsgToPat(mCstID){
	runClassMethod("web.DHCMDTInterface","SendMsgProxy",{"ID":mCstID,"Type":"F"},function(jsonString){
	},'',false)
}

/// ��ʼ��ҳ�濨���Ͷ���
function initCardTypeCombobox(){
	
	/// ��ȡĬ�Ͽ�����
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
        m_CCMRowID = CardTypeDefArr[14];
        if (CardTypeDefArr[16] == "Handle"){
	    	$('#PatCardNo').attr("readOnly",false);
	    }else{
			$('#PatCardNo').attr("readOnly",true);
		}
		$("#CardTypeDr").combobox("setValue",defaultCardTypeDr);
	},'',false)
}

/// ��ȡ���˶�Ӧ����������
function GetEmPatCardTypeDefine(CardTypeID){
    
	runClassMethod("web.DHCPUECommonData","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#PatCardNo').attr("readOnly",false);
			}else{
				$('#PatCardNo').attr("readOnly",true);
			}
			$("#CardTypeDr").combobox("setValue",CardTypeDefine);
		}
	},'text')
}

// ���� 44638842
function readcard(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=$('#CardTypeDr').combobox('getValue');
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	switch (rtn){
		case "0": //����Ч
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId){
				GetEmPatCardTypeDefine(NewCardTypeRowId);	
			}
			clearSignRegWin()//���
			$('#PatNo').val(PatientNo); //�ǼǺ�
			$('#PatCardNo').val(CardNo); //����
			QryPatList();	
			break;
		case "-200": //����Ч
			clearSignRegWin()//���
			$.messager.alert('��ʾ��','�˿���Ч��');
			break;
		case "-201": //�ֽ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId){
				GetEmPatCardTypeDefine(NewCardTypeRowId);		
			}
         	clearSignRegWin()//���
			$('#PatNo').val(PatientNo); //�ǼǺ�
			$('#PatCardNo').val(CardNo); //����
			break;
		default:
	}
}

//������id
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=$('#CardTypeDr').combobox('getValue');
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

/// ���
function clearSignRegWin(){
	
	$('#PatCardNo').val("");  //����
	$('#PatNo').val(""); //����id	
}

/// ��ӱ�ע
function AddNotes(){
	
    var rowData = $('#bmDetList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	var linkUrl ="dhcmdt.addnotes.csp?ID="+rowData.ID+"&DisGrpID="+ rowData.DisGrpID+"&EpisodeID="+ rowData.EpisodeID;
	commonShowWin({
		url: linkUrl,
		title: $g("��ע"),
		width: 700,
		height: 340
	})	
}

/// �޸�ר��
function modProWin(){
	
    var rowData = $('#bmDetList').datagrid('getSelected');
    if (rowData == null){
		$.messager.alert('��ʾ',"����ѡ��һ�м�¼!","error");
		return;
	}
	
	var itmCodes = (HasCenter == 1)?"30^40":"20^40"; /// ��������ʱ�������ں���״̬������༭
	if (GetIsTakOperFlag(rowData.ID, itmCodes) != "1"){
		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
		return;
	}
	
//	if ((GetIsOperFlag(rowData.ID, "30") != "1")&(GetIsOperFlag(rowData.ID, "40") != "1")){
//		$.messager.alert("��ʾ:","���뵥��ǰ״̬����������д˲�����","warning");
//		return;
//	}
	
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
	$g("�����������,������¼�룡");
	$g("��ǰ����Ч,�����ԣ�");
	$g("����ѡ��һ�м�¼!");
	$g("��ǰ�����ѳ��������ܴ�ӡ!");
	$g("��ǰ����δ�շѣ����ܴ�ӡ!");
	$g("���뵥�Ƿ���״̬�������������˲�����");
	$g("���뵥�Ƿ���״̬����������в��ز�����");
	$g("��ǰ����δ�շѣ����ܽ��д˲���!");
	$g("���뵥��ǰ״̬�����������");
	$g("����");
	$g("��");
	$g("������");
	$g("�ǼǺ��������");
	$g("�˺Ż��ͷŴ˺ű�ԤԼ��Դ������ֹͣ����ҽ������ȷ��Ҫ���д˲�����");
	$g("���뵥��ǰ״̬������������˺Ų�����");
	$g("����ѡ��ԤԼ��Դ��");
	$g("��ȷ��Ҫ������ʱ���޸�Ϊ��");
	$g("��");
	$g("ȷ�϶Ի���");
	$g("���뵥��ǰ״̬������������޸�ʱ�������");
	$g("�޸�ʧ�ܣ�ʧ��ԭ��");
	$g("�˿���Ч��");
	$g("���뵥��ǰ״̬����������д˲�����");
	$g("�����ɹ���");
	$g("�޸ĳɹ���");
	$g("�˺ųɹ���");
	$g("������ʾ");
	$g("���ͳɹ���");
}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
