/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-��ҩ
 *createdate:2016-08-18
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.INVROWID = "";
DHCPHA_CONSTANT.VAR.RETURNROWID = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
$(function () {
	CheckPermission();
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate = FormatDateT("t-30")
	$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
	InitSelectPrescNo();
	InitGridRequest();
	InitGirdReturn();
	InitReturnModal();
	/* ��ʼ����� end*/
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				$("#patInfo").remove()
				if(newpatno==""){return;}
				var patoptions = {
					id: "#dhcpha-patinfo",
					gettype: "patno",
					input: newpatno
				}
				AppendPatientBasicInfo(patoptions);
				$("#sel-prescno").empty();
				var prescNo = $("#sel-prescno").val();
				if (prescNo == null) {
					QueryGridRequest();
				} else {
					QueryGridReturn();
				}
			}
		}
	});

	//���Żس��¼�
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
				var patno = $.trim($("#txt-patno").val());
				$("#sel-prescno").empty();
				if(patno==""){return}
				var patoptions = {
					id: "#dhcpha-patinfo",
					gettype: "patno",
					input: patno
				}
				AppendPatientBasicInfo(patoptions);
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
	$("#btn-clear").on("click", ClearConditions)
	$("#btn-find").on("click", function () {
		var prescNo = $("#sel-prescno").val();
		var patno = $("#txt-patno").val();
		if((patno=="")||(patno=null)){
			dhcphaMsgBox.alert("������ǼǺŻ򿨺ź�,�ٲ�ѯ!");
			return;
		}
		if (prescNo == null) {
			QueryGridRequest();
		} else {
			QueryGridReturn();
		}
	});
	$("#btn-return").on("click", DoReturn);
	$("#btn-refusereturn").on("click", DoRefuseReturn);
	$("#btn-cancelrefuse").on("click", DoCancelRefuseReturn);
	$("#btn-readcard").on("click", BtnReadCardHandler); //����
	$("#btn-print").on("click", function () {
		if (DHCPHA_CONSTANT.VAR.RETURNROWID == "") {
			dhcphaMsgBox.alert("������ҩ��,�ٴ�ӡ!");
			return;
		}
		PrintReturn(DHCPHA_CONSTANT.VAR.RETURNROWID, "")
	});

	/* �󶨰�ť�¼� end*/
;
	InitBodyStyle();
	ResizeReturn();
	
})
// ����������
function InitSelectPrescNo() {
	var selectoption = {
		width: 280,
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		'?action=GetPrescForRet',
		placeholder: "��ѡ�񴦷�",
		minimumResultsForSearch: Infinity,
		templateResult: function (state) {
			if (!state.id) {
				return state.text;
			}
			var stateText = state.text;
			if (stateText.indexOf("����") >= 0) {
				stateText = $('<span style="font-weight:bold">' + stateText + '</span>')
					// var stateTextArr=stateText.split("  ");
					// stateText=$('<span>'+stateTextArr[0]+"  "+stateTextArr[1]+"  "+'</span><span style="color:green;font-weight:bold">'+stateTextArr[2]+'</span>')
			}
			return stateText;
		}
	}
	var ajaxopts = {
		data: function (params) {
			var stdate=$("#date-start").val();
			var enddate=$("#date-end").val();
			var daterange=stdate+" - "+enddate
			var patNo = $("#txt-patno").val();
			var inputStr = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "^" + patNo + "^" + daterange;
			return {
				combotext: params.term,
				inputStr: inputStr
			};
		}
	}
	$("#sel-prescno").dhcphaSelect(selectoption, ajaxopts)
	$('#sel-prescno').on('select2:select', function (event) {
		QueryGridReturn();
	});
}

