// 初始化处方通用名页签内容
var PHCGENERIC_RowId = "";
var PHCGENERIC_Style = {
	ComboWidth: 537
};

function PHCGENERIC() {
	$.parser.parse('#lyPHCGeneric');
	InitDictPHCGeneric();
	InitGridPHCGeneric();
	$("#btnCleanGene").on("click", ClrPHCGeneric);
	$("#btnFindGene").on("click", QueryPHCGeneric);
	$('#conGeneAlias').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			QueryPHCGeneric();
			$('#conGeneAlias').focus().select();
		}
	});
	$("#btnSavePHCGeneric").on("click", function () {
		PHA.Confirm("提示", "您确认保存吗?", function () {
			SavePHCGeneric();
		});
	});
	$("#btnAddPHCGeneric").on("click", function () {
		PHA.Confirm("提示", "您确认清屏吗?", function () {
			AddPHCGeneric();
		});
	});
	$("#btnDelPHCGeneric").on("click", DelPHCGeneric);
	$("#btnAddPHCGenericARCItmMast").on("click", AddPHCGenericARCItmMast);
	$("#btnMaxPHCGeneric").on("click", function () {
		PHA_UX.MaxCode({
			tblName: "PHC_Generic",
			codeName: "PHCGE_Code",
			title: "查询处方通用名最大码"
		}, function (code) {
			$("#geneCode").val(code);
		});
	});
	MakeToolTip();
}

function AddPHCGeneric() {
	$("#gridPHCGeneric").datagrid("clearSelections");
	PHA.DomData("#dataPHCGeneric", {
		doType: "clear"
	});
	$("#geneCode").focus();
	PHCGENERIC_RowId = "";
}

function SavePHCGeneric() {
	var valsArr = PHA.DomData("#dataPHCGeneric", {
		doType: "save"
	});
	var valsStr = valsArr.join("^");
	if (valsStr == "") {
		return;
	}
	var saveRet = $.cm({
		ClassName: 'PHA.IN.PHCGeneric.Save',
		MethodName: 'Save',
		GeneId: PHCGENERIC_RowId,
		DataStr: valsStr,
		dataType: 'text'
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('提示', saveInfo, 'warning');
		return;
	} else {
		PHA.Popover({
			msg: '保存成功',
			type: 'success'
		});
		PHCGENERIC_RowId = saveVal;
	}
}

function DelPHCGeneric() {
	var gridSelect = $('#gridPHCGeneric').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请先选中需要删除的处方通用名",
			type: "alert"
		});
		return;
	}
	PHA.Confirm("删除提示", "您确认删除吗?", function () {
		var geneId = gridSelect.geneId;
		var saveRet = $.cm({
			ClassName: 'PHA.IN.PHCGeneric.Save',
			MethodName: 'Delete',
			GeneId: geneId,
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('提示', saveInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '删除成功',
				type: 'success'
			});
			PHCGENERIC_RowId = "";
			$("#gridPHCGeneric").datagrid("reload");
			PHA.DomData("#dataPHCGeneric", {
				doType: "clear"
			});
		}
	});
}

function ClrPHCGeneric() {
	PHA.DomData("#gridPHCGenericBar", {
		doType: "clear"
	});
}

function QueryPHCGeneric() {
	var valsArr = PHA.DomData("#gridPHCGenericBar", {
		doType: "query"
	});
	var valsStr = valsArr.join("^");
	$("#gridPHCGeneric").datagrid("query", {
		InputStr: valsStr
	});
	PHCGENERIC_RowId="";
}

