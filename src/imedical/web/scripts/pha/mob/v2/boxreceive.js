/**
 * @Description: 移动药房 - 物流箱状态执行		//接收
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.boxreceive.csp
 * @Js:          pha/mob/v2/boxreceive.js
 * modified by MaYuqiang 20210330 界面功能修改为物流箱状态执行
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
PHA_COM.VAR = {
	CONFIG: null,
	statusColor: {},
	canAutoRec: false
};

$(function () {
	$('#panelBoxItm').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '物流箱状态执行' : '', 
		headerCls: 'panel-header-gray',
		iconCls: 'icon-scanning',
		fit: true,
		bodyCls: 'panel-body-gray'
	});
	
	// 初始化
	InitDict();
	InitGridBoxItm();

	// 事件绑定
	$('#btnReceive').on("click", Execute);
	$('#btnClear').on("click", Clear);
	$('#btnFind').on("click", QueryBoxItm);
	$('#boxNo').on("keydown", function (e) {
		if (e.keyCode == 13) {
			PHA_COM.VAR.canAutoRec = true;
			QueryBoxItm();
		}
	});
	$('#prescNo').on("keydown", function (e) {
		if (e.keyCode == 13) {
			var prescNo = $('#prescNo').val();
			var toLocId = $('#toLocId').combobox('getValue');
			var boxStatus = $('#boxStatus').combobox('getValue');
			var retBoxStr = tkMakeServerCall('PHA.MOB.BoxFind.Query', 'GetBoxInfo', prescNo, toLocId, boxStatus);
			var retBoxArr = retBoxStr.split('^');
			$('#prescNo').val('');
			if (retBoxArr[0] < 0) {
				PHA.Alert("提示", retBoxArr[1], retBoxArr[0]);
				return;
			}
			
			var retBoxId = retBoxArr[0];
			var retBoxNo = retBoxArr[1];
			$('#boxNo').val(retBoxNo);
			QueryBoxItm()
		}
	});
	$('#boxNo').focus();
})

// 初始化表单
function InitDict() {
	// 出发科室
	PHA.ComboBox("fromLocId", {
		placeholder: '请选择出发科室...',
		url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.BoxReceive.Query&QueryName=FromLocList&toLocId=' + session['LOGON.CTLOCID'],
		onLoadSuccess: function (data) {
			if (data.length > 0) {
				$(this).combobox('setValue', data[0].RowId);
			}
		},
		onSelect: function (record) {
			QueryBoxItm();
		}
	});

	// 到达科室
	PHA.ComboBox("toLocId", {
		placeholder: '请选择到达科室...',
		url: PHA_STORE.CTLoc().url,
		disabled: false,
		onLoadSuccess: function (data) {
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == session['LOGON.CTLOCID']) {
					$(this).combobox('setValue', iData.RowId);
				}
			}
		}
	});
	
	// 物流箱状态
	PHA.ComboBox("boxStatus", {
		placeholder: '执行状态...',
		url: $URL + '?ResultSetType=array&ClassName=PHA.MOB.BoxFind.Query&QueryName=BoxStatus',
		onSelect: function (record) {
			QueryBoxItm();
		}
	});
	$('#boxStatus').combobox('setValue', '60');
	
	// 日期默认
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
}

// 初始化表格
function InitGridBoxItm() {
	// 定义列
	var columns = [[{
				field: 'tSelect',
				checkbox: true
			}, {
				field: 'boxId',
				title: '物流箱ID',
				width: 80,
				hidden: true
			}, {
				field: 'boxItmId',
				title: '明细ID',
				width: 80,
				hidden: true
			}, {
				field: 'status',
				title: '状态码',
				width: 80,
				hidden: true
			}, {
				field: 'statusDesc',
				title: '当前状态',
				width: 110,
				align: 'center',
				styler: function(value, rowData, rowIndex){
					if (PHA_COM.VAR.statusColor[value]) {
						return 'background-color:' + PHA_COM.VAR.statusColor[value] + "; color:white;";
					}
				}
			}, {
				field: 'boxNo',
				title: '装箱单号',
				width: 130
			}, {
				field: 'boxPath',
				title: '物流路径',
				width: 200,
				formatter: function(value, rowData, rowIndex){
					return rowData.fromLocDesc + "<b> → </b>" + rowData.toLocDesc;
				}
			}, {
				field: 'createInfo',
				title: '装箱',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'formHandInfo',
				title: '交接',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'toHandInfo',
				title: '接收',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'toCheckInfo',
				title: '核对',
				width: 160,
				formatter: function(value, rowData, rowIndex){
					var valArr = value.split('^');
					if (valArr.length > 1) {
						return "<b>" + valArr[0] + "</b><br/>" + valArr[1];
					}
					return "";
				}
			}, {
				field: 'prescNo',
				title: '处方号',
				width: 140,
				align: 'left'
			}, {
				field: 'patNo',
				title: '登记号',
				width: 110,
				align: 'center'
			}, {
				field: 'patName',
				title: '患者姓名',
				width: 90
			}, {
				field: 'patAge',
				title: '年龄',
				width: 90
			}, {
				field: 'patSex',
				title: '性别',
				width: 60,
				align: 'center'
			}, {
				field: 'bedNo',
				title: '床号',
				width: 90
			}, {
				field: 'recLocDesc',
				title: '发药科室',
				width: 120
			}, {
				field: 'careProDesc',
				title: '医生',
				width: 90
			}, {
				field: 'cookPackQty',
				title: '每付袋数',
				width: 80,
				hidden: true
			}, {
				field: 'cookPackML',
				title: '一次用量',
				width: 80
			}, {
				field: 'freqDesc',
				title: '用药频次',
				width: 160
			}, {
				field: 'duratDesc',
				title: '用药疗程',
				width: 90
			}, {
				field: 'instDesc',
				title: '用法',
				width: 80
			}, {
				field: 'ordQty',
				title: '用量',
				width: 80,
				hidden: true
			}, {
				field: 'phCookMode',
				title: '煎药方式',
				width: 80,
				align: 'center'
			}, {
				field: 'packQty',
				title: '付数',
				width: 100
			}, {
				field: 'Notes',
				title: '处方备注',
				width: 100
			}, {
				field: 'Emergency',
				title: '是否加急',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}
		]
	];

	// Grid基本配置
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.BoxReceive.Query',
			QueryName: 'BoxItm',
		},
		pageSize: 500,
		singleSelect: false,
		columns: columns,
		pagination: true,
		toolbar: '#gridBoxItmBar',
		onLoadSuccess: function (data) {
			if (data.total > 0) {
				$(this).datagrid('selectAll');
				var isRecWhenScan = $('#isRecWhenScan').checkbox('getValue');
				if (isRecWhenScan == true && PHA_COM.VAR.canAutoRec == true) {
					Execute();
				}
			} else {
				$(this).datagrid('unselectAll');
			}
			$('#boxNo').focus();
			PHA_COM.VAR.canAutoRec = false;
		}
	};
	PHA.Grid("gridBoxItm", dataGridOption);
}

// 查询
function QueryBoxItm() {
	$('#prescNo').val('');
	var formDataArr = PHA.DomData("#gridBoxItmBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridBoxItm').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// 接收
function Execute() {
	var checkedData = $('#gridBoxItm').datagrid('getChecked');
	if (checkedData == null) {
		PHA.Popover({
			msg: '没有需要接收的处方数据！',
			type: "info"
		});
		return;
	}
	var boxNoArr = [];
	for (var i = 0; i < checkedData.length; i++) {
		var rowData = checkedData[i];
		var rowIndex = GetGridRowIndex('gridBoxItm', rowData);
		var boxNo = rowData.boxNo || "";
		if (boxNo == "") {
			PHA.Alert("提示", '第' + (rowIndex + 1) + '行, 装箱单号为空！', -2);
			return;
		}
		/*
		var status = rowData.status;
		if (status != '60') {
			PHA.Alert("提示", '第' + (rowIndex + 1) + '行, 状态不是[出发科室交接]状态,不能接收！', -2);
			return;
		}
		*/
		if (boxNoArr.indexOf(boxNo) < 0) {
			boxNoArr.push(boxNo);
		}
	}
	var toExeText = $('#boxStatus').combobox('getText') || '';
	if (boxNoArr.length == 0) {
		PHA.Alert("提示", '没有可执行[' + toExeText + ']的物流箱！请先查询...', -2);
		return;
	}
	
	var toExeCode = $('#boxStatus').combobox('getValue');
	var logisticsName = "" 	// 物流交接人员
	if (toExeCode == 60){
		var logisticsName = $('#logisticName').val() ;
		if (logisticsName == ""){
			PHA.Alert("提示", '执行“出发科室交接”时，物流人员不能为空...', -2);
			return ;	
		}
	}
	var boxNoStr = boxNoArr.join('^');
	var exeUserId = session['LOGON.USERID'];
	var userStr = exeUserId + "^" + logisticsName ; 
	
	// 更新后台
	var retStr = tkMakeServerCall("PHA.MOB.BoxExecute.Save", "ExecuteBoxs", boxNoStr, toExeCode, userStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		// 错误提示
		$.messager.alert($g("提示"), $g("更新失败:") + retArr[1], "warning");
	} else {
		/* 更新状态
		for (var i = 0; i < checkedData.length; i++) {
			var rowData = checkedData[i];
			var rowIndex = GetGridRowIndex('gridBoxItm', rowData);
			RefreshRow(rowIndex);
		}
		*/
		PHA.Popover({
			msg: '执行成功！',
			type: "success"
		});
		QueryBoxItm() ;
	}
}

