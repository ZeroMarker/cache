/**
 * FileName: dhcbill.outpay.ipaddinv.js
 * Author: LUANZH
 * Date: 2022-12-5
 * Description: 住院外院发票录入
 */

//全局变量
var TotalNewInv = 0; //新增发票数量

$(function() {
	var billNo = getValueById("billNo");
	findIpAdmInfo();
	loadinsuItmList(billNo);
	showBannerTip();
	initQueryMenu();
	initinsuItmList();
	GetAddInvInfo();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function() {
			readHFMagCardClick();
		}
	});

	var min = $.fn.datebox.defaults.formatter($.fn.datebox.defaults.parser('t'));
	$("#billTime").datetimebox({
		value: min,

	})
}

function initinsuItmList() {
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

	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function() {
			saveClick();
		}
	}, {
		text: '取消编辑',
		iconCls: 'icon-redo',
		handler: function() {
			rejectClick();
		}
	}]
	GV.InsuItmList = $HUI.datagrid("#insuItmList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: false,
		rownumbers: true,
		toolbar: toolbar,
		className: "BILL.OUTPAY.BL.ItemCtl",
		queryName: "ItemListQuery",
		onColumnsLoad: function(cm) {
			var a = {
				field: 'HospApprFlag1',
				title: '审核通过'
			}
			var b = {
				field: 'HospApprFlag2',
				title: '不需要审核'
			}
			cm.splice(14, 0, a, b);
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["InsuInvId", "ItemId", "InvDR", "ItmDR", "ItmCode", "ItmType", "BilgDeptCode", "BilgDeptName", "BilgDocName", "BilgDocCode", "TcmDrugUsedWay", "MatnFeeFlag", "EcoctionPiecesFlag", "DispGranulesFlag", "DscgTkDrugFlag", "CombNo", "Memo", "HospApprFlag", "UploadFlag", "PBODDR", "PBODType", "OptDate", "UpdtDate", "BillDate", "OptUserDR", "UpdtUserDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
				}
				if (cm[i].field == 'InvNoTmp') {
					cm[i].title = "发票号"
				}
				if (cm[i].field == 'ItmDesc') {
					cm[i].width = 300;
					if (GV.ItemType == 'HIS') {
						cm[i].title = "收费项目名称"
						cm[i].editor = {
							type: 'combogrid',
							options: {
								panelWidth: 660,
								fitColumns: true,
								method: 'GET',
								pagination: true,
								idField: 'ItmDesc',
								textField: 'ItmDesc',
								mode: 'remote',
								url: $URL + '?ClassName=BILL.OUTPAY.BL.ItemCtl&QueryName=ItmInfoQuery',
								delay: 300,
								lazy: true,
								enterNullValueClear: false,
								selectOnNavigation: false,
								required: true,
								columns: [
									[{
										field: 'ItmDR',
										title: 'rowid',
										width: 250,
										hidden: true
									}, {
										field: 'ItmCode',
										title: '收费项代码',
										width: 100
									}, {
										field: 'ItmDesc',
										title: '收费项名称',
										width: 150
									}, {
										field: 'InsuItmCode',
										title: '医保项目编码',
										width: 100
									}, {
										field: 'InsuItmDesc',
										title: '医保项目名称',
										width: 150
									}, {
										field: 'InsuScale',
										title: '自付比例',
										width: 80
									}, {
										field: 'InsuXmlb',
										title: '项目等级',
										width: 80
									}, ]
								],
								onBeforeLoad: function(param) {
									param.key = param.q;
									param.AdmReasonDr = getValueById("PatInsTypeDR");
									param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
								},
								onSelect: function(index, row) {
									onSelectItemHandler(row);
								}
							}
						};
					} else {
						cm[i].title = "医保项目名称"
						cm[i].editor = {
							type: 'combogrid',
							options: {
								panelWidth: 860,
								fitColumns: true,
								method: 'GET',
								pagination: true,
								idField: 'InsuItmDesc',
								textField: 'InsuItmDesc',
								mode: 'remote',
								url: $URL + '?ClassName=BILL.OUTPAY.BL.ItemCtl&QueryName=ItmInfoQuery',
								delay: 300,
								lazy: true,
								enterNullValueClear: false,
								selectOnNavigation: false,
								required: true,
								columns: [
									[{
											field: 'ItmDR',
											title: 'rowid',
											width: 250,
											hidden: true
										}, {
											field: 'ItmCode',
											title: '收费项代码',
											width: 100,
											hidden: true
										}, {
											field: 'ItmDesc',
											title: '收费项名称',
											width: 250,
											hidden: true
										}, {
											field: 'InsuItmCode',
											title: '医保项目编码',
											width: 100
										}, {
											field: 'InsuItmDesc',
											title: '医保项目名称',
											width: 250
										}, {
											field: 'InsuScale',
											title: '自付比例',
											width: 80
										}, {
											field: 'InsuXmlb',
											title: '项目等级',
											width: 80
										},

									]
								],
								onBeforeLoad: function(param) {
									param.key = param.q;
									param.AdmReasonDr = getValueById("PatInsTypeDR");
									param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
								},
								onSelect: function(index, row) {
									onSelectItemHandler(row);
								}
							}
						}
					}



				}
				if (cm[i].field == 'Price') {
					cm[i].title = "单价";
					cm[i].align = 'right';
					cm[i].editor = {
						type: 'numberbox',
						options: {
							required: true,
							precision: 4,
							//isKeyupChange: true,
							onChange: function(newValue, oldValue) {
								var row = GV.InsuItmList.getRows()[GV.EditRowIndex];
								if (row) {
									row.Price = newValue;
								}
							}
						}

					};
				}
				if (cm[i].field == 'Qty') {
					cm[i].title = "数量";
					cm[i].width = 60;
					cm[i].editor = {
						type: 'numberbox',
						options: {
							required: true,
							precision: 1,
							//isKeyupChange: true,
							onChange: function(newValue, oldValue) {
								var row = GV.InsuItmList.getRows()[GV.EditRowIndex];
								if (row) {
									row.Qty = newValue;
								}
							}
						}
					};
				}
				if (cm[i].field == 'Amt') {
					cm[i].title = "金额";
					cm[i].align = 'right';
				}
				if (cm[i].field == 'BillTime') {
					cm[i].title = "费用发生时间";
					cm[i].width = 175;
					cm[i].formatter = function(value, row, index) {
						if (row.BillDate) {
							return row.BillDate + " " + value;
						}
					};
					cm[i].editor = {
						type: 'datetimebox',
						options: {
							required: true
						}
					};
				}
				if (cm[i].field == 'HospApprFlag1') {
					cm[i].align = 'center';
					cm[i].formatter = function(value, row, index) {
						if (row.HospApprFlag == "1") {
							return '<input  type="checkbox"  id="checkboxL'+index+'" checked="checked"  onclick="clk(\'' + row + '\',' + index + ',\'L\')" />';
						} else {
							return '<input  type="checkbox"  id="checkboxL'+index+'"  onclick="clk(\'' + row + '\',' + index + ',\'L\')" />';
						}
					}
				}
				if (cm[i].field == 'HospApprFlag2') {
					cm[i].align = 'center';
					cm[i].formatter = function(value, row, index) {
						if (row.HospApprFlag == "0") {
							return '<input  type="checkbox"  id="checkboxR'+index+'" checked="checked"  onclick="clk(\'' + row + '\',' + index + ',\'R\')" />';
						} else {
							return '<input  type="checkbox"  id="checkboxR'+index+'" onclick="clk(\'' + row + '\',' + index + ',\'R\')" />';
						}
					}
				}
				if (cm[i].field == 'OptUserDesc') {
					cm[i].title = "创建人"
				}
				if (cm[i].field == 'OptTime') {
					cm[i].title = "创建时间"
					cm[i].width = 175;
					cm[i].formatter = function(value, row, index) {
						if (row.OptDate) {
							return row.OptDate + " " + value;
						}
					}
				}
				if (cm[i].field == 'UpdtUserDesc') {
					cm[i].title = "更新人"
				}
				if (cm[i].field == 'UpdtTime') {
					cm[i].title = "更新时间"
					cm[i].width = 175;
					cm[i].formatter = function(value, row, index) {
						if (row.UpdtDate) {
							return row.UpdtDate + " " + value;
						}
					}
				}
			}
		},
		onBeforeLoad:function(data){
			data.rows = "9999999";
			return data;
		},
		onLoadSuccess: function(data) {
			GV.EditRowIndex = undefined;
			if(GV.AuditFlag=="0"){
				$('#insuItmList').datagrid('hideColumn','HospApprFlag1');
				$('#insuItmList').datagrid('hideColumn','HospApprFlag2');
			}
		},
		onBeginEdit: function(index, row) {
			onBeginEditHandler(index, row);
		},
		onSelect: function(index, row) {
			calinvamt(row);
		},
		onDblClickRow: function(index, row) {
			updateClick();
		}

	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").linkbutton("options").disabled) {
		return;
	}
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
		case "0":
			setValueById("CardNo", myAry[1]);
			patientId = myAry[4];
			setValueById("patientNo", myAry[5]);
			setValueById("accMRowId", myAry[7]);
			setValueById("CardTypeRowId", myAry[8]);
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function() {
				focusById("CardNo");
			});
			break;
		case "-201":
			setValueById("CardNo", myAry[1]);
			patientId = myAry[4];
			setValueById("patientNo", myAry[5]);
			setValueById("CardTypeRowId", myAry[8]);
			break;
		default:
	}
	if (patientId != "") {
		setPatDetail(patientId);
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}

