/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-ֱ�ӷ�ҩ
 *createdate:2016-09-05
 *creator:dinghongying
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHPYUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.DEFAULT.OweDisp = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 1000;
DHCPHA_CONSTANT.VAR.OUTPHAWAY = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", "OA");
var PrintType=""
$(function () {
	CheckPermission();
	var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate = FormatDateT("t-2")
	$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-start").data('daterangepicker').setEndDate(tmpstartdate);

	InitGridWin();
	InitFYWin();
	InitGridDisp();
	InitGirdDispDetail();
	InitBasicLoc();
	InitSpecial();
	InitFYSTAFF();
	InitGirdWAITFY();
	InitConfig();	//��ʼ������
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				if(newpatno==""){return;}
				QueryGridDisp();
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
	$("#btn-find").on("click", QueryGridDisp);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-fy").on("click", ExecuteFY);
	$("#btn-reffy").on("click", ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click", CancelRefuseFY);
	$("#btn-allfy").on("click", ExecuteAllFY);
	$('#btn-print').bind("click", PrintHandler);
	$("#btn-win-sure").on("click", FYWindowConfirm);
	$("#btn-cardpay").on("click", CardBillClick);
	
	/*	�˶�������
	$("#btn-readcard").on("click",function(){
		PhaReadCardHandler();
		//dhcphaReadCard(CardCallBack);
	})*/
	$("#btn-readcard").on("click", BtnReadCardHandler); //����
	$("#btn-redir-return").on("click", function () {
		var lnk = ChangeCspPathToAll("dhcpha/dhcpha.outpha.return.csp");
		websys_createWindow(lnk, "��ҩ", "width=95%,height=75%")
		//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$("#modal-prescinfo .close").on("click", function () {
		hide();
	})
	/* �󶨰�ť�¼� end*/
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
	HotKeyInit("Disp","grid-disp");
})

//��ʼ����ҩtable
function InitGridDisp() {
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
			width: 150
		},
		{
			header: '��ҩ',
			index: 'TPrintFlag',
			name: 'TPrintFlag',
			width: 40,
			hidden: true
		},
		{
			header: '��ҩ',
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		},
		{
			header: '������',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 115,
			sortable: true
		},
		{
			header: 'Ԥ��',
			index: 'TPrescView',
			name: 'TPrescView',
			width: 50,
			formatter: PrescFormatter,
			hidden: true
		},
		{
			header: '�������',
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 70,
			align: 'right'
		},
		{
			header: '����',
			index: 'TJS',
			name: 'TJS',
			width: 40,
			hidden: true
		},
		{
			header: '�ѱ�',
			index: 'TPrescType',
			name: 'TPrescType',
			width: 70
		},
		{
			header: '����',
			index: 'TWinDesc',
			name: 'TWinDesc',
			width: 80
		},
		{
			header: '���',
			index: 'TMR',
			name: 'TMR',
			width: 150,
			align: "left"
		},
		{
			header: '�Ա�',
			index: 'TPatSex',
			name: 'TPatSex',
			width: 40
		},
		{
			header: '����',
			index: 'TPatAge',
			name: 'TPatAge',
			width: 40
		},
		{
			header: '����',
			index: 'TPatLoc',
			name: 'TPatLoc',
			width: 100
		},
		{
			header: 'Э������',
			index: 'TOrdGroup',
			name: 'TOrdGroup',
			width: 60,
			hidden: true
		},
		{
			header: '���տ���',
			index: 'TRecLocdesc',
			name: 'TRecLocdesc',
			width: 100
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
			header: 'TAdm',
			index: 'TAdm',
			name: 'TAdm',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatID',
			index: 'TPatID',
			name: 'TPatID',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatLoc',
			index: 'TPatLoc',
			name: 'TPatLoc',
			width: 60,
			hidden: true
		},
		{
			header: 'TJYType',
			index: 'TJYType',
			name: 'TJYType',
			width: 60,
			hidden: true
		},
		{
			header: 'TCallCode',
			index: 'TCallCode',
			name: 'TCallCode',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatAdd',
			index: 'TPatAdd',
			name: 'TPatAdd',
			width: 60,
			hidden: true
		},
		{
			header: 'TPrescTitle',
			index: 'TPrescTitle',
			name: 'TPrescTitle',
			width: 60,
			hidden: true
		},
		{
			header: 'TUseLocdr',
			index: 'TUseLocdr',
			name: 'TUseLocdr',
			width: 60,
			hidden: true
		},
		{
			header: 'Tphd',
			index: 'Tphd',
			name: 'Tphd',
			width: 60,
			hidden: true
		},
		{
			header: 'TPid',
			index: 'TPid',
			name: 'TPid',
			width: 60,
			hidden: true
		},
		{
			header: '�����ܼ�',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 70,
			hidden: true
		},
		{
			header: '���˼���',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 70,
			hidden: true
		},
		{
			header: '��Ƿҩ',
			index: 'TCanOwe',
			name: 'TCanOwe',
			width: 70,
			hidden: true
		},
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispList&style=jqGrid', //��ѯ��̨	
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		shrinkToFit: false,
		datatype: 'local',
		pager: "#jqGridPager", //��ҳ�ؼ���id  
		onSelectRow: function (id, status) {
			QueryGridDispSub()
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#grid-dispdetail").clearJqGrid();
			} else {
				$(this).jqGrid('setSelection', 1);
			}
			var chkdisp=""
			if ($("#chk-disp").is(':checked')) {
				chkdisp = "1";
			}
			if(chkdisp!=1){
				var fyrowdata = $("#grid-disp").jqGrid('getRowData');
				var fygridrows = fyrowdata.length;
				if (fygridrows <= 0) {
					return;
				}
				for (var rowi = 1; rowi <= fygridrows; rowi++) {
					var selrowdata=$("#grid-disp").jqGrid('getRowData', rowi)
					var prescno = selrowdata.TPrescNo;
					SendOPInfoToMachine("202",prescno)

				}
			}
		}
	};
	$("#grid-disp").dhcphaJqGrid(jqOptions);
}
//�Զ��崦��Ԥ���и�ʽ
function PrescFormatter(cellvalue, options, rowdata) {
	return '<i class="fa fa-file-text-o" style="cursor:pointer;" onClick=pop() alt="' + cellvalue + '"  />'
	//return '<i class="fa fa-file-text-o" style="cursor:pointer;" onMouseOver=pop() onMouseOut=hide() alt="' + cellvalue + '"  />' 
}

