/*
模块:		草药房
子模块:		草药房-煎药工作量确认
Creator:	hulihua
CreateDate:	2017-11-29
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var recorduserid = ""; //确认人
DhcphaTempBarCode = "";

$(function () {
	/*初始化插件 start*/
	SetDefaultCode();
	InitDecCond();
	InitGridDispConfirm();
	SetInitDecCond();
	/*初始化插件 end*/
	//条码回车事件
	$('#txt-barcode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			AddBarPrescNo();
		}
	});

	//工号回车事件
	$('#txt-usercode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			SetInitDecCond();
		}
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (event) {
		if (window.event.keyCode == "13") {
			return false;
		}
	});

	$("button").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	});

	$("#sel-deccond").on('select2:select', function () {
		DhcphaTempBarCode = "";
		$('#recordprenum').text(0);
		$("#txt-barcode").val("");
		$("#grid-recordconfirm").jqGrid("clearGridData");
	});

	/* 绑定按钮事件 start*/
	$("#a-help").popover({
		animation: true,
		placement: 'bottom',
		trigger: 'hover',
		html: true,
		content: '<div style="width:300px;">*温馨提示*</br>请先扫描条码,再扫描工号哦~</div>'
	});
	/* 绑定按钮事件 end*/

	$("#grid-recordconfirm").setGridWidth("")
	document.onkeydown = OnKeyDownHandler;
})

window.onload = function () {
	setTimeout("$(window).focus()", 100);
}

///默认登录人信息
function SetDefaultCode() {
	$('#recorduser').text(gUserName);
	$('#recordprenum').text(0);
	recorduserid = gUserID;
}

///已记录查询
function RecordQuery() {
	var lnk = "dhcpha/dhcpha.inpha.hmrecordworkquery.csp";
	window.open(lnk, "_target", "width=" + (window.screen.availWidth - 10) + ",height=" + (window.screen.availHeight - 10) + ",menubar=no,status=yes,toolbar=no,resizable=yes,top='0',left='110',location=no");
}

