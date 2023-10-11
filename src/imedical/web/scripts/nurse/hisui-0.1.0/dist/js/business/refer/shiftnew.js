/*
 * @Descripttion: �Ҽ�����-��������
 * @Author: yaojining
 */

var GV = {
	code: 'ShiftNew',
	groupID: 'groupShiftNew',
	hospitalID: session['LOGON.HOSPID'],
	wardID: session['LOGON.WARDID'],
	locID: session['LOGON.CTLOCID'],
	className: 'NurMp.Service.Refer.Handle',
	ConfigInfo: new Object(),
	OtherConfig: new Object()
};

/**
 * @description: ��ʼ������
 */
$(function () {
	initCondition();
	listenEvents();
});

/**
 * @description: ��ʼ������
 */
function initCondition() {
	initShiftBookList(function(){
		initShiftClassList(function(){
			requestConfig(initData);
		});
	});
}

/**
 * @description: ��ʼ������
 */
function initShiftBookList() {
	var callbackFun = arguments[0];
	$('#ShiftBookList').combogrid({
		url: $URL,
		queryParams: {
			ClassName: "Nur.SHIFT.Config.ShiftConfigController",
			MethodName: "GetShiftBookList"
		},
		mode: 'remote',
		panelWidth: 350,
		blurValidValue: true,
		idField: 'ID',
		textField: 'ShiftBookName',
		columns: [[
			{
				field: 'ShiftBookName', title: $g('����'), width: 150,
				formatter: function (value, row, index) {
					return $g(value)
				}
			}, {
				field: 'ShiftBookType', title: $g('����'), width: 80,
				formatter: function (value, row, index) {
					var text = ''
					if (value == 1) {
						text = '����'
					} else if (value == 2) {
						text = '����'
					} else if (value == 3) {
						text = '����'
					} else if (value == 4) {
						text = '������'
					} else {
						text = '����'
					}
					return $g(text)
				}
			}, {
				field: 'Remarks', title: $g('��ע'), width: 80,
				formatter: function (value, row, index) {
					return $g(value)
				}
			},

		]],
		fitColumns: true,
		onBeforeLoad: function (param) {
			var desc = '';
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { hospID: GV.hospitalID });
			return true;
		},
		onSelect: function (rowIndex, rowData) {
			reloadData();
		},
		onLoadSuccess: function (data) {
			$m({
				ClassName: 'Nur.SHIFT.Service.ShiftController',
				MethodName: 'GetWardShiftBookID',
				WardID: GV.wardID,
				LocID: GV.locID
			}, function(shiftBookID){
				if (!shiftBookID) {
					shiftBookID = 0;
				}
				$('#ShiftBookList').combogrid('setValue', shiftBookID);
				if (typeof callbackFun == 'function') {
					callbackFun();
				}
			});
		}
	});
}

/**
 * @description: ��ʼ�����
 */
function initShiftClassList() {
	var callbackFun = arguments[0];
	$('#ShiftClassList').combogrid({
		url: $URL,
		queryParams: {
			ClassName: "Nur.SHIFT.Config.ShiftConfigController",
			MethodName: "GetShiftClassList",
		},
		mode: 'remote',
		panelWidth: 350,
		blurValidValue: true,
		idField: 'ID',
		textField: 'ShiftClassName',
		columns: [[
			{
				field: 'ShiftClassName', title: $g('����'), width: 150,
				formatter: function (value, row, index) {
					return $g(value)
				}
			},
			{
				field: 'ShiftClassType', title: $g('����'), width: 80,
				formatter: function (value, row, index) {
					var text = ''
					if (value == 1) {
						text = '����'
					} else if (value == 2) {
						text = '����'
					} else if (value == 3) {
						text = '����'
					} else if (value == 4) {
						text = '�İ�'
					} else {
						text = '����'
					}
					return $g(text)
				}
			},
			{
				field: 'ShiftIsDefalut', title: $g('Ĭ�Ͻ���'), width: 80,
				formatter: function (value, row, index) {
					var text = '��'
					if (value == 1) {
						text = '��'
					}
					return $g(text)
				}
			},
			{
				field: 'isWard', title: $g('ȫԺ'), width: 80,
				formatter: function (value, row, index) {
					var text = '��'
					if (value == 0) {
						text = '��'
					}
					return $g(text)
				}

			}
		]],
		fitColumns: true,
		onBeforeLoad: function (param) {
			var desc = '';
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { HospID: GV.hospitalID, WardID: '', LocID: '' });
			return true;
		},
		onSelect: function (rowIndex, rowData) {
			reloadData();
		},
		onLoadSuccess: function (data) {
			var sel_id = data.rows[0].ID;
			$.each(data.rows, function (i, r) {
				if (r.ShiftIsDefalut == 1) {
					sel_id = r.ID;
					return false;
				}
			});
			$('#ShiftClassList').combogrid('setValue', sel_id);
			if (typeof callbackFun == 'function') {
				callbackFun();
			}
		}
	});
}

/**
 * @description: ��ʼ������
 * @param {object} config
 */
function initData(config) {
	console.log(config);
	var page_list = pageList();
	$('#dataGrid').datagrid({
		url: $URL,
		queryParams: initParameter(config),
		rownumbers: true,
		singleSelect: true,
		pagination: true,
		pageSize: page_list[0],
		pageList: page_list,
		frozenColumns: config.frozenColumns,
		columns: config.columns,
		nowrap: config.gridProperty.nowrap == "true",
		onLoadSuccess: function (data) {
			GV.OtherConfig = config.otherConfig;
		}
	});
}

/**
 * @description: ��֯���
 */
function initParameter() {
	var config = arguments[0];
	var startDate = $('#startDate').datebox('getValue');
	var endDate = $('#endDate').datebox('getValue');
	var shiftBookID = $('#ShiftBookList').combogrid('getValue');
	var shiftClassID =  $('#ShiftClassList').combogrid('getValue');
	eval(config.paramsCommand);
	// console.log(config.queryParams);
	return config.queryParams;
}

/**
 * @description: �����������
 */
function reloadData() {
	if (($('#dataGrid').length > 0) && (!$.isEmptyObject(GV.ConfigInfo))) {
		$('#dataGrid').datagrid('reload', initParameter(GV.ConfigInfo[GV.code]));
	}
}