// 根据行数据获取行号
function GetGridRowIndex(_id, _rowData) {
	var rowIndex = $('#' + _id).datagrid('getRowIndex', _rowData);
	return rowIndex;
}

// 只更新状态,不刷新表格
function RefreshRow(rowIndex){
	var status = $('#boxStatus').combobox('getValue');
	var statusDesc = $('#boxStatus').combobox('getText');
	/*
	var boxId = ""
	var exeHandInfo = ""
	if (status == 20){
		var exeHandInfo = tkMakeServerCall("PHA.MOB.BoxFind.Query","GetFormHandInfo",boxId, "string")
		var handColDesc = "formHandInfo"
	}
	else if (status == 35){
		var exeHandInfo = tkMakeServerCall("PHA.MOB.BoxFind.Query","GetToHandInfo",boxId, "string")
		var handColDesc = "toHandInfo"
	}
	else if (status == 40){
		var exeHandInfo = tkMakeServerCall("PHA.MOB.BoxFind.Query","GetToCheckInfo",boxId, "string")
		var handColDesc = "toCheckInfo"
	}
	*/
	$('#gridBoxItm').datagrid('updateRow',{
		index: rowIndex,
		row: {
			status: status,
			statusDesc: statusDesc
			//handColDesc: exeHandInfo
		}
	});
	$('#gridBoxItm').datagrid('refreshRow', rowIndex);
}

