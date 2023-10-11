var httpData = [{ 'id': 'http', 'text': 'http' }, { 'id': 'https', 'text': 'https' }, { 'id': 'ftp', 'text': 'ftp' }, { 'id': 'sftp', 'text': 'sftp' }];
function init() {
	initDataGrid();
	$("#FindBtn").click(function () {
		$("#grid").datagrid('reload');
	});
	$("#ClearBtn").click(function () {
		$('#TPSSCode').val('');
		$('#TPSSName').val('');
		$("#FindBtn").click();
	});
	$('#TPSSCode,#TPSSName').on('keydown', function (e) {
		if (e.keyCode == 13) {
			$("#FindBtn").click();
		}
	});
}
var DatagridDivId = "#grid";
function initDataGrid() {
	$(DatagridDivId).mgrid({
		className: "CF.BSP.SYS.BL.ThirdPartySystemServer",
		fitColumns: false,
		fit: true,
		editGrid: true,
		onBeforeLoad: function (param) {
			param.TPSSCode = $('#TPSSCode').val();
			param.TPSSName = $('#TPSSName').val();
			param.TPSSTPSParref = TPSUTPSParref;
		},
		columns: [[
			{ field: 'ID', title: 'ID', hidden: true } // ������ť��Ҫ���д��ڡ�
			, { field: 'rowId', title: 'rowId', hidden: true }
			, { field: 'TPSSCode', title: '����������', width: 100, editor: { type: 'text' } }
			, { field: 'TPSSName', title: '����������', width: 150, editor: { type: 'text' } }
			, { field: 'TPSSTPSParref', title: 'ָ������ϵͳ', hidden: true, width: 200, editor: { type: 'text' } }
			, {
				field: 'TPSSProtocol', title: 'Э������', width: 70, editor: {
					type: 'combobox',
					editable: false,
					options: {
						data: httpData,
						valueField: "id",
						textField: "text"
					}
				}
			}
			, { field: 'TPSSIP', title: '����IP', width: 150, editor: { type: 'text' } }
			, { field: 'TPSSPort', title: '����˿�', width: 70, editor: { type: 'text' } }
			, { field: 'TPSSParam', title: '�������', width: 300, editor: { type: 'text' } }
		]],
		delHandler: function (row) {
			var _t = this;
			$.messager.confirm("ɾ��", "ȷ��ɾ�� " + row.TPSSCode + " " + row.TPSSName + "��?", function (r) {
				if (r) {
					$.extend(_t.delReq, { "dto.entity.id": row.rowId });
					$cm(_t.delReq, defaultCallBack);
				}
			});
		},
		getNewRecord: function () {
			return { 'rowId': '', 'TPSSCode': '', 'TPSSName': '', 'TPSSTPSParref': TPSUTPSParref, 'TPSSProtocol': '', 'TPSSIP': '', 'TPSSPort': '', 'TPSSParam': '' };
		},
		insOrUpdHandler: function (row) {
			var param = {};
			var _t = this;
			if (!row.TPSSCode) {
				$.messager.popover({ msg: "���������� ����Ϊ��!", type: "info" });
				return;
			}
			if (!row.TPSSName) {
				$.messager.popover({ msg: "���������� ����Ϊ��!", type: "info" });
				return;
			}
			if (row.rowId == "") {
				param = _t.insReq;
			} else {
				param = $.extend(_t.updReq, { "dto.entity.id": row.rowId });
			}
			$.extend(param, {
				"dto.entity.TPSSCode": row.TPSSCode,
				"dto.entity.TPSSName": row.TPSSName,
				"dto.entity.TPSSTPSParref": row.TPSSTPSParref,
				"dto.entity.TPSSProtocol": row.TPSSProtocol,
				"dto.entity.TPSSIP": row.TPSSIP,
				"dto.entity.TPSSPort": row.TPSSPort,
				"dto.entity.TPSSParam": row.TPSSParam,
			});
			$cm(param, defaultCallBack);
		},
		a: 1
	});
}
$(init);