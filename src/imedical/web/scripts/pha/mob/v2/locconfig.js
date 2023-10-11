/**
 * ģ��:     �ƶ�ҩ������
 * ��д����: 2020-20-20
 * ��д��:   Huxt
 * scripts/pha/mob/v2/locconfig.js
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
	InitDict();
	InitGridConfig();
	$('#btnAdd').on("click", function () {
		OpenMainTainWin("A");
	});
	$('#btnUpdate').on("click", function () {
		OpenMainTainWin("U");
	});
	$('#btnDelete').on("click", DeleteConfig);
	$('#btnReload').on("click", function () {
		$('#gridConfig').datagrid("reload");
	});
});

// ��ʼ������
function InitDict() {
	$HUI.checkbox("#presChkFlag", {
		checked: true
	});
	$HUI.checkbox("#patRepFlag", {
		checked: false
	});
	$HUI.checkbox("#printPresFlag", {
		checked: false
	});
	$HUI.checkbox("#callFlag", {
		checked: false
	});
	$HUI.checkbox("#screenFlag", {
		checked: false
	});
	$HUI.checkbox("#presAllSendFlag", {
		checked: false
	});
	$HUI.checkbox("#presAgreeRetFlag", {
		checked: false
	});
	$HUI.checkbox("#PHCFPrintDispSheet", {
		checked: false
	});

	PHA.ComboBox('locId', {
		placeholder: 'ҩ������...',
		url: $URL + "?ClassName=PHA.STORE.Org&QueryName=CTLoc&ResultSetType=array&TypeStr=D&HospId=" + session['LOGON.HOSPID'],
		onBeforeLoad: function (param) {
			param.QText = param.q;
		},
		onLoadSuccess: function () {
			var comOpts = $("#locId").combobox("options");
			var hasSettedDefault = comOpts.hasSettedDefault;
			if (hasSettedDefault) {
				return;
			}
			var datas = $("#locId").combobox("getData");
			for (var i = 0; i < datas.length; i++) {
				if (datas[i].RowId == SessionLoc) {
					$("#locId").combobox("select", datas[i].RowId);
					break;
				}
			}
			comOpts.hasSettedDefault = true;
		}
	});

	PHA.ComboBox('presTypeId', {
		placeholder: '�䷽����...',
		url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=PresType&ResultSetType=array",
		editable: false,
		panelHeight: 'auto',
		onLoadSuccess: function () {
			var comOpts = $("#cmbPresType").combobox("options");
			comOpts.defaultData = null;
			var datas = $("#cmbPresType").combobox("getData");
			for (var i = 0; i < datas.length; i++) {
				if (datas[i].typeDefaul == 'Y') {
					comOpts.defaultData = datas[i]; // ����Ĭ��ֵ,����������ʱ����
					break;
				}
			}
		}
	});

	PHA.ComboBox('printLabSelect', {
		placeholder: '��ӡ�÷���ǩ...',
		editable: true,
		panelHeight: 'auto',
		data: [{
				"RowId": "0",
				"Description": "����ӡ��ǩ"
			}, {
				"RowId": "1",
				"Description": "������ɺ��ӡ��ǩ"
			}, {
				"RowId": "2",
				"Description": "������ӡ��ǩ"
			}
		]
	});
	
	PHA.ComboBox('patAdmType', {
		placeholder: '���߾�������...',
		editable: true,
		panelHeight: 'auto',
		data: [{
				"RowId": "O",
				"Description": "����"
			}, {
				"RowId": "E",
				"Description": "����"
			}, {
				"RowId": "I",
				"Description": "סԺ"
			}
		]
	});

	PHA.ComboBox('presChkSel', {
		placeholder: '��ʱ��...',
		editable: true,
		panelHeight: 'auto',
		data: [{
				"RowId": "1",
				"Description": "���շѺ���"
			}, {
				"RowId": "2",
				"Description": "���󷽺��շ�"
			}
		]
	});
}

// ���
function InitGridConfig() {
	var columns = [
		[{
				field: "phcf",
				title: 'phcf',
				hidden: true
			}, {
				field: "locId",
				title: 'ҩ��Id',
				hidden: true
			}, {
				field: 'locDesc',
				title: 'ҩ������',
				width: 180,
				sortable: 'true'
			}, {
				field: 'patAdmTypeCode',
				title: '���߾�������Code',
				hidden: true
			}, {
				field: 'patAdmType',
				title: '���߾�������',
				width: 100,
				sortable: 'true'
			}, {
				field: "presTypeId",
				title: '�䷽����Id',
				hidden: true
			}, {
				field: 'presTypeDesc',
				title: '�䷽����',
				width: 120,
				sortable: 'true'
			}, {
				field: 'printLabSelect',
				title: '��ӡ�÷���ǩId',
				width: 120,
				sortable: 'true',
				hidden: true
			}, {
				field: 'printLabSelectDesc',
				title: '��ӡ�÷���ǩ',
				width: 140,
				sortable: 'true'
			}, {
				field: 'presChkSel',
				title: '��ʱ��Id',
				width: 120,
				sortable: 'true',
				hidden: true
			}, {
				field: 'presChkSelDesc',
				title: '��ʱ��',
				width: 120,
				sortable: 'true',
				hidden: true
			}, {
				field: 'presChkFlag',
				title: '�Ƿ���Ҫ��',
				width: 100,
				sortable: 'true',
				align: 'center',
				formatter: FormatterYes,
				hidden: true
			}, {
				field: 'patRepFlag',
				title: '�Ƿ��軼�߱���',
				width: 120,
				align: 'center',
				formatter: FormatterYes
			}, {
				field: 'printPresFlag',
				title: '�Ƿ��ӡ��ҩ��',
				width: 120,
				sortable: 'true',
				align: 'center',
				formatter: FormatterYes
			}, {
				field: 'callFlag',
				title: '�Ƿ�к�',
				align: 'center',
				width: 90,
				formatter: FormatterYes
			}, {
				field: 'screenFlag',
				title: '�Ƿ�����',
				align: 'center',
				width: 90,
				sortable: 'true',
				formatter: FormatterYes
			}, {
				field: 'presAllSendFlag',
				title: '�Ƿ��ҩ��ȫ��',
				align: 'center',
				width: 120,
				sortable: 'true',
				formatter: FormatterYes
			}, {
				field: 'presAgreeRetFlag',
				title: '�Ƿ�������ҩ',
				align: 'center',
				width: 100,
				sortable: 'true',
				formatter: FormatterYes
			}, {
				field: 'printDispSheet',
				title: '�Ƿ��ӡ������',
				align: 'center',
				width: 120,
				sortable: 'true',
				formatter: FormatterYes,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.LocCfg.Query',
			QueryName: 'LocConfig',
			pJsonStr: JSON.stringify({
				hospId: session['LOGON.HOSPID']
			})
		},
		columns: columns,
		toolbar: "#gridConfigBar",
		onDblClickRow: function (rowIndex) {
			OpenMainTainWin("U");
		}
	};
	PHA.Grid("gridConfig", dataGridOption);
}

// ����
function SaveConfig() {
	var winTitle = $("#gridConfigWin").panel('options').title;
	
	// ���ڱ�����
	var formDataArr = PHA.DomData("#win-form", {
		doType: 'save',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.presChkFlag = formData.presChkFlag ? "Y" : "N";
	formData.patRepFlag = formData.patRepFlag ? "Y" : "N";
	formData.printPresFlag = formData.printPresFlag ? "Y" : "N";
	formData.callFlag = formData.callFlag ? "Y" : "N";
	formData.screenFlag = formData.screenFlag ? "Y" : "N";
	formData.presAllSendFlag = formData.presAllSendFlag ? "Y" : "N";
	formData.presAgreeRetFlag = formData.presAgreeRetFlag ? "Y" : "N";
	formData.printDispSheet = formData.printDispSheet ? "Y" : "N";
	
	// ��֤
	if (formData.presChkFlag == "Y" && formData.presChkSel == "") {
		$.messager.popover({
			msg: "��ѡ����ʱ�̣�",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	if (formData.presChkFlag == "N") {
		formData.presChkSel = "";
	}
	
	// ��ȡID
	var phcf = "";
	if (winTitle.indexOf("����") >= 0) {
	} else {
		var gridSelect = $('#gridConfig').datagrid('getSelected');
		phcf = gridSelect.phcf;
	}
	
	// ����
	var pJsonStr = JSON.stringify(formData);
	var saveRet = tkMakeServerCall("PHA.MOB.LocCfg.Save", "Save", phcf, pJsonStr);
	var saveArr = saveRet.split("^");
	var saveValue = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveValue < 0) {
		$.messager.alert("��ʾ", saveInfo, (saveValue == "-1") ? "warning" : "error");
		return;
	}
	$('#gridConfigWin').window('close');
	$('#gridConfig').datagrid("reload");
	$.messager.popover({
		msg: "����ɹ�!",
		type: "success",
		timeout: 1000
	});
}

// ɾ��
function DeleteConfig() {
	var gridSelect = $('#gridConfig').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "��ѡ����Ҫɾ���ļ�¼!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
		if (r) {
			var phcf = gridSelect.phcf || "";
			if (phcf == "") {
				var rowIndex = $('#gridConfig').datagrid('getRowIndex', gridSelect);
				$('#gridConfig').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.LocCfg.Save", "Delete", phcf);
				var delRetArr = delRet.split('^');
				if (delRetArr[0] < 0) {
					$.messager.alert("��ʾ", saveInfo, (saveValue == "-1") ? "warning" : "error");
					return;
				}
				$.messager.popover({
					msg: "ɾ���ɹ�!",
					type: "success",
					timeout: 1000
				});
				$('#gridConfig').datagrid("reload");
			}
		}
	})
}

// ��ʽ��
function FormatterYes(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// �򿪴���
function OpenMainTainWin(type) {
	var gridSelect = $('#gridConfig').datagrid('getSelected');
	if (type == "U") {
		if (gridSelect == null) {
			$.messager.popover({
				msg: "����ѡ����Ҫ�޸ĵļ�¼!",
				type: "alert",
				timeout: 1000
			});
			return;
		}
		var newData = {};
		newData.locId = gridSelect.locId;
		newData.presTypeId = gridSelect.presTypeId;
		newData.printLabSelect = gridSelect.printLabSelect;
		// newData.presChkFlag = gridSelect.presChkFlag;
		// newData.presChkSel = gridSelect.presChkSel;
		newData.patRepFlag = gridSelect.patRepFlag;
		newData.printPresFlag = gridSelect.printPresFlag;
		newData.callFlag = gridSelect.callFlag;
		newData.screenFlag = gridSelect.screenFlag;
		newData.presAllSendFlag = gridSelect.presAllSendFlag;
		newData.presAgreeRetFlag = gridSelect.presAgreeRetFlag;
		newData.printDispSheet = gridSelect.printDispSheet;
		newData.patAdmType = gridSelect.patAdmTypeCode;
		PHA.SetVals([newData]);
	} else if (type = "A") {
		PHA.DomData("#win-form", {doType: 'clear'});
		var comOpts = $("#presTypeId").combobox("options");
		var defaultDataVal = comOpts.defaultData;
		if (defaultDataVal) {
			$("#presTypeId").combobox('setValue', defaultDataVal.RowId);
		}
	}
	// 20210409 ������칵ͨ��ȥ�����ɱ༭�Ŀ���
//	$("#locId").combogrid((type == "A") ? 'enable' : 'disable', true);
//	$("#presTypeId").combogrid((type == "A") ? 'enable' : 'disable', true);
	$('#gridConfigWin').window({
		iconCls: (type == "A") ? "icon-w-add" : "icon-w-edit",
		title: "ҩ����������" + ((type == "A") ? "����" : "�޸�")
	});
	$('#gridConfigWin').window('open');
}
