/**
 * FileName: scripts/dhcinsu/revstrnsLog.js
 * hznzh
 * Date: 2021-09-14
 * Description: 冲正交易
 */
var GV = {

	HospId: session['LOGON.HOSPID'],
	UserCode: session['LOGON.USERCODE'],
	UserId: session['LOGON.USERID'],
	HiType: ""
}

$(document).ready(function () {

	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	var HospIdTdWidth = $("#HospIdTd").width()    //初始化院区宽度  2023/2/8 jins1010
	var opt = { width: HospIdTdWidth }
	var hospComp = GenUserHospComp(opt);
	$.extend(hospComp.jdata.options, {
		onSelect: function (index, row) {
			Clean();
			LoadTrnsList();
		},
		onLoadSuccess: function (data) {
			Clean();
			initMenu();
		}
	});
});
function initMenu() {
	//初始化查询条件
	init_SearchPanel();

	//回车事件
	init_Keyup();

	//按钮事件
	init_Btn();

	//InvList
	init_dg();

	//日期初始化
	init_Date();

	//初始化就诊记录
	InitAdmLst();
}
function init_Date() {
	InsuDateDefault('StartDate', -1);
	InsuDateDefault('EndDate');
}
function init_SearchPanel() {
	InitInsuTypeCmb();
	$('#RevsStas').combobox({
		panelHeight: 100,
		valueField: 'Code',
		textField: 'Desc',
		data: [{
			Code: '',
			Desc: '全部',
			selected: true
		}, {
			Code: '0',
			Desc: '未冲正'
		}, {
			Code: '1',
			Desc: '已冲正'
		}]

	});
	$('#IsRevs').combobox({
		panelHeight: 100,
		valueField: 'Code',
		textField: 'Desc',
		limitToList: true,
		data: [{
			Code: '',
			Desc: '全部',
			selected: true
		}, {
			Code: '0',
			Desc: '否'
		}, {
			Code: '1',
			Desc: '是'
		}],
		onLoadSuccess: function () {
			$('#IsRevs').combobox('select', 1);
		}
	});
	$('#Infno').combobox({
		panelHeight: 100,
		valueField: 'Code',
		textField: 'Desc',
		data: [{
			Code: '',
			Desc: '全部',
			selected: true
		}, {
			Code: '2401',
			Desc: '2401-入院办理'
		}, {
			Code: '2304',
			Desc: '2304-住院结算'
		},
		{
			Code: '2207',
			Desc: '2207-门诊结算'
		}, {
			Code: '2208',
			Desc: '2208-门诊结算撤销'
		}, {
			Code: '2305',
			Desc: '2305-住院结算撤销'
		}, {
			Code: '2102',
			Desc: '2102-药店结算'
		}, {
			Code: '2103',
			Desc: '2103-药店结算撤销'
		}]
	});
	if (GV.UserCode != "") {
		setValueById('UserCode', GV.UserCode);

		//$("#UserCode").attr("readOnly",true);
		$("#UserCode").attr("onfocus", "this.blur()");
		$("#UserCode").css("background", "#F7F7F7");
	}
	$("#info").select();
	$('#InfoWin').dialog({

		buttons: [{
			text: '关闭',
			handler: function () {
				$('#InfoWin').dialog('close');
			}
		},
		{
			text: '复制',
			handler: function () {
				//copyText($("#copyInfo").text());
				//var text = document.getElementById("copyInfo").innerText;
				//var input = document.getElementById("input");
				//input.value = text; // 修改文本框的内容
				//input.select(); // 选中文本
				//document.execCommand("copy"); // 执行浏览器复制命令
				//$.messager.alert("提示", "复制成功!", 'info');

				//upt HanZH 20220930
				var pre = document.getElementById("copyInfo")
				var text = pre.innerText;
				var input = $("<textarea></textarea>");
				input.text(text); // 修改文本框的内容
				input.appendTo(pre);
				input.select(); // 选中文本
				document.execCommand("copy"); // 执行浏览器复制命令
				input.remove();
				//$.messager.alert("提示", "复制成功!", 'info');
				$.messager.popover({
					msg: '复制成功：',
					type: 'info',
					timeout: 1000, 		//0不自动关闭。3000s
					showType: 'slide'
				});
			}
		}]
	})
}

