/**
 * @Description: �ƶ�ҩ�� - ������״ִ̬��		//����
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.boxreceive.csp
 * @Js:          pha/mob/v2/boxreceive.js
 * modified by MaYuqiang 20210330 ���湦���޸�Ϊ������״ִ̬��
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
PHA_COM.VAR = {
	CONFIG: null,
	statusColor: {},
	canAutoRec: false
};

$(function () {
	$('#panelBoxItm').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '������״ִ̬��' : '', 
		headerCls: 'panel-header-gray',
		iconCls: 'icon-scanning',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	// ��ʼ��
	InitDict();
	InitGridBoxItm();

	// �¼���
	$('#btnReceive').on("click", Execute);
	$('#btnClear').on("click", Clear);
	$('#btnFind').on("click", QueryBoxItm);
	$('#boxNo').on("keydown", function (e) {
		if (e.keyCode == 13) {
			PHA_COM.VAR.canAutoRec = true;
			QueryBoxItm();
		}
	});
	$('#prescNo').on("keydown", function (e) {
		if (e.keyCode == 13) {
			var prescNo = $('#prescNo').val();
			var toLocId = $('#toLocId').combobox('getValue');
			var boxStatus = $('#boxStatus').combobox('getValue');
			var retBoxStr = tkMakeServerCall('PHA.MOB.BoxFind.Query', 'GetBoxInfo', prescNo, toLocId, boxStatus);
			var retBoxArr = retBoxStr.split('^');
			$('#prescNo').val('');
			if (retBoxArr[0] < 0) {
				PHA.Alert("��ʾ", retBoxArr[1], retBoxArr[0]);
				return;
			}
			
			var retBoxId = retBoxArr[0];
			var retBoxNo = retBoxArr[1];
			$('#boxNo').val(retBoxNo);
			QueryBoxItm()
		}
	});
	$('#boxNo').focus();
})

// ��ʼ����
function InitDict() {
	// ��������
	PHA.ComboBox("fromLocId", {
		placeholder: '��ѡ���������...',
		url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.BoxReceive.Query&QueryName=FromLocList&toLocId=' + session['LOGON.CTLOCID'],
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox('setValue', data[0].RowId);
			}
		},
		onSelect: function (record) {
			QueryBoxItm();
		}
	});

	// �������
	PHA.ComboBox("toLocId", {
		placeholder: '��ѡ�񵽴����...',
		url: PHA_STORE.CTLoc().url,
		disabled: false,
		onLoadSuccess: function (data) {
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == session['LOGON.CTLOCID']) {
					$(this).combobox('setValue', iData.RowId);
				}
			}
		}
	});
	
	// ������״̬
	PHA.ComboBox("boxStatus", {
		placeholder: 'ִ��״̬...',
		url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.BoxFind.Query&QueryName=BoxStatus',
		onSelect: function (record) {
			QueryBoxItm();
		}
	});
	$('#boxStatus').combobox('setValue', '60');
	
	// ����Ĭ��
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
}

// ��ʼ�����
function InitGridBoxItm() {
	// ������
	var columns = [[{
				field: 'tSelect',
				checkbox: true
			}, {
				field: 'boxId',
				title: '������ID',
				width: 80,
				hidden: true
			}, {
				field: 'boxItmId',
				title: '��ϸID',
				width: 80,
				hidden: true
			}, {
				field: 'status',
				title: '״̬��',
				width: 80,
				hidden: true
			}, {
				field: 'statusDesc',
				title: '��ǰ״̬',
				width: 110,
				align: 'center',
				styler: function(value, rowData, rowIndex){
					if (PHA_COM.VAR.statusColor[value]) {
						return 'background-color:' + PHA_COM.VAR.statusColor[value] + "; color:white;";
					}
				}
			}, {
				field: 'boxNo',
				title: 'װ�䵥��',
				width: 130
			}, {
				field: 'boxPath',
				title: '����·��',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return rowData.fromLocDesc + "<b> �� </b>" + rowData.toLocDesc;
				}
			}, {
				field: 'createInfo',
				title: 'װ��',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'formHandInfo',
				title: '����',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'toHandInfo',
				title: '����',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'toCheckInfo',
				title: '�˶�',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'prescNo',
				title: '������',
				width: 140,
				align: 'left'
			}, {
				field: 'patNo',
				title: '�ǼǺ�',
				width: 110,
				align: 'center'
			}, {
				field: 'patName',
				title: '��������',
				width: 90
			}, {
				field: 'patAge',
				title: '����',
				width: 90
			}, {
				field: 'patSex',
				title: '�Ա�',
				width: 60,
				align: 'center'
			}, {
				field: 'bedNo',
				title: '����',
				width: 90
			}, {
				field: 'recLocDesc',
				title: '��ҩ����',
				width: 120
			}, {
				field: 'careProDesc',
				title: 'ҽ��',
				width: 90
			}, {
				field: 'cookPackQty',
				title: 'ÿ������',
				width: 80,
				hidden: true
			}, {
				field: 'cookPackML',
				title: 'һ������',
				width: 80
			}, {
				field: 'freqDesc',
				title: '��ҩƵ��',
				width: 160
			}, {
				field: 'duratDesc',
				title: '��ҩ�Ƴ�',
				width: 90
			}, {
				field: 'instDesc',
				title: '�÷�',
				width: 80
			}, {
				field: 'ordQty',
				title: '����',
				width: 80,
				hidden: true
			}, {
				field: 'phCookMode',
				title: '��ҩ��ʽ',
				width: 80,
				align: 'center'
			}, {
				field: 'packQty',
				title: '����',
				width: 100
			}, {
				field: 'Notes',
				title: '������ע',
				width: 100
			}, {
				field: 'Emergency',
				title: '�Ƿ�Ӽ�',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}
		]
	];

	// Grid��������
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.BoxReceive.Query',
			QueryName: 'BoxItm',
		},
		pageSize: 500,
		singleSelect: false,
		columns: columns,
		pagination: true,
		toolbar: '#gridBoxItmBar',
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$(this).datagrid('selectAll');
				var isRecWhenScan = $('#isRecWhenScan').checkbox('getValue');
				if (isRecWhenScan == true && PHA_COM.VAR.canAutoRec == true) {
					Execute();
				}
			} else {
				$(this).datagrid('unselectAll');
			}
			$('#boxNo').focus();
			PHA_COM.VAR.canAutoRec = false;
		}
	};
	PHA.Grid("gridBoxItm", dataGridOption);
}

// ��ѯ
function QueryBoxItm() {
	$('#prescNo').val('');
	var formDataArr = PHA.DomData("#gridBoxItmBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridBoxItm').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// ����
function Execute() {
	var checkedData = $('#gridBoxItm').datagrid('getChecked');
	if (checkedData == null) {
		PHA.Popover({
			msg: 'û����Ҫ���յĴ������ݣ�',
			type: "info"
		});
		return;
	}
	var boxNoArr = [];
	for (var i = 0; i < checkedData.length; i++) {
		var rowData = checkedData[i];
		var rowIndex = GetGridRowIndex('gridBoxItm', rowData);
		var boxNo = rowData.boxNo || "";
		if (boxNo == "") {
			PHA.Alert("��ʾ", '��' + (rowIndex + 1) + '��, װ�䵥��Ϊ�գ�', -2);
			return;
		}
		/*
		var status = rowData.status;
		if (status != '60') {
			PHA.Alert("��ʾ", '��' + (rowIndex + 1) + '��, ״̬����[�������ҽ���]״̬,���ܽ��գ�', -2);
			return;
		}
		*/
		if (boxNoArr.indexOf(boxNo) < 0) {
			boxNoArr.push(boxNo);
		}
	}
	var toExeText = $('#boxStatus').combobox('getText') || '';
	if (boxNoArr.length == 0) {
		PHA.Alert("��ʾ", 'û�п�ִ��[' + toExeText + ']�������䣡���Ȳ�ѯ...', -2);
		return;
	}
	
	var toExeCode = $('#boxStatus').combobox('getValue');
	var logisticsName = "" 	// ����������Ա
	if (toExeCode == 60){
		var logisticsName = $('#logisticName').val() ;
		if (logisticsName == ""){
			PHA.Alert("��ʾ", 'ִ�С��������ҽ��ӡ�ʱ��������Ա����Ϊ��...', -2);
			return ;	
		}
	}
	var boxNoStr = boxNoArr.join('^');
	var exeUserId = session['LOGON.USERID'];
	var userStr = exeUserId + "^" + logisticsName ; 
	
	// ���º�̨
	var retStr = tkMakeServerCall("PHA.MOB.BoxExecute.Save", "ExecuteBoxs", boxNoStr, toExeCode, userStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		// ������ʾ
		$.messager.alert($g("��ʾ"), $g("����ʧ��:") + retArr[1], "warning");
	} else {
		/* ����״̬
		for (var i = 0; i < checkedData.length; i++) {
			var rowData = checkedData[i];
			var rowIndex = GetGridRowIndex('gridBoxItm', rowData);
			RefreshRow(rowIndex);
		}
		*/
		PHA.Popover({
			msg: 'ִ�гɹ���',
			type: "success"
		});
		QueryBoxItm() ;
	}
}

