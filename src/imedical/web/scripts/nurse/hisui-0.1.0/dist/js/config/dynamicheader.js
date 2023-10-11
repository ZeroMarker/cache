/*
 * @Descripttion: ��������̬��ͷ����
 * @Author: yaojining
 * @Date: 2021-12-09 08:48:52
 */

var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ClassName: "NurMp.Service.Template.Header",
	ConfigTableName: "Nur_IP_Header",
	GUID: '',
	SelPanel: 'L',
	EditGrid: '#gridHeader'
};
var init = function () {
	initHosp(reloadHospData);
	initHeaderModel();
	initCondition();
	initgridL();
	initHeaderGrid();
	// $.parser.parse();
	listenEvents();
	setTimeout(function(){
		initgridL();
	},300);
}
$(init);

/**
 * @description: ��ʼ����̬��ͷģ��������
 */
function initHeaderModel() {
	var cbtreeModel =  $HUI.combotree('#cbtreeModel',{
		lines: true,
		panelWidth: 400,
		panelHeight: 500,
		delay: 500,
		onSelect: function (record) {
			$('#panelSearch').panel('setTitle', '���' + '&nbsp;&nbsp;<span>' + ' �� ' + record.text + '</span>');
			convertGuid(record.guid);
		},
		defaultFilter: 4
	});
	$cm({
		ClassName: "NurMp.DHCNurChangeLableRec",
		MethodName: "GetInternalConfigTree",
		Parr: "^^" + GLOBAL.HospitalID
	}, function (data) {
		cbtreeModel.loadData(data);
	});
}
/**
* @description: ����
*/
function initCondition() {
	$('#acRecommend').accordion({
		onSelect: function (title, index) {
			switch (index) {
				case 1: {
					GLOBAL.SelPanel = 'D';
					initgridD();
					reloadGridHeader();
					break;
				}
				case 2: {
					GLOBAL.SelPanel = 'R';
					initgridR();
					reloadGridHeader();
					break;
				}
				default: {
					GLOBAL.SelPanel = 'L';
					initgridL();
					reloadGridHeader();
				}
			}
		}
	});
}
/**
* @description: ��ʼ�����ұ��
*/
function initgridL() {
	$HUI.datagrid('#gridL', {
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: 'FindHeaderGroup',
			HospitalID: GLOBAL.HospitalID,
			Guid: GLOBAL.GUID,
			Type: 'L',
			Filter: $('#sbType').searchbox('getValue')
		},
		columns: [[
			{ field: 'HPName', title: '��������', width: 200 },
			{ field: 'HPDirectDr', title: '����ID', width: 100 },
			{ field: 'Id', title: '���ID', width: 100 }
		]],
		nowrap: false,
		singleSelect: true,
		pagination: true,
		pageSize: 12,
		pageList: [12, 30, 50],
		onClickRow: function (rowIndex, rowData) {
			if (endEditing()) {
				reloadGridHeader(rowData.Id);
			}
		},
	});
}
/**
* @description: ��ʼ����ϱ��
*/
function initgridD() {
	$HUI.datagrid('#gridD', {
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: 'FindHeaderGroup',
			HospitalID: GLOBAL.HospitalID,
			Guid: GLOBAL.GUID,
			Type: 'D',
			Filter: $('#sbType').searchbox('getValue')
		},
		columns: [[
			{ field: 'HPName', title: '�������', width: 200 },
			{ field: 'HPDirectDr', title: '���ID', width: 100 },
			{ field: 'Id', title: '���ID', width: 100 }
		]],
		nowrap: false,
		singleSelect: true,
		pagination: true,
		pageSize: 12,
		pageList: [12, 30, 50],
		onClickRow: function (rowIndex, rowData) {
			if (endEditing()) {
				reloadGridHeader(rowData.Id);
			}
		},
	});
}
/**
* @description: ��ʼ���Ƽ����
*/
function initgridR() {
	$HUI.datagrid('#gridR', {
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: 'FindHeaderGroup',
			HospitalID: GLOBAL.HospitalID,
			Guid: GLOBAL.GUID,
			Type: 'R',
			Filter: $('#sbType').searchbox('getValue')
		},
		columns: [[
			{ field: 'HPName', title: '����������', width: 400 },
			{ field: 'HPDirectDr', title: '�������ID', width: 100 },
			{ field: 'Id', title: '���ID', width: 100 }
		]],
		nowrap: false,
		singleSelect: true,
		pagination: true,
		pageSize: 12,
		pageList: [12, 30, 50],
		onClickRow: function (rowIndex, rowData) {
			if (endEditing()) {
				reloadGridHeader(rowData.Id);
			}
		},
	});
}
/**
* @description: ��ͷ���
*/
function initHeaderGrid() {
	$HUI.datagrid('#gridHeader', {
		url: $URL,
		queryParams: {
			ClassName: GLOBAL.ClassName,
			QueryName: "FindHeaderInfo",
			TypeId: ''
		},
		columns: [[
			{ field: 'HIDesc', title: '����', width: 200, editor: 'validatebox' },
			{ field: 'HISerialNo', title: '���', width: 100, hidden: true },
			{
				field: 'HIIsEnable', title: '����', width: 60, formatter: function (value, row) {
					return value === 'N' ? '��' : '��';
				},
				editor: {
					type: 'combobox',
					options: {
						valueField: 'value',
						textField: 'desc',
						required: true,
						editable: false,
						enterNullValueClear: false,
						data: [
							{ value: "Y", desc: "��" },
							{ value: "N", desc: "��" }
						]
					}
				}
			},
			{ field: 'Id', title: 'ID', width: 100 }
		]],
		nowrap: false,
		singleSelect: true,
		pagination: true,
		pageSize: 15,
		pageList: [15, 30, 50],
		onDblClickRow: clickRow,
	});
}
/**
 * @description: ���¼��ر�ͷ���
 */
