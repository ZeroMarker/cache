/**
 * 名称:   	 药房药库 - 毒麻药品管理 - 登记/回收查询
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-24
 * csp:		 pha.in.v1.narcqueryrec.csp
 * js:		 pha/in/v1/narcqueryrec.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcqueryrec.csp';
PHA_COM.App.Name = $g('回收查询');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.isGridLoad = false;
PHA_COM.VAR.isTotalInit = false;

$(function() {
	InitDict();
	InitGridNarcRecDetail();
	InitKeyWord();
	InitEvents();
	InitConfig();
});

// 初始化 - 表单字典
function InitDict(){
	PHA.ComboBox("recLocId", {
		placeholder: '回收科室...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("wardLocId", {
		placeholder: '病区...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W"
	});
	PHA.ComboBox("docLocId", {
		placeholder: '开单科室...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("admType", {
		placeholder: '就诊类型...',
		panelHeight: 'auto',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType'
	});
	PHA.ComboBox("dspState", {
		placeholder: '发药状态...',
		data: [
			{RowId: 'C', Description: $g('已发药')},
			{RowId: 'TC', Description: $g('未发药')}
		],
		panelHeight: 'auto'
	});
	PHA.ComboBox("recState", {
		disabled: true,
		placeholder: '回收状态...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RecStatus',
		panelHeight: 'auto'
	});
	PHA.ComboBox("destroyState", {
		placeholder: '销毁状态...',
		data: [
			{RowId: 'Y', Description: $g('已销毁')},
			{RowId: 'N', Description: $g('未销毁')}
		],
		panelHeight: 'auto'
	});
	InitDictVal();
}
function InitDictVal(){
	$('#recState').combobox('setValue', 'Y');
	$('#destroyState').combobox('setValue', '');
	PHA.SetComboVal('recLocId', session['LOGON.CTLOCID']);
}

// 初始化 - 事件绑定
function InitEvents(){
	$('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
    $('#patNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    var tPatNo = $('#patNo').val() || "";
		    if (tPatNo == '') {
			    return;
			}
		    var nPatNo = PHA_COM.FullPatNo(tPatNo);
		    $('#patNo').val(nPatNo);
		    Query();
		}
	});
	$('#grid-tabs').tabs({
		onSelect: function(title, index){
			if (title == $g('汇总列表') && PHA_COM.VAR.isGridLoad == false) {
				InitGridNarcRecTotal();
				PHA_COM.VAR.isGridLoad = true;
			}
			Query();
		}
	});
	
}

// 初始化 - 明细表格
function InitGridNarcRecDetail(){
	var columns = [
		[
			{
				title: "adm",
				field: "adm",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "登记号",
				field: "patNo",
				width: 100,
				align: "center",
				sortable: true,
				formatter: function(value, rowData, index){
					return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>"
				}
			} , {
				title: "患者姓名",
				field: "patName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "性别",
				field: "patSex",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "年龄",
				field: "patAge",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "患者科室",
				field: "patLocDesc",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "患者病区",
				field: "patWardDesc",
				width: 130,
				align: "left",
				sortable: true
			} , {
				title: "麻醉医师",
				field: "narcDocUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "毒麻药品编号",
				field: "inciNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "登记批号",
				field: "inciBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "药品名称",
				field: "inciDesc",
				width: 180,
				align: "left",
				sortable: true
			} , {
				title: "规格",
				field: "inciSpec",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "发药数量",
				field: "dspQty",
				width: 75,
				align: "right",
				sortable: true
			}  , {
				title: "发药单位",
				field: "dspUomDesc",
				width: 75,
				align: "right",
				sortable: true
			}, {
				title: "空安瓿数量",
				field: "recQty",
				width: 85,
				align: "right",
				sortable: true
			} , {
				title: "液体残余量",
				field: "recFluidQty",
				width: 85,
				align: "right",
				sortable: true
			} , {
				title: "用量单位",
				field: "doseUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "回收状态",
				field: "recStateDesc",
				width: 80,
				align: "center",
				sortable: true
			} , {
				title: "回收来源类型",
				field: "recOriTypeDesc",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "回收来源科室",
				field: "recOriLocDesc",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "回收科室",
				field: "recLocDesc",
				width: 100,
				align: "left",
				sortable: true
			}, {
				title: "回收人",
				field: "recUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "回收日期",
				field: "recDate",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "回收时间",
				field: "recTime",
				width: 80,
				align: "center",
				sortable: true
			} , {
				title: "回收核对人",
				field: "recCheckUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "回收送回人",
				field: "recFromUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "回收批号",
				field: "recBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "残量处理意见",
				field: "DSCDDesc",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "残量处理执行人",
				field: "DSCDExeUserName",
				width: 140,
				align: "left",
				sortable: true
			} , {
				title: "残量处理监督人",
				field: "DSCDSuperUserName",
				width: 140,
				align: "left",
				sortable: true
			} , {
				title: "预计执行时间",
				field: "dosingDT",
				width: 150,
				align: "center",
				sortable: true
			} , {
				title: "护士执行时间",
				field: "exeDT",
				width: 150,
				align: "center",
				sortable: true
			}, {
				title: "登记科室",
				field: "regLocDesc",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "登记人",
				field: "regUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "登记日期",
				field: "regDate",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "登记时间",
				field: "regTime",
				width: 80,
				align: "center",
				sortable: true
			}, {
				title: "执行记录ID",
				field: "oeore",
				width: 110,
				align: "left"
			}, {
				title: "毒麻登记ID",
				field: "pinr",
				width: 110,
				align: "left"
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Query',
			QueryName: 'NarcRecordDetail'
		},
		singleSelect: true,
		pagination: true,
		pageSize: 100,
		columns: columns,
		toolbar: [],
		onClickCell: function(index, field, value) {
			if (field == 'patNo') {
				OpenDetailWin(index);
				return;
			}
		}
	};
	PHA.Grid("grid-narcRecDetail", dataGridOption);
}

// 初始化 - 汇总表格
function InitGridNarcRecTotal(){
	var columns = [
		[
			{
				title: "adm",
				field: "adm",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "登记号",
				field: "patNo",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "姓名",
				field: "patName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "证件号码",
				field: "IDCard",
				width: 160,
				align: "center",
				sortable: true,
				formatter: function(value, rowData, rowIndex){
					return '<label title="' + (rowData.cardTypeDesc || '') + '" class="hisui-tooltip" data-options="position:\'right\'">' + value + '</label>';
				}
			} , {
				title: "性别",
				field: "patSex",
				width: 60,
				align: "center",
				sortable: true
			} , {
				title: "年龄",
				field: "patAge",
				width: 60,
				align: "center",
				sortable: true
			} , {
				title: "体重",
				field: "patWeight",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "身高",
				field: "patHeight",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "毒麻药品编号",
				field: "inciNo",
				width: 180,
				align: "left",
				sortable: true
			} , {
				title: "登记批号",
				field: "inciBatchNo",
				width: 150,
				align: "left",
				sortable: true
			} , {
				title: "药品代码",
				field: "inciCode",
				width: 150,
				align: "left",
				sortable: true
			} , {
				title: "药品名称",
				field: "inciDesc",
				width: 300,
				align: "left",
				sortable: true
			} , {
				title: "发药数量",
				field: "dspQty",
				width: 100,
				align: "right",
				sortable: true
			} , {
				title: "发药单位",
				field: "dspUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "空安瓿数量",
				field: "recQty",
				width: 100,
				align: "right",
				sortable: true
			} , {
				title: "残余液体量",
				field: "recFluidQty",
				width: 100,
				align: "right",
				sortable: true
			}, {
				title: "用量单位",
				field: "doseUomDesc",
				width: 75,
				align: "center",
				sortable: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Query',
			QueryName: 'NarcRecordTotal'
		},
		singleSelect: true,
		pagination: true,
		pageSize: 100,
		columns: columns,
		toolbar: "#grid-narcRecTotalBar",
		onClickCell: function(index, field, value) {}
	};
	PHA.Grid("grid-narcRecTotal", dataGridOption);
	PHA_COM.VAR.isTotalInit = true;
}

// 初始化 - 汇总类型关键字
function InitKeyWord(){
	$("#kwTotalType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [
			{
				text: '按医嘱',
				id: '1',
				selected: true
			},
			{
				text: '按药品',
				id: '2'
			},
			{
				text: '按登记批号',
				id: '3'
			}
		],
		onClick: Query
	});
}

/*
* 界面操作
*/
function Query(){
	var formData = PHA.DomData("#layout-formPanel", {
		doType: 'query',
		retType: 'Json'
	});
	if (formData.length == 0) {
		return;
	}
	var inputData = formData[0];
	var totalType = $("#kwTotalType").keywords("getSelected")[0].id || "";
	inputData.totalType = totalType;
	inputData.hospId = session['LOGON.HOSPID'];
	var InputStr = JSON.stringify(inputData);
	
	var tab = $('#grid-tabs').tabs('getSelected');
	var tabPanelOpts = $(tab).panel('options');
	var tabTitle = tabPanelOpts.title;
	var queryGridId = tabTitle == $g('明细列表') ? 'grid-narcRecDetail' : 'grid-narcRecTotal';
	ReSetCols(queryGridId, totalType);
	
	$('#' + queryGridId).datagrid('query', {
		InputStr: InputStr
	});
}

