/*
 *模块:门诊药房
 *子模块:门诊药房-配药确认
 *createdate:2016-08-15
 *creator:dinghongying
 *last modified by yunhaibao 2016-08-23
 */
DHCPHA_CONSTANT.URL.THIS_URL = "dhcpha/dhcpha.outpha.dispconfirm.action.csp";
DhcphaTempBarCode = "";
$(function () {
	$("#rankofpy").height($(window).height() - 20); //定义左侧高度
	/*初始化插件 start*/
	InitGridDispConfirm();
	/*初始化插件 end*/
	//处方号回车事件
	$('#txt-prescno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			QueryPrescDetail();
		}
	});

	//工号回车事件
	$('#txt-usercode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			ExecuteSure();
		}
	});
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	});
	/* 绑定按钮事件 start*/
	$("#btn-clear").on("click", ClearConditons);
	$("#a-help").popover({
		animation: true,
		placement: 'bottom',
		trigger: 'hover',
		html: true,
		content: '<div style="width:300px;">*'+$g("温馨提示")+'*</br>'+$g("请先扫描处方号,再扫描工号哦~")+'</div>' //
	});
	$("#btn-sure").on("click", ExecuteSure);
	$("#todayrank").on("click", QueryRankOfConfirm);
	/* 绑定按钮事件 end*/
	$("#grid-dispconfirm").setGridWidth("")
	//查询排名
	QueryRankOfConfirm();
	document.onkeydown = OnKeyDownHandler;
})