function getPatInfo() {
	setValueById('EpisodeID', '');
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({
					msg: "登记号错误，请重新输入",
					type: "info"
				});
				focusById("patientNo");
			} else {
				setValueById("PatientId", papmi);
				setPatDetail(papmi);
			}
		});
	}
}

function setPatDetail(papmi) {
	setValueById("PatientId", papmi);
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: ""
	}, function(rtn) {
		var myAry = rtn.split("^");
		var myPatientNo = myAry[1];
		var myPatType = myAry[7];
		var myAccMRowId = myAry[19];
		setValueById("patientNo", myPatientNo);
	});
	refreshBar(papmi, "");

}

function loadinsuItmList(billNo) {
	var queryParams = {
		ClassName: "BILL.OUTPAY.BL.ItemCtl",
		QueryName: "ItemListQuery",
		PatBillDR: billNo,
		AdmType: 'I',
		AdmDR: getValueById("EpisodeID")
	};
	loadDataGridStore("insuItmList", queryParams);
}

function onSelectItemHandler(row) {
	if (!row) {
		return;
	}
	setItemList(row);
	var editRow = GV.InsuItmList.getRows()[GV.EditRowIndex];
	if (!editRow) {
		return;
	}
	if (GV.ItemType == 'HIS') {
		editRow.ItmDesc = row.ItmDesc;
	} else {
		editRow.ItmDesc = row.InsuItmDesc;
	}
}

