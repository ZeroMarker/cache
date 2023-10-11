/**
 * 名称:   	 药房药库-毒麻药品销毁制单
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.win.csp
 * js:		 pha/in/v1/narcdestroy.win.js
 */

function OpenNarcDestroyWin(_options){
	var winId = "narcdestroy_win_main";
	var winContentId = "narcdestroy_win_main_html";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		var contentStr = $("#" + winContentId).html();
		$('#' + winId).dialog({
			width: parseInt($(document.body).width() * 0.97),
	    	height: parseInt($(document.body).height() * 0.97),
	    	modal: true,
	    	title: "毒麻药品管理 - 空安瓿/废贴销毁制单",
	    	iconCls: 'icon-w-pen-paper',
	    	content: contentStr,
	    	closable: true,
	    	onClose: function() {
		    	var pind = $('#win_pind').val() || "";
		    	_options.onClose && _options.onClose(pind);
		    }
		});
		InitWinLayout(_options);
	}
	$('#' + winId).dialog('open');
	
	InitWinData(_options);
}

// 初始化 - 入口
function InitWinLayout(_options){
	InitGridDestroyItm();
	InitWinDict();
	InitWinEvents();
}

// 初始化 - 表单字典
function InitWinDict(){
	// 销毁单信息
	$('#win_pindNo').val('');
	$('#win_pindDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.ComboBox("win_pindLocId", {
		url: PHA_STORE.CTLoc().url + "&HospId=" + session['LOGON.HOSPID'],
		onLoadSuccess: function(data){
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == session['LOGON.CTLOCID']) {
					// $('#win_pindLocId').combobox('setValue', iData.RowId);
				}
			}
		}
	});
	// 多选触发框
	var winOpts = {
		placeholder: '输入姓名、简拼或工号， 回车检索...',
		name: 'win_UserSel',
		width: 700,
		height: 450,
		grid_columns: [[
			{field:'RowId', title:'RowId', width:60, hidden:true},
			{field:'UserCode', title:'工号', width:100},
			{field:'Description', title:'姓名', width:120}
		]],
		grid_queryParams: {
			ClassName: 'PHA.STORE.Org',
			QueryName: 'SSUser',
			HospId: session['LOGON.HOSPID']
		}
	}
	TriggerBox_MultiSel.Init({
		triggerboxOpts: {
			winTitle: '选择销毁执行人',
			id: 'win_pindExeUser',
			width: 160
		},
		winOpts: winOpts
	});
	TriggerBox_MultiSel.Init({
		triggerboxOpts: {
			winTitle: '选择销毁批准人',
			id: 'win_pindAuditUser',
			width: 160
		},
		winOpts: winOpts
	});
	TriggerBox_MultiSel.Init({
		triggerboxOpts: {
			winTitle: '选择销毁监督人',
			id: 'win_pindSuperUser',
			width: 160
		},
		winOpts: winOpts
	});
	
	$('#pindPlace').val('');
	PHA.ComboBox("win_pindType", {
		url: $URL + '?ClassName=PHA.IN.Narc.Com&QueryName=ComDic&ResultSetType=array',
		onBeforeLoad: function(param){
			var scdiType = "NARCDestroyType";
			var valType = "code";
			var QText = param.q || "";
			param.InputStr = scdiType + "^" + valType + "^" + QText;
		}
	});
	
	// 明细查询条件
	$('#win_startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#win_endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	PHA.ComboBox("win_docLoc", {
		width: 130,
		placeholder: '开单科室...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("win_recState", {
		width: 130,
		placeholder: '请选择登记状态...',
		disabled: true,
		data: [
			{RowId: 'A', Description: '全部'},
			{RowId: 'N', Description: '未回收'},
			{RowId: 'Y', Description: '已回收'}
		],
		panelHeight: 'auto'
	});
	$('#win_recState').combobox('setValue', 'Y');
	
	PHA.ToggleButton('win_BMore', {
		buttonTextArr: ['更多', '隐藏'],
		selectedText: '更多',
		onClick: function(oldText, newText){
			if (oldText == '更多') {
				$("#gridToNarcDestroyBar-row2").show(100, function(){
					$('#win_layout_left').layout('resize');
				});
			} else {
				$("#gridToNarcDestroyBar-row2").hide(100, function(){
					$('#win_layout_left').layout('resize');
				});
			}
		}
	});
}

