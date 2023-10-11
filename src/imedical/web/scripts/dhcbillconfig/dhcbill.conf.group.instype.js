/**
 * FileName: dhcbill.conf.group.instype.js
 * Author: ZhYW
 * Date: 2020-08-14
 * Description: 患者类型设置
 */﻿

$(function() {
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	GV.InsTypeList = $HUI.datagrid("#insTypeList", {
		fit: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pageSize: 999999999,
		loadMsg: '',
		toolbar: [],
		columns: [[{field: 'ck', checkbox: true},
				   {title: 'AdmReaID', field: 'AdmReaID', hidden: true},
				   {title: '就诊费别', field: 'AdmReaDesc', width: 130},
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
			QueryName: "QryGSAdmReason",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				if (row.GSCfgID) {
					GV.InsTypeList.checkRow(index);
				}
			});
		}
	});
});

function defFlagCKClick(obj, index) {
	var cellObj = {};
	$.each(GV.InsTypeList.getRows(), function (idx, row) {
		if (index != idx) {
			cellObj = GV.InsTypeList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + idx + "] td[field=DefFlag] input:checkbox");
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
		var admReasonAry = [];
		$.each(GV.InsTypeList.getChecked(), function(idx, row) {
			var rowIndex = GV.InsTypeList.getRowIndex(row);
			var myAdmReaID = row.AdmReaID;
			var myGSCfgID = row.GSCfgID;
			var myDefFlag = getColumnValue(rowIndex, "DefFlag", "insTypeList") ? "Y" : "N";
			
			var myAdmReaStr = myAdmReaID + "^" + myGSCfgID + "^" + myDefFlag;
			admReasonAry.push(myAdmReaStr);
		});
		var admReasonStr = admReasonAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		$.m({
			ClassName: "BILL.CFG.COM.GroupAuth",
			MethodName: "UpdateGSAdmReason",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			admReasonStr: admReasonStr
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				GV.InsTypeList.load();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}