function pop() {
	$td = $(event.target).closest("td");
	var rowid = $td.closest("tr.jqgrow").attr("id");
	var selectdata = $('#grid-disp').jqGrid('getRowData', rowid);
	var phdrowid = selectdata.Tphd;
	var prescno = selectdata.TPrescNo;
	var prtrowid = "";
	var cyflag = DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	var newurl = "dhcpha.outpha.prescpreview.csp" +
		"?phdispid=" + phdrowid + "&prescno=" + prescno + "&cyflag=" + cyflag + "&prtrowid=" + prtrowid + "&phlrowid=" + DHCPHA_CONSTANT.DEFAULT.PHLOC;
	$('iframe').attr('src', newurl);
	document.getElementById("modal-prescinfo").style.display = "inline";
}

function hide() {
	$('iframe').attr('src', "")
	document.getElementById("modal-prescinfo").style.display = "none";
}
//��ʼ����ҩ��ϸtable
function InitGirdDispDetail() {
	var columns = [{
			header: '��ϸ״̬',
			index: 'TPhDispItmStat',
			name: 'TPhDispItmStat',
			width: 65,
			cellattr: addPhDispItmStatCellAttr
		},
		{
			header: 'ҩƷ����',
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 200,
			align: 'left'
		},
		{
			header: '����',
			index: 'TPhQty',
			name: 'TPhQty',
			width: 60,
			align: 'right'
		},
		{
			header: 'ʵ��',
			index: 'TRealQty',
			name: 'TRealQty',
			width: 60,
			editable: true,
			cellattr: addTextCellAttr
		},
		{
			header: '��λ',
			index: 'TPhUom',
			name: 'TPhUom',
			width: 70
		},
		{
			header: '����',
			index: 'TJL',
			name: 'TJL',
			width: 60
		},
		{
			header: 'Ƶ��',
			index: 'TPC',
			name: 'TPC',
			width: 40
		},
		{
			header: '�÷�',
			index: 'TYF',
			name: 'TYF',
			width: 40
		},
		{
			header: '�Ƴ�',
			index: 'TLC',
			name: 'TLC',
			width: 40
		},
		{
			header: '���',
			index: 'TPhgg',
			name: 'TPhgg',
			width: 100
		},
		{
			header: '��λ',
			index: 'TIncHW',
			name: 'TIncHW',
			width: 100
		},
		{
			header: '����',
			index: 'TPhFact',
			name: 'TPhFact',
			width: 170,
			align: 'left'
		},
		{
			header: '��ע',
			index: 'TPhbz',
			name: 'TPhbz',
			width: 40
		},
		{
			header: '��治��',
			index: 'TKCFlag',
			name: 'TKCFlag',
			width: 40,
			hidden: true
		},
		{
			header: '�������',
			index: 'TKCQty',
			name: 'TKCQty',
			width: 70
		},
		{
			header: 'ҽ������',
			index: 'TYBType',
			name: 'TYBType',
			width: 75
		},
		{
			header: '����',
			index: 'TPrice',
			name: 'TPrice',
			width: 60,
			align: 'right'
		},
		{
			header: '���',
			index: 'TMoney',
			name: 'TMoney',
			width: 60,
			align: 'right'
		},
		{
			header: '״̬',
			index: 'TOrdStatus',
			name: 'TOrdStatus',
			width: 60
		},
		{
			header: 'TOrditm',
			index: 'TOrditm',
			name: 'TOrditm',
			width: 60,
			hidden: true
		},
		{
			header: 'TUnit',
			index: 'TUnit',
			name: 'TUnit',
			width: 60,
			hidden: true
		},
		{
			header: '����',
			index: 'TIncPC',
			name: 'TIncPC',
			width: 60,
			hidden: true
		},
		{
			header: '��Ʊ��',
			index: 'TPrtNo',
			name: 'TPrtNo',
			width: 100
		},
		{
			header: 'Ƥ��',
			index: 'TSkinTest',
			name: 'TSkinTest',
			width: 60
		},
		{
			header: '������',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 60,
			hidden: true
		},
		{
			header: 'TInci',
			index: 'TInci',
			name: 'TInci',
			width: 60,
			hidden: true
		}
	];
	var jqOptions = {
		//cellEdit:true,
		//cellsubmit:'clientArray',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispListDetail&style=jqGrid',
		height: DhcphaJqGridHeight(2, 3) * 0.5,
		shrinkToFit: false,
		rowNum: 200,
		datatype: 'local',
		onSelectRow: function (id, status) {
			if (DHCPHA_CONSTANT.DEFAULT.CYFLAG == "Y") {
				return;
			}
			if (DHCPHA_CONSTANT.DEFAULT.OweDisp != "Y") {
				return;
			}
			var dispselid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
			var selrowdata = $("#grid-disp").jqGrid('getRowData', dispselid);
			var fyflag = selrowdata["TFyFlag"];
			var pyflag = selrowdata["TPrintFlag"];
			var dispstat = selrowdata["TPhDispStat"];
			var canOwe = selrowdata["TCanOwe"];
			if (fyflag == "OK") {
				return;
			}
			if ((dispstat.indexOf("����") >= 0) || (dispstat.indexOf("�Ѵ�ӡ") >= 0)) {
				return;
			}
			if (canOwe != "Y") {
				return;
			}
			if ((JqGridCanEdit == false) && (LastEditSel != "") && (LastEditSel != id)) {
				$("#grid-dispdetail").jqGrid('setSelection', LastEditSel);
				return
			}
			if ((LastEditSel != "") && (LastEditSel != id)) {
				$(this).jqGrid('saveRow', LastEditSel);
			}
			$(this).jqGrid("editRow", id, {
				oneditfunc: function () {
					$editinput = $(event.target).find("input");
					$editinput.focus();
					$editinput.select();
					$editinput.unbind().on("keyup",function(e){
						$editinput.val(ParseToNum($editinput.val()))
					});
					$("#" + id + "_TRealQty").on("focusout || mouseout", function () {
						var reg = /^[0-9]\d*$/;
						if (!reg.test(this.value)) {
							dhcphaMsgBox.message("��" + id + "�е�ʵ������ֻ��Ϊ����!")
							$("#grid-dispdetail").jqGrid('restoreRow', id);
							JqGridCanEdit = false
							return false
						}
						var iddata = $('#grid-dispdetail').jqGrid('getRowData', id);
						var oeoriqty = iddata.TPhQty;
						if (parseFloat(this.value * 1000) > parseFloat(oeoriqty * 1000)) {
							dhcphaMsgBox.message("��" + id + "��ʵ����������ҽ������!")
							$("#grid-dispdetail").jqGrid('restoreRow', id);
							JqGridCanEdit = false
							return false
						} else {
							JqGridCanEdit = true
							return true
						}
					});
				}
			});
			LastEditSel = id;
		}

	};
	$("#grid-dispdetail").dhcphaJqGrid(jqOptions);
	PhaGridFocusOut("grid-dispdetail");
}
//��ʼ������ҩtable
function InitGirdWAITFY() {
	var columns = [{
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
			header: 'TWarnLevel',
			index: 'TWarnLevel',
			name: 'TWarnLevel',
			width: 100,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryNeedFYList&style=jqGrid',
		height: DhcphaJqGridHeight(1, 1),
		shrinkToFit: false,
		datatype: 'local',
		onSelectRow: function (id, status) {
			var selrowdata = $(this).jqGrid('getRowData', id);
			var patno = selrowdata.tbpatid;
			$("#txt-patno").val(patno);
			QueryGridDisp();
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
	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + DHCPHA_CONSTANT.DEFAULT.PHWINDOW + "^" + 1 + "^" + stdate + "^" + enddate;
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

//��ʼ����������
function InitBasicLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			'?action=GetBasicLocList&style=select2',
		placeholder: "��������",
		minimumResultsForSearch: Infinity,
		width: 120
	}
	$("#sel-basicloc").dhcphaSelect(selectoption)
	$('#sel-basicloc').on('select2:select', function (event) {
		//alert(event)
	});
}
//��ʼ��������
function InitSpecial() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			'?action=GetEMLocList&style=select2',
		placeholder: "���ۿ���",
		minimumResultsForSearch: Infinity,
		width: 120
	}
	$("#sel-special").dhcphaSelect(selectoption)
	$('#sel-special').on('select2:select', function (event) {
		//alert(event)
	});
}
//��ѯ��ҩ�б�
function QueryGridDisp() {
	ChkUnFyOtherLoc();
	var stdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var chkdisp = "";
	if ($("#chk-disp").is(':checked')) {
		chkdisp = "1";
	}
	var patno = $("#txt-patno").val();
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //������ҩ���ڵ�ID
	var CPatName = "";
	var basicloc = $("#sel-basicloc").val();
	if (basicloc == null) {
		basicloc = "";
	}
	var emloc = $("#sel-special").val();
	if (emloc == null) {
		emloc = "";
	}
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + chkdisp + "^" + emloc + "^" + basicloc;
	$("#grid-disp").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	JqGridCanEdit = true;
}
//��ѯ��ҩ��ϸ
function QueryGridDispSub() {

	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var rPhdrow = selrowdata.Tphd;
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + prescno + "^" + rPhdrow;
	$("#grid-dispdetail").setGridParam({
		datatype: 'json',
		page: '1',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	JqGridCanEdit = true;
}
// ִ�з�ҩ
function ExecuteFY() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,���ܷ�ҩ!");
		return;
	}
	var basicloc = $("#sel-basicloc").val();
	if (basicloc == null) {
		basicloc = "";
	}
	if (basicloc != "") {
		dhcphaMsgBox.alert("��ѡ��ļ�¼Ϊ����ҩ,��ʹ��ȫ���������ɲ�����!")
		return;
	}
	/**if (JqGridCanEdit==false){
		return;
	}**/
	DispensingMonitor(selectid, "");
	
	QueryGridWaitFY();
}

