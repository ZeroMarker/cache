/**
 * 名称:	 药房药库-药学首页-卡片使用授权
 * 编写人:	 Huxt
 * 编写日期: 2020-04-13
 * csp:  	 pha.sys.v1.cardauth.csp
 * js:		 pha/sys/v1/cardauth.js
 */
PHA_COM.App.Csp = "pha.sys.v1.cardauth.csp";
PHA_COM.App.CspDesc = "卡片使用授权";
PHA_COM.App.ProDesc = "公共业务";
PHA_COM.Param.Temp = {
	help_text_1: $g('1. 卡片附加信息中配置的授权方式为“按卡片授权”的卡片，点击时会全选卡片的所有内容。'),
	help_text_2: $g('2. 卡片附加信息中配置的授权方式为“按内容授权”的卡片，点击时只选择当前点击的卡片内容。'),
	help_text_3: $g('3. 医院为授权必选项。'),
	help_text_3_bak: $g('3. 同一个卡片有多个级别的授权，优先级按照：用户 > 安全组 > 科室 > 通用。 ')
}

$(function () {
	InitFormData();
	InitKeyWords();
	InitGridAuth();
	InitTreeCard();

	$('#btnAuth').on("click", Auth);
	$('#btnPreview').on("click", WinPreview);
});

// 表单元素
function InitFormData() {
	PHA.SearchBox("conAuthAlias", {
		searcher: QueryAuth,
		width: 332,
		placeholder: "请输入简拼或名称回车查询"
	});
	PHA.SearchBox("conCardAlias", {
		searcher: QueryTreeCard,
		width: 332,
		placeholder: "请输入简拼或名称回车查询"
	});
	PHA.ComboBox("combHosp", {
		url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=CTHospital",
		width: 332,
		placeholder: '请选择医院...',
		onLoadSuccess: function (data) {
			$('#combHosp').combobox('setValue', session['LOGON.HOSPID']);
			QueryAuth();
		},
		onSelect: function () {
			QueryTreeCard();
		}
	});
}

// 权限关键字(作为查询条件)
function InitKeyWords() {
	$("#kwAuthType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [{
				text: '用户',
				id: 'U'
			}, {
				text: '安全组',
				id: 'G',
				selected: true
			}, {
				text: '科室',
				id: 'L'
			}, {
				text: '通用',
				id: 'A'
			}
		],
		onClick: QueryAuth
	});

	$("#kwAuthStat").keywords({
		singleSelect: false,
		labelCls: 'red',
		items: [{
				text: '未授',
				id: 'N',
				selected: true
			}, {
				text: '已授',
				id: 'Y',
				selected: true
			}
		],
		onClick: QueryAuth
	});
}

