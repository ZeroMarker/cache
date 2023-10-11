/**
 * ����:   	 ҩ��ҩ�� - ����ҩƷ���� - �Ǽ�/���ղ�ѯ
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-24
 * csp:		 pha.in.v1.narcqueryrec.csp
 * js:		 pha/in/v1/narcqueryrec.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcqueryrec.csp';
PHA_COM.App.Name = $g('���ղ�ѯ');
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

// ��ʼ�� - ���ֵ�
function InitDict(){
	PHA.ComboBox("recLocId", {
		placeholder: '���տ���...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("wardLocId", {
		placeholder: '����...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W"
	});
	PHA.ComboBox("docLocId", {
		placeholder: '��������...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("admType", {
		placeholder: '��������...',
		panelHeight: 'auto',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType'
	});
	PHA.ComboBox("dspState", {
		placeholder: '��ҩ״̬...',
		data: [
			{RowId: 'C', Description: $g('�ѷ�ҩ')},
			{RowId: 'TC', Description: $g('δ��ҩ')}
		],
		panelHeight: 'auto'
	});
	PHA.ComboBox("recState", {
		disabled: true,
		placeholder: '����״̬...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RecStatus',
		panelHeight: 'auto'
	});
	PHA.ComboBox("destroyState", {
		placeholder: '����״̬...',
		data: [
			{RowId: 'Y', Description: $g('������')},
			{RowId: 'N', Description: $g('δ����')}
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

// ��ʼ�� - �¼���
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
			if (title == $g('�����б�') && PHA_COM.VAR.isGridLoad == false) {
				InitGridNarcRecTotal();
				PHA_COM.VAR.isGridLoad = true;
			}
			Query();
		}
	});
	
}

// ��ʼ�� - ��ϸ���
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
				title: "�ǼǺ�",
				field: "patNo",
				width: 100,
				align: "center",
				sortable: true,
				formatter: function(value, rowData, index){
					return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>"
				}
			} , {
				title: "��������",
				field: "patName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "�Ա�",
				field: "patSex",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "����",
				field: "patAge",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "���߿���",
				field: "patLocDesc",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "���߲���",
				field: "patWardDesc",
				width: 130,
				align: "left",
				sortable: true
			} , {
				title: "����ҽʦ",
				field: "narcDocUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "����ҩƷ���",
				field: "inciNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "�Ǽ�����",
				field: "inciBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 180,
				align: "left",
				sortable: true
			} , {
				title: "���",
				field: "inciSpec",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "��ҩ����",
				field: "dspQty",
				width: 75,
				align: "right",
				sortable: true
			}  , {
				title: "��ҩ��λ",
				field: "dspUomDesc",
				width: 75,
				align: "right",
				sortable: true
			}, {
				title: "�հ������",
				field: "recQty",
				width: 85,
				align: "right",
				sortable: true
			} , {
				title: "Һ�������",
				field: "recFluidQty",
				width: 85,
				align: "right",
				sortable: true
			} , {
				title: "������λ",
				field: "doseUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "����״̬",
				field: "recStateDesc",
				width: 80,
				align: "center",
				sortable: true
			} , {
				title: "������Դ����",
				field: "recOriTypeDesc",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "������Դ����",
				field: "recOriLocDesc",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "���տ���",
				field: "recLocDesc",
				width: 100,
				align: "left",
				sortable: true
			}, {
				title: "������",
				field: "recUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "��������",
				field: "recDate",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "����ʱ��",
				field: "recTime",
				width: 80,
				align: "center",
				sortable: true
			} , {
				title: "���պ˶���",
				field: "recCheckUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "�����ͻ���",
				field: "recFromUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "��������",
				field: "recBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "�����������",
				field: "DSCDDesc",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "��������ִ����",
				field: "DSCDExeUserName",
				width: 140,
				align: "left",
				sortable: true
			} , {
				title: "��������ල��",
				field: "DSCDSuperUserName",
				width: 140,
				align: "left",
				sortable: true
			} , {
				title: "Ԥ��ִ��ʱ��",
				field: "dosingDT",
				width: 150,
				align: "center",
				sortable: true
			} , {
				title: "��ʿִ��ʱ��",
				field: "exeDT",
				width: 150,
				align: "center",
				sortable: true
			}, {
				title: "�Ǽǿ���",
				field: "regLocDesc",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "�Ǽ���",
				field: "regUserName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "�Ǽ�����",
				field: "regDate",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "�Ǽ�ʱ��",
				field: "regTime",
				width: 80,
				align: "center",
				sortable: true
			}, {
				title: "ִ�м�¼ID",
				field: "oeore",
				width: 110,
				align: "left"
			}, {
				title: "����Ǽ�ID",
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

// ��ʼ�� - ���ܱ��
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
				title: "�ǼǺ�",
				field: "patNo",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "����",
				field: "patName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "֤������",
				field: "IDCard",
				width: 160,
				align: "center",
				sortable: true,
				formatter: function(value, rowData, rowIndex){
					return '<label title="' + (rowData.cardTypeDesc || '') + '" class="hisui-tooltip" data-options="position:\'right\'">' + value + '</label>';
				}
			} , {
				title: "�Ա�",
				field: "patSex",
				width: 60,
				align: "center",
				sortable: true
			} , {
				title: "����",
				field: "patAge",
				width: 60,
				align: "center",
				sortable: true
			} , {
				title: "����",
				field: "patWeight",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "���",
				field: "patHeight",
				width: 70,
				align: "center",
				sortable: true
			} , {
				title: "����ҩƷ���",
				field: "inciNo",
				width: 180,
				align: "left",
				sortable: true
			} , {
				title: "�Ǽ�����",
				field: "inciBatchNo",
				width: 150,
				align: "left",
				sortable: true
			} , {
				title: "ҩƷ����",
				field: "inciCode",
				width: 150,
				align: "left",
				sortable: true
			} , {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 300,
				align: "left",
				sortable: true
			} , {
				title: "��ҩ����",
				field: "dspQty",
				width: 100,
				align: "right",
				sortable: true
			} , {
				title: "��ҩ��λ",
				field: "dspUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "�հ������",
				field: "recQty",
				width: 100,
				align: "right",
				sortable: true
			} , {
				title: "����Һ����",
				field: "recFluidQty",
				width: 100,
				align: "right",
				sortable: true
			}, {
				title: "������λ",
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

// ��ʼ�� - �������͹ؼ���
function InitKeyWord(){
	$("#kwTotalType").keywords({
		singleSelect: true,
		labelCls: 'blue',
		items: [
			{
				text: '��ҽ��',
				id: '1',
				selected: true
			},
			{
				text: '��ҩƷ',
				id: '2'
			},
			{
				text: '���Ǽ�����',
				id: '3'
			}
		],
		onClick: Query
	});
}

/*
* �������
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
	var queryGridId = tabTitle == $g('��ϸ�б�') ? 'grid-narcRecDetail' : 'grid-narcRecTotal';
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

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function(retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RecQuery.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['RecQuery.EdDate']));
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}