//ִ��ȫ��
function ExecuteAllFY() {
	var fyrowdata = $("#grid-disp").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	if (fygridrows <= 0) {
		dhcphaMsgBox.alert("û������!");
		return;
	}
	//���Ż���ҩƷ,��������ҩ�����嵥
	var firstrowdata = $("#grid-disp").jqGrid("getRowData", 1);
	var uselocdr = firstrowdata.TUseLocdr;
	if (uselocdr == undefined) {
		uselocdr = "";
	}
	if (uselocdr != "") {
		dhcphaMsgBox.confirm("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д������������ɲ�����!", ConfirmDispBasic);
	} else {
		dhcphaMsgBox.confirm("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!", ConfirmDispAll);
	}
}

function ConfirmDispBasic(result) {
	if (result == true) {
		var firstrowdata = $("#grid-disp").jqGrid("getRowData", 1);
		var pid = firstrowdata.TPid;
		var RetInfo = tkMakeServerCall("PHA.OP.Supply.OperTab", "SaveSupData", pid, DHCPHA_CONSTANT.DEFAULT.PHUSER, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHPYUSER, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
		var retarr = RetInfo.split("^");
		var retval = retarr[0];
		var retmessage = retarr[1];
		if (retval > 0) {
			PrintSupp(retval)
			QueryGridDisp();
			if (top && top.HideExecMsgWin) {
				top.HideExecMsgWin();
			}
		} else {
			dhcphaMsgBox.alert("����ҩƷ��ҩʧ��,�������:" + retmessage, "error");
		}
	}
}

function ConfirmDispAll(result) {
	if (result == true) {
		var fyrowdata = $("#grid-disp").jqGrid('getRowData');
		var fygridrows = fyrowdata.length;
		for (var rowi = 1; rowi <= fygridrows; rowi++) {
			DispensingMonitor(rowi, "U");
		}
	}
	QueryGridWaitFY();
}

function DispensingMonitor(rowid, updflag) {

	var selrowdata = $("#grid-disp").jqGrid('getRowData', rowid);
	var prescno = selrowdata.TPrescNo;
	var fyflag = selrowdata.TFyFlag;
	var patname = selrowdata.TPatName;
	var warnmsgtitle = "��������:" + patname + "<br/>" + "������:" + prescno + "<br/>"
	if (fyflag == "OK") {
		dhcphaMsgBox.alert(warnmsgtitle + "�ü�¼�Ѿ���ҩ!");
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno)
	if (checkprescadt == "") {
		dhcphaMsgBox.alert(warnmsgtitle + "�������!");
		return;
	} else if (checkprescadt == "N") {
		dhcphaMsgBox.alert(warnmsgtitle + "��˲�ͨ��,������ҩ!");
		return;
	} else if (checkprescadt == "S") {
		if (!confirm(warnmsgtitle + "�ô���ҽ�����ύ����\n���'ȷ��'��ͬ�����߼�����ҩ�����'ȡ��'��������ҩ������")) {
			return;
		}
	}
	var checkprescref = GetOrdRefResultByPresc(prescno)
	if (checkprescref == "N") {
		dhcphaMsgBox.alert(warnmsgtitle + "�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
	} else if (checkprescref == "A") {
		dhcphaMsgBox.alert(warnmsgtitle + "�ô����ѱ��ܾ�,��ֹ��ҩ!");
		return;
	} else if (checkprescref == "S") {
		dhcphaMsgBox.confirm(warnmsgtitle + "�ô���ҽ�����ύ����<br/>���[ȷ��]��ͬ�����߼�����ҩ�����[ȡ��]��������ҩ������", function (r) {
			if (r == true) {
				var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //���ߺ�ҩӦ�ȳ����ܾ�
				DispMonitor(prescno, updflag, rowid);
			} else {
				return;
			}
		});
	} else {
		DispMonitor(prescno, updflag, rowid);
	}
}

function DispMonitor(prescno, updflag, rowid) {
	var dispQtyString = ""
	if ((updflag == "") && (DHCPHA_CONSTANT.DEFAULT.OweDisp == "Y")) { //ȫ��ʱ�˱�־ΪU
		var fydetailrowdata = $("#grid-dispdetail").jqGrid('getRowData');
		var fydetailgridrows = fydetailrowdata.length;
		if (fydetailgridrows <= 0) {
			dhcphaMsgBox.alert("û����ϸ����!");
			return;
		}
		var chkflag = 0,
			allowe = 1,
			zeroFlag = 0
		var dispQtyString = 0
		for (var rowi = 0; rowi < fydetailgridrows; rowi++) {
			var oeoriQty = fydetailrowdata[rowi].TPhQty;
			var realQty = fydetailrowdata[rowi].TRealQty;
			var oeoriPrescNo = fydetailrowdata[rowi].TPrescNo;
			if (oeoriPrescNo != prescno) {
				dhcphaMsgBox.alert("ҩƷ��ϸ�б�Ǳ���������,������ѡ�д���!");
				return;
			}
			oeoriQty = $.trim(oeoriQty);
			realQty = $.trim(realQty);
			if (parseFloat(realQty) != 0) {
				var zeroFlag = 1;
			}
			if (parseFloat(realQty) > parseFloat(oeoriQty)) {
				dhcphaMsgBox.alert("ʵ���������ܴ���ҽ������!");
				return;
			}
			if (parseFloat(realQty) < 0) {
				dhcphaMsgBox.alert("ʵ����������С��0!");
				return;
			}
			if (parseFloat(realQty) != parseFloat(oeoriQty)) {
				chkflag = "1";
			}
			if (allowe != 0) {
				allowe = 0
			}
			var oeori = fydetailrowdata[rowi].TOrditm
			var unit = fydetailrowdata[rowi].TUnit
			var realqty = fydetailrowdata[rowi].TRealQty
			var Inci = fydetailrowdata[rowi].TInci
			var tmpdispstring = oeori + "^" + realQty + "^" + oeoriQty + "^" + unit + "^" + Inci
			if (dispQtyString == 0) {
				dispQtyString = tmpdispstring
			} else {
				dispQtyString = dispQtyString + "!!" + tmpdispstring
			}

		}
		if (zeroFlag != 1) {
			dhcphaMsgBox.alert("ʵ���������ܶ�Ϊ0!");
			return;
		}
		dispQtyString = chkflag + "&&" + allowe + "&&" + dispQtyString;
		var tmpordstr = dispQtyString.split("&&")
		var chkord = tmpordstr[0];
		ChkAllOweFlag = tmpordstr[1]; //�Ƿ�ȫ��Ƿҩ
		ChkOweFlag = chkord;
	}
	if (chkflag == "1") {
		dhcphaMsgBox.confirm("�Ƿ���Ҫ����Ƿҩ��? ���[ȷ��]���ɣ����[ȡ��]�˳�", function (r) {
			if (r == true) {
				ExecuteDisp(rowid, prescno, dispQtyString, updflag);
			} else {
				return;
			}
		});
	} else {
		ExecuteDisp(rowid, prescno, dispQtyString, updflag);
	}
}

function ExecuteDisp(rowid, prescno, dispQtyString, updflag) {
	var RetInfo = tkMakeServerCall("PHA.OP.DirDisp.OperTab", "SaveDispData", DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHPYUSER, DHCPHA_CONSTANT.DEFAULT.PHUSER, prescno, dispQtyString);
	var retarr = RetInfo.split("^");
	var retval = retarr[0];
	var retmessage = retarr[1];
	if (retval > 0) {
		var bgcolor = $(".dhcpha-record-disped").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-disp").setCell(rowid, 'TFyFlag', 'OK');
		$("#grid-disp").setCell(rowid, 'Tphd', retval);
		$("#grid-disp").setCell(rowid, 'TPhDispStat', '�ѷ�ҩ', cssprop);
		var phOweId = tkMakeServerCall("PHA.OP.COM.Print", "GetPhOweByPhd", retval);
		
		if((updflag!="U")&&(phOweId=="")){
			var nextSelectid=parseInt(rowid)+1
			var rowDatas = $("#grid-disp").jqGrid("getRowData");
			if(nextSelectid<=rowDatas.length)
			{
		    	$("#grid-disp").setSelection(nextSelectid);
		    }
		}
		AfterExecPrint(prescno,PrintType,retval,"")
		PrintPhdOwe(phOweId);
		SendOPInfoToMachine("203",prescno);			//��ҩ��
		if (top && top.HideExecMsgWin) {
			top.HideExecMsgWin();
		}
		
	} else {
		dhcphaMsgBox.alert(retmessage);
		return;
	}
}

// ִ�оܾ���ҩ
function ExecuteRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
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
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  �����ܾ�
	if (checkprescref == "N") {
		dhcphaMsgBox.alert("�ô����ѱ��ܾ�,�����ظ�����!")
		return;
	} else if (checkprescref == "A") {
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
    var refuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "SaveOPAuditResult", reasondr, input);
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	if (refuseret == 0) {
		var newdata = {
			TDocSS: '�ܾ���ҩ'
		};
		$("#grid-disp").jqGrid('setRowData', selectid, newdata);
	} else {
		dhcphaMsgBox.alert("�ܾ�ʧ��!�������:" + refuseret)
		return;
	}

}
// �����ܾ���ҩ
function CancelRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
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

		$("#grid-disp").jqGrid('setRowData', selectid, newdata);
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
//��ȡ������˽�� 
function GetOrdAuditResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	return ref;
}
//��ȡ�ܾ���ҩ�ʹ�����˽�� 
function GetPrescResult(prescno) {
	var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	return ref;
}
//��ȡ��������δ��ҩ��¼,��������ҩʱ
function ChkUnFyOtherLoc() {
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var patno = $("#txt-patno").val();
	if ((patno == "") || (patno == null)) {
		return;
	}
	var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", startdate, enddate, patno, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW,1)
	if (ret == -1) {
		//alert("����Ϊ��,�����")
	} else if (ret == -2) {
		dhcphaMsgBox.alert("û�ҵ��ǼǺ�Ϊ" + patno + "�Ĳ���");
		return;

	} else if ((ret != "") && (ret != null)) {
		//dhcphaMsgBox.message(ret);
		dhcphaMsgBox.alert(ret);
	}
}

