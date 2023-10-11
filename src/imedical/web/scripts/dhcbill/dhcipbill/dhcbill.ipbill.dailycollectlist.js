/**
 * FileName: dhcbill.ipbill.dailycollectlist.js
 * Anchor: ZhYW
 * Date: 2018-03-16
 * Description: 住院日结汇总列表
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
	
	var columns = [{field: 'ck', checkbox: true},
					 {title: 'TUserId', field: 'TUserId', hidden: true},
					 {title: '结账人', field: 'TUserName', width: 100},
					 {title: '结账日期', field: 'TDate', width: 100},
					 {title: '结账时间', field: 'TTime', width: 80},
					 {title: '结账号', field: 'TRowId', width: 80},
					 {title: '开始日期', field: 'TStDate', width: 100},
					 {title: '开始时间', field: 'TStTime', width: 80},
					 {title: '结束日期', field: 'TEndDate', width: 100},
					 {title: '结束时间', field: 'TEndTime', width: 80},
					 {title: '接收号', field: 'TReceId', width: 80},
					 {title: '收押金张数', field: 'TNorDepNum', width: 100},
					 {title: '收押金金额', field: 'TNorDepSum', align: 'right', width: 100},
					 {title: '收押金收据号段', field: 'TNorDepRcptNoStr', width: 200, showTip: true},
					 {title: '作废押金张数', field: 'TParkDepNum', width: 100},
					 {title: '作废押金金额', field: 'TParkDepSum', align: 'right', width: 100},
					 {title: '作废押金收据号', field: 'TParkDepRcptNoStr', width: 200, showTip: true},
					 {title: '红冲押金张数', field: 'TRefDepNum', width: 100},
					 {title: '红冲押金金额', field: 'TRefDepSum', align: 'right', width: 100},
					 {title: '红冲押金收据号', field: 'TRefDepRcptNoStr', width: 200, showTip: true},
					 {title: '发票总张数', field: 'TInvNum', width: 100},
					 {title: '发票总金额', field: 'TInvSum', align: 'right', width: 100},
					 {title: '发票总号段', field: 'TInvNoStr', width: 200, showTip: true},
					 {title: '作废发票张数', field: 'TParkInvNum', width: 100},
					 {title: '作废发票金额', field: 'TParkInvSum', align: 'right'},
					 {title: '作废发票号码', field: 'TParkInvNoStr', width: 200, showTip: true},
					 {title: '红冲发票张数', field: 'TRefInvNum', width: 100},
					 {title: '红冲发票金额', field: 'TRefInvSum', align: 'right', width: 100},
					 {title: '红冲发票号码', field: 'TRefInvNoStr', width: 200, showTip: true},
					 {title: '跳号押金数量', field: 'TVoidDepNum', width: 100},
					 {title: '跳号押金号码', field: 'TVoidDepNoStr', width: 150, showTip: true},
					 {title: '跳号发票数量', field: 'TVoidInvNum', width: 100},
					 {title: '跳号发票号码', field: 'TVoidInvNoStr', width: 150, showTip: true},
					 {title: '核销状态', field: 'verifyStatus', width: 80
						,formatter: function(value,row,index){
			            	if (row.verifyStatus==1&&row.TRowId!=""){
			                    return "核销";
			                } else if (row.verifyStatus==-1&&row.TRowId!=""){
			                    return "取消核销";
			                }else if (row.verifyStatus==""&&row.TRowId!=""){
				                return "未核销";
				                }
		            	}
		            },
			];
	
	if (GV.receCfg != 1) {
		var hideColAry = ["ck", "TReceId"];    //不显示的列
		columns = columns.filter(function (item) {
			return hideColAry.indexOf(item.field) == -1;
		});
	}

	$HUI.datagrid("#collectList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pagination: true,
		rownumbers: true,
		pageSize: 50,
		columns: [columns],
		toolbar: toolbar,
		idField: 'TRowId',
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillDailyCollect",
			QueryName: "FindDailyCollect",
			stDate: GV.stDate,
			endDate: GV.endDate,
			guserStr: GV.guserStr,
			receId: GV.receId,
			hospDR: GV.hospDR,
			groupDR: GV.groupDR,
			verifyStatus:GV.verifyStatus	//核销状态 20220905 WangXQ
		},
		onLoadSuccess: function (data) {
			if ($("#collectList").parent().find(".datagrid-header-row input:checkbox").length > 0) {
				var hasDisabledRow = false;
				$.each(data.rows, function (index, row) {
					if (!row.TReceId) {
						return true;
					}
					hasDisabledRow = true;
					$("#collectList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = hasDisabledRow;
				});
				//有disabled行时,表头也disabled
				$("#collectList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
			}
		},
		onDblClickRow: function (index, row) {
			scanHandinDetails(row);
		}
	});
	if (!isNeedPreReceive()){
		$("#collectList").datagrid('hideColumn', 'verifyStatus');//列的field值	
	}
});

function getCheckedFootIdStr() {
	return $("#collectList").datagrid("getChecked").filter(function (row) {
		return (row.TRowId > 0);
	}).map(function (row) {
		return row.TRowId;
	}).join("^");
}

//获取选中数据的核销状态 WangXQ 20220907
function getCheckedverifyStatus() {
	return $("#collectList").datagrid("getChecked").filter(function (row) {
		var verifyStatus=row.verifyStatus
		if(verifyStatus==""&&row.TRowId!=""){
			var verifyStatus=2	//未核销返回2
		}
		return verifyStatus;
	}).map(function (row) {
		var verifyStatus=row.verifyStatus
		if(verifyStatus==""&&row.TRowId!=""){
			var verifyStatus=2
		}
		return verifyStatus;
	}).join("^");
}

function scanHandinDetails(row) {
	var footId = row.TRowId;
	if (footId == "") {
		return;
	}
	var stDate = row.TStDate;
	var stTime = row.TStTime;
	var endDate = row.TEndDate;
	var endTime = row.TEndTime;
	var guser = row.TUserId;
	var receId = row.TReceId;
	var url = "dhcbill.dailymaintabs.csp?&businessType=IPD" + "&stDate=" + stDate + "&stTime=" + stTime
		+ "&endDate=" + endDate + "&endTime=" + endTime + "&footId=" + footId
		+ "&receId=" + receId + "&guser=" + guser + "&linkFlag=Y";
	var content = "<div style=\"width:100%;height:100%;padding:10px;\">"
					+ "<iframe frameborder=\"0\" src=\"" + websys_writeMWToken(url) + "\" width=\"100%\" height=\"100%\" scrolling=\"no\"></iframe>"
				+ "</div>";
	websys_showModal({
		content: content,
		title: $g('日结明细'),
		iconCls: 'icon-w-list',
		height: '85%',
		width: '90%'
	});
}

/**
 * Creator: ShangXuehao
 * CreatDate: 2021-07-20
 * Description: 导出
 */
