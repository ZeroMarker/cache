/**
 * ��Ŀ�޶����  dhcpe.arcimpremanager.js
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
var arcimTree;
//����ģʽ   Ĭ�ϲ�ѯ
var _Model = "S";

//��ǰ�ܶ�Ӧ�����ڼ���  ����һ����ĩ
var _WeekDataArr = null;

// �б༭����
var _EditRowArr = [];

// ����ɫ����
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
						$.messager.confirm("��ʾ", $g("����δ����ļ�¼,�Ƿ񱣴棿"), function(r) {
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
 * [������]
 * @param    {[String]}    arcimDesc [ҽ��������]
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
			//��ֹ������Ĳ˵���
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
 * [�����ӽڵ�]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function addNode_click() {
	var node = $('#ArcimTree').tree('getSelected');
	if (node == null) {
		$.messager.popover({
			type: "info",
			msg: $g("����ѡ��ڵ�")
		});
		return false;
	}
	//���ô����ֶ�
	clean_node_win(); //�����
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
		case "A": //ҽ����ڵ�  ���ӽڵ�
			$.messager.popover({
				msg: $g("ҽ����ڵ㲻������ӽڵ�"),
				type: "info"
			});
			break;
		default: //���ڵ���Զ���ڵ�
			initkeywords("");
			$("#node-type-key").keywords("select", "slefCategory");
			$("#EditNodeWin").window("open");
			break;
	}
}
/**
 * [�ؼ��ֵ���¼�]
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
 * �ڵ�༭��������
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
 * [���½ڵ�]
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
		$.messager.alert("��ʾ", $g("���벻��Ϊ��"), "info");
		return false;
	}
	if (nodeDesc == "") {
		$.messager.alert("��ʾ", $g("���Ʋ���Ϊ��"), "info");
		return false;
	}
	if (nodeType == "") {
		$.messager.alert("��ʾ", $g("�ڵ����Ͳ���Ϊ��"), "info");
		return false;
	}
	if (nodeType == "S" && sourceId != "") {
		$.messager.alert("��ʾ", $g("�Զ������ͣ�ҽ��ID��Ϊ�գ�"), "info");
		return false;
	}
	if (nodeType == "A" && sourceId == "") {
		$.messager.alert("��ʾ", $g("ҽ��ID��Ϊ�գ�"), "info");
		return false;
	}
	if (maxAge != "" && minAge != "" && parseInt(minAge) > parseInt(maxAge)) {
		$.messager.alert("��ʾ", $g("���䷶Χ����"), "info");
		return false;
	}
	var char0 = String.fromCharCode(0);
	var userId = session["LOGON.USERID"];
	//APTCode^APTDesc^APTParentNode^APTType^APTSourceDR^APTRemark^APTUpdateUserDR$C(0)APCSexDR^APCMinAge^APCMaxAge^APCVIPLevel^APCUpdateUserDR
	var valStr = nodeCode + "^" + nodeDesc + "^" + parentId + "^" + nodeType + "^" + sourceId + "^" + nodeRemark + "^" + userId;
	valStr = valStr + char0 + sexId + "^" + minAge + "^" + maxAge + "^" + vipLevel + "^" + userId;
	var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "UpdateTreeNode", nodeId, valStr);
	if (ret != "0") {
		$.messager.alert("��ʾ", $g("����ʧ�ܣ�") + ret.split("^")[1], "error");
		return false;
	} else {
		$.messager.popover({
			msg: $g("���³ɹ�"),
			type: "success"
		});
		$("#EditNodeWin").window("close");
		loadTree("");
		initDataGrid();
	}
}
/**
 * [ɾ���ڵ�]
 * @Author   wangguoying
 * @DateTime 2020-03-20
 */
function delNode_click() {
	var node = $('#ArcimTree').tree('getSelected');
	if (node == null) {
		$.messager.alert("��ʾ", $g("����ѡ��ڵ�"), "info");
		return false;
	}
	if (node.id == "root") {
		$.messager.alert("��ʾ", $g("���ڵ㲻����ɾ��"), "info");
		return false;
	}
	$.messager.confirm("ɾ��", $g("ɾ���ڵ��ͬ��ɾ�������ú�Դ��ȷ��ɾ����"), function(r) {
		if (r) {
			var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "DelTreeNode", node.id);
			if (ret.split("^")[0] != "0") {
				$.messager.alert("��ʾ", $g("ɾ��ʧ�ܣ�") + ret.split("^")[1], "info");
				return false;
			} else {
				$.messager.popover({
					msg: $g("ɾ���ɹ�"),
					type: "success"
				});
				loadTree("");
				initDataGrid();
			}
		}
	});
}

