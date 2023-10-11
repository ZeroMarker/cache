/**
 * 项目限额管理  dhcpe.arcimpremanager.js
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
var arcimTree;
//界面模式   默认查询
var _Model = "S";

//当前周对应的日期集合  从周一到周末
var _WeekDataArr = null;

// 行编辑集合
var _EditRowArr = [];

// 背景色对象
var _BgColor = {
	empty: "#f7e8e8",
	fulfil: "#ff7070",
	avail: "#4ffbc3"
}



function init() {
	setLayout();
	loadTree("");
	initcombobox();
	$("#Win_BCopy").click(function() {
		copy_advance_handeler(1);
	});
	$("#Win_BWeekCopy").click(function() {
		copy_advance_handeler(2);
	});
	setTimeout(function() {
		$('#CurDate').datebox('setValue', getDefStDate(0));
		$HUI.radio("input[name='Model']", {
			onCheckChange: function(e, value) {
				if (!value) return false;
				_Model = e.currentTarget.value;
				if (_Model != "E") {
					if (_EditRowArr > 0) {
						$.messager.confirm("提示", $g("存在未保存的记录,是否保存？"), function(r) {
							if (r) {
								if (!save_manager()) {
									$HUI.radio("#Model_E").setValue(true);
								};
							} else {
								$HUI.radio("#Model_E").setValue(true);
							}
						});
					}
					$("#BSave").linkbutton("disable");
					if (_Model == "C") {
						init_cell_draggable();
					} else {
						$('.datagrid-body [class*="datagrid-cell-c"][class*="-NUM_M_"]').parent().draggable('disable');
					}
				} else {
					$("#BSave").linkbutton("enable");
					$('.datagrid-body [class*="datagrid-cell-c"][class*="-NUM_M_"]').parent().draggable('disable');
				}
			}
		});
	}, 100);
}



/**
 * [加载树]
 * @param    {[String]}    arcimDesc [医嘱项描述]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function loadTree(arcimDesc) {
	arcimTree = $HUI.tree("#ArcimTree", {
		url: $URL + "?ClassName=web.DHCPE.ArcimPreManager&MethodName=GetArcimTree&ARCIMDesc=" + arcimDesc + "&ResultSetType=array",
		lines: true,
		onClick: function(node) {
			setTreeBtnDisabled(node);
		},
		onContextMenu: function(e, node) {
			e.preventDefault();
			//禁止浏览器的菜单打开
			$(this).tree('select', node.target);
			setTreeBtnDisabled(node);
			$('#right-menu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	});
}

/**
 * [新增子节点]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function addNode_click() {
	var node = $('#ArcimTree').tree('getSelected');
	if (node == null) {
		$.messager.popover({
			type: "info",
			msg: $g("请先选择节点")
		});
		return false;
	}
	//设置窗口字段
	clean_node_win(); //先清空
	var id = node.id;
	if (id == "root") id = "";
	$("#win_parentId").val(id);
	if (node.id != "root") {
		if (node.condition && node.condition.sexId != "") {
			$("#win-node-sex").combobox("setValue", node.condition.sexId);
			$("#win-node-sex").combobox("disable");
		}
		if (node.condition && node.condition.vipLevel != "") {
			$("#win-node-vip").combobox("setValue", node.condition.vipLevel);
			$("#win-node-vip").combobox("disable");
		}
		if (node.condition && node.condition.minAge != "") {
			$("#win-node-minage").val(node.condition.minAge);
		}
		if (node.condition && node.condition.maxAge != "") {
			$("#win-node-maxage").val(node.condition.maxAge);
		}
	}
	switch (node.type) {
		case "A": //医嘱项节点  无子节点
			$.messager.popover({
				msg: $g("医嘱项节点不能填加子节点"),
				type: "info"
			});
			break;
		default: //根节点或自定义节点
			initkeywords("");
			$("#node-type-key").keywords("select", "slefCategory");
			$("#EditNodeWin").window("open");
			break;
	}
}
/**
 * [关键字点击事件]
 * @param    {[object]}    item [description]
 * @Author   wangguoying
 * @DateTime 2020-03-18
 */
