/**
 * FileName: dhcbill.conf.page.set.main.js
 * Anchor: ZhYW
 * Date: 2019-11-01
 * Description: 页面配置
 */
 
var GV = {};

$(function() {
	$("#page-search").searchbox({
		searcher: function(value) {
			GV.PageList.load({
				ClassName: "web.DHCBillWebPage",
				QueryName: "FindWebPage",
				keyCode: value
			});
		}
	});
	
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
	
	GV.PageList = $HUI.datagrid("#pageList",{
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		pageSize: 30,
		displayMsg: '',
		toolbar: '#pl-tb',
		idField: 'rowId',
		columns: [[{title: 'rowId', field: 'rowId', hidden: true},
				   {title: '页面代码', field: 'cspName', hidden: true},
				   {title: '页面描述', field: 'pageName', width: 230},
				   {filed: 'confURL', field: 'confURL', hidden: true}
		]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCBillWebPage",
			QueryName: "FindWebPage",
			keyCode: ""
		},
		onLoadSuccess: function(data) {
			GV.PageList.unselectAll();
			GV.PageList.getPanel().find(".l-btn:not('#btn-add')").linkbutton("disable");
			$(".layout:first").layout("panel", "center").panel("setTitle", "页面配置");
			$("iframe").attr("src", "dhcbill.nodata.warning.csp");
		},
		onSelect: function(index, row) {
			GV.PageList.getPanel().find(".l-btn:not('#btn-add')").linkbutton("enable");
			$(".layout:first").layout("panel", "center").panel("setTitle", row.pageName + "页面配置");
			loadConfPage(row.rowId, row.confURL);
		}
	});
});

function loadConfPage(pageId, url) {
	var src = url + "?PageId=" + pageId;
	if ($("iframe").attr("src") != src) {
		$("iframe").attr("src", src);
	}
}

function addClick() {
	save("");
}

function updateClick() {
	var row = GV.PageList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要修改的行", type: "info"});
		return;
	}
	save(row);
}

function save(row) {
	$("#edit-Dlg").show();
	var id = "";
	var cspName = "";
	var pageName = "";
	var confURL = "";
	var dlgIconCls = "icon-w-add";
	var dlgTitle = "新增";
	if (row) {
		id = row.rowId;
		cspName = row.cspName;
		pageName = row.pageName;
		confURL = row.confURL;
		dlgIconCls = "icon-w-edit";
		dlgTitle = "修改";
	}

	setValueById("edit-cspName", cspName);
	setValueById("edit-pageName", pageName);
	setValueById("edit-confURL", confURL);
	$(".validatebox-text").validatebox("validate");
	
	var editDlgObj = $HUI.dialog("#edit-Dlg", {
		iconCls: dlgIconCls,
		title: dlgTitle,
		draggable: false,
		modal: true,
		buttons: [{
				text: "保存",
				handler: function () {
					var bool = true;
					$(".validatebox-text").each(function(index, item) {
						if (!$(this).validatebox("isValid")) {
							$.messager.popover({msg: "请输入<font color=red>" + $(this).parent().prev().text() + "</font>", type: "info"});
							bool = false;
							return false;
						}
					});
					if (!bool) {
						return;
					}
					
					var pageInfo = getValueById("edit-cspName") + "^" + getValueById("edit-pageName") + "^" + getValueById("edit-confURL");
					$.messager.confirm("确认", "确认保存？", function(r) {
						if (r) {
							$.m({
								ClassName: "web.DHCBillWebPage",
								MethodName: "Save",
								id: id,
								pageInfo: pageInfo
							}, function (rtn) {
								var myAry = rtn.split("^");
								if (myAry[0] == "0") {
									$.messager.popover({msg: "保存成功", type: "success"});
									editDlgObj.close();
									GV.PageList.reload();
								} else {
									$.messager.popover({msg: "保存失败：" + myAry[0], type: "error"});
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
	var row = GV.PageList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要删除的行", type: "info"});
		return;
	}
	var id = row.rowId;
	$.messager.confirm("确认", "确认删除？", function(r) {
		if (r) {
			$.cm({
				ClassName: "web.DHCBillWebPage",
				MethodName: "Delete",
				id: id
			}, function (json) {
				if (json.success == "0") {
					$.messager.popover({msg: json.msg, type: "success"});
					GV.PageList.reload();
				} else {
					$.messager.popover({msg: json.msg, type: "error"});
				}
			});
		}
	});
}