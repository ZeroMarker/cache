/**
 * 名称:	 门诊配液系统-配液综合查询
 * 编写人:	 yunhaibao
 * 编写日期: 2019-07-01
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
		title: isTabMenu !== true ? '配液综合查询' : '',
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
				title: '进程号',
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
				title: '提醒',
				width: 75,
				styler: PHA_OPIVAS_COM.Grid.Styler.Warn
			}, {
				field: "psName",
				title: '配液状态',
				width: 75,
				styler: PHA_OPIVAS_COM.Grid.Styler.PS
			}, {
				field: "packFlag",
				title: '打包',
				width: 45,
				align: "center",
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
				styler: PHA_OPIVAS_COM.Grid.Styler.Pack
			}, {
				field: "doseDateTime",
				title: '用药时间',
				width: 100
			}, {
				field: "patNo",
				title: '登记号',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.AdmDetail(value, row, index, "oeori")
				}
			}, {
				field: "patName",
				title: '姓名',
				width: 100
			}, {
				field: "patSex",
				title: '性别',
				width: 45,
				align: "center"
			}, {
				field: "patAge",
				title: '年龄'
			}, {
				field: "oeoriSign",
				title: '组',
				width: 30,
				formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
			}, {
				field: "inciDesc",
				title: '药品名称',
				width: 250
			}, {
				field: "dosage",
				title: '剂量'
			}, {
				field: "instrucDesc",
				title: '用法',
				width: 75
			}, {
				field: "freqDesc",
				title: '频次'
			}, {
				field: "duraDesc",
				title: '疗程',
				width: 75
			}, {
				field: "oeoriRemark",
				title: '医嘱备注',
				width: 100
			}, {
				field: "ivgttSpeed",
				title: '滴速',
				width: 80
			}, {
				field: "docLocDesc",
				title: '医生科室',
				width: 100
			}, {
				field: "docName",
				title: '医生',
				width: 100
			}, {
				field: "exceedReason",
				title: '疗程超量原因',
				width: 125
			}, {
				field: "prescNo",
				title: '处方号',
				width: 125
			}, {
				field: "oeoriStatus",
				title: '医嘱状态',
				width: 70,
				align: "center"
			}, {
				field: "oeoreStatus",
				title: '执行记录状态',
				width: 100
			}, {
				field: "oeori",
				title: '医嘱ID',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.OrderDetail(value, row, index, "oeori")
				}
			}, {
				field: "barCode",
				title: '条码',
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
					// 选择
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
 *  清屏
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
			msg: "请先选择记录", // @translate
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
			msg: "请先选择记录",  // @translate
			type: 'info'
		});
		return;
	}
	//  PIVASPRINT.Arrange({
	//		pogsNo:$("#conPOGSNo").triggerbox("getValue"),
	//		pogIdStr:pogIdStr
	//	},{
	//		rePrint:"补"
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
