/**
 * ����:   	 ����ҩƷ���ٵ� - �Ƶ�����(���ݱ���)
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.scrap.csp
 * js:		 pha/in/v1/narcdestroy.scrap.js
 */

/**
 * ������ڷ���
 * @param {object} _options
 * 				   _options.onSure Ϊһ���ص�����,�����Ĳ���Ϊ�����й�ѡ���е�����
 * @return
 */
function SelectByScrap(_options){
	var winId = "narcdestroy_win_scrap";
	var winContentId = "narcdestroy_win_scrap_html";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		var contentStr = $("#" + winContentId).html();
		$('#' + winId).dialog({
			width: parseInt($(document.body).width() * 0.92),
	    	height: parseInt($(document.body).height() * 0.92),
	    	modal: true,
	    	title: "ѡ�����¼",
	    	iconCls: 'icon-w-find',
	    	content: contentStr,
	    	closable: true,
	    	onClose: function() {}
		});
		InitScrapLayout(_options);
	}
	$('#' + winId).dialog('open');
	ScrapClear();
}

function InitScrapLayout(_options){
	InitScrapDict(_options);
	InitScrapEvents(_options);
	InitGridDestroyItmByScrap(_options);
}

function InitScrapDict(_options){
	PHA.ComboBox('scrap_locId', {
		placeholder: '�������...',
		url: PHA_STORE.CTLoc().url + '&HospId=' + session['LOGON.HOSPID']
	});
	$('#scrap_inscpNo').val('');
	$('#scrap_startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#scrap_endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
}

function InitScrapEvents(_options){
	$('#scrap_btnFind').on("click", ScrapQuery);
    $('#scrap_btnClear').on("click", ScrapClear);
	$('#scrap_btnSure').on("click", function(){
	    ScrapSure(_options);
	});
    $('#scrap_btnCancel').on("click", ScrapCancel);
    
	// �س�����
	$('#scrap_inscpNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    ScrapQuery();
		}
	});
}

// ��ʼ�� - ���
function InitGridDestroyItmByScrap(){
	var columns = [
		[
			{
				field: 'tSelect',
				checkbox: true
			} , {
				title: "������ϸID",
				field: "inspi",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "���𵥺�",
				field: "inscpNo",
				width: 180,
				align: "left",
				sortable: true
			} , {
				title: "��������",
				field: "inscpChkDate",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "����ʱ��",
				field: "inscpChkTime",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "���������",
				field: "inscpUserName",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "ҩƷ����",
				field: "inciCode",
				width: 100,
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
				title: "ҩƷ���",
				field: "inciSpec",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "��������",
				field: "inspiQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "������λID",
				field: "bUomId",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "������λ",
				field: "bUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "����Һ��",
				field: "inspiFluidQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "Һ�嵥λID",
				field: "eUomId",
				width: 75,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "Һ�嵥λ",
				field: "eUomDesc",
				width: 75,
				align: "center",
				sortable: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcDestroy.Query',
			QueryName: 'INSpItm'
		},
		singleSelect: false,
		pagination: true,
		pageSize: 500,
		columns: columns,
		toolbar: "#gridDestroyItmByScrapBar",
		onClickCell: function(index, field, value) {},
        onLoadSuccess: function(data){
	        $('#gridDestroyItmByScrap').siblings('.datagrid-view2').find('.datagrid-header-check').children().eq(0).prop("checked", false);
	    }
	};
	PHA.Grid("gridDestroyItmByScrap", dataGridOption);
}

/*
* �������
*/
function ScrapQuery(){
	var formDataArr = PHA.DomData("#gridDestroyItmByScrapBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData = replaceKey(formData);
	formData.hospId = session['LOGON.HOSPID'];
	
	var InputStr = JSON.stringify(formData);
	$('#gridDestroyItmByScrap').datagrid('query', {
		InputStr: InputStr
	});
}

function ScrapClear(){
	PHA.DomData("#gridDestroyItmByScrapBar", {doType: 'clear'});
	$('#scrap_startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#scrap_endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	PHA.SetComboVal('#scrap_locId', session['LOGON.CTLOCID']);
	$('#gridDestroyItmByScrap').datagrid('clear');
}

function ScrapSure(_options){
	var selectedRows = $('#gridDestroyItmByScrap').datagrid('getSelections');
	if (!selectedRows) {
		PHA.Popover({
			msg: "�빴ѡ������ϸ",
			type: "alert"
		});
		return;
	}
	if (selectedRows && selectedRows.length == 0) {
		PHA.Popover({
			msg: "�빴ѡ������ϸ",
			type: "alert"
		});
		return;
	}
	
	_options.onSure && _options.onSure(selectedRows);
	$('#narcdestroy_win_scrap').dialog('close');
}

function ScrapCancel(){
	$('#narcdestroy_win_scrap').dialog('close');
}