// 初始化权限列表
function InitGridAuth() {
	var columns = [
		[
			/*{
				field: 'TSelected',
				title: 'TSelected',
				checkbox: true
			},*/
			{
				field: "authId",
				title: '权限Id',
				hidden: true,
				width: 100
			}, {
				field: "authCode",
				title: '代码',
				width: 125
			}, {
				field: "authDesc",
				title: '名称',
				width: 150
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.CardAuth.Query',
			QueryName: 'GridAuth'
		},
		singleSelect: true,
		//selectOnCheck: false,
		displayMsg: "",
		pagination: true,
		columns: columns,
		fitColumns: true,
		onClickRow: function (rowIndex, rowData) {
			QueryTreeCard();
		},
		onLoadSuccess: function (data) {
			$(this).datagrid('unselectAll');
			QueryTreeCard();
		},
		toolbar: "#gridAuthBar"
	};
	PHA.Grid("gridAuth", dataGridOption);
}

// 卡片内容树
function InitTreeCard() {
	PHA.Tree("treeCard", {
		mode: 'remote',
		fit: true,
		checkbox: true,
		lines: true,
		autoNodeHeight: false,
		url: '',
		onCheck: function (node, checked) {
			// 按内容授权的不管
			if (node.cardAuthType != "Card") {
				return;
			}
			// 按卡片授权的全选
			var parent = $(this).tree('getParent', node.target);
			if (checked) {
				if (!node.children) {
					$(this).tree('check', parent.target);
					var allCheckedNodes = $(this).tree('getChecked');
					for (var i = 0; i < allCheckedNodes.length; i++) {
						var tempNode = allCheckedNodes[i];
						if (tempNode.children) {
							if (tempNode.id != parent.id) {
								// $(this).tree('uncheck', tempNode.target);
							}
						}
					}
				} else {
					var allCheckedNodes = $(this).tree('getChecked');
					for (var i = 0; i < allCheckedNodes.length; i++) {
						var tempNode = allCheckedNodes[i];
						if (tempNode.children) {
							if (tempNode.id != node.id) {
								// $(this).tree('uncheck', tempNode.target);
							}
						}
					}
				}
			} else {
				if (!node.children) {
					$(this).tree('uncheck', parent.target);
				}
			}
		},
		onClick: function (node) {
			return;
			if (node.checked) {
				$('#treeCard').tree('uncheck', node.target);
			} else {
				$('#treeCard').tree('check', node.target);
			}
			// 预览卡片
			ShowCardPreview(node.code);
		},
		onLoadSuccess: function () {
			var fitWidth = $('#treeCard').parent().css('width');
			$('#treeCard').children().eq(0).css('width', parseInt(fitWidth) - 22);
		}
	});
}

// 查询授类型权列表
function QueryAuth() {
	var hospId = $("#combHosp").combobox('getValue');
	var authType = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var stateStr = "";
	var stateArr = $("#kwAuthStat").keywords('getSelected');
	for (var i = 0; i < stateArr.length; i++) {
		stateStr = stateStr == "" ? stateArr[i].id : stateStr + ',' + stateArr[i].id;
	}
	var authAlias = $("#conAuthAlias").searchbox("getValue") || "";
	var inputStr = hospId + "^" + authType + "^" + stateStr + "^" + authAlias;
	
	$("#gridAuth").datagrid("options").url = $URL;
	$("#gridAuth").datagrid("query", {
		inputStr: inputStr
	});
}

// 查询 - 卡片树列表
function QueryTreeCard() {
	var hospId = $("#combHosp").combobox('getValue');
	var authType = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var authSelected = $("#gridAuth").datagrid('getSelected') || {};
	var authPointer = authSelected.authId || "";
	authPointer = authType == "A" ? 0 : authPointer;
	var cardAlias = $("#conCardAlias").searchbox("getValue") || "";
	var inputStr = hospId + "^" + authType + "^" + authPointer + "^" + cardAlias;

	$("#treeCard").tree("options").url = PHA.GetUrl({
		ClassName: 'PHA.SYS.CardAuth.Query',
		MethodName: 'QueryCardTree',
		inputStr: inputStr
	});
	$("#treeCard").tree("reload");
}

// 授权
function Auth() {
	var hospId = $("#combHosp").combobox('getValue');
	var authType = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var authSelected = $("#gridAuth").datagrid('getSelected') || {};
	var authPointer = authSelected.authId || "";
	var authPointerStr = '';
	/*
	// 暂时不要多选 Huxt 2021-11-22
	var checkedData = $("#gridAuth").datagrid('getChecked') || [];
	for (var i = 0; i < checkedData.length; i++) {
		var authId = checkedData[i]['authId'];
		if (authPointerStr == "") {
			authPointerStr = authId;
		} else {
			authPointerStr = authPointerStr + "^" + authId;
		}
	}
	*/
	authPointerStr = authPointer; // 单选

	var piciStr = "";
	var nodeArr = $('#treeCard').tree('getChecked');
	var nodeLen = nodeArr.length;
	for (var i = 0; i < nodeLen; i++) {
		var oneNode = nodeArr[i];
		var nId = oneNode.id;
		if (nId.indexOf('||') < 0) {
			continue;
		}
		if (piciStr == "") {
			piciStr = nId;
		} else {
			piciStr = piciStr + "^" + nId;
		}
	}
	if (hospId == "") {
		PHA.Popover({
			msg: "请选择医院!",
			type: "alert"
		});
		return;
	}
	if (authType == "") {
		PHA.Popover({
			msg: "请选左侧择授权类型!",
			type: "alert"
		});
		return;
	}
	if (authType != "A" && authPointerStr == "") {
		PHA.Popover({
			msg: "请选择左侧授权类型值!",
			type: "alert"
		});
		return;
	}
	authPointer = authType == "A" ? 0 : authPointer;
	var authStr = hospId + "^" + authType + "^" + authPointer;

	// 清空授权
	if (piciStr == "") {
		$.messager.confirm("提示", "未勾选授权内容,</br>是否清空该权限下所有的授权内容?", function (r) {
			if (!r) {
				return;
			}
			var retStr = $.cm({
				ClassName: 'PHA.SYS.CardAuth.Save',
				MethodName: 'AuthMulti',
				authStr: authStr,
				piciStr: piciStr,
				authPointerStr: authPointerStr,
				dataType: 'text'
			}, false);
			PHA.AfterRunServer(retStr, function () {
				QueryAuth();
				QueryTreeCard();
			});
		});
		return;
	}

	// 正常授权
	var retStr = $.cm({
		ClassName: 'PHA.SYS.CardAuth.Save',
		MethodName: 'AuthMulti',
		authStr: authStr,
		piciStr: piciStr,
		authPointerStr: authPointerStr,
		dataType: 'text'
	}, false);
	PHA.AfterRunServer(retStr, QueryTreeCard);
}

// 预览弹窗
function WinPreview() {
	// 验证
	var selNode = $('#treeCard').tree('getSelected');
	if (!selNode) {
		PHA.Popover({
			msg: "请先点击选中卡片！",
			type: "alert"
		});
		return;
	}
	if (!selNode.children) {
		PHA.Popover({
			msg: "内容不支持预览，请选择卡片！",
			type: "alert"
		});
		return;
	}
	var picCode = selNode.code || '';
	if (!selNode.children) {
		PHA.Popover({
			msg: "无法获取卡片代码！",
			type: "alert"
		});
		return;
	}
	// 弹窗
	var winId = 'Win_CardPreview';
	if ($("#" + winId).length == 0) {
		var contentStr = "";
		contentStr += '<div class="hisui-panel" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true">';
		contentStr += '		<div id="panel-cardItm" style="width:100%;height:100%;"></div>';
		contentStr += '</div>';
		$('<div id="' + winId + '"><div>').appendTo('body');
		$('#' + winId).dialog({
			width: parseInt($(window).width() * 0.9),
			height: parseInt($(window).height() * 0.9),
			modal: true,
			title: '卡片预览',
			iconCls: 'icon-w-find',
			content: contentStr,
			closable: true
		});
	}
	if(ShowCardPreview(picCode) == false) {
		$('#' + winId).dialog('close');
		return;
	}
	$('#' + winId).dialog('open');
}

// 预览界面
function ShowCardPreview(picCode) {
	// 预览参数
	var hospId = $("#combHosp").combobox('getValue');
	var authType = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var authSelected = $("#gridAuth").datagrid('getSelected') || {};
	var authPointer = authSelected.authId || "";
	var checkedData = $("#gridAuth").datagrid('getChecked') || [];
	for (var i = 0; i < checkedData.length; i++) {
		var authId = checkedData[i]['authId'];
		authPointer = authId;
		break;
	}

	if (hospId == "") {
		PHA.Popover({
			msg: "请选择医院!",
			type: "alert"
		});
		return false;
	}
	if (authType == "") {
		PHA.Popover({
			msg: "请选择授权类型!",
			type: "alert"
		});
		return false;
	}
	if (authType != "A" && authPointer == "") {
		PHA.Popover({
			msg: "请选择授权类型值!",
			type: "alert"
		});
		return false;
	}
	authPointer = authType == "A" ? 0 : authPointer;
	var authStr = hospId + "^" + "" + "^" + "" + "^" + "";
	if (authType == 'U') {
		authStr = hospId + "^" + authPointer + "^" + "" + "^" + "";
	}
	if (authType == 'G') {
		authStr = hospId + "^" + "" + "^" + authPointer + "^" + "";
	}
	if (authType == 'L') {
		authStr = hospId + "^" + "" + "^" + "" + "^" + authPointer;
	}
	// 开始预览
	var renderToId = "panel-cardItm";
	var _options = {}
	_options.renderToId = renderToId;
	_options.authStr = authStr;
	_options.picCode = picCode;
	CardPreview('cardContentPreview', _options);
	return true;
}

function HideCardPreview() {
	CardPreview('cardContentPreview', 'hide');
}

// 显示提示弹窗
function ShowHelpTips() {
	if ($('#winHelpTips').length == 0) {
		var helpHtmlStr = '';
		helpHtmlStr += '<div style="margin:10px;">';
		helpHtmlStr += '<p style="line-height:28.5px">' + PHA_COM.Param.Temp['help_text_1'] + '</p>';
		helpHtmlStr += '<p style="line-height:28.5px">' + PHA_COM.Param.Temp['help_text_2'] + '</p>';
		helpHtmlStr += '<p style="line-height:28.5px">' + PHA_COM.Param.Temp['help_text_3'] + '</p>';
		helpHtmlStr += '</div>';

		$('<div id="winHelpTips"></div>').appendTo('body');
		$('#winHelpTips').dialog({
			width: 420,
			height: 300,
			modal: true,
			title: '卡片授权使用帮助',
			iconCls: 'icon-w-list',
			content: helpHtmlStr,
			closable: true
		});
	}
	$('#winHelpTips').dialog('open');
}