// 初始化 - 事件绑定
function InitWinEvents() {
	// 按钮
	$('#win_btnSave').on("click", WinSave);
    $('#win_btnClear').on("click", WinClear);
    $('#win_btnByRec').on("click", AddByRec);
    $('#win_btnByScrap').on("click", AddByScrap);
    $('#win_btnDel').on("click", WinDel);
}

// 初始化 - 明细表格
function InitGridDestroyItm(){
	var columns = [
		[{
				title: "pind",
				field: "pind",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} ,{
				title: "pindi",
				field: "pindi",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "inci",
				field: "inci",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "药品代码",
				field: "inciCode",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "药品名称",
				field: "inciDesc",
				width: 200,
				align: "left",
				sortable: true,
				showTip: true,
				tipWidth: 200
			} , {
				title: "规格",
				field: "inciSpec",
				width: 90,
				align: "left",
				sortable: true
			} , {
				title: "批号",
				field: "pindiBatchNo",
				width: 90,
				align: "left",
				sortable: true
			} , {
				title: GetEditTitle("空安瓿数量"),
				field: "pindiQty",
				width: 100,
				align: "right",
				editor: PHA_GridEditor.ValidateBox({
					checkValue: function(val, chkRet){
						if (isNaN(val)) {
							chkRet.msg = "请输入数字!";
							return false;
						}
						val = parseFloat(val);
						if (val < 0) {
							chkRet.msg = "不能小于0!";
							return false;
						}
						return true;
					}
				})
			} , {
				title: "空安瓿单位",
				field: "pindiUomDesc",
				width: 85,
				align: "center",
				sortable: true
			}, {
				title: "pindiUomId",
				field: "pindiUomId",
				width: 85,
				align: "center",
				sortable: true,
				hidden: true
			}, {
				title: GetEditTitle("销毁液体残量"),
				field: "pindiFluidQty",
				width: 100,
				align: "center",
				editor: PHA_GridEditor.ValidateBox({
					checkValue: function(val, chkRet){
						if (isNaN(val)) {
							chkRet.msg = "请输入数字!";
							return false;
						}
						val = parseFloat(val);
						if (val < 0) {
							chkRet.msg = "不能小于0!";
							return false;
						}
						return true;
					},
					onBeforeNext: function (val, gridRowData, gridRowIdex) {
						// 最后一行最后一列
						if (PHA_GridEditor.IsLastRow()) {
							PHA_GridEditor.End('gridDestroyItm');
							return false;
						}
						return true;
					}
				})
			} , {
				title: "pindiFluidUomId",
				field: "pindiFluidUomId",
				width: 75,
				align: "center",
				sortable: true,
				hidden: true
			} , {
				title: "液体单位",
				field: "pindiFluidUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "执行记录ID",
				field: "oeore",
				width: 100,
				align: "left",
				sortable: true,
				formatter: function(value, rowData, index){
					if (value != "") {
						return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>";
					}
					return "";
				}
			} , {
				title: "报损子表ID",
				field: "inspi",
				width: 100,
				align: "left",
				sortable: true,
				formatter: function(value, rowData, index){
					if (value != "") {
						return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>";
					}
					return "";
				}
			} 
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcDestroy.Query',
			QueryName: 'NarcDestroyItm'
		},
		singleSelect: true,
		pagination: true,
		pageSize: 500,
		columns: columns,
		toolbar: "#gridDestroyItmBar",
		isCellEdit: false,
		isAutoShowPanel: true,
		editFieldSort: ["pindiQty", "pindiFluidQty"],
		onClickCell: function(index, field, value) {
			var rowsData = $(this).datagrid('getRows');
			var rowData = rowsData[index];
			if (field == 'oeore' && value != "") {
				var oeore = rowData.oeore || "";
				OeoreDetailWin(oeore);
				return;
			}
			if (field == 'inspi' && value != "") {
				var inspi = rowData.inspi || "";
				InspiDetailWin(inspi);
				return;
			}
			if (!PHA_GridEditor.End('gridDestroyItm')){
				return;
			}
			PHA_GridEditor.Edit({
				gridID: "gridDestroyItm",
				index: index,
        		field: field
			});
		},
        onLoadSuccess: function(data){
	        PHA_GridEditor.End('gridDestroyItm');
	        $(this).datagrid('uncheckAll');
	    }
	};
	PHA.Grid("gridDestroyItm", dataGridOption);
}

