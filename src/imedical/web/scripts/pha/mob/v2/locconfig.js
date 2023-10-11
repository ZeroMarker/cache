/**
 * 模块:     移动药房配置
 * 编写日期: 2020-20-20
 * 编写人:   Huxt
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

// 初始化条件
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
		placeholder: '药房科室...',
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
		placeholder: '配方类型...',
		url: $URL + "?ClassName=PHA.MOB.Dictionary&QueryName=PresType&ResultSetType=array",
		editable: false,
		panelHeight: 'auto',
		onLoadSuccess: function () {
			var comOpts = $("#cmbPresType").combobox("options");
			comOpts.defaultData = null;
			var datas = $("#cmbPresType").combobox("getData");
			for (var i = 0; i < datas.length; i++) {
				if (datas[i].typeDefaul == 'Y') {
					comOpts.defaultData = datas[i]; // 设置默认值,后面新增的时候用
					break;
				}
			}
		}
	});

	PHA.ComboBox('printLabSelect', {
		placeholder: '打印用法标签...',
		editable: true,
		panelHeight: 'auto',
		data: [{
				"RowId": "0",
				"Description": "不打印标签"
			}, {
				"RowId": "1",
				"Description": "调配完成后打印标签"
			}, {
				"RowId": "2",
				"Description": "单独打印标签"
			}
		]
	});
	
	PHA.ComboBox('patAdmType', {
		placeholder: '患者就诊类型...',
		editable: true,
		panelHeight: 'auto',
		data: [{
				"RowId": "O",
				"Description": "门诊"
			}, {
				"RowId": "E",
				"Description": "急诊"
			}, {
				"RowId": "I",
				"Description": "住院"
			}
		]
	});

	PHA.ComboBox('presChkSel', {
		placeholder: '审方时刻...',
		editable: true,
		panelHeight: 'auto',
		data: [{
				"RowId": "1",
				"Description": "先收费后审方"
			}, {
				"RowId": "2",
				"Description": "先审方后收费"
			}
		]
	});
}

// 表格
function InitGridConfig() {
	var columns = [
		[{
				field: "phcf",
				title: 'phcf',
				hidden: true
			}, {
				field: "locId",
				title: '药房Id',
				hidden: true
			}, {
				field: 'locDesc',
				title: '药房科室',
				width: 180,
				sortable: 'true'
			}, {
				field: 'patAdmTypeCode',
				title: '患者就诊类型Code',
				hidden: true
			}, {
				field: 'patAdmType',
				title: '患者就诊类型',
				width: 100,
				sortable: 'true'
			}, {
				field: "presTypeId",
				title: '配方类型Id',
				hidden: true
			}, {
				field: 'presTypeDesc',
				title: '配方类型',
				width: 120,
				sortable: 'true'
			}, {
				field: 'printLabSelect',
				title: '打印用法标签Id',
				width: 120,
				sortable: 'true',
				hidden: true
			}, {
				field: 'printLabSelectDesc',
				title: '打印用法标签',
				width: 140,
				sortable: 'true'
			}, {
				field: 'presChkSel',
				title: '审方时刻Id',
				width: 120,
				sortable: 'true',
				hidden: true
			}, {
				field: 'presChkSelDesc',
				title: '审方时刻',
				width: 120,
				sortable: 'true',
				hidden: true
			}, {
				field: 'presChkFlag',
				title: '是否需要审方',
				width: 100,
				sortable: 'true',
				align: 'center',
				formatter: FormatterYes,
				hidden: true
			}, {
				field: 'patRepFlag',
				title: '是否需患者报到',
				width: 120,
				align: 'center',
				formatter: FormatterYes
			}, {
				field: 'printPresFlag',
				title: '是否打印配药单',
				width: 120,
				sortable: 'true',
				align: 'center',
				formatter: FormatterYes
			}, {
				field: 'callFlag',
				title: '是否叫号',
				align: 'center',
				width: 90,
				formatter: FormatterYes
			}, {
				field: 'screenFlag',
				title: '是否上屏',
				align: 'center',
				width: 90,
				sortable: 'true',
				formatter: FormatterYes
			}, {
				field: 'presAllSendFlag',
				title: '是否揭药室全送',
				align: 'center',
				width: 120,
				sortable: 'true',
				formatter: FormatterYes
			}, {
				field: 'presAgreeRetFlag',
				title: '是否允许退药',
				align: 'center',
				width: 100,
				sortable: 'true',
				formatter: FormatterYes
			}, {
				field: 'printDispSheet',
				title: '是否打印调剂单',
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

// 保存
function SaveConfig() {
	var winTitle = $("#gridConfigWin").panel('options').title;
	
	// 窗口表单数据
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
	
	// 验证
	if (formData.presChkFlag == "Y" && formData.presChkSel == "") {
		$.messager.popover({
			msg: "请选择审方时刻！",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	if (formData.presChkFlag == "N") {
		formData.presChkSel = "";
	}
	
	// 获取ID
	var phcf = "";
	if (winTitle.indexOf("新增") >= 0) {
	} else {
		var gridSelect = $('#gridConfig').datagrid('getSelected');
		phcf = gridSelect.phcf;
	}
	
	// 保存
	var pJsonStr = JSON.stringify(formData);
	var saveRet = tkMakeServerCall("PHA.MOB.LocCfg.Save", "Save", phcf, pJsonStr);
	var saveArr = saveRet.split("^");
	var saveValue = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveValue < 0) {
		$.messager.alert("提示", saveInfo, (saveValue == "-1") ? "warning" : "error");
		return;
	}
	$('#gridConfigWin').window('close');
	$('#gridConfig').datagrid("reload");
	$.messager.popover({
		msg: "保存成功!",
		type: "success",
		timeout: 1000
	});
}

// 删除
function DeleteConfig() {
	var gridSelect = $('#gridConfig').datagrid("getSelected");
	if (gridSelect == null) {
		$.messager.popover({
			msg: "请选择需要删除的记录!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	$.messager.confirm('确认对话框', '确定删除吗？', function (r) {
		if (r) {
			var phcf = gridSelect.phcf || "";
			if (phcf == "") {
				var rowIndex = $('#gridConfig').datagrid('getRowIndex', gridSelect);
				$('#gridConfig').datagrid("deleteRow", rowIndex);
			} else {
				var delRet = tkMakeServerCall("PHA.MOB.LocCfg.Save", "Delete", phcf);
				var delRetArr = delRet.split('^');
				if (delRetArr[0] < 0) {
					$.messager.alert("提示", saveInfo, (saveValue == "-1") ? "warning" : "error");
					return;
				}
				$.messager.popover({
					msg: "删除成功!",
					type: "success",
					timeout: 1000
				});
				$('#gridConfig').datagrid("reload");
			}
		}
	})
}

// 格式化
function FormatterYes(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// 打开窗口
function OpenMainTainWin(type) {
	var gridSelect = $('#gridConfig').datagrid('getSelected');
	if (type == "U") {
		if (gridSelect == null) {
			$.messager.popover({
				msg: "请先选中需要修改的记录!",
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
	// 20210409 与胡晓天沟通，去掉不可编辑的控制
//	$("#locId").combogrid((type == "A") ? 'enable' : 'disable', true);
//	$("#presTypeId").combogrid((type == "A") ? 'enable' : 'disable', true);
	$('#gridConfigWin').window({
		iconCls: (type == "A") ? "icon-w-add" : "icon-w-edit",
		title: "药房属性配置" + ((type == "A") ? "新增" : "修改")
	});
	$('#gridConfigWin').window('open');
}
