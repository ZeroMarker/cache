/**
 * FileName: dhcbill.ipbill.dailydtllist.js
 * Author: ZhYW
 * Date: 2018-04-02
 * Description: 病区日清明细
 */

$(function () {
	initQueryMenu();
	initPatTree();
	initDtlList();
	initCateList();
});

function initQueryMenu() {
	$("#more-container").click(function () {
		var t = $(this);
		var ui = (HISUIStyleCode == "lite") ? "l" : "w";  //+2022-07-08 ZhYW 根据HISUI风格显示上下箭头图标
		if (t.find(".arrows-" + ui + "-text").text() == $g("更多")) {
			t.find(".arrows-" + ui + "-text").text($g("收起"));
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-td").slideDown("normal", setHeight(140));
		} else {
			t.find(".arrows-" + ui + "-text").text($g("更多"));
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-td").slideUp("normal", setHeight(-140));
		}
	});
	
	$("#menu-stDate, #menu-endDate").datebox("setValue", CV.DefDate);  //初始化日期为昨天

	$("#menu-stTime").timespinner("setValue", "00:00:00");
	$("#menu-endTime").timespinner("setValue", "23:59:59");

	$HUI.linkbutton("#menu-search", {
		onClick: function () {
			findClick();
		}
	});

	$HUI.linkbutton("#menu-prtdtl, #menu-prtcate", {
		onClick: function () {
			printClick(this.id);
		}
	});
	
	$HUI.switchbox("#merge-switch", {
		onText: $g('合并'),
		offText: $g('拆分'),
		animated: true,
		onClass: 'primary',
		offClass: 'gray',
		onSwitchChange: function (e, val) {
			loadDtlList();
		}
	});

	$HUI.combobox("#menu-ward", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryWard&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		selectOnNavigation: false,
		value: PUBLIC_CONSTANT.SESSION.WARDID,   //默认本病区
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
		},
		onChange: function (newValue, oldValue) {
			$("#menu-episodeId").combogrid("clear").combogrid("grid").datagrid("reload");
			GV.PatTree.reload();
		}
	});
	
	$HUI.combogrid("#menu-episodeId", {
		panelWidth: 700,
		panelHeight: 300,
		pagination: true,
		selectOnNavigation: false,
		showRefresh: false,
		url: $URL + '?ClassName=web.DHCIPBillDailyDtlList&QueryName=FindAdmList',
		mode: 'remote',
		delay: 500,
		lazy: true,
		idField: 'adm',
		textField: 'adm',
		columns: [[{field: 'papmi', title: 'papmi', hidden: true},
				   {field: 'patientNo', title: '登记号', width: 100},
				   {field: 'patName', title: '姓名', width: 80},
				   {field: 'bedName', title: '床号', width: 45},
				   {field: 'admDept', title: '就诊科室', width: 100},
				   {field: 'admDate', title: '入院时间', width: 150,
				    formatter: function (value, row, index) {
					   	return value + " " + row.admTime;
					}
				   },
				   {field: 'disDate', title: '出院时间', width: 150,
				   	formatter: function (value, row, index) {
					   	return value + " " + row.disTime;
					}
				   },
				   {field: 'adm', title: '就诊ID', width: 60}
				   ]],
		onBeforeLoad: function (param) {
			param.wardId = getValueById("menu-ward");
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.patientNo = param.q;
			param.episodeId = "";
		},
		onSelect: function (index, row) {
			setTimeout(function () {
				GV.PatTree.reload();
			}, 300);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				GV.PatTree.reload();
			}
		}
	});

	$HUI.combobox("#menu-userDept, #menu-recDept", {
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
	
	$HUI.combobox("#menu-userDeptGrp", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryDeptGrp&ResultSetType=array&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		editable: true,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});

	$HUI.combobox("#menu-tarCate", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryTarIC&ResultSetType=array&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID,
		editable: true,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

function initPatTree() {
	GV.PatTree = $HUI.tree("#pat-menu-tree", {
		fit: true,
		url: $URL + '?ClassName=web.DHCIPBillDailyDtlList&MethodName=GetPatTree&ResultSetType=array',
		checkbox: true,
		lines: true,
		animate: true,
		onBeforeLoad: function (node, param) {
			param.wardId = getValueById("menu-ward");
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.episodeId = getValueById("menu-episodeId");
		},
		onLoadSuccess: function (node, data) {
			var patNum = (data.length > 0) ? data[0].children.length : 0;
			$(".layout:eq(0)").layout("panel", "west").panel({
				title: $g("患者列表 ")+ "(" + patNum + $g("人") + ")"
			});
		}
	});
}

function initDtlList() {
	GV.DtlList = $HUI.datagrid("#dtlList", {
		fit: true,
		border: false,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		toolbar: [],
		frozenColumns: [[{title: '患者姓名', field: 'TPatName', width: 100},
						 {title: '床号', field: 'TBedName', width: 60}
			]],
		className: "web.DHCIPBillDailyDtlList",
		queryName: "FindDailyDtl",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TRegNo", "TMrNo", "TPatName", "TSex", "TAdm", "TBedName"]) != -1) {
					cm.splice(i, 1);
					continue;
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
				}
				if ($.inArray(cm[i].field, ["TCateDesc", "TAmt"]) != -1) {
					cm[i].styler = setCellStyle;
				}
			}
		},
		rowStyler: setRowStyle,
		onLoadSuccess: function (data) {
			var colCont = GV.DtlList.getColumnFields().filter(function(field) {
				return !GV.DtlList.getColumnOption(field).hidden;
			}).length;
			$.each(data.rows, function (index, row) {
				if ($.trim(row.TPatName)) {
					GV.DtlList.mergeCells({
						index: index,
						field: 'TCateDesc',
						colspan: colCont
					});
				}
			});
		}
	});
}