//初始化明细table
function InitGridDispConfirm() {
	var columns = [{
			header: ("登记号"),
			index: 'patNo',
			name: 'patNo',
			width: 100
		}, {
			header: ("姓名"),
			index: 'patName',
			name: 'patName',
			width: 100,
			align: "left"
		}, {
			header: ("发药窗口"),
			index: 'phwDesc',
			name: 'phwDesc',
			width: 120,
			align: "left"
		}, {
			header: ("药品名称"),
			index: 'incDesc',
			name: 'incDesc',
			align: "left",
			width: 200
		}, {
			header: ("数量"),
			index: 'qty',
			name: 'qty',
			width: 60,
			align: "right"
		}, {
			header: ("单位"),
			index: 'uomDesc',
			name: 'uomDesc',
			width: 60,
			align: "left"
		}, {
			header: ("单价"),
			index: 'sp',
			name: 'sp',
			width: 100,
			align: "right"
		}, {
			header: ("金额"),
			index: 'spAmt',
			name: 'spAmt',
			width: 100,
			align: "right"
		}, {
			header: ("剂量"),
			index: 'dosage',
			name: 'dosage',
			width: 100,
			align: "left"
		}, {
			header: ("频次"),
			index: 'freqDesc',
			name: 'freqDesc',
			width: 100,
			align: "left"
		}, {
			header: ("用法"),
			index: 'instrucDesc',
			name: 'instrucDesc',
			width: 100,
			align: "left"
		}, {
			header: ("疗程"),
			index: 'duraDesc',
			name: 'duraDesc',
			width: 100,
			align: "left"
		}, {
			header: ("医生"),
			index: 'docName',
			name: 'docName',
			width: 100,
			align: "left"
		}, {
			header: ("医嘱状态"),
			index: 'oeoriStat',
			name: 'oeoriStat',
			width: 75,
			align: "left"
		}, {
			header: ("病人密级"),
			index: 'encryptLevel',
			name: 'encryptLevel',
			width: 70,
			align: "left",
			hidden: true
		}, {
			header: ("病人级别"),
			index: 'patLevel',
			name: 'patLevel',
			width: 70,
			align: "left",
			hidden: true
		}, {
			header: ("发药表Id"),
			index: 'phdId',
			name: 'phdId',
			width: 30,
			hidden: true
		}, {
			header: ("处方号"),
			index: 'prescNo',
			name: 'prescNo',
			width: 30,
			hidden: true
		}

	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //列
		url: "DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.PyConfirm.Display&MethodName=JqGetConfirmPYData",
		height: DispConfirmCanUseHeight(),
		shrinkToFit: false,
		loadComplete: function () {
			var grid_records = $(this).getGridParam('records');
			if ((grid_records > 0) && ($("#txt-usercode").val() != "")) {
				ExecuteSure();
			}
		}
	};
	$("#grid-dispconfirm").dhcphaJqGrid(jqOptions);
}
//查询处方明细
function QueryPrescDetail() {
	var prescno = $.trim($("#txt-prescno").val());
	if (prescno != '') {
		var retValue = tkMakeServerCall("PHA.OP.PyConfirm.Query", "GetPhdByPrescNo", prescno);
		if (retValue == 0) {
			dhcphaMsgBox.alert($g("该处方不存在或该处方已确认,请核实!"));
		} else {
			$("#grid-dispconfirm").setGridParam({
				datatype: 'json',
				postData: {
					'InputStr': prescno
				}
			}).trigger("reloadGrid");
			if (CheckTxtFocus() == true) {
				$("#txt-usercode").focus();
			}
		}
	} else {
		dhcphaMsgBox.alert($g("处方号为空,请核实!"));
	}
	$("#txt-prescno").val("");
}
//验证用户信息并执行确认
function ExecuteSure() {
	DhcphaTempBarCode = "";
	var usercode = $.trim($("#txt-usercode").val());
	var grid_records = $("#grid-dispconfirm").getGridParam('records');
	if (grid_records == 0) {
		dhcphaMsgBox.alert($g("当前界面无明细数据,请先扫描处方号！"));
		$("#txt-usercode").val("");
		$("#txt-prescno").val("");
		return;
	}
	if (usercode == "") {
		dhcphaMsgBox.alert($g("工号不能为空!"));
		$("#txt-usercode").val("");
		$("#txt-prescno").val("");
		return;
	}
	var retValue = tkMakeServerCall("web.DHCOutPhTQDisp", "GetPydr", usercode, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	var retCode = retValue.split("^")[0];
	var retMessage = retValue.split("^")[1];
	if (retCode < 1) {
		dhcphaMsgBox.alert($g("工号对应的配药人没有定义,请在门诊药房科室配置的人员权限页签中核实!"));
		$("#txt-usercode").val("");
		return;
	} else {
		var firstrowdata = $("#grid-dispconfirm").jqGrid("getRowData", 1); //获取第一行数据
		var phdrow = firstrowdata.phdId;
		var prescno = firstrowdata.prescNo || "";
		if ((phdrow == "") || (phdrow == undefined)) {
			dhcphaMsgBox.alert($g("请联系工程师验证程序是否存在问题!"));
			return;
		}
		var pydr = retCode;
		var params = phdrow + "^" + pydr + "^" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
		var retval = tkMakeServerCall("PHA.OP.PyConfirm.OperTab", "UpdatePhdRowid", phdrow, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, pydr);
		var retCode = retval.split("^")[0];
		var retMessage = retval.split("^")[1];
		if (retCode != 0) {
			dhcphaMsgBox.alert(retMessage);
			return;
		}
		$("#grid-dispconfirm").setGridParam({
			postData: {
				'InputStr': prescno
			}
		}).trigger("reloadGrid");
		//var  tmpnum=parseFloat($("#lbl-dispcount").text())+1;
		//$("#lbl-dispcount").text(tmpnum)
		$("#txt-prescno").val("");
		$("#txt-usercode").val("");
		QueryRankOfConfirm();
		/*if(retval==0){
		scpath=tkMakeServerCall("web.DHCOutPhNewAddCommit","GetScreenPath",phl);
		if(scpath!="-1"){
		var retcall=tkMakeServerCall("web.DHCOutPhNewAddCommit","SendDHCall",presc,dispflag);
		}
		else{
		alert("确认失败");
		$("#txt-usercode").val("");
		}
		}*/
	}
}
function QueryRankOfConfirm() {
	var params = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "^" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	$.ajax({
		url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=RankOfDispConfirm&params=' + encodeURI(params),
		type: 'post',
		success: function (data) {
			if (data == "") {
				return;
			}
			var retjson = JSON.parse(data);
			var list_content = '';
			var pyuserid = "",
			pyusername = "",
			pycount = 0,
			countrecords = 0,
			nocolor = "black",
			nobackgroudcolor = "#45D28E";
			$.each(retjson, function () {
				pyusername = this.name;
				pycount = this.count;
				countrecords = countrecords + 1;
				pyuserid = this.id;
				if (pyuserid == DHCPHA_CONSTANT.SESSION.GUSER_ROWID) {
					if ($("#rankofme").children()) {
						$("#rankofme").children().remove();
					}
					$("#lbl-dispcount").text(pycount);
					var me_content = '<div style="color:white;padding-top:3px">' +
						'<span style=";font-weight:bold"><em>NO.' + countrecords + '</em>' + '</span>' +
						//'<span style="padding-left:15px"><image  src="../scripts/pharmacy/images/little-mixmale.png" color="">'+'</span>'+
						'<span style="padding-left:15px">' + DHCPHA_CONSTANT.SESSION.GUSER_NAME + "　" + pycount + '</span>' +
						'</div>'
						$("#rankofme").append(me_content)
				}
				if (countrecords == 1) {
					nocolor = "#FF5152";
				} else if (countrecords == 2) {
					nocolor = "#FD9563";
				} else if (countrecords == 3) {
					nocolor = "#FFCE33";
				} else {
					nocolor = "#7F7F7F";
				}
				var kingpng = "";
				if (countrecords < 4) {
					kingpng = "king" + countrecords + ".png";
				}
				list_content +=
				'<li class="list-group-item li_color" >' +
				'<span style="color:' + nocolor + ';font-weight:bold">' +
				'<em>　NO.' + countrecords + '</em>' +
				'</span>　'
				//+
				//'<span><image  src="../scripts/pharmacy/images/little-mixmale.png" color="">'
				//if (kingpng!=""){
				//	list_content+='<image  style="position: absolute;left: 50px;top:0px;" src='+"../scripts/pharmacy/images/"+kingpng+'>'
				//}
				list_content += '</span>' +
				'<span style="padding-left:' + ((countrecords < 10) ? 10 : 1.75) + 'px;">' + pyusername + '</span>' +
				'<span class="badge" style="background-color:' + nobackgroudcolor + ';margin:2px;">' + pycount + '</span>' +
				'</li>';
			})
			if ($("#list-list").children()) {
				$("#list-list").children().remove();
			}
			$("#list-list").append(list_content);
		},
		error: function () {}
	})
}
function ClearConditons() {
	$("#txt-prescno").val("");
	$("#txt-usercode").val("");
	$("#grid-dispconfirm").jqGrid("clearGridData");
	DhcphaTempBarCode = "";

}
//本页面table可用高度
function DispConfirmCanUseHeight() {
	var height1 = parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2 = parseFloat($("[class='panel-heading']").outerHeight());
	var height3 = parseFloat($("#firstrow").outerHeight());
	var height4 = parseFloat($(".div_content").css("margin-top"));
	var height5 = parseFloat($(".div_content").css("margin-bottom"));
	var height6 = parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight = height1 - height5 - height3 - height2 - height4 - height6 - DhcphaGridTrHeight
		return tableheight;
}
function CheckTxtFocus() {
	var txtfocus1 = $("#txt-prescno").is(":focus");
	var txtfocus2 = $("#txt-usercode").is(":focus")
		if ((txtfocus1 != true) & (txtfocus2 != true)) {
			return false;
		}
		return true;
}
//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler() {
	if($(".bootbox .btn")[0]){
		if (event.keyCode == 13) {
			$(".bootbox .btn").click();
			if ($("#grid-dispconfirm").getGridParam('records') > 0) {
				window.setTimeout(function(){$("#txt-usercode").focus(); },500);
			}
			else{
				window.setTimeout(function(){$("#txt-prescno").focus(); },500);
			}
		}
		else{
			$(".bootbox .btn").focus()
		}
		return;
		
	}
	if (CheckTxtFocus() != true) {
		if (event.keyCode == 13) {
			if (DhcphaTempBarCode.length > 10) {
				$("#txt-prescno").val(DhcphaTempBarCode);
				QueryPrescDetail();
			} else {
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-dispconfirm").getGridParam('records') > 0) {
					ExecuteSure();
				}
			}
			DhcphaTempBarCode = "";
		} else {
			DhcphaTempBarCode += String.fromCharCode(event.keyCode);
		}
	}
}
