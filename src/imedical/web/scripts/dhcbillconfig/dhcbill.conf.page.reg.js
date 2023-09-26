/**
 * FileName: dhcbill.conf.page.reg.js
 * Anchor: ZhYW
 * Date: 2019-11-05
 * Description: 住院登记页面配置
 */

$(function() {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	var options = {
		onText: '是',
		offText: '否',
		size: 'small',
		onClass: 'primary',
		offClass: 'gray'
	};
	$("#showInsuFlag").switchbox(options);
	
	initDOMList();
	initPageConfList();

	var tableName = "Bill_IP_Reg";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
		width: 350,
		url: $URL + '?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=' + tableName,
		method: 'GET',
		valueField: 'HOSPRowId',
		textField: 'HOSPDesc',
		editable: false,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			$(this).combobox('select', defHospId);
		},
		onChange: function(newValue, oldValue) {
			reloadDOMList();
			reloadPageConfList();
		}
	});
});

function initDOMList() {
	//上移
	$HUI.linkbutton("#btn-moveUp", {
		onClick: function () {
			moveUpClick();
		}
	});
	
	//下移
	$HUI.linkbutton("#btn-moveDown", {
		onClick: function () {
			moveDownClick();
		}
	});
	GV.DOMList = $HUI.datagrid("#domList", {
		fit: true,
		title: 'DOM元素',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		singleSelect: true,
		fitColumns: true,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: '#dl-tb',
		loadMsg: '',
		data: [],
		columns: [[{title: 'id', field: 'id', hidden: true},
				   {title: 'DOM元素名称', field: 'text', width: 130},
				   {title: '是否必填', field: 'required', width: 80, align: 'center',
				   	formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "1" ? "checked" : "") + "/>";
					}
				   },
				   {title: '是否禁用', field: 'disabled', width: 80, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "1" ? "checked" : "") + "/>";
					}
				   },
				   {title: '首屏焦点位置', field: 'focus', width: 100, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' onclick='defFocusClick(this, " + index + ")' " + (value == "1" ? "checked" : "") + "/>";
					}
				   }
			]]
	});
}

function defFocusClick(obj, index) {
	var cellObj = {};
	$.each(GV.DOMList.getRows(), function (idx, row) {
		if (index != idx) {
			cellObj = GV.DOMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + idx + "] td[field=focus] input:checked");
			if ($(obj).prop("checked") && $(cellObj).prop("checked")) {
				cellObj.prop("checked", false);
			}
		}
	});
}

function initPageConfList() {
	var selectRowIndex = undefined;
	GV.PageConfList = $HUI.datagrid("#pageConfList", {
		fit: true,
		title: '配置记录列表',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-paper',
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		pageSize: 30,
		toolbar: '#pl-tb',
		loadMsg: '',
		data: [],
		columns: [[{title: 'site', field: 'site', hidden: true},
				   {title: '保存模式', field: 'modeDesc', width: 130},
				   {title: 'siteId', field: 'siteId', hidden: true},
				   {title: '安全组/院区', field: 'userDesc', width: 100},
				   {title: 'confIdStr', field: 'confIdStr', hidden: true}
			]],
		onLoadSuccess: function(data) {
			selectRowIndex = undefined;
			GV.PCSite = "";
			GV.PCSiteDR = "";
		},
		onSelect: function(index, row) {
			if (selectRowIndex == index) {
				GV.PageConfList.unselectRow(index);
				return;
			}
			selectRowIndex = index;
			selectConfRowHandler(index, row);
		},
		onUnselect: function(index, row) {
			selectRowIndex = undefined;
			GV.PCSite = "";
			GV.PCSiteDR = "";
			$("#showInsuFlag").switchbox("setValue", true);
			reloadDOMList();
		}
	});
}

/**
* 选中配置记录列表行事件
*/
function selectConfRowHandler(index, row) {
	GV.PCSite = row.site;
	GV.PCSiteDR = row.siteId;
	var confIdStr = row.confIdStr;
	$.m({
		ClassName: "web.DHCIPBillRegConf",
		MethodName: "GetConfValById",
		confIdStr: confIdStr,
		code: GV.ShowInsuCode
	}, function(rtn) {
		$("#showInsuFlag").switchbox("setValue", (rtn == "1"));
	});

	$.cm({
		ClassName: "web.DHCIPBillRegConf",
		MethodName: "GetConfValById",
		confIdStr: confIdStr,
		code: GV.DOMSEQCode
	}, function(jsonObj) {
		GV.DOMList.loadData({"total": jsonObj.length, "rows": jsonObj});
	});
}

