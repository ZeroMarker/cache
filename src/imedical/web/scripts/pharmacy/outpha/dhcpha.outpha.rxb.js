/*
 *ģ��:����ҩ��
 *��ģ��:ҩ��ͳ��-������ͳ��
 *createdate:2016-12-06
 *creator:dinghongying
 */
var gNewCatId = "";
var QUERYPID = "";
$(function () {
	var daterangeoptions = {
		timePicker : true, 
		timePickerIncrement:1,
		timePicker24Hour:true,
		timePickerSeconds:true,
		singleDatePicker:true,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
		}
	}
	/* ��ʼ����� start*/
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);


	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})

	/*ҩ����� start*/
	$("#txt-phccat").next().children("i").on('click', function (event) {
		ShowPHAINPhcCat({},function(catObj){
			if (catObj){
				$("#txt-phccat").val(catObj.text||'');
				gNewCatId=catObj.id||'';
			}
		})
	});
	/*ҩ����� end*/
	InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	InitStkCat();
	InitManaGroup();
	InitFyUser();
	InitRXBList();
	ClearConditions();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$('#btn-export').on('click', function () { //�������
		ExportAllToExcel("rxbdg")
	});
	$('#btn-print').on('click', BtnPrintHandler);
	/* �󶨰�ť�¼� end*/
;
	$("#rxbdg").closest(".panel-body").height($(window).height() - QueryConditionHeight() - 60);
	//$("#rxbdg").closest(".panel-body").css("min-height",500);

})
//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
	var locincioptions = {
		id: "#sel-locinci",
		locid: locrowid
	}
	InitLocInci(locincioptions)
}
//��ʼ��������
function InitStkCat() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetStkCatDs&style=select2",
		allowClear: true,
		width: 250,
		placeholder: "������..."
	}
	$("#sel-stk").dhcphaSelect(selectoption)
	$('#sel-stk').on('select2:select', function (event) {
		//alert(event)
	});
}
//��ʼ��������
function InitManaGroup() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetManaGroupDs&style=select2&gLocId=" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		allowClear: true,
		minimumResultsForSearch: Infinity,
		placeholder: "������..."
	}
	$("#sel-managroup").dhcphaSelect(selectoption)
	$('#sel-managroup').on('select2:select', function (event) {
		//alert(event)
	});
}

//��ʼ����ҩ��
function InitFyUser() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetPYUserList&style=select2&gLocId=" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&gUserId=" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID,
		allowClear: true,
		placeholder: "��ҩ��..."
	}
	$("#sel-fyuser").dhcphaSelect(selectoption)
	$('#sel-fyuser').on('select2:select', function (event) {
		//alert(event)
	});
}

//�������б�
function InitRXBList() {
	//����columns
	var columns = [[{
				field: 'incCode',
				title: 'ҩƷ����',
				width: 80,
				sortable: true
			}, {
				field: 'incDesc',
				title: 'ҩƷ����',
				width: 250,
				sortable: true
			}, {
				field: 'qty',
				title: '��������',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'uomDesc',
				title: '��λ',
				width: 100,
				sortable: true
			}, {
				field: 'sp',
				title: '�ۼ�',
				width: 75,
				align: 'right',
				sortable: true
			}, {
				field: 'spAmt',
				title: '�������',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'rp',
				title: '����',
				width: 75,
				align: 'right',
				sortable: true
			}, {
				field: 'rpAmt',
				title: '���۽��',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'manfDesc',
				title: '��������',
				width: 200,
				sortable: true
			}, {
				field: 'pid',
				title: '���̺�',
				width: 200,
				sortable: true,
				hidden: true
			}
		]];

	var dataGridOption = {
		url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DayCons.Display&MethodName=EuiGetRXBStat",
		columns: columns,
		fitColumns: true,
		showFooter: true,
		onLoadSuccess: function () {
			if ($(this).datagrid("getRows").length > 0) {
				$(this).datagrid("selectRow", 0)
				QUERYPID = $(this).datagrid("getRows")[0].pid;
				$(this).datagrid("options").queryParams.Pid = QUERYPID;
			}
		}
	}
	//����datagrid
	$('#rxbdg').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
 	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var gUserId = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var stkCatId = $("#sel-stk").val();
	if (stkCatId == null) {
		stkCatId = "";
	}
	var fyUserId = $("#sel-fyuser").val();
	if (fyUserId == null) {
		fyUserId = "";
	}
	var manaGroupId = $("#sel-managroup").val();
	if (manaGroupId == null) {
		manaGroupId = "";
	}
	var price = $("#txt-inciSp").val();
	var chkmana = "N";
	if ($("#chk-mana").is(':checked')) {
		chkmana = "Y";
	}
	var inciRowid = $("#sel-locinci").val();
	if (inciRowid == null) {
		inciRowid = "";
	}
	var winposcode = "";
	if ($("#txt-phccat").val() == "") {
		gNewCatId = "";
	}
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = ctloc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + fyUserId + tmpSplit + inciRowid + tmpSplit + stkCatId + tmpSplit + price + tmpSplit + chkmana + tmpSplit + manaGroupId + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + gNewCatId;
	KillTmpGloal();
	$('#rxbdg').datagrid({
		queryParams: {
			InputStr: params,
			Pid: ""
		}
	});

}

//���
function ClearConditions() {
	$("#sel-stk").empty();
	$("#sel-fyuser").empty();
	$("#sel-locinci").empty();
	$("#txt-inciSp").val("");
	$("#txt-phccat").val("");
	gNewCatId = "";
	$("#sel-managroup").empty();
	$("#chk-mana").iCheck('uncheck');
	$('#rxbdg').clearEasyUIGrid();
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "23:59:59");
	KillTmpGloal();
}
// �����ʱglobal
function KillTmpGloal() {
	tkMakeServerCall("PHA.OP.DayCons.Global", "Kill", QUERYPID);
}

window.onbeforeunload = function () {
	KillTmpGloal();
}

//��ӡ
function BtnPrintHandler() {
	//��ȡ���������������
	if ($('#rxbdg').datagrid('getData').rows.length == 0) {
		dhcphaMsgBox.alert("ҳ��û������","info");
		return ;
	}
	// ȡҳ������
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var daterange = startdate+" �� "+enddate;
	var footerData=$("#rxbdg").datagrid('getFooterRows')
	var rpamtTotal=footerData[0].rpAmt;
	var spamtTotal=footerData[0].spAmt;
	var Para = {
		title: DHCPHA_CONSTANT.DEFAULT.LOC.text + "������",
		daterange: daterange,
		rpamtTotal:rpamtTotal,
		spamtTotal:spamtTotal
	}
	//��ӡ���� Huxt 2019-12-25
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPDailyConsum',
		data: {
			Para: Para,
			Grid: {type:'easyui', grid:'rxbdg'}
		},
		listBorder: {style:4, startX:1, endX:170},
		page: {rows:30, x:20, y:2, fontname:'����', fontbold:'true', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'},
		aptListFields: ["label9", "spamtTotal"]
	});
}