function onBeginEditHandler(index, row) {
	var ed = GV.InsuItmList.getEditor({
		index: index,
		field: "BillTime"
	});
	var datetime = $('#billTime').datetimebox('getValue');
	if (ed) {
		$(ed.target).datetimebox("setValue", datetime);
	}
}

function onEndEditHandler(index, row) {
	var ed = GV.InsuItmList.getEditor({
		index: index,
		field: "ItmDesc"
	});
	if (ed) {
		row.ItmDesc = $(ed.target).combogrid("getText");
	}
}

function setItemList(row) {
	var editRow = GV.InsuItmList.getRows()[GV.EditRowIndex];
	if (!editRow) {
		return;
	}

	if (GV.ItemType == 'HIS') {
		setGridCellValue(GV.EditRowIndex, "ItmCode", row.ItmCode); //收费项目编码 
		editRow.ItmCode = row.ItmCode;

	} else {
		setGridCellValue(GV.EditRowIndex, "ItmCode", row.InsuItmCode); //医保项目编码
		editRow.ItmCode = row.InsuItmCode;

	}

	setGridCellValue(GV.EditRowIndex, "ItmDR", row.ItmDR); //收费项目ID / 医保项目ID
	editRow.ItmDR = row.ItmDR;

	var billtime = $('#billTime').datetimebox('getValue');
	setGridCellValue(GV.EditRowIndex, "BillTime", billtime);
	editRow.BillTime = billtime;

	var invNo = getValueById("invNo");
	setGridCellValue(GV.EditRowIndex, "InvNoTmp", invNo);
	editRow.InvNoTmp = invNo;
}

