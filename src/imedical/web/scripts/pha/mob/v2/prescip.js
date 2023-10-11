/**
 * @Description: �ƶ�ҩ�� - סԺ�в�ҩ������ѯ
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.prescip.csp
 * @Js:          pha/mob/v2/prescip.js
 */
var curLocId = session['LOGON.CTLOCID'];
PHA_COM.VAR = {
	CONFIG: null
};
var combWidth = 130;
var gLocId = session['LOGON.CTLOCID'] ;
var gUserID = session['LOGON.USERID'] ;
$(function () {
	//��ʼ������
	InitDict();
	InitGridPresc();
	InitGridPrescDetail();
	PHA_COM.ResizePanel({
		layoutId: 'layout-main',
		region: 'south',
		height: 0.4
	});
	
	
	//���¼�
	$('#btnFind').on("click", QueryPresc);
	$('#btnPrint').on("click", Print);
	$('#btnPrinLabel').on("click", PrinDJLabel);
	$('#btnPrintHPLabel').on("click", PrintHPLabel);
	$('#btnAllowRet').on("click", AllowRet);
	$('#btnEmergency').on("click", Emergency);
	$('#btnCancelRefuse').on('click', CancelRefuse);
	$('#btnClear').on('click', Clear);

	// �ǼǺŻس��¼�
	$('#patNo').on('keypress', function (event) {
		if (event.keyCode == 13) {
			var patNo = $('#patNo').val();
			if (patNo == "") {
				return;
			}
			var newPatNo = PHA_COM.FullPatNo(patNo);
			$('#patNo').val(newPatNo);
			QueryPresc();
		}
	});

	// �����Żس��¼�
	$('#prescNo').on('keypress', function (event) {
		if (event.keyCode == 13) {
			var prescNo = $('#txt-PrescNo').val();
			if (prescNo == "") {
				return;
			}
			var newPrescNo = tkMakeServerCall("PHA.COM.MOB.Utils", "%PrescNoPadding", prescNo, 6, "I");
			$('#txt-PrescNo').val(newPrescNo);
			QueryPresc();
		}
	});
});

// ��ʼ��������
function InitDict() {
	PHA.ComboBox("phLoc", {
		placeholder: '��ѡ��ҩ��...',
		url: PHA_STORE.Pharmacy().url,
		width: combWidth ,
		onLoadSuccess: function(data){
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == gLocId) {
					$('#phLoc').combobox('setValue', iData.RowId);
				}
			}
		}
	});
	PHA.ComboBox("prescStatus", {
		placeholder: 'ѡ�񴦷�״̬...',
		url: $URL + '?ResultSetType=Array&ClassName=PHA.HERB.Com.Store&QueryName=ExeProStore&gLocId=' + session['LOGON.CTLOCID'] + '&HospId=' + session['LOGON.HOSPID'] + '&admType=I',
		width: combWidth ,
		panelHeight: 'auto',
		editable: true,
		onLoadSuccess: function (data) {
			//$('#prescStatus').combobox('setValue', '0');
		}
	});
	// ��ҩ�ܾ�
	PHA.ComboBox('refuseFlag', {
		placeholder: '��ѡ��ܾ�...',
		width: combWidth ,
        data: [
            { RowId: 'Y', Description: $g('��') },
            { RowId: 'N', Description: $g('��') }
        ],
        panelHeight: 'auto',
		editable: false,
        onSelect: function () {}
    });
	// ��ҩ��ʽ
	PHA.ComboBox('cookType', {
		placeholder: '��ѡ���ҩ��ʽ...',
        url: PHA_HERB_STORE.CookType('', curLocId).url,
        width: combWidth ,
        panelHeight: 'auto'
    });
    
	// ����Ĭ��
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
}

