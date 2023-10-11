/**
 * ģ��:     ������ҩ���뵥��ѯ
 * ��д����: 2018-10-23
 * ��д��:   DingHongying
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroupId = session['LOGON.GROUPID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", SessionGroupId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var Loaded = 0;
$(function () {
	InitDict();
	InitGridRequest();
	InitGridRequestDetail();
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patNo = $.trim($("#txtPatNo").val());
			if (patNo != "") {
				var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
				$(this).val(newPatNo);
				var patInfo = tkMakeServerCall("PHA.COM.Order", "GetPatByNo", newPatNo);
				$("#txtPatName").val(patInfo.split("^")[0] || "");
			} else {
				$("#txtPatName").val("");
			}
		}
	});
	$("#btnFind").on("click", Query);
	$("#btnPrintReq").on("click", Print);
	$("#btnClear").on("click", Clear);
	$("#btnDelReqItm").on("click", DeleteReqItm);
	window.resizeTo(screen.availWidth - 6, (screen.availHeight - 100));
	window.moveTo(3, 90);
});

function InitDict() {
	DHCPHA_HUI_COM.ComboBox.Init({
		Id: 'cmbPhaLoc',
		Type: 'PhaLoc'
	}, {
		onLoadSuccess: function () {
			if (Loaded < 2) {
				$("#cmbPhaLoc").combobox("setValue", DefPhaLocId);
				Loaded++;
			}
		}
	});
	$("#dateStart").datebox("setValue", DHCPHA_TOOLS.Today());
	$("#dateEnd").datebox("setValue", DHCPHA_TOOLS.Today());
}

// ���뵥�б�
function InitGridRequest() {
	var columns = [
		[{
				field: 'req',
				title: ("����Id"),
				width: 80,
				align: 'left',
				hidden: true
			}, {
				field: 'reqCode',
				title: ("���󵥺�"),
				width: 80,
				align: 'left'
			}, {
				field: 'reqDate',
				title: ("��������"),
				width: 100,
				align: 'left'
			}, {
				field: 'reqTime',
				title: ("����ʱ��"),
				width: 100,
				align: 'left'
			}, {
				field: 'reason',
				title: ("����ԭ��"),
				width: 100,
				align: 'left'
			}, {
				field: 'retFlag',
				title: ("���˱�־"),
				width: 80,
				align: 'center',
				editor: {
					type: 'icheckbox',
					options: {
						on: '1',
						off: '0'
					}
				},
				formatter: function (value, row, index) {
					if (value == "1") {
						return '<input type="checkbox" name="hisui-checkbox" checked="checked" disabled="disabled">';
					} else {
						return '<input type="checkbox" name="hisui-checkbox" disabled="disabled">';
					}
				}
			}, {
				field: 'userName',
				title: ("������"),
				width: 100,
				align: 'left'
			}, {
				field: 'pano',
				title: ("�ǼǺ�"),
				width: 120,
				align: 'left'
			}, {
				field: 'paname',
				title: ("��������"),
				width: 100,
				align: 'left'
			}, {
				field: 'age',
				title: ("����"),
				width: 80,
				align: 'left'
			}, {
				field: 'pasex',
				title: ("�Ա�"),
				width: 80,
				align: 'left'
			}, {
				field: 'invNo',
				title: ("��Ʊ��"),
				width: 100,
				halign: 'left',
				align: 'left',
				hidden: true
			}, {
				field: 'dispLoc',
				title: ("ҩ��"),
				width: 100,
				align: 'left'
			}, {
				field: 'ordDeptLoc',
				title: ("�������"),
				width: 150,
				align: 'left'
			}
		]
	];
	var dataGridOption = {
		url: "",
		fit: true,
		border: false,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		rownumbers: false,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 300, 500],
		pagination: true,
		toolbar:[],
		onSelect: function (rowIndex, rowData) {
			if (rowData) {
				QueryDetail();
			}
		},
		onUnselect: function (rowIndex, rowData) {
			if (rowData) {
				QueryDetail();
			}
		},
		onLoadSuccess: function () {
			$('#gridRequestDetail').datagrid('uncheckAll');
		}
	}
	DHCPHA_HUI_COM.Grid.Init("gridRequest", dataGridOption);
}

// ��ȡ����
function QueryParams() {
	var stDate = $('#dateStart').datebox('getValue');
	var edDate = $('#dateEnd').datebox('getValue');
	var phaLocId = $('#cmbPhaLoc').combobox("getValue");
	var patNo = $('#txtPatNo').val().trim();
	var onlyFlag = "";
	if (($('#onlyflag').is(':checked')) == true) {
		onlyFlag = "on";
	}
	var patName = $('#txtPatName').val().trim();
	return stDate + "^" + edDate + "^" + phaLocId + "^" + patNo + "^" + onlyFlag + "^" + patName;
}
// ��ѯ
function Query() {
	$("#gridRequestDetail").datagrid("clear");
	var params = QueryParams();
	paramsArr = params.split("^")
		$('#gridRequest').datagrid({
			url: $URL,
			queryParams: {
				ClassName: "PHA.OP.RetReq.Query",
				QueryName: "RetReqBill",
				displocRowid: paramsArr[2],
				StartDate: paramsArr[0],
				EndDate: paramsArr[1],
				OperUser: SessionUser,
				thePrt: "",
				PrescNo: "",
				PatNo: paramsArr[3],
				ctloc: SessionLoc,
				onlyAdmDoc: paramsArr[4],
				pmiName: paramsArr[5]
			}
		});
}

// ���뵥��ϸ�б�
function InitGridRequestDetail() {
	var columns = [
		[{
				field: 'gridRequestDetailSelect',
				checkbox: true
			}, {
				field: 'reqi',
				title: 'reqi',
				width: 80,
				halign: 'center',
				hidden: true
			}, {
				field: 'arcimDesc',
				title: ("ҩƷ����"),
				width: 450,
				align: 'left'
			}, {
				field: 'uom',
				title: ("��λ"),
				width: 120,
				align: 'left'
			}, {
				field: 'dispQty',
				title: ("��ҩ����"),
				width: 150,
				halign: 'left',
				align: 'left'
			}, {
				field: 'reqQty',
				title: ("��������"),
				width: 150,
				halign: 'left',
				align: 'left'
			}, {
				field: 'retQty',
				title: ("��������"),
				width: 150,
				hidden: true
			}, {
				field: 'dispAmt',
				title: ("��ҩ���"),
				width: 150,
				hidden: true
			}, {
				field: 'sp',
				title: ("����"),
				width: 120,
				halign: 'right',
				align: 'right',
				/*formatter: function (value, row, index) {
				if (row != null) {
				return parseFloat(value).toFixed(2);
				}
				}*/
			}, {
				field: 'prescno',
				title: ("������"),
				width: 180,
				halign: 'left',
				align: 'left'
			}, {
				field: 'reqAmt',
				title: ("������"),
				width: 140,
				halign: 'right',
				align: 'right'
			}, {
				field: 'cyFlag',
				title: ("��ҩ������־"),
				width: 80,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: "",
		fit: true,
		border: false,
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
		rownumbers: false,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 300, 500],
		pagination: true,
		toolbar: "#gridRequestDetailBar",
		onSelect: function (rowIndex, rowData) {},
		onUnselect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {
			$('#gridRequestDetail').datagrid('uncheckAll');
		},
		onCheck: function (rowIndex, rowData) {
			var cyFlag = rowData.cyFlag;
			if (cyFlag != "Y") {
				return;
			}
			DHCPHA_HUI_COM.Grid.LinkCheck.Init({
				CurRowIndex: rowIndex,
				GridId: 'gridRequestDetail',
				Field: 'prescno',
				Check: true,
				Value: rowData.prescno
			});
		},
		onUncheck: function (rowIndex, rowData) {
			var cyFlag = rowData.cyFlag;
			if (cyFlag != "Y") {
				return;
			}
			DHCPHA_HUI_COM.Grid.LinkCheck.Init({
				CurRowIndex: rowIndex,
				GridId: 'gridRequestDetail',
				Field: 'prescno',
				Check: false,
				Value: rowData.prescno
			});
		}
	}
	DHCPHA_HUI_COM.Grid.Init("gridRequestDetail", dataGridOption);
}