function exportClick() {
	$.cm({
		ResultSetType: "ExcelPlugin",
		localDir: "Self",
		ExcelName: $(".tabs-selected .tabs-title", parent.document).text(),
		PageName: page,
		ClassName: "web.DHCIPBillDailyCollect",
		QueryName: "FindDailyCollect",
		stDate: GV.stDate,
		endDate: GV.endDate,
		guserStr: GV.guserStr,
		receId: GV.receId,
		hospDR: GV.hospDR,
		groupDR: GV.groupDR,
		langId: session['LOGON.LANGID']
	}, false);
}

/**
 * Creator: ShangXuehao
 * CreatDate: 2021-07-20
 * Description: 导出配置
 */
function configClick() {
	var url = "websys.query.customisecolumn.csp?CONTEXT=Kweb.DHCIPBillDailyCollect:FindDailyCollect&PREFID=0&PAGENAME=" + page;
	websys_showModal({
		url: url,
		title: '导出配置',
		iconCls: 'icon-w-config',
		width: '80%',
		height: '80%'
	});
}
/**
* tangzf 2022-10-27
* 通用配置--是否需要预接收   通用配置-住院收费系统-住院日报汇总->是否预接收日报
*/
function isNeedPreReceive() {
	var bool = false;
	var data = $.cm({
		ClassName: "BILL.CFG.COM.GeneralCfg",
		MethodName: "GetResultByRelaCode",
		RelaCode: "IPCHRG.CshrDRptSum.SFHXRB",
		SourceData: "",
		TgtData: "",
		HospId: GV.hospDR,
		Date: ""
	}, false);
	if(data.data.split("^")[1] == "Yes"){
		bool = true;
	}
	return bool;
}
