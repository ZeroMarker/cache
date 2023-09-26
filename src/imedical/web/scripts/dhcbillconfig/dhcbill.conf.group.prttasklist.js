/**
 * FileName: dhcbill.conf.group.prttasklist.js
 * Anchor: ZhYW
 * Date: 2019-10-23
 * Description: 单据打印列表
 */

var GV = {
	GroupId: getParam("GroupId"),
	HospId: getParam("HospId"),
	EditRowIndex: undefined
};

$(function () {
	$HUI.linkbutton("#btn-add", {
		onClick: function () {
			addClick();
		}
	});

	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});

	$HUI.linkbutton("#btn-update", {
		onClick: function () {
			updateClick();
		}
	});

	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	$HUI.linkbutton("#btn-reject", {
		onClick: function () {
			rejectClick();
		}
	});
	
	GV.TaskList = $HUI.datagrid("#taskList", {
			fit: true,
			bodyCls: 'panel-header-gray',
			singleSelect: true,
			rownumbers: false,
			pagination: true,
			pageSize: 20,
			pageList: [20, 30, 40, 50],
			loadMsg: '',
			toolbar: '#tl-tb',
			columns: [[{title: 'GSPTRowID', field: 'GSPTRowID', hidden: true},
					   {title: '模板名称', field: 'PrtXmlName', width: 250,
						editor: {
							type: 'combobox',
							options: {
								method: 'get',
								url: $URL + '?ClassName=web.DHCXMLPConfig&QueryName=XMLPConfigQuery&ResultSetType=array',
								mode: 'remote',
								valueField: '模板名称',
								textField: '模板名称',
								onBeforeLoad: function (param) {
									param.Name = param.q;
								},
								onLoadSuccess: function() {
									$(this).next("span").find("input").focus();
								},
								onChange: function(newValue, oldValue) {
									setValueById("XmlTemplateName", newValue || "");
								}
							}
						}
					   },
					   {title: '类名称', field: 'ClassName', width: 250,
					    editor: {
							type: 'combobox',
							options: {
								method: 'get',
								delay: 500,
								url: $URL + '?ClassName=websys.Conversions&QueryName=LookUpClassName&ResultSetType=array',
								mode: 'remote',
								valueField: 'ClassName',
								textField: 'ClassName',
								selectOnNavigation: false,
								onBeforeLoad: function (param) {
									param.classname = param.q;
								},
								onSelect: function(rec) {
									var url = $URL + "?ClassName=websys.Conversions&QueryName=LookUpMethodName&ResultSetType=array&classname=" + rec.ClassName;
									var ed = GV.TaskList.getEditor({index: GV.EditRowIndex, field: "MethodName"});
									if (ed) {
										$(ed.target).combobox("reload", url);
									}
								},
								onChange: function(newValue, oldValue) {
									if (!newValue) {
										var ed = GV.TaskList.getEditor({index: GV.EditRowIndex, field: "MethodName"});
										if (ed) {
											$(ed.target).combobox("clear");
										}
									}
									setValueById("ClassName", newValue || "");
								}
							}
						}
					   },
					   {title: '方法名称', field: 'MethodName', width: 250,
					   	editor: {
							type: 'combobox',
							options: {
								method: 'get',
								valueField: 'ClassName',
								textField: 'ClassName',
								defaultFilter: 4,
								onChange: function(newValue, oldValue) {
									setValueById("MethodName", newValue || "");
								}
							}
						}
					   },
					   {title: '打印模式', field: 'PrintMode', width: 120,
					    editor: {
							type: 'combobox',
							options: {
								panelHeight: 'auto',
								method: 'get',
								url: $URL + "?ClassName=BILL.CFG.COM.GroupAuth&QueryName=InitListObjectValue&ResultSetType=array&ClsName=User.DHCOPGSPrintTask&PropName=PTPrintMode",
								valueField: 'ValueList',
								textField: 'DisplayValue',
								onChange: function(newValue, oldValue) {
									setValueById("PrintMode", newValue || "");
								}
							}
						}
					   },
					   {title: 'HardEquipDR', field: 'HardEquipDR', hidden: true},
					   {title: '设备类型', field: 'CCMDesc', width: 120,
					    editor: {
							type: 'combobox',
							options: {
								panelHeight: 150,
								method: 'get',
								url: $URL + "?ClassName=User.DHCCardHardComManager&QueryName=SelectByHardGroupType&ResultSetType=array&GrpType=BC",
								mode: 'remote',
								valueField: 'CCM_RowID',
								textField: 'CCM_Desc',
								onBeforeLoad: function (param) {
									param = $.extend(param, {HardName: param.q});
									return true;
								},
								onChange: function(newValue, oldValue) {
									setValueById("HardEquipDR", newValue || "");
								}
							}
						}
					   },
					   {title: 'PT_HardEquip_DR', field: 'PT_HardEquip_DR', hidden: true},
				]],
			url: $URL,
			queryParams: {
				ClassName: "BILL.CFG.COM.GroupAuth",
				QueryName: "ReadGSPrtList",
				groupId: GV.GroupId,
				hospId: GV.HospId,
				taskType: getValueById("TaskType")
			},
			onLoadSuccess: function(data) {
				GV.EditRowIndex = undefined;
			},
			onDblClickRow: function(index, row) {
				if (GV.EditRowIndex != undefined) {
					$.messager.popover({msg: "有正在编辑的行", type: "info"});
					return;
				}
				beginEditRow(index, row);
			}
		});
});