function key_click(item) {
	var id = $("#win_nodeId").val();
	var itemType = item.type;
	$('#win_nodeType').val(itemType);
	switch (itemType) {
		case "S":
			$("#win-node-desc").css("display", "block");
			$("#win-node-arcim").next(".combo").hide();
			break;
		case "A":
			$("#win-node-desc").css("display", "none");
			$("#win-node-arcim").next(".combo").show();
			initArcimDatagrid($("#win-node-arcimId").val());
			break;
	}
}

/**
 * 节点编辑窗口清屏
 * @Author   wangguoying
 * @DateTime 2020-03-19
 */
function clean_node_win() {
	$("#win_parentId").val("");
	$("#win_nodeId").val("");
	$("#win-node-code").val("");
	$("#win-node-desc").val("");
	$("#win-node-remark").val("");
	$('#win_nodeType').val("");
	$('#win-node-arcim').combogrid("setValue", "");
	$("#win-node-sex").combobox("setValue", "");
	$("#win-node-vip").combobox("setValue", "");
	$("#win-node-minage").val("");
	$("#win-node-maxage").val("");
	$('#win-node-arcim').combogrid("enable");
	$("#win-node-sex").combobox("enable");
	$("#win-node-vip").combobox("enable");
}

/**
 * [更新节点]
 * @Author   wangguoying
 * @DateTime 2020-03-18
 */
function save_node() {
	var parentId = $("#win_parentId").val();
	if (parentId == "root") parentId = "";
	var nodeId = $("#win_nodeId").val();
	var nodeCode = $("#win-node-code").val();
	var nodeDesc = $("#win-node-desc").val();
	var nodeRemark = $("#win-node-remark").val();
	var nodeType = $('#win_nodeType').val();
	var sourceId = $('#win-node-arcim').combogrid("getValue");
	if (sourceId == "undefind") sourceId = "";
	var sexId = $("#win-node-sex").combobox("getValue");
	var vipLevel = $("#win-node-vip").combobox("getValue");
	var minAge = $("#win-node-minage").val();
	var maxAge = $("#win-node-maxage").val();
	
	if(!$("#win-node-code").validatebox("isValid")){
		$("#win-node-code").focus();
		return false;
	}
	
	if (nodeCode == "") {
		$.messager.alert("提示", $g("代码不能为空"), "info");
		return false;
	}
	if (nodeDesc == "") {
		$.messager.alert("提示", $g("名称不能为空"), "info");
		return false;
	}
	if (nodeType == "") {
		$.messager.alert("提示", $g("节点类型不能为空"), "info");
		return false;
	}
	if (nodeType == "S" && sourceId != "") {
		$.messager.alert("提示", $g("自定义类型，医嘱ID不为空！"), "info");
		return false;
	}
	if (nodeType == "A" && sourceId == "") {
		$.messager.alert("提示", $g("医嘱ID不为空！"), "info");
		return false;
	}
	if (maxAge != "" && minAge != "" && parseInt(minAge) > parseInt(maxAge)) {
		$.messager.alert("提示", $g("年龄范围有误"), "info");
		return false;
	}
	var char0 = String.fromCharCode(0);
	var userId = session["LOGON.USERID"];
	//APTCode^APTDesc^APTParentNode^APTType^APTSourceDR^APTRemark^APTUpdateUserDR$C(0)APCSexDR^APCMinAge^APCMaxAge^APCVIPLevel^APCUpdateUserDR
	var valStr = nodeCode + "^" + nodeDesc + "^" + parentId + "^" + nodeType + "^" + sourceId + "^" + nodeRemark + "^" + userId;
	valStr = valStr + char0 + sexId + "^" + minAge + "^" + maxAge + "^" + vipLevel + "^" + userId;
	var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "UpdateTreeNode", nodeId, valStr);
	if (ret != "0") {
		$.messager.alert("提示", $g("更新失败：") + ret.split("^")[1], "error");
		return false;
	} else {
		$.messager.popover({
			msg: $g("更新成功"),
			type: "success"
		});
		$("#EditNodeWin").window("close");
		loadTree("");
		initDataGrid();
	}
}
/**
 * [删除节点]
 * @Author   wangguoying
 * @DateTime 2020-03-20
 */