function reloadDOMList() {
	var queryParams = {
		ClassName: "web.DHCIPBillRegConf",
		QueryName: "FindRegDOMList",
		rows: 99999999
	}
	loadDataGridStore("domList", queryParams);
}

function reloadPageConfList() {
	var queryParams = {
		ClassName: "web.DHCIPBillRegConf",
		QueryName: "FindPageConf",
		pageId: GV.PageId,
		hospId: getValueById("hospital")
	}
	loadDataGridStore("pageConfList", queryParams);
}

/**
 * 上移
 */
function moveUpClick() {
	var row = GV.DOMList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要移动的行",type: "info"});
		return;
	}
	var index = GV.DOMList.getRowIndex(row);
	var rows = GV.DOMList.getRows();
	if (index > 0) {
		var required = getCKEditorCellVal(index, "required");
		var disabled = getCKEditorCellVal(index, "disabled");
		var focus = getCKEditorCellVal(index, "focus");
		
		var upRequired = getCKEditorCellVal(index - 1, "required");
		var upDisabled = getCKEditorCellVal(index - 1, "disabled");
		var upFocus = getCKEditorCellVal(index - 1, "focus");
		
		var upRow = rows[index - 1];
		rows[index] = upRow;
		rows[index - 1] = row;
		GV.DOMList.refreshRow(index);
		GV.DOMList.refreshRow(index - 1);
		
		setCKEditorCellVal(index, "required", upRequired);
		setCKEditorCellVal(index, "disabled", upDisabled);
		setCKEditorCellVal(index, "focus", upFocus);
		
		setCKEditorCellVal(index - 1, "required", required);
		setCKEditorCellVal(index - 1, "disabled", disabled);
		setCKEditorCellVal(index - 1, "focus", focus);
		
		GV.DOMList.selectRow(index - 1);
	}
}

/**
 * 下移
 */
function moveDownClick() {
	var row = GV.DOMList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要移动的行", type: "info"});
		return;
	}
	var index = GV.DOMList.getRowIndex(row);
	var rows = GV.DOMList.getRows();
	if ((index + 1) < rows.length) {
		var required = getCKEditorCellVal(index, "required");
		var disabled = getCKEditorCellVal(index, "disabled");
		var focus = getCKEditorCellVal(index, "focus");
		
		var downRequired = getCKEditorCellVal(index + 1, "required");
		var downDisabled = getCKEditorCellVal(index + 1, "disabled");
		var downFocus = getCKEditorCellVal(index + 1, "focus");
		
		var downRow = rows[index + 1];
		rows[index + 1] = row;
		rows[index] = downRow;
		GV.DOMList.refreshRow(index);
		GV.DOMList.refreshRow(index + 1);
		
		setCKEditorCellVal(index, "required", downRequired);
		setCKEditorCellVal(index, "disabled", downDisabled);
		setCKEditorCellVal(index, "focus", downFocus);
		
		setCKEditorCellVal(index + 1, "required", required);
		setCKEditorCellVal(index + 1, "disabled", disabled);
		setCKEditorCellVal(index + 1, "focus", focus);
		
		GV.DOMList.selectRow(index + 1);
	}
}

/**
* 获取行编辑checkbox对象
*/
function getCKEditorCellObj(rowIndex, fieldName) {
	return GV.DOMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input:checkbox");
}

/**
* 获取行编辑checkbox值
*/
function getCKEditorCellVal(rowIndex, fieldName) {
	var obj = GV.DOMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input:checked");
	return $(obj).prop("checked");
}

/**
* 给行编辑checkbox赋值
*/
function setCKEditorCellVal(rowIndex, fieldName, value) {
	var obj = getCKEditorCellObj(rowIndex, fieldName);
	return $(obj).prop("checked", value);
}

