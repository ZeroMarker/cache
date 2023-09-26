/**
 * FileName: dhcbill.opbill.arcositemlist.js
 * Anchor: ZhYW
 * Date: 2019-06-24
 * Description: 门诊收费医嘱套录入弹窗
 */
 
var GV = {
	EpisodeID: getParam("EpisodeID"),
	PatientID: getParam("PatientID"),
	InsTypeID: getParam("InsTypeID"),
	OrderSetID: getParam("OrderSetID"),
	HiddenDelete: getParam("HiddenDelete")
}

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	initArcositemList();
});

function initArcositemList() {
	var toobar = [{
        text: '增加(F4)',
        id: 'btn-add',
        iconCls: 'icon-add',
        handler: function() {
	        addClick();
        }
    }];
	GV.ARCOSItemList = $HUI.datagrid("#arcositemList", {
		fit: true,
		border: true,
		bodyCls: 'panel-body-gray',
		striped: false,
		singleSelect: true,
		checkOnSelect: false,   //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: toobar,
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: 'ItemRowid', field: 'ItemRowid', hidden: true},
				   {title: 'OrderTypeCode', field: 'OrderTypeCode', hidden: true},
				   {title: 'itmCatid', field: 'itmCatid', hidden: true},
				   {title: 'OEMessage', field: 'OEMessage', hidden: true},
				   {title: 'RangeFrom', field: 'RangeFrom', hidden: true},
				   {title: 'RangeTo', field: 'RangeTo', hidden: true},
				   {title: '医嘱项名称', field: 'desc', width: 200},
				   {title: '数量', field: 'Quantity', width: 80},
				   {title: 'RangeFrom', field: 'RangeFrom', hidden: true},
				   {title: '接收科室', field: 'OPOrdItemRecLoc', width: 150,
				   	editor: {
					   	type: 'combobox',
					   	options: {
						   	panelHeight: 'auto',
							valueField: 'RecLocRID',
							textField: 'RecLocDesc',
							method: 'get',
							editable: false,
							onLoadSuccess: function(data) {
								var defRecLocRID = "";
								$.each(data, function (index, item) {
									if (item.DefRecFlag == "Y") {
										defRecLocRID = item.RecLocRID;
										return false;
									}
								});
								$(this).combobox("select", defRecLocRID);
							},
							onSelect:function(rec) {
								var index = $(this).parents("tr").eq(1).attr("datagrid-row-index");
								var row = GV.ARCOSItemList.getRows()[index];
								row.OPOrdItemRecLocRID = rec.RecLocRID;
								row.OPOrdItemRecLoc = rec.RecLocDesc;
							},
							onChange: function(newValue, oldValue) {
								if (newValue == "") {
									var index = $(this).parents("tr").eq(1).attr("datagrid-row-index");
									var row = GV.ARCOSItemList.getRows()[index];
									row.OPOrdItemRecLocRID = "";
									row.OPOrdItemRecLoc = "";
								}
							}
						}
					}
				   },
				   {title: '单位', field: 'UOM', width: 80},
				   {title: '单价', field: 'OPOrdPrice', width: 100, align: 'right'},
				   {title: '金额', field: 'OPOrdBillSum', width: 100, align: 'right'},
				   {title: 'OPOrdItemRecLocRID', field: 'OPOrdItemRecLocRID', hidden: true},
				   {title: 'OPOrdDiscPrice', field: 'OPOrdDiscPrice', hidden: true},
				   {title: 'OPOrdInsPrice', field: 'OPOrdInsPrice', hidden: true},
				   {title: 'OPOrdPatPrice', field: 'OPOrdPatPrice', hidden: true},
				   {title: 'OPOrdInsRowId', field: 'OPOrdInsRowId', hidden: true},
				   {title: 'defdur', field: 'defdur', hidden: true},
				   {title: 'itmSubCatid', field: 'itmSubCatid', hidden: true},
				   {title: 'DISABLED', field: 'DISABLED', hidden: true},
				   {title: 'StockAvailable', field: 'StockAvailable', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.OEOrdItem",
			QueryName: "OSItemList",
			itemtext: "",
			ORDERSETID: GV.OrderSetID,
			HiddenDelete: GV.HiddenDelete,
			PatientID: GV.PatientID,
			EpisodeID: GV.EpisodeID,
			GroupID: PUBLIC_CONSTANT.SESSION.GROUPID,
			formulary: "",
			rows: 999999999
		},
		onLoadSuccess: function (data) {
			focusById("btn-add");
			if (data.total = 0) {
				return;
			}
			$.each(data.rows, function (index, row) {
				beginEditing(index, row);
			});
			GV.ARCOSItemList.checkAll();
		}
	});
}