function InitDictPHCGeneric() {
	PHA.ComboBox("geneForm", {
		url: PHA_STORE.PHCForm().url,
		width: PHCGENERIC_Style.ComboWidth
	});
	// 品种通用名
	var opts = $.extend({}, PHA_STORE.DHCPHChemical(), {
		width: PHCGENERIC_Style.ComboWidth
	})
	PHA.LookUp("geneChem", opts);
	var opts = $.extend({}, PHA_STORE.DHCPHChemical(), {
		width: 200
	})
	PHA.LookUp("conGeneChem", opts);
	PHA.TriggerBox("conGenePHCCat", {
		handler: function (data) {
			PHA_UX.DHCPHCCat("conGenePHCCat", {}, function (data) {
				$("#conGenePHCCat").triggerbox("setValue", data.phcCatDescAll);
				$("#conGenePHCCat").triggerbox("setValueId", data.phcCatId);
			});
		},
		width: 370
	});
	PHA.TriggerBox("genePHCCat", {
		width: PHCGENERIC_Style.ComboWidth,
		handler: function (data) {
			PHA_UX.DHCPHCCat("genePHCCat", {}, function (data) {
				$("#genePHCCat").triggerbox("setValue", data.phcCatDescAll);
				$("#genePHCCat").triggerbox("setValueId", data.phcCatId);
			});
		}
	});

}

// 表格-处方通用名
function InitGridPHCGeneric() {
	var columns = [
		[

			{
				field: "geneId",
				title: 'Id',
				width: 100,
				hidden: true
			},
			{
				field: "geneCode",
				title: '代码',
				width: 100
			},
			{
				field: "geneName",
				title: '名称',
				width: 200
			},
			{
				field: "formDesc",
				title: '剂型',
				width: 100
			},
			{
				field: "chemDesc",
				title: '品种通用名',
				width: 200
			},
			{
				field: "phcCatDescAll",
				title: '药学分类',
				width: 300
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.PHCGeneric.Query',
			QueryName: 'PHCGeneric'
		},
		pagination: true,
		columns: columns,
		fitColumns: false,
		toolbar: "#gridPHCGenericBar",
		enableDnd: false,
		onSelect: function (rowIndex, rowData) {
			$.cm({
				ClassName: 'PHA.IN.PHCGeneric.Query',
				MethodName: 'SelectPHCGeneric',
				GeneId: rowData.geneId,
				ResultSetType: 'Array'
			}, function (arrData) {
				if (arrData.msg) {
					PHA.Alert("错误提示", arrData.msg, "error");
				} else {
					PHA.DomData("#dataPHCGeneric", {
						doType: "clear"
					});
					PHA.SetVals(arrData);
					PHCGENERIC_RowId = rowData.geneId;
				}
			})
		},
		onDblClickRow: function (rowIndex, rowData) {
			SwitchToARCItmMast(rowData.geneId, "");
		},
		onLoadSuccess: function (data) {
			PHA.DomData("#dataPHCGeneric", {
				doType: "clear"
			});
			var pageSize = $("#gridPHCGeneric").datagrid('getPager').data("pagination").options.pageSize;
			var total = data.total;
			if ((total > 0) && (total <= pageSize)) {
				$("#gridPHCGeneric").datagrid("selectRow", 0)
			}
		}

	};

	PHA.Grid("gridPHCGeneric", dataGridOption);
}

function AddPHCGenericARCItmMast() {
	if (PHCGENERIC_RowId == "") {
		PHA.Popover({
			msg: '请先选择处方通用名,如果正在新增请先保存',
			type: 'alert'
		});
		return;
	}
	SwitchToARCItmMast(PHCGENERIC_RowId, "AddArcim")
}

function SwitchToARCItmMast(geneId, type) {
	// 判断医嘱项是否初始化过,解决首次新增医嘱项被选中的问题
	var arcimLoaded=$("#lyArcItmMast").text().trim();
	$('#tabsDrug').tabs("select", "医嘱项");
	$.cm({
		ClassName: 'PHA.IN.Drug.Switch',
		MethodName: 'PHCGenericToARCItmMast',
		GeneId: geneId,
		Type: type,
		ResultSetType: 'Array'
	}, function (arrData) {
		if (arrData.msg) {
			PHA.Alert("错误提示", arrData.msg, "error");
		} else {
			if (arcimLoaded!=""){
				SwitchLoad();
			}else{
				setTimeout(SwitchLoad,500)
			}
			function SwitchLoad(){
				ClrARCItmMast();
				PHA.SetVals(arrData);
				DRUG_SwitchType=type;
				QueryARCItmMast();
				PHA.SetVals(arrData);
			}
		}
	})
}