function delNode_click() {
	var node = $('#ArcimTree').tree('getSelected');
	if (node == null) {
		$.messager.alert("提示", $g("请先选择节点"), "info");
		return false;
	}
	if (node.id == "root") {
		$.messager.alert("提示", $g("根节点不允许删除"), "info");
		return false;
	}
	$.messager.confirm("删除", $g("删除节点会同步删除已设置号源，确定删除吗？"), function(r) {
		if (r) {
			var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "DelTreeNode", node.id);
			if (ret.split("^")[0] != "0") {
				$.messager.alert("提示", $g("删除失败：") + ret.split("^")[1], "info");
				return false;
			} else {
				$.messager.popover({
					msg: $g("删除成功"),
					type: "success"
				});
				loadTree("");
				initDataGrid();
			}
		}
	});
}

/**
 * [编辑节点]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-03-20
 */
function editNode_click() {

	var node = $('#ArcimTree').tree('getSelected');
	if (node == null) {
		$.messager.alert("提示", $g("请先选择节点"), "info");
		return false;
	}
	if (node.id == "root") {
		$.messager.alert("提示", $g("根节点不允许删除"), "info");
		return false;
	}
	var parentNode = $('#ArcimTree').tree('getParent', node.target);
	var parentId = parentNode.id;
	if (parentId == "root") parentId = "";
	//设置窗口字段
	clean_node_win(); //先清空
	$("#win_parentId").val(parentId);
	if (node.condition && node.condition.sexId != "") {
		$("#win-node-sex").combobox("setValue", node.condition.sexId);
		if (parentId != "" && parentNode.condition && parentNode.condition.sexId != "") $("#win-node-sex").combobox("disable");
	}
	if (node.condition && node.condition.vipLevel != "") {
		$("#win-node-vip").combobox("setValue", node.condition.vipLevel);
		if (parentId != "" &&  parentNode.condition && parentNode.condition.vipLevel != "") $("#win-node-vip").combobox("disable");
	}
	if (node.condition && node.condition.minAge != "") {
		$("#win-node-minage").val(node.condition.minAge);
	}
	if (node.condition && node.condition.maxAge != "") {
		$("#win-node-maxage").val(node.condition.maxAge);
	}
	$("#win-node-code").val(node.code);
	$("#win-node-desc").val(node.desc);
	$("#win_nodeId").val(node.id);
	$("#win_nodeType").val(node.type);
	initkeywords(node.type);
	if (node.type == "S") {
		$("#node-type-key").keywords("select", "slefCategory");
	} else {
		$("#node-type-key").keywords("select", "arcimType");
		initArcimDatagrid(node.sourceId);
		$('#win-node-arcim').combogrid("setValue", node.sourceId);
		$('#win-node-arcim').combogrid("disable");
	}
	$("#EditNodeWin").window("open");
}

function cancel_node() {
	$("#EditNodeWin").window("close");
}

/**
 * [初始化关键字]
 * @param    {[String]}    type [节点类型]
 * @Author   wangguoying
 * @DateTime 2020-03-23
 */
function initkeywords(type) {
	var items = type == "S" ?
		[{
			text: '自定义分类',
			id: 'slefCategory',
			type: 'S'
		}] :
		type == "A" ?
		[{
			text: '医嘱项',
			id: 'arcimType',
			type: 'A'
		}] :
		[{
			text: '自定义分类',
			id: 'slefCategory',
			type: 'S'
		}, {
			text: '医嘱项',
			id: 'arcimType',
			type: 'A'
		}];
	var keywords = $HUI.keywords("#node-type-key", {
		singleSelect: true,
		items: items,
		onClick: function(item) {
			key_click(item);
		}
	})
}

/**
 * [初始化医嘱项]
 * @param    {[string]}    arcimId [医嘱IOD]
 * @return   {[type]}            [description]
 * @Author   wangguoying
 * @DateTime 2020-03-18
 */
function initArcimDatagrid(arcimId) {
	var ArcimObj = $HUI.combogrid("#win-node-arcim", {
		panelWidth: 450,
		url: $URL + "?ClassName=web.DHCPE.StationOrder&QueryName=StationOrderList&LocID="+session["LOGON.CTLOCID"]+"&hospId="+session["LOGON.HOSPID"],
		mode: 'remote',
		delay: 200,
		idField: 'STORD_ARCIM_DR',
		textField: 'STORD_ARCIM_Desc',
		onBeforeLoad: function(param) {
			param.Item = param.q;
			param.ItemID = arcimId;
		},
		onSelect: function(rowIndex, rowData) {
			$("#win-node-desc").val(rowData.STORD_ARCIM_Desc);
		},
		columns: [
			[{
				field: 'STORD_ARCIM_DR',
				title: 'ID',
				width: 80
			}, {
				field: 'STORD_ARCIM_Desc',
				title: '医嘱名称',
				width: 200
			}, {
				field: 'STORD_ARCIM_Code',
				title: '医嘱编码',
				width: 150
			}, ]
		],
		fitColumns: true,
		pagination: true,
		pageSize: 20
	});
}