///初始化明细table
function InitGridDispConfirm() {
	var columns = [{
			header: '处方号',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 80
		}, {
			header: '开方科室',
			index: 'TDoctorLoc',
			name: 'TDoctorLoc',
			width: 120,
			align: 'left'
		}, {
			header: '登记号',
			index: 'TPatNo',
			name: 'TPatNo',
			width: 60
		}, {
			header: '病人姓名',
			index: 'TPatName',
			name: 'TPatName',
			width: 60
		}, {
			header: '性别',
			index: 'TSex',
			name: 'TSex',
			width: 60
		}, {
			header: '年龄',
			index: 'TPatAge',
			name: 'TPatAge',
			width: 30
		}, {
			header: '付数',
			index: 'TFactor',
			name: 'TFactor',
			width: 60
		}, {
			header: '用法',
			index: 'TInstruc',
			name: 'TInstruc',
			width: 60
		}, {
			header: '煎药方式',
			index: 'TCookType',
			name: 'TCookType',
			width: 60
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=QueryDispConfirmList',
		height: DispConfirmCanUseHeight(),
		shrinkToFit: true,
		rownumbers: true,
		ondblClickRow: function () {
			DelBarPrescNo();
		}
	};
	$("#grid-recordconfirm").dhcphaJqGrid(jqOptions);
}

//增加处方列表信息！
function AddBarPrescNo() {
	DhcphaTempBarCode = "";
	var deccondesc = $.trim($('#sel-deccond option:checked').text());
	var decconid = $('#sel-deccond').val();
	if ((decconid == "") || (decconid == null)) {
		dhcphaMsgBox.alert("记录状态不能为空!");
		return false;
	}
	var barcode = $.trim($("#txt-barcode").val());
	var dispgridrows = $("#grid-recordconfirm").getGridParam('records');
	for (var i = 1; i <= dispgridrows; i++) {
		var tmpselecteddata = $("#grid-recordconfirm").jqGrid('getRowData', i);
		var tmpprescno = tmpselecteddata["TPrescNo"];
		if (barcode.indexOf(tmpprescno) != "-1") {
			dhcphaMsgBox.alert("该处方已扫描!");
			$("#txt-barcode").val("");
			return false;
		}
	}
	var ResultStr = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "GetPrescByBarCode", barcode, deccondesc);
	var ResultStrArr = ResultStr.split(tmpSplit);
	var ResultCode = ResultStrArr[0];
	if ((ResultCode < 0) || (ResultCode == "") || (ResultCode == null)) {
		if (ResultCode == "-6") {
			dhcphaMsgBox.alert("该处方由&nbsp&nbsp<b><font color=#CC1B04 size=4 >" + ResultStrArr[1] + "</font></b>&nbsp&nbsp已记录!<br/>");
		} else {
			dhcphaMsgBox.alert(ResultStrArr[1]);
		}
		$("#txt-barcode").val("");
		return false;
	}
	var ResultStrArr = ResultStr.split(tmpSplit)
		var PrescNo = ResultStrArr[0];
	var PatNo = ResultStrArr[1];
	var PatName = ResultStrArr[2];
	var Sex = ResultStrArr[3];
	var PatAge = ResultStrArr[4];
	var Instruc = ResultStrArr[5];
	var Factor = ResultStrArr[6];
	var CookType = ResultStrArr[7];
	var DoctorLoc = ResultStrArr[8];
	var datarow = {
		TPrescNo: PrescNo,
		TPatNo: PatNo,
		TPatName: PatName,
		TSex: Sex,
		TPatAge: PatAge,
		TFactor: Factor,
		TInstruc: Instruc,
		TCookType: CookType,
		TDoctorLoc: DoctorLoc
	};
	//console.log(datarow)
	var id = $("#grid-recordconfirm").find("tr").length;
	var su = $("#grid-recordconfirm").jqGrid('addRowData', id, datarow);
	if (!su) {
		dhcphaMsgBox.alert("扫描失败，请核实！");
	}
	$("#txt-barcode").val("");
	DhcphaTempBarCode = "";
	var SumFactor = $('#recordprenum').text();
	if ((SumFactor == "") || (SumFactor == null)) {
		SumFactor = 0;
	}
	SumFactor = parseInt(SumFactor) + parseInt(Factor);
	$('#recordprenum').text(SumFactor);
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-recordconfirm").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-recordconfirm").jqGrid('getRowData', id);
	var Factor = selrowdata.TFactor;
	var SumFactor = $('#recordprenum').text();
	if ((SumFactor == "") || (SumFactor == null)) {
		SumFactor = 0;
	}
	SumFactor = parseInt(SumFactor) - parseInt(Factor);
	$('#recordprenum').text(SumFactor);
	var su = $("#grid-recordconfirm").jqGrid('delRowData', id);
	if (!su) {
		dhcphaMsgBox.alert("删除失败，请重新双击删除！");
	}
	return false;
}

//验证用户信息并执行确认
function ExecuteSure() {
	DhcphaTempBarCode = "";
	if ((recorduserid == "") || (recorduserid == null)) {
		dhcphaMsgBox.alert("记录人不能为空!");
		return false;
	}
	var deccondesc = $.trim($('#sel-deccond option:checked').text());
	var decconid = $('#sel-deccond').val();
	if ((decconid == "") || (decconid == null)) {
		dhcphaMsgBox.alert("记录状态不能为空!");
		return false;
	}
	var grid_records = $("#grid-recordconfirm").getGridParam('records');
	if (grid_records == 0) {
		dhcphaMsgBox.alert("当前界面无处方数据,请先扫描处方条码！");
		$("#txt-barcode").val("");
		return false;
	}
	var firstrowdata = $("#grid-recordconfirm").jqGrid("getRowData", 1); //获取第一行数据
	var prescno = firstrowdata.TPrescNo;
	if ((prescno == "") || (prescno == undefined)) {
		dhcphaMsgBox.alert("请联系信息中心验证程序是否存在问题!");
		$("#txt-barcode").val("");
		return false;
	}
	var dispgridrows = $("#grid-recordconfirm").getGridParam('records');
	var succCnt=0;
	for (var i = 1; i <= dispgridrows; i++) {
		var tmpselecteddata = $("#grid-recordconfirm").jqGrid('getRowData', i);
		var tmpprescno = tmpselecteddata["TPrescNo"];
		var retValue = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "SaveRecordWorkLoad", tmpprescno, deccondesc, recorduserid);
		if (retValue != 0) {
			var Msg = retValue.split("^")[1];
			dhcphaMsgBox.alert("记录&nbsp&nbsp<b><font color=#CC1B04 size=5 >" + tmpprescno + "</font></b>&nbsp&nbsp失败!<br/>" + Msg);
			continue;
		} else {
			succCnt++;
			
		}
	}
	if(succCnt==0){
		dhcphaMsgBox.message("未记录!", "info");
	}if (succCnt==dispgridrows){
		dhcphaMsgBox.message("记录完成，全部成功!", "success");
	}else{
		dhcphaMsgBox.message("记录完成，部分成功!", "success");
	}
	ClearConditons();
	return false;
}

