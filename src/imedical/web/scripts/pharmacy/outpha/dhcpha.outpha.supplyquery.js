/*
 *ģ��:����ҩ��
 *��ģ��:�ճ�ҵ��-����ҩ��������ѯ
 *createdate:2016-12-07
 *creator:dinghongying
 */
$(function () {
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		timePicker24Hour:true,
		timePickerSeconds:true,
		singleDatePicker:true,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT+" HH:mm:ss"
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
	InitPhaLoc();
	InitBasicLoc();
	InitSupplyQueryList();
	InitSupplyQueryTotalList();
	ClearConditions();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$('#btn-print').on('click', BPrintHandler);
	/* �󶨰�ť�¼� end*/
;
	$("#supplyquerydg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
	$("#supplyquerytotaldg").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})

//��ʼ������
function InitPhaLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetUserAllLocDs&style=select2&gUserId=" +
		DHCPHA_CONSTANT.SESSION.GUSER_ROWID,
		allowClear: false,
		minimumResultsForSearch: Infinity
	}
	$("#sel-phaloc").dhcphaSelect(selectoption);
	var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
		$("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
	$('#sel-phaloc').on('select2:select', function (event) {
		//alert(event)
	});
}

//��ʼ����������
function InitBasicLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		"?action=GetBasicLocList&style=select2",
		allowClear: true,
		width: '11em',
		placeholder: '��������...'
	}
	$("#sel-basicloc").dhcphaSelect(selectoption);
	$('#sel-basicloc').on('select2:select', function (event) {
		//alert(event)
	});
}

//��ʼ������ҩ�������б�
function InitSupplyQueryList() {
	//����columns
	var columns = [[{
				field: 'Tward',
				title: '����',
				width: 60,
				hidden: true
			}, {
				field: 'Tdocloc',
				title: '��������',
				width: 150
			}, {
				field: 'Tsuppdate',
				title: '����',
				width: 80
			}, {
				field: 'Tsupptime',
				title: 'ʱ��',
				width: 70
			}, {
				field: 'Tusername',
				title: '������',
				width: 100
			}, {
				field: 'Tsuppno',
				title: '����',
				width: 150
			}, {
				field: 'Tsupp',
				title: '',
				width: 60,
				align: 'center',
				hidden: true
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true,
		onSelect: function (rowIndex, rowData) {
			QuerySub();
		},
		onLoadSuccess: function () {
			if ($(this).datagrid("getRows").length > 0) {
				$(this).datagrid("selectRow", 0)
			}
		}
	}
	//����datagrid
	$('#supplyquerydg').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ������ҩ�����������б�
function InitSupplyQueryTotalList() {
	//����columns
	var columns = [[{
				field: 'Tincicode',
				title: 'ҩƷ����',
				width: 100
			}, {
				field: 'Tincidesc',
				title: 'ҩƷ����',
				width: 300
			}, {
				field: 'Tqty',
				title: '��ҩ����',
				width: 100
			}, {
				field: 'Tspec',
				title: '���',
				width: 135
			}
		]];

	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true
	}
	//����datagrid
	$('#supplyquerytotaldg').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
	$('#supplyquerytotaldg').clearEasyUIGrid();
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var WardId = ""
		var DispLocId = $("#sel-phaloc").val();
	if (DispLocId == null) {
		DispLocId = "";
		dhcphaMsgBox.alert("��ѡ��ҩ��!");
		return;
	}
	var DoctorLocId = $("#sel-basicloc").val();
	if (DoctorLocId == null) {
		DoctorLocId = "";
	}
	var DispNo = $("#txt-supplyno").val();
	var OutFlag = "1";
	var InFlag = "0";
	var PamStr = OutFlag + "^" + InFlag;
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = startdate + tmpSplit + enddate + tmpSplit + DispLocId + tmpSplit + WardId + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + DoctorLocId + tmpSplit + DispNo + tmpSplit + PamStr;
	$('#supplyquerydg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.Supply.Query",
			QueryName: "SupplyList",
			Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
		}
	});

}

///����ҩ���������ܲ�ѯ
function QuerySub() {
	var selecteddata = $('#supplyquerydg').datagrid('getSelected');
	if (selecteddata == null) {
		return;
	}
	var supp = selecteddata["Tsupp"];
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params =supp;
	$('#supplyquerytotaldg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.Supply.Query",
			QueryName: "SupplyTotal",
			Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
		}
	});
}

//���
function ClearConditions() {
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T") + " " + "23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T") + " " + "23:59:59");
	InitPhaLoc();
	$("#sel-basicloc").empty();
	$("#txt-supplyno").val("");
	$('#supplyquerydg').clearEasyUIGrid();
	$('#supplyquerytotaldg').clearEasyUIGrid();
}

///����ҩ��������ӡ
function BPrintHandler() {
	if ($('#supplyquerydg').datagrid('getData').rows.length == 0) //��ȡ��ǰ������������
	{
		dhcphaMsgBox.alert("ҳ��û������!");
		return;
	}
	var gridSelected = $('#supplyquerydg').datagrid('getSelected');
	if (gridSelected == null) {
		dhcphaMsgBox.alert("��ѡ����Ҫ��ӡ����!");
		return;
	}
	if ($('#supplyquerytotaldg').datagrid('getData').rows.length == 0) //��ȡ��ǰ������������
	{
		dhcphaMsgBox.alert("ҳ��û������");
		return;
	}
	PrintSupp(gridSelected.Tsupp);
}
