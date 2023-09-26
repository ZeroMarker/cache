/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-������ͳ��
 *createdate:2016-11-15
 *creator:dinghongying
 */
$(function () {
	/* ��ʼ����� start*/
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
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	InitWorkLoadList();
	ClearConditions();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-print").on("click", BtnPrintHandler);
	/* �󶨰�ť�¼� end*/
;
	$("#workloaddg").closest(".panel-body").height(GridCanUseHeight(1));

})
//��ʼ��������ͳ���б�
function InitWorkLoadList() {
	//����columns
	var columns = [[{
				field: 'TPhName',
				title: 'ҩ����Ա',
				align: 'center',
				width: 125
			}, {
				field: 'TPYRC',
				title: '��ҩ����',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TFYRC',
				title: '��ҩ����',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TPYJE',
				title: '��ҩ���',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TFYJE',
				title: '��ҩ���',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TPYL',
				title: '��ҩ��',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TFYL',
				title: '��ҩ��',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetPresc',
				title: '��ҩ����',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetMoney',
				title: '��ҩ���',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetYL',
				title: '��ҩ��',
				width: 110,
				align: 'right',
				sortable: true
			}, {
				field: 'TPyFS',
				title: '��ҩ����',
				width: 120,
				align: 'right',
				sortable: true
			}, {
				field: 'TFyFS',
				title: '��ҩ����',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TTyFS',
				title: '��ҩ����',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				field: 'TJYFS',
				title: '��ҩ����',
				width: 120,
				sortable: true,
				hidden: true
			}, {
				field: 'TJYCF',
				title: '��ҩ����',
				width: 120,
				sortable: true,
				hidden: true
			}
		]];
	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns
	}
	//����datagrid
	$('#workloaddg').dhcphaEasyUIGrid(dataGridOption);
}

///ҩ��������ͳ�Ʋ�ѯ
function Query() {
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = ctloc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + starttime + tmpSplit + endtime;
	$('#workloaddg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.Workload.Query",
			QueryName: "Workload",
			Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
		}
	});

}

//���
function ClearConditions() {

	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+' 00:00:00')
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+' 00:00:00');
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+' 23:59:59');
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+' 23:59:59');
	$('#workloaddg').clearEasyUIGrid();
}

//��ӡ
function BtnPrintHandler() {
	if ($('#workloaddg').datagrid('getData').rows.length == 0) //��ȡ���������������
	{
		dhcphaMsgBox.alert("ҳ��û�����ݣ�");
		return;
	}
	var WorkLoaddgOption = $("#workloaddg").datagrid("options");
	var WorkLoaddgparams = encodeURIComponent(WorkLoaddgOption.queryParams.Params);
	var WorkLoaddgUrl = WorkLoaddgOption.url;
	var classname = "PHA.OP.Workload.Query";
	var queryname = "Workload";
	$.ajax({
		type: "GET",
		url: WorkLoaddgUrl + "?page=1&rows=9999&ClassName=" + classname + "&QueryName=" + queryname + "&Params=" + WorkLoaddgparams,
		async: false,
		dataType: "json",
		success: function (workloaddata) {
			var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
			var startdatetime=$("#date-start").val();
			var enddatetime=$("#date-end").val();
			var datetimerange=startdatetime+" �� "+enddatetime;
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: 'PHAOPWorkLoad',
				data:{
					Para: {
						titlemain:HospitalDesc + "���﹤����ͳ��",
						titlesecond: "ҩ��:" + DHCPHA_CONSTANT.DEFAULT.LOC.text+"     ͳ�Ʒ�Χ:"+datetimerange,
						lasttitle:"��ӡ��:"+session['LOGON.USERNAME']+"      ��ӡʱ��:"+getPrintDateTime()
					},
					List: workloaddata.rows
				},
				aptListFields: ["lasttitle"],
				listBorder: {style:4, startX:1, endX:195,space:1},
			})
		}
	});
}
