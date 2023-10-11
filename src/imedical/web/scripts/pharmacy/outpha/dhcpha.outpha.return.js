/*
 *模块:门诊药房
 *子模块:门诊药房-退药
 *createdate:2016-08-18
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.INVROWID = "";
DHCPHA_CONSTANT.VAR.RETURNROWID = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";

var PHAOUT_NEEDREQ=""
$(function () {
	CheckPermission();
	/* 初始化插件 start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	var tmpstartdate = FormatDateT("t-30")
	$("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
	InitSelectPrescNo();
	InitGridRequest();
	InitGirdReturn();
	InitReturnModal();
	/* 初始化插件 end*/
	/* 表单元素事件 start*/
	//登记号回车事件
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				$("#patInfo").remove()
				if(newpatno==""){return;}
				var patoptions = {
					id: "#dhcpha-patinfo",
					gettype: "patno",
					input: newpatno
				}
				AppendPatientBasicInfo(patoptions);
				$("#sel-prescno").empty();
				var prescNo = $("#sel-prescno").val();
				if (prescNo == null) {
					QueryGridRequest();
				} else {
					QueryGridReturn();
				}
			}
		}
	});

	//卡号回车事件
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
				var patno = $.trim($("#txt-patno").val());
				$("#sel-prescno").empty();
				if(patno==""){return}
				var patoptions = {
					id: "#dhcpha-patinfo",
					gettype: "patno",
					input: patno
				}
				AppendPatientBasicInfo(patoptions);
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
	$("#btn-clear").on("click", ClearConditions)
	$("#btn-find").on("click", function () {
		var prescNo = $("#sel-prescno").val();
		var patno = $("#txt-patno").val();
		if((patno=="")||(patno=null)){
			dhcphaMsgBox.alert($g("请输入登记号或卡号后,再查询!"));
			
			return;
		}
		if (prescNo == null) {
			QueryGridRequest();
		} else {
			QueryGridReturn();
		}
	});
	$("#btn-return").on("click", function(){
		CACert("PHAOPReturn",DoReturn);
	}); 
	$("#btn-refusereturn").on("click", DoRefuseReturn);
	$("#btn-cancelrefuse").on("click", DoCancelRefuseReturn);
	$("#btn-readcard").on("click", BtnReadCardHandler); //读卡
	$("#btn-print").on("click", function () {
		if (DHCPHA_CONSTANT.VAR.RETURNROWID == "") {
			dhcphaMsgBox.alert($g("请先退药后,再打印!"));
			return;
		}
		PrintReturn(DHCPHA_CONSTANT.VAR.RETURNROWID, "")
	});

	/* 绑定按钮事件 end*/
;
	InitBodyStyle();
	ResizeReturn();
})
// 处方号下拉
function InitSelectPrescNo() {
	var selectoption = {
		width: 280,
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
		'?action=GetPrescForRet',
		placeholder: $g("请选择处方"),
		minimumResultsForSearch: Infinity,
		templateResult: function (state) {
			if (!state.id) {
				return state.text;
			}
			var stateText = state.text;
			if ((stateText.indexOf("申请") >= 0)||(stateText.indexOf("Request") >= 0)) {
				stateText = $('<span style="font-weight:bold">' + stateText + '</span>')
					// var stateTextArr=stateText.split("  ");
					// stateText=$('<span>'+stateTextArr[0]+"  "+stateTextArr[1]+"  "+'</span><span style="color:green;font-weight:bold">'+stateTextArr[2]+'</span>')
			}
			return stateText;
		}
	}
	var ajaxopts = {
		data: function (params) {
			var stdate=$("#date-start").val();
			var enddate=$("#date-end").val();
			var daterange=stdate+" - "+enddate
			var patNo = $("#txt-patno").val();
			var freeDrgFlag=""
			if ($("#chk-freeDrg").is(':checked')) {
				freeDrgFlag = "Y";
			}
			if(PHAOUT_NEEDREQ=="Y"){
				if(freeDrgFlag!="Y"){
					dhcphaMsgBox.alert($g("除免费药外，退药需要根据退药申请!"));
					$("#sel-prescno").select2("close");
					return {};
				}
			}else{freeDrgFlag = "";}
			
			var inputStr = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "^" + patNo + "^" + daterange + "^" +  freeDrgFlag ;
			return {
				combotext: params.term,
				inputStr: inputStr
			};
		}
	}
	$("#sel-prescno").dhcphaSelect(selectoption, ajaxopts)
	$('#sel-prescno').on('select2:select', function (event) {
		QueryGridReturn();
	});
}

