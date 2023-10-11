/**
 * FileName: dhcbill.itemlist.js
 * Author: ZhYW
 * Date: 2019-03-18
 * Description: 收费项目明细
 */

var init = function() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadItmList();
		}
	});
	
	//收费项
	$HUI.combobox("#tarItm", {
		panelHeight: 150,
		mode: 'remote',
		method: 'GET',
		delay: 200,
		valueField: 'rowid',
		textField: 'desc',
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$.extend($(this).combobox("options"), {url: $URL})
				param.ClassName = "DHCBILLConfig.DHCBILLFIND";
				param.QueryName = "FindTarItem";
				param.ResultSetType = "array";
				param.alias = param.q;
				param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			}
		}
	});
	
	$HUI.datagrid("#itmList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFITM",
		queryName: "FindItmDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TBillDate", "TCreatDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TBillTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TBillDate + " " + value;
					}
				}
				if (cm[i].field == "TCreatTime") {
					cm[i].formatter = function(value, row, index) {
				   		return row.TCreatDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TItemDesc") {
						cm[i].width = 180;
					}
					if (cm[i].field == "TQty") {
						cm[i].width = 80;
					}
					if (cm[i].field == "TUom") {
						cm[i].width = 70;
					}
					if ($.inArray(cm[i].field, ["TBillTime", "TCreatTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFITM",
			QueryName: "FindItmDetail",
			BillNo: CV.BillID,
			StDate: getValueById("stDate"),
			EndDate: getValueById("endDate"),
			TarItmId: getValueById("tarItm")
		}
	});
};

var loadItmList = function() {
	var queryParams = {
		ClassName: "web.UDHCJFITM",
		QueryName: "FindItmDetail",
		BillNo: CV.BillID,
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		TarItmId: getValueById("tarItm")
	};
	loadDataGridStore("itmList", queryParams);
};

$(init);