// TrnsList
function LoadTrnsList() {

	if (GV.HiType == "") { $.messager.alert("提示", "请选择医保类型", 'info'); return; }

	ClearGrid('dg');
	var queryParams = { // StDate, EnDate, HospId, RevsStas, IsRevs, UserCode, Infno, PsnNo, SenderTrnsSn, AdmDr, PrtDr, BillDr
		ClassName: 'INSU.MI.BL.RevsTrnsLogCtl',
		QueryName: 'QueryRevsTrnsLog',
		StDate: getValueById('StartDate'),
		EndDate: getValueById('EndDate'),
		HiType: GV.HiType,
		HospId: GV.HospId,
		RevsStas: $('#RevsStas').combobox('getValue'),
		IsRevs: $('#IsRevs').combobox('getValue'),
		UserCode: getValueById('UserCode'),
		Infno: $('#Infno').combobox('getValue'),
		PsnNo: getValueById('PsnNo'),
		SenderTrnsSn: getValueById('SenderTrnsSn'),
		AdmDr: getValueById('AdmDr'),
		PrtDr: getValueById('PrtDr'),
		BillDr: getValueById('BillDr')
	}
	loadDataGridStore('dg', queryParams);
}


/**
 * Creator: hanzh
 * CreatDate: 2021-09-16
 * Description: 查询面板回车事件
 */
function init_Keyup() {
	$('#UserCode').keyup(function () {

		if (event.keyCode == 13) {

			Clean();
			LoadTrnsList();
		}
	});
	//登记号回车事件
	$("#RegNo").keyup(function () {
		if (event.keyCode == 13) {
			Clean(1);
			var tmpRegNo = $('#RegNo').val();
			if (tmpRegNo == "") {
				$.messager.alert("提示", "登记号不能为空!", 'info');
				return;
			}
			var RegNoLength = 10 - tmpRegNo.length;     //登记号补零   	
			for (var i = 0; i < RegNoLength; i++) {
				tmpRegNo = "0" + tmpRegNo;
			}
			RegNo = tmpRegNo;
			setValueById('RegNo', RegNo)              //登记号补全后回写
			AdmDr = "";
			var rtn = ""
			rtn = tkMakeServerCall("INSU.MI.BL.RevsTrnsLogCtl", "GetPatInfoByPatNo", "", "", RegNo, GV.HospId);
			if (typeof rtn != "string") {
				return;
			}
			if (rtn.split("!")[0] != "1") {
				setTimeout(function () { $.messager.alert('提示', '请输入正确的登记号!', 'error') }, 200);
				return;
			}
			else {
				var PatAry = (rtn.split("!")[1]).split("^");
				setValueById("PapmiDr", PatAry[0]);        //DingSH 2021-09-17
				QryAdmLst();
			}
		}

	});
	$('#PsnNo').keyup(function () {
		if (event.keyCode == 13) {
			Clean();
			LoadTrnsList();
		}
	});
	$('#SenderTrnsSn').keyup(function () {
		if (event.keyCode == 13) {
			Clean();
			LoadTrnsList();
		}
	});

	$('#AdmDr').keyup(function () {
		if (event.keyCode == 13) {
			LoadTrnsList();
		}
	});
	$('#PrtDr').keyup(function () {
		if (event.keyCode == 13) {
			LoadTrnsList();
		}
	});
	$('#BillDr').keyup(function () {
		if (event.keyCode == 13) {
			LoadTrnsList();
		}
	});
}
function ClearPaadmInfo(AFlag) {
	AdmDr = "";
	//setValueById('AdmDate',"");
	$HUI.combogrid("#AdmLst").clear();
	$('#AdmLst').combogrid('grid').datagrid("loadData", { total: -1, rows: [] });
}

