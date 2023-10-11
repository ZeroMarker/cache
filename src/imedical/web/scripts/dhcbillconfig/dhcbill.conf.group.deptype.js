/**
 * FileName: dhcbill.conf.group.deptype.js
 * Author: ZhYW
 * Date: 2020-08-14
 * Description: 押金类型设置
 */﻿

$(function() {
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	GV.DepTypeList = $HUI.datagrid("#depTypeList", {
		fit: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pageSize: 999999999,
		loadMsg: '',
		toolbar: [],
		columns: [[{field: 'ck', checkbox: true},
				   {title: 'DepTypeID', field: 'DepTypeID', hidden: true},
				   {title: '押金类型', field: 'DepTypeDesc', width: 140},
				   {title: 'GSCfgID', field: 'GSCfgID', hidden: true},
		           {title: '是否默认', field: 'DefFlag', width: 80, align: 'center', 
		            formatter: function (value, row, index) {
						return "<input type='checkbox' onclick='defFlagCKClick(this, " + index + ")' " + (value == "Y" ? "checked" : "") + "/>";
					}
		           }
		         ]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "QryGSDepType",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				if (row.GSCfgID) {
					GV.DepTypeList.checkRow(index);
				}
			});
		}
	});
});

function defFlagCKClick(obj, index) {
	var cellObj = {};
	$.each(GV.DepTypeList.getRows(), function (idx, row) {
		if (index != idx) {
			cellObj = GV.DepTypeList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + idx + "] td[field=DefFlag] input:checkbox");
			if ($(obj).prop("checked")) {
				cellObj.prop("checked", false);
			}
		}
	});
}

/**
* 保存
*/
function saveClick() {
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		var depTypeAry = [];
		$.each(GV.DepTypeList.getChecked(), function(idx, row) {
			var rowIndex = GV.DepTypeList.getRowIndex(row);
			var myDepTypeID = row.DepTypeID;
			var myGSCfgID = row.GSCfgID;
			var myDefFlag = getColumnValue(rowIndex, "DefFlag", "depTypeList") ? "Y" : "N";
			
			var myDepTypeStr = myDepTypeID + "^" + myGSCfgID + "^" + myDefFlag;
			depTypeAry.push(myDepTypeStr);
		});
		var depTypeStr = depTypeAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		$.m({
			ClassName: "BILL.CFG.COM.GroupAuth",
			MethodName: "UpdateGSDepType",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			depTypeStr: depTypeStr
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				GV.DepTypeList.load();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}