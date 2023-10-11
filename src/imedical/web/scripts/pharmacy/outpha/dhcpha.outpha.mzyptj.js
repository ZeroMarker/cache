/*
 *ģ��:����ҩ��
 *��ģ��:ҩ��ͳ��-����ҩƷ����ͳ��
 *createdate:2016-12-05
 *creator:dinghongying
 */
$(function () {
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	InitStkCat();
	InitPoisonCat();
	InitMZYPTJList();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$('#btn-export').on('click', function () { //�������
		if ($('#mzyptjdg' ).datagrid("getRows").length <=1) {
			dhcphaMsgBox.alert($g("û��ͳ������!"));
			return;
		}
		ExportAllToExcel("mzyptjdg")
	});
	/* �󶨰�ť�¼� end*/
;
	$("#mzyptjdg").closest(".panel-body").height(GridCanUseHeight(1));

})

//��ʼ��������
function InitStkCat() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetStkCatDs&style=select2",
		allowClear: true,
		width: '15em'
	}
	$("#sel-stk").dhcphaSelect(selectoption)
	$('#sel-stk').on('select2:select', function (event) {
		//alert(event)
	});
}

//��ʼ�����Ʒ���
function InitPoisonCat() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetPoisonCatDs&style=select2",
		allowClear: true,
		width: '15em',
		minimumResultsForSearch: Infinity
	}
	$("#sel-poison").dhcphaSelect(selectoption)
	$('#sel-poison').on('select2:select', function (event) {
		//alert(event)
	});
}

//����ҩƷ������Ϣ�б�
function InitMZYPTJList() {
	//����columns
	var columns = [[{
				field: 'TPhDate',
				title: $g("����"),
				width: 90,
				align: 'center',
				sortable: true
			}, {
				field: 'TPmiNo',
				title: $g("�ǼǺ�"),
				width: 90,
				align: 'center',
				sortable: true
			}, {
				field: 'TPatName',
				title: $g("����"),
				width: 100,
				align: 'left',
				sortable: true
			}, {
				field: 'TPatSex',
				title: $g("�Ա�"),
				width: 40,
				align: 'center'
			}, {
				field: 'TPatAge',
				title: $g("����"),
				width: 75,
				align: 'center'
			}, {
				field: 'TPatSN',
				title: $g("֤������"),
				width: 180,
				align: 'center'
			}, {
				field: 'TMR',
				title: $g("���"),
				width: 200
			}, {
				field: 'TPrescNo',
				title: $g("������"),
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TPhDesc',
				title: $g("ҩƷ����"),
				width: 200,
				sortable: true
			}, {
				field: 'TPhQty',
				title: $g("����"),
				width: 60,
				align: 'right',
				sortable: true
			}, {
				field: 'TPhUom',
				title: $g("��λ"),
				width: 60
			}, {
				field: 'TPhMoney',
				title: $g("���"),
				width: 60,
				align: 'right',
				sortable: true
			}, {
				field: 'TIncBatCode',
				title: $g("����"),
				width: 100
			}, {
				field: 'TYF',
				title: $g("�÷�"),
				width: 80
			}, {
				field: 'TPatLoc',
				title: $g("�Ʊ�"),
				width: 120
			}, {
				field: 'TDoctor',
				title: $g("ҽ��"),
				width: 80
			}, {
				field: 'TFYUser',
				title: $g("��ҩ��"),
				width: 80
			}, {
				field: 'TBZ',
				title: $g("��ע"),
				width: 100
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: false
	}
	//����datagrid
	$('#mzyptjdg').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
 	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var stkCatId = $("#sel-stk").val();
	if (stkCatId == null) {
		stkCatId = "";
	}
	var poisonCatId = $("#sel-poison").val();
	if (poisonCatId == null) {
		dhcphaMsgBox.alert($g("���Ʒ���Ϊ��ѡ�"));
		return;
	}
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = startdate + tmpSplit + enddate + tmpSplit + ctloc + tmpSplit + stkCatId + tmpSplit + poisonCatId;
	$('#mzyptjdg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.PreStat.Query",
			QueryName: "QueryMZYP",
			Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
		}
	});

}
//���
function ClearConditions() {
	var today = new Date();
	$("#date-start").data('daterangepicker').setStartDate(today);
	$("#date-start").data('daterangepicker').setEndDate(today);
	$("#date-end").data('daterangepicker').setStartDate(today);
	$("#date-end").data('daterangepicker').setEndDate(today);
	$("#sel-stk").empty();
	$("#sel-poison").empty();
	$('#mzyptjdg').clearEasyUIGrid();
}
