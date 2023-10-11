/**
 * 名称:   	 毒麻药品管理 - 毒麻处方打印
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-23
 * csp:		 pha.in.v1.narcprescprt.csp
 * js:		 pha/in/v1/narcprescprt.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcprescprt.csp';
PHA_COM.App.Name = '毒麻处方打印';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	InitDict();
	InitGridNarcPresc();
	InitEvents();

	InitConfig();
});

// 初始化 - 表单字典
function InitDict() {
	PHA.ComboBox("wardLocId", {
		placeholder: '病区...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox('phLocId', {
		placeholder: '发药科室...',
		url: PHA_STORE.CTLoc().url + '&TypeStr=D&HospId=' + session['LOGON.HOSPID']
	});
	PHA.ComboBox("docLocId", {
		placeholder: '开单科室...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '管制分类...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function (data) {
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});
	PHA.ComboBox("admType", {
		placeholder: '就诊类型...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType',
		panelHeight: 'auto'
	});
	/*
	PHA.ComboBox("oeoreState", {
		placeholder: '执行记录状态...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEOREStatus'
	});
	*/
}

// 初始化 - 事件绑定
function InitEvents() {
	// 登记号
	$('#patNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			var tPatNo = $('#patNo').val() || "";
			if (tPatNo == "") {
				return;
			}
			var nPatNo = PHA_COM.FullPatNo(tPatNo);
			$('#patNo').val(nPatNo);
			Query();
		}
	});
	$('#btnFind').on("click", Query);
	$('#btnClear').on("click", Clear);
	$('#btnPrint').on("click", PrintPrescDirect);
}

// 初始化 - 表格
function InitGridNarcPresc() {
	var columns = [
		[{
				title: "开单科室",
				field: "docLocDesc",
				width: 120,
				align: "left",
				sortable: true
			}, {
				title: "病区",
				field: "wardLocDesc",
				width: 130,
				align: "left",
				sortable: true
			}, {
				title: "处方号",
				field: "prescNo",
				width: 130,
				align: "left",
				sortable: true
			}, {
				title: "登记号",
				field: "patNo",
				width: 100,
				align: "left",
				sortable: true
			}, {
				title: "姓名",
				field: "patName",
				width: 90,
				align: "left",
				sortable: true
			}, {
				title: "证件号码",
				field: "IDCard",
				width: 170,
				align: "left",
				sortable: true,
				formatter: function(value, rowData, rowIndex){
					return '<label title="' + (rowData.cardTypeDesc || '') + '" class="hisui-tooltip" data-options="position:\'right\'">' + value + '</label>';
				}
			}, {
				title: "性别",
				field: "patSex",
				width: 65,
				align: "left",
				sortable: true
			}, {
				title: "年龄",
				field: "patAge",
				width: 65,
				align: "left",
				sortable: true
			}, {
				title: "体重",
				field: "patWeight",
				width: 70,
				align: "left",
				sortable: true
			}, {
				title: "身高",
				field: "patHeight",
				width: 70,
				align: "left",
				sortable: true
			}, {
				title: "电话",
				field: "patTel",
				width: 110,
				align: "left",
				sortable: true
			}, {
				title: "病历号",
				field: "MRNo",
				width: 100,
				align: "left",
				sortable: true
			}, {
				title: "诊断",
				field: "MRDiagnos",
				width: 150,
				align: "left",
				sortable: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Print',
			QueryName: 'NarcPresc'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: "#gridNarcPrescBar",
		onSelect: function (rowIndex, rowData) {
			var prescNo = rowData.prescNo;
			PrintPrescPreviwe(prescNo);
		},
		onLoadSuccess: function () {
			$('#ifrm-presc').attr('src', '');
		}
	};
	PHA.Grid("gridNarcPresc", dataGridOption);
}

function Query() {
	// 条件
	var formDataArr = PHA.DomData("#formPanel", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.hospId = session['LOGON.HOSPID'];

	// 查询
	var InputStr = JSON.stringify(formData);
	$('#gridNarcPresc').datagrid('query', {
		InputStr: InputStr
	});
}

// 界面预览
function PrintPrescPreviwe(prescNo) {
	var jsonData = GetPrescData(prescNo);
	if (jsonData == null) {
		return;
	}
	var backgroundColor = "white";
	if (jsonData.Para.PrescTitle) {
		var prescTitle = jsonData.Para.PrescTitle;
		if ((prescTitle.indexOf("麻") >= 0) || (prescTitle.indexOf("精一") >= 0)) {
			backgroundColor = "#F5A89A"; // 浅红
		}
		if (prescTitle.indexOf("急") >= 0) {
			backgroundColor = "#F6FDAF"; // 淡黄
		}
		if (prescTitle.indexOf("儿") >= 0) {
			backgroundColor = "#D5FFCA"; // 淡绿
		}
	}
	PRINTCOM.XML({
		printBy: 'inv',
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		iframeID: 'ifrm-presc',
		preview: {
			showButtons: false,
			backgroundColor: backgroundColor
		},
		page: {
			rows: 15,
			x: 20,
			y: 2,
			fontname: '黑体',
			fontbold: 'false',
			fontsize: '12'
		},
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

// 直接打印
function PrintPrescDirect() {
	var selectedData = $('#gridNarcPresc').datagrid('getSelected');
	if (selectedData == null || selectedData.length == 0) {
		PHA.Popover({
			msg: '请选择需要打印的处方!',
			type: "info"
		});
		return;
	}
	var prescNo = selectedData.prescNo;
	var jsonData = GetPrescData(prescNo);
	if (jsonData == null) {
		return;
	}

	PRINTCOM.XML({
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

function GetPrescData(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PrescPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		PHA.Alert("提示", "获取数据错误!" + jsonData.errMsg + ' \r\n ' + jsonData.success, -1);
		return null;
	}
	if (!jsonData.Templet) {
		PHA.Alert("提示", "未获取到需要处方数据!", -1);
		return null;
	}
	return jsonData;
}

function Clear() {
	PHA.DomData("#formPanel", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridNarcPresc').datagrid('clear');
	$('#ifrm-presc').attr('src', '');
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
		$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
		// 自动查询
		if (patNo != "") {
			Query();
		}
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