// 初始化 - 表单数据
function InitWinData(_options){
	var pind = _options.pind || "";
	if (pind == "") {
		SetMainData({
			patNo: _options.patNo || "",
			pindDate: PHA_UTIL.SysDate('t'),
			pindLocId: session['LOGON.CTLOCID'],
			pindLocDesc: tkMakeServerCall('PHA.IN.Narc.Com', 'GetLocDesc', session['LOGON.CTLOCID'])
		});
		WinQuery();
		return;
	}
	
	var InputStr = JSON.stringify({pind: pind});
	$.cm({
		ClassName: 'PHA.IN.NarcDestroy.Query',
		QueryName: 'NarcDestroy',
		InputStr: InputStr,
		ResultSetType: 'array',
		dataType: 'json'
	}, function(data){
		if (data.length > 0) {
			SetMainData(data[0]);
			WinQuery();
		}
	}, function(xhr){
		alert(xhr.responseText);
	});
}


/*
* 界面操作
*/
function WinQuery() {
	var pind = $('#win_pind').val() || "";
	var InputStr = JSON.stringify({pind: pind});
	$('#gridDestroyItm').datagrid('query', {
		InputStr: InputStr
	});
}

function WinClear(){
	PHA.DomData("#win_layout_left", {doType: 'clear'});
	TriggerBox_Set_User('win_pindExeUser', '');
	TriggerBox_Set_User('win_pindAuditUser', '');
	TriggerBox_Set_User('win_pindSuperUser', '');
	$('#gridDestroyItm').datagrid('clear');
}

