/*
 *模块:门诊药房
 *子模块:门诊药房-配药
 *createdate:2016-08-22
 *creator:dinghongying
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
var PrintType="";
$(function () {
	CheckPermission();
	var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* 初始化插件 start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);

	InitGridWin();
	InitPYWin();
	InitGridPY();
	InitGirdPYDetail();
	InitConfig();
	/* 表单元素事件 start*/
	//登记号回车事件
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);			
				$(this).val(newpatno);
				if(newpatno==""){return;}
				QueryGridPY();
			}
		}
	});
	//卡号回车事件
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
			}
		}
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	/* 表单元素事件 end*/


	/* 绑定按钮事件 start*/
	$("#btn-find").on("click", QueryGridPY);
	$("#btn-autoprint").on("click", function () {
		$("#modal-dhcpha-autoprint").modal('show');
	});
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-disp").on("click", ExecutePY);
	$('#btn-reprint').bind("click", RePrintHandler);
	$("#btn-win-sure").on("click", PYWindowConfirm);
	$("#btn-readcard").on("click", BtnReadCardHandler); //读卡
	/* 绑定按钮事件 end*/
	;

	/*modal show start*/
	$('#modal-dhcpha-autoprint').on('show.bs.modal', function () {
		DHCPHA_CONSTANT.VAR.TIMER = setInterval("AutoPrintPresc();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	})
	$('#modal-dhcpha-autoprint').on('hide.bs.modal', function () {
		clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	})
	$("#modal-windowinfo").on('shown.bs.modal', function () {
		$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			onText: "有人",
			offText: "无人",
			onColor: "success",
			offColor: "default",
			size: "small",
			onSwitchChange: function (event, state) {
				var ret = ChangeWinStat(state);
				if (ret == false) {
					$(this).bootstrapSwitch('state', !state, true);
				}
			}
		})
		$("#grid-window").setGridWidth($("#modal-windowinfo .div_content").width())
		$("#grid-window").HideJqGridScroll({
			hideType: "X"
		})
	})
	/*modal show end*/
	HotKeyInit("PY","grid-py");
})
//初始化配药table
function InitGridPY() {
	var columns = [{
			header: '配药状态',
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 75,
			cellattr: addPhDispStatCellAttr
		},
		{
			header: '收费日期',
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 100,
			align: 'left'
		},
		{
			header: '登记号',
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 90,
			align: 'left'
		},
		{
			header: '处方号',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 125,
			align: 'left'
		},
		{
			header: '姓名',
			index: 'TPatName',
			name: 'TPatName',
			width: 80,
			align: 'left'
		},
		{
			header: '性别',
			index: 'TPerSex',
			name: 'TPerSex',
			width: 50,
			align: 'left'
		},
		{
			header: '年龄',
			index: 'TPerAge',
			name: 'TPerAge',
			width: 60,
			align: 'left'
		},
		{
			header: '处方金额',
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 100,
			align: 'right'
		},
		{
			header: '费别',
			index: 'TPrescType',
			name: 'TPrescType',
			width: 60,
			align: 'left'
		},
		{
			header: '处方类型',
			index: 'TPrescTitle',
			name: 'TPrescTitle',
			width: 60
		},
		{
			header: '发药窗口',
			index: 'TWinDesc',
			name: 'TWinDesc',
			width: 90,
			align: 'left'
		},
		{
			header: '科室',
			index: 'TPerLoc',
			name: 'TPerLoc',
			width: 110,
			align: 'left'
		},
		{
			header: '取号',
			index: 'TNoteFlag',
			name: 'TNoteFlag',
			width: 60,
			align: 'left',
			hidden: true
		},
		{
			header: '发药机',
			index: 'TDispMachine',
			name: 'TDispMachine',
			width: 60,
			editable: true,
			edittype: 'checkbox',
			align: 'left',
			hidden: true
		},
		{
			header: '剂数',
			index: 'TJS',
			name: 'TJS',
			width: 60,
			align: 'left'
		},
		{
			header: '煎药类型',
			index: 'TJYType',
			name: 'TJYType',
			width: 80,
			align: 'left'
		},
		{
			header: '电话',
			index: 'TCallCode',
			name: 'TCallCode',
			width: 100,
			align: 'left'
		},
		{
			header: '诊断',
			index: 'TMR',
			name: 'TMR',
			width: 300,
			align: 'left'
		},
		{
			header: '发药标志',
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		},
		{
			header: '打印',
			index: 'TPrintFlag',
			name: 'TPrintFlag',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatAdd',
			index: 'TPatAdd',
			name: 'TPatAdd',
			width: 40,
			hidden: true
		},
		{
			header: 'TPatID',
			index: 'TPatID',
			name: 'TPatID',
			width: 40,
			hidden: true
		},
		{
			header: 'Tphdrowid',
			index: 'Tphdrowid',
			name: 'Tphdrowid',
			width: 40,
			hidden: true
		},
		{
			header: 'TPhawId',
			index: 'TPhawId',
			name: 'TPhawId',
			width: 40,
			hidden: true
		},
		{
			header: '病人密级',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 40,
			hidden: true
		},
		{
			header: '病人级别',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 40,
			hidden: true
		}

	];
	var jqOptions = {
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryPYList&style=jqGrid', //查询后台	
		height: DhcphaJqGridHeight(2, 1) + 7,
		multiselect: false,
		datatype: 'local',
		shrinkToFit: true,
		pager: "#jqGridPager", //分页控件的id  
		onSelectRow: function (id, status) {
			QueryGridPYSub()
		},
		loadComplete: function () {
			$("#grid-pydetail").clearJqGrid();
		}
	};
	$("#grid-py").dhcphaJqGrid(jqOptions);
}

