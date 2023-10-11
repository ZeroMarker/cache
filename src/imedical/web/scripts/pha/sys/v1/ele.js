/**
 * ����:	 ҩ������-ϵͳ����-Ԫ������
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 * Update:	 Huxt 2020-02-27
 * pha/sys/v1/ele.js
 */

PHA_COM.App.Csp = "pha.sys.v1.ele.csp";
PHA_COM.App.Name = "SYS.ELE";
$(function () {
	InitDict();
	InitTreeGridEle();
	InitGridEleItm();
	InitEvents();
});

/**
 * @description: ��ʼ���ֵ�
 */
function InitDict() {
	$("#eleItmValType").combobox({
		valueField: 'RowId',
		textField: 'Decription',
		panelHeight: 'auto',
		editable: false,
		width: 207,
		data: [{
				RowId: 'string',
				Decription: 'string'
			}, {
				RowId: 'number',
				Decription: 'number'
			}, {
				RowId: 'boolean',
				Decription: 'boolean'
			}, {
				RowId: 'pointer',
				Decription: 'pointer'
			}, {
				RowId: 'object',
				Decription: 'object'
			}, {
				RowId: 'function',
				Decription: 'function'
			}
		]
	});
	// $('#eleItmActive').next('label').css('margin-left', '-5px');
	// $('#eleItmComFlag').next('label').css('margin-left', '-5px');
}

/**
 * @description: ���α��-Ԫ��
 */