// 清除
function Clear() {
	PHA.DomData("#gridBoxItmBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	$('#fromLocId').combobox('setValue', '0');
	$('#toLocId').combobox('setValue', session['LOGON.CTLOCID']);
	$('#boxStatus').combobox('setValue', '60');
	$('#gridBoxItm').datagrid('clear');
}

// 在csp中调用 - 不用
function ToggleFormPanle() {
	var $toolBar = $("#layout-formPanel").siblings().eq(0).children('.panel-tool').children().eq(0);
	var curIcon = $toolBar.attr('class');
	var newIcon = curIcon == 'icon-up-gray' ? 'icon-down-gray' : 'icon-up-gray';

	// 隐藏
	if (curIcon == 'icon-up-gray') {
		$('#form-row2').hide();
		var northPanel = $('#layout').layout('panel', 'north');
		northPanel.panel('resize', {
			height: 95
		});
		$('#layout').layout('resize');
	}
	// 展开
	if (curIcon == 'icon-down-gray') {
		$('#form-row2').show();
		var northPanel = $('#layout').layout('panel', 'north');
		northPanel.panel('resize', {
			height: 135
		});
		$('#layout').layout('resize');
	}
	// 改图标
	$toolBar.attr('class', newIcon);
}

function YesNoFormatter(value, row, index){
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// 加载配置
function InitConfig() {
	// 获取颜色列表
	var retColorStr = tkMakeServerCall("PHA.MOB.BoxFind.Query", "GetStatusColor");
	PHA_COM.VAR.statusColor = eval('(' + retColorStr + ')');
	
	// 获取通用配置
	$.cm({
		ClassName: "PHA.MOB.COM.PC",
		MethodName: "GetConfig",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// 传递给全局
		PHA_COM.VAR.CONFIG = retJson;
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
