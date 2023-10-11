/**
 * ����:   	 ҩ��ҩ��-����ҩƷ���� - �ۺϲ�ѯ
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-24
 * csp:		 pha.in.v1.narcquerycom.csp
 * js:		 pha/in/v1/narcquerycom.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcquerycom.csp';
PHA_COM.App.Name = '����ҩƷ�ۺϲ�ѯ';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function() {
	$('#panel-narccom').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '����ҩƷ���� - �ۺϲ�ѯ' : '', 
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

// ��ʼ�� - ���ֵ�
function InitDict(){
	var formWidth = 155;
	PHA.ComboBox("phLocId", {
		placeholder: '��ҩ����...',
		width: formWidth,
		url: PHA_STORE.CTLoc().url + "&TypeStr=D&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("docLocId", {
		placeholder: '��������...',
		width: formWidth,
		url: PHA_STORE.DocLoc().url + "&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("recLocId", {
		placeholder: '���տ���...',
		width: formWidth,
		url: PHA_STORE.CTLoc().url + "&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("admType", {
		placeholder: '��������...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType',
		panelHeight: 'auto'
	});
	PHA.ComboBox("oeoriState", {
		placeholder: 'ҽ��״̬...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEORIStatus'
	});
	PHA.ComboBox("oeoreState", {
		placeholder: 'ִ�м�¼״̬...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEOREStatus'
	});
	PHA.ComboBox("wardLocId", {
		placeholder: '����...',
		width: formWidth,
		url: PHA_STORE.CTLoc().url + "&TypeStr=W&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox("dspState", {
		placeholder: '��ҩ״̬...',
		width: formWidth,
		data: [
			{RowId: 'Y', Description: '�ѷ�ҩ'},
			{RowId: 'N', Description: 'δ��ҩ'}
		],
		panelHeight: 'auto'
	});
	PHA.ComboBox("regState", {
		placeholder: '�Ǽ�״̬...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RegStatus',
		panelHeight: 'auto'
	});
	PHA.ComboBox("recState", {
		placeholder: '����״̬...',
		width: formWidth,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RecStatus',
		panelHeight: 'auto'
	});
	/*
	PHA.ComboBox("destroyState", {
		placeholder: '����״̬...',
		width: formWidth,
		data: [
			{RowId: 'A', Description: 'ȫ��'},
			{RowId: 'Y', Description: '������'},
			{RowId: 'N', Description: 'δ����'}
		],
		panelHeight: 'auto'
	});
	*/
	PHA.ComboBox("poisonIdStr", {
		placeholder: '���Ʒ���...',
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
		buttonTextArr: ['����', '����'],
		selectedText: '����',
		onClick: function (oldText, newText) {
			if (oldText == '����') {
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
}

// ��ʼ�����
function InitGridNarcCom(){
	var frozenColumns = [[
		{
			title: "ִ�м�¼ID",
			field: "oeore",
			width: 100,
			align: "left",
			formatter: function(value, rowData, index){
				return "<a style='border:0px;cursor:pointer' onclick=''>" + value + "</a>";
			}
		} ,{
			title: "�ǼǺ�",
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
				title: "��������",
				field: "patName",
				width: 100,
				align: "left"
			} , {
				title: "��ҩ����",
				field: "phLodDesc",
				width: 120,
				align: "left"
			} , {
				title: "ҽ��״̬",
				field: "oeoriStateDesc",
				width: 80,
				align: "left"
			} , {
				title: "ִ��״̬",
				field: "oeoreStateDesc",
				width: 80,
				align: "left"
			} , {
				title: "ҽ�����ȼ�",
				field: "priDesc",
				width: 100,
				align: "left"
			} , {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 180,
				align: "left",
				showTip: true,
				tipWidth: 180
			} , {
				title: "Ԥ��ִ��ʱ��",
				field: "dosingDT",
				width: 150,
				align: "left"
			} , {
				title: "��ʿִ��ʱ��",
				field: "exeDT",
				width: 150,
				align: "left"
			} , {
				title: "����",
				field: "doseQty",
				width: 100,
				align: "left"
			} , {
				title: "�÷�",
				field: "instDesc",
				width: 100,
				align: "left"
			} , {
				title: "��ҩ״̬",
				field: "dspStateDesc",
				width: 80,
				align: "left"
			} , {
				title: "��ҩ����",
				field: "dspDate",
				width: 100,
				align: "left"
			} , {
				title: "��ҩʱ��",
				field: "dspTime",
				width: 100,
				align: "left"
			} , {
				title: "��ҩ����",
				field: "dspQty",
				width: 70,
				align: "left"
			} , {
				title: "��ҩ��λ",
				field: "dspUomDesc",
				width: 70,
				align: "left"
			} , {
				title: "��ҩ��",
				field: "dspUserName",
				width: 90,
				align: "left"
			} , {
				title: "��ҩ����",
				field: "dspLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "�Ǽ�״̬",
				field: "regStateDesc",
				width: 80,
				align: "center"
			} , {
				title: "����ҩƷ���",
				field: "inciNo",
				width: 100,
				align: "left"
			} , {
				title: "�Ǽ�����",
				field: "inciBatchNo",
				width: 100,
				align: "left"
			} , {
				title: "�Ǽǿ���",
				field: "regLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "�Ǽ���",
				field: "regUserName",
				width: 90,
				align: "left"
			} , {
				title: "�Ǽ�����",
				field: "regDate",
				width: 90,
				align: "center"
			} , {
				title: "�Ǽ�ʱ��",
				field: "regTime",
				width: 80,
				align: "center"
			} , {
				title: "ʵ����ҩ��",
				field: "useQty",
				width: 85,
				align: "center",
				formatter: function(value, rowData, rowIndex){
					return (value == "" ? "" : value + rowData.doseUomDesc);
				}
			} , {
				title: "����״̬",
				field: "recStateDesc",
				width: 80,
				align: "center"
			} , {
				title: "������Դ����",
				field: "recOriTypeDesc",
				width: 100,
				align: "center"
			} , {
				title: "������Դ����",
				field: "recOriLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "���տ���",
				field: "recLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "�հ������",
				field: "recQty",
				width: 100,
				align: "right"
			} , {
				title: "Һ�����",
				field: "recFluidQty",
				width: 100,
				align: "right",
				formatter: function(value, rowData, rowIndex){
					return (value == "" ? "" : value + rowData.doseUomDesc);
				}
			} , {
				title: "������",
				field: "recUserName",
				width: 90,
				align: "left"
			} , {
				title: "��������",
				field: "recDate",
				width: 90,
				align: "left"
			} , {
				title: "����ʱ��",
				field: "recTime",
				width: 80,
				align: "center"
			} , {
				title: "���պ˶���",
				field: "recCheckUserName",
				width: 90,
				align: "left"
			} , {
				title: "�����ͻ���",
				field: "recFromUserName",
				width: 90,
				align: "left"
			} , {
				title: "��������",
				field: "recBatchNo",
				width: 100,
				align: "left"
			} , {
				title: "�����������",
				field: "DSCDDesc",
				width: 120,
				align: "left"
			} , {
				title: "��������ִ����",
				field: "DSCDExeUserName",
				width: 130,
				align: "left"
			} , {
				title: "��������ල��",
				field: "DSCDSuperUserName",
				width: 130,
				align: "left"
			} , {
				title: "����״̬",
				field: "destroyStateDesc",
				width: 90,
				align: "center"
			} , {
				title: "���ٿ���",
				field: "pindLocDesc",
				width: 120,
				align: "left"
			} , {
				title: "���ٵ���",
				field: "pindNo",
				width: 170,
				align: "left"
			} , {
				title: "��������",
				field: "pindDate",
				width: 90,
				align: "center"
			} , {
				title: "����ʱ��",
				field: "pindTime",
				width: 80,
				align: "center"
			} , {
				title: "����ִ����",
				field: "pindExeUserStr",
				width: 90,
				align: "left"
			} , {
				title: "����������",
				field: "pindAuditUserStr",
				width: 90,
				align: "left"
			} , {
				title: "���ټල��",
				field: "pindSuperUserStr",
				width: 90,
				align: "left"
			} , {
				title: "���ٵص�",
				field: "pindPlace",
				width: 120,
				align: "left"
			} , {
				title: "���ٷ�ʽ",
				field: "pindTypeDesc",
				width: 90,
				align: "left"
			} , {
				title: "���ٿհ������",
				field: "pindiQty",
				width: 110,
				align: "right"
			}, {
				title: "����Һ����",
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
			msg: '�ѻ���״̬�Ĳ�ѯ��ѡ����տ���!',
			type: "alert"
		});
		return;
	}
	if (recLocId != "" && formData.recState != "Y") {
		PHA.Popover({
			msg: '��ѡ���տ���,��ѡ�����״̬Ϊ[�ѻ���]!',
			type: "alert"
		});
		return;
	}
	
	// ҽԺ
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

function OpenStepWin(index){
	var rowsData = $('#grid-narccom').datagrid('getRows');
	var rowData = rowsData[index];
	var oeore = rowData.oeore || "";
	
	// ����
	var winWidth = parseInt($(document.body).width() * 0.9);
	var winId = "narc_win_step";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
	    	height: 160,
	    	modal: true,
	    	title: "����ҩƷִ�м�¼׷��",
	    	iconCls: 'icon-w-find',
	    	content: "<div id='hstp' style='height:90px;margin:10px;'></div>",
	    	closable: true,
	    	onClose: function() {}
		});
	}
	
	// ����
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
	
	// �򿪴���
	$('#' + winId).dialog('open');
	
	// ========================
	// Ϊ�յĲ���ʾ��ɫ
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
		// ���ݸ�ȫ�� (���ʱ�ָ�)
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
		$('#endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	}, function(error){
		console.dir(error);
		alert(error.responseText);
	});
}