/**
 * [初始化下拉列表]
 * @Author   wangguoying
 * @DateTime 2020-03-18
 */
function initcombobox() {
	var sexObj = $HUI.combobox("#win-node-sex", {
		url: $URL + "?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField: 'id',
		textField: 'sex'
	});
	var VIPObj = $HUI.combobox("#win-node-vip", {
		url: $URL + "?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session["LOGON.CTLOCID"],
		valueField: 'id',
		textField: 'desc'
	});
}

/**
 * [设置树按钮可否编辑]
 * @param    {[object]}    node [树节点]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function setTreeBtnDisabled(node) {
	var nodeType = node.type;
	switch (nodeType) {
		case "S": //自定义节点
			$('#AddNode').linkbutton('enable');
			$('#DeleteNode').linkbutton('enable');
			$('#EditNode').linkbutton('enable');
			$("#right-menu").menu("enableItem", $('#appendTNode')[0]);
			$("#right-menu").menu("enableItem", $('#delTNode')[0]);
			$("#right-menu").menu("enableItem", $('#editTNode')[0]);
			break;
		case "A": //医嘱项节点  无子节点
			$('#AddNode').linkbutton('disable');
			$('#DeleteNode').linkbutton('enable');
			$('#EditNode').linkbutton('enable');
			$("#right-menu").menu("disableItem", $('#appendTNode')[0]);
			$("#right-menu").menu("enableItem", $('#delTNode')[0]);
			$("#right-menu").menu("enableItem", $('#editTNode')[0]);
			break;
		default: //根节点
			$('#AddNode').linkbutton('enable');
			$('#DeleteNode').linkbutton('disable');
			$('#EditNode').linkbutton('disable');
			$("#right-menu").menu("enableItem", $('#appendTNode')[0]);
			$("#right-menu").menu("disableItem", $('#delTNode')[0]);
			$("#right-menu").menu("disableItem", $('#editTNode')[0]);
			break;
	}
}



function find_click(value, name) {
	value = encodeURI(value);
	loadTree(value);
}

/**
 * [全选节点]
 * @Author   wangguoying
 * @DateTime 2021-09-29
 */
function select_all_node() {
	var rows = $("#PreManagerList").treegrid("getRows");
	rows.forEach(function(element, index) {
		$("#PreManagerList").treegrid("checkNode", element.TID);
	});
}
/**
 * [撤销选中的节点]
 * @Author   wangguoying
 * @DateTime 2021-09-29
 */
function unselect_all_node() {
	var nodes = $("#PreManagerList").treegrid("getCheckedNodes");
	nodes.forEach(function(element, index) {
		$("#PreManagerList").treegrid("uncheckNode", element.TID);
	});
}



/**
 * [初始化表格]
 * @Author   wangguoying
 * @DateTime 2021-07-21
 */
