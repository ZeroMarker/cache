/**
 * FileName: dhcbill.conf.ip.monitor.main.js
 * Anchor: ZhYW
 * Date: 2020-01-07
 * Description: 住院费用监控配置主界面
 */

var GV = {};

$(function() {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	
	var tableName = "Bill_IP_MonitorPoint";
	var defHospId = $.m({
		ClassName: "web.DHCBL.BDP.BDPMappingHOSP",
		MethodName: "GetDefHospIdByTableName",
		tableName: tableName,
		HospID: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
	$("#hospital").combobox({
		panelHeight: 150,
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
			var queryParams = {
				ClassName: "web.DHCIPBillCostMonitorConfig",
				QueryName: "FindMonitorPoint",
				hospId: newValue,
				keyCode: $("#search").searchbox("getValue")
			}
			loadDataGridStore("montList", queryParams);
		}
	});

	$("#search").searchbox({
		searcher: function(value) {
			var queryParams = {
				ClassName: "web.DHCIPBillCostMonitorConfig",
				QueryName: "FindMonitorPoint",
				hospId: getValueById("hospital"),
				keyCode: value
			}
			loadDataGridStore("montList", queryParams);
		}
	});
	
	var toolbar = [{
				text: '新增',
				iconCls: 'icon-add',
				handler: function() {
					addClick();
				}
			}, {
				text: '修改',
				iconCls: 'icon-write-order',
				handler: function() {
					updateClick();
				}
			}, {
				text: '删除',
				iconCls: 'icon-cancel',
				handler: function() {
					deleteClick();
				}
			}
		];
	GV.MontList = $HUI.datagrid("#montList", {
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		pageSize: 20,
		displayMsg: '',
		data: [],
		toolbar: toolbar,
		idField: 'id',
		columns: [[{title: 'id', field: 'id', hidden: true},
				   {title: 'code', field: 'code', hidden: true},
				   {title: '描述', field: 'desc', width: 300},
				   {title: '是否启用', field: 'active', width: 70,
					formatter: function (value, row, index) {
						return (value == "Y") ? "<font color='#21ba45'>是</font>" : "<font color='#f16e57'>否</font>";
					}
				   }
			]],
		onLoadSuccess: function(data) {
			$("#montList").datagrid("unselectAll");
			$(".layout:first").layout("panel", "center").panel("setTitle", "配置");
			$("iframe").attr("src", "dhcbill.nodata.warning.csp");
		},
		onSelect: function(index, row) {
			$(".layout:first").layout("panel", "center").panel("setTitle", row.desc + "配置");
			loadConfPage(row.id, row.code);
		}
	});
});

function addClick() {
	save("");
}

function updateClick() {
	var row = GV.MontList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要修改的行", type: "info"});
		return;
	}
	save(row);
}

function save(row) {
	$("#edit-Dlg").form("clear").show();
	
	//类型
	$HUI.combobox("#edit-type", {
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data: [{id: 'I', text: '固有'},
		       {id: 'C', text: '自定义'}
		]
	});
	
	var id = "";
	var dlgIconCls = "icon-w-add";
	var dlgTitle = "新增";
	if (row) {
		dlgIconCls = "icon-w-edit";
		dlgTitle = "修改";
		id = row.id;
		$.cm({
			ClassName: "web.DHCBillCommon",
			MethodName: "GetClsPropValById",
			clsName: "User.DHCBillMonitorPointConfig",
			id: id
		}, function (jsonObj) {
			setValueById("edit-code", jsonObj.MPCCode);
			setValueById("edit-desc", jsonObj.MPCDesc);
			setValueById("edit-type", jsonObj.MPCType);
			setValueById("edit-explain", serverToHtml(jsonObj.MPCExplain));
			setValueById("edit-active", (jsonObj.MPCActiveFlag == "Y"));
			$(".validatebox-text").validatebox("validate");
		});
	}
	
	var editDlgObj = $HUI.dialog("#edit-Dlg", {
		iconCls: dlgIconCls,
		title: dlgTitle,
		draggable: false,
		modal: true,
		buttons: [{
				text: "保存",
				handler: function () {
					var bool = true;
					$.each($(document).find("label[class='clsRequired']"), function (index, item) {
						var val = getValueById($(this).parent().next().find("input")[0].id);
						if (!val) {
							$.messager.popover({msg: "<font color=red>" + $(this).text() + "</font>" + "不能为空", type: "info"});
							bool = false;
							return false;
						}
					});
					if (!bool) {
						return;
					}
					
					var jsonObj = {
						Id: id,
						Code: getValueById("edit-code"),
						Desc: getValueById("edit-desc"),
						Explain: htmlToServer(getValueById("edit-explain")),
						Active: getValueById("edit-active") ? "Y" : "N",
						Type: getValueById("edit-type"),
						HospId: getValueById("hospital")
					};

					$.messager.confirm("确认", "确认保存？", function(r) {
						if (r) {
							$.cm({
								ClassName: "web.DHCIPBillCostMonitorConfig",
								MethodName: "SaveMonitor",
								jsonStr: JSON.stringify(jsonObj)
							}, function (rtn) {
								if (rtn.success == "0") {
									$.messager.popover({msg: rtn.msg, type: "success"});
									editDlgObj.close();
									GV.MontList.reload();
								} else {
									$.messager.popover({msg: rtn.msg, type: "error"});
								}
							});
						}
					});
				}
			}, {
				text: '关闭',
				handler: function () {
					editDlgObj.close();
				}
			}
		]
	});
}

/**
* 删除
*/
function deleteClick() {
	var row = GV.MontList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的行", type: "info"});
		return;
	}
	var id = row.id;
	$.messager.confirm("确认", "确认删除？", function(r) {
		if (r) {
			$.cm({
				ClassName: "web.DHCIPBillCostMonitorConfig",
				MethodName: "DeleteMonitor",
				id: id
			}, function (rtn) {
				var type = (rtn.success == "0") ? "success" : "error";
				$.messager.popover({msg: rtn.msg, type: type});
				GV.MontList.reload();
			});
		}
	});
}

function loadConfPage(id, code) {
	var url = "dhcbill.nodata.warning.csp";
	if (new Array('01', '02', '03').indexOf(code) != -1) {
		url = "dhcbill.conf.ip.monitor.fir.csp";
	}else if (new Array('04').indexOf(code) != -1) {
		url = "dhcbill.conf.ip.monitor.sec.csp";
	}else if (new Array('12').indexOf(code) != -1) {
		url = "dhcbill.conf.ip.monitor.fou.csp";
	}else {
		url = "dhcbill.conf.ip.monitor.thir.csp";
	}
	var hospId = getValueById("hospital");
	var src = url + "?MoniId=" + id + "&HospId=" + hospId;
	if ($("iframe").attr("src") != src) {
		$("iframe").attr("src", src);
	}
}

function serverToHtml(str){
	return str.toString().replace(/<br\/>/g, "\r\n").replace(/&nbsp;/g, " ");
}

function htmlToServer(str) {
	return str.toString().replace(/(\r)*\n/g, "<br/>").replace(/\s/g, "&nbsp;");
}