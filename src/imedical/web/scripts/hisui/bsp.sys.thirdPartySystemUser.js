var UserData = [];
$("#TPSUUserDr").combobox({
	valueField: 'id',
	textField: 'text',
	multiple: false,
	rowStyle: '', //显示成勾选行形式
	panelHeight: "auto",
	editable: true,
	defaultFilter: 6,
	data: UserData
});
$q({
	ClassName: "web.SSUser",
	QueryName: "ListAll",
	rows: 20000
}, function (Data) {
	var rowData = Data.rows;
	for (var i = 0; i < rowData.length; i++) {
		var json = {};
		json.id = rowData[i].SSUSRRowId; // HIDDEN
		json.text = rowData[i].SSUSRInitials + "-" + rowData[i].SSUSRName;
		UserData.push(json)
	}
	$("#TPSUUserDr").combobox("loadData", UserData);
	initDataGrid();
});
function init() {	
	$("#FindBtn").click(function () {
		$("#grid").datagrid('reload');
	});
	$("#ClearBtn").click(function () {
		$("#TPSUUserDr").combobox("setValue", "");
		$("#TPSUUserDr").combobox("setText", "");
		$('#TPSUUserCode').val('');
		$("#FindBtn").click();
	});
	$('#TPSUUserDr,#TPSUUserCode').on('keydown', function (e) {
		if (e.keyCode == 13) {
			$("#FindBtn").click();
		}
	});
}
var DatagridDivId = "#grid";
function initDataGrid() {
	$(DatagridDivId).mgrid({
		className: "CF.BSP.SYS.BL.ThirdPartySystemUser",
		fitColumns: false,
		fit: true,
		editGrid: true,
		onBeforeLoad: function (param) {
			param.TPSUUserDr = $("#TPSUUserDr").combobox("getValue");
			param.TPSUUserCode = $('#TPSUUserCode').val();
			param.TPSUTPSParref = TPSUTPSParref;
		},
		columns: [[
			{ field: 'ID', title: 'ID', hidden: true } // 撤销按钮需要此列存在。
			, { field: 'rowId', title: 'rowId', hidden: true }
			, { field: 'TPSUTPSParref', title: 'TPSUTPSParref', hidden: true }
			, {
				field: 'TPSUUserDr', title: 'HIS用户', width: 200,
				editor: {
					type: 'combobox',
					readonly: false,
					options: {
						data: UserData,
						valueField: "id",
						textField: "text"
					}
				}
				, formatter: function (value, rowData, rowIndex) {
					for (var i = 0; i < UserData.length; i++) {
						if (UserData[i].id == value) {
							return UserData[i].text;
						}
					}
					return value;
				}
			}
			, { field: 'TPSUUserCode', title: '三方用户', width: 200, editor: { type: 'text' } }
			, { field: 'TPSUUserName', title: '三方用户姓名', width: 200, editor: { type: 'text' } }
		]],
		delHandler: function (row) {
			var _t = this;
			$.messager.confirm("删除", "确定删除吗?", function (r) {
				if (r) {
					$.extend(_t.delReq, { "dto.entity.id": row.rowId });
					$cm(_t.delReq, defaultCallBack);
				}
			});
		},
		getNewRecord: function () {
			return { "ID": "", "rowId": "", "TPSUTPSParref": TPSUTPSParref, "TPSUUserDr": "", "TPSUUserCode": "", "TPSUUserName": "" };
		},
		insOrUpdHandler: function (row) {
			var param = {};
			var _t = this;
			if (!row.TPSUUserDr) {
				$.messager.popover({ msg: "HIS用户不能为空!", type: "info" });
				return;
			}
			if (!row.TPSUUserCode && !row.TPSUUserName) {
				$.messager.popover({ msg: "三方名称不能都为空!", type: "info" });
				return;
			}
			if (row.rowId == "") {
				param = _t.insReq;
			} else {
				param = $.extend(_t.updReq, { "dto.entity.id": row.rowId });
			}
			$.extend(param, {
				"dto.entity.TPSUTPSParref": row.TPSUTPSParref,
				"dto.entity.TPSUUserDr": row.TPSUUserDr,
				"dto.entity.TPSUUserCode": row.TPSUUserCode,
				"dto.entity.TPSUUserName": row.TPSUUserName
			});
			$cm(param, defaultCallBack);
		},
		a: 1
	});
}
$(init);