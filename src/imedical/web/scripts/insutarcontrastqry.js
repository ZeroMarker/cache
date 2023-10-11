/**
* FillName: insutarcontrastqry.js
* Description: 医保目录对照查询
* Creator JinShuai1010
* 2022-11-10/靳帅/UI修改
* Date: 2022-09-26
*/
// 定义常量
var PUBLIC_CONSTANT = {
	SESSION: {
		HOSPID: session['LOGON.HOSPID'],  //院区
	}
}
var PUB_CNT = {
	HITYPE: '',                               //医保类型
	ChargesID: '',
	SSN: {
		USERID: session['LOGON.USERID'],	//操作员ID
	},
	SYSDTFRMT: function () {
		var _sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false);
		return _sysDateFormat;
	}
};
//入口函数

$(function () {
	GetjsonQueryUrl()
	setPageLayout();    //设置页面布局
	init_Keyup();
	$("#btnDivQuery").click(InsuSearch);
	$("#clear").click(clear);
	//	$("#btnDivQuery").click(ChangesS);
});
//设置页面布局
function setPageLayout() {
	//医保类型
	initHiTypeCmb();
	initHisDivDetDgDg();
	initCenterDivDetDg();
}
//清屏
function clear() {
	setValueById('InsuPinYin', "");
	setValueById('InsuCode', "");
	setValueById('InsuName', "");
	setValueById('ChargesPinYin', "");
	setValueById('ChargesCode', "");
	setValueById('ChargesName', "");
	$('#hiType').combobox('reload');
	$("#HisDivDetDg").datagrid("loadData", { total: 0, rows: [] }); //20191028
	$("#CenterDivDetDg").datagrid("loadData", { total: 0, rows: [] }); //20191028
}
//回车
function init_Keyup() {
	//医保目录对照
	$('#InsuPinYin').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#InsuCode').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#InsuName').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#ChargesPinYin').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#ChargesCode').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
	$('#ChargesName').keyup(function () {
		if (event.keyCode == 13) {
			InsuSearch();
		}
	});
}
//初始化医保类型
function initHiTypeCmb() {
	$HUI.combobox('#hiType', {
		url: $URL,
		editable: false,
		valueField: 'cCode',
		textField: 'cDesc',
		panelHeight: 100,
		method: 'GET',
		onBeforeLoad: function (param) {
			param.ClassName = 'web.INSUDicDataCom';
			param.QueryName = 'QueryDic';
			param.ResultSetType = 'array';
			param.Type = 'DLLType';
			param.Code = '';
			param.HospDr = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		loadFilter: function (data) {
			for (var i in data) {
				if (data[i].cDesc == '全部') {
					data.splice(i, 1)
				}
			}
			return data
		},
		onLoadSuccess: function () {
			$('#hiType').combobox('select', '00A');
		},
		onSelect: function (rec) {
			PUB_CNT.HITYPE = rec.cCode;
		}

	});
}
//初始化收费项信息dg
var Hiscolumn = [[
	{ field: 'HISRowId', title: '收费项id', width: 90, hidden: true },
	{ field: 'INTCTHisDesc', title: '收费项名称', width: 160 },
	{ field: 'INTCTHisCode', title: '收费项编码', width: 90 },
	{ field: 'TARIPrice', title: '收费项价格', width: 80 },
	{ field: 'INSURowId', title: '医保目录id', width: 90, hidden: true },
	{ field: 'INTCTInsuCode', title: '医保目录编码', width: 160 },
	{ field: 'INTCTInsuDesc', title: '医保目录名称', width: 160 },
	{ field: 'INTCTActiveDate', title: '生效日期', width: 90 },
	{ field: 'INTCTExpiryDate', title: '失效日期', width: 90 }

]];
function initHisDivDetDgDg() {
	$HUI.datagrid('#HisDivDetDg', {
		autoSizeColumn: false,
		title: '收费项信息',
		toolbar: [],
		headerCls: 'panel-header-gray',
		rownumbers: true,
		//border: false,
		fit: true,
		striped: true,
		//url:$URL,
		singleSelect: true,
		pageSize: 20,
		pageList: [10, 20, 30],
		pagination: true,
		columns: Hiscolumn

	});
}
//初始化医嘱项信息dg
var initColumn = [[
	{ field: 'ARCIMDesc', title: '医嘱项名称', width: 150 },
	{ field: 'ARCIMCode', title: '医嘱项代码', width: 120 },
	{ field: 'ARCIMRowId', title: '医嘱项Id', width: 120 },
	{ field: 'ARCIMEffDate', title: '有效日期', width: 120 },
	{ field: 'ARCIMEffDateTo', title: '失效日期', width: 100 }

]];
function initCenterDivDetDg() {
	$HUI.datagrid('#CenterDivDetDg', {
		rownumbers: true,
		fit: true,
		striped: true,
		title: '医嘱项信息',
		toolbar: [],
		headerCls: 'panel-header-gray',
		singleSelect: true,
		pageSize: 20,
		pageList: [10, 20, 30],
		pagination: true,
		autoSizeColumn: false,
		columns: initColumn

	});
}
//查询收费项信息
function InsuSearch() {
	var InsuAlias = $('#InsuPinYin').val();
	var InsuCode = $('#InsuCode').val();
	var InsuDesc = $('#InsuName').val();
	var HisAlias = $('#ChargesPinYin').val();
	var HisCode = $('#ChargesCode').val();
	var HisDesc = $('#ChargesName').val();
	if (InsuAlias == "" && InsuCode == "" && InsuDesc == "" && HisAlias == "" && HisCode == "" && HisDesc == "") {
		$.messager.alert("提示", "请至少输入一个查询条件!", "info");
		return false;
	}
	$HUI.datagrid('#HisDivDetDg', {
		columns: Hiscolumn,
		url: $URL,
		iconCls: 'icon-save',
		border: true,                          //upt 2023/2/15 JinS1010 显示边框
		fit: true,
		striped: true,
		autoSizeColumn: false,
		rownumbers: true,
		pagination: true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 40, 60],
		queryParams: {
			ClassName: 'web.INSUTarContrastQry',
			QueryName: 'GetTarConInfo',
			'Type': PUB_CNT.HITYPE,
			'InsuAlias': InsuAlias,
			'InsuCode': InsuCode,
			'InsuDesc': InsuDesc,
			'HisAlias': HisAlias,
			'HisCode': HisCode,
			'HisDesc': HisDesc,
			'HospId': PUBLIC_CONSTANT.SESSION.HOSPID
		},
		onSelect: function (rowIndex, rowData) {
			PUB_CNT.ID = rowData.HISRowId;
			InsuSelect();
		},
	});
}
//查询对应的医嘱项信息
function InsuSelect() {
	$HUI.datagrid('#CenterDivDetDg', {
		url: $URL,
		iconCls: 'icon-save',
		border: true,                        //upt 2023/2/15 JinS1010 显示边框
		fit: true,
		striped: true,
		autoSizeColumn: false,
		rownumbers: true,
		pagination: true,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 40, 60],
		queryParams: {
			ClassName: 'web.INSUTarContrastQry',
			QueryName: 'GetArcItmInfo',
			'TarRowid': PUB_CNT.ID,
			'HospId': PUBLIC_CONSTANT.SESSION.HOSPID
		}
	})
}
//加载院区
function selectHospCombHandle() {
	$('#hiType').combobox('reload');
}

