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
			dhcphaMsgBox.alert("û��ͳ������!");
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
				title: '����',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				field: 'TPmiNo',
				title: '�ǼǺ�',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				field: 'TPatName',
				title: '����',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				field: 'TPatSex',
				title: '�Ա�',
				width: 40,
				align: 'center'
			}, {
				field: 'TPatAge',
				title: '����',
				width: 75,
				align: 'center'
			}, {
				field: 'TPatSN',
				title: '֤������',
				width: 180,
				align: 'center'
			}, {
				field: 'TMR',
				title: '���',
				width: 200
			}, {
				field: 'TPrescNo',
				title: '������',
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TPhDesc',
				title: 'ҩƷ����',
				width: 200,
				sortable: true
			}, {
				field: 'TPhQty',
				title: '����',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				field: 'TPhUom',
				title: '��λ',
				width: 60
			}, {
				field: 'TPhMoney',
				title: '���',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				field: 'TIncBatCode',
				title: '����',
				width: 100
			}, {
				field: 'TYF',
				title: '�÷�',
				width: 80
			}, {
				field: 'TPatLoc',
				title: '�Ʊ�',
				width: 120
			}, {
				field: 'TDoctor',
				title: 'ҽ��',
				width: 80
			}, {
				field: 'TFYUser',
				title: '��ҩ��',
				width: 80
			}, {
				field: 'TBZ',
				title: '��ע',
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
		dhcphaMsgBox.alert("���Ʒ���Ϊ��ѡ�");
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
