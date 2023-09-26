/*
 *模块:门诊药房
 *子模块:门诊药房-处方预览发药
 *createdate:2016-10-29
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 1000;
DHCPHA_CONSTANT.VAR.BODYTYPE = "";
DHCPHA_CONSTANT.VAR.OUTPHAWAY = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", "OA");
var PrintType="";
$(function () {
	if (typeof (PrescDispType) != "undefined") {
		DHCPHA_CONSTANT.VAR.BODYTYPE = PrescDispType.toUpperCase();
	}
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
	InitFYWin();
	InitGridFY();
	InitGirdWAITFY();
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
				QueryGridFY();
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
	$("#a-refresh").on("click", QueryGridWaitFY)
	$("#btn-find").on("click", QueryGridFY);
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-fy").on("click", ExecuteFY);
	$("#btn-reffy").on("click", ExecuteRefuseFY);
	$("#btn-cancelreffy").on("click", CancelRefuseFY);
	$("#btn-allfy").on("click", ExecuteAllFY);
	$('#btn-printlabel').on("click", RePrintLabelHandler);
	$('#btn-print').on("click", PrintHandler);
	$("#btn-win-sure").on("click", FYWindowConfirm);
	$("#btn-redir-return").on("click", function () {
		var lnk = "dhcpha/dhcpha.outpha.return.csp";
		websys_createWindow(lnk, "退药", "width=95%,height=75%")
		//window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$("#btn-readcard").on("click", BtnReadCardHandler); //读卡
	/* 绑定按钮事件 end*/
	;
	InitBodyStyle();
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridWaitFY();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
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
	HotKeyInit("PrescFY","grid-fy");
})

//初始化发药table
function InitGridFY() {
	var tmpheight = 0;
	if (DHCPHA_CONSTANT.VAR.BODYTYPE == "ONE") {
		tmpheight = DhcphaJqGridHeight(1, 1);
	} else {
		tmpheight = DhcphaJqGridHeight(2, 3) * 0.5;
	}
	var columns = [{
			header: '发药状态',
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 65,
			cellattr: addPhDispStatCellAttr
		},
		{
			header: '姓名',
			index: 'TPatName',
			name: 'TPatName',
			width: 100
		},
		{
			header: '登记号',
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 100
		},
		{
			header: '收费日期',
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 100
		},
		{
			header: '收据号',
			index: 'TPrtInv',
			name: 'TPrtInv',
			width: 100,
			hidden: true
		},
		{
			header: '处方号',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 110
		},
		{
			header: '处方金额',
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 70,
			align: 'right'
		},
		{
			header: '性别',
			index: 'TPerSex',
			name: 'TPerSex',
			width: 40
		},
		{
			header: '年龄',
			index: 'TPerAge',
			name: 'TPerAge',
			width: 40
		},
		{
			header: '审核状态',
			index: 'TDocSS',
			name: 'TDocSS',
			width: 70
		},
		{
			header: '合理用药',
			index: 'TPassCheck',
			name: 'TPassCheck',
			width: 70,
			hidden: true
		},
		{
			header: '病人密级',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 100,
			hidden: true
		},
		{
			header: '病人级别',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 100,
			hidden: true
		},
		{
			header: '诊断',
			index: 'TMR',
			name: 'TMR',
			width: 200,
			align: 'left'
		},
		{
			header: 'TPrt',
			index: 'TPrt',
			name: 'TPrt',
			width: 60,
			hidden: true
		},
		{
			header: 'phdrow',
			index: 'phdrow',
			name: 'phdrow',
			width: 60,
			hidden: true
		},
		{
			header: '序号',
			index: 'TNoteCode',
			name: 'TNoteCode',
			width: 50,
			hidden: true
		},
		{
			header: '药框号',
			index: 'TBoxNum',
			name: 'TBoxNum',
			width: 60,
			hidden: true
		},
		{
			header: '发药',
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=jsQueryFYList&style=jqGrid', //查询后台	
		height: tmpheight,
		multiselect: false,
		pager: "#jqGridPager", //分页控件的id  
		shrinkToFit: false,
		onSelectRow: function (id, status) {
			QueryGridFYSub()
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				$("#ifrm-presc").attr("src", "");
			} else {
				$(this).jqGrid('setSelection', 1);
			}
			var chkfy=""
			if ($("#chk-fy").is(':checked')) {
				chkfy = "1";
			}	
			if(chkfy!=1){
					var fyrowdata = $("#grid-fy").jqGrid('getRowData');
					var fygridrows = fyrowdata.length;
					if (fygridrows <= 0) {
						return;
					}
					for (var rowi = 1; rowi <= fygridrows; rowi++) {
						var selrowdata=$("#grid-fy").jqGrid('getRowData', rowi)
						var prescno = selrowdata.TPrescNo;
						SendOPInfoToMachine("202",prescno)

					}

			}
		}
	};
	$("#grid-fy").dhcphaJqGrid(jqOptions);
}