// ��ʼ�������
function InitGridPresc() {
	var columns = [[{
				field: "phbdId",
				title: 'phbdId',
				width: 80,
				hidden: true
			}, {
				field: 'phac',
				title: 'phac',
				width: 80,
				hidden: true
			}, {
				field: "prescNo",
				title: '������',
				width: 120,
				formatter: function (value, rowData, rowIndex) {
					return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=OpenStepWin(" + rowIndex + ") >" + value + "</a>";
				}
			}, {
				field: 'prescType',
				title: '��ҩ����',
				width: 80,
				align: 'center'
			}, {
				field: 'patName',
				title: '��������',
				width: 100,
				align: 'center'
			}, {
				field: 'patNo',
				title: '�ǼǺ�',
				width: 120
			}, {
				field: 'wardLocDesc',
				title: '����',
				width: 180
			}, {
				field: 'bedNo',
				title: '����',
				width: 80,
				align: 'center'
			}, {
				field: 'phLocDesc',
				title: '��ҩ����',
				width: 120,
				align: 'center'
			}, {
				field: 'admLocDesc',
				title: '�������',
				width: 120,
				align: 'center'
			}, {
				field: 'comUserName',
				title: '��ͨҩ��ҩ��',
				width: 100
			}, {
				field: 'valUserName',
				title: '����ҩ��ҩ��',
				width: 100
			}, {
				field: 'priFlag',
				title: '�Ƿ�Ӽ�',
				width: 70,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'cyPrescType',
				title: '��������',
				width: 70,
				align: 'center'
			}, {
				field: 'piiDT',
				title: '��ҽ��ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'printDT',
				title: '��ҩ���ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'printFlag',
				title: '��ҩ��ɱ�־',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'priceFlag',
				title: '����ҩ',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'outFlag',
				title: '��Ժ��ҩ',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'cancelFlag',
				title: '�������',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'status',
				title: '����״̬',
				width: 80,
				align: 'center'
			}, {
				field: 'startPy',
				title: '��ʼ��ҩ',
				width: 80,
				hidden: true ,
				align: 'center'
			}, {
				field: 'emergencyFlag',
				title: '���ȱ�־',
				width: 70,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'allowRetFlag',
				title: '������ҩ��־',
				width: 110,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'refuseFlag',
				title: '�ܾ���־',
				width: 70,
				align: 'center',
				formatter: YesNoFormatter
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescIP.Query',
			QueryName: 'Interim',
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridPrescBar',
		onSelect: function (rowIndex, rowData) {
			QueryPrescDetail();
		},
		onClickCell: function (index, field, value) {},
		onLoadSuccess: function (data) {
			$('#gridPrescDetail').datagrid('clear');
			if (data.total > 0) {
				var selRowIdx = $(this).datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$(this).datagrid("selectRow", selRowIdx);
				} else {
					$(this).datagrid("selectRow", 0);
				}
			}
		}
	};
	PHA.Grid("gridPresc", dataGridOption);
}

// ��ϸ���
function InitGridPrescDetail() {
	var columns = [[{
				field: 'piii',
				title: 'piii',
				width: 80,
				hidden: true
			}, {
				field: 'inci',
				title: 'inci',
				width: 80,
				hidden: true
			}, {
				field: 'dspId',
				title: 'dspId',
				width: 80,
				hidden: true
			}, {
				field: 'oeori',
				title: 'oeori',
				width: 80,
				hidden: true
			}, {
				field: 'oeStatusDesc',
				title: 'ҽ��״̬',
				width: 100,
				align: 'center',
				styler: function(value, rowData, rowIndex) {
					if (rowData.oeStatusCode != "V" && rowData.oeStatusCode != "E") {
						return 'background-color:#FF5252; color:white;';
					}
				}
			}, {
				field: 'inciCode',
				title: 'ҩƷ����',
				width: 120
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 200
			}, {
				field: 'geneDesc',
				title: 'ͨ����',
				width: 160
			}, {
				field: 'goodName',
				title: '��Ʒ��',
				width: 160,
				hidden: true
			}, {
				field: 'inciSpec',
				title: '���',
				width: 100,
				align: 'center'
			}, {
				field: 'dspQty',
				title: '����',
				width: 80,
				align: 'right'
			}, {
				field: 'dspUomDesc',
				title: '��λ',
				width: 80
			}, {
				field: 'pyFlag',
				title: '��ҩ���',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'freqDesc',
				title: 'Ƶ��',
				width: 150
			}, {
				field: 'instDesc',
				title: '�÷�',
				width: 100
			}, {
				field: 'duratDesc',
				title: '�Ƴ�',
				width: 100
			}, {
				field: 'ordRemark',
				title: '�÷���ע',
				width: 150
			}, {
				field: 'feeType',
				title: '�ѱ�',
				width: 150
			}, {
				field: 'oeDate',
				title: 'ҽ������',
				width: 120,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescIP.Query',
			QueryName: 'InterimItm',
		},
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: false,
		onLoadSuccess: function (data) {}
	};
	PHA.Grid("gridPrescDetail", dataGridOption);
}

// ��ѯ
function QueryPresc() {
	// ��ѯ����
	var formDataArr = PHA.DomData("#gridPrescBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// ״̬���
	var statusCode = formData.prescStatus;
	var statusCodeArr = statusCode.split('-');
	var status = statusCodeArr[0]; 		// ״̬
	formData.status = status;
	var pJsonStr = JSON.stringify(formData);
	
	$('#gridPresc').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// ��ѯ��ϸ
function QueryPrescDetail() {
	var selRow = $('#gridPresc').datagrid('getSelected');
	var phbdId = selRow.phbdId;
	var pJsonStr = JSON.stringify({phbdId: phbdId});
	
	$('#gridPrescDetail').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// ����
function Clear() {
	PHA.DomData("#gridPrescBar", {doType: 'clear'});
	$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	$('#prescStatus').combobox('setValue', '');
	$('#phLoc').combobox('setValue', gLocId);
	$('#gridPresc').datagrid('clear');
	$('#gridPrescDetail').datagrid('clear');
}

// ��ӡ��ҩ��
function Print() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var status = selRow.status || "";
	if (status == "δ��ҩ") {
		$.messager.alert("��ʾ", "�ô�����δ��ҩ�����ܴ�ӡ��ҩ��", "warning");
		return;
	}
	PHA_MOB_PRINT.PrintPyd(prescNo);
}

// ��������ǩ
function PrinDJLabel() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var cookMode = selRow.prescType || "";
	if (cookMode !== "����") {
		$.messager.alert("��ʾ", "�ô�����ҩ���Ͳ��Ǵ��壬����Ҫ��ӡ�����ǩ", "warning");
		return;
	}
	
	// ����
	var winId = "presc_win_printNum";
	var winContentId = "presc_win_printNum" + "_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 250,
			height: 140,
			modal: true,
			title: "����������ǩ����",
			iconCls: 'icon-w-print',
			content: "<div style='padding:10px;'><input id='prntDJNum' class='hisui-numberbox' style='width:222px;'/></div>",
			closable: true,
			buttons:[{
				text:'ȷ��',
				handler:function(){
					var prescNo = GetSelectedPrescNo();
					var printNum = $('#prntDJNum').val() || "";
					if (printNum == "" || printNum <= 0 || isNaN(parseInt(printNum))) {
						$.messager.popover({
							msg: "������һ��������!",
							type: "alert",
							timeout: 1000,
							style: {top: 20, left: ""}
						});
					}
					else {
						PHA_MOB_PRINT.PrintDJLabel(prescNo, printNum);
					}
					$('#' + winId).dialog('close');
				}
			},{
				text:'ȡ��',
				handler:function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	
	// ȡĬ�ϵ�����
	var printNum = tkMakeServerCall('PHA.MOB.COM.Print', 'GetDefaultDJNum', prescNo);
	printNum = printNum <= 0 ? 1 : printNum;
	$('#prntDJNum').numberbox('setValue', printNum);
	$('#prntDJNum').focus();
}

// ����ҩ��ǩ
function PrintHPLabel() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var priceFlag = selRow.priceFlag || "";
	if (priceFlag !== "Y") {
		$.messager.alert("��ʾ", "�ô��������й���ҩ������Ҫ��ӡ����ҩ��ǩ", "warning");
		return;
	}
	PHA_MOB_PRINT.PrintPriceLabel(prescNo);
}

// ����Ϊ����
function Emergency() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var emergencyFlag = selRow.emergencyFlag || "";
	if (emergencyFlag == "Y") {
		$.messager.alert("��ʾ", "�ô����Ѿ�������״̬������Ҫ�ٴ����ã�", "warning");
		return;
	}
	var pJsonStr = JSON.stringify({prescNo: prescNo});
	
	var retStr = tkMakeServerCall("PHA.MOB.PrescIP.Save", "PrescEmergency", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "���óɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

// ������ҩ
function AllowRet() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var phbdId = selRow.phbdId || '' ;
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Save", "ChkAgreeReturnState", phbdId)
	if (chkRet != 0){
		var errMsg = chkRet.split("^")[1];
		$.messager.alert('��ʾ', errMsg , "info");
		return;
	}

	var htmlStr = '<div class="input-group">'
		htmlStr += 		'<div class="pha-col">' 
		htmlStr +=			'<textarea id="agrretremark" style="width:220px;"> </textarea>'
        htmlStr += 		'</div>'
	    htmlStr += '</div>';
	$.messager.confirm("����ԭ��ע",htmlStr,function(result){
		if(!result) {return};
		var agrRetRemark = $.trim($("#agrretremark").val()) ;
		var agrRetUserId = gUserID ;	// ��ǰ��¼��
		var pJsonStr = JSON.stringify({prescNo: prescNo,agrRetUserId:agrRetUserId,agrRetRemark:agrRetRemark});
		
		var retStr = tkMakeServerCall("PHA.MOB.PrescIP.Save", "PrescAllowRet", pJsonStr);
		var retArr = retStr.split("^");
		if (retArr[0] < 0) {
			$.messager.alert("��ʾ", retArr[1], "warning");
			return;
		}
		$.messager.popover({
			msg: "���óɹ�!",
			type: "success",
			timeout: 1000
		});
		QueryPresc();
		
	});
    
	
}

// �ֻ��Ͼܾ���ҩ�ĳ����ܾ�
function CancelRefuse() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var refuseFlag = selRow.refuseFlag || "";
	if (refuseFlag !== "Y") {
		$.messager.alert("��ʾ", "�ô���δ�ܾ���ҩ�����ܳ����ܾ�", "warning");
		return;
	}
	var pJsonStr = JSON.stringify({prescNo: prescNo});

	var retStr = tkMakeServerCall("PHA.MOB.PrescIP.Save", "CancelRefuse", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "�����ɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

function GetSelectedPrescNo(){
	var selRow = $('#gridPresc').datagrid('getSelected');
	if (selRow == null) {
		$.messager.popover({
			msg: "��ѡ�񴦷�!",
			type: "alert",
			timeout: 1000
		});
		return "";
	}
	var prescNo = selRow.prescNo || "";
	if (prescNo == "") {
		$.messager.popover({
			msg: "��ѡ�񴦷�!",
			type: "alert",
			timeout: 1000
		});
		return "";
	}
	return prescNo;
}

// ����׷�ٵ���
function OpenStepWin(rowIndex){
	var rowsData = $('#gridPresc').datagrid('getRows');
	if (rowsData == null) {
		$.messager.popover({
			msg: "�����б�û������!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var rowData = rowsData[rowIndex];
	var prescNo = rowData.prescNo || "";
	var pii = rowData.pii || "";
	/*
	if (pii == "") {
		$.messager.popover({
			msg: "����ѡ�񴦷�!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	*/
	
	// ����
	var winWidth = parseInt($(document.body).width() * 0.97);
	var winId = "presc_win_step";
	var winContentId = "presc_win_step" + "_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
	    	height: 160,
	    	modal: true,
	    	title: "��������״̬׷��",
	    	iconCls: 'icon-w-find',
	    	content: "<div id='" + winContentId + "' style='height:90px;margin:10px;'></div>",
	    	closable: true,
	    	onClose: function() {}
		});
	}
	
	// ����
	$("#" + winContentId).children().remove();
	//var stepJsonStr = tkMakeServerCall('PHA.MOB.PrescIP.Query', 'GetStepWinInfo', pii);
	var stepJsonStr = tkMakeServerCall('PHA.MOB.PrescIP.Query', 'GetStepWinInfo', prescNo);
	var stepJsonData = eval('(' + stepJsonStr + ')');
	var steps = stepJsonData.items.length;
	var stepWidth = (winWidth - 40) / steps;
	$("#" + winContentId).hstep({
		titlePostion: 'top',
		showNumber: false,
		stepWidth: stepWidth,
		currentInd: stepJsonData.currentInd,
		items: stepJsonData.items,
		onSelect: function(ind, item){}
	});
	
	// �򿪴���
	$('#' + winId).dialog('open');
	$('#' + winId).dialog('setTitle', "����״̬׷�� - " + prescNo);
}

function YesNoFormatter(value, row, index){
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// ��������
function InitConfig() {
	$.cm({
		ClassName: "PHA.MOB.COM.PC",
		MethodName: "GetConfig",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
