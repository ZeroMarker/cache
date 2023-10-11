/**
 * 名称:	 药房公共-系统管理-元素属性
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
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
 * @description: 初始化字典
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
 * @description: 树形表格-元素
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
				title: '名称',
				width: 100
			}, {
				field: "eleCode",
				title: '代码',
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
				text: $g("修改")
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
 * @description: 表格-元素属性
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
				title: '代码',
				width: 150
			}, {
				field: "eleItmDesc",
				title: '名称',
				width: 150
			}, {
				field: "eleItmValType",
				title: '类型',
				width: 100
			}, {
				field: "eleItmDefVal",
				title: '默认值',
				width: 100
			}, {
				field: "eleItmMemo",
				title: '说明',
				width: 410,
				showTip: true,
				tipWidth: 300,
				tipPosition: 'top'
			}, {
				field: "eleItmActive",
				title: '启用',
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
				title: '通用属性',
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
				text: $g("修改")
			});
		},
		toolbar: "#gridEleItmBar",
		gridSave: false
	};
	PHA.Grid("gridEleItm", dataGridOption);
}

/**
 * @description: 事件绑定初始化
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
 * @description: 查询属性
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
 * @description: 显示元素编辑弹窗
 */
function ShowDiagEle(btnOpt) {
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var ifSub = (btnOpt.id).indexOf('Sub') >= 0 ? true : false;
	var rowsData = $('#treegridEle').datagrid('getRows');
	var gridSelect = $('#treegridEle').datagrid('getSelected') || "";
	if ((gridSelect == "" && ifSub == true) || (gridSelect == "" && rowsData.length != 0)) {
		PHA.Popover({
			msg: "请选择需要处理的元素!",
			type: "alert"
		});
		return;
	}
	if (ifAdd == false) {
		var eleId = gridSelect.eleId || "";
		if (eleId == "") {
			PHA.Popover({
				msg: "请先选中需要编辑的元素",
				type: "alert"
			});
			return;
		}
	}
	$('#diagEle').dialog({
		modal: true,
		title: "元素" + btnOpt.text,
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
 * @description: 保存元素
 * @param {String} type 1(继续新增)
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
		PHA.Alert("提示", retInfo, retVal);
		return;
	} else {
		PHA.Popover({
			msg: "保存成功!",
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
 * @description: 删除元素
 */
function DeleteEle() {
	var gridSelect = $('#treegridEle').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择一条数据!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	//删除前验证
	var eleId = gridSelect.eleId || "";
	var chkRet = $.cm({
		ClassName: 'PHA.SYS.Ele.Save',
		MethodName: 'CheckDelete',
		eleId: eleId,
		dataType: 'text',
	}, false);
	var chkArr = chkRet.toString().split("^");
	var delInfo = "是否确认删除?"
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
		//删除确认
		PHA.Confirm("温馨提示", delInfo, function () {
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
			PHA.Alert('温馨提示', retInfo, 'warning');
			return;
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: 'success'
			});
			$("#treegridEle").treegrid("reload");
		}
	});
}

/**
 * @description: 显示元素属性编辑弹窗
 */
function ShowDiagEleItm(btnOpt) {
	var ifAdd = (btnOpt.id).indexOf("Add") >= 0 ? true : false;
	var gridSelect = $('#treegridEle').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "请选择元素!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var gridItmSelect = $('#gridEleItm').datagrid('getSelected') || "";
	if (ifAdd == false && gridItmSelect == "") {
		PHA.Popover({
			msg: "请选择元素属性!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	$('#diagEleItm').dialog({
		modal: true,
		title: "元素属性" + btnOpt.text,
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
 * @description: 保存属性
 * @param {String} type 1(继续新增)
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
		PHA.Alert("温馨提示", retInfo, retVal);
		return;
	} else {
		PHA.Popover({
			msg: "保存成功!",
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
 * @description: 显示元素属性编辑弹窗
 */
function DeleteEleItm() {
	var gridItmSelect = $('#gridEleItm').datagrid('getSelected');
	if (gridItmSelect == null) {
		PHA.Popover({
			msg: '请选择元素属性!',
			type: 'alert'
		});
		return;
	}
	var eleItmId = gridItmSelect.eleItmId || "";

	//删除确认
	PHA.Confirm("温馨提示", "是否确认删除?", function () {
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
			PHA.Alert('温馨提示', retInfo, retVal);
			return;
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: 'success'
			});
			$("#gridEleItm").datagrid("reload");
		}
	});
}

function ShowHelp(){
	/* 帮助弹窗 */
	var winId = "ele_help_win";
	var winContentId = winId + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 650,
			height: 480,
			modal: true,
			title: '元素属性帮助',
			iconCls: 'icon-w-list',
			content: "<div id='" + winContentId + "'style='margin:10px;'></div>",
			closable: true
		});
		$('#' + winContentId).html(GetInitHtml());
	}
	$('#' + winId).dialog('open');
	
	/* 帮助内容 */
	function GetInitHtml(){
		var helpHtml = '';
		helpHtml += GetItemTitle('代码');
		helpHtml += GetItemContent('代码与hisui组件的配置属性名一致。');
		helpHtml += GetItemTitle('名称');
		helpHtml += GetItemContent('名称是描述属性的含义。');
		helpHtml += GetItemTitle('类型');
		helpHtml += GetItemContent('用于在【页面设置】中维护属性值的时候，验证输入的属性值是否合法。例如：boolean只能输入Y/N；number类型只能输入数字。');
		helpHtml += GetItemTitle('默认值');
		helpHtml += GetItemContent('在没有维护相应属性值的时候，取此值为默认值。');
		helpHtml += GetItemTitle('说明');
		helpHtml += GetItemContent('对该属性的详细说明，帮助用户在后面填写属性值的时候理解其含义或者提供示例。');
		helpHtml += GetItemTitle('启用');
		helpHtml += GetItemContent('启用的属性在系统中才有效，否则即使维护了相应的属性值也无效。');
		helpHtml += GetItemTitle('通用属性');
		helpHtml += GetItemContent('参数设置系统将页面为两类: (1)CSP页面 - 药房进入某个HISUI页面由系统自动生成的页面,一个csp代表一个页面; (2)自定义页面 - 通过模板无代码生成的页面。“通用属性”是指维护属性值之后，在“CSP页面”和“自定义页面”都可以使用的属性，非通用属性则不可以在“CSP页面”页面使用，但可以在“自定义页面”使用。');
		return helpHtml;
	}
	function GetItemTitle(title){
		return '<div style="margin-top:10px;"><b>' + trans(title) + '：</b></div>';
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