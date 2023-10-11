/**
 * FileName: dhcbill.ipbill.dailyipbillinvdetails.js
 * Anchor: ZhYW
 * Date: 2018-03-16
 * Description: 出院结算收费明细
 */

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
		ClassName: "web.DHCBillGroupConfig",
		MethodName: "GetInvDetColumns"
	}, function (columns) {
		var hideColAry = ["TInvRoundErrSum"];    //不显示的列
		columns = columns.filter(function(item) {
			return hideColAry.indexOf(item.field) == -1;
		});

		$HUI.datagrid('#ipbillInvList', {
			fit: true,
			striped: true,
			border: false,
			url: $URL,
			pagination: true,
			rownumbers: true,
			pageSize: 20,
			toolbar: toolbar,
			columns: [columns],
			queryParams: {
				ClassName: "web.DHCIPBillDailyDetails",
				QueryName: "FindIPBillInvDetails",
				stDate: GV.stDate,
				stTime: GV.stTime,
				endDate: GV.endDate,
				endTime: GV.endTime,
				footId: GV.footId,
				guser: GV.guser,
				hospDR: GV.hospDR,
				langId: session['LOGON.LANGID']
			}
		});
	});
});

/**
 * Creator: ShangXuehao
 * CreatDate: 20210720
 * Description: 导出
 */
function exportClick() {
	$.cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: $(".tabs-selected .tabs-title", parent.document).text(),
		PageName: page,
		ClassName: "web.DHCIPBillDailyDetails",
		QueryName: "FindIPBillInvDetails",
		stDate: GV.stDate,
		stTime: GV.stTime,
		endDate: GV.endDate,
		endTime: GV.endTime,
		footId: GV.footId,
		guser: GV.guser,
		hospDR: GV.hospDR,
		langId: session['LOGON.LANGID']
	}, false);
}

/**
 * Creator: ShangXuehao
 * CreatDate: 20210720
 * Description: 导出配置
 */
function configClick() {
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCIPBillDailyDetails:FindIPBillInvDetails&PREFID=0&PAGENAME=" + page;
	websys_showModal({
		url: url,
		title: '导出配置',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}