function reloadGridHeader() {
	var par = arguments[0];
	if (!par) {
		var rows = $('#grid' + GLOBAL.SelPanel).datagrid('getSelections');
		if (rows.length == 1) {
			par = rows[0].Id;
		}
	}
	$('#gridHeader').datagrid('reload', {
		ClassName: GLOBAL.ClassName,
		QueryName: "FindHeaderInfo",
		TypeId: par
	});
}
/**
 * @description: ������Ӵ���
 */
function showAddTypeDialog() {
	if (!GLOBAL.GUID) {
		$.messager.alert("��ʾ", "��ѡ��̬��ͷ����", "info");
		return;
	}
	var domId = 'dialogAddType';
	var width = 600;
	if (GLOBAL.SelPanel == 'R') {
		domId = 'dialogAddRec';
		width = 900;
	}
	$('#' + domId).dialog({
		title: '����',
		buttons: [{
			text: '����',
			handler: saveType
		}, {
			text: '�ر�',
			handler: function () {
				$("#" + domId).dialog("close");
			}
		}],
		width: width,
		height: 568,
		onOpen: function (e) {
			initgridAdd();
		},
		closed: false
	});
}
/**
 * @description: ��ʼ����ӱ��
 */
function initgridAdd() {
	if (GLOBAL.SelPanel == 'L') {
		$('#gridAddType').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.Common.Base.Hosp',
				QueryName: 'FindHospLocs',
				HospitalID: GLOBAL.HospitalID,
				ConfigTableName: GLOBAL.ConfigTableName,
				SearchDesc: $('#sbAddType').searchbox('getValue')
			},
			columns: [[
				{ field: 'Checkbox', title: 'sel', checkbox: true },
				{ field: 'LocDesc', title: '����', width: 250 },
				{ field: 'HospDesc', title: 'Ժ��', width: 240 },
			]],
			idField: "LocId",
			pagination: true,
			pageSize: 10,
			pageList: [10, 30, 50],
			onLoadSuccess: function (data) {
				$('#gridAddType').datagrid('clearSelections');
			}
		});
	} else if (GLOBAL.SelPanel == 'D') {
		$('#gridAddType').datagrid({
			url: $URL,
			queryParams: {
				ClassName: GLOBAL.ClassName,
				QueryName: 'FindDiagInfo',
				HospitalID: GLOBAL.HospitalID,
				ConfigTableName: GLOBAL.ConfigTableName,
				SearchDesc: $('#sbAddType').searchbox('getValue')
			},
			columns: [[
				{ field: 'Checkbox', title: 'sel', checkbox: true },
				{ field: 'DiagDesc', title: '����', width: 250 }
			]],
			idField: "Id",
			pagination: true,
			pageSize: 10,
			pageList: [10, 30, 50],
			onLoadSuccess: function (data) {
				$('#gridAddType').datagrid('clearSelections');
			}
		});
	} else {
		$('#gridAddLoc').datagrid({
			url: $URL,
			queryParams: {
				ClassName: 'NurMp.Common.Base.Hosp',
				QueryName: 'FindHospLocs',
				HospitalID: GLOBAL.HospitalID,
				ConfigTableName: GLOBAL.ConfigTableName,
				SearchDesc: $('#sbAddType').searchbox('getValue')
			},
			columns: [[
				{ field: 'Checkbox', title: 'sel', checkbox: true },
				{ field: 'LocDesc', title: '����', width: 200 },
				{ field: 'HospDesc', title: 'Ժ��', width: 240 },
			]],
			idField: "LocId",
			singleSelect: true,
			pagination: true,
			pageSize: 9,
			pageList: [9, 30, 50],
			onLoadSuccess: function (data) {
				$('#gridAddLoc').datagrid('clearSelections');
			}
		});
		$('#gridAddDiag').datagrid({
			url: $URL,
			queryParams: {
				ClassName: GLOBAL.ClassName,
				QueryName: 'FindDiagInfo',
				HospitalID: GLOBAL.HospitalID,
				ConfigTableName: GLOBAL.ConfigTableName,
				SearchDesc: $('#sbAddType').searchbox('getValue')
			},
			columns: [[
				{ field: 'Checkbox', title: 'sel', checkbox: true },
				{ field: 'DiagDesc', title: '����', width: 250 },
				{ field: 'Id', title: 'ID', width: 250 }
			]],
			idField: "Id",
			singleSelect: false,
			pagination: true,
			pageSize: 9,
			pageList: [9, 30, 50],
			onLoadSuccess: function (data) {
				$('#gridAddDiag').datagrid('clearSelections');
			}
		});
	}
}
/**
 * @description: ����ѡ��
 */