function initDataGrid(arcim) {
	arcim = arcim == undefined ? $("#SearchDescBtn").searchbox("getValue") : arcim;
	var dateStr = tkMakeServerCall("web.DHCPE.SetsPreTemplate", "GetWeekDateRange", $("#CurDate").datebox("getValue"));
	_WeekDataArr = dateStr.split("^");
	var thead = [{
		field: 'TID',
		hidden: true
	}, {
		field: 'TNode',
		rowspan: 2,
		width: 300,
		title: '项目'
	}, {
		title: $g('周一')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[0] + '）</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('周二')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[1] + '）</label>',
		align: "centere",
		colspan: 3
	}, {
		title: $g('周三')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[2] + '）</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('周四')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[3] + '）</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('周五')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[4] + '）</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('周六')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[5] + '）</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('周日')+'<label style="color:red;font-weight:bolder">（' + _WeekDataArr[6] + '）</label>',
		align: "center",
		colspan: 3
	}];
	var thead2 = [];
	for (let i = 1; i <= 7; i++) {
		var num = i == 7 ? 0 : i;
		thead2.push({
			field: 'NUM_M_' + num,
			width: 60,
			title: '限额',
			align: "center",
			editor: {
				type: "numberbox",
				options: {
					min: 0
				}
			},
			styler: function(value, row, index) {
				return value != "" ? "" : "background-color:" + _BgColor.empty + ";";
			}
		});
		thead2.push({
			field: 'NUM_P_' + num,
			width: 60,
			title: '已约',
			align: "center",
			formatter: function(value, row, index) {
				if (parseInt(value) > 0) {
					return "<a href='#' onClick='pre_detail(" + row.TID + ",\"" + _WeekDataArr[i-1] + "\")'>" + value + "</a>";
				}
				return value;
			}
		});
		thead2.push({
			field: 'NUM_A_' + num,
			width: 60,
			title: '剩余',
			align: "center",
			styler: function(value, row, index) {
				return value != "" ?
					(
						parseInt(value) > 0 ? "background-color:" + _BgColor.avail + ";" :
						"background-color:" + _BgColor.fulfil + ";"
					) :
					"background-color:" + _BgColor.empty + ";";
			}
		});
	}

	var columns = [];
	columns.push(thead);
	columns.push(thead2);
	$HUI.treegrid("#PreManagerList", {
		idField: 'TID',
		treeField: 'TNode',
		rownumbers: true,
		checkbox: true,
		toolbar: "#tb",
		url: $URL,
		queryParams: {
			ClassName: "web.DHCPE.ArcimPreManager",
			QueryName: "SerchPreManagerNum",
			Date: $("#CurDate").datebox("getValue"),
			ArcimDesc: arcim,
			LocID: session["LOGON.CTLOCID"]
		},
		onClickCell: function(field, row) {},
		onDblClickRow: function(id, row) {
			var model = $("input[name='Model']:checked").val();
			if (model == "E") {
				if (_EditRowArr.indexOf(id) == -1) {
					$("#PreManagerList").treegrid("beginEdit", id);
					_EditRowArr.push(id);
				}
			}
		},
		onLoadSuccess: function(data) {
			if (_Model == "C") {
				//设置可拖拽
				init_cell_draggable();
			}
		},
		columns: columns,
		fit: true
	});
	_EditRowArr = [];
}

/**
 * [查看预约明细  后期拓展]
 * @param    {[type]}    id   [description]
 * @param    {[type]}    date [description]
 * @return   {[type]}         [description]
 * @Author   wangguoying
 * @DateTime 2021-09-28
 */
function pre_detail(id, date) {
	if (_Model == "S") {
		var lnk = "dhcpe.arcimpredetail.csp?NodeID=" + id + "&LocID=" + session["LOGON.CTLOCID"] + "&DateStr=" + date;
		$('#PreDetailDialog').dialog({
			title: $g('预约详情'),
			iconCls: "icon-book",
			width: 1100,
			height: 600,
			cache: false,
			content: "<iframe src='" + PEURLAddToken(lnk) + "' style='width:100%;height:100%;border:0'></iframe> ",
			modal: true
		});
	}
}

/**
 * [设置可拖拽  可放置]
 * @Author   wangguoying
 * @DateTime 2021-09-17
 */
function init_cell_draggable() {
	var DragObj = {
		revert: true,
		disabled: false,
		proxy: function(source) {
			var p = $('<div style="border:1px solid #ccc"></div>');
			p.html($(source).html()).appendTo('body');
			return p;
		}
	};
	$('.datagrid-body [class*="datagrid-cell-c"][class*="-NUM_M_"]').parent().each(function() {
		$(this).draggable(DragObj);
		$(this).droppable({
			onDrop: function(e, source) {
				copy_cell(source, this, DragObj);
			}
		});

	});
}


/**
 * [复制单元格限额]
 * @param    {[HTMLElement]}    source [源单元格]
 * @param    {[HTMLElement]}    target [目标单元格]
 * @param    {[Obejct]}    		DragObj [拖动代理对象]
 * @Author   wangguoying
 * @DateTime 2021-09-18
 */
function copy_cell(source, target, DragObj) {
	var className = $(source).children()[0].className;
	var num = $(source).find('[class*="datagrid-cell-c"][class*="-NUM_M_"]').text();
	var tid = $(target).parent().find('[field="TID"]').text();
	var field = $(target).attr("field");
	var weekNum = parseInt(field.split("_")[2]);
	weekNum = weekNum == 0 ? 6 : weekNum - 1;
	var date = _WeekDataArr[weekNum];
	var info = tid + ":" + date + "," + num;
	var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "SavePreManager", info, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
	if (parseInt(ret) == 0) {
		$.messager.popover({
			msg: $g("复制成功"),
			type: "success"
		});
		initDataGrid();
	} else {
		$.messager.alert("提示", $g("复制失败：") + ret.split("^")[1], "error");
	}
}

