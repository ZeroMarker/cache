/*
 * 名称:	 毒麻药品管理 - 科室基数管理
 * 编写人:	 Huxt
 * 编写日期: 2021-08-10
 * csp:      pha.in.v1.narcbase.csp
 * js:       pha/in/v1/narcbase.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = $g('药库');
PHA_COM.App.Csp = 'pha.in.v1.narcbase.csp';
PHA_COM.App.Name = $g('科室库存基数维护');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function () {
	if (!PHA_COM.IsTabsMenu()){
		var pOpts = $('#panelNarcDrug').panel('options');
		$('#panelNarcDrug').panel('setTitle', PHA_COM.App.Name + ' - ' + pOpts.title);
	}
	
	InitDict();
	InitGridNarcDrug();
	InitGridNarcDrugBat();
	InitEvents();
	InitConfig();
});

function InitEvents(){
	$('#btnFindNarcDrug').on('click', QueryNarcDrug);
	$('#btnClearNarcDrug').on('click', ClearNarcDrug);
	$('#btnFindNarcDrugBat').on('click', QueryNarcDrugBat);
	$('#btnClearNarcDrugBat').on('click', ClearNarcDrugBat);
	$('#btnSave').on('click', BeforeSave);
	$('#inciText').on('keydown', function(e){
		if (e.keyCode == 13) {
			QueryNarcDrug();
		}
	});
	$('#closeReason').on('click', function(){
		$('#dialogSelReason').dialog('close');
	});
	$('#saveReason').on('click', function(){
		Save();
		$('#dialogSelReason').dialog('close');
	});
}

function InitDict(){
	PHA.ComboBox('baseLocId', {
		required: true,
		placeholder: '基数科室...',
		disabled: true,
		url: PHA_STORE.CTLoc().url,
		onSelect: function (rowData) {
			QueryNarcDrugBat();
		}
	});
	PHA.ComboBox('baseStatus', {
		placeholder: '库存状态...',
		panelHeight: 'auto',
		data: [
			{RowId: 'A', Description: $g('全部')},
			{RowId: 'Y', Description: $g('有库存')},
			{RowId: 'N', Description: $g('无库存')}
		]
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '管制分类...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		width: 295
	});
	
	PHA.ComboBox("adjReason", {
		placeholder: '调整原因...',
		mode: 'remote',
		width: 260,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=ComDic',
		onBeforeLoad: function (param) {
			var scdiType = 'NARCAdjReason';
			var valType = 'Code';
			var QText = param.q || '';
			param.InputStr = scdiType + '^' + valType + '^' + QText;
		}
	});
	
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('baseLocId', PHA_COM.VAR.locId);
	PHA.SetComboVal('baseStatus', 'A');
	PHA.SetComboVal('adjReason', '1');
}

// 初始化 - 表格
function InitGridNarcDrug() {
	var columns = [[{
				field: 'inci',
				title: '库存项ID',
				width: 100,
				hidden: true
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 140,
				hidden: true
			}, {
				field: 'inciDesc',
				title: '药品名称',
				width: 200
			}, {
				field: 'inciSpec',
				title: '规格',
				width: 100
			}, {
				field: 'poisonDesc',
				title: '管制分类',
				width: 100
			}, {
				field: 'showDetail',
				title: '详情',
				width: 45,
				fixed: true,
				formatter: function(value, rowData, rowIndex){
					return "<a class='pha-detail-tips' rowIndex='" + rowIndex + "'>" + $g("详情") + "</a>";
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcBase.Query',
			QueryName: 'NarcDrug',
			hospId: PHA_COM.VAR.hospId
		},
		fitColumns: true,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridNarcDrugBar',
		onSelect: function (rowIndex, rowData) {
			QueryNarcDrugBat();
		},
		onLoadSuccess: function (data) {
			$('#gridNarcDrugBat').datagrid('loadData', []);
			$(".pha-detail-tips").each(function(){
				var rowIndex = $(this).attr('rowIndex');
				var rowsData = $('#gridNarcDrug').datagrid('getRows');
				var rowData = rowsData[rowIndex];
				var contentHtml = '';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药品代码') + '：</font>' + rowData.inciCode + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药品名称') + '：</font>' + rowData.inciDesc + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药品规格') + '：</font>' + rowData.inciSpec + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('管制分类') + '：</font>' + rowData.poisonDesc + '</p>';
				contentHtml += '<p style="line-height:24px;white-space:nowrap;"><font style="color:#777777;">' + $g('药学分类') + '：</font>' + rowData.phccDescAll + '</p>';
				$(this).popover({
					placement: 'auto',
					trigger: 'hover',
					title: '药品详情',
					content: contentHtml
				});
			});
		}
	};
	PHA.Grid('gridNarcDrug', dataGridOption);
}

// 初始化 - 表格
function InitGridNarcDrugBat() {
	var columns = [[{
				field: 'incib',
				title: '批次ID',
				width: 100,
				hidden: true
			}, {
				field: 'pinb',
				title: '主键',
				width: 100,
				hidden: true
			}, {
				field: 'baseLocDesc',
				title: '基数科室',
				width: 130
			}, {
				field: 'batNo',
				title: '批号',
				width: 130
			}, {
				field: 'expDate',
				title: '效期',
				width: 95
			}, {
				field: 'displayQty',
				title: GetEditTitle('库存基数'),
				width: 100,
				align: 'right',
				editor: PHA_GridEditor.NumberBox({})
			}, {
				field: 'displayUomId',
				descField: 'displayUomDesc',
				title: GetEditTitle('单位'),
				width: 90,
				formatter: function (value, rowData, rowIndex) {
					return rowData["displayUomDesc"];
				},
				editor: PHA_GridEditor.ComboBox({
					mode: 'remote',
					url: $URL + '?ResultSetType=Array&ClassName=PHA.IN.NarcBase.Query&QueryName=DrugUom',
					onBeforeLoad: function (param) {
						var selRow = $('#gridNarcDrug').datagrid('getSelected');
						if (selRow == null) {
							return;
						}
						param.inci = selRow.inci || "";
					}
				})
			}, {
				title: "是否可用",
				field: "active",
				width: 70,
				align: "center",
				formatter: function (value, rowData, rowIndex) {
					var fmtStr = '<label style="border:0px;cursor:pointer;" title="'+$g('点击修改可用状态')+'" onclick=UpdateActive(' + rowIndex + ')>';
					if (value == 'Y') {
						fmtStr += '<font color="#21ba45">'+$g('是')+'</font>';
					} else {
						fmtStr += '<font color="#f16e57">'+$g('否')+'</font>';
					}
					fmtStr += '</label>';
					return fmtStr;
				},
			}, {
				field: 'baseQty',
				title: '基本单位数量',
				width: 90,
				hidden: true
			}, {
				field: 'baseUomDesc',
				title: '基本单位',
				width: 90,
				hidden: true
			}, {
				field: 'vendDesc',
				title: '经营企业',
				width: 170
			}, {
				field: 'manfName',
				title: '生产企业',
				width: 170
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcBase.Query',
			QueryName: 'NarcDrugBat',
			hospId: PHA_COM.VAR.hospId
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridNarcDrugBatBar',
		onSelect: function (rowIndex, rowData) {},
		allowEnd: true,
		isAutoShowPanel: true,
		editFieldSort: ['displayQty', 'displayUomId'],
		onDblClickCell: function(index, field, value){
			PHA_GridEditor.Edit({
				gridID: 'gridNarcDrugBat',
				index: index,
				field: field
			});
		},
		onClickCell: function(index, field, value){
			PHA_GridEditor.End('gridNarcDrugBat');
		},
		onLoadSuccess: function (data) {
			PHA_GridEditor.End('gridNarcDrugBat');
		}
	};
	PHA.Grid('gridNarcDrugBat', dataGridOption);
}

function QueryNarcDrug(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	
	$('#gridNarcDrug').datagrid('options').url = $URL;
	$('#gridNarcDrug').datagrid('query', {
		pJsonStr: JSON.stringify(formData),
		hospId: PHA_COM.VAR.hospId
	});
}

function QueryNarcDrugBat(){
	var selRow = $('#gridNarcDrug').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	var inci = selRow.inci;
	var formDataArr = PHA.DomData("#gridNarcDrugBatBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	formData.inci = inci;
	
	$('#gridNarcDrugBat').datagrid('options').url = $URL;
	$('#gridNarcDrugBat').datagrid('query', {
		pJsonStr: JSON.stringify(formData),
		hospId: PHA_COM.VAR.hospId
	});
}

function BeforeSave(){
	PHA_GridEditor.End('gridNarcDrugBat');
	// 验证科室权限
	if (!CheckLocAuth()) {
		return;
	}
	
	$('#dialogSelReason').dialog({
		/*buttons:[{
				text: '保存',
				handler: function(){
					Save();
					$('#dialogSelReason').dialog('close');
				}
			},{
				text: '关闭',
				handler:function(){
					$('#dialogSelReason').dialog('close');
				}
			}
		]*/
	});
	$('#dialogSelReason').dialog('open');
}