//��ӡ
function PrintHandler() {
	if (DhcphaGridIsEmpty("#grid-disp") == true) {
		return;
	}
	var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-disp").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("û��ѡ������,�޷���ӡ!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	var phdrow = selrowdata.Tphd;
	//AfterExecPrint(prescno,PrintType,phdrow,"")
	OUTPHA_PRINTCOM.Presc(prescno, "����", "");
}

//���
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-disp').iCheck('uncheck');
	$("#grid-disp").clearJqGrid();
	$("#grid-dispdetail").clearJqGrid();
	$("#sel-basicloc").empty();
	$("#sel-special").empty();
	var tmpstartdate = FormatDateT("t-2");
	$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	QueryGridWaitFY();
	JqGridCanEdit = true;
	return
	if ($("#col-right").is(":hidden") == false) {
		$("#col-right").hide();
		$("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
	} else {
		$("#col-right").show()
		$("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
	}
	$("#grid-disp").setGridWidth("")
	$("#grid-dispdetail").setGridWidth("")
	$("#grid-waitfy").setGridWidth("");
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
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '',
		height: '100%',
		autowidth: true,
		loadComplete: function () {

		}
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
	var fystaffdata = $("#sel-staff").select2("data")[0];
	if (fywindata == undefined) {
		dhcphaMsgBox.alert("��ҩ���ڲ���Ϊ��!");
		return false;
	}
	if (fystaffdata == undefined) {
		dhcphaMsgBox.alert("��ҩ�˲���Ϊ��!");
		return false;
	}
	var fywin = fywindata.id;
	var fywindesc = fywindata.text;
	var fystaff = fystaffdata.id;
	var fystaffdesc = fystaffdata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(fywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = fywin;
	$("#currentpyuser").text("");
	$("#currentpyuser").text(fystaffdesc);
	DHCPHA_CONSTANT.DEFAULT.PHPYUSER = fystaff;
	var phcookieinfo = fywin + "^" + fywindesc + "^" + fystaff + "^" + fystaffdesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp", phcookieinfo);
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
			var retjson = JSON.parse(data);
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
				DHCPHA_CONSTANT.DEFAULT.OweDisp = retdata.owedisp;
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^disp");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
					$("#currentpyuser").text(getphcookie.split("^")[3]);
					DHCPHA_CONSTANT.DEFAULT.PHPYUSER = getphcookie.split("^")[2];
					QueryGridWaitFY();
				} else {
					$("#modal-windowinfo").modal('show');
				}
				$('#modal-windowinfo').on('show.bs.modal', function () {
					$("#sel-window ").empty();
					$("#sel-staff ").empty();
				})
			}
			if (DHCPHA_CONSTANT.DEFAULT.CYFLAG == "Y") {
				$("#grid-disp").setGridParam().showCol("TJS");
				$("#grid-disp").setGridParam().showCol("TOrdGroup");
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
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}
//��ʼ����ҩ��Ա
function InitFYSTAFF() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetPYUserList&style=select2" + '&gLocId=' +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&gUserId=' +
			DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "&flag=PY",
		minimumResultsForSearch: Infinity
	}
	$("#sel-staff").dhcphaSelect(selectoption)
}

