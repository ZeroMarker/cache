/**
 * ����:   	 ����ҩƷ���ٵ� - �Ƶ�����(���ݻ���)
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.rec.csp
 * js:		 pha/in/v1/narcdestroy.rec.js
 */

/**
 * ������ڷ���
 * @param {object} _options
 * 				   _options.onSure Ϊһ���ص�����,�����Ĳ���Ϊ�����й�ѡ���е�����
 * @return
 */
function SelectByRec(_options){
	var winId = "narcdestroy_win_rec";
	var winContentId = "narcdestroy_win_rec_html";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		var contentStr = $("#" + winContentId).html();
		$('#' + winId).dialog({
			width: parseInt($(document.body).width() * 0.92),
	    	height: parseInt($(document.body).height() * 0.89),
	    	modal: true,
	    	title: "ѡ����ռ�¼",
	    	iconCls: 'icon-w-find',
	    	content: contentStr,
	    	closable: true,
	    	onClose: function() {}
		});
		InitRecLayout(_options);
	}
	$('#' + winId).dialog('open');
	RecClear();
}

function InitRecLayout(_options) {
	InitRecDict(_options);
	InitRecEvents(_options);
	InitGridDestroyItmByRec(_options);
}

// ��ʼ�� - ���ֵ�
function InitRecDict(){
	$('#rec_patNo').val('');
	$('#rec_startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#rec_endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	
	PHA.ComboBox("rec_recLocId", {
		width: 130,
		disabled: true,
		placeholder: '���տ���...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.SetComboVal('rec_recLocId', session['LOGON.CTLOCID']);
	
	PHA.ComboBox("rec_docLocId", {
		width: 130,
		placeholder: '��������...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("rec_wardLocId", {
		width: 130,
		placeholder: '����...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboGrid("rec_inci", {
		width: 130,
		panelWidth: 450,
		placeholder: 'ҩƷ...',
		url: $URL + "?ClassName=PHA.IN.Narc.Com&QueryName=INCItm&HospId=" + session['LOGON.HOSPID'],
		idField: 'inci',
		textField: 'inciDesc',
		columns:[[
			{field:'inci', title:'�����ID', width:60, hidden: true},
			{field:'inciCode', title:'����', width:120},
			{field:'inciDesc', title:'����', width:200},
			{field:'inciSpec', title:'���', width:100}
		]],
		onLoadSuccess: function(){
			return false;
		}
	});
	PHA.ComboBox("rec_admType", {
		width: 130,
		placeholder: '��������...',
		panelHeight: 'auto',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType'
	});
}

// ��ʼ�� - �¼���
function InitRecEvents(_options) {
	// ��ť
	$('#rec_btnFind').on("click", RecQuery);
    $('#rec_btnClear').on("click", RecClear);
    $('#rec_btnReadCard').on("click", RecReadCard);
    $('#rec_btnSure').on("click", function(){
	    RecSure(_options);
	});
    $('#rec_btnCancel').on("click", RecCancel);
    
	// �س�����
	$('#rec_cardNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    RecReadCard();
		}
	});
	// �ǼǺ�
	$('#rec_patNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    var tPatNo = $('#rec_patNo').val() || "";
		    if (tPatNo == "") {
			    return;
			}
		    var nPatNo = PHA_COM.FullPatNo(tPatNo);
		    $('#rec_patNo').val(nPatNo);
		    RecQuery();
		}
	});
	// ��ҩor�Ǽ�����
	$('#rec_batchNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    RecQuery();
		}
	});
}

