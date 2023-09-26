/**
 * FileName: dhcbill.pkg.patpkg.js
 * Anchor: ZhYW
 * Date: 2018-02-18
 * Description: �ͻ��ײ�
 */

var GV = {
	EditIndex: undefined,
	RowsJson: {},
	PatientID: getParam('PatientID'),
	ARCIMID: getParam('ARCIMID')
};

/*
 * ��֤������
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
		message: '��ΪС�ڵ��ڶ���������������'
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
					title: '������',
					field: 'orderNumber',
					width: 100
				}, {
					title: '�ײ�����',
					field: 'productName',
					width: 170
				}
			]],
		onSelect: function (rowIndex, rowData) {
			endEditing();
			loadOrderList(rowData.pkgRowId);
		}
	});
	//��������
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
					title: '��Ʒ��',
					field: 'arcimDesc',
					width: 100
				}, {
					title: 'uomDR',
					field: 'uomDR',
					hidden: true
				}, {
					title: '��λ',
					field: 'uomDesc',
					hidden: true
				}, {
					title: 'ʣ������',
					field: 'remainqty',
					width: 80
				}, {
					title: '¼������',
					field: 'insertQty',
					width: 80,
					editor: {
						type: 'numberbox',
						options: {
							validType: 'integer'
						}
					}
				}, {
					title: '��׼����',
					field: 'priceperunit',
					align: 'right',
					width: 80
				}, {
					title: '�Ը�����',
					field: 'patshareprice',
					align: 'right',
					width: 80
				}, {
					title: '�ۿ۵���',
					field: 'discprice',
					align: 'right',
					width: 80
				}, {
					title: '��Ч��ʼ����',
					field: 'validstdate',
					width: 100
				}, {
					title: '��Ч��������',
					field: 'validenddate',
					width: 100
				}, {
					title: '��������',
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
 * �����ײ���ϸ
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
		$.messager.alert('��ʾ', '��ѡ��ҽ����ϸ', 'info');
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
		$.messager.alert('��ʾ', '��ѡ��ҽ����ϸ', 'info');
		return;
	}
	var myStr = myAry.join();    //������תΪ�ַ�������
	websys_showModal("options").CallBackFunc(myStr);
	websys_showModal("close");
}

function cancelClick() {
	websys_showModal("options").CallBackFunc("");
	websys_showModal("close");
}