function Save(){
	// 验证科室权限
	if (!CheckLocAuth()) {
		return;
	}
	
	var rowsData = $('#gridNarcDrugBat').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: '没有数据！',
			type: "alert"
		});
		return;
	}
	var changesData = $('#gridNarcDrugBat').datagrid('getChanges');
	if (changesData == null || changesData.length == 0) {
		PHA.Popover({
			msg: '数据没有发生改变！',
			type: "alert"
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridNarcDrugBat');
	if (chkRetStr != "") {
		PHA.Popover({
			msg: chkRetStr,
			type: "alert"
		});
		return;
	}
	var locId = $('#baseLocId').combobox('getValue') || '';
	var adjReason = $('#adjReason').combobox('getText') || '';
	var pJsonStr = JSON.stringify({
		locId: locId,
		userId: PHA_COM.VAR.userId,
		adjReason: adjReason
	});
	AddRowIndex('gridNarcDrugBat', changesData);
	var pRowsDataStr = JSON.stringify(changesData);
	
	// 保存
	var retStr = tkMakeServerCall('PHA.IN.NarcBase.Save', 'AdjLocBase', pJsonStr, pRowsDataStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert('提示', retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '保存成功！',
		type: "success"
	});
	QueryNarcDrugBat();
}

function UpdateActive(rowIndex){
	// 验证科室权限
	if (!CheckLocAuth()) {
		return;
	}
	
	var rowsData = $('#gridNarcDrugBat').datagrid('getRows');
	var rowData = rowsData[rowIndex];
	var locId = $('#baseLocId').combobox('getValue') || '';
	if (locId == '') {
		PHA.Popover({
			msg: '请选择基数科室！',
			type: "alert"
		});
		return;
	}
	rowData.locId = locId;
	rowData.userId = PHA_COM.VAR.userId;
	var activeFlag = rowData.active;
	var oldDesc = activeFlag == 'Y' ? $g('可用') : $g('不可用');
	var newDesc = activeFlag == 'Y' ? $g('不可用') : $g('可用');
	var newColor = activeFlag == 'Y' ? '#f16e57' : '#21ba45';
	var conTips = '是否确认将状态修改为 [<font color="' + newColor + '">' + newDesc + '</font>] ？';
	var pJsonStr = JSON.stringify(rowData);
	
	PHA.Confirm('温馨提示', conTips, function () {
		var retStr = tkMakeServerCall('PHA.IN.NarcBase.Save', 'UpdateActive', pJsonStr);
		var retArr = retStr.split('^');
		if (retArr[0] < 0) {
			PHA.Alert('提示', retArr[1], retArr[0]);
			return;
		}
		PHA.Popover({
			msg: '修改成功！',
			type: "success"
		});
		QueryNarcDrugBat();
	});
}

function ClearNarcDrug(){
	var formDataArr = PHA.DomData("#gridNarcDrugBar", {
		doType: 'clear'
	});
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridNarcDrug').datagrid('loadData', []);
	$('#gridNarcDrugBat').datagrid('loadData', []);
}

function ClearNarcDrugBat(){
	var formDataArr = PHA.DomData("#gridNarcDrugBatBar", {
		doType: 'clear'
	});
	InitDictVal();
	$('#gridNarcDrugBat').datagrid('loadData', []);
}

function CheckLocAuth(){
	var locId = $('#baseLocId').combobox('getValue') || '';
	if (locId == '') {
		PHA.Popover({
			msg: '请选择基数科室！',
			type: "alert"
		});
		return false;
	}
	var locType = tkMakeServerCall('PHA.IN.Narc.Com', 'GetLocType', locId);
	if (['OP', 'W'].indexOf(locType) < 0) {
		PHA.Alert('温馨提示', '[基数科室]为医技科室或病区才能使用此功能', -1);
		return false;
	}
	return true;
} 

function GetEditTitle(title) {
	return title;
}

function AddRowIndex(gridId, rowsData){
	var rLen = rowsData.length;
	for (var i = 0; i < rLen; i++) {
		var iData = rowsData[i];
		var rowIndex = $("#" + gridId).datagrid('getRowIndex', iData);
		iData.rowIndex = rowIndex + 1;
	}
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}