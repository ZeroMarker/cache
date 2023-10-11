/**
 * FileName: dhcbill.inv.selectbuyinv.js
 * Author: ZhYW
 * Date: 2017-09-30
 * Description: 
 */

$(function () {
	$("#receiptsList").datagrid({
		fit: true,
		striped: true,
		singleSelect: true,
		bodyCls: 'panel-body-gray',
		pagination: true,
		rownumbers: false,
		pageSize: 10,
		className: GV.CLS,
		queryName: GV.QUERY,
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["buyDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "buyTime") {
					cm[i].formatter = function (value, row, index) {
						return row.buyDate + " " + value;
					}
				}
				if ($.inArray(cm[i].field, ["startNo", "endNo", "curNo"]) != -1) {
					cm[i].formatter = function (value, row, index) {
						return (row.title != "") ? (row.title + "[" + value + "]") : value;
					}
				}
				if ($.inArray(cm[i].field, ["id", "title"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["startNo", "endNo", "curNo"]) != -1) {
						cm[i].width = 130;
					}
					if (cm[i].field == "leftNum") {
						cm[i].width = 80;
					}
					if (cm[i].field == "buyTime") {
						cm[i].width = 150;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: GV.CLS,
			QueryName: GV.QUERY,
			type: GV.Type,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			userId: ""   //查询所有购入的可用发票
		},
		onDblClickRow: function (index, row) {
			getReceipts(row);
		}
	});
});

function getReceipts(row) {
	var id = row.id;
	var curNo = row.curNo;
	var endNo = row.endNo;
	var title = row.title;
	var leftNum = row.leftNum;
	//将此号段置为启用
	$.m({
		ClassName: GV.CLS,
		MethodName: GV.UPDATE,
		rowID: id
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == 0) {
			var receiptStr = id + "^" + curNo + "^" + endNo + "^" + title + "^" + leftNum;
			websys_showModal("options").callbackFunc(receiptStr);
			websys_showModal("close");
		}
		$.messager.popover({msg: "更新发票状态失败：" + (myAry[1] || myAry[0]), type: "error"});
	});
}