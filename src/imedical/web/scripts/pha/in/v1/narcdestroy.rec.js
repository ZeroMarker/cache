/**
 * 名称:   	 毒麻药品销毁单 - 制单界面(依据回收)
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcdestroy.rec.csp
 * js:		 pha/in/v1/narcdestroy.rec.js
 */

/**
 * 弹窗入口方法
 * @param {object} _options
 * 				   _options.onSure 为一个回调函数,函数的参数为弹窗中勾选的行的数据
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
	    	title: "选择回收记录",
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

// 初始化 - 表单字典
function InitRecDict(){
	$('#rec_patNo').val('');
	$('#rec_startDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.StDate']));
	$('#rec_endDate').datebox('setValue',  PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Destroy.EdDate']));
	
	PHA.ComboBox("rec_recLocId", {
		width: 130,
		disabled: true,
		placeholder: '回收科室...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.SetComboVal('rec_recLocId', session['LOGON.CTLOCID']);
	
	PHA.ComboBox("rec_docLocId", {
		width: 130,
		placeholder: '开单科室...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("rec_wardLocId", {
		width: 130,
		placeholder: '病区...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboGrid("rec_inci", {
		width: 130,
		panelWidth: 450,
		placeholder: '药品...',
		url: $URL + "?ClassName=PHA.IN.Narc.Com&QueryName=INCItm&HospId=" + session['LOGON.HOSPID'],
		idField: 'inci',
		textField: 'inciDesc',
		columns:[[
			{field:'inci', title:'库存项ID', width:60, hidden: true},
			{field:'inciCode', title:'代码', width:120},
			{field:'inciDesc', title:'名称', width:200},
			{field:'inciSpec', title:'规格', width:100}
		]],
		onLoadSuccess: function(){
			return false;
		}
	});
	PHA.ComboBox("rec_admType", {
		width: 130,
		placeholder: '就诊类型...',
		panelHeight: 'auto',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType'
	});
}

// 初始化 - 事件绑定
function InitRecEvents(_options) {
	// 按钮
	$('#rec_btnFind').on("click", RecQuery);
    $('#rec_btnClear').on("click", RecClear);
    $('#rec_btnReadCard').on("click", RecReadCard);
    $('#rec_btnSure').on("click", function(){
	    RecSure(_options);
	});
    $('#rec_btnCancel').on("click", RecCancel);
    
	// 回车读卡
	$('#rec_cardNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    RecReadCard();
		}
	});
	// 登记号
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
	// 发药or登记批号
	$('#rec_batchNo').on('keydown', function(e){
	    if (e.keyCode == 13) {
		    RecQuery();
		}
	});
}

// 初始化 - 表格
function InitGridDestroyItmByRec(){
	var columns = [
		[
			{
				field: 'tSelect',
				checkbox: true
			} , {
				title: "主键",
				field: "pinr",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "就诊记录ID",
				field: "adm",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "登记号",
				field: "patNo",
				width: 100,
				align: "left",
				sortable: true,
				formatter: function(value, rowData, index){
					return "<a style='border:0px;cursor:pointer' onclick=OeoreDetailWin>" + value + "</a>"
				}
			} , {
				title: "患者姓名",
				field: "patName",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "性别",
				field: "patSex",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "年龄",
				field: "patAge",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "执行记录ID",
				field: "oeore",
				width: 100,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "药品代码",
				field: "inciCode",
				width: 120,
				align: "left",
				sortable: true,
				hidden: true
			} , {
				title: "药品名称",
				field: "inciDesc",
				width: 200,
				align: "left",
				sortable: true,
				showTip: true,
				tipWidth: 200
			} , {
				title: "药品编号",
				field: "inciNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "登记批号",
				field: "inciBatchNo",
				width: 100,
				align: "left",
				sortable: true
			} , {
				title: "回收批号",
				field: "recBatchNo",
				width: 90,
				align: "left"
			} , {
				title: "规格",
				field: "inciSpec",
				width: 75,
				align: "left",
				sortable: true
			} , {
				title: "发药数量",
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
				title: "发药单位",
				field: "dspUomDesc",
				width: 75,
				align: "center",
				sortable: true
			} , {
				title: "医嘱剂量",
				field: "doseQty",
				width: 90,
				align: "right",
				sortable: true
			} , {
				title: "剂量单位ID",
				field: "doseUomId",
				width: 75,
				align: "right",
				sortable: true,
				hidden: true
			} , {
				title: "剂量单位",
				field: "doseUomDesc",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "液体残量",
				field: "recFluidQty",
				width: 75,
				align: "right",
				sortable: true
			} , {
				title: "空安瓿数量",
				field: "recQty",
				width: 90,
				align: "right",
				sortable: true
			} , {
				title: "回收核对人",
				field: 'recCheckUserName',
				width: 100,
				align: "left"
			} , {
				title: "回收交回人",
				field: 'recFromUserName',
				width: 100,
				align: "left"
			} , {
				title: "交回人联系方式",
				field: "recFromUserTel",
				width: 120,
				align: "left"
			} , {
				title: "回收来源类型",
				field: "recOriTypeDesc",
				width: 100,
				align: "left"
			} , {
				title: "回收来源科室",
				field: "recOriLocDesc",
				width: 120
			} , {
				title: "残量处理意见",
				field: "DSCDDesc",
				width: 160,
				align: "left"
			} , {
				title: "残量处理执行人",
				field: "DSCDExeUserName",
				width: 120,
				align: "left"
			} , {
				title: "残量处理监督人",
				field: "DSCDSuperUserName",
				width: 120,
				align: "left"
			} , {
				title: "回收科室",
				field: "recLocDesc",
				width: 130,
				align: "left"
			} , {
				title: "回收人",
				field: "recUserName",
				width: 100,
				align: "left"
			} , {
				title: "回收日期",
				field: "recDate",
				width: 100,
				align: "center",
				sortable: true
			} , {
				title: "回收时间",
				field: "recTime",
				width: 90,
				align: "center",
				sortable: true
			} , {
				title: "预计执行时间",
				field: "dosingDT",
				width: 150,
				align: "center",
				sortable: true
			} , {
				title: "护士执行时间",
				field: "exeDT",
				width: 150,
				align: "center",
				sortable: true
			} , {
				title: "回收状态",
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
* 界面操作
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
	formData.recState = "Y";						// 已回收
	formData.destroyState = "N"; 					// 未销毁
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
			msg: "请勾选回收记录",
			type: "alert"
		});
		return;
	}
	if (selectedRows && selectedRows.length == 0) {
		PHA.Popover({
			msg: "请勾选回收记录",
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