function InitTreeGridEle() {
	var columns = [
		[{
				field: "eleId",
				title: 'eleId',
				width: 100,
				hidden: true
			}, {
				field: "eleDesc",
				title: '����',
				width: 100
			}, {
				field: "eleCode",
				title: '����',
				width: 100
			}, {
				field: '_parentId',
				title: 'parentId',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Ele.Query',
			QueryName: 'PHAINEle'
		},
		idField: 'eleId',
		treeField: 'eleDesc',
		fit: true,
		border: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		fitColumns: true,
		toolbar: "#treegridEleBar",
		onSelect: function (rowIndex, rowData) {
			QueryEleItm();
		},
		onDblClickRow: function (rowIndex, rowData) {
			ShowDiagEle({
				id: "btnEditEle",
				text: $g("�޸�")
			});
		},
		onLoadSuccess: function(data){
			var allData = $(this).treegrid('getData');
			if (!allData || allData.length == 0) {
				return;
			}
			if (!allData[0].children) {
				return;
			}
			var firstChild = allData[0].children[0];
			if (!firstChild) {
				return;
			}
			var eleId = firstChild.eleId;
			if (eleId) {
				$("#treegridEle").treegrid('select', eleId);
			} else {
				$('#gridEleItm').datagrid('clear');
			}
		}
	};
	$HUI.treegrid("#treegridEle", dataGridOption);
}

/**
 * @description: ���-Ԫ������
 */
function InitGridEleItm() {
	var columns = [
		[{
				field: "eleItmId",
				title: 'eleItmId',
				width: 100,
				hidden: true
			}, {
				field: "eleItmCode",
				title: '����',
				width: 150
			}, {
				field: "eleItmDesc",
				title: '����',
				width: 150
			}, {
				field: "eleItmValType",
				title: '����',
				width: 100
			}, {
				field: "eleItmDefVal",
				title: 'Ĭ��ֵ',
				width: 100
			}, {
				field: "eleItmMemo",
				title: '˵��',
				width: 410,
				showTip: true,
				tipWidth: 300,
				tipPosition: 'top'
			}, {
				field: "eleItmActive",
				title: '����',
				align: "center",
				width: 50,
				fixed: true,
				formatter: function (val, rowData, rowIndex) {
					if (val == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}, {
				field: "eleItmComFlag",
				title: 'ͨ������',
				align: "center",
				width: 70,
				fixed: true,
				formatter: function (val, rowData, rowIndex) {
					if (val == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.SYS.Ele.Query',
			QueryName: 'PHAINEleItm'
		},
		fit: true,
		border: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		fitColumns: true,
		onDblClickRow: function (rowIndex, rowData) {
			ShowDiagEleItm({
				id: "btnEditEleItm",
				text: $g("�޸�")
			});
		},
		toolbar: "#gridEleItmBar",
		gridSave: false
	};
	PHA.Grid("gridEleItm", dataGridOption);
}

/**
 * @description: �¼��󶨳�ʼ��
 */
function InitEvents() {
	$("#btnAddEle,#btnEditEle,#btnAddEleSub").on("click", function () {
		ShowDiagEle(this);
	});
	$("#btnDelEle").on("click", DeleteEle);
	$("#btnAddEleItm,#btnEditEleItm").on("click", function () {
		ShowDiagEleItm(this);
	});
	$("#btnDelEleItm").on("click", DeleteEleItm);
	$("#btnHelp").on("click", ShowHelp);
}

/**
 * @description: ��ѯ����
 */
function QueryEleItm() {
	var selRowData = $('#treegridEle').datagrid('getSelected');
	if (selRowData == null) {
		return;
	}
	$("#gridEleItm").datagrid("options").url = $URL;
	$("#gridEleItm").datagrid("query", {
		ClassName: 'PHA.SYS.Ele.Query',
		QueryName: 'PHAINEleItm',
		inputStr: selRowData.eleId || ""
	});
}

/**
 * @description: ��ʾԪ�ر༭����
 */
function ShowDiagEle(btnOpt) {
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var ifSub = (btnOpt.id).indexOf('Sub') >= 0 ? true : false;
	var rowsData = $('#treegridEle').datagrid('getRows');
	var gridSelect = $('#treegridEle').datagrid('getSelected') || "";
	if ((gridSelect == "" && ifSub == true) || (gridSelect == "" && rowsData.length != 0)) {
		PHA.Popover({
			msg: "��ѡ����Ҫ�����Ԫ��!",
			type: "alert"
		});
		return;
	}
	if (ifAdd == false) {
		var eleId = gridSelect.eleId || "";
		if (eleId == "") {
			PHA.Popover({
				msg: "����ѡ����Ҫ�༭��Ԫ��",
				type: "alert"
			});
			return;
		}
	}
	$('#diagEle').dialog({
		modal: true,
		title: "Ԫ��" + btnOpt.text,
		iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
		ifAdd: ifAdd,
		ifSub: ifSub
	}).dialog('open');
	if (ifAdd == false) {
		$("#diagEle_btnAdd").hide();
		$.cm({
			ClassName: 'PHA.SYS.Ele.Query',
			QueryName: 'SelectPHAINEle',
			eleId: gridSelect.eleId,
			ResultSetType: 'Array'
		}, function (arrData) {
			PHA.SetVals(arrData);
		});
	} else {
		var clearValueArr = [
			"eleCode",
			"eleDesc"
		];
		PHA.ClearVals(clearValueArr);
	}
}

/**
 * @description: ����Ԫ��
 * @param {String} type 1(��������)
 */
function SaveEle(type) {
	var diagEleOpts = $("#diagEle").panel('options');
	var ifAdd = diagEleOpts.ifAdd;
	var ifSub = diagEleOpts.ifSub;

	var gridSelect = $('#treegridEle').datagrid('getSelected');
	var eleId = gridSelect == null ? "" : gridSelect.eleId || "";
	var elePar = "";
	if (ifSub == true) {
		elePar = eleId;
	} else {
		elePar = gridSelect == null ? "" : gridSelect._parentId || "";
	}
	if (ifAdd == true) {
		eleId = "";
	}
	var domIdArr = [
		"eleCode",
		"eleDesc"
	];
	var jsonDataArr = PHA.GetVals(domIdArr, "Json");
	if (jsonDataArr.length == 0) {
		return;
	}
	var jsonDataObj = jsonDataArr[0];
	jsonDataObj.elePar = elePar;
	var jsonDataStr = JSON.stringify(jsonDataObj);
	var retStr = $.cm({
		ClassName: 'PHA.SYS.Ele.Save',
		MethodName: 'Save',
		eleId: eleId,
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	var retArr = retStr.split("^");
	var retVal = retArr[0];
	var retInfo = retArr[1];
	if (retVal < 0) {
		PHA.Alert("��ʾ", retInfo, retVal);
		return;
	} else {
		PHA.Popover({
			msg: "����ɹ�!",
			type: "success",
			timeout: 500
		});
	}
	if (type == 1) {
		PHA.ClearVals(domIdArr);
		$("#eleCode").focus();
	} else {
		$('#diagEle').dialog('close');
	}
	$("#treegridEle").treegrid("reload");
}

/**
 * @description: ɾ��Ԫ��
 */
function DeleteEle() {
	var gridSelect = $('#treegridEle').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ��һ������!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	//ɾ��ǰ��֤
	var eleId = gridSelect.eleId || "";
	var chkRet = $.cm({
		ClassName: 'PHA.SYS.Ele.Save',
		MethodName: 'CheckDelete',
		eleId: eleId,
		dataType: 'text',
	}, false);
	var chkArr = chkRet.toString().split("^");
	var delInfo = "�Ƿ�ȷ��ɾ��?"
		if (chkArr[0] < 0) {
			if (chkArr[0] == "-10") {
				PHA.Popover({
					msg: chkArr[1],
					type: "alert",
					timeout: 1000
				});
				return;
			}
			delInfo += "</br>" + chkArr[1];
		}
		//ɾ��ȷ��
		PHA.Confirm("��ܰ��ʾ", delInfo, function () {
		var retStr = $.cm({
			ClassName: 'PHA.SYS.Ele.Save',
			MethodName: 'Delete',
			eleId: eleId,
			dataType: 'text'
		}, false);
		var retArr = retStr.split('^');
		var retVal = retArr[0];
		var retInfo = retArr[1];
		if (retVal < 0) {
			PHA.Alert('��ܰ��ʾ', retInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�!',
				type: 'success'
			});
			$("#treegridEle").treegrid("reload");
		}
	});
}

/**
 * @description: ��ʾԪ�����Ա༭����
 */
function ShowDiagEleItm(btnOpt) {
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var gridSelect = $('#treegridEle').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "��ѡ��Ԫ��!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var gridItmSelect = $('#gridEleItm').datagrid('getSelected') || "";
	if (ifAdd == false && gridItmSelect == "") {
		PHA.Popover({
			msg: "��ѡ��Ԫ������!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	$('#diagEleItm').dialog({
		modal: true,
		title: "Ԫ������" + btnOpt.text,
		iconCls: (btnOpt.id).indexOf("Add") > 0 ? 'icon-w-add' : 'icon-w-edit',
		ifAdd: ifAdd
	})
	$('#diagEleItm').dialog('open');
	if (ifAdd == false) {
		$("#diagEleItm_btnAdd").hide();
		$.cm({
			ClassName: 'PHA.SYS.Ele.Query',
			QueryName: 'SelectPHAINEleItm',
			eleItmId: gridItmSelect.eleItmId || "",
			ResultSetType: 'Array'
		}, function (arrData) {
			PHA.SetVals(arrData);
		});
	} else {
		var clearValueArr = [
			"eleItmCode",
			"eleItmDesc",
			"eleItmValType",
			"eleItmMemo",
			"eleItmActive",
			"eleItmDefVal",
			"eleItmComFlag"
		];
		PHA.ClearVals(clearValueArr);
	}
}

/**
 * @description: ��������
 * @param {String} type 1(��������)
 */
function SaveEleItm(type) {
	var diagEleItmOpts = $("#diagEleItm").panel('options');
	var ifAdd = diagEleItmOpts.ifAdd;
	var gridSelect = $('#treegridEle').datagrid('getSelected') || {};
	var gridItmSelect = $('#gridEleItm').datagrid('getSelected') || {};
	var eleItmId = gridItmSelect.eleItmId || "";
	eleItmId = ifAdd == true ? "" : eleItmId;

	var domIdArr = [
		"eleItmCode",
		"eleItmDesc",
		"eleItmValType",
		"eleItmMemo",
		"eleItmActive",
		"eleItmDefVal",
		"eleItmComFlag"
	];
	var jsonDataArr = PHA.GetVals(domIdArr, "Json");
	if (jsonDataArr.length == 0) {
		return;
	}
	var jsonDataObj = jsonDataArr[0];
	jsonDataObj.eleId = gridSelect.eleId || "";
	var jsonDataStr = JSON.stringify(jsonDataObj);
	var retStr = $.cm({
		ClassName: 'PHA.SYS.Ele.Save',
		MethodName: 'SaveItm',
		eleItmId: eleItmId,
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	var retArr = retStr.split("^");
	var retVal = retArr[0];
	var retInfo = retArr[1];
	if (retVal < 0) {
		PHA.Alert("��ܰ��ʾ", retInfo, retVal);
		return;
	} else {
		PHA.Popover({
			msg: "����ɹ�!",
			type: "success",
			timeout: 500
		});
	}
	if (type == 1) {
		PHA.ClearVals(domIdArr);
		$("#eleItmCode").focus();
	} else {
		$('#diagEleItm').dialog('close');
	}
	$("#gridEleItm").datagrid("reload");
}

/**
 * @description: ��ʾԪ�����Ա༭����
 */
function DeleteEleItm() {
	var gridItmSelect = $('#gridEleItm').datagrid('getSelected');
	if (gridItmSelect == null) {
		PHA.Popover({
			msg: '��ѡ��Ԫ������!',
			type: 'alert'
		});
		return;
	}
	var eleItmId = gridItmSelect.eleItmId || "";

	//ɾ��ȷ��
	PHA.Confirm("��ܰ��ʾ", "�Ƿ�ȷ��ɾ��?", function () {
		var retStr = $.cm({
			ClassName: 'PHA.SYS.Ele.Save',
			MethodName: 'DeleteItm',
			eleItmId: eleItmId,
			dataType: 'text'
		}, false);
		var retArr = retStr.split('^');
		var retVal = retArr[0];
		var retInfo = retArr[1];
		if (retVal < 0) {
			PHA.Alert('��ܰ��ʾ', retInfo, retVal);
			return;
		} else {
			PHA.Popover({
				msg: 'ɾ���ɹ�!',
				type: 'success'
			});
			$("#gridEleItm").datagrid("reload");
		}
	});
}

function ShowHelp(){
	/* �������� */
	var winId = "ele_help_win";
	var winContentId = winId + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 650,
			height: 480,
			modal: true,
			title: 'Ԫ�����԰���',
			iconCls: 'icon-w-list',
			content: "<div id='" + winContentId + "'style='margin:10px;'></div>",
			closable: true
		});
		$('#' + winContentId).html(GetInitHtml());
	}
	$('#' + winId).dialog('open');
	
	/* �������� */
	function GetInitHtml(){
		var helpHtml = '';
		helpHtml += GetItemTitle('����');
		helpHtml += GetItemContent('������hisui���������������һ�¡�');
		helpHtml += GetItemTitle('����');
		helpHtml += GetItemContent('�������������Եĺ��塣');
		helpHtml += GetItemTitle('����');
		helpHtml += GetItemContent('�����ڡ�ҳ�����á���ά������ֵ��ʱ����֤���������ֵ�Ƿ�Ϸ������磺booleanֻ������Y/N��number����ֻ���������֡�');
		helpHtml += GetItemTitle('Ĭ��ֵ');
		helpHtml += GetItemContent('��û��ά����Ӧ����ֵ��ʱ��ȡ��ֵΪĬ��ֵ��');
		helpHtml += GetItemTitle('˵��');
		helpHtml += GetItemContent('�Ը����Ե���ϸ˵���������û��ں�����д����ֵ��ʱ������京������ṩʾ����');
		helpHtml += GetItemTitle('����');
		helpHtml += GetItemContent('���õ�������ϵͳ�в���Ч������ʹά������Ӧ������ֵҲ��Ч��');
		helpHtml += GetItemTitle('ͨ������');
		helpHtml += GetItemContent('��������ϵͳ��ҳ��Ϊ����: (1)CSPҳ�� - ҩ������ĳ��HISUIҳ����ϵͳ�Զ����ɵ�ҳ��,һ��csp����һ��ҳ��; (2)�Զ���ҳ�� - ͨ��ģ���޴������ɵ�ҳ�档��ͨ�����ԡ���ָά������ֵ֮���ڡ�CSPҳ�桱�͡��Զ���ҳ�桱������ʹ�õ����ԣ���ͨ�������򲻿����ڡ�CSPҳ�桱ҳ��ʹ�ã��������ڡ��Զ���ҳ�桱ʹ�á�');
		return helpHtml;
	}
	function GetItemTitle(title){
		return '<div style="margin-top:10px;"><b>' + trans(title) + '��</b></div>';
	}
	function GetItemContent(content){
		return '<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + trans(content) + '</p>';
	}
	function trans(val){
		try {
			return $g(val);
		} catch(ex){
			return val;
		}
	}
}