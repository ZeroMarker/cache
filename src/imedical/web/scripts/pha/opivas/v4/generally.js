/**
 * ����:	 ������Һϵͳ-��Һ�ۺϲ�ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2019-07-01
 */
PHA_COM.App.Csp = "pha.opivas.v4.generally.csp"
	var GENERALLY_DEFAULT = [{
			conStDate: "t",
			conEdDate: "t",
			conStTime: "",
			conEdTime: "",
			conPack: {
				RowId: "",
				Select: false
			}
		}
	];

$(function () {
	var isTabMenu = PHA_COM.IsTabsMenu ? PHA_COM.IsTabsMenu() : false;
	$('#panelGenerally').panel({
		title: isTabMenu !== true ? '��Һ�ۺϲ�ѯ' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-pivas-query',
		bodyCls: 'panel-body-gray',
		fit: true
	});

	InitDict();
	InitGridGenerally();
	$("#btnFind").on("click", Query);
	$("#btnClean").on("click", Clean);
	$("#btnPrint").on("click", PrintLabel);
	$("#btnPrintArrange").on("click", PrintArrange);
	$("#btnAllSelect").on("click", function () {
		CheckRowsGlobal("", "Y", "Y");
	});
	$("#btnAllUnSelect").on("click", function () {
		CheckRowsGlobal("", "N", "Y");
	});
	PHA_OPIVAS_COM.Bind.KeyDown.PatNo("conPatNo", Query);
	PHA_OPIVAS_COM.Bind.KeyDown.Event("conBarCode", Query);
	PHA.SetVals(GENERALLY_DEFAULT);
});