// ���������ݻ�ȡ�к�
function GetGridRowIndex(_id, _rowData) {
	var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
	return rowIndex;
}

// ֻ����״̬,��ˢ�±��
function RefreshRow(rowIndex){
	var status = $('#boxStatus').combobox('getValue');
	var statusDesc = $('#boxStatus').combobox('getText');
	/*
	var boxId = ""
	var exeHandInfo = ""
	if (status == 20){
		var exeHandInfo = tkMakeServerCall("PHA.MOB.BoxFind.Query","GetFormHandInfo",boxId, "string")
		var handColDesc = "formHandInfo"
	}
	else if (status == 35){
		var exeHandInfo = tkMakeServerCall("PHA.MOB.BoxFind.Query","GetToHandInfo",boxId, "string")
		var handColDesc = "toHandInfo"
	}
	else if (status == 40){
		var exeHandInfo = tkMakeServerCall("PHA.MOB.BoxFind.Query","GetToCheckInfo",boxId, "string")
		var handColDesc = "toCheckInfo"
	}
	*/
	$('#gridBoxItm').datagrid('updateRow',{
		index: rowIndex,
		row: {
			status: status,
			statusDesc: statusDesc
			//handColDesc: exeHandInfo
		}
	});
	$('#gridBoxItm').datagrid('refreshRow', rowIndex);
}