function ReSetCols(gridId, totalType){
	if (gridId != 'grid-narcRecTotal') {
		return;
	}
	var $_dg = $('#' + gridId);
	var dgOptions = $_dg.datagrid('options');
	var columns = dgOptions.columns[0];
	if (totalType == '1') {
		var fieldArr = ['patNo', 'patName', 'IDCard', 'patSex', 'patAge', 'patWeight', 'patHeight', 'inciBatchNo'];
		for (var i = 0; i < fieldArr.length; i++) {
			$_dg.datagrid('showColumn', fieldArr[i]);
		}
	}
	if (totalType == '2') {
		var fieldArr = ['patNo', 'patName', 'IDCard', 'patSex', 'patAge', 'patWeight', 'patHeight', 'inciBatchNo'];
		for (var i = 0; i < fieldArr.length; i++) {
			$_dg.datagrid('hideColumn', fieldArr[i]);
		}
	}
	if (totalType == '3') {
		$_dg.datagrid('showColumn', 'inciBatchNo');
		var fieldArr = ['patNo', 'patName', 'IDCard', 'patSex', 'patAge', 'patWeight', 'patHeight'];
		for (var i = 0; i < fieldArr.length; i++) {
			$_dg.datagrid('hideColumn', fieldArr[i]);
		}
	}
}

function Clear(){
	PHA.DomData("#layout-formPanel", {
		doType: 'clear'
	});
	InitDictVal();
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RecQuery.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RecQuery.EdDate']));
	$('#grid-narcRecDetail').datagrid('clear');
	if (PHA_COM.VAR.isTotalInit) {
		$('#grid-narcRecTotal').datagrid('clear');
	}
}

function OpenDetailWin(index){
	var rowsData = $('#grid-narcRecDetail').datagrid('getRows');
	var rowData = rowsData[index];
	var oeore = rowData.oeore || "";
	PHA_UX.DetailWin({
		id: 'PHA_WIN_INFO',
		title: '医嘱明细信息',
		width: 500,
		height: 560,
		labelWidth: 120,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Com',
			MethodName: 'GetOrderWinInfo',
			oeore: oeore
		}
	});
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RecQuery.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RecQuery.EdDate']));
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}