function saveClick() {
	$("#modeDlg").show();
	var dlgObj = $HUI.dialog("#modeDlg", {
		title: (GV.PCSite) ? '修改' : '新增',
		iconCls: (GV.PCSite) ? 'icon-w-edit' : 'icon-w-add',
		draggable: false,
		resizable: false,
		cache: false,
		modal: true,
		onBeforeOpen: function() {
			$("#modeDlg").form("clear");
			//安全组/院区
			$HUI.combobox("#siteId", {
				panelHeight: 200,
				multiple: true,
				rowStyle: 'checkbox',
				method: 'GET',
				disabled: (GV.PCSiteDR != ""),
				blurValidValue: true,
				defaultFilter: 4
			});
			
			//保存模式
			$HUI.combobox("#site", {
				panelHeight: 'auto',
				valueField: 'id',
				textField: 'text',
				editable: false,
				disabled: (GV.PCSite != ""),
				data: [{id: 'HOSPITAL', text: '医院', selected: true},
					   {id: 'GROUP', text: '安全组'}
					  ],
				onLoadSuccess: function() {
					var siteId = GV.PCSite || getValueById("site");
					if (siteId) {
						$("#site").combobox("clear").combobox("select", siteId);
					}
				},
				onSelect: function(rec) {
					$("#siteId").combobox("clear").combobox("loadData", []);
					switch(rec.id) {
					case "GROUP":
						var url = $URL + "?ClassName=web.DHCIPBillRegConf&QueryName=QuerySSGroup&ResultSetType=array&hospId=" + getValueById("hospital");
						$.extend($("#siteId").combobox("options"), {valueField: 'id', textField: 'text'});
						$("#siteId").combobox("reload", url).combobox("setValue", GV.PCSiteDR);
						break;
					case "HOSPITAL":
						var tableName = "Bill_IP_Reg";
						var url = $URL + "?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=" + tableName;
						$.extend($("#siteId").combobox("options"), {valueField: 'HOSPRowId', textField: 'HOSPDesc'});
						$("#siteId").combobox("reload", url).combobox("setValue", GV.PCSiteDR);
						break;
					default:
					}
				}
			});
		},
		buttons: [{
					text: '确认',
					id: 'btn-ok',
					handler: function () {
						var bool = true;
						var id = "";
						var val = "";
						$.each($(document).find("label[class='clsRequired']"), function (index, item) {
							id = $(this).parent().next().find("input")[0].id;
							val = $("#"+id).combobox("options").multiple ? $("#"+id).combobox("getValues") : getValueById(id);
							if (!val) {
								$.messager.popover({msg: "请选择<font color=red>" + $(this).text() + "</font>", type: "info"});
								bool = false;
								return false;
							}
						});
						if (!bool) {
							return;
						}

						$.messager.confirm("确认", "确认保存?", function(r) {
							if (r) {
								save();
								dlgObj.close();
							}
						});
					}
				}, {
					text: '关闭',
					handler: function () {
						dlgObj.close();
					}
				}
			]
	});
}

/**
* 保存
*/
function save() {
	var confObj = {};
	
	confObj[GV.ShowInsuCode + "VAL"] = $("#showInsuFlag").switchbox("getValue") ? 1 : 0;
	confObj[GV.ShowInsuCode + "DESC"] = "是否显示医保信息面板";
	
	var myRows = [];
	$.each(GV.DOMList.getRows(), function(index, row) {
		myJson = {};
		myJson.id = row.id;
		myJson.text = row.text;
		myJson.required = getCKEditorCellVal(index, "required") ? true : false;
		myJson.disabled = getCKEditorCellVal(index, "disabled") ? true : false;
		myJson.focus = getCKEditorCellVal(index, "focus") ? true : false;
		myRows.push(myJson);
	});
	confObj[GV.DOMSEQCode + "VAL"] = JSON.stringify(myRows);
	confObj[GV.DOMSEQCode + "DESC"] = "DOM元素跳转顺序";

	var siteIdAry = $("#siteId").combobox("getValues");
	if (siteIdAry.length == 0) {
		siteIdAry[0] = "";
	}
	
	var confAry = [];
	$.each(siteIdAry, function(index, siteId) {
		$.each(GV.CodeStr.split("^"), function(idx, code) {
			var myObj = {};
			myObj.PCSite = getValueById("site");
			myObj.PCSiteDR = siteId;
			myObj.PCCode = code;
			myObj.PCValue = confObj[code + "VAL"];
			myObj.PCDesc = confObj[code + "DESC"];
			confAry.push(JSON.stringify(myObj));
		});
	});

	$.m({
		ClassName: "web.DHCBillPageConf",
		MethodName: "SaveConfInfo",
		pageId: GV.PageId,
		confList: confAry
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.popover({msg: "保存成功", type: "success"});
			GV.PageConfList.load();
		}else {
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
		}
	});
}

/**
* 删除
*/
function deleteClick() {
	var row = GV.PageConfList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的记录",type: "info"});
		return;
	}
	var confIdStr = row.confIdStr;
	$.messager.confirm("确认", "确认删除?", function (r) {
		if (r) {
			$.cm({
				ClassName: "web.DHCBillPageConf",
				MethodName: "Delete",
				idStr: confIdStr
			}, function(rtn) {
				if (rtn.success == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
					GV.PageConfList.load();
				}else {
					$.messager.popover({msg: "保存失败：" + rtn.msg, type: "error"});
				}
			});
		}
	});
}