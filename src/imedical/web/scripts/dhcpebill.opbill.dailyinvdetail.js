/**
 * FileName: dhcpebill.opbill.dailyinvdetail.js
 * Anchor: xy
 * Date: 2018-05-24
 * Description:门诊与体检日报合并中发票明细
 */
 
var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		GROUP_ROWID: session['LOGON.GROUPID'],
		HOSP_ROWID: session['LOGON.HOSPID']
	},
	METHOD: {
		CLS: "web.DHCPE.DHCPEToOPBillInterface",
		QUERY: "FindInv"
	}
};



$(function () {
	var toolbar = [{
		text: $g('导出'),
		iconCls: 'icon-export',
		handler: function () {
			exportClick();
		}
	},{
		text: $g('导出配置'),
		iconCls: 'icon-batch-cfg',
		handler: function () {
			configClick();
		}
	}];
	

	$.cm({
		ClassName: "web.DHCPE.DHCPEToOPBillInterface",
		MethodName: "GetInvDetColumns",
		LocID:session['LOGON.CTLOCID']
	}, function (txtData) {
		var columnAry = new Array();
		var columnum=txtData.length;
		$.each(txtData, function (index, item) {
			var column = {};
			column["title"] = item.title;
			column["field"] = item.field;
			column["align"] = item.align;
			column["width"] = 1552/columnum-1;
			columnAry.push(column);
		});
		var opbillInvListObj = $HUI.datagrid('#dhcpeInvList', {
				url: $URL,
				fit: true,
				striped: true,
				border: false,
				pagination: true,
				rownumbers: true,
				pageSize: 20,
				pageList: [20, 30, 40, 50],
				toolbar: toolbar,
				columns: [columnAry],
				queryParams: {
					ClassName: PUBLIC_CONSTANT.METHOD.CLS,
					QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
					stDate: GlobalObj.stDate,
					stTime: GlobalObj.stTime,
					endDate: GlobalObj.endDate,
					endTime: GlobalObj.endTime,
					footId: GlobalObj.footId,
					guser: GlobalObj.guser,
					hospDR: GlobalObj.hospDR,
					LocID:session['LOGON.CTLOCID']
				}
			});
	});
});

/**
 * Creator: xueying
 * CreatDate: 20230420
 * Description: 导出
*/
function exportClick() {
	$.cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: $(".tabs-selected .tabs-title", parent.document).text(),
		PageName: page,
		ClassName: PUBLIC_CONSTANT.METHOD.CLS,
	    QueryName: PUBLIC_CONSTANT.METHOD.QUERY,
	    stDate: GlobalObj.stDate,
		stTime: GlobalObj.stTime,
		endDate: GlobalObj.endDate,
		endTime: GlobalObj.endTime,
		footId: GlobalObj.footId,
		guser: GlobalObj.guser,
		hospDR: GlobalObj.hospDR,
		LocID:session['LOGON.CTLOCID']
	}, false);
}

/**
 * Creator: xueying
 * CreatDate: 20230420
 * Description: 导出配置
*/
function configClick() {
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCOPBillDailyDetails:FindOPBillInvDetails&PREFID=0&PAGENAME=" + page;
	websys_showModal({
		url: url,
		title: '导出配置',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}