function saveType() {
	var arrItems = new Array();
	if (GLOBAL.SelPanel == 'R') {
		var locRows = $('#gridAddLoc').datagrid('getSelections');
		if (locRows.length < 1) {
			$.messager.alert("��ʾ", "��ѡ����ң�", "info");
			return;
		}
		var dirRows = $('#gridAddDiag').datagrid('getSelections');
		if (dirRows.length < 1) {
			$.messager.alert("��ʾ", "��ѡ����ϣ�", "info");
			return;
		}
		var arr_dir = [];
		$.each(dirRows, function(index, row){
			arr_dir.push(locRows[0].LocId + '|' + row.Id);
			
		});
		directId = arr_dir.join(',');
		var objItem = new Object();
		objItem['RowID'] = '';
		objItem['HPHospDr'] = GLOBAL.HospitalID;
		objItem['HPGuid'] = GLOBAL.GUID;
		objItem['HPType'] = GLOBAL.SelPanel;
		objItem['HPDirectDr'] = directId;
		arrItems.push(objItem);
	} else {
		var addItems = $('#gridAddType').datagrid('getSelections');
		if (addItems.length < 1) {
			$.messager.alert("��ʾ", "��ѡ����Ҫ��ӵ��", "info");
			return;
		}
		$.each(addItems, function (index, item) {
			var objItem = new Object();
			objItem['RowID'] = '';
			objItem['HPHospDr'] = GLOBAL.HospitalID;
			objItem['HPGuid'] = GLOBAL.GUID;
			objItem['HPType'] = GLOBAL.SelPanel;
			objItem['HPDirectDr'] = GLOBAL.SelPanel == 'L' ? item.LocId : item.Id;
			arrItems.push(objItem);
		});
	}
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: 'SaveType',
		ClsName: 'CF.NUR.EMR.Header',
		Param: JSON.stringify(arrItems)
	}, function (result) {
		if (result.status >= 0) {
			$.messager.popover({ msg: result.msg, type: "success" });
			$('#btnSearchType').click();
			if (GLOBAL.SelPanel == 'R') {
				$("#dialogAddRec").dialog("close");
			} else {
				$("#dialogAddType").dialog("close");
			}
		} else {
			$.messager.popover({ msg: result.msg, type: "error" });
			return;
		}
	});
}
/**
 * @description: ɾ�����
 */
