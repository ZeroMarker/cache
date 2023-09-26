/**
 * FileName: dhcbill.ipbill.billorder.js
 * Anchor: ZhYW
 * Date: 2019-12-20
 * Description: 费用核对
 */

var GV = {
	EpisodeID: getParam("EpisodeID"),
	BillRowId: getParam("BillRowId")
};

$(function () {
	$.cm({
		ClassName: "web.DHCBillCommon",
		MethodName: "GetClsPropValById",
		clsName: "User.PAAdm",
		id: GV.EpisodeID
	}, function(jsonObj) {
		refreshBar(jsonObj.PAADMPAPMIDR, GV.EpisodeID);
	});
	initQueryMenu();
	initPBOList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			findClick();
		}
	});

	$HUI.linkbutton("#btn-confirm", {
		onClick: function () {
			confirmClick();
		}
	});
	
	$HUI.linkbutton("#btn-cancel", {
		onClick: function () {
			cancelClick();
		}
	});
	
	//开单科室
	$HUI.combobox("#userDept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'dept',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	//审核标志
	$HUI.combobox("#confirmFlag", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'id',
		textField: 'text',
		data: [{id: 'Y', text: '通过', selected: true},
		       {id: 'N', text: '拒绝'}
		]
	});
}

function initPBOList() {
	$HUI.datagrid("#pboList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		columns: [[{title: '项目分类', field: 'Ttaridesc', width: 140},
				   {title: '医嘱', field: 'Torder', width: 260},
				   {title: '单位', field: 'Tuom', width: 100},
				   {title: '单价', field: 'Tunitprice', width: 150, align: 'right'},
				   {title: '数量', field: 'Tqty', width: 150},
				   {title: '金额', field: 'Tprice', width: 180, align: 'right'},
				   {title: '医嘱ID', field: 'OrderRowid', width: 120,
				   	formatter: function(value, row, index) {
					   	if (value) {
							return "<a href='javascript:;' onclick='execDetail(" + JSON.stringify(row) + ")'>" + value + "||" + row.OrderSub +"</a>";
						}
					}
				   }
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFBillDetailOrder",
			QueryName: "FindBillOrderDetail",
			BillNo: GV.BillRowId,
			stdate: getValueById("stDate"),
			endate: getValueById("endDate"),
			getdoclocid: getValueById("userDept") || ""
		}
	});
}

function execDetail(row) {
	$("#execDlg").show();
	$("#execDlg").dialog({
		width: 900,
		height: 530,
		iconCls: 'icon-w-list',
		title: '执行记录明细',
		draggable: false,
		modal: true,
		onBeforeOpen: function() {
			$HUI.linkbutton("#btn-execFind", {
				onClick: function () {
					$("#execList").datagrid("load", {
						ClassName: "web.UDHCJFBillDetailOrder",
						QueryName: "FindOeordexecFee",
						Oeordrowid: row.OrderRowid + "||" + row.OrderSub,
						StDate: getValueById("execStDate"),
						EndDate: getValueById("execEndDate"),
						BillNo: GV.BillRowId
					});
				}
			});
			$HUI.datagrid("#execList", {
				fit: true,
				striped: true,
				bodyCls: 'panel-body-gray',
				singleSelect: true,
				pagination: true,
				pageSize: 10,
				toolbar: '#exec-tb',
				columns:[[{title: '执行时间', field: 'DateExecuted', width: 150},
						  {title: '执行状态', field: 'OrderStatus', width: 70},
						  {title: '要求执行时间', field: 'TExStDate', width: 150},
						  {title: '处理人', field: 'ctpcp', width: 80},
						  {title: '开单科室', field: 'OeoreLoc', width: 100},
						  {title: '金额', field: 'TPatamt', width: 80, align: 'right'},
						  {title: '计费状态', field: 'TBillFlag', width: 70},
						  {title: '发药数量', field: 'TCollectQty', width: 70},
						  {title: '退药数量', field: 'TRefundQty', width: 70},
						  {title: '开医嘱人', field: 'Tdoctor', width: 80},
						  {title: '医嘱类型', field: 'TordPrior', width: 80},
						  {title: '数量', field: 'TPatnum', width: 70},
						  {title: '账单医嘱ID', field: 'TBillOrdrowid', width: 100},
						  {title: '执行记录ID', field: 'TOrdExcRowID', width: 100}
					]],
				url: $URL,
				queryParams: {
					ClassName: "web.UDHCJFBillDetailOrder",
					QueryName: "FindOeordexecFee",
					Oeordrowid: row.OrderRowid + "||" + row.OrderSub,
					StDate: getValueById("execStDate"),
					EndDate: getValueById("execEndDate"),
					BillNo: GV.BillRowId
				}
			});
		}
	});
}

function findClick() {
	var queryParams = {
		ClassName: "web.UDHCJFBillDetailOrder",
		QueryName: "FindBillOrderDetail",
		BillNo: GV.BillRowId,
		stdate: getValueById("stDate"),
		endate: getValueById("endDate"),
		getdoclocid: getValueById("userDept") || ""
	}
	loadDataGridStore("pboList", queryParams);
}

/**
* 审核
*/
function confirmClick() {
	$.messager.confirm("确认", "是否确认审核?", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFBillDetailOrder",
				MethodName: "Confirm",
				Adm: GV.EpisodeID,
				BillNo: GV.BillRowId,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				Reason: getValueById("confirmReason"),
				Flag: getValueById("confirmFlag")
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.popover({msg: '审核成功', type: 'success'});
					break;
				case "Y":
					$.messager.popover({msg: '账单已经是审核通过状态，不用再审核通过', type: 'info'});
					break;
				case "N":
					$.messager.popover({msg: '账单已经是审核拒绝状态，不用再审核拒绝', type: 'info'});
					break;
				case "BillErr":
					$.messager.popover({msg: '患者有多个未结算账单，不允许审核', type: 'info'});
					break;
				case "VSatusErr":
					$.messager.popover({msg: '患者有未做最终结算，不允许审核', type: 'info'});
					break;
				case "CloseAcountErr":
					$.messager.popover({msg: '该账单未封帐，不允许审核', type: 'info'});
					break;
				case "AdmErr":
					$.messager.popover({msg: '患者正在进行费用调整，不允许审核', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '审核失败，错误代码：' + rtn, type: 'error'});
				}
			});
		}
	});
}

/**
* 撤销审核
*/
function cancelClick() {
	$.messager.confirm("确认", "是否确认撤销审核?", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFBillDetailOrder",
				MethodName: "Confirm",
				Adm: GV.EpisodeID,
				BillNo: GV.BillRowId,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				Reason: getValueById("confirmReason"),
				Flag: "C"
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.popover({msg: '撤销审核成功', type: 'success'});
					break;
				case "C":
					$.messager.popover({msg: '该账单已经是撤销审核状态，不能再次撤销', type: 'info'});
					break;
				case "":
					$.messager.popover({msg: '该账单未审核，不需要撤销', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '撤销审核失败，错误代码：' + rtn, type: 'error'});
				}
			});
		}
	});
}