//��ʼ����ҩ����table
function InitGridRequest() {
	var columns = [{
			index: 'reqNo',
			name: 'reqNo',
			header: '���뵥��',
			width: 100
		}, {
			index: 'prescNo',
			name: 'prescNo',
			header: '������',
			width: 115
		}, {
			index: 'reqUser',
			name: 'reqUser',
			header: '������',
			width: 100
		}, {
			index: 'reqRowId',
			name: 'reqRowId',
			header: 'reqRowId',
			width: 100,
			hidden: true
		}, {
			index: 'reqReason',
			name: 'reqReason',
			header: 'reqReason',
			width: 100,
			hidden: true
		}, {
			index: 'reqReasonDesc',
			name: 'reqReasonDesc',
			header: '����ԭ��',
			width: 100,
			hidden: false
		},
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetReqListByReqNo', //��ѯ��̨
		height: DhcphaJqGridHeight(1, 1),
		datatype: 'local',
		onSelectRow: function (id, status) {
			DHCPHA_CONSTANT.VAR.RETURNROWID = "";
			var selrowdata = $(this).jqGrid('getRowData', id);
			var reqRowId = selrowdata.reqRowId;
			$("#grid-return").setGridParam({
				datatype: 'json',
				url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + "?action=GetReturnListByReq",
				postData: {
					'params': reqRowId
				}
			}).trigger("reloadGrid");
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#grid-return").clearJqGrid();
			} else {
				$(this).jqGrid('setSelection', 1);
			}
		}
	};
	$('#grid-request').dhcphaJqGrid(jqOptions);
}
//��ʼ����ҩ��ϸtable
function InitGirdReturn() {
	var columns = [{
			index: 'TRefuse',
			name: 'TRefuse',
			header: '����ԭ��',
			width: 100,
			align: 'left'
		}, {
			index: 'TPhdesc',
			name: 'TPhdesc',
			header: 'ҩƷ����',
			width: 225,
			align: 'left',
			cellattr: function (rowId, val, rawObject, cm, rdata) {
				var cantRetReason = rawObject.TCantRetReason || "";
				if (cantRetReason != "") {
					return "style='color:#FF5648;font-weight:bold;'";
				}

			}
		}, {
			index: 'TPhUom',
			name: 'TPhUom',
			header: 'ҩƷ��λ',
			width: 80,
			align: 'left'
		}, {
			index: 'TPrice',
			name: 'TPrice',
			header: 'ҩƷ����',
			width: 100,
			align: 'right'
		}, {
			index: 'TDispQty',
			name: 'TDispQty',
			header: '��ҩ����',
			width: 80,
			align: 'right'
		}, {
			index: 'TDispMoney',
			name: 'TDispMoney',
			header: '��ҩ���',
			width: 100,
			align: 'right'
		}, {
			index: 'TRetQty',
			name: 'TRetQty',
			header: '��ҩ����',
			width: 100,
			align: 'center',
			editable: true,
			cellattr: addTextCellAttr
		}, {
			index: 'TRetMoney',
			name: 'TRetMoney',
			header: '��ҩ���',
			width: 100,
			align: 'right'
		}, {
			index: 'TPhgg',
			name: 'TPhgg',
			header: '���',
			width: 100,
			align: 'left'
		}, {
			index: 'TIncDispBatCode',
			name: 'TIncDispBatCode',
			header: '��ҩ����',
			width: 100,
			align: 'left'
		}, {
			index: 'TIncRetBatCode',
			name: 'TIncRetBatCode',
			header: '��ҩ����',
			width: 100,
			align: 'left',
			editable: true,
			cellattr: addTextCellAttr
		}, {
			index: 'TInvNo',
			name: 'TInvNo',
			header: '��Ʊ��',
			width: 100,
			align: 'left'
		}, {
			index: 'TPhdItm',
			name: 'TPhdItm',
			header: 'TPhdItm',
			width: 100,
			hidden: true
		}, {
			index: 'TPhUomid',
			name: 'TPhUomid',
			header: 'TPhUomid',
			width: 100,
			hidden: true
		}, {
			index: 'TReqItm',
			name: 'TReqItm',
			header: 'TReqItm',
			width: 100,
			hidden: true
		}, {
			index: 'TPhdLbRowId',
			name: 'TPhdLbRowId',
			header: '��ҩ�ӱ�ID',
			width: 100,
			hidden: true
		}, {
			index: 'TDodisBatch',
			name: 'TDodisBatch',
			header: '����ӱ�ID',
			width: 100,
			hidden: true
		}, {
			index: 'TCantRetReason',
			name: 'TCantRetReason',
			header: '������ҩԭ��',
			width: 100
		}, {
			index: 'TCyFlag',
			name: 'TCyFlag',
			header: '��ҩ������־',
			width: 30,
			hidden: true
		}, {
			index: 'TRefuseFlag',
			name: 'TRefuseFlag',
			header: '�ܾ���־',
			width: 30,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetNeedReturnList',
		height: DhcphaJqGridHeight(1, 1),
		shrinkToFit: true,
		datatype: 'local',
		onSelectRow: function (id, status) {
			var iddata = $('#grid-return').jqGrid('getRowData', id);
			var prescyflag = iddata.TCyFlag;
			if (prescyflag == "Y") {
				return;
			}
			var DispBatCode = iddata.TIncDispBatCode;
			if (DispBatCode.indexOf("Ƿҩ") >-1) {
				return;
			}
			if ((JqGridCanEdit == false) && (LastEditSel != "") && (LastEditSel != id)) {
				$("#grid-return").jqGrid('setSelection', LastEditSel);
				return
			}
			if ((LastEditSel != "") && (LastEditSel != id)) {
				UpdateReturnGridRow($(this).attr("id"));
			}

			$(this).jqGrid("editRow", id, {
				oneditfunc: function () {
					$editinput = $(event.target).find("input");
					$editinput.focus();
					$editinput.select();
					$("#" + id + "_TRetQty").unbind().on("keyup",function(e){
						$("#" + id + "_TRetQty").val(ParseToNum($("#" + id + "_TRetQty").val()))
					});	
					$("#" + id + "_TRetQty").on("focusout || mouseout", function () {
						if(this.value==""){	// ����Ϊ��
							return true;
						}
						var reg = /^[0-9]\d*$/;
						if (!reg.test(this.value)) {
							dhcphaMsgBox.message("��" + id + "�е�ʵ������ֻ��Ϊ����!")
							$("#grid-return").jqGrid('restoreRow', id);
							JqGridCanEdit = false;
							return false;
						}
						var iddata = $('#grid-return').jqGrid('getRowData', id);
						var dispedqty = iddata.TDispQty;
						if (parseFloat(this.value * 1000) > parseFloat(dispedqty * 1000)) {
							dhcphaMsgBox.message("��" + id + "����ҩ�������ڷ�ҩ����!")
							$("#grid-return").jqGrid('restoreRow', id);
							JqGridCanEdit = false;
							return false;
						} else {
							JqGridCanEdit = true;
							return true;
						}
					});
				}
			});
			LastEditSel = id;
		}
	};
	$('#grid-return').dhcphaJqGrid(jqOptions);
	PhaGridFocusOut("grid-return");
}

//��ѯ����ҩ�б�
function QueryGridReturn() {
	var patno = $("#txt-patno").val();
	var prescno = $("#sel-prescno").select2('data')[0].id || "";
	var params = prescno + "^" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	$("#grid-return").setGridParam({
		datatype: 'json',
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetNeedReturnList',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");

	$("#grid-request").clearJqGrid();
	JqGridCanEdit = true;
	DHCPHA_CONSTANT.VAR.RETURNROWID = "";
	return true
}
//��ѯ��ҩ�����б�
function QueryGridRequest() {
	var patno = $("#txt-patno").val();
	var params = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "^" + patno;
	$("#grid-request").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	return true
}
//ִ����ҩ
function DoReturn() {
	if (DHCPHA_CONSTANT.VAR.RETURNROWID != "") {
		dhcphaMsgBox.alert("���μ�¼����ҩ,��˲�!");
		return;
	}
	if (DhcphaGridIsEmpty("#grid-return") == true) {
		return;
	}
	/*if (JqGridCanEdit == false) {
		return;
	}*/
	if (CheckDataBeforeDoReturn() == false) {
		return;
	}
	$("#sel-retreason").val("")
	$("#modal-outpharetreason").modal('show');
}
//�����ҩǰ����֤
function CheckDataBeforeDoReturn() {
	var retqty = 0,dispedqty = "",refusereason = "",lastrefusereason = "",lastcantretreason="";
	var canreturn = false,returninfo = "",zeroFlag = 0;
	var returnrowdata = $("#grid-return").jqGrid('getRowData');
	var detailgridrows = returnrowdata.length;
	if (detailgridrows <= 0) {
		dhcphaMsgBox.alert("û����ϸ����!");
		return false;
	}
	for (var rowi = 0; rowi < detailgridrows; rowi++) {
		var cyflag = returnrowdata[rowi].TCyFlag;
		var refuseflag = returnrowdata[rowi].TRefuseFlag;
		if ((cyflag == "Y") && (refuseflag == "Y")) {
			dhcphaMsgBox.alert("�ò�ҩ����ҩƷ:" + returnrowdata[rowi]["TPhdesc"] + "</br>���ھܾ���ҩ��¼�����ܲ�����!");
			return false;
		}
		var cantretreason = returnrowdata[rowi].TCantRetReason;
		if ((cyflag == "Y") && (cantretreason != "")) {
			dhcphaMsgBox.alert("�ò�ҩ����ҩƷ:" + returnrowdata[rowi]["TPhdesc"] + "</br>ά���˲�����ҩԭ�򣬲��ܲ�����!");
			return false;
		}else if (cantretreason!=""){
			lastcantretreason=cantretreason;
			continue;
		}
		var phdLbRowId = returnrowdata[rowi].TPhdLbRowId;
		var preColFlag = tkMakeServerCall("PHA.OP.Return.OperTab","GetPreColFlag",phdLbRowId)
		//alert("phdLbRowId:"+phdLbRowId+"  preColFlag:"+preColFlag)
		if (preColFlag == "1"){
			dhcphaMsgBox.alert("ҩƷ:" + returnrowdata[rowi]["TPhdesc"] + "</br>���ڴ������ڼ�ҩ���շ�����������ҩ!");
			return false;
		}
		var retqty = returnrowdata[rowi].TRetQty;
		var dispedqty = returnrowdata[rowi].TDispQty;
		var refusereason = returnrowdata[rowi].TRefuse;
		if ((refusereason != "") && (refusereason != undefined)) {
			lastrefusereason = refusereason;
			continue;
		}
		retqty = $.trim(retqty);
		dispedqty = $.trim(dispedqty);
		// �մ�����
		if (retqty == "") {
			continue;
		}
		if (retqty == 0) {
			continue;
		}
		if (parseFloat(retqty) < 0) {
			dhcphaMsgBox.alert("ҩƷ:" + returnrowdata[rowi]["TPhdesc"] + "</br>��ҩ��������С��0!");
			return;
		}
		if (isNaN(retqty) == true) {
			dhcphaMsgBox.alert("ҩƷ:" + returnrowdata[rowi]["TPhdesc"] + "</br>��ҩ��������Ϊ������!");
			canreturn = false;
			return;
		}
		canreturn = true;
		returninfo = 1;
	}
	if (lastrefusereason != "") {
		dhcphaMsgBox.alert("����ҩ������ھܾ���ҩ��¼!");
	} else if (canreturn == false) {
		if(lastcantretreason!=""){
			dhcphaMsgBox.alert("ҩƷά���˲�����ԭ��</br>�磺"+lastcantretreason);
		}else{
			dhcphaMsgBox.alert("������ҩ����!");
		}
	}
	return canreturn;
}
function ExecuteReturn(returnreason) {
	var checkretsum = 0;
	var returninfo = "",oweflag = "";
	var canreturn = true;
	var retqty = "",dispedqty = "",phditm = "",retmoney = "",price = "",batno = "",retuomid = "",refusereason = "",phdlbrowid = "";
	var returnids = $("#grid-return").jqGrid('getDataIDs');
	$.each(returnids, function () {
		var rowdata = $('#grid-return').jqGrid('getRowData', this);
		retqty = rowdata["TRetQty"];
		dispedqty = rowdata["TDispQty"];
		phditm = rowdata["TPhdItm"];
		retmoney = rowdata["TRetMoney"];
		price = rowdata["TPrice"];
		batno = rowdata["TIncDispBatCode"];
		retuomid = rowdata["TPhUomid"];
		refusereason = rowdata["TRefuse"] || "";
		phdlbrowid = rowdata["TPhdLbRowId"];
		var cantretreason = rowdata["TCantRetReason"] || "";
		if (cantretreason != "") {
			return true;
		}
		if (refusereason != "") {
			return true;
		}
		if (retqty == "") {
			return true;
		}
		if (retqty == 0) {
			return true;
		}
		if (phditm == "") {
			return true;
		}
		if (isNaN(retqty) == true) {
			dhcphaMsgBox.alert("ҩƷ:" + rowdata["TPhdesc"] + "</br>��ҩ��������Ϊ������!");
			canreturn = false;
			return false;
		}
		if (parseFloat(retqty) < 0) {
			dhcphaMsgBox.alert("ҩƷ:" + rowdata["TPhdesc"] + "</br>��ҩ��������С��0!");
			canreturn = false;
			return false;
		}
		if (parseFloat(retqty * 1000) > parseFloat(dispedqty * 1000)) {
			dhcphaMsgBox.alert("ҩƷ:" + rowdata["TPhdesc"] + "</br>��ҩ�������ڷ�ҩ����!");
			canreturn = false;
			return false;
		}
		if ((retqty > 0) && (batno != "Ƿҩ")) {
			var checkret = tkMakeServerCall("PHA.OP.Return.Query", "CheckRetQty", phdlbrowid, retqty);
			if (checkret == "-1") {
				checkretsum = checkretsum + 1;
				canreturn = false;
				dhcphaMsgBox.alert("ҩƷ:" + rowdata["TPhdesc"] + "</br>��ҩ��������ʣ��δ������!");
				return false;
			}
		}
		if (batno == "Ƿҩ") {
			oweflag = 1;
		}
		var onereturn = "";
		if (oweflag == "1") {
			onereturn = phditm;
		} else {
			onereturn = phditm + "^" + retqty + "^" + retmoney + "^" + retuomid + "^" + this + "^" + phdlbrowid;
		}
		if (returninfo == "") {
			returninfo = onereturn;
		} else {
			returninfo = returninfo + "&" + onereturn;
		}

	})
	if (canreturn == false) {
		return;
	}
	if (returninfo == "") {
		dhcphaMsgBox.alert("��������,û�п���ҩƷ!");
		return;
	}
	var reqrowid = "";
	var reqselectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
	if (reqselectid != null) {
		var reqselectdata = $('#grid-request').jqGrid('getRowData', reqselectid);
		if (reqselectdata) {
			reqrowid = reqselectdata.reqRowId;
		}
	}
	//��֤�Ƿ�����
	if (oweflag == "1") {
		var oweresult = tkMakeServerCall("PHA.OP.Owe.OperTab", "DoChowReturn", reqrowid, DHCPHA_CONSTANT.SESSION.GUSER_ROWID, returninfo);
		var oweret = oweresult.split("^")[0];
		if (oweret != 0) {
			dhcphaMsgBox.alert("Ƿҩ��ҩʧ�ܣ�</br>�������:" + oweresult.split("^")[1], "error");
			return;
		} else {
			dhcphaMsgBox.alert("Ƿҩ��ҩ�ɹ�!", "success");
			return;
		}
	} else {
		var retresult = tkMakeServerCall("PHA.OP.Return.OperTab", "DoReturn",
				DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
				DHCPHA_CONSTANT.SESSION.GUSER_ROWID,
				phditm, returnreason, DHCPHA_CONSTANT.VAR.INVROWID, "", reqrowid, returninfo);
		var retval = retresult.split("^")[0];
		var retmessage = retresult.split("^")[1];
		if (retval < 0) {
			dhcphaMsgBox.alert(retmessage);
			return;
		} else {
			DHCPHA_CONSTANT.VAR.RETURNROWID=retval;
			dhcphaMsgBox.alert("��ҩ�ɹ�!�뵽�շѴ��˷�!", "success");
		}
	}

}
//�ܾ���ҩ
function DoRefuseReturn() {
	if (DHCPHA_CONSTANT.VAR.RETURNROWID != "") {
		dhcphaMsgBox.alert("���μ�¼����ҩ,��˲�!");
		return;
	}
	if (DhcphaGridIsEmpty("#grid-return") == true) {
		return;
	}
	if (DhcphaGridIsSelect("#grid-return") == false) {
		return;
	}
	var retselectid = $("#grid-return").jqGrid('getGridParam', 'selrow');
	var retselectdata = $('#grid-return').jqGrid('getRowData', retselectid);
	var reqitm = retselectdata.TReqItm;
	var refuse = retselectdata.TRefuse;
	if ((reqitm == "") || (reqitm == undefined)) {
		dhcphaMsgBox.alert("��������ҩ������ҩʱ����ܾ�!");
		return;
	}
	if ((refuse != "") && (refuse != undefined)) {
		dhcphaMsgBox.alert("�ü�¼�Ѿܾ�!");
		return;
	}
	
	$("#sel-retrefreason").val("")
	$("#modal-outpharetrefreason").modal('show');
}
//�����ܾ�
function DoCancelRefuseReturn() {
	var retselectid = $("#grid-return").jqGrid('getGridParam', 'selrow');
	if (retselectid == null) {
		dhcphaMsgBox.alert("����ѡ������,�ٽ��в���!");
		return;
	}
	var retselectdata = $('#grid-return').jqGrid('getRowData', retselectid);
	var reqitm = retselectdata.TReqItm;
	var refuse = retselectdata.TRefuse;
	if ((reqitm == "") || (reqitm == undefined)) {
		dhcphaMsgBox.alert("��������ҩ������ҩʱ�������ܾ�!");
		return;
	}
	if ((refuse == "") || (refuse == undefined)) {
		dhcphaMsgBox.alert("�ü�¼����Ҫ�����ܾ�!");
		return;
	}
	var refuseret = tkMakeServerCall("PHA.OP.Return.OperTab", "CancelRefuseReason", reqitm)
		if (refuseret == 0) {
			dhcphaMsgBox.alert("�����ܾ���ҩ�ɹ�", "success");
			var newdata = {
				TRefuse: '',
				TRefuseFlag: ''
			}
			$('#grid-return').jqGrid('setRowData', retselectid, newdata);
		} else {
			dhcphaMsgBox.alert("�����ܾ�ʧ��!�������:" + refuseret, "error");
		}
}
//��֧�ֵ����ܾ�
function ExecuteRefuseReturn(retrefarr) {
	var retselectid = $("#grid-return").jqGrid('getGridParam', 'selrow');
	var retselectdata = $('#grid-return').jqGrid('getRowData', retselectid);
	var reqitm=retselectdata.TReqItm;
	var refuse=retselectdata.TRefuse;
	if ((reqitm=="")||(reqitm==undefined)){
		dhcphaMsgBox.alert("��������ҩ������ҩʱ����ܾ�!");
		return;
	}
	if ((refuse!="")&&(refuse!=undefined)){
		dhcphaMsgBox.alert("�ü�¼�Ѿܾ�!");
		return;
	}
	var refuseret = tkMakeServerCall("PHA.OP.Return.OperTab", "RefuseReason", retrefarr.id, reqitm)
		if (refuseret == 0) {
			dhcphaMsgBox.alert("�ܾ���ҩ�ɹ�", "success");
			var newdata = {
				TRefuse: retrefarr.text,
				TRefuseFlag: "Y"
			}
			$('#grid-return').jqGrid('setRowData', retselectid, newdata);
		} else {
			dhcphaMsgBox.alert("�ܾ�ʧ��!�������:" + refuseret, "error");
		}
}

function ClearConditions() {
	var cardoptions = {
		id: "#sel-cardtype"
	}
	InitSelectCardType(cardoptions);
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-30"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-30"));
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());

	if ($("#patInfo")) {
		$("#patInfo").remove()
	}
	$("#grid-request").clearJqGrid();
	$("#grid-return").clearJqGrid();
	$("#sel-prescno").empty();
	JqGridCanEdit = true;
}
function InitReturnModal() {
	//��ҩ
	$('#modal-outpharetreason').on('show.bs.modal', function () {
		var locoption = {
			url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + "?action=GetRetReason&style=select2"+"&HospId=" + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID,
			minimumResultsForSearch: Infinity,
			allowClear: false,
			width: 200
		}
		$("#sel-retreason").dhcphaSelect(locoption)
		$("#sel-retreason").empty();
		var selectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
		if ((selectid != "") && (selectid != undefined)) {
			var selrowdata = $("#grid-request").jqGrid('getRowData', selectid);
			var select2option = '<option value=' + "'" + selrowdata.reqReason + "'" + 'selected>' + selrowdata.reqReasonDesc + '</option>'
				$("#sel-retreason").append(select2option);
		}
	})
	$("#btn-retreason-sure").on("click", function () {
		var returnreason = $("#sel-retreason").val();
		if ((returnreason == "") || (returnreason == null)) {
			dhcphaMsgBox.alert("��ѡ����ҩԭ��!");
			return;
		}
		$("#modal-outpharetreason").modal('hide');
		ExecuteReturn(returnreason);
	});
	//�ܾ���ҩ
	$('#modal-outpharetrefreason').on('show.bs.modal', function () {
		var locoption = {
			url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + "?action=GetRetRefuseReason&style=select2"+"&HospId=" + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID,
			minimumResultsForSearch: Infinity,
			width: 200
		}
		$("#sel-retrefreason").dhcphaSelect(locoption);
		$("#sel-retrefreason").empty();
	})
	$("#btn-retrefreason-sure").on("click", function () {
		var returnrefreason = $("#sel-retrefreason").val();
		var returnrefreasondesc = $("#sel-retrefreason").text();
		var retrefarr = {
			id: returnrefreason,
			text: returnrefreasondesc
		}
		if ((returnrefreason == "") || (returnrefreason == null)) {
			dhcphaMsgBox.alert("��ѡ��ܾ���ҩԭ��!");
			return;
		}
		$("#modal-outpharetrefreason").modal('hide');
		ExecuteRefuseReturn(retrefarr);
	});
}
function InitBodyStyle() {
	$("#grid-return").setGridWidth("");
}
function PhaGridFocusOut(gridid) {
	$("#" + gridid).on("mouseleave",function (e) {
		if (e.relatedTarget) {
			var $related = $("#" + gridid).find(e.relatedTarget);
			if ($related.length <= 0 && LastEditSel != "") {
				UpdateReturnGridRow(gridid);
			}
		}
	})
}

