�1�3 /*
Creator: Liu XiaoMing
CreatDate: 2018-09-04
Description: ȫ��Ԥ�����-������Ϣ-������λ
CSPName: herp.budg.hisui.budgcalUnit.csp
ClassName: herp.budg.hisui.udata.uBudgCalUnit
herp.budg.udata.uBudgCalUnit
 */

var startIndex = undefined;

//�ж��Ƿ�����༭
function endEditing() {

	if (startIndex == undefined) {
		return true
	}
	if ($('#calUnitGrid').datagrid('validateRow', startIndex)) {
		$('#calUnitGrid').datagrid('endEdit', startIndex);
		startIndex = undefined;
		return true;
	} else {
		return false;
	}
}

var calUnitColumn = [[{
			field: 'ck',
			checkbox: true
		}, {
			field: 'rowid',
			title: 'ID',
			hidden: true
		}, {
			field: 'code',
			title: '����',
			width: 300,
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}

			}
		}, {
			field: 'name',
			title: '����',
			width: 300,
			allowBlank: false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}

	]]

//���Ӱ�ť
var AddBtn = {
	id: 'Add',
	iconCls: 'icon-add',
	text: '����',
	handler: function () {

		if (endEditing()) {
			$('#calUnitGrid').datagrid('appendRow', {
				rowid: '',
				code: '',
				name: ''
			});

			startIndex = $('#calUnitGrid').datagrid('getRows').length - 1;
			$('#calUnitGrid').datagrid('selectRow', startIndex).datagrid('beginEdit', startIndex);

		}
	}
}

//���水ť
var SaveBtn = {
	id: 'Save',
	iconCls: 'icon-save',
	text: '����',
	handler: function () {
		Save();
	}
}

//ɾ����ť
var DelBtn = {
	id: 'Del',
	iconCls: 'icon-cancel',
	text: 'ɾ��',
	handler: function () {
		Del();
	}
}

var calUnitGridObj = $HUI.datagrid('#calUnitGrid', {
		headerCls: 'panel-header-gray',
		region: 'center',
		fit: true,
		url: $URL,
		queryParams: {
			ClassName: 'herp.budg.hisui.udata.uBudgCalUnit',
			MethodName: 'List',
			hospid: hospid,
			userid: userid
		},
		columns: calUnitColumn,
		rownumbers: true, //�к�
		pagination: true, //��ҳ
		pageSize: 20,
		pageList: [10, 20, 30, 50, 100],
		toolbar: [AddBtn, SaveBtn, DelBtn],
		onClickCell: ClickCell
	});

//�����Ԫ���¼�
function ClickCell(index, field) {

	//alert(startIndex+"^"+index);
	startIndex = index;
	if (endEditing()) {
		$('#calUnitGrid').datagrid('editCell', {
			index: index,
			field: field
		});
	}
}

//����ǰУ��
function chkBefSave(rowIndex, grid, row) {
	var fields = grid.datagrid('getColumnFields')
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var tmobj = grid.datagrid('getColumnOption', field);
			if (tmobj != null) {
				var reValue = "";
				reValue = row[field];
				if (reValue == undefined) {
					reValue = "";
				}
				if ((tmobj.allowBlank == false)) {
					var title = tmobj.title;
					if ((reValue == "") || (reValue == undefined) || (parseInt(reValue) == 0)) {
						var info = "��ע��������Ϊ�ջ��㣡";
						$.messager.popover({
							msg: info,
							type: 'alert',
							timeout: 2000,
							showType: 'show',
							style: {
								"position": "absolute",
								"z-index": "9999",
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
								top: 1
							}
						});
						return false;
					}
				}
			}
		}
		return true;
}

//���淽��
function Save() {

	var grid = $('#calUnitGrid');
	var indexs = grid.datagrid('getEditingRowIndexs');
	if (indexs.length > 0) {
		for (i = 0; i < indexs.length; i++) {
			grid.datagrid("endEdit", indexs[i]);
		}
	}
	var rows = grid.datagrid("getChanges");
	var rowIndex = "",
	row = "",
	mainData = "";
	if (rows.length > 0) {
		$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function (t) {
			if (t) {
				var flag = 1;
				for (var i = 0; i < rows.length; i++) {
					row = rows[i];
					rowIndex = grid.datagrid('getRowIndex', row);
					grid.datagrid('endEdit', rowIndex);
					if (chkBefSave(rowIndex, grid, row)) {
						var tempdata = row.rowid
							 + "^" + row.code
							 + "^" + row.name;

						if (mainData == "") {
							mainData = tempdata;
						} else {
							mainData = mainData + "|" + tempdata;
						}
					} else {
						flag = 0;
						break;
					}
				}
				//alert(mainData);
				if (flag == 1) {
					DoSave(mainData);
				}
				grid.datagrid("reload");
			}
		})
	}
}

//���������̨����
var DoSave = function (mainData) {
	$.m({
		ClassName: 'herp.budg.hisui.udata.uBudgCalUnit',
		MethodName: 'Save',
		userid: userid,
		mainData: mainData
	},
		function (Data) {
		if (Data == 0) {
			$.messager.popover({
				msg: '����ɹ���',
				type: 'success',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 1
				}
			});
		} else {
			$.messager.popover({
				msg: '����ʧ�ܣ�' + Data,
				type: 'error',
				timeout: 5000,
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 1
				}
			});
		}
	});
}

function Del() {
	var rows = $('#calUnitGrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({
			msg: '��ѡ��Ҫɾ���ļ�¼��',
			type: 'alert',
			timeout: 2000,
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 1
			}
		});
		return;
	}

	$.messager.confirm('ȷ��', 'ȷ��Ҫɾ��ѡ����������', function (t) {
		if (t) {
			var mainData = "";
			for (var i = 0; i < rows.length; i++) {
				var row = rows[i];
				var rowid = row.rowid;
				if (row.rowid > 0) {
					if (mainData == "") {
						mainData = row.rowid;
					} else {
						mainData = mainData + "|" + row.rowid;
					}
				} else {
					//��������ɾ��
					editIndex = $('#calUnitGrid').datagrid('getRowIndex', row);
					$('#calUnitGrid').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
				}
			}
			$.m({
				ClassName: 'herp.budg.hisui.udata.uBudgCalUnit',
				MethodName: 'Del',
				userid: userid,
				mainData: mainData
			},
				function (Data) {
				if (Data == 0) {
					$.messager.popover({
						msg: 'ɾ���ɹ���',
						type: 'success',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 1
						}
					});
					$('#calUnitGrid').datagrid("reload");
				} else {
					$.messager.popover({
						msg: 'ɾ��ʧ�ܣ�' + Data,
						type: 'error',
						timeout: 5000,
						style: {
							"position": "absolute",
							"z-index": "9999",
							left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
							top: 1
						}
					});
				}
			});

			$('#calUnitGrid').datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
			startIndex = undefined;
			return startIndex;
		}
	})
}