//初始化就诊记录函数
function InitAdmLst() {
	$('#AdmLst').combogrid({
		panelWidth: 380,
		method: 'GET',
		idField: 'AdmDr',
		textField: 'AdmNo',
		columns: [[
			{ field: 'AdmDr', title: 'AdmDr', width: 60 },
			{ field: 'DepDesc', title: '就诊科室', width: 160 },
			{ field: 'AdmDate', title: '就诊日期', width: 100 },
			{ field: 'AdmTime', title: '就诊时间', width: 100 }
		]],
		onClickRow: function (rowIndex, rowData) {
			var AdmLstVal = rowData.DepDesc + "-" + rowData.AdmDate;  //+" "+rowData.AdmTime
			$('#AdmLst').combogrid("setValue", AdmLstVal);
			setValueById('AdmDr', rowData.AdmDr);
		},

		onLoadSuccess: function (data) {
			if (data.total < 0) {
				return;
			}
			if (data.total == 0) {
				$.messager.alert("提示", "没有查询到病人就诊记录!", 'info');
				return;
			}
			else {
				var rowData = data.rows[0];
				$('#AdmLst').combogrid("setValue", rowData.DepDesc + "-" + rowData.AdmDate); //+" "+rowData.AdmTime
				setValueById('AdmDr', rowData.AdmDr)

			}

		}
	});

}

//查询就诊记录函数
function QryAdmLst() {
	var tURL = $URL + "?ClassName=" + 'INSU.MI.BL.RevsTrnsLogCtl' + "&MethodName=" + "GetPaAdmListByPatNo" + "&PapmiNo=" + getValueById('RegNo') + "&itmjs=" + "HUIToJson" + "&itmjsex=" + "" + "&HospDr=" + GV.HospId
	$('#AdmLst').combogrid({ url: tURL });
	//s AdmDr=
	//setValueById('AdmDr',rowData.AdmDr);
}
/**
 *按钮Click事件
*/
function init_Btn() {
	//查询按钮事件
	$("#btnFind").click(function () {
		LoadTrnsList();
	});

	//冲正按钮事件
	$("#btnTrns").click(function () {
		RevsTrns();
	});
	//清屏按钮事件
	$("#btnClear").click(function () {
		Clean();
	});

}
//grid
function init_dg() {
	grid = $('#dg').datagrid({
		autoSizeColumn: false,
		fit: true,
		striped: false,
		singleSelect: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		border: false,
		cache: true,
		pagination: true,
		frozenColumns: [[
			{ field: 'Ind', title: '序号', width: 60 },
			{ field: 'Rowid', title: '冲正交易表Id', width: 60, hidden: true },
			{ field: 'PapmiNo', title: '登记号', width: 100 },
			{ field: 'Name', title: '姓名', width: 80 },
			{ field: 'Poolarea', title: '统筹区', width: 100 },
			{ field: 'InfnoDesc', title: '交易名称', width: 80 },
			{ field: 'HiType', title: '医保类型', width: 80, hidden: true },
			{ field: 'HiTypeDesc', title: '医保类型', width: 80 },
			{ field: 'tPsnNo', title: '个人编号', width: 220 },
			{ field: 'tSenderTrnsSn', title: '发送方交易流水号', width: 255 },
			{ field: 'RevsStas', title: '冲正状态', width: 80, styler: setRevsStasStyle, align: 'center' },
			{ field: 'IsRevs', title: '是否可冲正', width: 80, styler: setIsRevsStyle, align: 'center' },
			{ field: 'TrnsInptPara', title: '入参', width: 50, formatter: setInputInfoFormatter },
			{ field: 'TrnsOutPara', title: '出参', width: 50, formatter: setResponseInfoFormatter },
			{ field: 'PoolareaNo', title: '统筹区编号', width: 80 },
			{ field: 'Infno', title: '交易代码', width: 80 }
		]],
		columns: [[ // PrtRowID:%String,PrtInv:%String,PatName:%String,PatIPNo:%String,PrtAcount:%String,PrtPayMode:%String,TMyRealAmt:%String,TPrtDate,TPrtTime
			{ field: 'RevsOpterName', title: '冲正操作员', width: 100 },
			{ field: 'RevsOptDate', title: '冲正日期', width: 100 },
			{ field: 'RevsOptTime', title: '冲正时间', width: 100 },
			{ field: 'UserName', title: '创建人', width: 100 },
			{ field: 'CrteDate', title: '创建日期', width: 100 },
			{ field: 'CrteTime', title: '创建时间', width: 80 },
			{ field: 'PapmiDr', title: '基本信息表Dr', width: 100 },
			{ field: 'tAdmDr', title: '就诊表Dr', width: 70 },
			{ field: 'tPrtDr', title: '发票表Dr', width: 70 },
			{ field: 'tBillDr', title: '账单表Dr', width: 70 },
			{ field: 'TrnsLogDr', title: '交易日志指针', width: 80, hidden: true },
			{ field: 'RevsTrnsMsgId', title: '冲正交易报文ID', width: 120, hidden: true },
			{ field: 'RecerTrnsSn', title: '接收方交易流水号', width: 120, hidden: true }

		]],
		onSelect: function (rowIndex, rowData) {
			//setValueById('PsnNo',rowData.tPsnNo);		WangXQ 20221024
			//setValueById('SenderTrnsSn',rowData.tSenderTrnsSn);
			SetBtnIsDisabled(rowData.RevsStas, rowData.IsRevs);  //20210916 DingSH
		},
		onUnselect: function (rowIndex, rowData) {
		},
		onBeforeLoad: function (param) {
		},
		onLoadSuccess: function (data) {

		}
	});
}
function ClearGrid(gridid) {
	$('#' + gridid).datagrid('loadData', { total: 0, rows: [] });
}

