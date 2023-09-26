/**
 * FileName: dhcbill.conf.group.tabs.js
 * Anchor: ZhYW
 * Date: 2019-10-23
 * Description: 页签授权
 */

$(function() {
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	GV.TabTreegrid = $HUI.treegrid("#tabTreegrid", {
		fit: true,
		border: false,
		idField: 'id',
		treeField: 'title',
		checkbox: true,
		pageSize: 999999999,
		loadMsg: '',
		toolbar: [],
		columns: [[{title: 'id', field: 'id', hidden: true},
				   {title: '页签名称', field: 'title', width: 450},
				   {title: '是否默认', field: 'defFlag', width: 80, align: 'center',
					formatter: function (value, row, index) {
						if (value) {
							return "<input type='checkbox' onclick='defFlagCKClick(this, " + JSON.stringify(row) + ")' " + (value == "Y" ? "checked" : "") + "/>";
						}
					}
				   },
				   {title: 'tabRowID', field: 'tabRowID', hidden: true},
				   {title: 'gtRowID', field: 'gtRowID', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "FindGroupTabs",
			groupId: GV.GroupId,
			hospId: GV.HospId,
			rows: 99999999
		}
	});
});

function defFlagCKClick(obj, row) {
	var tabRowId = row.tabRowID;
	if (!tabRowId) {
		return;
	}
	var cellObj = {};
	$.each(GV.TabTreegrid.getChildren(row._parentId), function (idx, item) {
		if (row.id != item.id) {
			cellObj = GV.TabTreegrid.getPanel().find(".datagrid-row[node-id=" + item.id + "] td[field=defFlag] input:checkbox");
			if ($(obj).prop("checked")) {
				cellObj.prop("checked", false);
			}
		}
	});
}

function saveClick() {
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (r) {
			var myAry = [];
			$.each(GV.TabTreegrid.getCheckedNodes("checked"), function (index, row) {
				if (row.tabRowID) {
					var myTabRowID = row.tabRowID;
					var myGTRowID = row.gtRowID || "";
					var defFlag = $(GV.TabTreegrid.getPanel().find(".datagrid-row[node-id=" + row.id + "] td[field=defFlag] input:checkbox")).prop("checked") ? "Y" : "N";
					var str = myGTRowID + "^" + myTabRowID + "^" + defFlag;
					myAry.push(str);
				}
			});
			var checkedStr = myAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			
			$.m({
				ClassName: "BILL.CFG.COM.GroupAuth",
				MethodName: "SaveGroupTabs",
				groupId: GV.GroupId,
				hospId: GV.HospId,
				GTStr: checkedStr
			}, function (rtn) {
				if (rtn == "0") {
					$.messager.popover({msg: "保存成功", type: "success"});
				}else {
					$.messager.popover({msg: "保存失败", type: "error"});
				}
			});
		}
	});
}