function InitBodyStyle() {
	$("#grid-waitfy").setGridWidth("");
	if (LoadPatNo != "") {
		$("#txt-patno").val(LoadPatNo);
		setTimeout(function () {
			QueryGridDisp();
		}, 1000)
	}
}
//��������,���ڶ������������ַ�ʽ
function CardCallBack() {
	var cardTypeRowId = arguments[0];
	var cardTypeDesc = arguments[1];
	var cardTypeValue = arguments[1];
	myrtn = DHCACC_GetAccInfo(cardTypeRowId, cardTypeValue);
	if (myrtn == -200) { //����Ч
		dhcphaMsgBox.alert("����Ч!");
		return;
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
		case "0":
			//����Ч
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			break;
		case "-200":
			dhcphaMsgBox.alert("����Ч!");
			break;
		case "-201":
			//�ֽ�
			PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			break;
		default:
	}
}
/*
function PhaReadCardHandler(){ 
	var cardTypeValue=$("#sel-cardtype").val();
	var cardTypeArr=cardTypeValue.split("^");
	var cardTypeRowId=cardTypeArr[0];
	var cardTypeDesc=$("#sel-cardtype").text();
	var cardTypeValue=arguments[1];	
	var myrtn; 
	myrtn = DHCACC_GetAccInfo(cardTypeRowId, cardTypeValue); 
	if (myrtn == -200) { //����Ч
		dhcphaMsgBox.alert("����Ч!");
		return;
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
		case "0":
			//����Ч
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			$("#txt-patno").val(PatientNo);
			QueryGridDisp();
			break;
		case "-200":
			dhcphaMsgBox.alert("����Ч!");
			break;
		case "-201":
			//�ֽ�
			var PatientNo = myary[5];
			var CardNo = myary[1]
			var NewCardTypeRowId = myary[8];
			$("#txt-patno").val(PatientNo);
			QueryGridDisp();
			break;
		default:
	}
}
*/
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

function addPhDispItmStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == "��治��") {
		return "class=dhcpha-record-nostock";
	} else if ((val.indexOf("����") > 0) || (val.indexOf("ֹͣ") > 0)) {
		return "class=dhcpha-record-ordstop";
	} else {
		return "";
	}
}

function PhaGridFocusOut(gridid) {
	$("#" + gridid).on("mouseleave",function (e) {
		if (e.relatedTarget) {
			var $related = $("#" + gridid).find(e.relatedTarget);
			if ($related.length <= 0 && LastEditSel != "") {
				$("#" + gridid).jqGrid('saveRow', LastEditSel);
			}
		}
	})
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
	QueryGridDisp();
}
function InitConfig(){
	var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if(CongigStr!=""){
		var arr=CongigStr.split("^");
		if(arr.length>=11){
			PrintType=arr[10]
		}
	}
}
function CardBillClick(){	
	var readcardoptions = {
		CardTypeId: "sel-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, CardPay)
}
function CardPay(){
	
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var carpayoptions = {
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno",
		StDate:startdate,
		EndDate:enddate
	}	
	DhcCardPayCommon(carpayoptions,QueryGridDisp);	
}

// 	�����ҩ��
function SendOPInfoToMachine(SendCode,PrescNo)
{
	var ret= tkMakeServerCall("web.DHCSTInterfacePH", "SendOPInfoToMachine", SendCode,PrescNo)	
}