/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-��ҩȷ��
 *createdate:2016-08-15
 *creator:dinghongying
 *last modified by yunhaibao 2016-08-23
 */
DHCPHA_CONSTANT.URL.THIS_URL = "dhcpha/dhcpha.outpha.dispconfirm.action.csp";
DhcphaTempBarCode = "";
$(function () {
	$("#rankofpy").height($(window).height() - 20); //�������߶�
	/*��ʼ����� start*/
	InitGridDispConfirm();
	/*��ʼ����� end*/
	//�����Żس��¼�
	$('#txt-prescno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			QueryPrescDetail();
		}
	});

	//���Żس��¼�
	$('#txt-usercode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			ExecuteSure();
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	});
	/* �󶨰�ť�¼� start*/
	$("#btn-clear").on("click", ClearConditons);
	$("#a-help").popover({
		animation: true,
		placement: 'bottom',
		trigger: 'hover',
		html: true,
		content: '<div style="width:300px;">*'+$g("��ܰ��ʾ")+'*</br>'+$g("����ɨ�账����,��ɨ�蹤��Ŷ~")+'</div>' //
	});
	$("#btn-sure").on("click", ExecuteSure);
	$("#todayrank").on("click", QueryRankOfConfirm);
	/* �󶨰�ť�¼� end*/
	$("#grid-dispconfirm").setGridWidth("")
	//��ѯ����
	QueryRankOfConfirm();
	document.onkeydown = OnKeyDownHandler;
})

//��ʼ����ϸtable
function InitGridDispConfirm() {
	var columns = [{
			header: ("�ǼǺ�"),
			index: 'patNo',
			name: 'patNo',
			width: 100
		}, {
			header: ("����"),
			index: 'patName',
			name: 'patName',
			width: 100,
			align: "left"
		}, {
			header: ("��ҩ����"),
			index: 'phwDesc',
			name: 'phwDesc',
			width: 120,
			align: "left"
		}, {
			header: ("ҩƷ����"),
			index: 'incDesc',
			name: 'incDesc',
			align: "left",
			width: 200
		}, {
			header: ("����"),
			index: 'qty',
			name: 'qty',
			width: 60,
			align: "right"
		}, {
			header: ("��λ"),
			index: 'uomDesc',
			name: 'uomDesc',
			width: 60,
			align: "left"
		}, {
			header: ("����"),
			index: 'sp',
			name: 'sp',
			width: 100,
			align: "right"
		}, {
			header: ("���"),
			index: 'spAmt',
			name: 'spAmt',
			width: 100,
			align: "right"
		}, {
			header: ("����"),
			index: 'dosage',
			name: 'dosage',
			width: 100,
			align: "left"
		}, {
			header: ("Ƶ��"),
			index: 'freqDesc',
			name: 'freqDesc',
			width: 100,
			align: "left"
		}, {
			header: ("�÷�"),
			index: 'instrucDesc',
			name: 'instrucDesc',
			width: 100,
			align: "left"
		}, {
			header: ("�Ƴ�"),
			index: 'duraDesc',
			name: 'duraDesc',
			width: 100,
			align: "left"
		}, {
			header: ("ҽ��"),
			index: 'docName',
			name: 'docName',
			width: 100,
			align: "left"
		}, {
			header: ("ҽ��״̬"),
			index: 'oeoriStat',
			name: 'oeoriStat',
			width: 75,
			align: "left"
		}, {
			header: ("�����ܼ�"),
			index: 'encryptLevel',
			name: 'encryptLevel',
			width: 70,
			align: "left",
			hidden: true
		}, {
			header: ("���˼���"),
			index: 'patLevel',
			name: 'patLevel',
			width: 70,
			align: "left",
			hidden: true
		}, {
			header: ("��ҩ��Id"),
			index: 'phdId',
			name: 'phdId',
			width: 30,
			hidden: true
		}, {
			header: ("������"),
			index: 'prescNo',
			name: 'prescNo',
			width: 30,
			hidden: true
		}

	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
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
//��ѯ������ϸ
function QueryPrescDetail() {
	var prescno = $.trim($("#txt-prescno").val());
	if (prescno != '') {
		var retValue = tkMakeServerCall("PHA.OP.PyConfirm.Query", "GetPhdByPrescNo", prescno);
		if (retValue == 0) {
			dhcphaMsgBox.alert($g("�ô��������ڻ�ô�����ȷ��,���ʵ!"));
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
		dhcphaMsgBox.alert($g("������Ϊ��,���ʵ!"));
	}
	$("#txt-prescno").val("");
}
//��֤�û���Ϣ��ִ��ȷ��
function ExecuteSure() {
	DhcphaTempBarCode = "";
	var usercode = $.trim($("#txt-usercode").val());
	var grid_records = $("#grid-dispconfirm").getGridParam('records');
	if (grid_records == 0) {
		dhcphaMsgBox.alert($g("��ǰ��������ϸ����,����ɨ�账���ţ�"));
		$("#txt-usercode").val("");
		$("#txt-prescno").val("");
		return;
	}
	if (usercode == "") {
		dhcphaMsgBox.alert($g("���Ų���Ϊ��!"));
		$("#txt-usercode").val("");
		$("#txt-prescno").val("");
		return;
	}
	var retValue = tkMakeServerCall("web.DHCOutPhTQDisp", "GetPydr", usercode, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	var retCode = retValue.split("^")[0];
	var retMessage = retValue.split("^")[1];
	if (retCode < 1) {
		dhcphaMsgBox.alert($g("���Ŷ�Ӧ����ҩ��û�ж���,��������ҩ���������õ���ԱȨ��ҳǩ�к�ʵ!"));
		$("#txt-usercode").val("");
		return;
	} else {
		var firstrowdata = $("#grid-dispconfirm").jqGrid("getRowData", 1); //��ȡ��һ������
		var phdrow = firstrowdata.phdId;
		var prescno = firstrowdata.prescNo || "";
		if ((phdrow == "") || (phdrow == undefined)) {
			dhcphaMsgBox.alert($g("����ϵ����ʦ��֤�����Ƿ��������!"));
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
		alert("ȷ��ʧ��");
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
						'<span style="padding-left:15px">' + DHCPHA_CONSTANT.SESSION.GUSER_NAME + "��" + pycount + '</span>' +
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
				'<em>��NO.' + countrecords + '</em>' +
				'</span>��'
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
//��ҳ��table���ø߶�
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
//����keydown,���ڶ�λɨ��ǹɨ����ֵ
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
