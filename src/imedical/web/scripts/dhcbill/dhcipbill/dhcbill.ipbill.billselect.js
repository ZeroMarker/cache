﻿/**
 * FileName: dhcbill.ipbill.billselect.js
 * Anchor: ZhYW
 * Date: 2019-05-22
 * Description: 选择患者账单
 */
 
var GV = {};

$(function () {
	var toolbar = [{
			id: 'btn-export',
			text: '费用明细',
			iconCls: 'icon-pat-fee-det',
			handler: function () {
				var row = GV.BillList.getSelected();
				if (!row) {
					$.messager.popover({msg: "请选择账单", type: "info"});
					return;
				}
				var billId = row.Tbillno;
				if (!billId) {
					return;
				}
				websys_showModal({
					url: "dhcbill.ipbill.billdtl.csp?&EpisodeID=" + getParam("EpisodeID") + "&BillRowId=" + billId,
					title: '费用明细',
					iconCls: 'icon-w-list',
					width: '85%'
				});
			}
		}, {
			id: 'btn-print',
			text: '费用核对',
			iconCls: 'icon-compare',
			handler: function () {
				var row = GV.BillList.getSelected();
				if (!row) {
					$.messager.popover({msg: "请选择账单", type: "info"});
					return;
				}
				var billId = row.Tbillno;
				if (!billId) {
					return;
				}
				websys_showModal({
					url: "dhcbill.ipbill.billorder.csp?EpisodeID=" + getParam("EpisodeID") + "&BillRowId=" + billId,
					title: '费用核对',
					iconCls: 'icon-w-stamp',
					width: '90%'
				});
			}
		}
	]
	
	GV.BillList = $HUI.datagrid("#billList", {
		fit: true,
		striped: true,
		bodyCls: 'panel-body-gray',
		singleSelect: true,
		pageSize: 999999999,
		toolbar: toolbar,
		columns: [[{title: '患者姓名', field: 'Tpatname', width: 100},
				   {title: '登记号', field: 'Tpatno', width: 120},
				   {title: '入院日期', field: 'Tadmdate', width: 120},
				   {title: '出院日期', field: 'Tdisdate',width: 120},
				   {title: '总费用', field: 'Tpatfee', align: 'right', width: 100},
				   {title: '账单号', field: 'Tbillno', width: 100},
				   {title: '账单状态', field: 'Tstatus', width: 100}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFORDCHK",
			QueryName: "getpatbill",
			Adm: getParam("EpisodeID")
		}
	});
});