/**
 * FileName: dhcbill.conf.tabsmaintain.js
 * Author: ZhYW
 * Date: 2018-03-28
 * Description: �Ʒ�ҳǩά��
 */

$(function () {
	initQueryMenu();
	initListGrid();
});

var initQueryMenu = function () {
	$HUI.combobox("#menu-type", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillTabs&QueryName=QryBizTypes&ResultSetType=array',
		valueField: 'value',
		textField: 'text',
		selectOnNavigation: false,
		onChange: function (newValue, oldValue) {
			$("#tabsList").datagrid("load", {
				ClassName: "web.DHCBillTabs",
				QueryName: "QryBillTabs",
				type: newValue || ""
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
					text: '����',
					handler: function () {
						saveHandler("");
					}
				}, {
					iconCls: 'icon-write-order',
					text: '�޸�',
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
					   {title: '�Ƿ�����', field: 'active', width: 50,
						formatter: function (value, row, index) {
							var color = (value == "Y") ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == "Y") ? $g("��") : $g("��")) + "</font>";
						}
					   },
					   {title: 'ҵ������', field: 'typeDesc', width: 150},
					   {title: 'type', field: 'type', hidden: true}
				]],
			queryParams: {
				ClassName: "web.DHCBillTabs",
				QueryName: "QryBillTabs",
				type: ""
			},
			onLoadSuccess: function (data) {
				tabsListObj.autoMergeCells(["typeDesc"]);
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
	var rowId = "";
	var id = "";
	var title = "";
	var href = "";
	var active = "";
	var type = "";
	var dlgIconCls = "icon-w-add";
	var dlgTitle = "����";
	if (row) {
		rowId = row.rowId;
		id = row.id;
		title = row.title;
		href = row.href;
		active = row.active;
		type = row.type;
		dlgIconCls = "icon-w-edit";
		dlgTitle = "�޸�";
	}
	$("#tabDlg").show();
	var tabDlgObj = $HUI.dialog("#tabDlg", {
			iconCls: dlgIconCls,
			title: dlgTitle,
			draggable: false,
			resizable: true,
			modal: true,
			buttons: [{
					text: '����',
					handler: function () {
						var bool = true;
						$(".validatebox-text").each(function(index, item) {
							if (!$(this).validatebox("isValid")) {
								$.messager.popover({msg: "<font color=red>" + $(this).parent().prev().text() + "</font>" + "��֤��ͨ��", type: "info"});
								bool = false;
								return false;
							}
						});
						if (!bool) {
							return;
						}
						$.messager.confirm("ȷ��", "ȷ�ϱ��棿", function(r) {
							if (!r) {
								return;
							}
							var CH3 = PUBLIC_CONSTANT.SEPARATOR.CH3;
							var tabInfo = getValueById("edit-id") + CH3 + getValueById("edit-title");
							tabInfo += CH3 + getValueById("edit-href") + CH3 + getValueById("edit-active");
							tabInfo += CH3 + getValueById("edit-type");
							$.m({
								ClassName: "web.DHCBillTabs",
								MethodName: "SaveTabs",
								rowId: rowId,
								tabInfo: tabInfo
							}, function (rtn) {
								var myAry = rtn.split("^");
								if (myAry[0] == 0) {
									$.messager.popover({msg: "����ɹ�", type: "success"});
									tabDlgObj.close();
									$("#tabsList").datagrid("load");
									return;
								}
								$.messager.popover({msg: "����ʧ�ܣ�" + (myAry[1] || myAry[0]), type: "error"});
							});
						});
					}
				}, {
					text: '�ر�',
					handler: function () {
						tabDlgObj.close();
					}
				}
			],
			onBeforeOpen: function() {
				setValueById("edit-id", id);
				setValueById("edit-title", title);
				setValueById("edit-href", href);
				setValueById("edit-active", active);
				setValueById("edit-type", type);
				$("#tabDlg .validatebox-text").each(function(index, ele) {
					$(this).validatebox("validate");
				});
				$HUI.combobox("#edit-active", {
					panelHeight: 'auto',
					editable: false,
					valueField: 'value',
					textField: 'text',
					required: true,
					data: [{value: 'Y', text: '����'},
					       {value: 'N', text: '������'}
						  ],
					onLoadSuccess: function () {
						$(this).combobox('setValue', active);
					}
				});
				$HUI.combobox("#edit-type", {
					panelHeight: 'auto',
					editable: false,
					url: $URL + '?ClassName=web.DHCBillTabs&QueryName=QryBizTypes&ResultSetType=array',
					valueField: 'value',
					textField: 'text',
					required: true,
					onLoadSuccess: function () {
						$(this).combobox("setValue", type);
					}
				});
			}
		});
}