// ��ѯ��ϸ
function QueryDetail() {
	var row = $('#gridRequest').datagrid('getSelected');
	var reqId = row.req;
	if ((reqId == null) || (reqId == "")) {
		$.messager.alert($g("��ʾ"), $g("����ѡ���¼"), "warning");
		return;
	}
	$('#gridRequestDetail').datagrid({
		url: $URL,
		queryParams: {
			ClassName: "PHA.OP.RetReq.Query",
			QueryName: "RetReqBillItem",
			req: reqId
		}
	});
}

// ��ȡѡ�м�¼��������ϸ��id
function GetCheckedReqItmArr() {
	var reqItmArr = [];
	var gridReqDetailChecked = $('#gridRequestDetail').datagrid('getChecked');
	for (var i = 0; i < gridReqDetailChecked.length; i++) {
		var checkedData = gridReqDetailChecked[i];
		var reqItmRowId = checkedData.reqi;
		if (reqItmArr.indexOf(reqItmRowId) < 0) {
			reqItmArr.push(reqItmRowId);
		}
	}
	return reqItmArr.join("^");
}

function DeleteReqItm() {
	var reqItmIdStr = GetCheckedReqItmArr();
	if ((reqItmIdStr == "") || (reqItmIdStr == undefined)) {
		$.messager.alert($g("��ʾ"), $g("���ȹ�ѡ��Ҫɾ���ļ�¼"), "warning");
		return;
	}

	var delRet = tkMakeServerCall("PHA.OP.RetReq.OperTab", "DeleteItms", reqItmIdStr);
	var delRetArr = delRet.split("^");
	var delVal = delRetArr[0];
	var delInfo = delRetArr[1];
	if (delVal < 0) {
		$.messager.alert($g("��ʾ"), delInfo, "warning");
		//return;
	}else{
		$.messager.alert($g("��ʾ"), $g("ɾ���ɹ�"), "info");
	}
	QueryDetail();
}

function Clear() {
	$("#gridRequest").datagrid("clear");
	$("#gridRequestDetail").datagrid("clear");
	$("#txtPatNo").val("");
	$("#txtPatName").val("");
	$("#cmbPhaLoc").combobox("setValue", "");
	$("#dateStart").datebox("setValue", DHCPHA_TOOLS.Today());
	$("#dateEnd").datebox("setValue", DHCPHA_TOOLS.Today());
	$('#onlyflag').checkbox("uncheck",true) ;

}
function Print() {
	var row = $('#gridRequest').datagrid('getSelected');
	if ((row == null) || (row == "")) {
		$.messager.alert($g("��ʾ"), $g("�빴ѡ��Ҫ��ӡ����ҩ���뵥"), "warning");
		return;
	}
	
	///��ȡ���뵥����
	var reqId = row.reqCode;
	var prtData = tkMakeServerCall("PHA.OP.COM.Print", "JsonPrtReqData", reqId);

	var prtJson=JSON.parse(prtData);
	
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "DHCOutReturnRequest",
		data:prtJson,
		listBorder: {style:4, startX:1, endX:90,space:1},
		 aptListFields: ["lasttitle","lasttitle2"],
		 listAutoWrap:true
	 });
}