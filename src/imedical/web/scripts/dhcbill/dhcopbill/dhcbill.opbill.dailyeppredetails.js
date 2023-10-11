/**
 * FileName: dhcbill.opbill.dailyeppredetails.js
 * Anchor: ZhYW
 * Date: 2018-03-08
 * Description: 急诊留观押金明细
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
	
	$HUI.datagrid('#epPreList', {
		fit: true,
		striped: true,
		border: false,
		url: $URL,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		columns: [[{title: '交款日期', field: 'TPreDate', width: 100},
				   {title: '交款时间', field: 'TPreTime', width: 100},
				   {title: '患者姓名', field: 'TPatName',  width: 100},
				   {title: '登记号', field: 'TRegNo', width: 100},
				   {title: '金额', field: 'TPreSum', align: 'right', width: 100},
				   {title: '支付方式', field: 'TPaymDesc', width: 100},
				   {title: '状态', field: 'TStatus', width: 100},
				   {title: '记录号', field: 'TRowId', width: 100},
				   {title: '流水号', field: 'TBillNo', width: 180},
				   {title: '结账号', field: 'TPreFootDR', width: 100},
				   {title: '级别', field: 'TEncryptLevel', width: 100},
				   {title: '密级', field: 'TPatLevel', width: 100}
			]],
		queryParams: {
			ClassName: "web.DHCOPBillDailyDetails",
			QueryName: "FindEPPreDetails",
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
function exportClick(){		
	$.cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: $(".tabs-selected .tabs-title", parent.document).text(),
		PageName: page,
		ClassName: "web.DHCOPBillDailyDetails",
		QueryName: "FindEPPreDetails",
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
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCOPBillDailyDetails:FindEPPreDetails&PREFID=0&PAGENAME=" + page;
	websys_showModal({
		url: url,
		title: '导出配置',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}