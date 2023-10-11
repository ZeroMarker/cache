/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-��ҩ���ݲ�ѯ
 *createdate:2016-11-22
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
	InitReturnInfoList();
	InitReturnDetailList();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-print").on("click", BPrintHandler);
	$("#btn-cancel").on("click", BCancelReturnHandler);
	$("#btn-export").on("click", function () {
		ExportAllToExcel("returninfodg");
	});
	/* �󶨰�ť�¼� end*/
	$("#returninfodg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
	$("#returndetaildg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})

//��ʼ����ҩ���б�
function InitReturnInfoList() {
	//����columns
	var columns = [[{
				field: 'TPmiNo',
				title: ("�ǼǺ�"),
				width: 150,
				align: 'center',
				sortable: true
			}, {
				field: 'TPatName',
				title: ("����"),
				width: 100,
				align: 'center'
			}, {
				field: 'TRetDate',
				title: ("��ҩ����"),
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TRetMoney',
				title: ("��ҩ���"),
				width: 80,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetUser',
				title: ("������"),
				width: 100,
				align: 'center',
				sortable: true
			}, {
				field: 'TDoctor',
				title: ("ҽ��"),
				width: 100,
				align: 'center'
			}, {
				field: 'TLocDesc',
				title: ("����"),
				width: 120,
				align: 'left',
				sortable: true
			}, {
				field: 'TRetReason',
				title: ("��ҩԭ��"),
				width: 150,
				align: 'left',
				sortable: true
			}, {
				field: 'TDispDate',
				title: ("��ҩ����"),
				width: 120,
				align: 'center',
				sortable: true
			}, {
				field: 'TCancleUser',
				title: ("������"),
				width: 80,
				align: 'center',
				sortable: true
			}, {
				field: 'TCancleDate',
				title: ("��������"),
				width: 80,
				align: 'center',
				sortable: true
			}, {
				field: 'TCancleTime',
				title: ("����ʱ��"),
				width: 120,
				align: 'center',
				sortable: true,
				hidden: true
			}, {
				field: 'TEncryptLevel',
				title: ("�����ܼ�"),
				width: 80,
				align: 'center',
				hidden: true
			}, {
				field: 'TPatLevel',
				title: ("���˼���"),
				width: 80,
				align: 'center',
				hidden: true
			}, {
				field: 'TRetRowid',
				title: ("��ҩ��Id"),
				width: 80,
				hidden: false
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true,
		onSelect: function (rowIndex, rowData) {
			QueryDetail();
		},
		onLoadSuccess: function () {
			if ($(this).datagrid("getRows").length > 0) {
				$(this).datagrid("selectRow", 0)
			} else {
				$('#returndetaildg').clearEasyUIGrid();
			}
		}
	}
	//����datagrid
	$('#returninfodg').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩ����ϸ�б�
function InitReturnDetailList() {
	//����columns
	var columns = [[{
				field: 'TPhDesc',
				title: ("ҩƷ����"),
				width: 300,
				align: 'left'
			}, {
				field: 'TPhUom',
				title: ("��λ"),
				width: 125,
				align: 'center'
			}, {
				field: 'TRetQty',
				title: ("��ҩ����"),
				width: 125,
				align: 'right'
			}, {
				field: 'TPhprice',
				title: ("����"),
				width: 125,
				align: 'right'
			}, {
				field: 'TRetMoney',
				title: ("��ҩ���"),
				width: 125,
				align: 'right'
			}, {
				field: 'TBatExpStr',
				title: ("����~Ч��"),
				width: 125,
				align: 'center'
			}
		]];
	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true,
		pagination: false
	}
	//����datagrid
	$('#returndetaildg').dhcphaEasyUIGrid(dataGridOption);

}

///��ҩ����ѯ
function Query() {
	var startdate = $("#date-start").val();
	var enddate = $("#date-end").val();
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = startdate + tmpSplit + enddate + tmpSplit + ctloc;
	$('#returninfodg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.RetQuery.Query",
			QueryName: "ReturnBill",
			Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
		}
	});
}

//��ѯ��ϸ
function QueryDetail() {
	var selectdata = $("#returninfodg").datagrid("getSelected")
		if (selectdata == null) {
			dhcphaMsgBox.alert($g("ѡ�������쳣!"));
			return;
		}
		var params = selectdata["TRetRowid"]
		$('#returndetaildg').datagrid({
			queryParams: {
				ClassName: "PHA.OP.RetQuery.Query",
				QueryName: "ReturnBillDet",
				Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
			}
		});
}

//���
function ClearConditions() {
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$('#returninfodg').clearEasyUIGrid();
	$('#returndetaildg').clearEasyUIGrid();
}

//��ӡ
function BPrintHandler() {
	var selectdata = $("#returninfodg").datagrid("getSelected");
	if (selectdata == null) {
		dhcphaMsgBox.alert($g("��ѡ����Ҫ��ӡ����ҩ��!"));
		return;
	}
	var retrowid = selectdata["TRetRowid"];
	PrintReturn(retrowid, "��");
}

//������ҩ
function BCancelReturnHandler() {
	var selectdata = $("#returninfodg").datagrid("getSelected");
	if (selectdata == null) {
		dhcphaMsgBox.alert($g("��ѡ����Ҫ��������ҩ��!"));
		return;
	}
	var retrowid = selectdata["TRetRowid"];
	var othParams=DHCPHA_CONSTANT.SESSION.GROUP_ROWID+"^"+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var cancelRet = tkMakeServerCall("PHA.OP.Return.OperTab", "CancleReturn", retrowid,DHCPHA_CONSTANT.SESSION.GUSER_ROWID,othParams);
	var cancelRetArr = cancelRet.split("^");
	var retCode = cancelRetArr[0];
	if (retCode != 0) {
		var cancelRetInfo = cancelRetArr[1] || "";
		if (cancelRetInfo != "") {
			dhcphaMsgBox.alert(cancelRetInfo);
		} else {
			dhcphaMsgBox.alert($g("����ʧ��,����ϵ�����Ա���д���,�������:") + cancelRet);
		}
	} else {
		dhcphaMsgBox.alert($g("�����ɹ���"));
		Query();
	}
}