function setInputInfoFormatter(value, row, index) {
	if (row.TrnsInptPara == "") {
		return;
	}
	return "<span class='linkinfo' style='color:#339EFF' onclick='showInputJson(" + row.TrnsLogDr + "," + row.Infno + ")'>详情</span>";
}

function setResponseInfoFormatter(value, row, index) {
	if (row.TrnsOutPara == "") {
		return;
	}
	return "<span class='linkinfo' style='color:#339EFF' onclick='showResponseJson(" + row.TrnsLogDr + "," + row.Infno + ")'>详情</span>";
}
function showInputJson(RowID, Infno) {
	$("#info").html("");
	var ret = $m({
		ClassName: "INSU.MI.BL.TrnsLogCtl",
		MethodName: "GetTrnsParaById",
		RId: RowID,
		KeyCode: "INPUT"
	}, false);
	try {
		ret = JSON.stringify(JSON.parse(ret), null, 4);
	} catch (ex) { }
	//$("#info").html("<input id='input'>"+"<pre id='copyInfo'>"+ret+"</pre>"+"</input>");
	$("#info").html("<pre id='copyInfo'>" + ret + "</pre>");	 //upt 20220930 HanZH
	$('#InfoWin').dialog({ position: 'center' });               //upt 20220930 JInS1010 
	$('#InfoWin').dialog("setTitle", Infno + "-交易入参");       //upt 20220930 JInS1010
	$('#InfoWin').dialog("open");

}
function showResponseJson(RowID, Infno) {
	$("#info").html("");
	var ret = $m({
		ClassName: "INSU.MI.BL.TrnsLogCtl",
		MethodName: "GetTrnsParaById",
		RId: RowID,
		KeyCode: "OUTPUT"
	}, false);
	try {
		ret = JSON.stringify(JSON.parse(ret), null, 4);
	} catch (ex) { }
	//$("#info").html("<input id='input'>"+"<pre id='copyInfo'>"+ret+"</pre>"+"</input>");
	$("#info").html("<pre id='copyInfo'>" + ret + "</pre>");	 //upt 20220930 HanZH
	$('#InfoWin').dialog({ position: 'center' });               //upt 20220930 JInS1010       
	$('#InfoWin').dialog("setTitle", Infno + "-交易出参");       //upt 20220930 JInS1010
	$('#InfoWin').dialog("open");

}

