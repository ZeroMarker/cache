/**
 * 名称:   	 毒麻药品销毁单 - 制单界面(依据报损)
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.scrap.csp
 * js:		 pha/in/v1/narcdestroy.scrap.js
 */

/**
 * 弹窗入口方法
 * @param {object} _options
 * 				   _options.onSure 为一个回调函数,函数的参数为弹窗中勾选的行的数据
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
	    	title: "选择报损记录",
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
		placeholder: '报损科室...',
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
    
	// 回车读卡
	$('#scrap_inscpNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    ScrapQuery();
		}
	});
}

// 初始化 - 表格
function InitGridDestroyItmByScrap(){
	var columns = [
		[
			{
				field: 'tSelect',
				checkbox: true
			} , {
				title: "报损单明细ID",
				field: "inspi",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "报损单号",
				field: "inscpNo",
				width: 180,
				align: "left",
				sortable: true
			} , {
				title: "报损日期",
				field: "inscpChkDate",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "报损时间",
				field: "inscpChkTime",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "报损审核人",
				field: "inscpUserName",
				width: 120,
				align: "left",
				sortable: true
			} , {
				title: "药品代码",
				field: "inciCode",
				width: 100,
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
				title: "药品规格",
				field: "inciSpec",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "报损数量",
				field: "inspiQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "数量单位ID",
				field: "bUomId",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "数量单位",
				field: "bUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "销毁液体",
				field: "inspiFluidQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "液体单位ID",
				field: "eUomId",
				width: 75,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "液体单位",
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
* 界面操作
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
			msg: "请勾选报损明细",
			type: "alert"
		});
		return;
	}
	if (selectedRows && selectedRows.length == 0) {
		PHA.Popover({
			msg: "请勾选报损明细",
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