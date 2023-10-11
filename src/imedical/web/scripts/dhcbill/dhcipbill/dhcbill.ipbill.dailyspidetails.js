/**
 * FileName: dhcbill.ipbill.dailyspidetails.js
 * Anchor: ZhYW
 * Date: 2021-05-12
 * Description: 出院结算集中打印发票明细
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
	
	$HUI.datagrid('#summaryInvList', {
		fit: true,
		striped: true,
		border: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		columns: [[{title: '交款日期', field: 'TInvDate', width: 100},
				   {title: '交款时间', field: 'TInvTime', width: 80},
				   {title: '患者姓名', field: 'TPatName', width: 100},
				   {title: '病案号', field: 'TMedicareNo', width: 100},
				   {title: '登记号', field: 'TRegNo', width: 150},
				   {title: '状态', field: 'TStatus', width: 100},
				   {title: '发票号', field: 'TInvNo', width: 128},
				   {title: '金额', field: 'TInvSum', align: 'right', width: 100},
				   {title: '记录号', field: 'TRowId', width: 100},
				   {title: '原发票记录', field: 'TInitInvDR', width: 100},
				   {title: '结账号', field: 'TInvFootDR', width: 80},
				   {title: '费别', field: 'TAdmReaDesc', width: 80},
				   {title: '级别', field: 'TEncryptLevel', width: 80}, 
				   {title: '密级', field: 'TPatLevel', width: 80}
			]],
		queryParams: {
			ClassName: "web.DHCIPBillDailyDetails",
			QueryName: "FindSPIDetails",
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
		QueryName: "FindSPIDetails",
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
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCIPBillDailyDetails:FindSPIDetails&PREFID=0&PAGENAME=" + page;
	websys_showModal({
		url: url,
		title: '导出配置',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}