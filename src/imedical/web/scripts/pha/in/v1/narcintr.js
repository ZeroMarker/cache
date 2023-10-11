/**
 * 名称:   	 毒麻药品管理 - 毒麻药品台账查询
 * 编写人:   Huxiaotian
 * 编写日期: 2021-06-09
 * csp:		 pha.in.v1.narcintr.csp
 * js:		 pha/in/v1/narcintr.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcintr.csp';
PHA_COM.App.Name = '毒麻药品台账查询';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;

$(function() {
	InitDict();
	InitGridIntrDsipRet();
	InitGridIntrTotal();
	InitGridIntrDetail();
	InitEvents();
	InitConfig();
});

// 初始化 - 表单字典
function InitDict(){
	PHA.ComboBox('phLocId', {
		placeholder: '发药科室...',
		url: PHA_STORE.CTLoc().url + '&TypeStr=D&HospId=' + session['LOGON.HOSPID']
	});
	PHA.ComboBox('poisonIdStr', {
		placeholder: '管制分类...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	PHA.ComboBox('stkCatGrpId', {
		placeholder: '类组...',
		width: 154,
		url: PHA_STORE.DHCStkCatGroup().url + '&HospId=' + session['LOGON.HOSPID'],
		onSelect: function(){
			$('#stkCatId').combobox('clear');
			$('#stkCatId').combobox('reload');
		}
	});
	PHA.ComboBox('stkCatId', {
		placeholder: '库存分类...',
		width: 154,
		url: PHA_STORE.INCStkCat().url + '&HospId=' + session['LOGON.HOSPID'],
		onBeforeLoad: function(param){
			var stkCatGrpId = $('#stkCatGrpId').combobox('getValue');
			param.CatGrpId = stkCatGrpId;
		}
	});
	PHA.ComboBox('intrTypeStr', {
		placeholder: '业务类型...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=IntrType',
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false
	});
	// 药品下拉
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 160;
	inciOptions.placeholder = '药品...';
	PHA.ComboGrid('inci', inciOptions);
	
	// 表单默认值
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('phLocId', session['LOGON.CTLOCID']);
	var tab = $('#tabsIntr').tabs('getSelected');
	var tabIndex = $('#tabsIntr').tabs('getTabIndex',tab);
	if (tabIndex == 0) {
		$('#intrTypeStr').combobox('setValues', ['P', 'Y', 'F', 'H']);
	}
}

// 初始化 - 事件绑定
function InitEvents(){
	$('#btnFind').on('click', Query);
    $('#btnClear').on('click', Clear);
    
    $('#tabsIntr').tabs({
		onSelect: function(title){
			$('#intrTypeStr').combobox('clear');
			// 综合业务台账
			if (title == $g('综合业务台账')) {
				var $tabOpts = $('#tabsIntr').tabs('options');
				if (!$tabOpts.isInitLayout) {
					PHA_COM.ResizePanel({
						layoutId: 'layoutIntr',
						region: 'north',
						height: 0.5
					});
					$('#tabsIntr').tabs('options').isInitLayout = true;
				}
			}
			// 发退药台账
			if (title == $g('发/退药业务台账')) {
				$('#intrTypeStr').combobox('setValues', ['P', 'Y', 'F', 'H']);
			}
		}
	});
}

// 初始化 - 表格
function InitGridIntrDsipRet(){
	var columns = [
		[
			{
				title: "业务时间",
				field: "intrDT",
				width: 155
			}, {
				title: "开单科室",
				field: "docLocDesc",
				width: 120
			}, {
				title: "登记号",
				field: "patNo",
				width: 95
			}, {
				title: "姓名",
				field: "patName",
				width: 100
			}, {
				title: "性别",
				field: "patSex",
				width: 60,
				align: 'center'
			}, {
				title: "年龄",
				field: "patAge",
				width: 60
			}, {
				title: "证件号",
				field: "patIDNo",
				width: 140
			}, {
				title: "电话",
				field: "patTel",
				width: 110
			}, {
				title: "处方号",
				field: "prescNo",
				width: 120
			}, {
				title: "诊断",
				field: "diagnosis",
				width: 120
			}, {
				title: "药品代码",
				field: "inciCode",
				width: 100
			}, {
				title: "药品名称",
				field: "inciDesc",
				width: 170
			}, {
				title: "规格",
				field: "inciSpec",
				width: 90
			}, {
				title: "开单医生", // 暂时不要. Huxt 2021-06-11
				field: "docUserName",
				width: 100
			}, {
				title: "数量",
				field: "intrQty",
				width: 65,
				align: 'right'
			}, {
				title: "单位",
				field: "intrUomDesc",
				width: 60
			}, {
				title: "数量(基)",
				field: "bQty",
				width: 65,
				align: 'right'
			}, {
				title: "基本单位",
				field: "bUomDesc",
				width: 70
			}, {
				title: "数量(入)",
				field: "pQty",
				width: 70,
				align: 'right'
			}, {
				title: "入库单位",
				field: "pUomDesc",
				width: 70
			}, {
				title: "结余数量(基)",
				field: "curBQty",
				width: 95,
				align: 'right'
			}, {
				title: "售价金额",
				field: "spAmt",
				width: 70,
				align: 'right'
			}, {
				title: "结余金额",
				field: "curSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "批号",
				field: "incibNo",
				width: 100
			}, {
				title: "配药人",
				field: "pyUserName",
				width: 80
			}, {
				title: "发药人",
				field: "fyUserName",
				width: 80
			}, {
				title: "业务类型",
				field: "intrTypeDesc",
				width: 70
			}, {
				title: "毒麻药品编号",
				field: "INCINo",
				width: 100
			}, {
				title: "登记科室",
				field: "regLocDesc",
				width: 110
			}, {
				title: "登记人",
				field: "regUserName",
				width: 100
			}, {
				title: "登记日期",
				field: "regDate",
				width: 90
			}, {
				title: "登记时间",
				field: "regTime",
				width: 90
			}, {
				title: "登记备注",
				field: "remarks",
				width: 120
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Trans',
			QueryName: 'IntrDispRet'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		gridSave: true,
		toolbar: [],
		onClickCell: function(index, field, value) {},
		onLoadSuccess: function(data){}
	};
	PHA.Grid('gridIntrDsipRet', dataGridOption);
}

// 初始化 - 药品台账
function InitGridIntrTotal(){
	var columns = [
		[
			{
				title: "incil",
				field: "incil",
				width: 100,
				hidden: true
			}, {
				title: "药品代码",
				field: "inciCode",
				width: 100
			}, {
				title: "药品名称",
				field: "inciDesc",
				width: 180
			}, {
				title: "规格",
				field: "inciSpec",
				width: 90
			}, {
				title: "经营企业",
				field: "venDesc",
				width: 120
			}, {
				title: "生产企业",
				field: "manfName",
				width: 120
			}, {
				title: "入库单位",
				field: "pUomDesc",
				width: 70
			}, {
				title: "基本单位",
				field: "bUomDesc",
				width: 70
			}, {
				title: "期初数量(基)",
				field: "begQty",
				width: 110,
				align: 'right',
				hidden: true
			}, {
				title: "期初数量",
				field: "begQtyUom",
				width: 110,
				align: 'right'
			}, {
				title: "期初金额(进)",
				field: "begRpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "期初金额(售)",
				field: "begSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "期末数量(基)",
				field: "endQty",
				width: 110,
				align: 'right',
				hidden: true
			}, {
				title: "期末数量",
				field: "endQtyUom",
				width: 110,
				align: 'right'
			}, {
				title: "期末金额(进)",
				field: "endRpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "期末金额(售)",
				field: "endSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "增加数量(基)",
				field: "plusQty",
				width: 100,
				align: 'right'
			}, {
				title: "减少数量(基)",
				field: "minusQty",
				width: 100,
				align: 'right'
			}, {
				title: "增加金额",
				field: "plusSpAmt",
				width: 100,
				align: 'right'
			}, {
				title: "减少金额",
				field: "minusSpAmt",
				width: 100,
				align: 'right'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Trans',
			QueryName: 'IntrTotal'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: [],
		onSelect: function(rowIndex, rowData) {
			QueryIntrDetail();
		},
		gridSave: false,
		onLoadSuccess: function(data){}
	};
	PHA.Grid('gridIntrTotal', dataGridOption);
}

// 初始化 - 台账明细
function InitGridIntrDetail(){
	var columns = [
		[
			{
				title: "intr",
				field: "intr",
				width: 100,
				hidden: true
			}, {
				title: "业务日期",
				field: "intrDT",
				width: 155
			}, {
				title: "业务类型",
				field: "intrTypeDesc",
				width: 90
			}, {
				title: "批号效期",
				field: "batStr",
				width: 175
			}, {
				title: "数量(入)",
				field: "pQty",
				width: 70,
				align: 'right'
			}, {
				title: "入库单位",
				field: "pUomDesc",
				width: 70
			}, {
				title: "售价",
				field: "pSp",
				width: 100,
				align: 'right'
			}, {
				title: "进价",
				field: "pRp",
				width: 100,
				align: 'right'
			}, {
				title: "售价金额",
				field: "spAmt",
				width: 100,
				align: 'right'
			}, {
				title: "进价金额",
				field: "rpAmt",
				width: 100,
				align: 'right'
			}, {
				title: "结余数量(入)",
				field: "curPQty",
				width: 110,
				align: 'right'
			}, {
				title: "结余金额(售)",
				field: "curSpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "结余金额(进)",
				field: "curRpAmt",
				width: 130,
				align: 'right'
			}, {
				title: "操作人",
				field: "userName",
				width: 110
			}, {
				title: "业务ID",
				field: "intrPointer",
				width: 150,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Trans',
			QueryName: 'IntrDetail'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: [],
		gridSave: true,
		onClickCell: function(index, field, value) {},
		onLoadSuccess: function(data){}
	};
	PHA.Grid('gridIntrDetail', dataGridOption);
}

/*
* 界面操作
*/
function Query() {
	var tab = $('#tabsIntr').tabs('getSelected');
	var tabTndex = $('#tabsIntr').tabs('getTabIndex', tab);
	if (tabTndex == 0) {
		QueryIntrDsipRet();
	} else {
		QueryIntrTotal();
	}
	
}
function QueryIntrDsipRet(){
	var formData = GetFormData();
	
	var needTypeArr = ['P', 'Y', 'F', 'H'];
	var intrTypeStr = formData.intrTypeStr;
	var intrTypeArr = intrTypeStr.split(',');
	for (var i in intrTypeArr) {
		var iType = intrTypeArr[i] || '';
		if (needTypeArr.indexOf(iType) < 0) {
			PHA.Popover({
				msg: "业务类型只能选择[住院发药/住院退药/门诊发药/门诊退药]",
				type: "alert"
			});
			return;
		}
	}
	
	$('#gridIntrDsipRet').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}
function QueryIntrTotal(){
	var formData = GetFormData();
	$('#gridIntrDetail').datagrid('clear');
	$('#gridIntrTotal').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}
function QueryIntrDetail(){
	var formData = GetFormData();
	var selRow = $('#gridIntrTotal').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	formData.incil = selRow.incil || '';
	$('#gridIntrDetail').datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}

// 获取参数
function GetFormData(){
	var formDataArr = PHA.DomData('#panelNarcIntr', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// 医院
	formData.hospId = session['LOGON.HOSPID'];
	return formData;
}

// 清空界面
function Clear(){
	PHA.DomData('#panelNarcIntr', {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#inci').combogrid('setValue', '');
	$('#stkCatId').combobox('reload');
	$('#gridIntrDsipRet').datagrid('clear');
	$('#gridIntrTotal').datagrid('clear');
	$('#gridIntrDetail').datagrid('clear');
	InitDictVal();
}

function InitConfig() {
	$.cm({
		ClassName: 'PHA.IN.Narc.Com',
		MethodName: 'GetConfigParams',
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}
