/**
 * FileName: dhcbill.conf.group.paym.js
 * Anchor: ZhYW
 * Date: 2019-10-23
 * Description: 支付方式授权
 */

$(function() {	
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	GV.PaymList = $HUI.datagrid("#paymList", {
		fit: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		loadMsg: '',
		toolbar: [],
		columns: [[{field: 'ck', checkbox: true},
				   {title: 'CTPMRowID', field: 'CTPMRowID', hidden: true},
		           {title: 'CTPMCode', field: 'CTPMCode', hidden: true},
				   {title: '支付方式', field: 'CTPMDesc', width: 120},
				   {title: 'PMRowID', field: 'PMRowID', hidden: true},
				   {title: '默认支付', field: 'DefFlag', width: 80, align: 'center', 
				   	formatter: function (value, row, index) {
						return "<input type='checkbox' onclick='defFlagCKClick(this, " + index + ")' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '打印标志', field: 'INVPrtFlag', width: 80, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '必要信息', field: 'RPFlag', width: 80, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '预交金', field: 'PMPDFlag', width: 70, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '收费', field: 'PMOPCFlag', width: 70, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '退费', field: 'PMOPRefundFlag', width: 70, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '挂号', field: 'PMOPRegFlag', width: 70, align: 'center',
				   	formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   }
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "ReadPMConfig",
			groupId: GV.GroupId,
			hospId: GV.HospId,
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				if (row.PMRowID) {
					GV.PaymList.checkRow(index);
				}
			});
		}
	});
});

function defFlagCKClick(obj, index) {
	var cellObj = {};
	$.each(GV.PaymList.getRows(), function (idx, row) {
		if (index != idx) {
			cellObj = GV.PaymList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + idx + "] td[field=DefFlag] input:checkbox");
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
	var paymAry = [];
	$.each(GV.PaymList.getChecked(), function(idx, row) {
		var rowIndex = GV.PaymList.getRowIndex(row);
		
		var myCTPMRowID = row.CTPMRowID;
		var myPMGSRowID = row.PMRowID;
		var myPMDefault = getEditorCellValue(rowIndex, "DefFlag");
		var myPMPrintFlag = getEditorCellValue(rowIndex, "INVPrtFlag");
		var myPMRPFlag = getEditorCellValue(rowIndex, "RPFlag");
		var myPMPDFlag = getEditorCellValue(rowIndex, "PMPDFlag");
		var myPMOPCFlag = getEditorCellValue(rowIndex, "PMOPCFlag");
		var myPMOPRegFlag = getEditorCellValue(rowIndex, "PMOPRegFlag");
		var myPMOPRefundFlag = getEditorCellValue(rowIndex, "PMOPRefundFlag");
		
		var myPMStr = myCTPMRowID + "^" + myPMGSRowID + "^" + myPMDefault + "^" + myPMPrintFlag;
		myPMStr += "^" + myPMRPFlag + "^" + myPMPDFlag + "^" + myPMOPCFlag;
		myPMStr += "^" + myPMOPRegFlag + "^" + myPMOPRefundFlag;
		paymAry.push(myPMStr);
	});
	var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	$.m({
		ClassName: "BILL.CFG.COM.GroupAuth",
		MethodName: "UpdateGSPM",
		groupId: GV.GroupId,
		hospId: GV.HospId,
		gsPMStr: paymStr
	}, function(rtn) {
		if (rtn == "0") {
			$.messager.popover({msg: "保存成功", type: "success"});
		}else {
			$.messager.popover({msg: "保存失败：" + rtn, type: "error"});
		}
	});
}

/**
* 取行编辑checkbox值
*/
function getEditorCellValue(rowIndex, fieldName) {
	var obj = GV.PaymList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input:checkbox");
	return (obj) ? ($(obj).prop("checked") ? "Y" : "N") : "N";
}