function setRevsStasStyle(value, row, index) {
	if (value == "已冲正") return "color:red;";
	if (value == "未冲正") return "color:green;";
}
function setIsRevsStyle(value, row, index) {
	if (value == "否") return "color:red;";
	if (value == "是") return "color:green;";
}
function Clean() {

	setValueById('PsnNo', ''); NotClearRegFlag = arguments[0]; //DingSH 2021-09-17
	setValueById('RevsStas', '');
	setValueById('Infno', '');
	setValueById('SenderTrnsSn', '');
	setValueById('UserCode', GV.UserCode); //
	if (!NotClearRegFlag) { setValueById('RegNo', ''); }
	setValueById('AdmLst', '');
	setValueById('AdmDr', '');
	setValueById('PrtDr', '');
	setValueById('BillDr', '');
	setValueById('PapmiDr', ''); //DingSH 2021-09-17
	//setValueById('StartDate',getDefStDate(0));
	//setValueById('EndDate',getDefStDate(0));
	ClearGrid('dg');
	setValueById('StartDate', "");	//点清屏日期也清 WangXQ 20221024
	setValueById('EndDate', "");
}
function RevsTrns() {
	var selectedRow = $('#dg').datagrid('getSelected');
	if (!selectedRow) {
		$.messager.alert('提示', '请选择一条记录！');
		return;
	}

	var RevsStas = selectedRow.RevsStas;
	if (RevsStas == "已冲正") {
		$.messager.alert('提示', '已冲正记录，不允许冲正！');
		return;
	}
	var IsRevs = selectedRow.IsRevs;
	if (IsRevs == "否") {
		$.messager.alert('提示', '不可冲正记录，不允许冲正！');
		return;
	}
	//var PsnNo=getValueById('PsnNo');
	var PsnNo = selectedRow.tPsnNo;	//从选中行获取	WangXQ 20221024
	var oinfno = selectedRow.Infno;
	//var omsgid=getValueById('SenderTrnsSn');
	var omsgid = selectedRow.tSenderTrnsSn;	//从选中行获取	WangXQ 20221024
	//var ExpStr=getValueById('HiType')+"^"+selectedRow.Rowid;
	var ExpStr = selectedRow.HiType + "^" + selectedRow.Rowid;	//从选中行获取	WangXQ 20221024
	var rtn = InsuReverse(0, GV.UserId, PsnNo, oinfno, omsgid, ExpStr); //DHCInsuPort.js
	if (rtn == "0") {
		$.messager.alert('提示', '冲正成功', 'info');
		LoadTrnsList();
		return;
	} else {
		$.messager.alert('提示', '冲正失败', 'error');
		return;
	}
}
/*
 * 医保类型combogrid
 */
function InitInsuTypeCmb() {
	var options = {
		hospDr: GV.HospId,
		defaultFlag: "N"
	}
	INSULoadDicData("HiType", "DLLType", options); // dhcinsu/common/dhcinsu.common.js
	$HUI.combobox("#HiType", {
		onSelect: function (rec) {
			GV.HiType = rec.cCode;
		},
		onLoadSuccess: function () {
			$('#HiType').combobox('select', "00A");
		}
	});
}
//设置按钮是否可用
function SetBtnIsDisabled(RevsStasDesc, IsRevsDesc) {
	if (IsRevsDesc == "否") { disableById("btnTrns"); return;/*冲正*/ }

	switch (RevsStasDesc) {
		case "未冲正":
			enableById("btnTrns");    /*冲正*/
			break;
		case "已冲正":
			disableById("btnTrns");   /*冲正*/
			break;
		default:
			enableById("btnTrns");    /*冲正*/
			break;
	}
}
