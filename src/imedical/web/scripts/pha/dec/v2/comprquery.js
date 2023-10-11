/**
 * ģ��:     ��ҩ�ۺϲ�ѯ
 * ��д����: 2019-07-17
 * ��д��:   GuoFa
 */
$(function () {
	InitDict(); //��ʼ��������
	InitGridQueryDetail(); //��ʼ�����
	InitSetDefVal(); //��Ĭ��ֵ
	queryDecInfo();
	$("#txt-prescno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryDecInfo();
		}
	});
	//�����Żس��¼�
	$("#txt-patno").on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			queryDecInfo();
		}
	});
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryDecInfo();
			}
		}
	});
});
/**
 * ��ʼ�����
 * method InitDict
 */
function InitDict() {
	//��ҩ��
	PHA.ComboBox("cmbDecLoc", {
		width: 120,
		url: PHA_DEC_STORE.DecLoc().url,
		onSelect: function () {
			queryDecInfo();
		}
	});
	//��ǰ����
	PHA.ComboBox("cmbprocess", {
		width: 120,
		url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=DecProDict&locId=' + gLocId,
		idField: 'RowId',
		textField: 'Description',
		method: 'get',
		onSelect: function () {
			queryDecInfo();
		}
	});
}
/**
 * ��ʼ����ϸ���
 * @method InitGridQueryDetail
 */
function InitGridQueryDetail() {
	var columns = [[{
				field: 'RowId',
				title: '��ҩ����id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'patNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100
			}, {
				field: 'patName',
				title: '����',
				align: 'left',
				width: 100
			}, {
				field: 'prescno',
				title: '������',
				align: 'left',
				width: 150,
				styler: function(value,row,index){
					return 'color:blue';
				}
			}, {
				field: 'ordLoc',
				title: '��������',
				align: 'left',
				width: 150
			}, {
				field: 'pdDesc',
				title: '��ǰ����',
				align: 'left',
				width: 70
			}, {
				field: 'pdType',
				title: '��ҩ����',
				align: 'left',
				width: 70
			}, {
				field: 'compFlag',
				title: '��ɱ�־',
				align: 'left',
				width: 70
			}, {
				field: 'pdDate',
				title: '��������',
				align: 'left',
				width: 100
			}, {
				field: 'pdTime',
				title: '����ʱ��',
				align: 'left',
				width: 80
			}, {
				field: 'soakInterval',
				title: '����ʱ��(����)',
				align: 'left',
				width: 120
			}, {
				field: 'soakEquiDesc',
				title: '�����豸',
				align: 'left',
				width: 80
			}, {
				field: 'firWaterQua',
				title: '�׼��ˮ��(ml)',
				align: 'left',
				width: 120
			}, {
				field: 'firInterval',
				title: '�׼�ʱ��(����)',
				align: 'left',
				width: 120
			}, {
				field: 'firEquiDesc',
				title: '�׼��豸',
				align: 'left',
				width: 80
			}, {
				field: 'secWaterQua',
				title: '�����ˮ��(ml)',
				align: 'left',
				width: 120
			}, {
				field: 'secInterval',
				title: '����ʱ��(����)',
				align: 'left',
				width: 120
			}, {
				field: 'secEquiDesc',
				title: '�����豸',
				align: 'left',
				width: 80
			}, {
				field: 'labelNum',
				title: '��ǩ��',
				align: 'left',
				width: 60
			}, {
				field: 'boxNum',
				title: '��װ�����',
				align: 'left',
				width: 120
			}
		]];
	var dataGridOption = {
		columns: columns,
		rownumbers: true,
		toolbar: '#toolBarDecComQuery',
		border: true ,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.Compre.Query",
			QueryName: "QueryDecoInfo"
		},
		onClickCell: function (rowIndex, field, value) {
			var RowId = $(this).datagrid("getRows")[rowIndex].RowId;
			if (field == "prescno") {
				PHADEC_UX.TimeLine(
					{
						modal: true,
						top: null,
						modalable: true
					},
					{ phpmId: RowId }
				);
			}	
		}
	};
	PHA.Grid("gridQueryDetail", dataGridOption);
}

/**
 * ��ȡ����Ԫ��ֵ
 * method getParams
 */
function getParams() {
	var stDate = $("#startDate").datebox('getValue');
	var enDate = $("#endDate").datebox('getValue');
	var stTime = $('#startTime').timespinner('getValue') || "";
	var enTime = $('#endTime').timespinner('getValue') || "";
	var decLoc = $('#cmbDecLoc').combobox("getValue") || "";
	var type = $("input[name='busType']:checked").val() || "";
	var process = $('#cmbprocess').combobox("getValue") || "";
	var prescno = $.trim($("#txt-prescno").val());
	var patNo = $.trim($("#txt-patno").val());
	var succFlag = $('#chk-success').is(':checked');
	var succFlag = succFlag == true ? "Y" : "N";
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + decLoc + "^" + type + "^" + process + "^" + prescno + "^" + patNo + "^" + succFlag;
	return params;
}

/**
 * ��ѯtable
 * method queryDecInfo
 */
function queryDecInfo() {
	var inputStr = getParams();
	$('#gridQueryDetail').datagrid('query', {
		inputStr: inputStr
	});
}
/**
 * ��Ĭ��ֵ
 * method InitSetDefVal
 */
function InitSetDefVal() {
	//��������
	$.cm({
		ClassName: "PHA.DEC.Com.Method",
		MethodName: "GetAppProp",
		UserId: gUserID,
		LocId: gLocId,
		SsaCode: "DEC.COMMON",
	}, function (jsonComData) {
		$("#startDate").datebox("setValue", jsonComData.StatStartDate);
		$("#endDate").datebox("setValue", jsonComData.StatEndDate);
		$('#startTime').timespinner('setValue', "00:00:00");
		$('#endTime').timespinner('setValue', "23:59:59");
		$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
	});
}
//���
function ClearConditions() {
	InitSetDefVal();
	$("#cmbDecLoc").combobox('setValue', "");
	$("#cmbprocess").combobox('setValue', "");
	$("#txt-prescno").val("");
	$("#txt-patno").val("");
	$("#chk-success").checkbox("uncheck");	
	$("input[label='ȫ��']").radio("check");
	$('#gridQueryDetail').datagrid('loadData', {
		total: 0,
		rows: []
	});
}

window.onload=function(){
	setTimeout("queryDecInfo()",200);
}
