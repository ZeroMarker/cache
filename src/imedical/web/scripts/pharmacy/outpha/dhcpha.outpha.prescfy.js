/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-����Ԥ����ҩ
 *createdate:2016-10-29
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 1000;
DHCPHA_CONSTANT.VAR.BODYTYPE = "";
DHCPHA_CONSTANT.VAR.OUTPHAWAY = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", "OA");
var PrintType="";
$(function () {
	if (typeof (PrescDispType) != "undefined") {
		DHCPHA_CONSTANT.VAR.BODYTYPE = PrescDispType.toUpperCase();
	}
	CheckPermission();
	var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);

	InitGridWin();
	InitFYWin();
	InitGridFY();
	InitGirdWAITFY();
	InitConfig();
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				if(newpatno==""){return;}
				QueryGridFY();
			}
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
			}
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	/* ��Ԫ���¼� end*/


	/* �󶨰�ť�¼� start*/
	$("#a-refresh").on("click", QueryGridWaitFY)
	$("#btn-find").on("click", QueryGridFY);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-fy").on("click", ExecuteFY);
	$("#btn-reffy").on("click", ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click", CancelRefuseFY);
	$("#btn-allfy").on("click", ExecuteAllFY);
	$('#btn-printlabel').on("click", RePrintLabelHandler);
	$('#btn-print').on("click", PrintHandler);
	$("#btn-win-sure").on("click", FYWindowConfirm);
	$("#btn-redir-return").on("click", function () {
		var lnk = "dhcpha/dhcpha.outpha.return.csp";
		websys_createWindow(lnk, "��ҩ", "width=95%,height=75%")
		//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$("#btn-readcard").on("click", BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/
	;
	InitBodyStyle();
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridWaitFY();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	$("#modal-windowinfo").on('shown.bs.modal', function () {
		$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			onText: "����",
			offText: "����",
			onColor: "success",
			offColor: "default",
			size: "small",
			onSwitchChange: function (event, state) {
				var ret = ChangeWinStat(state);
				if (ret == false) {
					$(this).bootstrapSwitch('state', !state, true);
				}
			}
		})
		$("#grid-window").setGridWidth($("#modal-windowinfo .div_content").width())
		$("#grid-window").HideJqGridScroll({
			hideType: "X"
		})
	})
	HotKeyInit("PrescFY","grid-fy");
})

//��ʼ����ҩtable
function InitGridFY() {
	var tmpheight = 0;
	if (DHCPHA_CONSTANT.VAR.BODYTYPE == "ONE") {
		tmpheight = DhcphaJqGridHeight(1, 1);
	} else {
		tmpheight = DhcphaJqGridHeight(2, 3) * 0.5;
	}
	var columns = [{
			header: '��ҩ״̬',
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 65,
			cellattr: addPhDispStatCellAttr
		},
		{
			header: '����',
			index: 'TPatName',
			name: 'TPatName',
			width: 100
		},
		{
			header: '�ǼǺ�',
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 100
		},
		{
			header: '�շ�����',
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 100
		},
		{
			header: '�վݺ�',
			index: 'TPrtInv',
			name: 'TPrtInv',
			width: 100,
			hidden: true
		},
		{
			header: '������',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 110
		},
		{
			header: '�������',
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 70,
			align: 'right'
		},
		{
			header: '�Ա�',
			index: 'TPerSex',
			name: 'TPerSex',
			width: 40
		},
		{
			header: '����',
			index: 'TPerAge',
			name: 'TPerAge',
			width: 40
		},
		{
			header: '���״̬',
			index: 'TDocSS',
			name: 'TDocSS',
			width: 70
		},
		{
			header: '������ҩ',
			index: 'TPassCheck',
			name: 'TPassCheck',
			width: 70,
			hidden: true
		},
		{
			header: '�����ܼ�',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		},
		{
			header: '���˼���',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 100,
			hidden: true
		},
		{
			header: '���',
			index: 'TMR',
			name: 'TMR',
			width: 200,
			align: 'left'
		},
		{
			header: 'TPrt',
			index: 'TPrt',
			name: 'TPrt',
			width: 60,
			hidden: true
		},
		{
			header: 'phdrow',
			index: 'phdrow',
			name: 'phdrow',
			width: 60,
			hidden: true
		},
		{
			header: '���',
			index: 'TNoteCode',
			name: 'TNoteCode',
			width: 50,
			hidden: true
		},
		{
			header: 'ҩ���',
			index: 'TBoxNum',
			name: 'TBoxNum',
			width: 60,
			hidden: true
		},
		{
			header: '��ҩ',
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=jsQueryFYList&style=jqGrid', //��ѯ��̨	
		height: tmpheight,
		multiselect: false,
		pager: "#jqGridPager", //��ҳ�ؼ���id  
		shrinkToFit: false,
		onSelectRow: function (id, status) {
			QueryGridFYSub()
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#ifrm-presc").attr("src", "");
			} else {
				$(this).jqGrid('setSelection', 1);
			}
			var chkfy=""
			if ($("#chk-fy").is(':checked')) {
				chkfy = "1";
			}	
			if(chkfy!=1){
					var fyrowdata = $("#grid-fy").jqGrid('getRowData');
					var fygridrows = fyrowdata.length;
					if (fygridrows <= 0) {
						return;
					}
					for (var rowi = 1; rowi <= fygridrows; rowi++) {
						var selrowdata=$("#grid-fy").jqGrid('getRowData', rowi)
						var prescno = selrowdata.TPrescNo;
						SendOPInfoToMachine("202",prescno)

					}

			}
		}
	};
	$("#grid-fy").dhcphaJqGrid(jqOptions);
}