// ���
function Clear() {
	PHA.DomData("#gridBoxItmBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	$('#fromLocId').combobox('setValue', '0');
	$('#toLocId').combobox('setValue', session['LOGON.CTLOCID']);
	$('#boxStatus').combobox('setValue', '60');
	$('#gridBoxItm').datagrid('clear');
}

// ��csp�е��� - ����
function ToggleFormPanle() {
	var $toolBar = $("#layout-formPanel").siblings().eq(0).children('.panel-tool').children().eq(0);
	var curIcon = $toolBar.attr('class');
	var newIcon = curIcon == 'icon-up-gray' ? 'icon-down-gray' : 'icon-up-gray';

	// ����
	if (curIcon == 'icon-up-gray') {
		$('#form-row2').hide();
		var northPanel = $('#layout').layout('panel', 'north');
		northPanel.panel('resize', {
			height: 95
		});
		$('#layout').layout('resize');
	}
	// չ��
	if (curIcon == 'icon-down-gray') {
		$('#form-row2').show();
		var northPanel = $('#layout').layout('panel', 'north');
		northPanel.panel('resize', {
			height: 135
		});
		$('#layout').layout('resize');
	}
	// ��ͼ��
	$toolBar.attr('class', newIcon);
}

function YesNoFormatter(value, row, index){
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// ��������
function InitConfig() {
	// ��ȡ��ɫ�б�
	var retColorStr = tkMakeServerCall("PHA.MOB.BoxFind.Query", "GetStatusColor");
	PHA_COM.VAR.statusColor = eval('(' + retColorStr + ')');
	
	// ��ȡͨ������
	$.cm({
		ClassName: "PHA.MOB.COM.PC",
		MethodName: "GetConfig",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
