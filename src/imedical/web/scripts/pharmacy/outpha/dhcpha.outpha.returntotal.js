/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-ҩƷ��ҩ����
 *createdate:2016-11-21
 *creator:dinghongying
 */
$(function () {
	/* ��ʼ����� start*/
	var daterangeoptions = {
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
	InitLoc();
	InitReturnTotalList();
	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", Query);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-print").on("click", BPrintHandler);
	$("#btn-export").on("click", function () {
		ExportAllToExcel("returntotaldg")
	});
	/* �󶨰�ť�¼� end*/
;
	$("#returntotaldg").closest(".panel-body").height(GridCanUseHeight(1));
})

//��ʼ������
function InitLoc() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
		"?action=GetCtLocDs&style=select2&custtype=DocLoc",
		allowClear: true,
		width: '15em'
	}
	$("#sel-loc").dhcphaSelect(selectoption)
	$('#sel-loc').on('select2:select', function (event) {
		//alert(event)
	});
}

//��ʼ��ҩƷ��ҩ�����б�
function InitReturnTotalList() {
	//����columns
	var columns = [[{
				field: 'TPhDesc',
				title: 'ҩƷ����',
				width: 300,
				align: 'left'
			}, {
				field: 'TPhUom',
				title: '��λ',
				width: 150,
				align: 'center'
			}, {
				field: 'TRetQty',
				title: '��ҩ����',
				width: 150,
				align: 'right',
				sortable: true
			}, {
				field: 'TRetMoney',
				title: '��ҩ���',
				width: 150,
				align: 'right',
				sortable: true
			}
		]];
	var dataGridOption = {
		url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns: columns,
		fitColumns: true
		//pagination:false,
		//pageSize:100,
		//view:scrollview //���û�����Ҫ��ҳ,�����ô�pagination:false,pagesizeд��
	}
	//����datagrid
	$('#returntotaldg').dhcphaEasyUIGrid(dataGridOption);
}

///ҩƷ��ҩ���ܲ�ѯ
function Query() {
	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var depcode = $("#sel-loc").val();
	if (depcode == null) {
		depcode = "";
	}
	var doctor = "";
	var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
	var params = ctloc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + depcode + tmpSplit + doctor;
	$('#returntotaldg').datagrid({
		queryParams: {
			ClassName: "PHA.OP.RetQuery.Query",
			QueryName: "ReturnTotal",
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
	$("#sel-loc").empty();
	$('#returntotaldg').clearEasyUIGrid();
}

//��ӡ
function BPrintHandler() {
	//��ȡ���������������
	if ($('#returntotaldg').datagrid('getData').rows.length == 0) {
		dhcphaMsgBox.alert("ҳ��û������,�޷���ӡ!");
		return ;
	}
	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var daterange=startdate+" �� "+enddate;
	var title = DHCPHA_CONSTANT.SESSION.GHOSP_DESC+DHCPHA_CONSTANT.DEFAULT.LOC.text + "��ҩ����";
	var Para = {
		daterange: daterange,
		title: title
	}
	//��ӡ���� Huxt 2019-12-25
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPReturnTotal',
		data: {
			Para: Para,
			Grid: {type:'easyui', grid:'returntotaldg'}
		},
		listBorder: {style:4, startX:6, endX:160},
		page: {rows:30, x:6, y:4, fontname:'����', fontbold:'false', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'}
	});
}