function beginEditing(index, row) {
	GV.ARCOSItemList.beginEdit(index);
	var ed = GV.ARCOSItemList.getEditor({index: index, field: "OPOrdItemRecLoc"});
	if (ed) {
		var url = $URL + "?ClassName=web.DHCOPItemMast&QueryName=AIMRecLoc&ResultSetType=array&PAADMRowID=" + GV.EpisodeID + "&ARCIMRID=" + row.ItemRowid + "&LocRowID=" + PUBLIC_CONSTANT.SESSION.CTLOCID;
		ed.target.combobox("reload", url);
	}
	var encmeth = getValueById("OPOSOEInfoEncrypt");
	var qty = row.Quantity || 1;
	var itmInfo = cspRunServerMethod(encmeth, GV.EpisodeID, row.ItemRowid, "", GV.InsTypeID, "", "ARCIM", qty, PUBLIC_CONSTANT.SESSION.CTLOCID, PUBLIC_CONSTANT.SESSION.HOSPID);
	var myAry = itmInfo.split("^");
	
	setGridCellValue(index, "UOM", myAry[4]);
	row.UOM = myAry[4];
	
	setGridCellValue(index, "OPOrdPrice", myAry[12]);
	row.OPOrdPrice = myAry[12];
	setGridCellValue(index, "OPOrdDiscPrice", myAry[13]);
	row.OPOrdDiscPrice = myAry[13];
	setGridCellValue(index, "OPOrdInsPrice", myAry[14]);
	row.OPOrdInsPrice = myAry[14];
	setGridCellValue(index, "OPOrdPatPrice", myAry[15]);
	row.OPOrdPatPrice = myAry[15];
	
	if (myAry[17] == 1) {
		GV.ARCOSItemList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
		GV.ARCOSItemList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = true;
	}
	
	setGridCellValue(index, "OPOrdBillSum", myAry[18]);
	row.OPOrdBillSum = myAry[18];
	
	row.OPOrdInsRowId = GV.InsTypeID;
}

function setGridCellValue(rowIndex, fieldName, value) {
	var obj = GV.ARCOSItemList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] div");
	if (obj) {
		$(obj).text(value);
	}
}

function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		addClick();
		break;
	default:
	}
}

function addClick() {
	var rows = GV.ARCOSItemList.getChecked();
	if (rows.length == 0) {
		return;
	}
	var myJson = {};
	$.each(rows, function (index, row) {
		myJson = {};
		myJson["OPOrdItemDesc"] = row.desc;
		myJson["OPOrdUnit"] = row.UOM;
		myJson["OPOrdPrice"] = row.OPOrdPrice;
		myJson["OPOrdQty"] = row.Quantity;
		myJson["OPOrdBillSum"] = row.OPOrdBillSum;
		myJson["OPOrdItemRecLoc"] = row.OPOrdItemRecLoc;
		myJson["TOrdSubCat"] = row.itmCatid;
		myJson["OPOrdItemRecLocRID"] = row.OPOrdItemRecLocRID;
		myJson["OPOrdDiscPrice"] = row.OPOrdDiscPrice;
		myJson["OPOrdInsPrice"] = row.OPOrdInsPrice;
		myJson["OPOrdPatPrice"] = row.OPOrdPatPrice;
		myJson["OPOrdType"] = row.OrderTypeCode;
		myJson["OPOrdInsRowId"] = row.OPOrdInsRowId;
		myJson["OPOrdItemRowID"] = row.ItemRowid;
		websys_showModal("options").originWindow.addCopyItemToList(myJson);
	});
	websys_showModal("options").originWindow.appendEditRow();
	websys_showModal("close");
}