//初始化配药明细table
function InitGirdPYDetail() {
	var columns = [{
			header: '药品名称',
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 200,
			align: 'left'
		},
		{
			header: '数量',
			index: 'TPhQty',
			name: 'TPhQty',
			width: 60,
			align: 'right'
		},
		{
			header: '单位',
			index: 'TPhUom',
			name: 'TPhUom',
			width: 80,
			align: 'left'
		},
		{
			header: '用法',
			index: 'TYF',
			name: 'TYF',
			width: 80,
			align: 'left'
		},
		{
			header: '剂量',
			index: 'TJL',
			name: 'TJL',
			width: 60,
			align: 'left'
		},
		{
			header: '频次',
			index: 'TPC',
			name: 'TPC',
			width: 60,
			align: 'left'
		},
		{
			header: '疗程',
			index: 'TLC',
			name: 'TLC',
			width: 80,
			align: 'left'
		},
		{
			header: '单价',
			index: 'TPrice',
			name: 'TPrice',
			width: 80,
			align: 'right',
			align: 'left'
		},
		{
			header: '金额',
			index: 'TMoney',
			name: 'TMoney',
			width: 80,
			align: 'right',
			align: 'left'
		},
		{
			header: '状态',
			index: 'TOrdStatus',
			name: 'TOrdStatus',
			width: 80,
			align: 'left'
		},
		{
			header: '发票号',
			index: 'TPrtNo',
			name: 'TPrtNo',
			width: 100
		},
		{
			header: '厂商',
			index: 'TPhFact',
			name: 'TPhFact',
			width: 200,
			align: 'left'
		},
		{
			header: '备注',
			index: 'TPhbz',
			name: 'TPhbz',
			width: 70,
			align: 'left'
		},
		{
			header: '发药机',
			index: 'TDispMachine',
			name: 'TDispMachine',
			width: 60,
			align: 'left'
		},
		{
			header: '货位',
			index: 'TIncHW',
			name: 'TIncHW',
			width: 100,
			align: 'left'
		},
		{
			header: 'TOrditm',
			index: 'TOrditm',
			name: 'TOrditm',
			width: 60,
			hidden: true
		},
		{
			header: 'TUnit',
			index: 'TUnit',
			name: 'TUnit',
			width: 70,
			hidden: true
		},
		{
			header: '批次',
			index: 'TIncPC',
			name: 'TIncPC',
			width: 150,
			hidden: true
		},
		{
			header: '规格',
			index: 'TPhgg',
			name: 'TPhgg',
			width: 150,
			hidden: true
		},
		{
			header: '皮试',
			index: 'TSkinTest',
			name: 'TSkinTest',
			width: 70
		},
		{
			header: '产地',
			index: 'TPhFact',
			name: 'TPhFact',
			width: 150,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		rowNum: 200,
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispListDetail&style=jqGrid',
		height: DhcphaJqGridHeight(1, 1) - 10
	};
	$("#grid-pydetail").dhcphaJqGrid(jqOptions);
}
//查询配药列表
function QueryGridPY() {

	var stdate = $("#date-start").val();
    var enddate = $("#date-end").val();
	var chkpy = "0";
	if ($("#chk-py").is(':checked')) {
		chkpy = "1";
	}
	var patno = $("#txt-patno").val();
	if((patno=="")&&(chkpy!=1)){
		dhcphaMsgBox.alert("请输入登记号或卡号后,再次查询!");
		return;
	}
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //$('#sel-window option:selected').val(); //这是配药窗口的ID
	var CPatName = "";
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + chkpy;
	$("#grid-py").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
}
//查询配药明细
function QueryGridPYSub() {
	var selectid = $("#grid-py").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-py").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var rPhdrow = "";
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + prescno + "^" + rPhdrow;
	$("#grid-pydetail").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
}
// 执行配药
function ExecutePY() {
	if (DhcphaGridIsEmpty("#grid-py") == true) {
		return;
	}
	var selectid = $("#grid-py").jqGrid('getGridParam', 'selrow');
	if ((selectid == "") || (selectid == null)) {
		dhcphaMsgBox.alert("没有选中数据,不能配药!");
		return;
	}
	var selrowdata = $("#grid-py").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var printflag = selrowdata.TPrintFlag;
	if (printflag == "1") {
		dhcphaMsgBox.alert("您选中的记录已经配药!");
		return;
	}
	var adtresult = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	if (adtresult == "") {
		dhcphaMsgBox.alert("请先审核!")
		return;
	} else if (adtresult == "N") {
		dhcphaMsgBox.alert("审核不通过,不允许配药!")
		return;
	}
	var pharwid = selrowdata.TPhawId;
	var RetInfo = tkMakeServerCall("PHA.OP.PyAdv.OperTab", "SavePhdData", DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHUSER, prescno, pharwid);
	var retarr = RetInfo.split("^");
	var dispret = retarr[0];
	var retmessage = retarr[1];
	if (dispret > 0) {
		var bgcolor = $(".dhcpha-record-pyed").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-py").setCell(selectid, 'TPrintFlag', 1);
		$("#grid-py").setCell(selectid, 'Tphdrowid', dispret);
		$("#grid-py").setCell(selectid, 'TPhDispStat', "已配药", cssprop);
		AfterExecPrint(prescno,PrintType,dispret,"");
		//AfterPyPrint(dispret, prescno, "");
	} else {
		dhcphaMsgBox.alert(retmessage, "error")
		return;
	}
}

//自动打印配药单
function AutoPrintPresc() {
	var autopy = tkMakeServerCall("web.DHCOutPhCode", "GetPhlAutoPyFlag", DHCPHA_CONSTANT.DEFAULT.PHLOC);
	if (autopy != 1) return;
	var startDate = $("#date-start").val();
    var endDate = $("#date-end").val();
	var getautodispinfo = tkMakeServerCall("PHA.OP.PyAdv.Query", "GetAutoDispInfo", startDate, endDate, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
	var retarr = getautodispinfo.split("^")
	var retnum = retarr[0]
	var retpid = retarr[1]
	if (retnum == 0) {
		return;
	}
	var insertphdispauto = tkMakeServerCall("PHA.OP.PyAdv.OperTab", "SaveAutoDispInfo", retpid, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHUSER);
	if (insertphdispauto == "") {
		return;
	}
	var phdIdArr = insertphdispauto.split("^");
	for (var phdI = 0; phdI < phdIdArr.length; phdI++) {
		var iPhdIdStr = phdIdArr[phdI] || "";
		if (iPhdIdStr == "") {
			continue;
		}
		var iPhdId = iPhdIdStr.split("$")[0];
		var iPrescNo = iPhdIdStr.split("$")[1];
		AfterExecPrint(iPrescNo,PrintType,iPhdId,"")
		//AfterPyPrint(iPhdId, iPrescNo, "");
	}
}

//重新打印
function RePrintHandler() {
	if (DhcphaGridIsEmpty("#grid-py") == true) {
		return;
	}
	var selectid = $("#grid-py").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-py").jqGrid('getRowData', selectid);
	if (selectid == "") {
		dhcphaMsgBox.alert("没有选中数据,无法打印!");
		return;
	}
	var phdrowid = selrowdata.Tphdrowid;
	var prescno = selrowdata.TPrescNo;
	AfterExecPrint(prescno,PrintType,phdrowid,"补")
	//AfterPyPrint(phdrowid, prescno, "补");
}

//配药后的打印（走参数配置）
function AfterPyPrint(phdrowid, prescno, ReprintFlag) {
	var outparamstr = tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
	var printtype = outparamstr.split("^")[1];
	if (printtype == "2") {
		OUTPHA_PRINTCOM.Presc(prescno, "正方", "");
	} else {
		OUTPHA_PRINTCOM.PYD(phdrowid, ReprintFlag);
	}
}

//清空
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-py').iCheck('uncheck');
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#grid-py").clearJqGrid();
	$("#grid-pydetail").clearJqGrid();
}

//初始化配药窗口table
function InitGridWin() {
	var columns = [{
			header: '配药窗口',
			index: 'pyWindesc',
			name: 'pyWindesc'
		},{
			header: '发药窗口',
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		},
		{
			header: '发药窗口状态',
			index: 'phwWinStat',
			name: 'phwWinStat',
			
			formatter: statusFormatter,
			title: false
		},
		{
			header: 'phwid',
			index: 'phwid',
			name: 'phwpid',
			width: 20,
			hidden: true
		},
		{
			header: 'phwpid',
			index: 'phwpid',
			name: 'phwpid',
			width: 20,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&ChkRelFlag=1',
		height: '100%',
		autowidth: true,
		loadComplete: function () {}
	};
	$("#grid-window").dhcphaJqGrid(jqOptions);
}
//自定义状态列格式
function statusFormatter(cellvalue, options, rowdata) {
	if (cellvalue == "有人") {
		return '<input name="dhcphaswitch" type="checkbox" checked> '
	} else {
		return '<input name="dhcphaswitch" type="checkbox" unchecked> '
	}
}

function ChangeWinStat(state) {
	var wintd = $(event.target).closest("td");
	var rowid = $(wintd).closest("tr.jqgrow").attr("id");
	var selrowdata = $("#grid-window").jqGrid('getRowData', rowid);
	var phwpid = selrowdata.phwpid;
	var phwWinStat = state;
	var winstat = "";
	if (phwWinStat == true) {
		phwWinStat = "1";
	} else {
		phwWinStat = "0";
	}
	var modifyret = tkMakeServerCall("web.DHCOutPhDisp", "UpdatePhwp", phwpid, phwWinStat);
	if (modifyret == 0) {
		return true;
	} else if (modifyret == -11) {
		dhcphaMsgBox.alert("请确保至少一个窗口为有人状态!");
		return false;
	} else {
		dhcphaMsgBox.alert("修改窗口状态失败,错误代码:" + modifyret, "error");
		return false;
	}
}
//配药窗口确认
function PYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var pywindata = $("#sel-window").select2("data")[0];
	if (pywindata == undefined) {
		dhcphaMsgBox.alert("配药窗口不能为空!");
		return false;
	}
	var timestep = $("#timestep").val().trim();
	if (timestep == "") {
		dhcphaMsgBox.alert("时间间隔不能为空!");
		return false;
	}
	var pywin = pywindata.id;
	var pywindesc = pywindata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(pywindesc);
	$("#btn-change").text(pywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = pywin;
	if ($.trim(timestep) != "") {
		DHCPHA_CONSTANT.VAR.TIMERSTEP = $("#timestep").val();
	}
	var phcookieinfo = pywin + "^" + pywindesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^py");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^py", phcookieinfo);
	ClearConditions();
	return false;
}

//权限验证
function CheckPermission() {
	$.ajax({
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
			'&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
			'&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
			'&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type: 'post',
		success: function (data) {
			var retjson = eval("(" + data + ")");
			var retdata = retjson[0];
			var permissionmsg = "",
				permissioninfo = "";
			if (retdata.phloc == "") {
				permissionmsg = "药房科室:" + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = "尚未在门诊药房科室维护中维护!"
			} else {
				permissionmsg = "工号:" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "　　姓名:" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser == "") {
					permissioninfo = "尚未在门诊药房人员代码维护!"
				} else if (retdata.phnouse == "Y") {
					permissioninfo = "门诊药房人员代码维护中已设置为无效!"
				} else if (retdata.phpy != "Y") {
					permissioninfo = "门诊药房人员代码维护中未设置配药权限!"
				}
			}
			if (permissioninfo != "") {
				$('#modal-dhcpha-permission').modal({
					backdrop: 'static',
					keyboard: false
				}); //点灰色区域不关闭
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)

				})
				$("#modal-dhcpha-permission").modal('show');
			} else {
				DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^py");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					$("#btn-change").text(getphcookie.split("^")[1])
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
				} else {
					$("#modal-windowinfo").modal('show');
				}
				$('#modal-windowinfo').on('show.bs.modal', function () {
					$("#sel-window ").empty();
				})
			}
		},
		error: function () {}
	})
}
//初始化配药窗口
function InitPYWin() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetPYWinList&style=select2&gLocId=" +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&chkFyWFlag=1",
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}

function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == "已配药") {
		return "class=dhcpha-record-pyed";
	} else if (val == "已打印") {
		return "class=dhcpha-record-printed";
	} else if (val == "已发药") {
		return "class=dhcpha-record-disped";
	} else {
		return "";
	}
}
//读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "sel-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
//读卡返回操作
function ReadCardReturn() {
	QueryGridPY();
}
function InitConfig(){
	var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if(CongigStr!=""){
		var arr=CongigStr.split("^");
		if(arr.length>=2){
			PrintType=arr[1]
		}
	}
}