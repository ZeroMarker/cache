/**
 * ����:	 ҩ��ҩ��-ҩѧ��ҳ-��Ƭʹ����Ȩ
 * ��д��:	 Huxt
 * ��д����: 2020-04-13
 * csp:  	 pha.sys.v1.cardauth.csp
 * js:		 pha/sys/v1/cardauth.js
 */
PHA_COM.App.Csp = "pha.sys.v1.cardauth.csp";
PHA_COM.App.CspDesc = "��Ƭʹ����Ȩ";
PHA_COM.App.ProDesc = "����ҵ��";
PHA_COM.Param.Temp = {
	help_text_1: $g('1. ��Ƭ������Ϣ�����õ���Ȩ��ʽΪ������Ƭ��Ȩ���Ŀ�Ƭ�����ʱ��ȫѡ��Ƭ���������ݡ�'),
	help_text_2: $g('2. ��Ƭ������Ϣ�����õ���Ȩ��ʽΪ����������Ȩ���Ŀ�Ƭ�����ʱֻѡ��ǰ����Ŀ�Ƭ���ݡ�'),
	help_text_3: $g('3. ҽԺΪ��Ȩ��ѡ�'),
	help_text_3_bak: $g('3. ͬһ����Ƭ�ж���������Ȩ�����ȼ����գ��û� > ��ȫ�� > ���� > ͨ�á� ')
}

$(function () {
	InitFormData();
	InitKeyWords();
	InitGridAuth();
	InitTreeCard();

	$('#btnAuth').on("click", Auth);
	$('#btnPreview').on("click", WinPreview);
});

// ��Ԫ��
function InitFormData() {
	PHA.SearchBox("conAuthAlias", {
		searcher: QueryAuth,
		width: 332,
		placeholder: "�������ƴ�����ƻس���ѯ"
	});
	PHA.SearchBox("conCardAlias", {
		searcher: QueryTreeCard,
		width: 332,
		placeholder: "�������ƴ�����ƻس���ѯ"
	});
	PHA.ComboBox("combHosp", {
		url: $URL + "?ResultSetType=array&ClassName=PHA.SYS.Store&QueryName=CTHospital",
		width: 332,
		placeholder: '��ѡ��ҽԺ...',
		onLoadSuccess: function (data) {
			$('#combHosp').combobox('setValue', session['LOGON.HOSPID']);
			QueryAuth();
		},
		onSelect: function () {
			QueryTreeCard();
		}
	});
}

// Ȩ�޹ؼ���(��Ϊ��ѯ����)
function InitKeyWords() {
	$("#kwAuthType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [{
				text: '�û�',
				id: 'U'
			}, {
				text: '��ȫ��',
				id: 'G',
				selected: true
			}, {
				text: '����',
				id: 'L'
			}, {
				text: 'ͨ��',
				id: 'A'
			}
		],
		onClick: QueryAuth
	});

	$("#kwAuthStat").keywords({
		singleSelect: false,
		labelCls: 'red',
		items: [{
				text: 'δ��',
				id: 'N',
				selected: true
			}, {
				text: '����',
				id: 'Y',
				selected: true
			}
		],
		onClick: QueryAuth
	});
}

// ��ʼ��Ȩ���б�
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
				title: 'Ȩ��Id',
				hidden: true,
				width: 100
			}, {
				field: "authCode",
				title: '����',
				width: 125
			}, {
				field: "authDesc",
				title: '����',
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

// ��Ƭ������
function InitTreeCard() {
	PHA.Tree("treeCard", {
		mode: 'remote',
		fit: true,
		checkbox: true,
		lines: true,
		autoNodeHeight: false,
		url: '',
		onCheck: function (node, checked) {
			// ��������Ȩ�Ĳ���
			if (node.cardAuthType != "Card") {
				return;
			}
			// ����Ƭ��Ȩ��ȫѡ
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
			// Ԥ����Ƭ
			ShowCardPreview(node.code);
		},
		onLoadSuccess: function () {
			var fitWidth = $('#treeCard').parent().css('width');
			$('#treeCard').children().eq(0).css('width', parseInt(fitWidth) - 22);
		}
	});
}

// ��ѯ������Ȩ�б�
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

// ��ѯ - ��Ƭ���б�
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

// ��Ȩ
function Auth() {
	var hospId = $("#combHosp").combobox('getValue');
	var authType = $("#kwAuthType").keywords("getSelected")[0].id || "";
	var authSelected = $("#gridAuth").datagrid('getSelected') || {};
	var authPointer = authSelected.authId || "";
	var authPointerStr = '';
	/*
	// ��ʱ��Ҫ��ѡ Huxt 2021-11-22
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
	authPointerStr = authPointer; // ��ѡ

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
			msg: "��ѡ��ҽԺ!",
			type: "alert"
		});
		return;
	}
	if (authType == "") {
		PHA.Popover({
			msg: "��ѡ�������Ȩ����!",
			type: "alert"
		});
		return;
	}
	if (authType != "A" && authPointerStr == "") {
		PHA.Popover({
			msg: "��ѡ�������Ȩ����ֵ!",
			type: "alert"
		});
		return;
	}
	authPointer = authType == "A" ? 0 : authPointer;
	var authStr = hospId + "^" + authType + "^" + authPointer;

	// �����Ȩ
	if (piciStr == "") {
		$.messager.confirm("��ʾ", "δ��ѡ��Ȩ����,</br>�Ƿ���ո�Ȩ�������е���Ȩ����?", function (r) {
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

	// ������Ȩ
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

// Ԥ������
function WinPreview() {
	// ��֤
	var selNode = $('#treeCard').tree('getSelected');
	if (!selNode) {
		PHA.Popover({
			msg: "���ȵ��ѡ�п�Ƭ��",
			type: "alert"
		});
		return;
	}
	if (!selNode.children) {
		PHA.Popover({
			msg: "���ݲ�֧��Ԥ������ѡ��Ƭ��",
			type: "alert"
		});
		return;
	}
	var picCode = selNode.code || '';
	if (!selNode.children) {
		PHA.Popover({
			msg: "�޷���ȡ��Ƭ���룡",
			type: "alert"
		});
		return;
	}
	// ����
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
			title: '��ƬԤ��',
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

// Ԥ������
function ShowCardPreview(picCode) {
	// Ԥ������
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
			msg: "��ѡ��ҽԺ!",
			type: "alert"
		});
		return false;
	}
	if (authType == "") {
		PHA.Popover({
			msg: "��ѡ����Ȩ����!",
			type: "alert"
		});
		return false;
	}
	if (authType != "A" && authPointer == "") {
		PHA.Popover({
			msg: "��ѡ����Ȩ����ֵ!",
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
	// ��ʼԤ��
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

// ��ʾ��ʾ����
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
			title: '��Ƭ��Ȩʹ�ð���',
			iconCls: 'icon-w-list',
			content: helpHtmlStr,
			closable: true
		});
	}
	$('#winHelpTips').dialog('open');
}