/**
* 新增
*/
function addClick() {
	if (GV.EditRowIndex != undefined) {
		$.messager.popover({msg: "有正在编辑的行", type: "info"});
		return;
	}
	var row = {};
	$.each(GV.TaskList.getColumnFields(), function (index, item) {
		row[item] = "";
	});
	GV.TaskList.appendRow(row);
	GV.EditRowIndex = GV.TaskList.getRows().length - 1;
	GV.TaskList.beginEdit(GV.EditRowIndex);
	GV.TaskList.selectRow(GV.EditRowIndex);
}

/**
* 删除
*/
function deleteClick() {
	var row = GV.TaskList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的行", type: "info"});
		return;
	}
	var rowId = row.GSPTRowID;
	$.messager.confirm("确认", "确认删除？", function(r) {
		if (r) {
			$.m({
				ClassName: "BILL.CFG.COM.GroupAuth",
				MethodName: "DelGSPT",
				rowId: rowId
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.popover({msg: "删除成功", type: "success"});
					GV.TaskList.reload();
				}else {
					$.messager.popover({msg: "删除失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

/**
* 修改
*/
function updateClick() {
	if (GV.EditRowIndex != undefined) {
		$.messager.popover({msg: "有正在编辑的行", type: "info"});
		return;
	}
	var row = GV.TaskList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要编辑的行", type: "info"});
		return;
	}
	
	GV.EditRowIndex = GV.TaskList.getRowIndex(row);
	beginEditRow(GV.EditRowIndex, row);
}

function beginEditRow(index, row) {
	setValueById("GSPTRowID", row.GSPTRowID);
	GV.EditRowIndex = index;
	GV.TaskList.beginEdit(index);
}

/**
* 保存
*/
function saveClick() {
	GV.TaskList.acceptChanges();
	var encmeth = getValueById("InitGSPrintTaskEncrypt");
	var xmlData = getEntityClassInfoToXML(encmeth);
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (r) {
			$.m({
				ClassName: "BILL.CFG.COM.GroupAuth",
				MethodName: "UpdateGSPT",
				groupId: GV.GroupId,
				hospId: GV.HospId,
				xmlData: xmlData
			}, function(rtn) {
				if (rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
					GV.TaskList.reload();
				}else {
					$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
				}
			});
		}
	});
}

/**
* 取消编辑
*/
function rejectClick() {
	GV.TaskList.rejectChanges();
	GV.EditRowIndex = undefined;
}