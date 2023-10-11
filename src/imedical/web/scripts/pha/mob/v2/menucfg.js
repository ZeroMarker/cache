/**
 * Desc:    �û�/����/��ȫ�����������ҩ���� ά��
 * Creator: Huxt 2019-09-11
 * scripts/pha/mob/v2/menucfg.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	PHA.SearchBox("conAuthAlias", {
		searcher: QueryAuth,
		placeholder: "�������ƴ�����ƻس���ѯ"
	});
	PHA.SearchBox("conMenuAlias", {
		searcher: QueryMenu,
		placeholder: "�������ƴ�����ƻس���ѯ,˫����Ȩ"
	});
	PHA.ComboBox("cmbPro", {
		url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=DHCStkSysPro&ActiveFlag=Y",
		placeholder: "��ѡ���Ʒ��...",
		width: 266,
		onSelect: function (rowData) {
			QueryMenu();
			QueryCfgItm();
		}

	});
	InitHosp();
	InitKeyWords();
	InitGridAuth();
	InitGridMenu();
	InitGridCfgItm();
});

// ��ʼ�� - �¼�
function InitKeyWords() {
	$("#kwAuthType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [{
				text: '�û�',
				id: 'U'
			},
			{
				text: '��ȫ��',
				id: 'G'
			}, {
				text: '����',
				id: 'L',
				selected: true
			}
			// ��ʱȥ��,�����2843099. Huxt 2022-08-05
			/*, {
				text: 'ҽԺ',
				id: 'H'
			}*/
		],
		onClick: function (v) {
			QueryAuth();
		}
	});
	$("#kwAuthStat").keywords({
		singleSelect: false,
		labelCls: 'red',
		items: [{
				text: 'δ��Ȩ',
				id: 'N',
				selected: true
			}, {
				text: '����Ȩ',
				id: 'Y',
				selected: true
			}
		],
		onClick: function (v) {
			QueryAuth();
		}
	});
}

// ��� - �˵���Ȩ
function InitGridAuth() {
	var columns = [
		[{
				field: "authId",
				title: 'Ȩ��Id',
				hidden: true,
				width: 100
			}, {
				field: "authDesc",
				title: '����',
				width: 150
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.MenuCfg.Query',
			QueryName: 'AuthType',
			Type: "L",
			InputStr: "^A"
		},
		displayMsg: "",
		pagination: true,
		columns: columns,
		fitColumns: true,
		toolbar: "#gridAuthBar",
		onSelect: function (rowIndex, rowData) {
			QueryMenu();
			QueryCfgItm();
		},
		onLoadSuccess: function () {
			$("#gridMenu").datagrid("clear");
			$("#gridCfgItm").datagrid("clear");
		}
	};
	PHA.Grid("gridAuth", dataGridOption);
}

// ��� - �˵�
function InitGridMenu() {
	var columns = [
		[{
				field: "menuId",
				title: '�˵�Id',
				hidden: true,
				width: 100
			}, {
				field: "menuOperate",
				title: '����',
				width: 20,
				align: "center",
				formatter: function (value, rowData, rowIndex) {
					return '<img title="' + $g('��Ȩ') + '" onclick="AddCfgItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/select_grant.png" style="border:0px;cursor:pointer">'
				}
			}, {
				field: "menuDesc",
				title: '����',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.MenuCfg.Query',
			QueryName: 'PHAINMobMenu'
		},
		fitColumns: true,
		singleSelect: true,
		toolbar: "#gridMenuBar",
		pagination: false,
		columns: columns,
		onSelect: function (rowIndex, rowData) {},
		onDblClickRow: function (index, row) {
			AddCfgItm()
		},
		onLoadSuccess: function () {
			// $("#gridMenu").datagrid("enableDnd");  // ��������ӵ�Ԫ��༭,�г�ͻ
		}
	};
	PHA.Grid("gridMenu", dataGridOption);
}

// ��Ȩ
function AddCfgItm() {
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "��ѡ��ҽԺ!!!",
			type: 'alert'
		});
		return;
	}
	var $target = $(event.target);
	var menuRowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
	var menuRowData = $("#gridMenu").datagrid("getRows")[menuRowIndex];
	var authType = $("#kwAuthType").keywords("getSelected")[0].id;
	var authId = $("#gridAuth").datagrid("getSelected").authId;
	var menuId = menuRowData.menuId;
	var saveRet = $.cm({
		ClassName: 'PHA.MOB.MenuCfg.Save',
		MethodName: 'Save',
		DataStr: authType + "^" + authId + "^" + menuId + "^" + hospId,
		dataType: 'text',
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Popover({
			msg: saveInfo,
			type: 'alert'
		});
		return;
	}
	var newCfgItmRow = {
		cfgItmId: saveVal,
		menuId: menuRowData.menuId,
		menuDesc: menuRowData.menuDesc
	}
	$("#gridMenu").datagrid("deleteRow", menuRowIndex);
	$("#gridCfgItm").datagrid("appendRow", newCfgItmRow);
	RefreshGrid();

	// ��ʾ
	PHA.Popover({
		msg: '��Ȩ�ɹ���',
		type: 'success'
	});
}

// ȡ����Ȩ
function DelCfgItm() {
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: "��ѡ��ҽԺ!!!",
			type: 'alert'
		});
		return;
	}
	var $target = $(event.target);
	var cfgItmRowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
	var cfgItmRowData = $("#gridCfgItm").datagrid("getRows")[cfgItmRowIndex];
	var saveRet = $.cm({
		ClassName: 'PHA.MOB.MenuCfg.Save',
		MethodName: 'Delete',
		RowId: cfgItmRowData.cfgItmId,
		HospId: hospId,
		dataType: 'text',
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Popover({
			msg: saveInfo,
			type: 'alert'
		});
		return;
	}
	var newMenuRow = {
		menuId: cfgItmRowData.menuId,
		menuDesc: cfgItmRowData.menuDesc
	}
	$("#gridCfgItm").datagrid("deleteRow", cfgItmRowIndex);
	$("#gridMenu").datagrid("appendRow", newMenuRow);
	QueryMenu(); // RefreshGrid();
	// ��ʾ
	PHA.Popover({
		msg: 'ȡ����Ȩ�ɹ���',
		type: 'success'
	});
}