/**
 * [�༭�ڵ�]
 * @return   {[type]}    [description]
 * @Author   wangguoying
 * @DateTime 2020-03-20
 */
function editNode_click() {

	var node = $('#ArcimTree').tree('getSelected');
	if (node == null) {
		$.messager.alert("��ʾ", $g("����ѡ��ڵ�"), "info");
		return false;
	}
	if (node.id == "root") {
		$.messager.alert("��ʾ", $g("���ڵ㲻����ɾ��"), "info");
		return false;
	}
	var parentNode = $('#ArcimTree').tree('getParent', node.target);
	var parentId = parentNode.id;
	if (parentId == "root") parentId = "";
	//���ô����ֶ�
	clean_node_win(); //�����
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
 * [��ʼ���ؼ���]
 * @param    {[String]}    type [�ڵ�����]
 * @Author   wangguoying
 * @DateTime 2020-03-23
 */
function initkeywords(type) {
	var items = type == "S" ?
		[{
			text: '�Զ������',
			id: 'slefCategory',
			type: 'S'
		}] :
		type == "A" ?
		[{
			text: 'ҽ����',
			id: 'arcimType',
			type: 'A'
		}] :
		[{
			text: '�Զ������',
			id: 'slefCategory',
			type: 'S'
		}, {
			text: 'ҽ����',
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
 * [��ʼ��ҽ����]
 * @param    {[string]}    arcimId [ҽ��IOD]
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
				title: 'ҽ������',
				width: 200
			}, {
				field: 'STORD_ARCIM_Code',
				title: 'ҽ������',
				width: 150
			}, ]
		],
		fitColumns: true,
		pagination: true,
		pageSize: 20
	});
}


/**
 * [��ʼ�������б�]
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
 * [��������ť�ɷ�༭]
 * @param    {[object]}    node [���ڵ�]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function setTreeBtnDisabled(node) {
	var nodeType = node.type;
	switch (nodeType) {
		case "S": //�Զ���ڵ�
			$('#AddNode').linkbutton('enable');
			$('#DeleteNode').linkbutton('enable');
			$('#EditNode').linkbutton('enable');
			$("#right-menu").menu("enableItem", $('#appendTNode')[0]);
			$("#right-menu").menu("enableItem", $('#delTNode')[0]);
			$("#right-menu").menu("enableItem", $('#editTNode')[0]);
			break;
		case "A": //ҽ����ڵ�  ���ӽڵ�
			$('#AddNode').linkbutton('disable');
			$('#DeleteNode').linkbutton('enable');
			$('#EditNode').linkbutton('enable');
			$("#right-menu").menu("disableItem", $('#appendTNode')[0]);
			$("#right-menu").menu("enableItem", $('#delTNode')[0]);
			$("#right-menu").menu("enableItem", $('#editTNode')[0]);
			break;
		default: //���ڵ�
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
 * [ȫѡ�ڵ�]
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
 * [����ѡ�еĽڵ�]
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
 * [��ʼ�����]
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
		title: '��Ŀ'
	}, {
		title: $g('��һ')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[0] + '��</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('�ܶ�')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[1] + '��</label>',
		align: "centere",
		colspan: 3
	}, {
		title: $g('����')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[2] + '��</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('����')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[3] + '��</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('����')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[4] + '��</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('����')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[5] + '��</label>',
		align: "center",
		colspan: 3
	}, {
		title: $g('����')+'<label style="color:red;font-weight:bolder">��' + _WeekDataArr[6] + '��</label>',
		align: "center",
		colspan: 3
	}];
	var thead2 = [];
	for (let i = 1; i <= 7; i++) {
		var num = i == 7 ? 0 : i;
		thead2.push({
			field: 'NUM_M_' + num,
			width: 60,
			title: '�޶�',
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
			title: '��Լ',
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
			title: 'ʣ��',
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
				//���ÿ���ק
				init_cell_draggable();
			}
		},
		columns: columns,
		fit: true
	});
	_EditRowArr = [];
}

/**
 * [�鿴ԤԼ��ϸ  ������չ]
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
			title: $g('ԤԼ����'),
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
 * [���ÿ���ק  �ɷ���]
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
 * [���Ƶ�Ԫ���޶�]
 * @param    {[HTMLElement]}    source [Դ��Ԫ��]
 * @param    {[HTMLElement]}    target [Ŀ�굥Ԫ��]
 * @param    {[Obejct]}    		DragObj [�϶��������]
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
			msg: $g("���Ƴɹ�"),
			type: "success"
		});
		initDataGrid();
	} else {
		$.messager.alert("��ʾ", $g("����ʧ�ܣ�") + ret.split("^")[1], "error");
	}
}

/**
 * [��ȡѡ�еĽڵ�]
 * @return   {[String]}    [�ڵ�ID^�ڵ�ID����]
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
 * [���ܸ���]
 * @param    {[int]}    type [���ͣ�-1���������ܣ�1�����Ƶ���һ�� 0������������]
 * @Author   wangguoying
 * @DateTime 2021-09-29
 */