//�к���Ϣ����
function SendMessToVoice(rowIndex) {

	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert("û��ѡ������,���ܽк�!");
		return;
	}

	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var patno = selrowdata.tbpatid;
	var patname = selrowdata.tbname;
	var window = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var serverip = ClientIPAddress;
	var FYUserID = DHCPHA_CONSTANT.DEFAULT.PHUSER;
	var SendVoiceRet = tkMakeServerCall("web.DHCSTInterfacePH", "SendMessToVoice", patno, patname, serverip, window, FYUserID)

}

//��ʼ������ҩtable
function InitGirdWAITFY() {
	var tmpheight = 0;
	if (DHCPHA_CONSTANT.VAR.BODYTYPE == "ONE") {
		tmpheight = DhcphaJqGridHeight(1, 1);
	} else {
		tmpheight = DhcphaJqGridHeight(2, 3) * 0.5;
	}
	var columns = [{
			header: '�к�',
			index: 'tSendVoice',
			name: 'tSendVoice',
			width: 50,
			formatter: function (cellvalue, options, rowObject) {
				return "<a href='#' onclick='SendMessToVoice(\"" + options.rowId + "\")'><i class='fa fa-bullhorn'></i></a>";
			}
		},
		{
			header: '����',
			index: 'tbname',
			name: 'tbname',
			width: 100
		},
		{
			header: '�ǼǺ�',
			index: 'tbpatid',
			name: 'tbpatid',
			width: 100
		},
		{
			header: '�����ܼ�',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 200,
			hidden: true
		},
		{
			header: '���˼���',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 200,
			hidden: true
		},
		{
			header: 'TWarnLevel',
			index: 'TWarnLevel',
			name: 'TWarnLevel',
			width: 100,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryNeedFYList&style=jqGrid',
		height: tmpheight,
		recordtext: "",
		pgtext: "",
		shrinkToFit: true,
		onSelectRow: function (id, status) {
			var selrowdata = $(this).jqGrid('getRowData', id);
			var patno = selrowdata.tbpatid;
			$("#txt-patno").val(patno);
			QueryGridFY();
		},
		gridComplete: function () {
			var ids = $("#grid-waitfy").jqGrid("getDataIDs");
			var rowDatas = $("#grid-waitfy").jqGrid("getRowData");
			for (var i = 0; i < rowDatas.length; i++) {
				var rowData = rowDatas[i];
				var warnLevel = rowData.TWarnLevel;
				if ((warnLevel.indexOf("��") >= 0) || (warnLevel.indexOf("��") >= 0)) {
					$("#grid-waitfy" + " #" + ids[i] + " td").css({
						color: '#FF6356',
						'font-weight': 'bold'
					});
				}
			}
			return true;
		}
	};
	$("#grid-waitfy").dhcphaJqGrid(jqOptions);
}
//��ѯ����ҩtable
function QueryGridWaitFY() {
	var stdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + DHCPHA_CONSTANT.DEFAULT.PHWINDOW + "^^" + stdate + "^" + enddate;;
	$("#grid-waitfy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	if ((DHCPHA_CONSTANT.DEFAULT.PHLOC != "") && (DHCPHA_CONSTANT.DEFAULT.PHWINDOW != "")) {
		clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	}
}
//��ѯ��ҩ�б�
function QueryGridFY() {
	ChkUnFyOtherLoc();
	var stdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var chkfy = "";
	if ($("#chk-fy").is(':checked')) {
		chkfy = "1";
	}
	var patno = $("#txt-patno").val();
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //������ҩ���ڵ�ID
	var CPatName = "";
	var CPrescNo = "";
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + CPrescNo + "^" + chkfy;
	$("#grid-fy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	$("#ifrm-presc").attr("src", "");
}
//��ѯ��ҩ��ϸ
function QueryGridFYSub() {
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var cyflag = DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	var phartype = "DHCOUTPHA";
	var paramsstr = phartype + "^" + prescno + "^" + cyflag;
	$("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}
// ִ�з�ҩ
function ExecuteFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,���ܷ�ҩ!");
		return;
	}
	DispensingMonitor(selectid);
	var nextSelectid=parseInt(selectid)+1
	var rowDatas = $("#grid-fy").jqGrid("getRowData");
	if(nextSelectid<=rowDatas.length)
	{
    	$("#grid-fy").setSelection(nextSelectid);
    }
	QueryGridWaitFY();
}


//ִ��ȫ��
function ExecuteAllFY() {
	var fyrowdata = $("#grid-fy").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	if (fygridrows <= 0) {
		dhcphaMsgBox.alert("û������!");
		return;
	}
	for (var rowi = 1; rowi <= fygridrows; rowi++) {
		DispensingMonitor(rowi);
	}
	QueryGridWaitFY();

}

function DispensingMonitor(rowid) {
	var selrowdata = $("#grid-fy").jqGrid('getRowData', rowid);
	var prescno = selrowdata.TPrescNo;
	var phdrowid = selrowdata.phdrow;
	var adtresult = GetOrdAuditResultByPresc(prescno);
	if (adtresult == "") {
		dhcphaMsgBox.alert("�������!")
		return;
	} else if (adtresult == "N") {
		dhcphaMsgBox.alert("�ô�����˲�ͨ��,��ֹ��ҩ!")
		return;
	} else if (adtresult == "S") {
		if (!confirm("�ô���ҽ�����ύ����,���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������")) {
			return;
		}
	}
	var checkprescref = GetOrdRefResultByPresc(prescno)
	if (checkprescref == "N") {
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
	}
	if (checkprescref == "A") {
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
	}
	if (checkprescref == "S") {
		dhcphaMsgBox.confirm("�ô���ҽ�����ύ����<br/>���[ȷ��]��ͬ�����߼�����ҩ�����[ȡ��]��������ҩ������", function (r) {
			if (r == true) {
				var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //���ߺ�ҩӦ�ȳ����ܾ�
				ExecuteDisp(phdrowid, prescno, rowid);
			} else {
				return;
			}
		});
	} else {
		ExecuteDisp(phdrowid, prescno, rowid);
	}
}

function ExecuteDisp(phdrowid, prescno, rowid) {
	var RetInfo = tkMakeServerCall("PHA.OP.PyDisp.OperTab", "SaveDispData", phdrowid, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHUSER, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
	var retarr = RetInfo.split("^");
	var dispret = retarr[0];
	var retmessage = retarr[1];
	if (dispret > 0) {
		var bgcolor = $(".dhcpha-record-disped").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-fy").setCell(rowid, 'TFyFlag', 'OK');
		$("#grid-fy").setCell(rowid, 'TPhDispStat', '�ѷ�ҩ', cssprop);
		AfterExecPrint(prescno,PrintType,phdrowid,"");
		SendOPInfoToMachine("203",prescno);
	} else {
		dhcphaMsgBox.alert(retmessage, "error")
		return;
	}
}

// ִ�оܾ���ҩ
function ExecuteRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,���ܾܾ���ҩ!");
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert("�����ѷ�ҩ�����ܾܾ�!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	if (prescno == "") {
		dhcphaMsgBox.alert("��ѡ��Ҫ�ܾ��Ĵ���");
		return;
	}
	var ref = GetOrdRefResultByPresc(prescno);
	if (ref == "N") {
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	} else if (ref == "A") {
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno);
	if (checkprescadt == "") {
		dhcphaMsgBox.alert("�ô���δ���,��ֹ����!")
		return;
	} else if (checkprescadt != "Y") {
		dhcphaMsgBox.alert("�ô������δͨ��,��ֹ����!")
		return;
	}
	var waycode = DHCPHA_CONSTANT.VAR.OUTPHAWAY;
	ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescno,
		selType:"PRESCNO"
	},SaveCommontResultEX,{prescno:prescno});
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var input = ret + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "^" + origOpts.prescno + "^OR" //orditm;	
    
    if (reasondr.indexOf("$$$") == "-1") {
		reasondr = reasondr + "$$$" + prescno;
	}
    var refuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "SaveOPAuditResult", reasondr, input);
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');

	if (refuseret == 0) {
		$("#grid-fy").setCell(selectid, 'TDocSS', '�ܾ���ҩ');
	} else {
		dhcphaMsgBox.alert("�ܾ�ʧ��!�������:" + refuseret)
		return;
	}

}
// �����ܾ���ҩ
function CancelRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,���ܳ����ܾ���ҩ!");
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	var prescno = selrowdata.TPrescNo;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert("�ü�¼�Ѿ���ҩ!");
		return;
	}
	if (prescno == "") {
		dhcphaMsgBox.alert("��ѡ��Ҫ�����ܾ��Ĵ���");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  �����ܾ�
	if ((checkprescref != "N") && (checkprescref != "A")) {
		if (checkprescref == "S") {
			dhcphaMsgBox.alert("�ô���ҽ�����ύ����,����Ҫ����!")
			return;
		} else {
			dhcphaMsgBox.alert("�ô���δ���ܾ�,���ܳ�������!")
			return;
		}
	}
	var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR");
	if (cancelrefuseret == "0") {
		var PrescResult = GetPrescResult(prescno);
		var newdata = {
			TDocSS: PrescResult
		};
		$("#grid-fy").jqGrid('setRowData', selectid, newdata);
		dhcphaMsgBox.alert("�����ɹ�!", "success");
	} else if (cancelrefuseret == "-2") {
		dhcphaMsgBox.alert("�ô���δ���ܾ�,���ܳ�������!");
	} else if (retval == "-3") {
		dhcphaMsgBox.alert("�ô����ѳ���,�����ٴγ���!");
	}
}

