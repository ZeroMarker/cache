/**
 * FileName: dhcbill.conf.tabsmaintain.js
 * Anchor: ZhYW
 * Date: 2018-03-28
 * Description: 计费页签维护
 */

$(function () {
	initQueryMenu();
	initListGrid();
});

var initQueryMenu = function () {
	$HUI.combobox('#menu-type', {
		panelHeight: 'auto',
		multiple: false,
		data: [{
				value: '',
				text: '全部'
			}, {
				value: 'OPD',
				text: '门诊日结'
			}, {
				value: 'OPC',
				text: '门诊日结汇总'
			}, {
				value: 'IPD',
				text: '住院日结'
			}, {
				value: 'IPC',
				text: '住院日结汇总'
			}, {
				value: 'BOA',
				text: '第三方对账平台'
			}
		],
		editable: false,
		valueField: 'value',
		textField: 'text',
		onSelect: function (record) {
			$('#tabsList').datagrid('load', {
				ClassName: "web.DHCBillTabs",
				QueryName: "FindBillTabs",
				type: record.value
			});
		}
	});
}

var initListGrid = function () {
	var tabsListObj = $HUI.datagrid("#tabsList", {
			fit: true,
			border: false,
			singleSelect: true,
			fitColumns: true,
			url: $URL,
			pagination: true,
			rownumbers: true,
			pageSize: 20,
			toolbar: [{
					iconCls: 'icon-add',
					text: '新增',
					handler: function () {
						saveHandler("");
					}
				}, {
					iconCls: 'icon-write-order',
					text: '修改',
					disabled: true,
					id: 'editTab',
					handler: function () {
						var row = tabsListObj.getSelected();
						if (row) {
							saveHandler(row);
						}
					}
				}
			],
			columns: [[{title: 'rowId', field: 'rowId', hidden: true},
					   {title: 'id', field: 'id', width: 150},
					   {title: 'title', field: 'title', width: 150},
					   {title: 'href', field: 'href', width: 350},
					   {title: '启用', field: 'active', width: 50,
						formatter: function (value, row, index) {
							return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
						}
					   },
					   {title: '业务类型', field: 'typeDesc', width: 150},
					   {title: 'type', field: 'type', hidden: true}
				]],
			queryParams: {
				ClassName: "web.DHCBillTabs",
				QueryName: "FindBillTabs",
				type: ""
			},
			onLoadSuccess: function (data) {
				tabsListObj.autoMergeCells(['typeDesc']);
			},
			onSelect: function (rowIndex, rowData) {
				tabsListObj.getPanel().find("#editTab").linkbutton("enable");
			},
			onDblClickRow: function (rowIndex, rowData) {
				saveHandler(rowData);
			}
		});
}

var saveHandler = function (row) {
	$('#tabDlg').show();
	var rowId = '';
	var id = '';
	var title = '';
	var href = '';
	var active = '';
	var type = '';
	var dlgIconCls = 'icon-w-add';
	var dlgTitle = '新增';
	if (row) {
		rowId = row.rowId;
		id = row.id;
		title = row.title;
		href = row.href;
		active = row.active;
		type = row.type;
		dlgIconCls = 'icon-w-edit';
		dlgTitle = '修改';
	}
	$('#edit-id').val(id).validatebox('validate');
	$('#edit-title').val(title).validatebox('validate');
	$('#edit-href').val(href);
	$('#edit-active').val(active);
	$('#edit-type').val(type);

	$HUI.combobox('#edit-active', {
		panelHeight: 'auto',
		data: [{
				value: 'Y',
				text: '启用'
			}, {
				value: 'N',
				text: '不启用'
			}
		],
		editable: false,
		valueField: 'value',
		textField: 'text',
		required: true,
		onLoadSuccess: function () {
			$(this).combobox('setValue', active);
		}
	});
	$HUI.combobox('#edit-type', {
		panelHeight: 'auto',
		data: [{
				value: 'OPD',
				text: '门诊日结'
			}, {
				value: 'OPC',
				text: '门诊日结汇总'
			}, {
				value: 'IPD',
				text: '住院日结'
			}, {
				value: 'IPC',
				text: '住院日结汇总'
			}, {
				value: 'BOA',
				text: '第三方对账平台'
			}
		],
		editable: false,
		valueField: 'value',
		textField: 'text',
		required: true,
		onLoadSuccess: function () {
			$(this).combobox('setValue', type);
		}
	});

	var tabDlgObj = $HUI.dialog('#tabDlg', {
			iconCls: dlgIconCls,
			title: dlgTitle,
			draggable: false,
			resizable: true,
			modal: true,
			buttons: [{
					text: '保存',
					handler: function () {
						var tabInfo = $('#edit-id').val() + String.fromCharCode(3) + $('#edit-title').val() + String.fromCharCode(3);
						tabInfo += $('#edit-href').val() + String.fromCharCode(3) + $('#edit-active').combobox('getValue');
						tabInfo += String.fromCharCode(3) + $('#edit-type').combobox('getValue');
						$.cm({
							ClassName: "web.DHCBillTabs",
							MethodName: "SaveTabs",
							rowId: rowId,
							tabInfo: tabInfo
						}, function (jsonData) {
							if (jsonData.success == 0) {
								tabDlgObj.close();
								$('#tabsList').datagrid('load');
							} else {
								$.messager.alert('提示', jsonData.msg, 'info');
							}
						});
					}
				}, {
					text: '关闭',
					handler: function () {
						tabDlgObj.close();
					}
				}
			]
		});
}