// ��ʼ�� - ���
function InitGridDestroyItmByRec(){
	var columns = [
		[
			{
				field: 'tSelect',
				checkbox: true
			} , {
				title: "����",
				field: "pinr",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "�����¼ID",
				field: "adm",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "�ǼǺ�",
				field: "patNo",
				width: 100,
				align: "left",
				sortable: true,
				formatter: function(value, rowData, index){
					return "<a style='border:0px;cursor:pointer' onclick=OeoreDetailWin>" + value + "</a>"
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
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "����",
				field: "patAge",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "ִ�м�¼ID",
				field: "oeore",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "ҩƷ����",
				field: "inciCode",
				width: 120,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "ҩƷ����",
				field: "inciDesc",
				width: 200,
				align: "left",
				sortable: true,
				showTip: true,
				tipWidth: 200
			} , {
				title: "ҩƷ���",
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
				title: "��������",
				field: "recBatchNo",
				width: 90,
				align: "left"
			} , {
				title: "���",
				field: "inciSpec",
				width: 75,
				align: "left",
				sortable: true
			} , {
				title: "��ҩ����",
				field: "dspQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "dspUomId",
				field: "dspUomId",
				width: 75,
				align: "right",
				sortable: true,
				hidden: true
			} , {
				title: "��ҩ��λ",
				field: "dspUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "ҽ������",
				field: "doseQty",
				width: 90,
				align: "right",
				sortable: true
			} , {
				title: "������λID",
				field: "doseUomId",
				width: 75,
				align: "right",
				sortable: true,
				hidden: true
			} , {
				title: "������λ",
				field: "doseUomDesc",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "Һ�����",
				field: "recFluidQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "�հ������",
				field: "recQty",
				width: 90,
				align: "right",
				sortable: true
			} , {
				title: "���պ˶���",
				field: 'recCheckUserName',
				width: 100,
				align: "left"
			} , {
				title: "���ս�����",
				field: 'recFromUserName',
				width: 100,
				align: "left"
			} , {
				title: "��������ϵ��ʽ",
				field: "recFromUserTel",
				width: 120,
				align: "left"
			} , {
				title: "������Դ����",
				field: "recOriTypeDesc",
				width: 100,
				align: "left"
			} , {
				title: "������Դ����",
				field: "recOriLocDesc",
				width: 120
			} , {
				title: "�����������",
				field: "DSCDDesc",
				width: 160,
				align: "left"
			} , {
				title: "��������ִ����",
				field: "DSCDExeUserName",
				width: 120,
				align: "left"
			} , {
				title: "��������ල��",
				field: "DSCDSuperUserName",
				width: 120,
				align: "left"
			} , {
				title: "���տ���",
				field: "recLocDesc",
				width: 130,
				align: "left"
			} , {
				title: "������",
				field: "recUserName",
				width: 100,
				align: "left"
			} , {
				title: "��������",
				field: "recDate",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "����ʱ��",
				field: "recTime",
				width: 90,
				align: "center",
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
			} , {
				title: "����״̬",
				field: "recStateDesc",
				width: 70,
				align: "center",
				sortable: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcRec.Query',
			QueryName: 'NarcRec'
		},
		singleSelect: false,
		pagination: true,
		pageSize: 500,
		columns: columns,
		toolbar: "#gridDestroyItmByRecBar",
		onClickCell: function(index, field, value) {
			if (field == "patNo") {
				var rowsData = $(this).datagrid('getRows');
				var rowData = rowsData[index];
				var oeore = rowData.oeore || "";
				OeoreDetailWin(oeore);
			}
		},
        onLoadSuccess: function(data){
	        $('#gridDestroyItmByRec').siblings('.datagrid-view2').find('.datagrid-header-check').children().eq(0).prop("checked", false);
	    }
	};
	PHA.Grid("gridDestroyItmByRec", dataGridOption);
}


/*
* �������
*/
function RecQuery(){
	var formDataArr = PHA.DomData("#gridDestroyItmByRecBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.recState = "Y";						// �ѻ���
	formData.destroyState = "N"; 					// δ����
	formData = replaceKey(formData);
	formData.hospId = session['LOGON.HOSPID'];
	
	var InputStr = JSON.stringify(formData);
	$('#gridDestroyItmByRec').datagrid('query', {
		InputStr: InputStr
	});
}

function RecClear(){
	PHA.DomData("#gridDestroyItmByRecBar", {doType: 'clear'});
	$('#gridDestroyItmByRec').datagrid('clear');
	$('#rec_startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#rec_endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
}

function RecSure(_options){
	var selectedRows = $('#gridDestroyItmByRec').datagrid('getSelections');
	if (!selectedRows) {
		PHA.Popover({
			msg: "�빴ѡ���ռ�¼",
			type: "alert"
		});
		return;
	}
	if (selectedRows && selectedRows.length == 0) {
		PHA.Popover({
			msg: "�빴ѡ���ռ�¼",
			type: "alert"
		});
		return;
	}
	_options.onSure && _options.onSure(selectedRows);
	$('#narcdestroy_win_rec').dialog('close');
}

function RecCancel(){
	$('#narcdestroy_win_rec').dialog('close');
}

function RecReadCard(){
	PHA_COM.ReadCard({
		CardNoId: 'rec_cardNo',
		PatNoId: 'rec_patNo'
	}, function(readRet){
		RecQuery();
	});
}