//��ȡ�����ܾ���� 
function GetOrdRefResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc", prescno);
	return ref;
}
//��ȡ�ܾ���ҩ�ʹ�����˽�� 
function GetPrescResult(prescno) {
	var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	return ref;
}
//��ȡ������˽�� 
function GetOrdAuditResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	return ref;
}
//��ȡ��������δ��ҩ��¼,��������ҩʱ
function ChkUnFyOtherLoc() {
	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();

	var patno = $("#txt-patno").val();
	if ((patno == "") || (patno == null)) {
		return;
	}
	var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", startdate, enddate, patno, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW)
	if (ret == -1) {
		//alert("����Ϊ��,�����")
	} else if (ret == -2) {
		dhcphaMsgBox.alert("û�ҵ��ǼǺ�Ϊ" + patno + "�Ĳ���");
		return;

	} else if ((ret != "") && (ret != null)) {
		dhcphaMsgBox.alert(ret);
	}
}
//��ӡ
function PrintHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,�޷���ӡ!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	//����
	OUTPHA_PRINTCOM.Presc(prescno, "", "");
}
//�ش��ǩ
function RePrintLabelHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,�޷���ӡ!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Label(prescno, "", "");

}
//���
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-fy').iCheck('uncheck');
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#grid-fy").clearJqGrid();
	$("#ifrm-presc").attr("src", "");
	QueryGridWaitFY();
}
//��ʼ����ҩ����table
function InitGridWin() {
	var columns = [{
			header: 'ҩ������',
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		},
		{
			header: '����״̬',
			index: 'phwWinStat',
			name: 'phwWinStat',
			formatter: statusFormatter,
			title: false
		},
		{
			header: 'phwid',
			index: 'phwid',
			name: 'phwpid',
			width: 20,
			hidden: true
		},
		{
			header: 'phwpid',
			index: 'phwpid',
			name: 'phwpid',
			width: 20,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&ChkRelFlag=1',
		height: '100%',
		autowidth: true,
		loadComplete: function () {}
	};
	$("#grid-window").dhcphaJqGrid(jqOptions);
}

function statusFormatter(cellvalue, options, rowdata) {
	if (cellvalue == "����") {
		return '<input name="dhcphaswitch" type="checkbox" checked> '
	} else {
		return '<input name="dhcphaswitch" type="checkbox" unchecked> '
	}
}

function ChangeWinStat(state) {
	var wintd = $(event.target).closest("td");
	var rowid = $(wintd).closest("tr.jqgrow").attr("id");
	var selrowdata = $("#grid-window").jqGrid('getRowData', rowid);
	var phwpid = selrowdata.phwpid;
	var phwWinStat = state;
	var winstat = "";
	if (phwWinStat == true) {
		phwWinStat = "1";
	} else {
		phwWinStat = "0";
	}
	var modifyret = tkMakeServerCall("web.DHCOutPhDisp", "UpdatePhwp", phwpid, phwWinStat);
	if (modifyret == 0) {
		return true;
	} else if (modifyret == -11) {
		dhcphaMsgBox.alert("��ȷ������һ������Ϊ����״̬!");
		return false;
	} else {
		dhcphaMsgBox.alert("�޸Ĵ���״̬ʧ��,�������:" + modifyret, "error");
		return false;
	}
}
//��ҩ����ȷ��
function FYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var fywindata = $("#sel-window").select2("data")[0];
	if (fywindata == undefined) {
		dhcphaMsgBox.alert("��ҩ���ڲ���Ϊ��!");
		return false;
	}
	var fywin = fywindata.id;
	var fywindesc = fywindata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(fywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = fywin;
	var phcookieinfo = fywin + "^" + fywindesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy", phcookieinfo);
	ClearConditions();
	return false;
}

//Ȩ����֤
function CheckPermission() {
	$.ajax({
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
			'&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
			'&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
			'&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type: 'post',
		success: function (data) {
			var retjson = eval("(" + data + ")");
			var retdata = retjson[0];
			var permissionmsg = "",
				permissioninfo = "";
			if (retdata.phloc == "") {
				permissionmsg = "ҩ������:" + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = "��δ������ҩ������ά����ά��!"
			} else {
				permissionmsg = "����:" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "��������:" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser == "") {
					permissioninfo = "��δ������ҩ����Ա����ά��!"
				} else if (retdata.phnouse == "Y") {
					permissioninfo = "����ҩ����Ա����ά����������Ϊ��Ч!"
				} else if (retdata.phfy != "Y") {
					permissioninfo = "����ҩ����Ա����ά����δ���÷�ҩȨ��!"
				}
			}
			if (permissioninfo != "") {
				$('#modal-dhcpha-permission').modal({
					backdrop: 'static',
					keyboard: false
				}); //���ɫ���򲻹ر�
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)

				})
				$("#modal-dhcpha-permission").modal('show');
			} else {
				DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
					QueryGridWaitFY();
				} else {
					$("#modal-windowinfo").modal('show');
				}
				$('#modal-windowinfo').on('show.bs.modal', function () {
					$("#sel-window ").empty();
				})
				
			}
		},
		error: function () {}
	})
}
//��ʼ����ҩ����
function InitFYWin() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetFYWinList&style=select2&gLocId=" +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&ChkRelFlag=1",
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}