/**
 * [获取选中的节点]
 * @return   {[String]}    [节点ID^节点ID……]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function get_check_nodeIds() {
	var nodes = $("#PreManagerList").treegrid("getCheckedNodes");
	var ids = "";
	nodes.forEach(function(element, index) {
		ids = ids == "" ? element.TID : ids + "^" + element.TID;
	});
	return ids;
}


/**
 * [按周复制]
 * @param    {[int]}    type [类型：-1：沿用上周，1：复制到下一周 0：按条件复制]
 * @Author   wangguoying
 * @DateTime 2021-09-29
 */
function copy_week(type) {
	var ids = get_check_nodeIds();
	if (ids == 0) {
		$.messager.popover({
			msg: $g("请选择需要复制的节点"),
			type: "info"
		});
		return false;
	}
	var date = $("#CurDate").datebox("getValue");
	var ret = 0;
	switch (type) {
		case -1:
			var sourceDate = addDate(date, -7);
			var beginDate = _WeekDataArr[0]
			var endDate = _WeekDataArr[6];
			break;
		case 1:
			var sourceDate = date;
			var targetDate = addDate(date, 7);
			var dateRange = tkMakeServerCall("web.DHCPE.SetsPreTemplate", "GetWeekDateRange", targetDate);
			var beginDate = dateRange.split("^")[0]
			var endDate = dateRange.split("^")[6];
			break;
		default:
			break;
	}
	var ret = invoke_copy(ids, sourceDate, beginDate, endDate);
	if (ret) {
		if (type == -1) initDataGrid();
	}
}


/**
 * [调用后台复制方法]
 * @param    {[String]}    ids        [选中的节点ID集合]
 * @param    {[String]}    sourceDate [原日期]
 * @param    {[String]}    beginDate  [目标开始日期]
 * @param    {[String]}    endDate    [目标结束日期]
 * @return   {[Boolean]}              [成功标记]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function invoke_copy(ids, sourceDate, beginDate, endDate) {
	var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "CopyByWeek", ids, sourceDate, beginDate, endDate, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
	if (parseInt(ret) == 0) {
		$.messager.popover({
			msg: $g("复制成功"),
			type: "success"
		});
	} else {
		$.messager.alert("提示", $g("复制失败：") + ret.split("^")[1], "error");
		return false;
	}
	return true;
}

/**
 * [按条件复制]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function copy_advance() {
	var ids = get_check_nodeIds();
	if (ids == 0) {
		$.messager.popover({
			msg: $g("请选择需要复制的节点"),
			type: "info"
		});
		return false;
	}
	copy_win_clean();
	$("#SDate").datebox({
		minDate: _WeekDataArr[0],
		maxDate: _WeekDataArr[6]
	});
	$("#W_SDate").datebox("setValue", $("#CurDate").datebox("getValue"));
	$("#AdvanceCopyWin").dialog("open");
}

/**
 * [窗口复制按钮点击事件]
 * @param    {[int]}    type [1：按天复制  2：按周复制]
 * @return   {[Boolean]}         [复制成功标记]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function copy_advance_handeler(type) {
	var ids = get_check_nodeIds();
	if (ids == 0) {
		$.messager.popover({
			msg: $g("请选择需要复制的节点"),
			type: "info"
		});
		return false;
	}
	if (type == 1) {
		var sdate = $("#SDate").datebox("getValue");
		var tbdate = $("#TDate").datebox("getValue");
		var tedate = tbdate;
		if (sdate == "" || tbdate == "") {
			$.messager.popover({
				msg: $g("原日期与目标日期不能为空"),
				type: "info"
			});
			return false;
		}
	} else {
		var sdate = $("#W_SDate").datebox("getValue");
		var tbdate = $("#W_TBDate").datebox("getValue");
		var tedate = $("#W_TEDate").datebox("getValue");
		if (sdate == "" || tbdate == "" || tedate == "") {
			$.messager.popover({
				msg: $g("原日期与目标日期不能为空"),
				type: "info"
			});
			return false;
		}
	}
	var ret = invoke_copy(ids, sdate, tbdate, tedate);
	return ret;
}

/**
 * [条件复制窗口清屏]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function copy_win_clean() {
	$("#SDate").datebox("setValue", "");
	$("#TDate").datebox("setValue", "");
	$("#W_SDate").datebox("setValue", "");
	$("#W_TBDate").datebox("setValue", "");
	$("#W_TEDate").datebox("setValue", "");
}

/**
 * [设置当前日期]
 * @param    {[int]}    type [0：当前周  -1：上一周  1：下一周]
 * @Author   wangguoying
 * @DateTime 2021-07-21
 */