function setGridCellValue(rowIndex, fieldName, value) {
	var ed = GV.InsuItmList.getEditor({
		index: rowIndex,
		field: fieldName
	});
	if (ed) {
		var obj = GV.InsuItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input");
		if (obj) {
			$(obj).val(value);
		}
	} else {
		var obj = GV.InsuItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] div");
		if (obj) {
			$(obj).text(value);
		}
	}
}

/**
 * 新增
 */
function addClick() {
	var selfg = checkSelInfo();
	if (selfg == 1) {
		return;
	}
	var invNo = getValueById("invNo");
	var correctAdmNo = getValueById("EpisodeID");
	$.m({
		ClassName: "BILL.OUTPAY.BL.InsuInvCtl",
		MethodName: "GetPAADMRowidByInvNo",
		OutFlag: "Y",
		AdmType: "I",
		InvNo: invNo
	}, function(rtn) {
		if (rtn != correctAdmNo && rtn != "") {
			$.messager.alert("提示", "该发票号与就诊记录不一致，请重新选择就诊记录!", 'info');
			return;
		} else {
			$.m({
				ClassName: "BILL.OUTPAY.BL.InvPrtCtl",
				MethodName: "InvChgedFlagByInvNo",
				OutFlag: "Y",
				AdmType: "I",
				InvNo: invNo
			}, function(rtn) {
				if (rtn == "N") {
					$.messager.alert("提示", "该发票已结算，无法再录入明细!", 'info');
					return;
				} else {
					var row = {};
					$.each(GV.InsuItmList.getColumnFields(), function(index, item) {
						row[item] = "";
					});
					$("#insuItmList").datagrid("insertRow", {
						index: 0,
						row: row
					});
					TotalNewInv = TotalNewInv + 1; //计算录入明细条数
					GV.InsuItmList.beginEdit(0); //明细从第0条开始录入
					GV.InsuItmList.selectRow(0);
					GV.EditRowIndex = 0;
				}
			})
		}
	})
}

/**
 * 取消编辑
 */
function rejectClick() {
	GV.InsuItmList.rejectChanges();
	GV.EditRowIndex = undefined;
	TotalNewInv = 0;
}

/**
 * 修改
 */
function updateClick() {
	if (GV.EditRowIndex != undefined) {
		$.messager.popover({
			msg: "有正在编辑的行",
			type: "info"
		});
		return;
	}
	var row = GV.InsuItmList.getSelected();
	if (!row) {
		$.messager.popover({
			msg: "请选择需要编辑的行",
			type: "info"
		});
		return;
	}
	GV.EditRowIndex = GV.InsuItmList.getRowIndex(row);
	var invNo = getValueById("invNo");
	$.m({
		ClassName: "BILL.OUTPAY.BL.InvPrtCtl",
		MethodName: "InvChgedFlagByInvNo",
		OutFlag: "Y",
		AdmType: "I",
		InvNo: invNo
	}, function(rtn) {
		if (rtn == "N") {
			$.messager.alert("提示", "该发票已结算，无法再修改明细!", 'info');
			GV.EditRowIndex = undefined;
			return;
		} else {
			GV.InsuItmList.beginEdit(GV.EditRowIndex);
		}
	})
}

/**
 * 保存
 */
