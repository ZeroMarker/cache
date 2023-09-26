/**
 * FileName: dhcbill.pkg.patpkg.js
 * Anchor: ZhYW
 * Date: 2018-02-18
 * Description: 客户套餐
 */

var GV = {
	EditIndex: undefined,
	RowsJson: {},
	PatientID: getParam('PatientID'),
	ARCIMID: getParam('ARCIMID')
};

/*
 * 验证正整数
 */
$.extend($.fn.validatebox.defaults.rules, {
	integer: {
		validator: function (value, param) {
			var bool = true;
			var curRow = $(this).parents('.datagrid-row').attr('datagrid-row-index') || '';
			if (curRow != '') {
				var reg = /^[1-9]\d*$/;
				if (!reg.test(value)) {
					bool = false;
				} else {
					var rowData = $('#orderList').datagrid('getRows')[curRow];
					var quantity = rowData.quantity;
					if (+value > +quantity) {
						bool = false;
					}
				}
			}
			return bool;
		},
		message: '须为小于等于订购数量的正整数'
	}
});

$(function () {
	initQueryMenu();
	refreshBar(GV.PatientID, '');
	initPatPkgList();
	initOrderList();
});

function initQueryMenu() {
	$HUI.linkbutton('#btn-ok', {
		onClick: function () {
			saveClick();
		}
	});

	$HUI.linkbutton('#btn-cancel', {
		onClick: function () {
			cancelClick();
		}
	});
}

function initPatPkgList() {
	$HUI.datagrid('#patPkgList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: false,
		pageSize: 999999999,
		toolbar: [],
		data: [],
		columns: [[{
					title: 'pkgRowId',
					field: 'pkgRowId',
					hidden: true
				}, {
					title: 'productId',
					field: 'productId',
					hidden: true
				}, {
					title: '订单号',
					field: 'orderNumber',
					width: 100
				}, {
					title: '套餐名称',
					field: 'productName',
					width: 170
				}
			]],
		onSelect: function (rowIndex, rowData) {
			endEditing();
			loadOrderList(rowData.pkgRowId);
		}
	});
	//加载数据
	loadPatPkgList();
}

function initOrderList() {
	$HUI.datagrid('#orderList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		fitColumns: false,
		autoRowHeight: false,
		pageSize: 999999999,
		toolbar: [],
		data: [],
		columns: [[{
					title: 'orddRowId',
					field: 'orddRowId',
					hidden: true
				}, {
					title: 'arcim',
					field: 'arcim',
					hidden: true
				}, {
					title: '产品名',
					field: 'arcimDesc',
					width: 100
				}, {
					title: 'uomDR',
					field: 'uomDR',
					hidden: true
				}, {
					title: '单位',
					field: 'uomDesc',
					hidden: true
				}, {
					title: '剩余数量',
					field: 'remainqty',
					width: 80
				}, {
					title: '录入数量',
					field: 'insertQty',
					width: 80,
					editor: {
						type: 'numberbox',
						options: {
							validType: 'integer'
						}
					}
				}, {
					title: '标准单价',
					field: 'priceperunit',
					align: 'right',
					width: 80
				}, {
					title: '自付单价',
					field: 'patshareprice',
					align: 'right',
					width: 80
				}, {
					title: '折扣单价',
					field: 'discprice',
					align: 'right',
					width: 80
				}, {
					title: '有效开始日期',
					field: 'validstdate',
					width: 100
				}, {
					title: '有效结束日期',
					field: 'validenddate',
					width: 100
				}, {
					title: '订购数量',
					field: 'quantity',
					width: 80
				}
			]],
		onLoadSuccess: function (data) {
			$.each(data.rows, function (index, row) {
				var myJson = GV.RowsJson['\"' + row.orddRowId + '\"'];
				if (myJson) {
					var qty = myJson.insertQty;
					HISUIDataGrid.setFieldValue('insertQty', qty, index, 'orderList');
				}
			});
		},
		onClickRow: function (index, row) {
			if (GV.EditIndex != index) {
				if (endEditing()) {
					$(this).datagrid('selectRow', index).datagrid('beginEdit', index);
					GV.EditIndex = index;
					insertQtyFocus(index);
				} else {
					$(this).datagrid('selectRow', GV.EditIndex);
				}
			}
		}
	});
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if ($('#orderList').datagrid('validateRow', GV.EditIndex)) {
		$('#orderList').datagrid('endEdit', GV.EditIndex);
		savaOrdQtyToJson(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/*
 * 保存套餐明细
 */
function savaOrdQtyToJson(index) {
	var rows = $('#orderList').datagrid('getRows');
	if (rows) {
		var row = rows[index];
		var orddRowId = row.orddRowId;
		var insertQty = row.insertQty;
		if (+insertQty > 0) {
			GV.RowsJson['\"' + orddRowId + '\"'] = row;
		} else {
			delete GV.RowsJson['\"' + orddRowId + '\"'];
		}
	}
}

function insertQtyFocus(index) {
	var objOrdGrid = $HUI.datagrid('#orderList');
	var ed = objOrdGrid.getEditor({index: index, field: 'insertQty'});
	if (ed) {
		$(ed.target).focus();
		$(ed.target).select();
	}
}

function loadPatPkgList() {
	var queryParams = {
		ClassName: 'BILL.PKG.BL.PkgPackage',
		QueryName: 'FindPkgPatPackage',
		patientId: GV.PatientID,
		arcimId: GV.ARCIMID,
		hospitalId: PUBLIC_CONSTANT.SESSION.HOSPID,
		rows: 999999999
	};
	loadDataGridStore('patPkgList', queryParams);
}

function loadOrderList(pkgRowId) {
	var queryParams = {
		ClassName: 'BILL.PKG.BL.PkgPackage',
		QueryName: 'FindPkgOrderDtl',
		pkgRowId: pkgRowId,
		rows: 999999999
	};
	loadDataGridStore('orderList', queryParams);
}

function saveClick() {
	if (!endEditing()) {
		return;
	}
	GV.EditIndex = undefined;
	$('#orderList').datagrid('acceptChanges');
	if ($.isEmptyObject(GV.RowsJson)) {
		$.messager.alert('提示', '请选择医嘱明细', 'info');
		return;
	}
	var myAry = [];
	var num = 0;
	$.each(GV.RowsJson, function (key, row) {
		var arcim = row.arcim;
		var seqNo = ++num;
		var orddRowId = row.orddRowId;
		var qty = row.insertQty;
		var uom = row.uomDR;
		var uomDesc = row.uomDesc;
		var itmData = '^^^^' + qty + PUBLIC_CONSTANT.SEPARATOR.CH1 + uomDesc + PUBLIC_CONSTANT.SEPARATOR.CH1 + uom + '^^^^^^^^^^^^^^^^^' + orddRowId;
		var orderType = row.orderType;
		var itmStr = arcim + '!' + seqNo + '!' + itmData + '!' + orderType + '!' + '!'+ '!' + 'Order';
		myAry.push(itmStr);
	});
	if (myAry == "") {
		$.messager.alert('提示', '请选择医嘱明细', 'info');
		return;
	}
	var myStr = myAry.join();    //将数组转为字符串返回
	websys_showModal("options").CallBackFunc(myStr);
	websys_showModal("close");
}

function cancelClick() {
	websys_showModal("options").CallBackFunc("");
	websys_showModal("close");
}