function setDate(type) {
	var date = $("#CurDate").datebox("getValue");
	switch (type) {
		case -1:
			date = addDate(date, -7);
			break;
		case 1:
			date = addDate(date, 7);
			break;
		default:
			date = getDefStDate(0)
			break;
	}
	$("#CurDate").datebox("setValue", date);
}


/**
 * [日期 加 天数]
 * @param    {[String]}    date [日期]
 * @param    {[int]}       days [增加的天数]
 * @Author   wangguoying
 * @DateTime 2021-07-21
 */
function addDate(date, days) {
	if (days == undefined || days == '') {
		days = 7;
	}
	var date = new Date(date);
	// var dateArr = date.split("/");
	// var date = new Date(parseInt(dateArr[2]),parseInt(dateArr[1])-1,parseInt(dateArr[0]));


	date.setDate(date.getDate() + days);
	var month = date.getMonth() + 1;
	var day = date.getDate();

	var dateStr = "";
	var sysDateFormat = $.m({
		ClassName: "websys.Conversions",
		MethodName: "DateFormat"
	}, false); //同步调用取系统配置日期格式
	if (sysDateFormat == 1) {
		dateStr = getFormatDate(month) + '/' + getFormatDate(day) + '/' + date.getFullYear();
	} else if (sysDateFormat == 3) {
		dateStr = date.getFullYear() + '-' + getFormatDate(month) + '-' + getFormatDate(day);
	} else {
		dateStr = getFormatDate(day) + '/' + getFormatDate(month) + '/' + date.getFullYear();
	}
	return dateStr;
}

/**
 * [日期格式化]
 * @Author   wangguoying
 * @DateTime 2021-07-21
 */
function getFormatDate(arg) {
	if (arg == undefined || arg == '') {
		return '';
	}
	var re = arg + '';
	if (re.length < 2) {
		re = '0' + re;
	}
	return re;
}

/**
 * [保存限额]
 * @Author   wangguoying
 * @DateTime 2021-09-28
 */
function save_manager() {
	if (_EditRowArr.length == 0) {
		$.messager.popover({
			msg: $g("没有需要保存的数据"),
			type: "info"
		});
		return false;
	}
	var info = "";
	var splitChar = String.fromCharCode(0);
	_EditRowArr.forEach(function(element, index) {
		var row = $("#PreManagerList").treegrid("getRowDom", {
			id: element
		});
		var rowStr = "";
		row.each(function(index, el) {
			if (el.children.length > 1) {
				for (var i = 0; i < 7; i++) {
					//数量
					var n = $($(el).find("td[field='NUM_M_" + i + "'] .datagrid-editable-input")).val();
					if ($.trim(n) == "") continue;
					//日期
					var d = i == 0 ? _WeekDataArr[6] : _WeekDataArr[i - 1];
					rowStr = rowStr == "" ? d + "," + n : rowStr + "^" + d + "," + n;
				}
			}
		});
		rowStr = element + ":" + rowStr;
		info = info == "" ? rowStr : info + splitChar + rowStr;
	});
	var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "SavePreManager", info, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
	if (parseInt(ret) == 0) {
		$.messager.popover({
			msg: $g("保存成功"),
			type: "success"
		});
		initDataGrid();
	} else {
		$.messager.alert("提示", $g("保存失败：") + ret.split("^")[1], "error");
		return false;
	}
	return true;
}

function setRightToolbar(code){
	$(".grid-toobar-right").css("display",code == 1 ? "block" : "none");
}

/**
 * [设置界面布局]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function setLayout() {
	$(".panel-header.panel-header-gray").css("border-radius", "4px 4px 0 0"); //五方圆角
	$('#Content').layout('collapse', 'east');
}
$(init);