//初始化退药申请table
function InitGridRequest() {
	var columns = [{
			index: 'reqNo',
			name: 'reqNo',
			header: ("申请单号"),
			width: 100
		}, {
			index: 'prescNo',
			name: 'prescNo',
			header: ("处方号"),
			width: 115
		}, {
			index: 'reqUser',
			name: 'reqUser',
			header: ("申请人"),
			width: 100
		}, {
			index: 'reqRowId',
			name: 'reqRowId',
			header: 'reqRowId',
			width: 100,
			hidden: true
		}, {
			index: 'reqReason',
			name: 'reqReason',
			header: 'reqReason',
			width: 100,
			hidden: true
		}, {
			index: 'prescCYFlag',
			name: 'prescCYFlag',
			header: 'prescCYFlag',
			width: 100,
			hidden: true
		}, {
			index: 'reqReasonDesc',
			name: 'reqReasonDesc',
			header: ("申请原因"),
			width: 100,
			hidden: false
		},
	];
	var jqOptions = {
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetReqListByReqNo', //查询后台
		height: DhcphaJqGridHeight(1, 1),
		datatype: 'local',
		onSelectRow: function (id, status) {
			DHCPHA_CONSTANT.VAR.RETURNROWID = "";
			var selrowdata = $(this).jqGrid('getRowData', id);
			var reqRowId = selrowdata.reqRowId;
			$("#grid-return").setGridParam({
				datatype: 'json',
				url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + "?action=GetReturnListByReq",
				postData: {
					'params': reqRowId
				}
			}).trigger("reloadGrid");
		},
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if (grid_records == 0) {
				//$("#grid-return").clearJqGrid();
			} else {
				$(this).jqGrid('setSelection', 1);
			}
		}
	};
	$('#grid-request').dhcphaJqGrid(jqOptions);
}
//初始化退药明细table
function InitGirdReturn() {
	var columns = [{
			index: 'TRefuse',
			name: 'TRefuse',
			header: ("拒退原因"),
			width: 100,
			align: 'left'
		}, {
			index: 'TPhdesc',
			name: 'TPhdesc',
			header: ("药品名称"),
			width: 225,
			align: 'left',
			cellattr: function (rowId, val, rawObject, cm, rdata) {
				var cantRetReason = rawObject.TCantRetReason || "";
				if (cantRetReason != "") {
					return "style='color:#FF5648;font-weight:bold;'";
				}

			}
		}, {
			index: 'TPhUom',
			name: 'TPhUom',
			header: ("药品单位"),
			width: 80,
			align: 'left'
		}, {
			index: 'TPrice',
			name: 'TPrice',
			header: ("药品单价"),
			width: 100,
			align: 'right'
		}, {
			index: 'TDispQty',
			name: 'TDispQty',
			header: ("发药数量"),
			width: 80,
			align: 'right'
		}, {
			index: 'TDispMoney',
			name: 'TDispMoney',
			header: ("发药金额"),
			width: 100,
			align: 'right'
		}, {
			index: 'TRetQty',
			name: 'TRetQty',
			header: ("退药数量"),
			width: 100,
			align: 'center',
			editable: true,
			cellattr: addTextCellAttr
		}, {
			index: 'TRetMoney',
			name: 'TRetMoney',
			header: ("退药金额"),
			width: 100,
			align: 'right'
		}, {
			index: 'TPhgg',
			name: 'TPhgg',
			header: ("规格"),
			width: 100,
			align: 'left'
		}, {
			index: 'TIncDispBatCode',
			name: 'TIncDispBatCode',
			header: ("发药批号"),
			width: 100,
			align: 'left'
		}, {
			index: 'TIncRetBatCode',
			name: 'TIncRetBatCode',
			header: ("退药批号"),
			width: 100,
			align: 'left',
			editable: true,
			cellattr: addTextCellAttr
		}, {
			index: 'TInvNo',
			name: 'TInvNo',
			header: ("发票号"),
			width: 100,
			align: 'left'
		}, {
			index: 'TPhdItm',
			name: 'TPhdItm',
			header: 'TPhdItm',
			width: 100,
			hidden: true
		}, {
			index: 'TPhUomid',
			name: 'TPhUomid',
			header: 'TPhUomid',
			width: 100,
			hidden: true
		}, {
			index: 'TReqItm',
			name: 'TReqItm',
			header: 'TReqItm',
			width: 100,
			hidden: true
		}, {
			index: 'TPhdLbRowId',
			name: 'TPhdLbRowId',
			header: ("发药子表ID"),
			width: 100,
			hidden: true
		}, {
			index: 'TDodisBatch',
			name: 'TDodisBatch',
			header: ("打包子表ID"),
			width: 100,
			hidden: true
		}, {
			index: 'TCantRetReason',
			name: 'TCantRetReason',
			header: ("不可退药原因"),
			width: 100
		}, {
			index: 'TCyFlag',
			name: 'TCyFlag',
			header: ("草药处方标志"),
			width: 30,
			hidden: true
		}, {
			index: 'TRefuseFlag',
			name: 'TRefuseFlag',
			header: ("拒绝标志"),
			width: 30,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //列
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetNeedReturnList',
		height: DhcphaJqGridHeight(1, 1),
		shrinkToFit: true,
		datatype: 'local',
		onSelectRow: function (id, status) {
			var iddata = $('#grid-return').jqGrid('getRowData', id);
			var prescyflag = iddata.TCyFlag;
			if (prescyflag == "Y") {
				return;
			}
			var DispBatCode = iddata.TIncDispBatCode;
			if (DispBatCode.indexOf($g("欠药")) >-1) {
				return;
			}
			if ((JqGridCanEdit == false) && (LastEditSel != "") && (LastEditSel != id)) {
				$("#grid-return").jqGrid('setSelection', LastEditSel);
				return
			}
			if ((LastEditSel != "") && (LastEditSel != id)) {
				UpdateReturnGridRow($(this).attr("id"));
			}

			$(this).jqGrid("editRow", id, {
				oneditfunc: function () {
					$editinput = $(event.target).find("input");
					$editinput.focus();
					$editinput.select();
					$("#" + id + "_TRetQty").unbind().on("keyup",function(e){
						$("#" + id + "_TRetQty").val(ParseToNum($("#" + id + "_TRetQty").val()))
					});	
					$("#" + id + "_TRetQty").on("focusout || mouseout", function () {
						if(this.value==""){	// 允许为空
							return true;
						}
						var reg = /^[0-9]\d*$/;
						if (!reg.test(this.value)) {
							dhcphaMsgBox.message($g("第") + id + $g("行的退药数量只能为整数!"))
							$("#grid-return").jqGrid('restoreRow', id);
							JqGridCanEdit = false;
							return false;
						}
						var iddata = $('#grid-return').jqGrid('getRowData', id);
						var dispedqty = iddata.TDispQty;
						if (parseFloat(this.value * 1000) > parseFloat(dispedqty * 1000)) {
							dhcphaMsgBox.message($g("第") + id + $g("行退药数量大于发药数量!"))
							$("#grid-return").jqGrid('restoreRow', id);
							JqGridCanEdit = false;
							return false;
						} else {
							JqGridCanEdit = true;
							return true;
						}
					});
				}
			});
			LastEditSel = id;
		}
	};
	$('#grid-return').dhcphaJqGrid(jqOptions);
	PhaGridFocusOut("grid-return");
}

//查询可退药列表
function QueryGridReturn() {
	var patno = $("#txt-patno").val();
	var prescno = $("#sel-prescno").select2('data')[0].id || "";
	var freeDrgFlag=""
	if ($("#chk-freeDrg").is(':checked')) {
		freeDrgFlag = "Y";
	}
	var params = prescno + "^" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+ "^" + freeDrgFlag;
	$("#grid-return").setGridParam({
		datatype: 'json',
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetNeedReturnList',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");

	$("#grid-request").clearJqGrid();
	JqGridCanEdit = true;
	DHCPHA_CONSTANT.VAR.RETURNROWID = "";
	return true
}
//查询退药申请列表
function QueryGridRequest() {
	var prescNo = $("#sel-prescno").val()||"";
	if(prescNo!=""){return;}
	var patno = $("#txt-patno").val();
			var stdate=$("#date-start").val();
			var enddate=$("#date-end").val();
			
	var params = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "^" + patno+ "^" + stdate+ "^" +enddate ;
	$("#grid-request").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
	$("#grid-return").clearJqGrid();
	return true
}
//执行退药
function DoReturn() {
	if (DHCPHA_CONSTANT.VAR.RETURNROWID != "") {
		dhcphaMsgBox.alert($g("本次记录已退药,请核查!"));
		return;
	}
	if (DhcphaGridIsEmpty("#grid-return") == true) {
		return;
	}
	/*if (JqGridCanEdit == false) {
		return;
	}*/
	if (CheckDataBeforeDoReturn() == false) {
		return;
	}
	$("#sel-retreason").val("")
	$("#modal-outpharetreason").modal('show');
}
//点击退药前的验证
function CheckDataBeforeDoReturn() {
	var retqty = 0,dispedqty = "",refusereason = "",lastrefusereason = "",lastcantretreason="";
	var canreturn = false,returninfo = "",zeroFlag = 0;
	var returnrowdata = $("#grid-return").jqGrid('getRowData');
	var detailgridrows = returnrowdata.length;
	if (detailgridrows <= 0) {
		dhcphaMsgBox.alert($g("没有明细数据!"));
		return false;
	}
	for (var rowi = 0; rowi < detailgridrows; rowi++) {
		var cyflag = returnrowdata[rowi].TCyFlag;
		var refuseflag = returnrowdata[rowi].TRefuseFlag;
		if ((cyflag == "Y") && (refuseflag == "Y")) {
			dhcphaMsgBox.alert($g("该草药处方药品")+":" + returnrowdata[rowi]["TPhdesc"] + "</br>"+$g("存在拒绝退药记录，不能部分退!"));
			return false;
		}
		var cantretreason = returnrowdata[rowi].TCantRetReason;
		if ((cyflag == "Y") && (cantretreason != "")) {
			dhcphaMsgBox.alert($g("该草药处方药品")+":" + returnrowdata[rowi]["TPhdesc"] + "</br>"+$g("维护了不可退药原因，不能部分退!"));
			return false;
		}else if (cantretreason!=""){
			lastcantretreason=cantretreason;
			continue;
		}
		var phdLbRowId = returnrowdata[rowi].TPhdLbRowId;
		var preColFlag = tkMakeServerCall("PHA.OP.Return.OperTab","GetPreColFlag",phdLbRowId)
		//alert("phdLbRowId:"+phdLbRowId+"  preColFlag:"+preColFlag)
		if (preColFlag == "1"){
			dhcphaMsgBox.alert($g("药品")+":" + returnrowdata[rowi]["TPhdesc"] + "</br>"+$g("所在处方已在煎药室收方，不允许退药!"));
			return false;
		}
		var retqty = returnrowdata[rowi].TRetQty;
		var dispedqty = returnrowdata[rowi].TDispQty;
		var refusereason = returnrowdata[rowi].TRefuse;
		if ((refusereason != "") && (refusereason != undefined)) {
			lastrefusereason = refusereason;
			continue;
		}
		retqty = $.trim(retqty);
		dispedqty = $.trim(dispedqty);
		// 空代表不退
		if (retqty == "") {
			continue;
		}
		if (retqty == 0) {
			continue;
		}
		if (parseFloat(retqty) < 0) {
			dhcphaMsgBox.alert($g("药品")+":" + returnrowdata[rowi]["TPhdesc"] + "</br>"+$g("退药数量不能小于0!"));
			return;
		}
		if (isNaN(retqty) == true) {
			dhcphaMsgBox.alert($g("药品")+":" + returnrowdata[rowi]["TPhdesc"] + "</br>"+$g("退药数量不能为非数字!"));
			canreturn = false;
			return;
		}
		canreturn = true;
		returninfo = 1;
	}
	if (lastrefusereason != "") {
		dhcphaMsgBox.alert($g("该退药申请存在拒绝退药记录!"));
	} else if (canreturn == false) {
		if(lastcantretreason!=""){
			dhcphaMsgBox.alert($g("药品维护了不可退原因！")+"</br>"+$g("如：")+lastcantretreason);
		}else{
			dhcphaMsgBox.alert($g("请检查退药数量!"));
		}
	}
	return canreturn;
}
function ExecuteReturn(returnreason) {
	var checkretsum = 0;
	var returninfo = "",oweflag = "";
	var canreturn = true;
	var retqty = "",dispedqty = "",phditm = "",retmoney = "",price = "",batno = "",retuomid = "",refusereason = "",phdlbrowid = "";
	var returnids = $("#grid-return").jqGrid('getDataIDs');
	$.each(returnids, function () {
		var rowdata = $('#grid-return').jqGrid('getRowData', this);
		retqty = rowdata["TRetQty"];
		dispedqty = rowdata["TDispQty"];
		phditm = rowdata["TPhdItm"];
		retmoney = rowdata["TRetMoney"];
		price = rowdata["TPrice"];
		batno = rowdata["TIncDispBatCode"];
		retuomid = rowdata["TPhUomid"];
		refusereason = rowdata["TRefuse"] || "";
		phdlbrowid = rowdata["TPhdLbRowId"];
		var cantretreason = rowdata["TCantRetReason"] || "";
		if (cantretreason != "") {
			return true;
		}
		if (refusereason != "") {
			return true;
		}
		if (retqty == "") {
			return true;
		}
		if (retqty == 0) {
			return true;
		}
		if (phditm == "") {
			return true;
		}
		if (isNaN(retqty) == true) {
			dhcphaMsgBox.alert($g("药品")+":" + rowdata["TPhdesc"] + "</br>"+$g("退药数量不能为非数字!"));
			canreturn = false;
			return false;
		}
		if (parseFloat(retqty) < 0) {
			dhcphaMsgBox.alert($g("药品")+":" + rowdata["TPhdesc"] + "</br>"+$g("退药数量不能小于0!"));
			canreturn = false;
			return false;
		}
		if (parseFloat(retqty * 1000) > parseFloat(dispedqty * 1000)) {
			dhcphaMsgBox.alert($g("药品")+":" + rowdata["TPhdesc"] + "</br>"+$g("退药数量大于发药数量!"));
			canreturn = false;
			return false;
		}
		if ((retqty > 0) && (batno != $g("欠药"))) {
			var checkret = tkMakeServerCall("PHA.OP.Return.Query", "CheckRetQty", phdlbrowid, retqty, retuomid);
			if (checkret == "-1") {
				checkretsum = checkretsum + 1;
				canreturn = false;
				dhcphaMsgBox.alert($g("药品")+":" + rowdata["TPhdesc"] + "</br>"+$g("退药数量大于剩余未退数量!"));
				return false;
			}
		}
		if (batno == $g("欠药")) {
			oweflag = 1;
		}
		var onereturn = "";
		if (oweflag == "1") {
			onereturn = phditm;
		} else {
			onereturn = phditm + "^" + retqty + "^" + retmoney + "^" + retuomid + "^" + this + "^" + phdlbrowid;
		}
		if (returninfo == "") {
			returninfo = onereturn;
		} else {
			returninfo = returninfo + "&" + onereturn;
		}

	})
	if (canreturn == false) {
		return;
	}
	if (returninfo == "") {
		dhcphaMsgBox.alert($g("界面数据,没有可退药品!"));
		return;
	}
	var reqrowid = "";
	var reqselectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
	if (reqselectid != null) {
		var reqselectdata = $('#grid-request').jqGrid('getRowData', reqselectid);
		if (reqselectdata) {
			reqrowid = reqselectdata.reqRowId;
		}
	}
	//验证是否已退
	if (oweflag == "1") {
		var oweresult = tkMakeServerCall("PHA.OP.Owe.OperTab", "DoChowReturn", reqrowid, DHCPHA_CONSTANT.SESSION.GUSER_ROWID, returninfo);
		var oweret = oweresult.split("^")[0];
		if (oweret != 0) {
			dhcphaMsgBox.alert($g("欠药退药失败！")+"</br>"+$g("错误代码")+":" + oweresult.split("^")[1], "error");
			return;
		} else {
			dhcphaMsgBox.alert($g("欠药退药成功!"), "success");
			return;
		}
	} else {
		var retresult = tkMakeServerCall("PHA.OP.Return.OperTab", "DoReturn",
				DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
				DHCPHA_CONSTANT.SESSION.GUSER_ROWID,
				phditm, returnreason, DHCPHA_CONSTANT.VAR.INVROWID, "", reqrowid, returninfo);
		var retval = retresult.split("^")[0];
		var retmessage = retresult.split("^")[1];
		if (retval < 0) {
			dhcphaMsgBox.alert($g(retmessage));
			return;
		} else {
			DHCPHA_CONSTANT.VAR.RETURNROWID=retval;
			dhcphaMsgBox.alert($g("退药成功!"), "success");
		}
	}

}
//拒绝退药
function DoRefuseReturn() {
	
	var reqselectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
	var reqselectdata = $('#grid-request').jqGrid('getRowData', reqselectid);
	
	// MaYuqiang 20210311 草药拒绝退药
	var prescCYFlag = reqselectdata.prescCYFlag ;
	if (prescCYFlag == "Y"){
		DoHERBRefuseReturn() ;
		return ;
	}
	
	
	if (DHCPHA_CONSTANT.VAR.RETURNROWID != "") {
		dhcphaMsgBox.alert($g("本次记录已退药,请核查!"));
		return;
	}
	if (DhcphaGridIsEmpty("#grid-return") == true) {
		return;
	}
	if (DhcphaGridIsSelect("#grid-return") == false) {
		return;
	}
	var retselectid = $("#grid-return").jqGrid('getGridParam', 'selrow');
	var retselectdata = $('#grid-return').jqGrid('getRowData', retselectid);
	var reqitm = retselectdata.TReqItm;
	var refuse = retselectdata.TRefuse;
	
	if ((reqitm == "") || (reqitm == undefined)) {
		dhcphaMsgBox.alert($g("仅根据退药申请退药时允许拒绝!"));
		return;
	}
	if ((refuse != "") && (refuse != undefined)) {
		dhcphaMsgBox.alert($g("该记录已拒绝!"));
		return;
	}
	
	$("#sel-retrefreason").val("")
	$("#modal-outpharetrefreason").modal('show');
}

// MaYuqiang 20210311 草药拒绝退药
function DoHERBRefuseReturn(){
	var reqselectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
	var reqselectdata = $('#grid-request').jqGrid('getRowData', reqselectid);
	var reqRowId = reqselectdata.reqRowId ;
	if ((reqRowId == "") || (reqRowId == undefined)) {
		dhcphaMsgBox.alert($g("草药处方依据退药申请退药时才允许拒绝退药!"));
		return;
	}
	$("#sel-retrefreason").val("")
	$("#modal-outpharetrefreason").modal('show');
	
}


//撤消拒绝
function DoCancelRefuseReturn() {
	
	var reqselectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
	var reqselectdata = $('#grid-request').jqGrid('getRowData', reqselectid);
	
	// MaYuqiang 20210311 草药撤消拒绝退药
	var prescCYFlag = reqselectdata.prescCYFlag ;
	if (prescCYFlag = "Y"){
		var reqRowId = reqselectdata.reqRowId ; 
		DoHERBCancelRefuse(reqRowId) ;
		return ;
	}
	
	
	var retselectid = $("#grid-return").jqGrid('getGridParam', 'selrow');
	if (retselectid == null) {
		dhcphaMsgBox.alert($g("请先选中数据,再进行操作!"));
		return;
	}
	var retselectdata = $('#grid-return').jqGrid('getRowData', retselectid);
	var reqitm = retselectdata.TReqItm;
	var refuse = retselectdata.TRefuse;
	if ((reqitm == "") || (reqitm == undefined)) {
		dhcphaMsgBox.alert($g("仅依据退药申请退药时才允许撤消拒绝!"));
		return;
	}
	if ((refuse == "") || (refuse == undefined)) {
		dhcphaMsgBox.alert($g("该记录不需要撤消拒绝!"));
		return;
	}
	var refuseret = tkMakeServerCall("PHA.OP.Return.OperTab", "CancelRefuseReason", reqitm,DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
		if (refuseret == 0) {
			dhcphaMsgBox.alert($g("撤消拒绝退药成功"), "success");
			var newdata = {
				TRefuse: '',
				TRefuseFlag: ''
			}
			$('#grid-return').jqGrid('setRowData', retselectid, newdata);
		} else {
			dhcphaMsgBox.alert($g("撤消拒绝失败!错误代码:") + refuseret, "error");
		}
}
//仅支持单条拒绝
function ExecuteRefuseReturn(retrefarr) {
	
	var reqselectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
	var reqselectdata = $('#grid-request').jqGrid('getRowData', reqselectid);
	// MaYuqiang 20210311 草药拒绝退药
	var prescCYFlag = reqselectdata.prescCYFlag ;
	if (prescCYFlag = "Y"){
		var reqRowId = reqselectdata.reqRowId ;
		DoHERBExecuteRefuse(retrefarr, reqRowId) ;
		return ;
	}
		
	var retselectid = $("#grid-return").jqGrid('getGridParam', 'selrow');
	var retselectdata = $('#grid-return').jqGrid('getRowData', retselectid);
	var reqitm=retselectdata.TReqItm;
	var refuse=retselectdata.TRefuse;
	if ((reqitm=="")||(reqitm==undefined)){
		dhcphaMsgBox.alert($g("仅依据退药申请退药时才允许拒绝!"));
		return;
	}
	if ((refuse!="")&&(refuse!=undefined)){
		dhcphaMsgBox.alert($g("该记录已拒绝!"));
		return;
	}
	var refuseret = tkMakeServerCall("PHA.OP.Return.OperTab", "RefuseReason", retrefarr.id, reqitm,DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
		if (refuseret == 0) {
			dhcphaMsgBox.alert($g("拒绝退药成功"), "success");
			var newdata = {
				TRefuse: retrefarr.text,
				TRefuseFlag: "Y"
			}
			$('#grid-return').jqGrid('setRowData', retselectid, newdata);
		} else {
			dhcphaMsgBox.alert($g("拒绝失败!错误代码:") + refuseret, "error");
		}
}

/// MaYuqiang 20210311
/// 执行草药处方的拒绝退药
function DoHERBExecuteRefuse(retrefarr, reqRowId){
	
	var refuseret = tkMakeServerCall("PHA.OP.Return.OperTab", "HerbRefuseRet", retrefarr.id, reqRowId,DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if (refuseret == 0) {
		dhcphaMsgBox.alert($g("拒绝退药成功"), "success");
		var newdata = {
			TRefuse: retrefarr.text,
			TRefuseFlag: "Y"
		}
		var rows = $("#grid-return").getGridParam('records');
	    if (rows == 0) {
	        return;
	    }
	    for (var i = 1; i <= rows; i++) {
			$('#grid-return').jqGrid('setRowData', i, newdata);
	    }
	} else {
		dhcphaMsgBox.alert($g("拒绝失败!错误代码:") + refuseret, "error");
	}
}

/// MaYuqiang 20210311
/// 执行草药处方的撤消拒绝退药
function DoHERBCancelRefuse(reqRowId){
	
	var refuseret = tkMakeServerCall("PHA.OP.Return.OperTab", "HerbCancelRefuseRet", reqRowId,DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if (refuseret == 0) {
		dhcphaMsgBox.alert($g("撤消拒绝退药成功"), "success");
		var newdata = {
			TRefuse: '',
			TRefuseFlag: ''
		}
		var rows = $("#grid-return").getGridParam('records');
	    if (rows == 0) {
	        return;
	    }
	    for (var i = 1; i <= rows; i++) {
			$('#grid-return').jqGrid('setRowData', i, newdata);
	    }
	} else {
		dhcphaMsgBox.alert($g("撤消拒绝失败!错误代码:") + refuseret, "error");
	}
	
}

function ClearConditions() {
	var cardoptions = {
		id: "#sel-cardtype"
	}
	InitSelectCardType(cardoptions);
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-30"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-30"));
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());

	if ($("#patInfo")) {
		$("#patInfo").remove()
	}
	$("#grid-request").clearJqGrid();
	$("#grid-return").clearJqGrid();
	$("#sel-prescno").empty();
	$('#chk-freeDrg').iCheck('uncheck');
	JqGridCanEdit = true;
}
function InitReturnModal() {
	//退药
	$('#modal-outpharetreason').on('show.bs.modal', function () {
		var locoption = {
			url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + "?action=GetRetReason&style=select2"+"&HospId=" + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID,
			minimumResultsForSearch: Infinity,
			allowClear: false,
			width: 200
		}
		$("#sel-retreason").dhcphaSelect(locoption)
		$("#sel-retreason").empty();
		var selectid = $("#grid-request").jqGrid('getGridParam', 'selrow');
		if ((selectid != "") && (selectid != undefined)) {
			var selrowdata = $("#grid-request").jqGrid('getRowData', selectid);
			var select2option = '<option value=' + "'" + selrowdata.reqReason + "'" + 'selected>' + selrowdata.reqReasonDesc + '</option>'
				$("#sel-retreason").append(select2option);
		}
	})
	$("#btn-retreason-sure").on("click", function () {
		var returnreason = $("#sel-retreason").val();
		if ((returnreason == "") || (returnreason == null)) {
			dhcphaMsgBox.alert($g("请选择退药原因!"));
			return;
		}
		$("#modal-outpharetreason").modal('hide');
		ExecuteReturn(returnreason);
	});
	//拒绝退药
	$('#modal-outpharetrefreason').on('show.bs.modal', function () {
		var locoption = {
			url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + "?action=GetRetRefuseReason&style=select2"+"&HospId=" + DHCPHA_CONSTANT.SESSION.GHOSP_ROWID,
			minimumResultsForSearch: Infinity,
			width: 200
		}
		$("#sel-retrefreason").dhcphaSelect(locoption);
		$("#sel-retrefreason").empty();
	})
	$("#btn-retrefreason-sure").on("click", function () {
		var returnrefreason = $("#sel-retrefreason").val();
		var returnrefreasondesc = $("#sel-retrefreason").text();
		var retrefarr = {
			id: returnrefreason,
			text: returnrefreasondesc
		}
		if ((returnrefreason == "") || (returnrefreason == null)) {
			dhcphaMsgBox.alert($g("请选择拒绝退药原因!"));
			return;
		}
		$("#modal-outpharetrefreason").modal('hide');
		ExecuteRefuseReturn(retrefarr);
	});
}
function InitBodyStyle() {
	$("#grid-return").setGridWidth("");
}
function PhaGridFocusOut(gridid) {
	$("#" + gridid).on("mouseleave",function (e) {
		if (e.relatedTarget) {
			var $related = $("#" + gridid).find(e.relatedTarget);
			if ($related.length <= 0 && LastEditSel != "") {
				UpdateReturnGridRow(gridid);
			}
		}
	})
}

function UpdateReturnGridRow(inputId) {
	$("#" + inputId).jqGrid('saveRow', LastEditSel, true);
	UpdateReturnGridRowData(inputId);

}
function UpdateReturnGridRowData(inputId) {
	var selrowdata = $("#" + inputId).jqGrid('getRowData', LastEditSel);
	var selretqty = selrowdata.TRetQty;
	var selprice = selrowdata.TPrice;
	selretqty = $.jgrid.stripHtml(selretqty);
	var retamt = selretqty * selprice;
	$("#" + inputId).setCell(LastEditSel, 'TRetMoney', retamt);
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
	var newpatno = $("#txt-patno").val();
	var patoptions = {
		id: "#dhcpha-patinfo",
		gettype: "patno",
		input: newpatno
	}
	AppendPatientBasicInfo(patoptions);
	QueryGridRequest();
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
			var retjson = JSON.parse(data);
			var retdata = retjson[0];
			DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
			var permissioninfo = "",permissionmsg = "";
			//增加验证，add by zhaoxinlong 2022.05.10
			if (retdata.phloc == "") {
				permissionmsg = $g("药房科室")+":" + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = $g("尚未在门诊药房科室维护中维护!")
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
				var returnNeedReq=retdata.ReturnNeedReq;
				PHAOUT_NEEDREQ=returnNeedReq
				if(returnNeedReq=="Y"){
					//$("#divPrescNo").css("display","none");
				}else{
					$("#divFreeDrg").css("display","none");
				}
			}
		},
		error: function () {
		}
	})
}

window.onresize = ResizeReturn;

function ResizeReturn() {
   
    var titleheight = $("#gview_grid-return .ui-jqgrid-hbox").height();
    var gridheight = DhcphaJqGridHeight(1, 1)  ;  //+32
    $("#grid-return").setGridHeight(gridheight).setGridWidth("");
    $("#grid-request").setGridHeight(gridheight).setGridWidth("");

}