function initCateList() {
	GV.CateList = $HUI.datagrid("#cateList", {
		fit: true,
		border: false,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		toolbar: [],
		frozenColumns: [[{title: '患者姓名', field: 'TPatName', width: 100},
						 {title: '床号', field: 'TBedName', width: 60}
			]],
		className: "web.DHCIPBillDailyDtlList",
		queryName: "FindCateFee",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TRegNo", "TMrNo", "TPatName", "TSex", "TAdm", "TBedName"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				cm[i].styler = setCellStyle;
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		},
		rowStyler: setRowStyle,
		onLoadSuccess: function (data) {
			var colCont = GV.CateList.getColumnFields().filter(function(field) {
				return !GV.CateList.getColumnOption(field).hidden;
			}).length;
			$.each(data.rows, function (index, row) {
				if ($.trim(row.TPatName)) {
					GV.CateList.mergeCells({
						index: index,
						field: 'TCateDesc1',
						colspan: colCont
					});
				}
			});
		}
	});
}

/**
* 修改datagrid 单元格 Style
* @method setCellStyle
* @author ZhYW
*/
function setCellStyle(value, row, index) {
	var cateDesc = row.TCateDesc || row.TCateDesc1;
	if ($.inArray(cateDesc, [$g("小计"), $g("总计")]) != -1) {
		return "font-weight: bold";
	}
}

/**
 * 修改datagrid rowStyle
 * @method setRowStyle
 * @author ZhYW
 */
function setRowStyle(index, row) {
	if ($.trim(row.TPatName)) {
		var bgColor = (HISUIStyleCode == "lite") ? "#339EFF" : "#40a2de";
		return "color:#fff;background-color:" + bgColor + ";";
	}
}

/**
 * 查询按钮点击事件
 * @method findClick
 * @author ZhYW
 */
function findClick() {
	loadDtlList();
	loadCateList();
}

/**
 * 重新加载明细grid
 * @method loadDtlList
 * @author ZhYW
 */
function loadDtlList() {
	var admStr = getTreeChecked();
	var cateId = getValueById("menu-tarCate") || "";
	var userDeptId = getValueById("menu-userDept") || "";
	var userDeptGrpId = getValueById("menu-userDeptGrp") || "";
	var recDeptId = getValueById("menu-recDept") || "";
	var mergeFlag = $("#merge-switch").switchbox("getValue") ? 1 : 0;
	var otherQryStr = cateId + "!" + userDeptId + "!" + userDeptGrpId + "!" + recDeptId + "!" + mergeFlag;
	
	var queryParams = {
		ClassName: "web.DHCIPBillDailyDtlList",
		QueryName: "FindDailyDtl",
		wardId: getValueById("menu-ward"),
		admStr: admStr,
		stDate: getValueById("menu-stDate"),
		stTime: $("#menu-stTime").timespinner("getValue"),
		endDate: getValueById("menu-endDate"),
		endTime: $("#menu-endTime").timespinner("getValue"),
		otherQryStr: otherQryStr
	};
	loadDataGridStore("dtlList", queryParams);
}