function removeType() {
	var rows = $('#grid' + GLOBAL.SelPanel).datagrid('getSelections');
	if (rows.length < 1) {
		$.messager.alert("��ʾ", "��ѡ����Ҫ��Ҫɾ�������", "info");
		return;
	}
	var ids = null;
	$.each(rows, function (index, row) {
		ids = !!ids ? ids + '^' + row.Id : row.Id;
	});
	$.messager.confirm("����", "ȷ��Ҫɾ����", function (r) {
		if (r) {
			$cm({
				ClassName: 'NurMp.Common.Logic.Handler',
				MethodName: 'Delete',
				ClsName: 'CF.NUR.EMR.Header',
				Ids: ids
			}, function (result) {
				if (result.status >= 0) {
					$.messager.popover({ msg: result.msg, type: "success" });
					$('#btnSearchType').click();
				} else {
					$.messager.popover({ msg: result.msg, type: "error" });
					return;
				}
			});
		} else {
			return;
		}
	});
}
/**
 * @description: ������ͷ
 */
function addHeader() {
	var rows = $('#grid' + GLOBAL.SelPanel).datagrid('getSelections');
	if (rows.length < 1) {
		$.messager.alert("��ʾ", "��ѡ�����", "info");
		return;
	}
	append({ HIIsEnable: 'Y' });
}
/**
 * @description: �����ͷ
 */
function saveHeader() {
	var types = $('#grid' + GLOBAL.SelPanel).datagrid('getSelections');
	if (types.length < 1) {
		return;
	}
	var addItems = getChanges();
	if (addItems.length == 0) {
		$.messager.alert("��ʾ", "����ӱ�ͷ��", "info");
		return;
	}
	var arrItems = new Array();
	$.each(addItems, function (index, item) {
		var objItem = new Object();
		objItem['RowID'] = !item.Id ? types[0].Id + '||' : item.Id;
		objItem['HIDesc'] = item.HIDesc;
		objItem['HISerialNo'] = 1;
		objItem['HIIsEnable'] = item.HIIsEnable;
		arrItems.push(objItem);
	});
	$cm({
		ClassName: GLOBAL.ClassName,
		MethodName: 'SaveHeader',
		ClsName: 'CF.NUR.EMR.HeaderItem',
		Param: JSON.stringify(arrItems)
	}, function (result) {
		if (result.status >= 0) {
			$.messager.popover({ msg: result.msg, type: "success" });
			reloadGridHeader();
		} else {
			$.messager.popover({ msg: result.msg, type: "error" });
			return;
		}
	});
	accept();
}
/**
 * @description: ɾ����ͷ
 */
function removeHeader() {
	var headers = $('#gridHeader').datagrid('getSelections');
	if (headers.length < 1) {
		$.messager.alert("��ʾ", "��ѡ��Ҫɾ���ı�ͷ��", "info");
		return;
	}
	var ids = null;
	$.each(headers, function (index, header) {
		ids = !!ids ? ids + '^' + header.Id : header.Id;
	});
	$.messager.confirm("��ʾ", "ȷ��ɾ��ѡ�еļ�¼��?", function (r) {
		if (r) {
			$cm({
				ClassName: 'NurMp.Common.Logic.Handler',
				MethodName: "Delete",
				ClsName: 'CF.NUR.EMR.HeaderItem',
				Ids: ids
			}, function (result) {
				if (result.status >= 0) {
					$.messager.popover({ msg: result.msg, type: "success" });
					reloadGridHeader();
				} else {
					$.messager.popover({ msg: result.msg, type: "error" });
					return;
				}
			});
		} else {
			return;
		}
	});
}
/**
 * @description: ���¼ӿ��ұ��
 */
