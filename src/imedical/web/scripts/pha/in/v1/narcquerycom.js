/**
 * 名称:   	 药房药库-毒麻药品管理 - 综合查询
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-24
 * csp:		 pha.in.v1.narcquerycom.csp
 * js:		 pha/in/v1/narcquerycom.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcquerycom.csp';
PHA_COM.App.Name = '毒麻药品综合查询';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function() {
	$('#panel-narccom').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '毒麻药品管理 - 综合查询' : '', 
		headerCls: 'panel-header-gray',
		iconCls: 'icon-search',
		bodyCls: 'panel-body-gray',
		fit: true
	});
	
	InitDict();
	InitGridNarcCom();
	InitEvents();
	InitConfig();
});

// 初始化 - 表单字典
function InitDict(){
	var formWidth = 155;
	PHA.ComboBox("phLocId", {
		placeholder: '发药科室...',
		width: formWidth,
		url: PHA_STORE.CTLoc().url + "&TypeStr=D&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("docLocId", {
		placeholder: '开单科室...',
		width: formWidth,
		url: PHA_STORE.DocLoc().url + "&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("recLocId", {
		placeholder: '回收科室...',
		width: formWidth,
		url: PHA_STORE.CTLoc().url + "&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("admType", {
		placeholder: '就诊类型...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType',
		panelHeight: 'auto'
	});
	PHA.ComboBox("oeoriState", {
		placeholder: '医嘱状态...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEORIStatus'
	});
	PHA.ComboBox("oeoreState", {
		placeholder: '执行记录状态...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEOREStatus'
	});
	PHA.ComboBox("wardLocId", {
		placeholder: '病区...',
		width: formWidth,
		url: PHA_STORE.CTLoc().url + "&TypeStr=W&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("dspState", {
		placeholder: '发药状态...',
		width: formWidth,
		data: [
			{RowId: 'Y', Description: '已发药'},
			{RowId: 'N', Description: '未发药'}
		],
		panelHeight: 'auto'
	});
	PHA.ComboBox("regState", {
		placeholder: '登记状态...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RegStatus',
		panelHeight: 'auto'
	});
	PHA.ComboBox("recState", {
		placeholder: '回收状态...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RecStatus',
		panelHeight: 'auto'
	});
	/*
	PHA.ComboBox("destroyState", {
		placeholder: '销毁状态...',
		width: formWidth,
		data: [
			{RowId: 'A', Description: '全部'},
			{RowId: 'Y', Description: '已销毁'},
			{RowId: 'N', Description: '未销毁'}
		],
		panelHeight: 'auto'
	});
	*/
	PHA.ComboBox("poisonIdStr", {
		placeholder: '管制分类...',
		width: formWidth,
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function(data){
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});
	PHA.ToggleButton('BMore', {
		buttonTextArr: ['更多', '隐藏'],
		selectedText: '更多',
		onClick: function (oldText, newText) {
			if (oldText == '更多') {
				$('#grid-narccomBar2').show();
				$('#grid-narccomBar3').show();
			} else {
				$('#grid-narccomBar2').hide();
				$('#grid-narccomBar3').hide();
			}
			$('#layout').layout('resize');
		}
	});
	
	InitDictVal();
}
function InitDictVal(){
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
}

