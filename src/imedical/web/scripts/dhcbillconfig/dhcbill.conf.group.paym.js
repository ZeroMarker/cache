/**
 * FileName: dhcbill.conf.group.paym.js
 * Author: ZhYW
 * Date: 2019-10-23
 * Description: 支付方式授权
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkRepeat: {    //重复性校验
	    validator: function(value, param) {
	    	var bool = true;
		    $.each(GV.PayMList.getRows(), function (index, row) {
			    if (index == GV.EditRowIndex) {
				    return true;
				}
			    if (row[param[0]] && (row[param[0]] == value)) {
				    bool = false;
				    return false;
				}
			});
			return bool;
		},
		message: "该值已存在"
	}
});
	
$(function() {	
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	GV.PayMList = $HUI.datagrid("#paymList", {
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
				   {title: '支付方式', field: 'CTPMDesc', width: 100},
				   {title: 'PMRowID', field: 'PMRowID', hidden: true},
				   {title: '默认支付', field: 'DefFlag', width: 70, align: 'center',
				   	formatter: function (value, row, index) {
						return "<input type='checkbox' onclick='defFlagCKClick(this, " + index + ")' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '打印标志', field: 'INVPrtFlag', width: 70, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '必要信息', field: 'RPFlag', width: 70, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '收预交金', field: 'PMPDFlag', width: 70, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {title: '退预交金', field: 'PMDEPRefundFlag', width: 70, align: 'center',
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
				   },
				   {title: '急诊留观<br/>收费', field: 'PMObsChgFlag', width: 80, align: 'center',
				    formatter: function (value, row, index) {
						return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				   },
				   {field: 'PMSequence', title: '顺序号', width: 70,
				   	 editor: {
					   	type: 'numberbox',
					   	options: {
						   	min:1,
						   	isKeyupChange: true,
						   	validType:['checkRepeat["PMSequence"]']
						 }
					  }
				   },
				   {field: 'PMHotKey', title: '收银台<br/>快捷键', width: 70,
				   	editor: {
					   	type: 'validatebox',
					   	options: {
						   	validType: ['checkRepeat["PMHotKey"]']
						 }
					}
				   },
				   {field: 'PMIconCls', title: '收银台<br/>支付方式图标', width: 100, editor: 'text'}
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.CFG.COM.GroupAuth",
			QueryName: "ReadPMConfig",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			GV.EditRowIndex = undefined;
			$.each(data.rows, function(index, row) {
				if (row.PMRowID) {
					GV.PayMList.checkRow(index);
				}
			});
		},
		onClickCell: function (index, field, value) {
			if (GV.PayMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + index + "] td[field=" + field + "] input").length == 0) {
				clickCellHandler(index, field, value);
			}
		}
	});
});

function clickCellHandler(index, field, value) {
	if (endEditing()) {
		GV.EditRowIndex = index;
		GV.PayMList.editCell({index: index, field: field});
		var ed = GV.PayMList.getEditor({index: index, field: field});
		if (ed) {
			$(ed.target).focus();
		}
	}
}

function endEditing() {
	if (GV.EditRowIndex == undefined) {
		return true;
	}
	if (GV.PayMList.validateRow(GV.EditRowIndex)) {
		//datagrid endEdit()中有refreshRow，会refresh掉checkbox的值，故先记录值，endEdit后再赋值.
		var fieldObj = {};
		var field = "";
		GV.PayMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + GV.EditRowIndex + "] td[field!='ck'] input:checkbox").each(function(idx, ele) {
			field = $(this).parents("td").attr("field");
			fieldObj[field] = $(this).prop("checked");
		});
		
		GV.PayMList.endEdit(GV.EditRowIndex);

		GV.PayMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + GV.EditRowIndex + "] td[field!='ck'] input:checkbox").each(function(idx, ele) {
			field = $(this).parents("td").attr("field");
			$(this).prop("checked", fieldObj[field]);
		});
		
		GV.EditRowIndex = undefined;
		return true;
	}
	return false;
}

function defFlagCKClick(obj, index) {
	var cellObj = {};
	$.each(GV.PayMList.getRows(), function (idx, row) {
		if (index != idx) {
			cellObj = GV.PayMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + idx + "] td[field=DefFlag] input:checkbox");
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
	if (!endEditing()) {
		return;
	}
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
		var paymAry = [];
		$.each(GV.PayMList.getChecked(), function(idx, row) {
			var rowIndex = GV.PayMList.getRowIndex(row);
			var myCTPMRowID = row.CTPMRowID;
			var myPMGSRowID = row.PMRowID;
			var myPMDefault = getEditorCellValue(rowIndex, "DefFlag");
			var myPMPrintFlag = getEditorCellValue(rowIndex, "INVPrtFlag");
			var myPMRPFlag = getEditorCellValue(rowIndex, "RPFlag");
			var myPMPDFlag = getEditorCellValue(rowIndex, "PMPDFlag");
			var myPMOPCFlag = getEditorCellValue(rowIndex, "PMOPCFlag");
			var myPMOPRegFlag = getEditorCellValue(rowIndex, "PMOPRegFlag");
			var myPMOPRefundFlag = getEditorCellValue(rowIndex, "PMOPRefundFlag");
			var myPMSequence = row.PMSequence;
			var myPMHotKey = row.PMHotKey;
			var myPMIconCls = row.PMIconCls;
			var myObsChgFlag = getEditorCellValue(rowIndex, "PMObsChgFlag");   //急诊留观收费
			var myPMDEPRefundFlag = getEditorCellValue(rowIndex, "PMDEPRefundFlag");   //退预交金
			
			var myPMStr = myCTPMRowID + "^" + myPMGSRowID + "^" + myPMDefault + "^" + myPMPrintFlag
				+ "^" + myPMRPFlag + "^" + myPMPDFlag + "^" + myPMOPCFlag + "^" + myPMOPRegFlag
				+ "^" + myPMOPRefundFlag + "^" + myPMSequence + "^" + myPMHotKey + "^" + myPMIconCls
				+ "^" + myObsChgFlag+ "^" + myPMDEPRefundFlag;
			paymAry.push(myPMStr);
		});
		var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		$.m({
			ClassName: "BILL.CFG.COM.GroupAuth",
			MethodName: "UpdateGSPM",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			gsPMStr: paymStr
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				GV.PayMList.load();
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}

/**
* 取行编辑checkbox值
*/
function getEditorCellValue(index, field) {
	var checked = GV.PayMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + index + "] td[field=" + field + "] input:checkbox").is(":checked");
	return checked ? "Y" : "N";
}