function copy_week(type) {
	var ids = get_check_nodeIds();
	if (ids == 0) {
		$.messager.popover({
			msg: $g("��ѡ����Ҫ���ƵĽڵ�"),
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
 * [���ú�̨���Ʒ���]
 * @param    {[String]}    ids        [ѡ�еĽڵ�ID����]
 * @param    {[String]}    sourceDate [ԭ����]
 * @param    {[String]}    beginDate  [Ŀ�꿪ʼ����]
 * @param    {[String]}    endDate    [Ŀ���������]
 * @return   {[Boolean]}              [�ɹ����]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function invoke_copy(ids, sourceDate, beginDate, endDate) {
	var ret = tkMakeServerCall("web.DHCPE.ArcimPreManager", "CopyByWeek", ids, sourceDate, beginDate, endDate, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
	if (parseInt(ret) == 0) {
		$.messager.popover({
			msg: $g("���Ƴɹ�"),
			type: "success"
		});
	} else {
		$.messager.alert("��ʾ", $g("����ʧ�ܣ�") + ret.split("^")[1], "error");
		return false;
	}
	return true;
}

/**
 * [����������]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function copy_advance() {
	var ids = get_check_nodeIds();
	if (ids == 0) {
		$.messager.popover({
			msg: $g("��ѡ����Ҫ���ƵĽڵ�"),
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
 * [���ڸ��ư�ť����¼�]
 * @param    {[int]}    type [1�����츴��  2�����ܸ���]
 * @return   {[Boolean]}         [���Ƴɹ����]
 * @Author   wangguoying
 * @DateTime 2021-09-30
 */
function copy_advance_handeler(type) {
	var ids = get_check_nodeIds();
	if (ids == 0) {
		$.messager.popover({
			msg: $g("��ѡ����Ҫ���ƵĽڵ�"),
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
				msg: $g("ԭ������Ŀ�����ڲ���Ϊ��"),
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
				msg: $g("ԭ������Ŀ�����ڲ���Ϊ��"),
				type: "info"
			});
			return false;
		}
	}
	var ret = invoke_copy(ids, sdate, tbdate, tedate);
	return ret;
}

/**
 * [�������ƴ�������]
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
 * [���õ�ǰ����]
 * @param    {[int]}    type [0����ǰ��  -1����һ��  1����һ��]
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
 * [���� �� ����]
 * @param    {[String]}    date [����]
 * @param    {[int]}       days [���ӵ�����]
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
	}, false); //ͬ������ȡϵͳ�������ڸ�ʽ
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
 * [���ڸ�ʽ��]
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
 * [�����޶�]
 * @Author   wangguoying
 * @DateTime 2021-09-28
 */
function save_manager() {
	if (_EditRowArr.length == 0) {
		$.messager.popover({
			msg: $g("û����Ҫ���������"),
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
					//����
					var n = $($(el).find("td[field='NUM_M_" + i + "'] .datagrid-editable-input")).val();
					if ($.trim(n) == "") continue;
					//����
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
			msg: $g("����ɹ�"),
			type: "success"
		});
		initDataGrid();
	} else {
		$.messager.alert("��ʾ", $g("����ʧ�ܣ�") + ret.split("^")[1], "error");
		return false;
	}
	return true;
}

function setRightToolbar(code){
	$(".grid-toobar-right").css("display",code == 1 ? "block" : "none");
}

/**
 * [���ý��沼��]
 * @Author   wangguoying
 * @DateTime 2020-03-17
 */
function setLayout() {
	$(".panel-header.panel-header-gray").css("border-radius", "4px 4px 0 0"); //�巽Բ��
	$('#Content').layout('collapse', 'east');
}
$(init);