function InitDict() {
	PHA.ComboBox("conPivasLoc", {
		url: PHA_STORE.Pharmacy("OPIVAS").url,
		editable: false,
		panelHeight: "auto",
		onLoadSuccess: function (data) {
			$(this).combobox("select", data[0].RowId)
		}
	});
	PHA.ComboBox("conPS", {
		editable: true,
		url: PHA_OPIVAS_STORE.PIVAState().url + "&InputStr=" + session['LOGON.CTLOCID'],
		panelHeight: "auto",
		onSelect: function () {},
		onLoadSuccess: function (data) {
			// $(this).combobox("showPanel");
		}
	});
	PHA.ComboBox("conPack", {
		editable: false,
		url: PHA_OPIVAS_STORE.PIVADISPackFlag().url,
		panelHeight: "auto",
		onSelect: function () {
			Query();
		}
	});

	var opts = $.extend({}, PHA_STORE.ArcItmMast(), {
		width: (typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite') ? 297 : 305,
		panelWidth: 500,
		fitColumns: true
	})
		PHA.LookUp("conArcim", opts);
	PHA.TriggerBox("conPOGSNo", {
		handler: function (data) {
			PHA_OPIVAS_UX.POGSNo({
				locId: $("#conPivasLoc").combobox("getValue") || ""
			}, function (data) {
				$("#conPOGSNo").triggerbox("setValue", data.pogsNo).triggerbox("setValueId", data.pogsNo);
				Query();
			});
		},
		width: 305
	});
	PHA.ComboBox("conDocLoc", {
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("conEMLGLoc", {
		url: PHA_STORE.EMLGLoc().url
	});
}

function InitGridGenerally() {
	var columns = [
		[{
				field: "pid",
				title: '���̺�',
				width: 100,
				hidden: true
			}, {
				field: "mDspId",
				title: 'mDspId',
				width: 95,
				hidden: true
			}, {
				field: "pogId",
				title: 'pogId',
				width: 95,
				hidden: true
			}, {
				field: 'oeoreChk',
				checkbox: true
			}, {
				field: "warn",
				title: '����',
				width: 75,
				styler: PHA_OPIVAS_COM.Grid.Styler.Warn
			}, {
				field: "psName",
				title: '��Һ״̬',
				width: 75,
				styler: PHA_OPIVAS_COM.Grid.Styler.PS
			}, {
				field: "packFlag",
				title: '���',
				width: 45,
				align: "center",
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
				styler: PHA_OPIVAS_COM.Grid.Styler.Pack
			}, {
				field: "doseDateTime",
				title: '��ҩʱ��',
				width: 100
			}, {
				field: "patNo",
				title: '�ǼǺ�',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.AdmDetail(value, row, index, "oeori")
				}
			}, {
				field: "patName",
				title: '����',
				width: 100
			}, {
				field: "patSex",
				title: '�Ա�',
				width: 45,
				align: "center"
			}, {
				field: "patAge",
				title: '����'
			}, {
				field: "oeoriSign",
				title: '��',
				width: 30,
				formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
			}, {
				field: "inciDesc",
				title: 'ҩƷ����',
				width: 250
			}, {
				field: "dosage",
				title: '����'
			}, {
				field: "instrucDesc",
				title: '�÷�',
				width: 75
			}, {
				field: "freqDesc",
				title: 'Ƶ��'
			}, {
				field: "duraDesc",
				title: '�Ƴ�',
				width: 75
			}, {
				field: "oeoriRemark",
				title: 'ҽ����ע',
				width: 100
			}, {
				field: "ivgttSpeed",
				title: '����',
				width: 80
			}, {
				field: "docLocDesc",
				title: 'ҽ������',
				width: 100
			}, {
				field: "docName",
				title: 'ҽ��',
				width: 100
			}, {
				field: "exceedReason",
				title: '�Ƴ̳���ԭ��',
				width: 125
			}, {
				field: "prescNo",
				title: '������',
				width: 125
			}, {
				field: "oeoriStatus",
				title: 'ҽ��״̬',
				width: 70,
				align: "center"
			}, {
				field: "oeoreStatus",
				title: 'ִ�м�¼״̬',
				width: 100
			}, {
				field: "oeori",
				title: 'ҽ��ID',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.OrderDetail(value, row, index, "oeori")
				}
			}, {
				field: "barCode",
				title: '����',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.PSDetail(value, row, index, "barCode")
				}
			}, {
				field: "check",
				title: 'check',
				width: 100,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		exportXls: false,
		url: "pha.opivas.v4.broker.csp",
		queryParams: {
			ClassName: 'PHA.OPIVAS.Generally.Query',
			QueryName: 'Generally',
			GrpField: "mDspId",
			LogonStr: PHA_COM.Session.ALL
		},
		pagination: true,
		columns: columns,
		nowrap: true,
		singleSelect: false,
		toolbar: "#gridGenerallyBar",
		onCheck: function (rowIndex, rowData) {
			if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
			PHA_OPIVAS_COM.Grid.LinkCheck.Do({
				CurRowIndex: rowIndex,
				GridId: 'gridGenerally',
				Field: 'mDspId',
				Check: true,
				Value: rowData.mDspId
			});
			CheckRowsGlobal(rowData.mDspId, "Y");
			$(this).datagrid("options").checking = "";

		},
		onUncheck: function (rowIndex, rowData) {
			if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
			PHA_OPIVAS_COM.Grid.LinkCheck.Do({
				CurRowIndex: rowIndex,
				GridId: 'gridGenerally',
				Field: 'mDspId',
				Check: false,
				Value: rowData.mDspId
			});
			CheckRowsGlobal(rowData.mDspId, "N");
			$(this).datagrid("options").checking = "";
		},
		onCheckAll: function (rows) {
			if ($(this).datagrid("options").checking == true) {
				return;
			}
			CheckPage(rows, "Y");
		},
		onUncheckAll: function (rows) {
			if ($(this).datagrid("options").checking == true) {
				return;
			}
			CheckPage(rows, "N");
		},
		onLoadSuccess: function (data) {
			$(this).datagrid("options").checking = true;
			var row0Data = data.rows[0];
			if (row0Data) {
				$(this).datagrid("checkAll")
				var pid = row0Data.pid;
				$(this).datagrid("options").queryParams.Pid = pid;
				var rows = $(this).datagrid("getRows");
				var rowsLen = rows.length;
				for (var index = (rowsLen - 1); index >= 0; index--) {
					// ѡ��
					var rowData = rows[index];
					var check = rowData.check;
					if (check != "Y") {
						$(this).datagrid("uncheckRow", index);
					}
				}
			} else {
				$(this).datagrid("uncheckAll");
			}
			$(this).datagrid("options").checking = "";
			$(this).datagrid("scrollTo", 0);
		},
		rowStyler: function (index, rowData) {
			return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, "patNo");
		}
	};
	PHA.Grid("gridGenerally", dataGridOption);
}

/*****************************************************************/
function Query() {
	var valsStr = PHA_OPIVAS_COM.DomData("#qCondition", {
		doType: "query",
		needId: "Y"
	});
	KillTmpGloal();
	$("#gridGenerally").datagrid("query", {
		InputStr: valsStr,
		Pid: ""
	});

}

/**
 *  ����
 */
function Clean() {
	PHA.DomData("#qCondition", {
		doType: "clear"
	});
	KillTmpGloal();
	$("#gridGenerally").datagrid("clear");
	PHA.SetVals(GENERALLY_DEFAULT);
}

function KillTmpGloal() {
	PHA_OPIVAS_COM.Kill("gridGenerally", "PHA.OPIVAS.Generally.Query", "KillGenerally");
}

function CheckPage(rows, flag) {
	if (rows == "") {
		return;
	}
	var mDspIdArr = [];
	var mDspId = "";
	for (var i in rows) {
		mDspId = rows[i].mDspId;
		if (mDspId == "") {
			continue;
		}
		if (mDspIdArr.indexOf(mDspId) >= 0) {
			continue;
		}
		mDspIdArr.push(mDspId);
	}
	var mDspIdStr = mDspIdArr.join("^");
	if (mDspIdStr == "") {
		return;
	}
	CheckRowsGlobal(mDspIdStr, flag)
}

function CheckRowsGlobal(mDspIdStr, flag, all) {
	$.cm({
		ClassName: 'PHA.OPIVAS.Generally.Query',
		MethodName: 'CheckRows',
		MDspIdStr: mDspIdStr,
		Flag: flag,
		Pid: $("#gridGenerally").datagrid("options").queryParams.Pid || "",
		All: all || "",
		dataType: "text"
	}, false);
	if (all == "Y") {
		$("#gridGenerally").datagrid("reload");
	}
}
window.onbeforeunload = function () {
	KillTmpGloal();
}

function GetCheckPOGStr() {
	var pogIdStr = $.cm({
		ClassName: 'PHA.OPIVAS.Generally.Query',
		MethodName: 'GetCheckPOGStr',
		Pid: $("#gridGenerally").datagrid("options").queryParams.Pid || "",
		dataType: "text"
	}, false);
	return pogIdStr;
}

function PrintLabel() {
	var pogIdStr = GetCheckPOGStr();
	if (pogIdStr == "") {
		PHA.Popover({
			msg: "����ѡ���¼", // @translate
			type: 'info'
		});
		return;
	}
	PIVASPRINT.LabelsJsonByPogStr({
		pogStr: pogIdStr
	});
}
function PrintArrange() {
	var pogIdStr = GetCheckPOGStr();
	if (pogIdStr == "") {
		PHA.Popover({
			msg: "����ѡ���¼",  // @translate
			type: 'info'
		});
		return;
	}
	//  PIVASPRINT.Arrange({
	//		pogsNo:$("#conPOGSNo").triggerbox("getValue"),
	//		pogIdStr:pogIdStr
	//	},{
	//		rePrint:"��"
	//	});
	PIVASPRINT.Arrange(
		$("#conPOGSNo").triggerbox("getValue"),
		pogIdStr);
}

function detectZoom() {
	var ratio = 0,
	screen = window.screen,
	ua = navigator.userAgent.toLowerCase();
	if (window.devicePixelRatio !== undefined) {
		ratio = window.devicePixelRatio;
	} else if (~ua.indexOf('msie')) {
		if (screen.deviceXDPI && screen.logicalXDPI) {
			ratio = screen.deviceXDPI / screen.logicalXDPI;
		}
	} else if (window.outerWidth !== undefined && window.innerWidth !== undefined) {
		ratio = window.outerWidth / window.innerWidth;
	}
	if (ratio) {
		ratio = Math.round(ratio * 100);
	}
	return ratio;
}
