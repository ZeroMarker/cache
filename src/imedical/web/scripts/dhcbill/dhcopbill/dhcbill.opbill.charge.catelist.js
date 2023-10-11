/**
 * FileName: dhcbill.opbill.charge.oecat.js
 * Author: ZhYW
 * Date: 2021-07-28
 * Description: 门诊收费
 */

$(function() {
	initCateList();
});

function initCateList() {
	GV.CateList = $HUI.datagrid("#cateList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pageSize: 999999999,
		toolbar: [],
		columns: [[{title: '分类', field: 'CateDesc1', width: 130},
				   {title: 'CateSum1', field: 'CateSum1', hidden: true},
				   {title: 'CateDiscSum1', field: 'CateDiscSum1', hidden: true},
				   {title: 'CatePayOrSum1', field: 'CatePayOrSum1', hidden: true},
				   {title: '金额', field: 'CatePatSum1', width: 130, align: 'right'},
				   {title: '分类', field: 'CateDesc2', width:130},
				   {title: 'CateSum2', field: 'CateSum2', hidden: true},
				   {title: 'CateDiscSum2', field: 'CateDiscSum2', hidden: true},
				   {title: 'CatePayOrSum2', field: 'CatePayOrSum2', hidden: true},
				   {title: '金额', field: 'CatePatSum2', width: 130, align: 'right'},
				   {title: '分类', field: 'CateDesc3', width:130},
				   {title: 'CateSum3', field: 'CateSum3', hidden: true},
				   {title: 'CateDiscSum3', field: 'CateDiscSum3', hidden: true},
				   {title: 'CatePayOrSum3', field: 'CatePayOrSum3', hidden: true},
				   {title: '金额', field: 'CatePatSum3', width: 130, align: 'right'},
				   {title: '分类', field: 'CateDesc4', width:130},
				   {title: 'CateSum4', field: 'CateSum4', hidden: true},
				   {title: 'CateDiscSum4', field: 'CateDiscSum4', hidden: true},
				   {title: 'CatePayOrSum4', field: 'CatePayOrSum4', hidden: true},
				   {title: '金额', field: 'CatePatSum4', width: 130, align: 'right'}
			]],
		rowStyler: function (index, row) {
			if (index == (GV.CateList.getRows().length - 1)) {
				return "font-weight: bold";    //将最后一行"合计"行加粗
			}
		}
	});
}

function loadCateList(adm) {
	if (!adm) {
		return;
	}
	var curInsType = getSelectedInsType();
	if (!curInsType) {
		return;
	}
	var unBillStr = getUnBillOrderStr();
	
	var queryParams = {
		ClassName: "web.DHCOPCashier",
		QueryName: "QryAdmCateFee",
		adm: adm,
		insTypeId: curInsType,
		unBillStr: unBillStr,
		sessionStr: getSessionStr(),
		rows: 99999999
	}
	loadDataGridStore("cateList", queryParams);
}