//叫号消息发送
function SendMessToVoice(rowIndex) {

	if ((rowIndex == null) || (rowIndex == "")) {
		dhcphaMsgBox.alert("没有选中数据,不能叫号!");
		return;
	}

	var selrowdata = $("#grid-waitfy").jqGrid('getRowData', rowIndex);
	var patno = selrowdata.tbpatid;
	var patname = selrowdata.tbname;
	var window = DHCPHA_CONSTANT.DEFAULT.PHWINDOW;
	var serverip = ClientIPAddress;
	var FYUserID = DHCPHA_CONSTANT.DEFAULT.PHUSER;
	var SendVoiceRet = tkMakeServerCall("web.DHCSTInterfacePH", "SendMessToVoice", patno, patname, serverip, window, FYUserID)

}

//初始化待发药table
function InitGirdWAITFY() {
	var tmpheight = 0;
	if (DHCPHA_CONSTANT.VAR.BODYTYPE == "ONE") {
		tmpheight = DhcphaJqGridHeight(1, 1);
	} else {
		tmpheight = DhcphaJqGridHeight(2, 3) * 0.5;
	}
	var columns = [{
			header: '叫号',
			index: 'tSendVoice',
			name: 'tSendVoice',
			width: 50,
			formatter: function (cellvalue, options, rowObject) {
				return "<a href='#' onclick='SendMessToVoice(\"" + options.rowId + "\")'><i class='fa fa-bullhorn'></i></a>";
			}
		},
		{
			header: '姓名',
			index: 'tbname',
			name: 'tbname',
			width: 100
		},
		{
			header: '登记号',
			index: 'tbpatid',
			name: 'tbpatid',
			width: 100
		},
		{
			header: '病人密级',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 200,
			hidden: true
		},
		{
			header: '病人级别',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 200,
			hidden: true
		},
		{
			header: 'TWarnLevel',
			index: 'TWarnLevel',
			name: 'TWarnLevel',
			width: 100,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryNeedFYList&style=jqGrid',
		height: tmpheight,
		recordtext: "",
		pgtext: "",
		shrinkToFit: true,
		onSelectRow: function (id, status) {
			var selrowdata = $(this).jqGrid('getRowData', id);
			var patno = selrowdata.tbpatid;
			$("#txt-patno").val(patno);
			QueryGridFY();
		},
		gridComplete: function () {
			var ids = $("#grid-waitfy").jqGrid("getDataIDs");
			var rowDatas = $("#grid-waitfy").jqGrid("getRowData");
			for (var i = 0; i < rowDatas.length; i++) {
				var rowData = rowDatas[i];
				var warnLevel = rowData.TWarnLevel;
				if ((warnLevel.indexOf("毒") >= 0) || (warnLevel.indexOf("麻") >= 0)) {
					$("#grid-waitfy" + " #" + ids[i] + " td").css({
						color: '#FF6356',
						'font-weight': 'bold'
					});
				}
			}
			return true;
		}
	};
	$("#grid-waitfy").dhcphaJqGrid(jqOptions);
}
//查询待发药table
function QueryGridWaitFY() {
	var stdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + DHCPHA_CONSTANT.DEFAULT.PHWINDOW + "^^" + stdate + "^" + enddate;;
	$("#grid-waitfy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	if ((DHCPHA_CONSTANT.DEFAULT.PHLOC != "") && (DHCPHA_CONSTANT.DEFAULT.PHWINDOW != "")) {
		clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	}
}
//查询发药列表
function QueryGridFY() {
	ChkUnFyOtherLoc();
	var stdate=$("#date-start").val();
	var enddate=$("#date-end").val();
	var chkfy = "";
	if ($("#chk-fy").is(':checked')) {
		chkfy = "1";
	}
	var patno = $("#txt-patno").val();
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //这是配药窗口的ID
	var CPatName = "";
	var CPrescNo = "";
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + CPrescNo + "^" + chkfy;
	$("#grid-fy").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	$("#ifrm-presc").attr("src", "");
}
//查询发药明细
function QueryGridFYSub() {
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var cyflag = DHCPHA_CONSTANT.DEFAULT.CYFLAG;
	var phartype = "DHCOUTPHA";
	var paramsstr = phartype + "^" + prescno + "^" + cyflag;
	$("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}
// 执行发药
function ExecuteFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("没有选中数据,不能发药!");
		return;
	}
	DispensingMonitor(selectid);
	var nextSelectid=parseInt(selectid)+1
	var rowDatas = $("#grid-fy").jqGrid("getRowData");
	if(nextSelectid<=rowDatas.length)
	{
    	$("#grid-fy").setSelection(nextSelectid);
    }
	QueryGridWaitFY();
}


//执行全发
function ExecuteAllFY() {
	var fyrowdata = $("#grid-fy").jqGrid('getRowData');
	var fygridrows = fyrowdata.length;
	if (fygridrows <= 0) {
		dhcphaMsgBox.alert("没有数据!");
		return;
	}
	for (var rowi = 1; rowi <= fygridrows; rowi++) {
		DispensingMonitor(rowi);
	}
	QueryGridWaitFY();

}

function DispensingMonitor(rowid) {
	var selrowdata = $("#grid-fy").jqGrid('getRowData', rowid);
	var prescno = selrowdata.TPrescNo;
	var phdrowid = selrowdata.phdrow;
	var adtresult = GetOrdAuditResultByPresc(prescno);
	if (adtresult == "") {
		dhcphaMsgBox.alert("请先审核!")
		return;
	} else if (adtresult == "N") {
		dhcphaMsgBox.alert("该处方审核不通过,禁止发药!")
		return;
	} else if (adtresult == "S") {
		if (!confirm("该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")) {
			return;
		}
	}
	var checkprescref = GetOrdRefResultByPresc(prescno)
	if (checkprescref == "N") {
		dhcphaMsgBox.alert("该处方已被拒绝,禁止发药!");
		return;
	}
	if (checkprescref == "A") {
		dhcphaMsgBox.alert("该处方已被拒绝,禁止发药!");
		return;
	}
	if (checkprescref == "S") {
		dhcphaMsgBox.confirm("该处方医生已提交申诉<br/>点击[确认]将同意申诉继续发药，点击[取消]将放弃发药操作。", function (r) {
			if (r == true) {
				var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR"); //申诉后发药应先撤消拒绝
				ExecuteDisp(phdrowid, prescno, rowid);
			} else {
				return;
			}
		});
	} else {
		ExecuteDisp(phdrowid, prescno, rowid);
	}
}

function ExecuteDisp(phdrowid, prescno, rowid) {
	var RetInfo = tkMakeServerCall("PHA.OP.PyDisp.OperTab", "SaveDispData", phdrowid, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHUSER, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
	var retarr = RetInfo.split("^");
	var dispret = retarr[0];
	var retmessage = retarr[1];
	if (dispret > 0) {
		var bgcolor = $(".dhcpha-record-disped").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-fy").setCell(rowid, 'TFyFlag', 'OK');
		$("#grid-fy").setCell(rowid, 'TPhDispStat', '已发药', cssprop);
		AfterExecPrint(prescno,PrintType,phdrowid,"");
		SendOPInfoToMachine("203",prescno);
	} else {
		dhcphaMsgBox.alert(retmessage, "error")
		return;
	}
}

// 执行拒绝发药
function ExecuteRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("没有选中数据,不能拒绝发药!");
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert("处方已发药，不能拒绝!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	if (prescno == "") {
		dhcphaMsgBox.alert("请选择要拒绝的处方");
		return;
	}
	var ref = GetOrdRefResultByPresc(prescno);
	if (ref == "N") {
		dhcphaMsgBox.alert("该处方已被拒绝,不能重复操作!")
		return;
	} else if (ref == "A") {
		dhcphaMsgBox.alert("该处方已被拒绝,不能重复操作!")
		return;
	}
	var checkprescadt = GetOrdAuditResultByPresc(prescno);
	if (checkprescadt == "") {
		dhcphaMsgBox.alert("该处方未审核,禁止操作!")
		return;
	} else if (checkprescadt != "Y") {
		dhcphaMsgBox.alert("该处方审核未通过,禁止操作!")
		return;
	}
	var waycode = DHCPHA_CONSTANT.VAR.OUTPHAWAY;
	ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:prescno,
		selType:"PRESCNO"
	},SaveCommontResultEX,{prescno:prescno});
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var input = ret + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "^" + origOpts.prescno + "^OR" //orditm;	
    
    if (reasondr.indexOf("$$$") == "-1") {
		reasondr = reasondr + "$$$" + prescno;
	}
    var refuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "SaveOPAuditResult", reasondr, input);
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');

	if (refuseret == 0) {
		$("#grid-fy").setCell(selectid, 'TDocSS', '拒绝发药');
	} else {
		dhcphaMsgBox.alert("拒绝失败!错误代码:" + refuseret)
		return;
	}

}
// 撤消拒绝发药
function CancelRefuseFY() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("没有选中数据,不能撤消拒绝发药!");
		return;
	}
	var fyflag = selrowdata.TFyFlag;
	var prescno = selrowdata.TPrescNo;
	if (fyflag == "OK") {
		dhcphaMsgBox.alert("该记录已经发药!");
		return;
	}
	if (prescno == "") {
		dhcphaMsgBox.alert("请选择要撤消拒绝的处方");
		return;
	}
	var checkprescref = GetOrdRefResultByPresc(prescno); //LiangQiang 2014-12-22  处方拒绝
	if ((checkprescref != "N") && (checkprescref != "A")) {
		if (checkprescref == "S") {
			dhcphaMsgBox.alert("该处方医生已提交申诉,不需要撤消!")
			return;
		} else {
			dhcphaMsgBox.alert("该处方未被拒绝,不能撤消操作!")
			return;
		}
	}
	var cancelrefuseret = tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CancelRefuse", DHCPHA_CONSTANT.SESSION.GUSER_ROWID, prescno, "OR");
	if (cancelrefuseret == "0") {
		var PrescResult = GetPrescResult(prescno);
		var newdata = {
			TDocSS: PrescResult
		};
		$("#grid-fy").jqGrid('setRowData', selectid, newdata);
		dhcphaMsgBox.alert("撤消成功!", "success");
	} else if (cancelrefuseret == "-2") {
		dhcphaMsgBox.alert("该处方未被拒绝,不能撤消操作!");
	} else if (retval == "-3") {
		dhcphaMsgBox.alert("该处方已撤消,不能再次撤消!");
	}
}

