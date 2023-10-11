/*
 * 名称:	 毒麻药品管理 - 交接班管理
 * 编写人:	 Huxt
 * 编写日期: 2021-08-01
 * csp:      pha.in.v1.narchand.csp
 * js:       pha/in/v1/narchand.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narchand.csp';
PHA_COM.App.Name = $g('交接班管理');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function () {
	InitDict();
	InitGridNarcHand();
	InitEvents();
	InitConfig();
});

// 初始化 - 表单字典
function InitDict() {
	$('#startTime').timespinner({
	    showSeconds: true
	});
	$('#endTime').timespinner({
	    showSeconds: true
	});
	PHA.ComboBox('locId', {
		placeholder: '科室...',
		disabled: true,
		width: 220,
		url: PHA_STORE.CTLoc().url + '&HospId=' + session['LOGON.HOSPID'],
		onSelect: function(record){
			ResetStart(record.RowId);
		}
	});
	PHA.ComboBox('poisonIdStr', {
		placeholder: '管制分类...',
		width: 220,
		url: PHA_STORE.PHCPoison().url,
		disabled: true,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function (data) {
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});
	PHA.ComboBox('fromUserId', {
		placeholder: '交班人...',
		selectOnNavigation: false,
		url: PHA_STORE.SSUser(session['LOGON.CTLOCID']).url,
		onSelect: function(record){
			UpdateGrid('fromUserId', 'fromUserName', record);
		}
	});
	PHA.ComboBox('toUserId', {
		placeholder: '接班人...',
		selectOnNavigation: false,
		url: PHA_STORE.SSUser(session['LOGON.CTLOCID']).url,
		onSelect: function(record){
			UpdateGrid('toUserId', 'toUserName', record);
		}
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('locId', session['LOGON.CTLOCID']);
	$('#startTime').timespinner('setValue', PHA_UTIL.SysTime('t'));
	$('#endTime').timespinner('setValue', PHA_UTIL.SysTime('t'));
	ResetStart(session['LOGON.CTLOCID']);
}
function ResetStart(locId){
	var lastEdTime = tkMakeServerCall('PHA.IN.NarcHand.Query', 'GetEndTime', locId);
	if (lastEdTime != '') {
		$('#startDate').datebox('options').notUpdate = true;
		var lastEdTimeArr = lastEdTime.split(' ');
		var edDate = lastEdTimeArr[0];
		var edTime = lastEdTimeArr[1];
		$('#startDate').datebox('disable');
		$('#startTime').timespinner('disable');
		$('#startDate').datebox('setValue', edDate);
		$('#startTime').timespinner('setValue', edTime);
	} else {
		$('#startDate').datebox('enable');
		$('#startTime').timespinner('enable');
	}
	$('#fromUserId').combobox('reload', PHA_STORE.SSUser(locId).url);
	$('#toUserId').combobox('reload', PHA_STORE.SSUser(locId).url);
	$('#fromUserId').combobox('setValue', '');
	$('#toUserId').combobox('setValue', '');
}

// 初始化 - 事件
function InitEvents() {
	$('#btnFind').on('click', QueryNarcHand);
	$('#btnFindNo').on('click', NarcHandFindNo);
	$('#btnSave').on('click', NarcHandSave);
	$('#btnComplete').on('click', NarcHandComplete);
	$('#btnCancel').on('click', NarcHandCancel);
	$('#btnDelete').on('click', NarcHandDelete);
	$('#btnClear').on('click', ClearScreen);
}

// 初始化 - 表格
function InitGridNarcHand() {
	var columns = [[{
				field: "incib",
				title: 'incib',
				width: 80,
				hidden: true
			}, {
				field: "locId",
				title: 'locId',
				width: 80,
				hidden: true
			}, {
				field: "pinhi",
				title: 'pinhi',
				width: 80,
				hidden: true
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 120
			}, {
				field: "inciDesc",
				title: '药品名称',
				width: 180
			}, {
				field: "inciSpec",
				title: '规格',
				width: 100
			}, {
				field: 'batNo',
				title: '批号',
				width: 110
			}, {
				field: 'uomId',
				title: '单位ID',
				width: 60,
				hidden:true
			}, {
				field: 'uomDesc',
				title: '单位',
				width: 60
			}, {
				field: 'lastEdQty',
				title: '上次交接数量',
				width: 100,
				align: 'right'
			}, {
				field: 'startQty',
				title: '初始库存',
				width: 80,
				align: 'right',
				styler: function(value, rowData, rowIndex){
					if (value != rowData.lastEdQty && rowData.hasHandRecord == 'Y'){
						return 'background-color:#ffee00;color:red;';
					}
					return '';
				}
			}, {
				field: 'plusQty',
				title: '增加数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:green;">' + value + '</label>';
				}
			}, {
				field: 'minusQty',
				title: '减少数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'endQty',
				title: '当前库存',
				width: 80,
				align: 'right'
			}, {
				field: 'diffQty',
				title: '差异',
				width: 60,
				align: 'right',
				styler: function (value, rowData, rowIndex) {
					if (value != 0) {
						return 'background-color:#ffee00;color:red;';
					}
					return '';
				}
			}, {
				field: 'fromUserId',
				title: '交班人ID',
				width: 90,
				hidden: true
			}, {
				field: 'fromUserName',
				title: '交班人',
				width: 110
			}, {
				field: 'toUserId',
				descField: 'toUserName',
				title: '接班人',
				width: 110,
				formatter: function (value, rowData, index) {
					return rowData['toUserName'];
				},
				editor: PHA_GridEditor.ComboBox({
					mode: 'remote',
					url: $URL + '?ClassName=PHA.IN.NarcHand.Query&MethodName=GetUserData',
					onBeforeLoad: function (param) {
						var userId = $('#toUserId').combobox('getValue');
						param.userId = userId;
					}
				})
			}, {
				field: 'remarks',
				title: '备注',
				width: 180,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: 'manfName',
				title: '生产企业',
				width: 180
			}, {
				field: 'vendDesc',
				title: '经营企业',
				width: 180
			}, {
				field: 'expDate',
				title: '效期',
				width: 90
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcHand.Query',
			QueryName: 'NarcHandItm',
			hospId: PHA_COM.VAR.hospId,
			page: 1,
			rows: 9999
		},
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		pagination: false,
		toolbar: '#gridNarcHandBar',
		gridSave: true,
		isCellEdit: true,
		onClickCell: function(index, field, value){
			PHA_GridEditor.Edit({
				gridID: 'gridNarcHand',
				index: index,
				field: field
			});
		},
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {}
	};
	PHA.Grid("gridNarcHand", dataGridOption);
}

// 查询
function QueryNarcHand() {
	var formData = GetFormData(true);
	if (formData == null) {
		return;
	}
	var pJsonStr = JSON.stringify(formData);
	var chkRetStr = tkMakeServerCall('PHA.IN.NarcHand.Query', 'CheckDateTime', pJsonStr);
	var chkRetArr = chkRetStr.split('^');
	if (chkRetArr[0] < 0) {
		PHA.Popover({
			msg: chkRetArr[1],
			type: "alert"
		});
		return;
	}
	
	$('#gridNarcHand').datagrid('options').url = $URL;
	$('#gridNarcHand').datagrid('query', {
		pJsonStr: pJsonStr,
		hospId: PHA_COM.VAR.hospId,
		page: 1,
		rows: 9999
	});
}

// 保存
function NarcHandSave(){
	PHA_GridEditor.End('gridNarcHand');
	// 主表数据
	var formData = GetFormData(true);
	if (formData == null) {
		return;
	}
	formData.userId = session['LOGON.USERID'];
	var mainJson = JSON.stringify(formData);
	// 子表数据
	var dgRows = $('#gridNarcHand').datagrid('getRows') || [];
	if (dgRows.length == 0) {
		PHA.Popover({
			msg: '没有需要保存的数据',
			type: "alert"
		});
		return;
	}
	for (var i = 0; i < dgRows.length; i++) {
		var iData = dgRows[i];
		if (iData.lastEdQty != iData.startQty && iData.hasHandRecord == 'Y') {
			PHA.Popover({
				msg: '第' + (i + 1) + '行, 上次交接数量和本次交接的初始库存不一致!',
				type: "alert"
			});
			return;
		}
	}
	var detailJson = JSON.stringify(dgRows);
	// 保存后台
	var retStr = tkMakeServerCall('PHA.IN.NarcHand.Save', 'SaveNarcHand', mainJson, detailJson);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '保存成功!',
		type: "success"
	});
	// 展示单据
	ShowMainData(retStr);
	QueryNarcHand();
}

// 完成
function NarcHandComplete(){
	var formData = GetFormData(true);
	if (formData == null) {
		return;
	}
	var handNo = formData.handNo || '';
	var retStr = tkMakeServerCall('PHA.IN.NarcHand.Save', 'NarcHandComplete', '', handNo);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '操作成功!',
		type: "success"
	});
	// 展示单据
	ShowMainData(retStr);
	QueryNarcHand();
}

// 取消完成
function NarcHandCancel(){
	var formData = GetFormData(true);
	if (formData == null) {
		return;
	}
	var handNo = formData.handNo || '';
	var retStr = tkMakeServerCall('PHA.IN.NarcHand.Save', 'NarcHandCancel', '', handNo);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert("温馨提示", retArr[1], retArr[0]);
		return;
	}
	PHA.Popover({
		msg: '操作成功!',
		type: "success"
	});
	// 展示单据
	ShowMainData(retStr);
	QueryNarcHand();
}

// 删除交接单
function NarcHandDelete(){
	var handNo = $('#handNo').val();
	if (handNo == '') {
		PHA.Popover({
			msg: '单号为空或者未保存!',
			type: "alert"
		});
		return;
	}
	PHA.Confirm('温馨提示', '是否确认删除此交接单？', function () {
		var formData = GetFormData();
		var handNo = formData.handNo || '';
		var saveRet = $.cm({
			ClassName: 'PHA.IN.NarcHand.Save',
			MethodName: 'Delete',
			pinh: '',
			handNo: handNo,
			dataType: 'text'
		}, false);
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('温馨提示', saveInfo, saveVal);
			return;
		} else {
			PHA.Popover({
				msg: '删除成功!',
				type: 'success'
			});
			ClearScreen();
		}
	});
}

function ShowMainData(pinh){
	var mainDataStr = tkMakeServerCall('PHA.IN.NarcHand.Query', 'GetNarcHandData', pinh);
	var mainData = JSON.parse(mainDataStr);
	ChangeFormStatus('disable');
	PHA.SetVals([mainData]);
}

// 查询单号
function NarcHandFindNo(){
	Win_NarcHandOpen({
		params: null,
		onClose: null,
		onDblClick: OnDblClickCall
	});
}
function OnDblClickCall(rowData){
	ChangeFormStatus('disable');
	if (rowData.status == '20') {
		rowData.isComplete = 'Y';
	}
	PHA.SetVals([rowData]);
	QueryNarcHand();
	
	$('#fromUserId').combobox('reload', PHA_STORE.SSUser(rowData.locId).url);
	$('#toUserId').combobox('reload', PHA_STORE.SSUser(rowData.locId).url);
	PHA.SetComboVal('fromUserId', rowData.fromUserId);
	PHA.SetComboVal('toUserId', rowData.toUserId);
}

// 清屏
function ClearScreen(){
	ChangeFormStatus('enable');
	PHA.DomData('#gridNarcHandBar', {
		doType: 'clear'
	});
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr'] || '');
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.EdDate']));
	$('#gridNarcHand').datagrid('loadData', []);
	InitDictVal();
}

// 修改表单可用状态
function ChangeFormStatus(_status){
	$('#startDate').datebox(_status);
	$('#startTime').timespinner(_status);
	$('#endDate').datebox(_status);
	$('#endTime').timespinner(_status);
	$('#locId').combobox(_status);
}

// 获取表单数据
function GetFormData(showTips){
	var formDataArr = PHA.DomData("#gridNarcHandBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	var fromUserId = formData.fromUserId;
	var toUserId = formData.toUserId;
	if (fromUserId == toUserId) {
		if (showTips) {
			PHA.Popover({
				msg: '交班人和接班人不能相同!',
				type: "alert"
			});
		}
		return null;
	}
	return formData;
}

// 初始化配置
function InitConfig() {
	$.cm({
		ClassName: 'PHA.IN.Narc.Com',
		MethodName: 'GetConfigParams',
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
		if ($('#startDate').datebox('options').notUpdate != true) {
			$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.StDate']));
		}
		$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr'] || '');
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}

function UpdateGrid(gField, gDescField, record){
	var rowsData = $('#gridNarcHand').datagrid('getRows');
	var gRows = rowsData.length;
	for (var i = 0; i < gRows; i++) {
		var iData = {};
		iData[gField] = record.RowId;
		iData[gDescField] = record.Description;
		$('#gridNarcHand').datagrid('updateRow',{
			index: i,
			row: iData
		});
	}
}

function toFloat(_num){
	_num = parseFloat(_num);
	if (isNaN(_num)) {
		return 0;
	}
	return _num;
}


// ========================================
// 交接单查询弹窗
function Win_NarcHandOpen(_options){
	var winId = 'win_winHarcHand';
	var winContentId = 'win_winHarcHand_content';
	_options.winId = winId;
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		var contentStr = $("#" + winContentId).html();
		$('#' + winId).dialog({
			width: parseInt($(document.body).width() * 0.9),
	    	height: parseInt($(document.body).height() * 0.9),
	    	modal: true,
	    	title: "毒麻药品管理 - 交接单查询",
	    	iconCls: 'icon-w-find',
	    	content: contentStr,
	    	closable: true,
	    	onClose: function() {
		    	_options.onClose && _options.onClose();
		    }
		});
		Win_InitLayout(_options);
	}
	Win_Clear();
	$('#' + winId).dialog('open');
}
function Win_InitLayout(_options){
	Win_InitDict(_options);
	Win_InitGridNarcHand(_options);
	Win_InitGridNarcHandItm(_options);
	Win_InitEvent(_options);
}
function Win_InitEvent(_options){
	$('#win_btnFind').on('click', Win_QueryNarcHand);
	$('#win_btnClear').on('click', Win_Clear);
}
function Win_InitDict(_options){
	PHA.ComboBox('win_locId', {
		placeholder: '科室...',
		width: 270,
		url: PHA_STORE.CTLoc().url + '&HospId=' + session['LOGON.HOSPID']
	});
	Win_InitDictVal(_options);
}
function Win_InitDictVal(_options){
	$('#win_startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.StDate']));
	$('#win_endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Hand.EdDate']));
	PHA.SetComboVal('win_locId', session['LOGON.CTLOCID']);
}
function Win_InitGridNarcHand(_options){
	var columns = [[{
				field: "pinh",
				title: 'pinh',
				width: 80,
				hidden: true
			}, {
				field: 'handNo',
				title: '交接单号',
				width: 136
			}, {
				field: "stTime",
				title: '开始时间',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.startDate + ' ' + rowData.startTime;
				}
			}, {
				field: "edTime",
				title: '截止时间',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.endDate + ' ' + rowData.endTime;
				}
			}, {
				field: "ctTime",
				title: '创建时间',
				width: 150,
				formatter: function(value ,rowData, rowIndex){
					return rowData.createDate + ' ' + rowData.createTime;
				}
			}, {
				field: "createUserName",
				title: '创建人',
				width: 100
			}, {
				field: 'locDesc',
				title: '科室',
				width: 100
			}, {
				field: 'remarks',
				title: '备注',
				width: 110
			}, {
				field: 'statusDesc',
				title: '状态',
				width: 60
			}, {
				field: 'fromUserName',
				title: '交班人',
				width: 80
			}, {
				field: 'toUserName',
				title: '接班人',
				width: 80
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcHand.Query',
			QueryName: 'NarcHand',
			hospId: PHA_COM.VAR.hospId,
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#win_gridNarcHandBar',
		gridSave: false,
		onSelect: function (rowIndex, rowData) {
			Win_QueryNarcHandItm();
		},
		onDblClickRow: function(rowIndex, rowData) {
			$('#' + _options.winId).dialog('close');
			_options.onDblClick && _options.onDblClick(rowData);
		},
		onLoadSuccess: function (data) {
			if (data.total == 0) {
				$('#win_gridNarcHandItm').datagrid('loadData', []);
			}
		}
	};
	PHA.Grid("win_gridNarcHand", dataGridOption);
}
function Win_InitGridNarcHandItm(_options){
	var columns = [[{
				field: "incib",
				title: 'incib',
				width: 80,
				hidden: true
			}, {
				field: "locId",
				title: 'locId',
				width: 80,
				hidden: true
			}, {
				field: 'inciCode',
				title: '药品代码',
				width: 120
			}, {
				field: "inciDesc",
				title: '药品名称',
				width: 180
			}, {
				field: "inciSpec",
				title: '规格',
				width: 100
			}, {
				field: 'batNo',
				title: '批号',
				width: 110
			}, {
				field: 'uomId',
				title: '单位ID',
				width: 60,
				hidden:true
			}, {
				field: 'uomDesc',
				title: '单位',
				width: 60
			}, {
				field: 'lastEdQty',
				title: '上次交接数量',
				width: 100,
				align: 'right'
			}, {
				field: 'startQty',
				title: '初始库存',
				width: 80,
				align: 'right'
			}, {
				field: 'plusQty',
				title: '增加数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:green;">' + value + '</label>';
				}
			}, {
				field: 'minusQty',
				title: '减少数量',
				width: 80,
				align: 'right',
				formatter: function (value, rowData, rowIndex) {
					return '<label style="color:red;">' + value + '</label>';
				}
			}, {
				field: 'endQty',
				title: '当前库存',
				width: 80,
				align: 'right'
			}, {
				field: 'fromUserName',
				title: '交班人',
				width: 110
			}, {
				field: 'toUserName',
				title: '接班人',
				width: 110
			}, {
				field: 'remarks',
				title: '备注',
				width: 180
			}, {
				field: 'manfName',
				title: '生产企业',
				width: 180
			}, {
				field: 'vendDesc',
				title: '经营企业',
				width: 180
			}, {
				field: 'expDate',
				title: '效期',
				width: 90
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.NarcHand.Query',
			QueryName: 'NarcHandItm',
			hospId: PHA_COM.VAR.hospId
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: [],
		gridSave: false,
		onSelect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {}
	};
	PHA.Grid("win_gridNarcHandItm", dataGridOption);
}
function Win_QueryNarcHand(){
	var formDataArr = PHA.DomData("#win_gridNarcHandBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return null;
	}
	var formData = formDataArr[0];
	var newData = {};
	for (var k in formData) {
		var nk = k.toString().replace('win_', '');
		newData[nk] = formData[k];
	}
	var pJsonStr = JSON.stringify(newData);
	
	$('#win_gridNarcHand').datagrid('options').url = $URL;
	$('#win_gridNarcHand').datagrid('query', {
		pJsonStr: pJsonStr,
		hospId: PHA_COM.VAR.hospId
	});
	$('#win_gridNarcHandItm').datagrid('loadData', []);
}
function Win_QueryNarcHandItm(){
	var selRow = $('#win_gridNarcHand').datagrid('getSelected');
	if (selRow == null) {
		return;
	}
	var pJsonStr = JSON.stringify(selRow);
	
	$('#win_gridNarcHandItm').datagrid('options').url = $URL;
	$('#win_gridNarcHandItm').datagrid('query', {
		pJsonStr: pJsonStr,
		hospId: PHA_COM.VAR.hospId
	});
}
function Win_Clear(){
	PHA.DomData("#win_gridNarcHandBar", {
		doType: 'clear'
	});
	Win_InitDictVal();
	$('#win_gridNarcHand').datagrid('loadData', []);
	$('#win_gridNarcHandItm').datagrid('loadData', []);
}
