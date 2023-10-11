/**
 * FileName: dhcbill.ipbill.billorder.js
 * Author: ZhYW
 * Date: 2019-12-20
 * Description: 费用核对
 */

$(function () {
	refreshBar(CV.PatientID, CV.EpisodeID);
	
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
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	//审核标志
	$HUI.combobox("#confirmFlag", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: 'Y', text: $g('通过'), selected: true},
		       {value: 'N', text: $g('拒绝')}
		]
	});
	
	//医嘱大类
	$HUI.combobox("#ordCate", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryOrdCate&ResultSetType=array&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onChange: function(newValue, oldValue) {
			if (!newValue) {
				$("#ordSubCate").combobox("clear").combobox("loadData", []);
				return;
			}
			var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryARCItemCat&ResultSetType=array&ordCatId=" + newValue + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
			$("#ordSubCate").combobox("clear").combobox("reload", url);
		}
	});
	
	//医嘱子类
	$HUI.combobox("#ordSubCate", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

function initPBOList() {
	$HUI.datagrid("#pboList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		className: "web.UDHCJFBillDetailOrder",
		queryName: "FindBillOrderDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["PhcfDesc", "PhmnfName", "BillNo", "tariID"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TOEORI") {
					cm[i].formatter = function(value, row, index) {
					   	if (value) {
							return "<a href='javascript:;' onclick='execDetail(" + JSON.stringify(row) + ")'>" + value +"</a>";
						}
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.UDHCJFBillDetailOrder",
			QueryName: "FindBillOrderDetail",
			BillNo: CV.BillID,
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			userDeptId: getValueById("userDept") || "",
			ordCatId: getValueById("ordCate") || "",
			ordSubCatId: getValueById("ordSubCate") || ""
		}
	});
}

function execDetail(row) {
	$("#execDlg").show().dialog({
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
						OEORI: row.TOEORI,
						StDate: getValueById("execStDate"),
						EndDate: getValueById("execEndDate"),
						BillNo: CV.BillID
					});
				}
			});
			$HUI.datagrid("#execList", {
				fit: true,
				bodyCls: 'panel-body-gray',
				singleSelect: true,
				pagination: true,
				pageSize: 10,
				toolbar: '#exec-tb',
				className: "web.UDHCJFBillDetailOrder",
				queryName: "FindOeordexecFee",
				onColumnsLoad: function(cm) {
					for (var i = (cm.length - 1); i >= 0; i--) {
						if ($.inArray(cm[i].field, ["Tconfflag"]) != -1) {
							cm.splice(i, 1);
							continue;
						}
						if (!cm[i].width) {
							cm[i].width = 100;
							if ($.inArray(cm[i].field, ["DateExecuted", "TExStDate"]) != -1) {
								cm[i].width = 155;
							}
						}
					}
				},
				url: $URL,
				queryParams: {
					ClassName: "web.UDHCJFBillDetailOrder",
					QueryName: "FindOeordexecFee",
					OEORI: row.TOEORI,
					StDate: getValueById("execStDate"),
					EndDate: getValueById("execEndDate"),
					BillNo: CV.BillID
				}
			});
		}
	});
}

function findClick() {
	var queryParams = {
		ClassName: "web.UDHCJFBillDetailOrder",
		QueryName: "FindBillOrderDetail",
		BillNo: CV.BillID,
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		userDeptId: getValueById("userDept") || "",
		ordCatId: getValueById("ordCate") || "",
		ordSubCatId: getValueById("ordSubCate") || ""
	}
	loadDataGridStore("pboList", queryParams);
}

/**
* 审核
*/
function confirmClick() {
	if ($("#btn-confirm").linkbutton("options").disabled) {
		return;
	}
	$("#btn-confirm").linkbutton("disable");
	
	$.messager.confirm("确认", "是否确认审核?", function(r) {
		if (!r) {
			$("#btn-confirm").linkbutton("enable");
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBillDetailOrder",
			MethodName: "Confirm",
			Adm: CV.EpisodeID,
			BillNo: CV.BillID,
			User: PUBLIC_CONSTANT.SESSION.USERID,
			Reason: getValueById("confirmReason"),
			Flag: getValueById("confirmFlag")
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "审核成功", type: "success"});
				$("#btn-confirm").linkbutton("enable");
				return;
			}
			$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
			$("#btn-confirm").linkbutton("enable");
		});
	});
}

/**
* 撤销审核
*/
function cancelClick() {
	if ($("#btn-cancel").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancel").linkbutton("disable");
	
	$.messager.confirm("确认", "是否确认撤销审核?", function(r) {
		if (!r) {
			$("#btn-cancel").linkbutton("enable");
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBillDetailOrder",
			MethodName: "Confirm",
			Adm: CV.EpisodeID,
			BillNo: CV.BillID,
			User: PUBLIC_CONSTANT.SESSION.USERID,
			Reason: getValueById("confirmReason"),
			Flag: "C"
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "撤销审核成功", type: "success"});
				$("#btn-cancel").linkbutton("enable");
				return;
			}
			$.messager.popover({msg: (myAry[1] || myAry[0]), type: "error"});
			$("#btn-cancel").linkbutton("enable");
		});
	});
}