//获取处方拒绝结果 
function GetOrdRefResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc", prescno);
	return ref;
}
//获取拒绝发药和处方审核结果 
function GetPrescResult(prescno) {
	var ref = tkMakeServerCall("web.DHCOUTPHA.Common.CommonDisp", "GetPrescAuditFlag", prescno);
	return ref;
}
//获取处方审核结果 
function GetOrdAuditResultByPresc(prescno) {
	var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	return ref;
}
//获取其他科室未发药记录,仅读卡发药时
function ChkUnFyOtherLoc() {
	var startdate=$("#date-start").val();
	var enddate=$("#date-end").val();

	var patno = $("#txt-patno").val();
	if ((patno == "") || (patno == null)) {
		return;
	}
	var ret = tkMakeServerCall("PHA.OP.COM.Method", "ChkUnFyOtherLoc", startdate, enddate, patno, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW)
	if (ret == -1) {
		//alert("病人为空,请读卡")
	} else if (ret == -2) {
		dhcphaMsgBox.alert("没找到登记号为" + patno + "的病人");
		return;

	} else if ((ret != "") && (ret != null)) {
		dhcphaMsgBox.alert(ret);
	}
}
//打印
function PrintHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("没有选中数据,无法打印!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	//处方
	OUTPHA_PRINTCOM.Presc(prescno, "", "");
}
//重打标签
function RePrintLabelHandler() {
	if (DhcphaGridIsEmpty("#grid-fy") == true) {
		return;
	}
	var selectid = $("#grid-fy").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-fy").jqGrid('getRowData', selectid);
	if (selectid == null) {
		dhcphaMsgBox.alert("没有选中数据,无法打印!");
		return;
	}
	var prescno = selrowdata.TPrescNo;
	OUTPHA_PRINTCOM.Label(prescno, "", "");

}
//清空
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-fy').iCheck('uncheck');
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#grid-fy").clearJqGrid();
	$("#ifrm-presc").attr("src", "");
	QueryGridWaitFY();
}
//初始化配药窗口table
function InitGridWin() {
	var columns = [{
			header: '药房窗口',
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		},
		{
			header: '窗口状态',
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
//发药窗口确认
function FYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var fywindata = $("#sel-window").select2("data")[0];
	if (fywindata == undefined) {
		dhcphaMsgBox.alert("发药窗口不能为空!");
		return false;
	}
	var fywin = fywindata.id;
	var fywindesc = fywindata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(fywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = fywin;
	var phcookieinfo = fywin + "^" + fywindesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy", phcookieinfo);
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
				} else if (retdata.phfy != "Y") {
					permissioninfo = "门诊药房人员代码维护中未设置发药权限!"
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
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^fy");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
					QueryGridWaitFY();
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
//初始化发药窗口
function InitFYWin() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetFYWinList&style=select2&gLocId=" +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&ChkRelFlag=1",
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}

function InitBodyStyle() {
	var bodytype = DHCPHA_CONSTANT.VAR.BODYTYPE;
	var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
	var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5 = parseFloat($("[class='panel-heading']").height());
	if (bodytype == "ONE") {
		var dbLayoutWidth = parseInt($("#dbLayout").closest(".div_content").css("width")) - 3;
		var tableheight = OutFYCanUseHeight(1) + 40;
	} else {
		var tableheight = $(window).height() - height1 * 2 - height3 - height4 - height5 - 11;
		$("#ifrm-presc").height(tableheight)
		var dbLayoutWidth = $("[class='panel div_content']").width();
	}
	var dbLayoutCss = {
		width: dbLayoutWidth,
		height: tableheight
	};
	$("#dbLayout").css(dbLayoutCss);
	$("#divReport").css(dbLayoutCss);
	$("#grid-fy").setGridWidth("");
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
	QueryGridFY();
}
function InitConfig(){
	var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if(CongigStr!=""){
		var arr=CongigStr.split("^");
		if(arr.length>=10){
			PrintType=arr[9]
		}
	}
}
// 	门诊摆药机
function SendOPInfoToMachine(SendCode,PrescNo)
{
	var ret= tkMakeServerCall("web.DHCSTInterfacePH", "SendOPInfoToMachine", SendCode,PrescNo)	
}