//状态暂存
function SaveStatus() {
	if ((recorduserid == "") || (recorduserid == null)) {
		dhcphaMsgBox.alert("记录人不能为空!");
		return false;
	}
	var deccondesc = $.trim($('#sel-deccond option:checked').text());
	var decconid = $('#sel-deccond').val();
	if ((decconid == "") || (decconid == null)) {
		dhcphaMsgBox.alert("记录状态不能为空!");
		return false;
	}
	var retValue = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "SaveTempStatus", decconid, deccondesc, recorduserid);
	if (retValue != 0) {
		var Msg = retValue.split("^")[1];
		dhcphaMsgBox.alert("暂存失败，" + Msg);
	} else {
		dhcphaMsgBox.alert("暂存成功!");
	}
	return false;
}

//给煎药状态下拉框赋值
function SetInitDecCond() {
	var usercode = $.trim($("#txt-usercode").val());
	if (usercode == "") {
		usercode = gUserCode;
	}
	if (usercode == "") {
		dhcphaMsgBox.alert("工号不能为空!");
		return false;
	}
	var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", usercode);
	if (defaultinfo == "") {
		dhcphaMsgBox.alert("请输入正确的工号！");
		return false;
	}
	var ss = defaultinfo.split("^");
	recorduserid = ss[0];
	$('#recorduser').text(ss[2]);
	$("#txt-usercode").val("");
	var DecCondStr = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "GetTempStatus", recorduserid);
	if ((DecCondStr != "") || (DecCondStr != null)) {
		$("#sel-deccond").empty();
		var select2option = '<option value=' + "'" + DecCondStr.split("^")[0] + "'" + 'selected>' + DecCondStr.split("^")[1] + '</option>'
			$("#sel-deccond").append(select2option);
	}
	return false;
}

function ClearConditons() {
	DhcphaTempBarCode = "";
	$('#recordprenum').text(0);
	$("#txt-barcode").val("");
	$("#txt-usercode").val("");
	SetInitDecCond();
	$("#grid-recordconfirm").jqGrid("clearGridData");
}
//本页面table可用高度
function DispConfirmCanUseHeight() {
	var height1 = parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2 = parseFloat($("[class='panel-heading']").outerHeight());
	var height3 = parseFloat($(".div_content").css("margin-top"));
	var height4 = parseFloat($(".div_content").css("margin-bottom"));
	var height5 = parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight = $(window).height() - height1 - height4 - height2 - height3 - height5 - DhcphaGridTrHeight + 40;
	return tableheight;
}

function CheckTxtFocus() {
	var txtfocus1 = $("#txt-barcode").is(":focus");
	var txtfocus2 = $("#txt-usercode").is(":focus")
		if ((txtfocus1 != true) && (txtfocus2 != true)) {
			return false;
		}
		return true;
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler() {

	if (CheckTxtFocus() != true) {
		if (event.keyCode == 13) {
			if (DhcphaTempBarCode.length > 6) {
				$("#txt-barcode").val(DhcphaTempBarCode);
				AddBarPrescNo();
			} else {
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-recordconfirm").getGridParam('records') > 0) {
					ExecuteSure();
				}
			}
			DhcphaTempBarCode = "";
		} else {
			DhcphaTempBarCode += String.fromCharCode(event.keyCode)
		}
	}
}
