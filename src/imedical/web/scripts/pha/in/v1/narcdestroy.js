/**
 * 名称:   	 药房药库 - 毒麻药品销毁
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.csp
 * js:		 pha/in/v1/narcdestroy.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcdestroy.csp';
PHA_COM.App.Name = $g('毒麻药品销毁');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function() {
	InitDict();
	InitGridNarcDestroy();
	InitGridNarcDestroyItm();
	InitEvents();
	
	InitConfig();
});

// 初始化 - 表单字典
function InitDict(){
	PHA.ComboBox("pindLocId", {
		url: PHA_STORE.CTLoc().url + "&HospId=" + session['LOGON.HOSPID']
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('pindLocId', session['LOGON.CTLOCID']);
}

// 初始化 - 事件绑定
function InitEvents(){
	$('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
    $('#btnPrint').on("click", Print);
    
    $('#btnAdd').on("click", function(){
	    OpenNarcDestroyWin({
		    patNo: '',
		    pind: '',
		    onClose: OnWinCloseCall
		});
	});
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

// 初始化 - 表格
function InitGridNarcDestroy(){
	var columns = [
		[{
				title: "主键",
				field: "pind",
				width: 100,
				align: "left",
				hidden: true
			} , {
				title: "单号",
				field: "pindNo",
				width: 200,
				align: "left",
				sortable: true
			} , {
				title: "销毁日期",
				field: "pindDate",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "销毁时间",
				field: "pindTime",
				width: 80,
				align: "center",
				sortable: true
			} , {
				title: "销毁执行人ID",
				field: "pindExeUser",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "销毁执行人",
				field: "pindExeUserStr",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "销毁审批人ID",
				field: "pindAuditUser",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "销毁审批人",
				field: "pindAuditUserStr",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "销毁监督人ID",
				field: "pindSuperUser",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "销毁监督人",
				field: "pindSuperUserStr",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "销毁地点",
				field: "pindPlace",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "销毁方式代码",
				field: "pindType",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "销毁方式",
				field: "pindTypeDesc",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "销毁科室ID",
				field: "pindLoc",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "销毁科室",
				field: "pindLocDesc",
				width: 150,
				align: "left",
				sortable: true
			}

		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcDestroy.Query',
			QueryName: 'NarcDestroy'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: [],
		onDblClickRow: function(rowIndex, rowData) {
			var pind = rowData.pind || "";
			OpenNarcDestroyWin({
				patNo: '',
			    pind: pind,
			    onClose: OnWinCloseCall
			});
		},
		onSelect: function(rowIndex, rowData) {
			QueryDetail();
		},
        onLoadSuccess: function(data){
	        if (data.total > 0) {
		        $('#gridNarcDestroy').datagrid('selectRow', 0);
		    } else {
			    $('#gridNarcDestroyItm').datagrid('clear');
			}
	   	}
	};
	PHA.Grid("gridNarcDestroy", dataGridOption);
}

// 初始化 - 表格
function InitGridNarcDestroyItm(){
	var columns = [
		[{
				title: "主表主键",
				field: "pind",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} ,{
				title: "子表主键",
				field: "pindi",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "库存项ID",
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
				title: "批号",
				field: "pindiBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "空安瓿数量",
				field: "pindiQty",
				width: 100,
				align: "right"
			} , {
				title: "数量单位",
				field: "pindiUomDesc",
				width: 75,
				align: "center"
			} , {
				title: "销毁液体残量",
				field: "pindiFluidQty",
				width: 100,
				align: "right"
			} , {
				title: "液体单位",
				field: "pindiFluidUomDesc",
				width: 75,
				align: "center"
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
		pagination: false,
		columns: columns,
		toolbar: [],
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
		}
	};
	PHA.Grid("gridNarcDestroyItm", dataGridOption);
}

/*
* 界面操作
*/
function Query(){
	var formDataArr = PHA.DomData("#layout-formPanel", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.hospId = session['LOGON.HOSPID'];
	
	var InputStr = JSON.stringify(formData);
	$('#gridNarcDestroy').datagrid('query', {
		InputStr: InputStr
	});
}
function Clear(){
	PHA.DomData("#layout-formPanel", {
		doType: 'clear'
	});
	InitDictVal();
	$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	$('#gridNarcDestroy').datagrid('clear');
	$('#gridNarcDestroyItm').datagrid('clear');
}

function QueryDetail(){
	var selectedRow = $('#gridNarcDestroy').datagrid('getSelected');
	if (selectedRow == null) {
		return;
	}
	var pind = selectedRow.pind;
	
	var InputStr = JSON.stringify({pind: pind});
	$('#gridNarcDestroyItm').datagrid('query', {
		InputStr: InputStr
	});
}

function Print(){
	// 获取数据
	var selectedRow = $('#gridNarcDestroy').datagrid('getSelected');
	if (selectedRow == null) {
		PHA.Popover({
			msg: "请选择需要打印的销毁单",
			type: "alert"
		});
		return;
	}
	var pind = selectedRow.pind;
	var dataStr = tkMakeServerCall('PHA.IN.NarcDestroy.Query', 'GetPrintData', pind);
	var dataJson = eval('(' + dataStr + ')');
	
	// 打印
	new PHA_LODOP.Init('毒麻药品销毁单')
	.Page('Orient:1; Width:0; Height:0; PageName:A4')
	.PageNo('Top:2mm; Left:160mm;')
	.Text($g('毒麻药品销毁单'), 'Top:2mm; Left:4mm; Width:170mm; Height:20mm; FontName:宋体; FontSize:14; Bold:1; Alignment:2')
	.Text(dataJson.Para.pindNo, 'Top:8mm; Left:4mm; Width:170mm; Height:10mm; FontName:宋体; FontSize:10; Bold:1; Alignment:2')
	.Html({
		// 区域
		type: 'html',
		FromTop: 50,
		FromLeft: 5,
		DivWidth: '98%',
		DivHeight: '94%',
		// 表格
		data: [{
				main: dataJson.Para,
				detail: dataJson.List
			}
		],
		width: 195,
		borderStyle: 4,
		padding: 3,
		fontSize: 12,
		rowHeight: 10,
		// 列信息
		columns: [{
				name: $g('药品代码'),
				index: 'inciCode',
				width: '10'
			}, {
				name: $g('药品名称'),
				index: 'inciDesc',
				width: '15'
			}, {
				name: $g('批号'),
				index: 'pindiBatchNo',
				width: '8'
			}, {
				name: $g('空安瓿数量'),
				index: 'pindiQty',
				width: '7',
				align: 'right'
			}, {
				name: $g('单位'),
				index: 'pindiUomDesc',
				width: '5'
			}, {
				name: $g('液体残量'),
				index: 'pindiFluidQty',
				width: '6',
				align: 'right'
			}, {
				name: $g('液体单位'),
				index: 'pindiFluidUomDesc',
				width: '6'
			}
		],
		formatHeader: function (main, detail) {
			return {
				marginTop: 20,
				fontSize: 12,
				padding: 3,
				data: [[{
							td: $g("销毁科室：") + main.pindLocDesc,
							width: 30
						}, {
							td: $g("销毁日期：") + main.pindDate + ' ' + main.pindTime,
							width: 30
						}, {
							td: $g("销毁方式：") + main.pindTypeDesc,
							width: 30
						}
					], [{
							td: $g("执行人：") + main.pindExeUserStr,
							width: 30
						}, {
							td: $g("监督人：") + main.pindSuperUserStr,
							width: 30
						}, {
							td: $g("审批人：") + main.pindAuditUserStr,
							width: 30
						}
					]
				]
			};
		}
	})
	.Print();
}

function OnWinCloseCall(pind){
	if (pind == "") {
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
			var rowData = data[0];
			var pindNo = rowData.pindNo || "";
			$('#pindNo').val(pindNo);
			Query();
		}
	});
}

// ===============================
// 执行记录详细信息弹窗
function OeoreDetailWin(oeore){
	PHA_UX.DetailWin({
		id: 'PHA_WIN_ORD_INFO',
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

// 报损明细详细信息弹窗
function InspiDetailWin(inspi){
	PHA_UX.DetailWin({
		id: 'PHA_WIN_SCRAP_INFO',
		title: '报损单信息',
		width: 500,
		height: 560,
		labelWidth: 120,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Com',
			MethodName: 'GetInspiWinInfo',
			inspi: inspi
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
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}