/**
 * 重新加载分类汇总grid
 * @method loadCateList
 * @author ZhYW
 */
function loadCateList() {
	var admStr = getTreeChecked();
	var cateId = getValueById("menu-tarCate") || "";
	var userDeptId = getValueById("menu-userDept") || "";
	var userDeptGrpId = getValueById("menu-userDeptGrp") || "";
	var recDeptId = getValueById("menu-recDept") || "";
	var otherQryStr = cateId + "!" + userDeptId + "!" + userDeptGrpId + "!" + recDeptId;
	
	var queryParams = {
		ClassName: "web.DHCIPBillDailyDtlList",
		QueryName: "FindCateFee",
		wardId: getValueById("menu-ward"),
		admStr: admStr,
		stDate: getValueById("menu-stDate"),
		stTime: $("#menu-stTime").timespinner("getValue"),
		endDate: getValueById("menu-endDate"),
		endTime: $("#menu-endTime").timespinner("getValue"),
		otherQryStr: otherQryStr,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("cateList", queryParams);
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} val
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout:eq(1)");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.panel("panel").outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (num > 0) {
		$("tr.display-more-td").show();
	} else {
		$("tr.display-more-td").hide();
	}
	var c = l.layout("panel", "center");
	var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
	c.panel("resize", {
		height: ch,
		top: nh
	});
}

/**
 * 获取选中树的叶子节点Id串
 * @method getTreeChecked
 * @author ZhYW
 */
function getTreeChecked() {
	return GV.PatTree.getChecked().filter(function(node) {
		return GV.PatTree.isLeaf(node.target);
	}).map(function(node) {
		return node.id;
	}).join("!");
}

/**
 * 打印清单和汇总单
 * @method printClick
 * @author ZhYW
 */
function printClick(btnId) {
	var admStr = getTreeChecked();
	var wardId = getValueById("menu-ward");
	var stDate = getValueById("menu-stDate");
	var stTime = $("#menu-stTime").timespinner("getValue");
	var endDate = getValueById("menu-endDate");
	var endTime = $("#menu-endTime").timespinner("getValue");
	var cateId = getValueById("menu-tarCate") || "";
	var userDeptId = getValueById("menu-userDept") || "";
	var userDeptGrpId = getValueById("menu-userDeptGrp") || "";
	var recDeptId = getValueById("menu-recDept") || "";
	var mergeFlag = $("#merge-switch").switchbox("getValue") ? 1 : 0;
	
	var otherQryStr = cateId + "!" + userDeptId + "!" + userDeptGrpId + "!" + recDeptId;
	
	var fileName = "";
	var splitColFlag = $.m({ClassName: "web.DHCBillPageConf", MethodName: "GetPageConfValue", cspName: "dhcbill.ipbill.dailydtllist.csp", code: "DSC", groupId: "", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	switch (btnId) {
	case "menu-prtdtl":
		otherQryStr += "!" + mergeFlag;
		fileName = (splitColFlag == 1) ? "DHCBILL-IPBILL-BQRQMXSL.rpx" : "DHCBILL-IPBILL-BQRQMX.rpx";
		break;
	case "menu-prtcate":
		fileName = "DHCBILL-IPBILL-BQRQFLHZ.rpx";
		break;
	default:
	}
	var params = "&wardId=" + wardId + "&admStr=" + admStr + "&stDate=" + stDate + "&stTime=" + stTime;
	params += "&endDate=" + endDate + "&endTime=" + endTime + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	params += "&otherQryStr=" + otherQryStr;
	
	var pageAdmFlag = $.m({ClassName: "web.DHCBillPageConf", MethodName: "GetPageConfValue", cspName: "dhcbill.ipbill.dailydtllist.csp", code: "PA", groupId: "", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	params += "&pageAdmFlag=" + pageAdmFlag;
	
	fileName += params;
	var maxHeight = $(window).height() * 0.8;
	var maxWidth = $(window).width() * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}