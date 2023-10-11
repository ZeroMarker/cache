/**
 * ����:   	 ҩ��ҩ�� - ����ҩƷ����
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.csp
 * js:		 pha/in/v1/narcdestroy.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcdestroy.csp';
PHA_COM.App.Name = $g('����ҩƷ����');
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

// ��ʼ�� - ���ֵ�
function InitDict(){
	PHA.ComboBox("pindLocId", {
		url: PHA_STORE.CTLoc().url + "&HospId=" + session['LOGON.HOSPID']
	});
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('pindLocId', session['LOGON.CTLOCID']);
}

// ��ʼ�� - �¼���
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

// ��ʼ�� - ���
function InitGridNarcDestroy(){
	var columns = [
		[{
				title: "����",
				field: "pind",
				width: 100,
				align: "left",
				hidden: true
			} , {
				title: "����",
				field: "pindNo",
				width: 200,
				align: "left",
				sortable: true
			} , {
				title: "��������",
				field: "pindDate",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "����ʱ��",
				field: "pindTime",
				width: 80,
				align: "center",
				sortable: true
			} , {
				title: "����ִ����ID",
				field: "pindExeUser",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "����ִ����",
				field: "pindExeUserStr",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "����������ID",
				field: "pindAuditUser",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "����������",
				field: "pindAuditUserStr",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "���ټල��ID",
				field: "pindSuperUser",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "���ټල��",
				field: "pindSuperUserStr",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "���ٵص�",
				field: "pindPlace",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "���ٷ�ʽ����",
				field: "pindType",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "���ٷ�ʽ",
				field: "pindTypeDesc",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "���ٿ���ID",
				field: "pindLoc",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "���ٿ���",
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

// ��ʼ�� - ���
function InitGridNarcDestroyItm(){
	var columns = [
		[{
				title: "��������",
				field: "pind",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} ,{
				title: "�ӱ�����",
				field: "pindi",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "�����ID",
				field: "inci",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "ҩƷ����",
				field: "inciCode",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 200,
				align: "left",
				sortable: true,
				showTip: true,
				tipWidth: 200
			} , {
				title: "����",
				field: "pindiBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "�հ������",
				field: "pindiQty",
				width: 100,
				align: "right"
			} , {
				title: "������λ",
				field: "pindiUomDesc",
				width: 75,
				align: "center"
			} , {
				title: "����Һ�����",
				field: "pindiFluidQty",
				width: 100,
				align: "right"
			} , {
				title: "Һ�嵥λ",
				field: "pindiFluidUomDesc",
				width: 75,
				align: "center"
			} , {
				title: "ִ�м�¼ID",
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
				title: "�����ӱ�ID",
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
* �������
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
	// ��ȡ����
	var selectedRow = $('#gridNarcDestroy').datagrid('getSelected');
	if (selectedRow == null) {
		PHA.Popover({
			msg: "��ѡ����Ҫ��ӡ�����ٵ�",
			type: "alert"
		});
		return;
	}
	var pind = selectedRow.pind;
	var dataStr = tkMakeServerCall('PHA.IN.NarcDestroy.Query', 'GetPrintData', pind);
	var dataJson = eval('(' + dataStr + ')');
	
	// ��ӡ
	new PHA_LODOP.Init('����ҩƷ���ٵ�')
	.Page('Orient:1; Width:0; Height:0; PageName:A4')
	.PageNo('Top:2mm; Left:160mm;')
	.Text($g('����ҩƷ���ٵ�'), 'Top:2mm; Left:4mm; Width:170mm; Height:20mm; FontName:����; FontSize:14; Bold:1; Alignment:2')
	.Text(dataJson.Para.pindNo, 'Top:8mm; Left:4mm; Width:170mm; Height:10mm; FontName:����; FontSize:10; Bold:1; Alignment:2')
	.Html({
		// ����
		type: 'html',
		FromTop: 50,
		FromLeft: 5,
		DivWidth: '98%',
		DivHeight: '94%',
		// ���
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
		// ����Ϣ
		columns: [{
				name: $g('ҩƷ����'),
				index: 'inciCode',
				width: '10'
			}, {
				name: $g('ҩƷ����'),
				index: 'inciDesc',
				width: '15'
			}, {
				name: $g('����'),
				index: 'pindiBatchNo',
				width: '8'
			}, {
				name: $g('�հ������'),
				index: 'pindiQty',
				width: '7',
				align: 'right'
			}, {
				name: $g('��λ'),
				index: 'pindiUomDesc',
				width: '5'
			}, {
				name: $g('Һ�����'),
				index: 'pindiFluidQty',
				width: '6',
				align: 'right'
			}, {
				name: $g('Һ�嵥λ'),
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
							td: $g("���ٿ��ң�") + main.pindLocDesc,
							width: 30
						}, {
							td: $g("�������ڣ�") + main.pindDate + ' ' + main.pindTime,
							width: 30
						}, {
							td: $g("���ٷ�ʽ��") + main.pindTypeDesc,
							width: 30
						}
					], [{
							td: $g("ִ���ˣ�") + main.pindExeUserStr,
							width: 30
						}, {
							td: $g("�ල�ˣ�") + main.pindSuperUserStr,
							width: 30
						}, {
							td: $g("�����ˣ�") + main.pindAuditUserStr,
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
// ִ�м�¼��ϸ��Ϣ����
function OeoreDetailWin(oeore){
	PHA_UX.DetailWin({
		id: 'PHA_WIN_ORD_INFO',
		title: 'ҽ����ϸ��Ϣ',
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

// ������ϸ��ϸ��Ϣ����
function InspiDetailWin(inspi){
	PHA_UX.DetailWin({
		id: 'PHA_WIN_SCRAP_INFO',
		title: '������Ϣ',
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
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}