function InitBodyStyle() {
	var bodytype = DHCPHA_CONSTANT.VAR.BODYTYPE;
	var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
	var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5 = parseFloat($("[class='panel-heading']").height());
	if (bodytype == "ONE") {
		var dbLayoutWidth = parseInt($("#dbLayout").closest(".div_content").css("width")) - 3;
		var tableheight = OutFYCanUseHeight(1) + 40;
	} else {
		var tableheight = $(window).height() - height1 * 2 - height3 - height4 - height5 - 11;
		$("#ifrm-presc").height(tableheight)
		var dbLayoutWidth = $("[class='panel div_content']").width();
	}
	var dbLayoutCss = {
		width: dbLayoutWidth,
		height: tableheight
	};
	$("#dbLayout").css(dbLayoutCss);
	$("#divReport").css(dbLayoutCss);
	$("#grid-fy").setGridWidth("");
}

function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == "����ҩ") {
		return "class=dhcpha-record-pyed";
	} else if (val == "�Ѵ�ӡ") {
		return "class=dhcpha-record-printed";
	} else if (val == "�ѷ�ҩ") {
		return "class=dhcpha-record-disped";
	} else {
		return "";
	}
}
//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "sel-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
//�������ز���
function ReadCardReturn() {
	QueryGridFY();
}
function InitConfig(){
	var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if(CongigStr!=""){
		var arr=CongigStr.split("^");
		if(arr.length>=10){
			PrintType=arr[9]
		}
	}
}
// 	�����ҩ��
function SendOPInfoToMachine(SendCode,PrescNo)
{
	var ret= tkMakeServerCall("web.DHCSTInterfacePH", "SendOPInfoToMachine", SendCode,PrescNo)	
}