// 初始化表格
function InitGridNarcCom(){
	var frozenColumns = [[
		{
			title: "执行记录ID",
			field: "oeore",
			width: 100,
			align: "left",
			formatter: function(value, rowData, index){
				return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>";
			}
		} ,{
			title: "登记号",
			field: "patNo",
			width: 100,
			align: "left",
			formatter: function(value, rowData, index){
				return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>";
			}
		} 
	]]
	var columns = [
		[
			{
				title: "adm",
				field: "adm",
				width: 100,
				align: "left",
				hidden: true
			} , {
				title: "pinr",
				field: "pinr",
				width: 100,
				align: "left",
				hidden: true
			} , {
				title: "pindi",
				field: "pindi",
				width: 100,
				align: "left",
				hidden: true
			} , {
				title: "患者姓名",
				field: "patName",
				width: 100,
				align: "left"
			} , {
				title: "发药科室",
				field: "phLodDesc",
				width: 120,
				align: "left"
			} , {
				title: "医嘱状态",
				field: "oeoriStateDesc",
				width: 80,
				align: "left"
			} , {
				title: "执行状态",
				field: "oeoreStateDesc",
				width: 80,
				align: "left"
			} , {
				title: "医嘱优先级",
				field: "priDesc",
				width: 100,
				align: "left"
			} , {
				title: "药品名称",
				field: "inciDesc",
				width: 180,
				align: "left",
				showTip: true,
				tipWidth: 180
			} , {
				title: "预计执行时间",
				field: "dosingDT",
				width: 150,
				align: "left"
			} , {
				title: "护士执行时间",
				field: "exeDT",
				width: 150,
				align: "left"
			} , {
				title: "剂量",
				field: "doseQty",
				width: 100,
				align: "left"
			} , {
				title: "用法",
				field: "instDesc",
				width: 100,
				align: "left"
			} , {
				title: "发药状态",
				field: "dspStateDesc",
				width: 80,
				align: "left"
			} , {
				title: "发药日期",
				field: "dspDate",
				width: 100,
				align: "left"
			} , {
				title: "发药时间",
				field: "dspTime",
				width: 100,
				align: "left"
			} , {
				title: "发药数量",
				field: "dspQty",
				width: 70,
				align: "left"
			} , {
				title: "发药单位",
				field: "dspUomDesc",
				width: 70,
				align: "left"
			} , {
				title: "发药人",
				field: "dspUserName",
				width: 90,
				align: "left"
			} , {
				title: "发药科室",
				field: "dspLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "登记状态",
				field: "regStateDesc",
				width: 80,
				align: "center"
			} , {
				title: "毒麻药品编号",
				field: "inciNo",
				width: 100,
				align: "left"
			} , {
				title: "登记批号",
				field: "inciBatchNo",
				width: 100,
				align: "left"
			} , {
				title: "登记科室",
				field: "regLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "登记人",
				field: "regUserName",
				width: 90,
				align: "left"
			} , {
				title: "登记日期",
				field: "regDate",
				width: 90,
				align: "center"
			} , {
				title: "登记时间",
				field: "regTime",
				width: 80,
				align: "center"
			} , {
				title: "实际用药量",
				field: "useQty",
				width: 85,
				align: "center",
				formatter: function(value, rowData, rowIndex){
					return (value == "" ? "" : value + rowData.doseUomDesc);
				}
			} , {
				title: "回收状态",
				field: "recStateDesc",
				width: 80,
				align: "center"
			} , {
				title: "回收来源类型",
				field: "recOriTypeDesc",
				width: 100,
				align: "center"
			} , {
				title: "回收来源科室",
				field: "recOriLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "回收科室",
				field: "recLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "空安瓿数量",
				field: "recQty",
				width: 100,
				align: "right"
			} , {
				title: "液体残量",
				field: "recFluidQty",
				width: 100,
				align: "right",
				formatter: function(value, rowData, rowIndex){
					return (value == "" ? "" : value + rowData.doseUomDesc);
				}
			} , {
				title: "回收人",
				field: "recUserName",
				width: 90,
				align: "left"
			} , {
				title: "回收日期",
				field: "recDate",
				width: 90,
				align: "left"
			} , {
				title: "回收时间",
				field: "recTime",
				width: 80,
				align: "center"
			} , {
				title: "回收核对人",
				field: "recCheckUserName",
				width: 90,
				align: "left"
			} , {
				title: "回收送回人",
				field: "recFromUserName",
				width: 90,
				align: "left"
			} , {
				title: "回收批号",
				field: "recBatchNo",
				width: 100,
				align: "left"
			} , {
				title: "残量处理意见",
				field: "DSCDDesc",
				width: 120,
				align: "left"
			} , {
				title: "残量处理执行人",
				field: "DSCDExeUserName",
				width: 130,
				align: "left"
			} , {
				title: "残量处理监督人",
				field: "DSCDSuperUserName",
				width: 130,
				align: "left"
			} , {
				title: "销毁状态",
				field: "destroyStateDesc",
				width: 90,
				align: "center"
			} , {
				title: "销毁科室",
				field: "pindLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "销毁单号",
				field: "pindNo",
				width: 170,
				align: "left"
			} , {
				title: "销毁日期",
				field: "pindDate",
				width: 90,
				align: "center"
			} , {
				title: "销毁时间",
				field: "pindTime",
				width: 80,
				align: "center"
			} , {
				title: "销毁执行人",
				field: "pindExeUserStr",
				width: 90,
				align: "left"
			} , {
				title: "销毁审批人",
				field: "pindAuditUserStr",
				width: 90,
				align: "left"
			} , {
				title: "销毁监督人",
				field: "pindSuperUserStr",
				width: 90,
				align: "left"
			} , {
				title: "销毁地点",
				field: "pindPlace",
				width: 120,
				align: "left"
			} , {
				title: "销毁方式",
				field: "pindTypeDesc",
				width: 90,
				align: "left"
			} , {
				title: "销毁空安瓿数量",
				field: "pindiQty",
				width: 110,
				align: "right"
			}, {
				title: "销毁液体量",
				field: "pindiFluidQty",
				width: 90,
				align: "right",
				formatter: function(value, rowData, rowIndex){
					return (value == "" ? "" : value + rowData.doseUomDesc);
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Query',
			QueryName: 'NarcQueryCom'
		},
		singleSelect: true,
		pagination: true,
		pageSize: 100,
		columns: columns,
		frozenColumns: frozenColumns,
		toolbar: '#grid-narccomBar',
		onClickCell: function(index, field, value) {
			if (field == 'patNo') {
				OpenDetailWin(index);
				return;
			}
			if (field == 'oeore') {
				OpenStepWin(index);
				return;
			}
		}
	};
	PHA.Grid("grid-narccom", dataGridOption);
}

function Query(){
	var formDataArr = PHA.DomData("#grid-narccomBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var recLocId = formData.recLocId || "";
	if (formData.recState == "Y" && recLocId == "") {
		PHA.Popover({
			msg: '已回收状态的查询请选择回收科室!',
			type: "alert"
		});
		return;
	}
	if (recLocId != "" && formData.recState != "Y") {
		PHA.Popover({
			msg: '已选回收科室,请选择回收状态为[已回收]!',
			type: "alert"
		});
		return;
	}
	
	// 医院
	formData.hospId = session['LOGON.HOSPID'];
	
	var InputStr = JSON.stringify(formData);
	$('#grid-narccom').datagrid('query', {
		InputStr: InputStr
	});
}

function Clear(){
	PHA.DomData("#grid-narccomBar", {doType: 'clear'});
	InitDictVal();
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#grid-narccom').datagrid('clear');
}

function OpenDetailWin(index){
	var rowsData = $('#grid-narccom').datagrid('getRows');
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

function OpenStepWin(index){
	var rowsData = $('#grid-narccom').datagrid('getRows');
	var rowData = rowsData[index];
	var oeore = rowData.oeore || "";
	
	// 窗口
	var winWidth = parseInt($(document.body).width() * 0.9);
	var winId = "narc_win_step";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
	    	height: 160,
	    	modal: true,
	    	title: "毒麻药品执行记录追踪",
	    	iconCls: 'icon-w-find',
	    	content: "<div id='hstp' style='height:90px;margin:10px;'></div>",
	    	closable: true,
	    	onClose: function() {}
		});
	}
	
	// 步骤
	var speed = 1000;
	$("#hstp").children().remove();
	var stepJsonStr = tkMakeServerCall('PHA.IN.Narc.Com', 'GetStepWinInfo', oeore);
	var stepJsonData = eval('(' + stepJsonStr + ')');
	var steps = stepJsonData.items.length;
	for (var i = 0; i < steps; i++){
		if (stepJsonData.items[i].context){
			stepJsonData.items[i].context = '<div style="font-weight:normal;">'+ stepJsonData.items[i].context +'</div>';
		}
	}
	var stepWidth = (winWidth - 40) / steps;
	$("#hstp").hstep({
		speed: speed,
		titlePostion: 'top',
		showNumber: false,
		stepWidth: stepWidth,
		currentInd: stepJsonData.currentInd,
		items: stepJsonData.items,
		onSelect: function(ind, item){}
	});
	
	// 打开窗口
	$('#' + winId).dialog('open');
	
	// ========================
	// 为空的不显示绿色
	/*
	var itemsLen = stepJsonData.items.length;
	setTimeout(function(){
		if (stepJsonData.items) {
			for (var i = 0; i < itemsLen; i++) {
				var item = stepJsonData.items[i];
				if (item.context == '' || typeof item.context == 'undefined') {
					$("#hstp .hstep-container-steps").find('li[ind="' + (i + 1) + '"]').each(function(){
						$(this).attr('class', 'undone');
					});
				}
			}
		}
	}, speed);
	*/
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// 传递给全局 (清空时恢复)
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}