function saveClick() {
	var checkfg = checkRequired();
	if (checkfg == 1) {
		return;
	}
	var money = 0;
	var Rowid = 0; //明细rowid 
	$.messager.confirm("确认", "是否确认保存?", function(r) {
		if (r) {
			var selfg = checkSelInfo();
			if (selfg == 1) {
				return;
			}
			var TCrter = PUBLIC_CONSTANT.SESSION.USERID;
			if (!endEditing()) {
				return;
			}
			var alldata = GV.InsuItmList.getRows();
			var arr = []; //保存录入明细到数组arr
			console.log(TotalNewInv)
			if (TotalNewInv == 0) {
				var row = GV.InsuItmList.getSelected();
				GV.EditRowIndex = GV.InsuItmList.getRowIndex(row);
				var newdata = alldata[GV.EditRowIndex];
				arr.push(newdata);
			} else {
				for (i = 0; i < TotalNewInv; i++) {
					var newdata = alldata[i];
					arr.push(newdata);
				}
			}
			//TotalNewInv==0是修改,TotalNewInv>0是增加
			if (TotalNewInv == 0) {
				var c = arr[0].ItemId;
				arr[0].Rowid = c;
				var data = arr[0].BillTime;
				var a = data.split(" ");
				var Date = a[0];
				var Time = a[1];
				arr[0].BillDate = Date;
				arr[0].BillTime = Time;
				arr[0].Amt = arr[0].Price * arr[0].Qty
				arr[0].ItemType = GV.ItemType;
			} else {
				for (i = 0; i < TotalNewInv; i++) {
					var c = arr[i].ItemId;
					arr[i].Rowid = c;
					arr[i].ItmType = GV.ItemType;
					var data = arr[i].BillTime;
					var a = data.split(" ");
					var Date = a[0];
					var Time = a[1];
					arr[i].BillDate = Date;
					arr[i].BillTime = Time;
					arr[i].Amt = arr[i].Price * arr[i].Qty
				}
			}

			console.log(arr)

			//计算总金额
			var invNo = getValueById("invNo");
			for (i = 0; i < GV.InsuItmList.getRows().length; i++) {
				if ((alldata[i].InvNoTmp == "") || (alldata[i].InvNoTmp == invNo)) {
					money = Number(money) + Number(alldata[i].Amt);
				}
			}
			money = money.toFixed(2);
			console.log(money)
			if (!arr[0].BillTime) {
				$.messager.alert("提示", "请双击修改发票信息或者点击'新增'按钮录入发票信息!", 'info');
				GV.EditRowIndex = undefined;
				return
			}
			var jsonObj = {
				InvNo: getValueById("invNo"),
				PatBillDR: getValueById("billNo"),
				OutFlag: 'Y',
				ConType: "PatientBill",
				TotalAmt: money,
				PAPMIDR: getValueById("PatientId"),
				AdmDR: getValueById("EpisodeID"),
				AdmType: "I",
				DiagCode: "",
				DiagDesc: "",
				HospDR: PUBLIC_CONSTANT.SESSION.HOSPID,
				OptUserDR: TCrter,
				UpdtUserDR: TCrter,
				Items: arr,
			};
			$.m({
				ClassName: "BILL.OUTPAY.BL.InsuInvCtl",
				MethodName: "Save",
				InputJson: JSON.stringify(jsonObj)
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({
						msg: "保存成功",
						type: "success"
					});
					TotalNewInv = 0;
					GV.InsuItmList.reload();
					GetAddInvInfo();
					return;
				} else {
					$.messager.popover({
						msg: "保存失败：" + (myAry[1] || myAry[0]),
						type: "error"
					});
					TotalNewInv = 0;
					GetAddInvInfo();
				}

			});

		}

	})
}

/**
 *删除
 */
function deleteClick() {
	var row = GV.InsuItmList.getSelected();
	if (!row) {
		$.messager.popover({
			msg: "请单击行选中需要删除的明细",
			type: "info"
		});
		return;
	}
	var invNo = getValueById("invNo");
	$.m({
		ClassName: "BILL.OUTPAY.BL.InvPrtCtl",
		MethodName: "InvChgedFlagByInvNo",
		OutFlag: "Y",
		AdmType: "I",
		InvNo: invNo
	}, function(rtn) {
		if (rtn == "N") {
			$.messager.alert("提示", "该发票已结算，不能删除发票对应明细!", 'info');
			GV.EditRowIndex = undefined;
			return;
		} else {
			var rowIndex = GV.InsuItmList.getRowIndex(row);
			$.messager.confirm("确认", "是否确认删除明细?", function(r) {
				if (r) {
					var ItemId = row.ItemId;
					var rtn = $.m({
						ClassName: "BILL.OUTPAY.DTO.Items",
						MethodName: "DeleteItemsByID",
						ItemID: ItemId
					}, false);
					if (rtn == 0) {
						GV.EditRowIndex = undefined;
						$.messager.popover({
							msg: "删除成功",
							type: "success"
						});
						GV.InsuItmList.uncheckRow(rowIndex);
						GV.InsuItmList.deleteRow(rowIndex);
						var billNo = getValueById("billNo")
						loadinsuItmList(billNo);
						setValueById("invNo", "");
						setValueById("invAmt", "");
						GetAddInvInfo();
					} else {
						$.messager.popover({
							msg: "删除失败：" + (ItemId),
							type: "error"
						});
						setValueById("invNo", "");
						setValueById("invAmt", "");
						GetAddInvInfo();
					}
				}
			});
		}
	})

}