function WinSave(){
	// 主表信息
	var mainData = GetMainData();
	if (mainData == null) {
		return;
	}
	var mainStr = JSON.stringify(mainData);
	
	// 子表信息
	PHA_GridEditor.End('gridDestroyItm');
	var rowsData = $('#gridDestroyItm').datagrid('getRows');
	if (rowsData == null || rowsData.length == 0) {
		PHA.Popover({
			msg: '没有需要保存的明细!',
			type: "info"
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridDestroyItm');
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	var detailStr = JSON.stringify(rowsData);
	
	// 保存
	var saveRetStr = tkMakeServerCall('PHA.IN.NarcDestroy.Save', 'SaveOrder', mainStr, detailStr);
	var saveRetArr = saveRetStr.split('^');
	if (saveRetArr[0] < 0) {
		PHA.Alert("提示", saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '保存成功!',
			type: "success"
		});
		$('#win_pind').val(saveRetArr[0]);
		$('#narcdestroy_win_main').dialog('close');
	}
}

function GetMainData(){
	var pind = $('#win_pind').val();
	var pindNo = $('#win_pindNo').val();
	var pindLocId = session['LOGON.CTLOCID'];
	var pindExeUser = TriggerBox_Get_User('win_pindExeUser');
	if (pindExeUser == '') {
		PHA.Popover({
			msg: "销毁执行人不能为空",
			type: "alert",
			style: {top: 20, left: ""}
		});
		return null;
	}
	var pindAuditUser = TriggerBox_Get_User('win_pindAuditUser');
	if (pindAuditUser == '') {
		PHA.Popover({
			msg: "销毁批准人不能为空",
			type: "alert",
			style: {top: 20, left: ""}
		});
		return null;
	}
	var pindSuperUser = TriggerBox_Get_User('win_pindSuperUser');
	if (pindSuperUser == '') {
		PHA.Popover({
			msg: "销毁监督人不能为空",
			type: "alert",
			style: {top: 20, left: ""}
		});
		return null;
	}
	var pindType = $('#win_pindType').combobox('getValue') || '';
	var pindPlace = $('#win_pindPlace').val();
	return {
		pind: pind,
		pindNo: pindNo,
		pindLocId: pindLocId,
		pindExeUser: pindExeUser,
		pindAuditUser: pindAuditUser,
		pindSuperUser: pindSuperUser,
		pindType: pindType,
		pindPlace: pindPlace
	}
}

function SetMainData(data){
	var pind = data.pind || "";
	var pindNo = data.pindNo || "";
	var pindDate = data.pindDate || "";
	var pindTime = data.pindTime || "";
	var pindExeUser = data.pindExeUser || ""; // ID串
	var pindExeUserStr = data.pindExeUserStr || "";
	var pindAuditUser = data.pindAuditUser || ""; // ID串
	var pindAuditUserStr = data.pindAuditUserStr || "";
	var pindSuperUser = data.pindSuperUser || ""; // ID串
	var pindSuperUserStr = data.pindSuperUserStr || "";
	var pindPlace = data.pindPlace || "";
	var pindType = data.pindType || "";
	var pindTypeDesc = data.pindTypeDesc || "";
	var pindLocId = data.pindLocId || "";
	var pindLocDesc = data.pindLocDesc || "";
	
	$('#win_pind').val(pind);
	$('#win_pindNo').val(pindNo);
	$('#win_pindDate').datebox('setValue', pindDate);
	$('#win_pindLocId').combobox('setValue', pindLocId);
	$('#win_pindLocId').combobox('setText', pindLocDesc);
	
	TriggerBox_Set_User('win_pindExeUser', pindExeUser);
	TriggerBox_Set_User('win_pindAuditUser', pindAuditUser);
	TriggerBox_Set_User('win_pindSuperUser', pindSuperUser);
	
	$('#win_pindType').combobox('setValue', pindType);
	$('#win_pindType').combobox('setText', pindTypeDesc);
	$('#win_pindPlace').val(pindPlace);
}

/*
* 方式一：依据回收制单
*/
function AddByRec(){
	// 验证
	var rowsData = $('#gridDestroyItm').datagrid('getRows');
	var rowsDataLen = rowsData.length;
	for (var i = 0; i < rowsDataLen; i++) {
		var rowData = rowsData[i];
		if (rowData.inspi != "") {
			PHA.Popover({
				msg: "单据已经“依据报损”制单!",
				type: "alert"
			});
			return;
		}
	}
	// 打开弹窗
    SelectByRec({
	    onSure: OnSureByRec
	});
}

// 选择回收记录时
function OnSureByRec(selRows){
	var selRowsLen = selRows.length;
	for (var i = 0; i < selRowsLen; i++) {
		var rowData = selRows[i];
		if (ExistOeore(rowData.oeore)) {
			continue;
		}
		$('#gridDestroyItm').datagrid('appendRow',{
			oeore: rowData.oeore,
			inspi: '',
			inciCode: rowData.inciCode,
			inciDesc: rowData.inciDesc,
			inciSpec: rowData.inciSpec,
			pindiBatchNo: rowData.recBatchNo,
			pindiQty: rowData.recQty,
			pindiUomId: rowData.dspUomId,
			pindiUomDesc: rowData.dspUomDesc,
			pindiFluidQty: rowData.recFluidQty,
			pindiFluidUomId: rowData.doseUomId,
			pindiFluidUomDesc: rowData.doseUomDesc
		});
	}
}
// 检查执行记录是否存在
function ExistOeore(oeore){
	var rowsData = $('#gridDestroyItm').datagrid('getRows');
	var rowsDataLen = rowsData.length;
	for (var i = 0; i < rowsDataLen; i++) {
		var rowData = rowsData[i];
		if (rowData.oeore == oeore) {
			return true;
		}
	}
	return false;
}

/*
* 方式二：依据报损单制单
*/
function AddByScrap(){
	// 验证
	var rowsData = $('#gridDestroyItm').datagrid('getRows');
	var rowsDataLen = rowsData.length;
	for (var i = 0; i < rowsDataLen; i++) {
		var rowData = rowsData[i];
		if (rowData.oeore != "") {
			PHA.Popover({
				msg: "单据已经“依据回收”制单!",
				type: "alert"
			});
			return;
		}
	}
	// 打开弹窗
	SelectByScrap({
	    onSure: OnSureByScrap
	});
}
// 选择报损记录时
function OnSureByScrap(selRows){
	var selRowsLen = selRows.length;
	for (var i = 0; i < selRowsLen; i++) {
		var rowData = selRows[i];
		if (ExistInspi(rowData.inspi)) {
			continue;
		}
		$('#gridDestroyItm').datagrid('appendRow',{
			oeore: '',
			inspi: rowData.inspi,
			inciCode: rowData.inciCode,
			inciDesc: rowData.inciDesc,
			inciSpec: rowData.inciSpec,
			pindiBatchNo: rowData.batchNo,
			pindiQty: rowData.inspiQty || 0,
			pindiUomId: rowData.bUomId,
			pindiUomDesc: rowData.bUomDesc,
			pindiFluidQty: rowData.inspiFluidQty || 0,
			pindiFluidUomId: rowData.eUomId,
			pindiFluidUomDesc: rowData.eUomDesc
		});
	}
}
// 检查报损明细是否存在
function ExistInspi(inspi){
	var rowsData = $('#gridDestroyItm').datagrid('getRows');
	var rowsDataLen = rowsData.length;
	for (var i = 0; i < rowsDataLen; i++) {
		var rowData = rowsData[i];
		if (rowData.inspi == inspi) {
			return true;
		}
	}
	return false;
}

/*
 * 删除一条明细
 */
function WinDel(){
	var selRow = $('#gridDestroyItm').datagrid('getSelected');
	if (selRow == null) {
		PHA.Popover({
			msg: "请选择一条明细!",
			type: "alert"
		});
	}
	var pindi = selRow.pindi || '';
	
	PHA.Confirm("温馨提示", "是否确认删除？", function () {
		// 删后台
		if (pindi != '') {
			var retStr = tkMakeServerCall('PHA.IN.NarcDestroy.Save', 'DeleteItm', pindi);
			var retArr = retStr.split('^');
			if (retArr[0] < 0) {
				PHA.Alert("提示", retArr[1], retArr[0]);
				return;
			}
		}
		// 删前台
		var rowIndex = $("#gridDestroyItm").datagrid('getRowIndex', selRow);
		$("#gridDestroyItm").datagrid('deleteRow', rowIndex);
		// 提示
		PHA.Popover({
			msg: '删除成功!',
			type: "success"
		});
	});
}

function replaceKey(obj){
	var newObj = {};
	for (k in obj) {
		var kArr = k.split('_');
		var nKey = kArr.length == 2 ? kArr[1] : k;
		newObj[nKey] = obj[k];
	}
	return newObj;
}

function GetEditTitle(title){
	return title;
	//return '<label style="color:red;">*</label>' + title;
}

// =============================
// 多选触发框公共 (后期整理成一个插件)
var TriggerBox_MultiSel = {
	ICON_Add: "../scripts_lib/hisui-0.1.0/dist/css/icons/add.png",
	ICON_Remove: "../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png",
	Init: function(_options){
		var triggerboxOpts = _options.triggerboxOpts || {};
		var id = triggerboxOpts.id || "";
		if (id == "id为必填项") {
			return;
		}
		triggerboxOpts.handler = function(){
			TriggerBox_MultiSel._OpenWin(_options);
		}
		triggerboxOpts.editable = false;
		PHA.TriggerBox(id, triggerboxOpts);
		$("#" + id).next().eq(0).children().eq(0).attr('readonly', 'readonly'); // 只读
	},
	_OpenWin: function(_options){
		var triggerboxOpts = _options.triggerboxOpts || {};
		var triggerboxDomId = triggerboxOpts.id || "";
		
		var winOpts = _options.winOpts || {};
		var winId = winOpts.name || "";
		if (winId == "name为必填项") {
			return;
		}
		var winContentId = winId + "_Content";
		
		if ($('#' + winId).length == 0) {
			var winDefaultOpts = {
				width: 580,
				height: 450,
				title: "选择",
				iconCls: 'icon-w-edit',
				closable: true,
				modal: true
			}
			winOpts.content = TriggerBox_MultiSel._GetUserListHtml(_options),
			winOpts.curTriggerboxDomId = triggerboxDomId;
			winOpts.buttons = [{
				text: '确认',
				handler: function(){
					// 获取数据
					var rowsData = $('#' + winId + '_win_grid_right').datagrid('getRows');
					var valStr = "";
					var txtStr = "";
					for (var i = 0; i < rowsData.length; i++) {
						var _iData = rowsData[i];
						valStr = valStr == "" ? _iData.RowId : (valStr + "," + _iData.RowId);
						txtStr = txtStr == "" ? _iData.Description : (txtStr + "," + _iData.Description);
					}
					// 将数据绑定到Triggerbox
					var _winOpts = $('#' + winId).dialog('options');
					var _curTriggerboxDomId = _winOpts.curTriggerboxDomId;
					TriggerBox_MultiSel.SetVal({
						id: _curTriggerboxDomId,
						type: 'array',
						val: rowsData
					});
					TriggerBox_MultiSel.SetVal({
						id: _curTriggerboxDomId,
						type: 'value',
						val: valStr
					});
					TriggerBox_MultiSel.SetVal({
						id: _curTriggerboxDomId,
						type: 'text',
						val: txtStr
					});
					$('#' + winId).dialog('close');
				}
			}, {
				text: '取消',
				handler: function(){
					$('#' + winId).dialog('close');
				}
			}];
			var newWinOpts = $.extend({}, winDefaultOpts, winOpts);
			$("<div id='" + winId + "'></div>").appendTo("body");
			$('#' + winId).dialog(newWinOpts);
			// 样式修改
			var dialogBody = $('#' + winId).dialog('body').children().eq(0).children().eq(0).children().eq(0);
			dialogBody.parent().addClass('pha-scrollbar-hidden');
			dialogBody.addClass('pha-scrollbar-hidden-chl');
			dialogBody.css('overflow', 'hidden');
			// 初始化表格
			this._InitWinGrid(_options);
			// 初始化事件
			var placeholder = winOpts.placeholder || "请输入查询条件..."
			PHA.SearchBox(winId + '_win_txt_QText', {
				placeholder: placeholder,
				searcher: function(){
					TriggerBox_MultiSel._QueryGridLeft(_options)
				}
			});
		}
		$('#' + winId + '_win_grid_left').datagrid('clear');
		$('#' + winId).dialog('setTitle', (triggerboxOpts.winTitle || "选择"));
		$('#' + winId).dialog('open');
		$('#' + winId + '_win_txt_QText').searchbox('setValue', '');
		$('#' + winId + '_win_txt_QText').next().children().eq(0).focus();
		$('#' + winId + '_win_txt_QText').attr('open', 'Y');
		// 默认查询数据
		TriggerBox_MultiSel._QueryGridLeft(_options);
		// 查询右侧已选
		var winOpts = $('#' + winId).dialog('options');
		var rRowsData = TriggerBox_MultiSel.GetVal({
			id: triggerboxDomId,
			type: 'array'
		});
		$('#' + winId + '_win_grid_right').datagrid('loadData', rRowsData);
		// 记录当前操作的ID
		winOpts.curTriggerboxDomId = triggerboxDomId;
	},
	// =====================================
	_InitWinGrid: function(_options){
		var winOpts = _options.winOpts;
		var winId = winOpts.name || "";
		var columns0 = winOpts.grid_columns[0];
		
		// 左侧表格
		var leftColumns = [];
		for (var i = 0; i < columns0.length; i++) {
			leftColumns.push(columns0[i]);
		}
		leftColumns.push({
			title: "操作",
			field: "op",
			width: 45,
			align: "center",
			formatter: function(value, rowData, rowIndex){
				var inputStr = winId + "^" + rowIndex;
				return "<img src='" + TriggerBox_MultiSel.ICON_Add + "' style='border:0px;cursor:pointer' onclick=TriggerBox_MultiSel._AddRowData('" + inputStr + "') />";
			}
		});
		var dataGridOption = {
			singleSelect: true,
			pagination: false,
			columns: [leftColumns],
			fitColumns: true,
			toolbar: '#' + winId + '_win_txt_wrap',
			loadFilter: function(data){
				// 已选择的则不加载 Huxt 2022-07-07
				var idArr = [];
				var rightRows = $('#' + winId + "_win_grid_right").datagrid('getRows');
				for (var i = 0; i < rightRows.length; i++) {
					idArr.push(rightRows[i].RowId);
				}
				var newData = [];
				for (var i = 0; i < data.length; i++) {
					var iData = data[i];
					if (idArr.indexOf(iData.RowId) >= 0 ) {
						continue;
					}
					newData.push(iData);
				}
				return {
					rows: newData,
					total: newData.length
				};
			},
			onBeforeLoad: function(param){
				if ($('#' + winId + '_win_txt_QText').attr('open') == 'Y') {
					$('#' + winId + '_win_txt_QText').attr('open', 'N');
					return false;
				}
				return true;
			}
		};
		PHA.Grid(winId + "_win_grid_left", dataGridOption);
		
		// 右侧表格
		var rightColumns = [];
		for (var i = 0; i < columns0.length; i++) {
			rightColumns.push(columns0[i]);
		}
		rightColumns.push({
			title: "操作",
			field: "op",
			width: 45,
			align: "center",
			formatter: function(value, rowData, rowIndex){
				var inputStr = winId + "^" + rowIndex;
				return "<img src='" + TriggerBox_MultiSel.ICON_Remove + "' style='border:0px;cursor:pointer' onclick=TriggerBox_MultiSel._RemoveRowData('" + inputStr + "') />";
			}
		});
		var dataGridOption = {
			singleSelect: true,
			pagination: false,
			columns: [rightColumns],
			fitColumns: true,
			toolbar: [],
			onLoadSuccess: function(data){
				$('#' + winId + '_win_grid_left').datagrid('reload');
			}
		};
		PHA.Grid(winId + "_win_grid_right", dataGridOption);
	},
	_QueryGridLeft: function(_options){
		var winOpts = _options.winOpts || {};
		var winId = winOpts.name || "";
		
		$('#' + winId + '_win_grid_left').datagrid('options').url = $URL + "?ResultSetType=array";
		var QText = $('#' + winId + '_win_txt_QText').searchbox('getValue') || "";
		var winOpts = _options.winOpts;
		var queryParams = winOpts.grid_queryParams || {};
		queryParams.QText = QText;
		$('#' + winId + '_win_grid_left').datagrid('load', queryParams);
	},
	_AddRowData: function(inputStr){
		var inputArr = inputStr.split('^');
		var winId = inputArr[0];
		var rowIndex = inputArr[1];
		var lRowsData = $('#' + winId + '_win_grid_left').datagrid('getRows');
		var lCurRowData = lRowsData[rowIndex];
		var existFlag = false;
		var rRowsData = $('#' + winId + '_win_grid_right').datagrid('getRows');
		if (rRowsData.length > 30) {
			PHA.Popover({
				msg: "您添加的人数过多",
				type: "alert"
			});
			return;
		}
		for (var i = 0; i < rRowsData.length; i++) {
			var rowData = rRowsData[i];
			if (rowData.RowId == lCurRowData.RowId) {
				existFlag = true;
				PHA.Popover({
					msg: "已存在",
					type: "alert"
				});
				break;
			}
		}
		if (existFlag == false) {
			rRowsData.push(lCurRowData);
		}
		$('#' + winId + '_win_grid_right').datagrid('loadData', rRowsData);
	},
	_RemoveRowData: function (inputStr) {
		var inputArr = inputStr.split('^');
		var winId = inputArr[0];
		var rowIndex = inputArr[1];
		
		var rNewRowsData = [];
		var rRowsData = $('#' + winId + '_win_grid_right').datagrid('getRows');
		for (var i = 0; i < rRowsData.length; i++) {
			if (rowIndex == i) {
				continue;
			}
			rNewRowsData.push(rRowsData[i]);
		}
		$('#' + winId + '_win_grid_right').datagrid('loadData', rNewRowsData);
	},
	_GetUserListHtml: function(_options){
		var winOpts = _options.winOpts || {};
		var winWidth = winOpts.width;
		var winId = winOpts.name || "";
		var placeholder = winOpts.placeholder || "请输入查询条件..."
		
		var userListHtml = "";
		userListHtml += '<div class="hisui-layout" fit="true">';
		userListHtml += '	<div data-options="region:\'center\',border:false" style="padding:10px 10px 0px 10px;" >';
		userListHtml += '		<div class="hisui-layout" fit="true">';
		//userListHtml += '			<div data-options="region:\'north\',height:40,border:false,split:true">';
		//userListHtml += '			</div>';
		userListHtml += '			<div data-options="region:\'center\',border:false,split:true">';
		userListHtml += '				<div class="hisui-layout" fit="true">';
		userListHtml += '					<div data-options="region:\'west\',width:' + (winWidth / 2) + ',border:false,split:true">';
		userListHtml += '						<div class="hisui-panel" title="查询" data-options="headerCls:\'panel-header-gray\',fit:true">';
		userListHtml += '							<div id="' + winId + '_win_grid_left"></div>';
		userListHtml += '						</div>';
		userListHtml += '					</div>';
		userListHtml += '					<div data-options="region:\'center\',border:false,split:true">';
		userListHtml += '						<div class="hisui-panel" title="已选" data-options="headerCls:\'panel-header-gray\',fit:true">';
		userListHtml += '							<div id="' + winId + '_win_grid_right"></div>';
		userListHtml += '						</div>';
		userListHtml += '					</div>';
		userListHtml += '				</div>';
		userListHtml += '			</div>';
		userListHtml += '		</div>';
		userListHtml += '	</div>';
		userListHtml += '</div>';
		userListHtml += '<div id="' + winId + '_win_txt_wrap" style="padding:1px;"><input id="' + winId + '_win_txt_QText" style="display:none;width:' + (winWidth / 2 - 14) + 'px;" placeholder="' + placeholder + '" />';
		return userListHtml;
	},
	// =====================================
	SetVal: function (_options){
		if (_options.type == "array") {
			var _triOpts = $('#' + _options.id).triggerbox('options');
			_triOpts.mArr = (_options.val || []);
		}
		if (_options.type == "value") {
			var _triOpts = $('#' + _options.id).triggerbox('options');
			_triOpts.mVal = _options.val;
		}
		if (_options.type == "text") {
			$('#' + _options.id).triggerbox('setValue', _options.val);
		}
	},
	GetVal: function (_options){
		if (_options.type == "array") {
			var _triOpts = $('#' + _options.id).triggerbox('options');
			return (_triOpts.mArr || []);
		}
		if (_options.type == "value") {
			var _triOpts = $('#' + _options.id).triggerbox('options');
			return _triOpts.mVal;
		}
		if (_options.type == "text") {
			return $('#' + _options.id).triggerbox('getValue');
		}
		return "";
	}
}

// 赋值 (传参ID字符串)
function TriggerBox_Set_User(domId, valStr) {
	var jsonDataStr = tkMakeServerCall('PHA.IN.Narc.Com', 'GetUserDataById', valStr);
	var jsonDataArr = eval('(' + jsonDataStr + ')');
	var txtStr = "";
	for (var i = 0; i < jsonDataArr.length; i++) {
		txtStr = txtStr == "" ? jsonDataArr[i].Description : txtStr + "," + jsonDataArr[i].Description
	}
	TriggerBox_MultiSel.SetVal({id:domId, type:'array', val:jsonDataArr});
	TriggerBox_MultiSel.SetVal({id:domId, type:'value', val:valStr});
	TriggerBox_MultiSel.SetVal({id:domId, type:'text', val:txtStr});
}

// 取值 (返回ID字符串)
function TriggerBox_Get_User(domId) {
	return TriggerBox_MultiSel.GetVal({id:domId, type:'value'});
}