// ��ʼ����� - ����Ȩ
function InitGridCfgItm() {
	var columns = [
		[{
				field: "cfgItmId",
				title: '�����ӱ�Id',
				hidden: true
			}, {
				field: "menuId",
				title: '�˵�Id',
				hidden: true
			}, {
				field: "menuCfgOperate",
				title: '����',
				width: 10,
				align: "center",
				formatter: function () {
					return '<img title="' + $g('ȡ����Ȩ') + '" onclick="DelCfgItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_select_grant.png" style="border:0px;cursor:pointer">'
				}
			}, {
				field: "menuDesc",
				title: '����',
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.MenuCfg.Query',
			QueryName: 'PHAINMenuCfgItm'
		},
		fitColumns: true,
		pagination: false,
		columns: columns,
		toolbar: [],
		onDrop: function () {
			var cfgItmIdStr = "";
			var rows = $("#gridCfgItm").datagrid("getRows");
			var rowsLen = rows.length;
			for (var i = 0; i < rowsLen; i++) {
				var cfgItmId = rows[i].cfgItmId;
				cfgItmIdStr = (cfgItmIdStr == "") ? cfgItmId : cfgItmIdStr + "^" + cfgItmId;
			}
			var saveRet = $.cm({
				ClassName: 'PHA.MOB.MenuCfg.Save',
				MethodName: 'ReBuildSortCode',
				DataStr: cfgItmIdStr,
				dataType: 'text',
			}, false);
			var saveArr = saveRet.split('^');
			var saveVal = saveArr[0];
			var saveInfo = saveArr[1];
			if (saveVal < 0) {
				PHA.Popover({
					msg: saveInfo,
					type: 'alert'
				});
			}
		},
		onLoadSuccess: function () {
			$("#gridCfgItm").datagrid("enableDnd"); // ��������ӵ�Ԫ��༭,�г�ͻ
		}
	};
	PHA.Grid("gridCfgItm", dataGridOption);

}

function QueryAuth() {
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		return false;
	}
	var conAuthAlias = $("#conAuthAlias").searchbox("getValue") || "";
	var authType = $("#kwAuthType").keywords("getSelected")[0].id;
	var authStatSel = $("#kwAuthStat").keywords("getSelected");
	var authStat = "";
	if (authStatSel.length == 2) {
		authStat = "A";
	} else if (authStatSel.length == 1) {
		authStat = $("#kwAuthStat").keywords("getSelected")[0].id;
	}
	if (authStat == "") {
		PHA.Popover({
			msg: "����ѡ��[����Ȩ][δ��Ȩ]������",
			type: 'alert'
		});
		return;
	}
	$("#gridAuth").datagrid("query", {
		InputStr: conAuthAlias + "^" + authStat + "^" + hospId,
		Type: authType
	})
}

function QueryMenu() {
	var hospId = $('#_HospList').combogrid('getValue') || "";
	var gridSelect = $('#gridAuth').datagrid('getSelected');
	if (gridSelect == null) {
		PHA.Popover({
			msg: '����ѡ����Ȩ���',
			type: 'alert'
		});
		return;
	}
	var proId = $("#cmbPro").combobox("getValue") || "";
	if (proId == "") {
		PHA.Popover({
			msg: '��ѡ���Ʒ��',
			type: 'alert'
		});
		$("#gridMenu").datagrid('clear');
		$("#gridCfgItm").datagrid('clear');
		return;
	}
	var inputArr = [];
	inputArr.push($("#kwAuthType").keywords("getSelected")[0].id);
	inputArr.push(gridSelect.authId);
	inputArr.push($("#conMenuAlias").searchbox("getValue") || "");
	inputArr.push(hospId);
	inputArr.push(proId);
	$("#gridMenu").datagrid("query", {
		InputStr: inputArr.join("^")
	});
}

function QueryCfgItm() {
	var hospId = $('#_HospList').combogrid('getValue') || "";
	var gridSelect = $('#gridAuth').datagrid('getSelected');
	if (gridSelect == null) {
		return;
	}
	var proId = $("#cmbPro").combobox("getValue") || "";
	if (proId == "") {
		PHA.Popover({
			msg: '��ѡ���Ʒ��',
			type: 'alert'
		});
		$("#gridMenu").datagrid('clear');
		$("#gridCfgItm").datagrid('clear');
		return;
	}
	var inputArr = [];
	inputArr.push($("#kwAuthType").keywords("getSelected")[0].id);
	inputArr.push(gridSelect.authId);
	inputArr.push(hospId);
	inputArr.push(proId);
	$("#gridCfgItm").datagrid("query", {
		InputStr: inputArr.join("^")
	});
}

// ǰ̨�����ع����
function RefreshGrid() {
	$("#gridMenu").datagrid('loadData', $("#gridMenu").datagrid('getRows'));
	$("#gridCfgItm").datagrid('loadData', $("#gridCfgItm").datagrid('getRows'));
}

/*
 * @description: ��Ժ������ - ���س�ʼ��ҽԺ
 */
function InitHosp() {
	var hospComp = GenHospComp("PHAIN_MenuConfig");
	hospComp.options().onSelect = function (record) {
		QueryAuth();
	}
	hospComp.options().onLoadSuccess = function (record) {
		QueryAuth();
	}
}