function endEditing() {
	if (GV.EditRowIndex == undefined) {
		return true;
	}
	if (GV.InsuItmList.validateRow(GV.EditRowIndex)) {

		GV.InsuItmList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	}
	return false;
}

function clearClick() {
	setValueById('PatientId', '');
	setValueById('EpisodeID', '');
	$(':text:not(.pagination-num,.combobox-f)').val('');
	$('.numberbox-f').numberbox('clear');
	setValueById('stDate', getDefStDate(0));
	setValueById('endDate', '');
	$('#admList').combogrid('clear');
	$('.datagrid-f').datagrid('loadData', {
		total: 0,
		rows: []
	});

	//清除banner
	showBannerTip();
}

/**
 *计算发票总金额
 */
function calinvamt(row) {
	var invNo = row.InvNoTmp;
	if (row.InvNoTmp) {
		setValueById("invNo", row.InvNoTmp)
	}
	var allAmt = 0;
	var alldata = GV.InsuItmList.getRows();
	for (i = 0; i < GV.InsuItmList.getRows().length; i++) {
		if (alldata[i].InvNoTmp == invNo) {
			allAmt = Number(allAmt) + Number(alldata[i].Amt);
		}

	}
	allAmt = allAmt.toFixed(2);
	setValueById("invAmt", allAmt);
}

/**
 *账单号取费别
 */
function findIpAdmInfo() {
	$.m({
		ClassName: "BILL.OUTPAY.BL.FindAdmInfo",
		MethodName: "FindIpAdmInfo",
		billId: getValueById("billNo")
	}, function(rtn) {
		setValueById("PatInsTypeDR", rtn);
		console.log(rtn)
	});
}

/**
 * 校验必填项
 */
function checkRequired() {
	var checkdata = GV.InsuItmList.getRows();
	console.log(checkdata)
	for (i = 0; i < checkdata.length; i++) {
		if (checkdata[i].ItmDesc == "" || checkdata[i].Price == "" || checkdata[i].Qty == "") {
			$.messager.alert("提示", "请录入发票必填信息!", 'info');
			return 1;
		}
	}
}

/**
 * 检查查询条件是否完整
 */
function checkSelInfo() {
	var invNo = getValueById("invNo");
	if (invNo == "") {
		$.messager.alert("提示", "请输入发票号!", 'info');
		return 1;
	}

}

function clk(row, index, type) {
	var row = GV.InsuItmList.getSelected();
	var selindex=$('#insuItmList').datagrid('getRowIndex',row);
	if (type == "L") {
		$('#checkboxR'+selindex).removeAttr('checked');
		row.HospApprFlag = "1";
		if(!$('#checkboxL'+selindex).prop('checked')){
			$('#checkboxL'+selindex).removeAttr('checked');
			row.HospApprFlag = "2";
		}
	}
	if (type == "R") {
		$('#checkboxL'+selindex).removeAttr('checked');
		row.HospApprFlag = "0";
		if(!$('#checkboxR'+selindex).prop('checked')){
			$('#checkboxR'+selindex).removeAttr('checked');
			row.HospApprFlag = "2";
		}
	}
}

/**
* 计算录入发票总金额和数量
*/
function GetAddInvInfo() {
	$.m({
	ClassName: "BILL.OUTPAY.BL.InsuInvCtl",
	MethodName: "GetInvInfoByAdmId",
	AdmId: getValueById("EpisodeID")
}, function(rtn) {
	var Info=rtn.split("^");
	var num=Info[0];
	var totalAmt=Info[1];
	setValueById("invNum",num);
	setValueById("addAmt",totalAmt);
})
}