function UpdateReturnGridRow(inputId) {
	$("#" + inputId).jqGrid('saveRow', LastEditSel, true);
	UpdateReturnGridRowData(inputId);

}
function UpdateReturnGridRowData(inputId) {
	var selrowdata = $("#" + inputId).jqGrid('getRowData', LastEditSel);
	var selretqty = selrowdata.TRetQty;
	var selprice = selrowdata.TPrice;
	selretqty = $.jgrid.stripHtml(selretqty);
	var retamt = selretqty * selprice;
	$("#" + inputId).setCell(LastEditSel, 'TRetMoney', retamt);
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
	var newpatno = $("#txt-patno").val();
	var patoptions = {
		id: "#dhcpha-patinfo",
		gettype: "patno",
		input: newpatno
	}
	AppendPatientBasicInfo(patoptions);
	QueryGridRequest();
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
			var retjson = JSON.parse(data);
			var retdata = retjson[0];
			DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
		},
		error: function () {}
	})
}

window.onresize = ResizeReturn;

function ResizeReturn() {

    
    var titleheight = $("#gview_grid-return .ui-jqgrid-hbox").height();
    var gridheight = DhcphaJqGridHeight(1, 1)  ;  //+32
    $("#grid-return").setGridHeight(gridheight).setGridWidth("");
    $("#grid-request").setGridHeight(gridheight).setGridWidth("");

}