function reloadGridType() {
	$('#grid' + GLOBAL.SelPanel).datagrid('reload', {
		ClassName: GLOBAL.ClassName,
		QueryName: 'FindHeaderGroup',
		HospitalID: GLOBAL.HospitalID,
		Guid: GLOBAL.GUID,
		Type: GLOBAL.SelPanel,
		Filter: $('#sbType').searchbox('getValue')
	});
}

/**
 * @description: ѡ��Ժ���Ļص�����
 */
function reloadHospData() {
	$('#cbtreeModel').combotree('options').url = $URL + "?ClassName=NurMp.DHCNurChangeLableRec&MethodName=GetInternalConfigTree&Parr=^^" + GLOBAL.HospitalID;
	$('#cbtreeModel').combotree('reload');
	$('#cbtreeModel').combotree('setValue', '');
	$('#panelSearch').panel('setTitle', '���');
	GLOBAL.GUID = '';
	reloadGridType();
	reloadGridHeader();
}
/**
 * @description: ���ݽ���Guid����¼������guid
 * @param {String} Guid
 * @return {String} guid
 */
function convertGuid(Guid) {
	if (!Guid) return;
	$m({
		ClassName: GLOBAL.ClassName,
		MethodName: 'getHeadChildGuid',
		Guid: Guid
	}, function(guid) {
		GLOBAL.GUID = guid;
		reloadGridType();
		reloadGridHeader();
	});
}
/**
 * @description: �����¼�
 */
function listenEvents() {
	$('#sbType').searchbox("textbox").keydown(function (e) {
		if (e.keyCode == 13) {
			$("#btnSearchType").click();
		}
	});
	$('#btnSearchType').bind('click', function (e) {
		reloadGridType();
		$('#grid' + GLOBAL.SelPanel).datagrid('clearSelections');
		reloadGridHeader();
	});
	$('#btnAddType').bind('click', showAddTypeDialog);
	$('#btnRemoveType').bind('click', removeType);

	$('#sbAddType').searchbox("textbox").keydown(function (e) {
		if (e.keyCode == 13) {
			$("#btnSearchAddType").click();
		}
	});
	$('#btnSearchAddType').bind('click', function (e) {
		if (GLOBAL.SelPanel == 'D') {
			$('#gridAddType').datagrid('reload', {
				ClassName: GLOBAL.ClassName,
				QueryName: 'FindDiagInfo',
				HospitalID: GLOBAL.HospitalID,
				ConfigTableName: GLOBAL.ConfigTableName,
				Filter: $('#sbAddType').searchbox('getValue')
			});
		} else {
			$('#gridAddType').datagrid('reload', {
				ClassName: 'NurMp.Common.Base.Hosp',
				QueryName: 'FindHospLocs',
				HospitalID: GLOBAL.HospitalID,
				ConfigTableName: GLOBAL.ConfigTableName,
				SearchDesc: $('#sbAddType').searchbox('getValue')
			});
		}
	});

	$('#sbAddLoc').searchbox("textbox").keydown(function (e) {
		if (e.keyCode == 13) {
			$("#btnSearchAddLoc").click();
		}
	});
	$('#btnSearchAddLoc').bind('click', function (e) {
		$('#gridAddLoc').datagrid('reload', {
			ClassName: 'NurMp.Common.Base.Hosp',
			QueryName: 'FindHospLocs',
			HospitalID: GLOBAL.HospitalID,
			ConfigTableName: GLOBAL.ConfigTableName,
			SearchDesc: $('#sbAddLoc').searchbox('getValue')
		});
	});

	$('#sbAddDiag').searchbox("textbox").keydown(function (e) {
		if (e.keyCode == 13) {
			$("#btnSearchAddDiag").click();
		}
	});
	$('#btnSearchAddDiag').bind('click', function (e) {
		$('#gridAddDiag').datagrid('reload', {
			ClassName: GLOBAL.ClassName,
			QueryName: 'FindDiagInfo',
			HospitalID: GLOBAL.HospitalID,
			ConfigTableName: GLOBAL.ConfigTableName,
			Filter: $('#sbAddDiag').searchbox('getValue')
		});
	});

	$('#btnAddHeader').bind('click', addHeader);
	$('#btnRemoveHeader').bind('click', removeHeader);
	$('#btnResetHeader').bind('click', reject);
	$('#btnSaveHeader').bind('click', saveHeader);
}
