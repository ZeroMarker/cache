/**
 * @ģ��:     �����ҩ������ҩ
 * @��д����: 2020-11-06
 * @��д��:   MaYuqiang
 */
DHCPHA_CONSTANT.DEFAULT.APPTYPE="HERBOR";
DHCPHA_CONSTANT.DEFAULT.DISPWINDOW="";
DHCPHA_CONSTANT.DEFAULT.PYUSER="";
PHA_COM.Val.CAModelCode = "PHAHERBOPFY"; 
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var ProDictCode = "Dispen";
var PYDictCode = "CompleteDisp"
var AppPropData;	// ģ������
var ComPropData;	// ��������
var SELCOOKTYPE;
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_opdisp', $('#pha_herb_v2_opdisp').panel('options').title);
	InitGridOutPrescList();
	InitGridWaitList();
	InitSetDefVal();
	InitEvent();            //  ��ť�¼�
	ResizePanel();          //  ���ֵ���
});

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)
	
	$("#dateColStart").datebox("setValue", ComPropData.OPDispStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.OPDispEndDate);
	$('#timeColStart').timespinner('setValue', "00:00:00");
	$('#timeColEnd').timespinner('setValue', "23:59:59");
	
	/* ��ʼ����ҩ���� */ 
	if (ComPropData.DispByWindow == "Y"){
		InitDispWinDialog({callback: RetWinInfo});		
	}
	else {
		$('#currentWin').parent().css('visibility','hidden');
		$('#currentWinLable').parent().css('visibility','hidden');
		$("#btn-ChangeWindow").attr({
            "style": "display:none"
        });
	}

	/* ��ʼ����ҩ��ѡ�� */ 
	if (ComPropData.SelectPYUser == "Y"){
		InitPYUserDialog({callback: RetPYUserInfo});	// ��ҩҩʦ
	}
	else{
		$('#pyUserName').parent().css('visibility','hidden');
		$('#pyUserNameLable').parent().css('visibility','hidden');
		$("#btn-ChangePYUser").attr({
            "style": "display:none"
        });
	}
	if (ComPropData.AddCookFeeFlag == "N"){
		$("#btnAddCookFee").attr({
            "style": "display:none"
        });
	}
	PrescView("");
	Setfocus();
}

/* ��ť�¼� */
function InitEvent(){
	$('#btnDisp').on('click', ClickDispBtn);
	$('#btnReturn').on('click', LinkReturn);
	$('#btnDispAll').on('click', ClickDispAllBtn);
	$('#btnDispRefuse').on('click', ExecuteRefuseDisp);
	$('#btnCancelRefuse').on('click', CancelRefuse);
	$('#btnApplyCook').on('click', ApplyCook);
	$('#btnChangeCook').on('click', ChangeCookType);
	$('#btnSaveAgreeRet').on('click', SaveAgreeRet);
	$('#btnAddCookFee').on('click', AddCookFee);
    $('#btnOK').on('click', function () {
       SaveCookFee();
    });
    $('#btnCancel').on('click', function () {
        $('#gridCookFee').window('close');
    });
	$("#btn-ChangeWindow").on("click", function () {
		ShowWindowInfo() ;
	});
	$("#btn-ChangePYUser").on("click", function () {
		ShowPYUserInfo() ;
	});
	$("#btnFresh").on("click", function () {
		QueryWaitList() ;
	});
	$("#txtCardNo").imedisabled();

	//�ǼǺŻس��¼�
	$('#txtBarCode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txtBarCode").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryOutPrescList();
			}	
		}
	});
	
	// ���Żس��¼�
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	$('#readCard').on('click', BtnReadCardHandler) ;
	
	//�������лس��¼�
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
}

// ���ֵ���
function ResizePanel(){
    setTimeout(function () {    
        var flag = 0.4;
        if(PHA_COM.Window.Width()<1500 ){flag = 0.5}         
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb��grid',
            region: 'west',
            width: flag
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb��grid-list',
            region: 'south',
            height: 0.5 
        });
    }, 0);
}

/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridOutPrescList() {
	var columns = [
		[	/*{
				field:'pdCheck',	
				checkbox: true 
			},*/
			{
				field: 'TDspStatus',
				title: '��ҩ״̬',
				align: 'left',
				showTip: true,
				tipWidth: 100,
				width: 90,
				styler: function(value, rowData, rowIndex) {
					if (rowData.TDspStatus == $g("�ܾ���ҩ")) {
						return 'background-color:#ee4f38; color:white;';
					}
					else if(rowData.TDspStatus == $g("����")) {
						return 'background-color:#f1c516; color:white;';
					}
				}
			},{
				field: 'TPrescPro',
				title: '��ǰ����',
				align: 'left',
				hidden: true,
				showTip: true,
				width: 90
			}, {
				field: 'TEmergFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 70
			}, {
				field: 'TPatName',
				title: '����',
				align: 'left',
				width: 70
			}, {
				field: 'TPmiNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 100,
				formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.TAdm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
			}, {
				field: 'TPrescNo',
				title: '������',
				align: 'left',
				showTip: true,
				width: 130
			}, {
				field: 'TFyFlag',
				title: '��ҩ��־',
				align: 'left',
				width: 30,
				hidden: true
			}, {
				field: 'TPrescType',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TFactor',
				title: '����',
				align: 'left',
				width: 50
			}, {
				field: 'TPrescTakeMode',
				title: 'ȡҩ��ʽ',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				align: 'left',
				width: 80
			}, {
				field: 'TCookCost',
				title: '��ҩ��/����״̬',
				align: 'left',
				showTip: true,
				width: 180
			}, {
				field: 'TBillType',
				title: '�ѱ�',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TMBDiagnos',
				title: '�������',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TDiag',
				title: '���',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TAdmLoc',
				title: '����/����',
				align: 'left',
				showTip: true,
				width: 120
			}, {
				field: 'TPatSex',
				title: '�Ա�',
				align: 'left',
				width: 50
			}, {
				field: 'TPatAge',
				title: '����',
				align: 'left',
				width: 50
			}, {
				field: 'TRefResult',
				title: '�ܾ�����',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TDocNote',
				title: '��������',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TAgreeRetFlag',
				title: '�Ƿ����',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
                    var qOpts = "{phbdId:'" + row.TPhbdId + "'}";
                    return '<a class="pha-grid-a" onclick="PHAHERB_COM.AgreeRetReason({},' + qOpts + ')">' + value + '</a>';
					
                }
			}, {
				field: 'TAdm',
				title: 'TAdm',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TPapmi',
				title: 'TPapmi',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TOeori',
				title: 'TOeori',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TEncryptLevel',
				title: '�����ܼ�',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPatLevel',
				title: '���˼���',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPhbdId',
				title: 'TPhbdId',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPrescTypeCode',
				title: '�������ʹ���',
				align: 'left',
				width: 80,
				hidden: true
			}, {
				field: 'TCookTypeId',
				title: '��ҩ��ʽId',
				align: 'left',
				width: 80,
				hidden: true
			}, {
				field: 'TPrescFormula',
				title: 'Э����',
				align: 'left',
				showTip: true,
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap: true ,
		exportXls: false,
		pagination: true,
		pageSize:100,
		pageList:[100,300,500,999],
		singleSelect: true,
		toolbar: "#gridOutPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Dispen.Query",
			QueryName: "GetOutPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			PHAHERB_COM.Default.selCookTypeDesc = rowData.TCookType;
			PrescView(prescNo);
		},
		onLoadSuccess: function () {
			var rows = $("#gridOutPrescList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridOutPrescList').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridOutPrescList").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.TPrescNo;
				PHAHERB_COM.Default.selCookTypeDesc = gridSelect.TCookType;
				PrescView(prescNo);
			}
		}
	};
	PHA.Grid("gridOutPrescList", dataGridOption);
}



/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridWaitList() {
	var columns = [
		[	
			{
				field: 'TPapmi',
				title: '������',
				align: 'left',
				hidden: true,
				width: 90
			}, { 
				field: 'TSendVoice',		
				title: $g('�к�'),			
				width: 120,		
				align: 'left',
            	styler:function(value, row, index) {
					return PHAHERB_COM.WaitStatusStyler(value, row, index);
				},
            	formatter:function(value, row, index) {
					return PHAHERB_COM.WaitStatusFormatter(value, row, index);
				}
	        }, {
				field: 'TPatNo',
				title: '�ǼǺ�',
				align: 'left',
				width: 200
			}, {
				field: 'TPatName',
				title: '����',
				align: 'left',
				width: 220
			}, {
				field: 'TCallFlag',
				title: 'callFlag',
				align: 'left',
				width: 120,
				hidden: true
			}, {
				field: 'TPhwQuId',
				title: '�к�id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TQueNo',
				title: '�ŶӺ�',
				align: 'left',
				width: 100
			}
			
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:true ,
		pagination: false,	//true
		exportXls: false,
		//pageSize:100,
		//pageList:[100,300,500,999],
		singleSelect: true,
		toolbar: "#gridWaitListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Dispen.Query",
			QueryName: "GetWaitList",
		},
		onClickRow: function (rowIndex, rowData, className) {
			var patNo = rowData.TPatNo;
			$('#txtBarCode').val(patNo);
			QueryOutPrescList();
		},
		onLoadSuccess: function () {
			/*
			var rows = $("#gridWaitList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridWaitList').datagrid('selectRow', 0);
			}
			*/
		}
	};
	PHA.Grid("gridWaitList", dataGridOption);
	/*  */
	var eventClassArr = [];
		eventClassArr.push('pha-grid-a icon icon-ring-blue');
		eventClassArr.push('pha-grid-a icon icon-skip-no');
	PHA.GridEvent("gridWaitList", 'click', eventClassArr, function(rowIndex, rowData, className){
		var opType = "";
		if (className === 'pha-grid-a icon icon-ring-blue') {
			var patNo = rowData.TPatNo;
			var phwQuId = rowData.TPhwQuId;
			if (phwQuId != "") {
				var state = "Call";
				var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
			}
			QueryWaitList();
		}
		if (className === 'pha-grid-a icon icon-skip-no') {
			var patNo = rowData.TPatNo;
			var phwQuId = rowData.TPhwQuId;
			if (phwQuId == "") {
				$.messager.alert('��ʾ',"û�б����Ŷ�,�������!","info");
				return;
			}
			var state = "Skip";
			var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
			QueryWaitList();
		}
	})

	
	
}

/**
 * ����Ԥ��
 * @method PrescView
 */
function PrescView(prescNo){
	if (prescNo == ""){
		$("#ifrm-PreViewPresc").attr("src", "");
		return;
	}

	var phbdType = "OP";
	if(prescNo.indexOf("I")>-1){
		phbdType = "IP";
	}
	var cyFlag = "Y";
	var zfFlag = "�׷�"
	var dispFlag = "OK"
	if (dispFlag !== "OK"){
        var useFlag = "3"       // δ��ҩ
    }
    else {
        var useFlag = "4"       // �ѷ�ҩ
    }

	PHA_HERB.PREVIEW({
        prescNo: prescNo,           
        preAdmType: phbdType,
        zfFlag: zfFlag,
        prtType: 'DISPPREVIEW',
        useFlag: useFlag,
        iframeID: 'ifrm-PreViewPresc',
        cyFlag: cyFlag
    });
}

/**
 * ��ѯ����
 * @method QueryOutPrescList
 */
function QueryOutPrescList() {
	$('#gridOutPrescList').datagrid('uncheckAll');
	$('#gridOutPrescList').datagrid('clear');
	PrescView("") ;
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridOutPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		LogonInfo: LogonInfo
	});
	$('#txtBarCode').val('');	
	Setfocus();
}

/**
 * ��ѯ����ҩ����
 * @method QueryWaitList
 */
function QueryWaitList() {
	$('#gridOutPrescList').datagrid('uncheckAll');
	$('#gridOutPrescList').datagrid('clear');
	PrescView("");
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridWaitList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		LogonInfo: LogonInfo
	});	 
	Setfocus();
}


/**
 * ��ѯ������JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var patNo = $('#txtBarCode').val() ;
    return {
        startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        loc: gLocId,
        patNo: $('#txtBarCode').val(),
        dispFlag: ($('#chk-disp').checkbox('getValue')==true?'Y':'N'),
		dispWinId: DHCPHA_CONSTANT.DEFAULT.DISPWINDOW     
    };
}

/* �����ҩ��ť */
function ClickDispBtn(){
	PHA_COM.CACert("PHAHERBOPFY", ShowHerbDeliveryDiag);	
}

/*
 * ��ݴ��ڴ�
 * @method ShowHerbDeliveryDiag
 */
function ShowHerbDeliveryDiag(){
	if ((ComPropData.SelectPYUser == "Y")&&(DHCPHA_CONSTANT.DEFAULT.PYUSER == "")){
		$.messager.alert('��ʾ',"����ѡ����ҩҩʦ�ٽ��з�ҩ!","info");
		return;
	}
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ҩ�Ĵ���!","info");
		return;
	}	
	var dspStatus = gridSelect.TDspStatus;
	if (dspStatus==$g("�ܾ���ҩ")){
		$.messager.alert('��ʾ',"�ô����Ѿܾ���ҩ����ȡ���ܾ�������","info");
		return;
	}
	var fyFlag = gridSelect.TFyFlag;
	if (fyFlag=="Y"){
		$.messager.alert('��ʾ',"�ô����ѷ�ҩ�������ٴη�ҩ!","info");
		return;
	}

	var phbdId = gridSelect.TPhbdId ;
	var prescNo = gridSelect.TPrescNo ;
	var prescForm = gridSelect.TPrescTypeCode ;
	var papmi = gridSelect.TPapmi;
	// �����Ƿ���Է�ҩ
	var stateId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", ProDictCode)
	var params = phbdId + tmpSplit + stateId + tmpSplit + gUserID ;
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Biz", "CheckBeforeExe", params, LogonInfo)
	if (chkRet != 0){
		$.messager.alert('��ʾ', chkRet, "info");
		return;
	}

	var deliveryFlag = ComPropData.DeliveryFlag ;
	if (deliveryFlag == "Y"){
		ShowDeliveryDiag({
			prescNo : prescNo,
			prescForm : prescForm,
			papmi : papmi
		},GetDeliveryRet);
	}
	else{
		ExecuteDisp();
	}
}


function GetDeliveryRet(retVal){
	if (retVal == 1){
		ExecuteDisp() ;
	}
	return ;
}

/*
 * ��ҩ������ҩ���
 * @method ExecuteDisp
 */
function ExecuteDisp(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ���ŵĴ���!","info");
		return;
	}	
	var phbdId = gridSelect.TPhbdId ;
	if (ComPropData.SelectPYUser == "Y"){
		var pyStateId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", PYDictCode)
		var params = phbdId + tmpSplit + pyStateId + tmpSplit + DHCPHA_CONSTANT.DEFAULT.PYUSER ;
		$.m({
			ClassName: "PHA.HERB.Dispen.Save",
			MethodName: "UpdatePrescState",
			param: params,
			logonInfo: LogonInfo
		}, function (retData) {
			var retArr = retData.split("^")
			if (retArr[0] < 0) {
				$.messager.alert('��ʾ', retArr[1], 'warning');
				return;
			}
			else{
				DoExecuteDisp(phbdId);
			}
		});
	}
	else {
		DoExecuteDisp(phbdId);
	}
	PrescView("");
	QueryOutPrescList();
}

/*
 * ִ�в�ҩ������ҩ
 * @method DoExecuteDisp
 */
function DoExecuteDisp(phbdId){
	var stateId = tkMakeServerCall("PHA.HERB.Com.Method","GetDictId",ProDictCode)
	var params = phbdId + tmpSplit + stateId + tmpSplit + gUserID ;
	var retData = $.m({
		ClassName: "PHA.HERB.Dispen.Save",
		MethodName: "UpdatePrescState",
		param: params,
		logonInfo: LogonInfo
	}, false)
	var retArr = retData.split("^")
	if (retArr[0] < 0) {
		$.messager.alert('��ʾ', retArr[1], 'warning');
		return;
	}
	else{
		PHA_COM.SaveCACert({
			signVal: phbdId,
			type: "FH"
		})
		var printList = ComPropData.DispPrintList;
		var printListData = printList.split(",")
		for (var i = 0; i < printListData.length; i++){
			var printType = printListData[i];
			if (printType == 1){
				var prescNo = tkMakeServerCall("PHA.HERB.Com.Data", "GetPrescNoByPHBD", phbdId)
				HERB_PRINTCOM.Presc(prescNo,"");
			}
			else if (printType == 2) {
				HERB_PRINTCOM.PYD(phbdId,"");
			}
		}
		return;
	}
}

/*
 * ��ҩ������ҩ(���ӳ���ҩ����)
 * @method ExecuteReturn
 */
function LinkReturn(){
	
	$.ajax({
        type: "GET",
        cache: false,
        url: "pha.herb.v2.returnbyreq.csp",
        data: "",
        success: function() {
	        var lnk="pha.herb.v2.returnbyreq.csp";
            window.open(lnk,"_target","width="+(window.screen.availWidth-50)+",height="+(window.screen.availHeight-100)+ ",left=0,top=0,menubar=no,status=yes,toolbar=no,resizable=yes") ;
			return ;
        },
        error: function() {
            return ;
        }
    });
	
}

/* ���ȫ����ť */
function ClickDispAllBtn(){
	var deliveryFlag = ComPropData.DeliveryFlag ;
	if (deliveryFlag == "Y"){
		$.messager.alert('��ʾ',"�ѿ����������ҵ�񣬲���ʹ��ȫ������","info");
		return;
	}
	var prescRows = $("#gridOutPrescList").datagrid("getRows");
	if (prescRows.length == 0){
		$.messager.alert('��ʾ',"���Ȳ�ѯ����Ҫȫ���Ĵ���!","info");
		return;
	}
	PHA_COM.CACert("PHAHERBOPAllFY", ExecuteDispAll);	
}

/*
 * ��ҩ����ȫ��
 * @method ExecuteDispAll
 */
function ExecuteDispAll(){
	var prescRows = $("#gridOutPrescList").datagrid("getRows");
	var stateId = tkMakeServerCall("PHA.HERB.Com.Method","GetDictId",ProDictCode)
	for (var i = 0; i < prescRows.length; i++) {
		var phbdId = prescRows[i].TPhbdId;
		if (ComPropData.SelectPYUser == "Y"){
			var pyStateId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", PYDictCode)
			var params = phbdId + tmpSplit + pyStateId + tmpSplit + DHCPHA_CONSTANT.DEFAULT.PYUSER ;
			$.m({
				ClassName: "PHA.HERB.Dispen.Save",
				MethodName: "UpdatePrescState",
				param: params,
				logonInfo: LogonInfo
			}, function (retData) {
				var retArr = retData.split("^")
				if (retArr[0] < 0) {
					$.messager.alert('��ʾ', retArr[1], 'warning');
					return;
				}
				else{
					DoExecuteDisp(phbdId);
				}
			});
		}
		else {
			DoExecuteDisp(phbdId);
		}
	}
	
	PrescView("");
	QueryOutPrescList();
}

/*
 * ��ҩ�����ܷ�ҩ
 * @method RefuseDisp
 */
function ExecuteRefuseDisp(){
	
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�ܾ���ҩ�Ĵ���!","info");
		return;
	}
	var fyFlag = gridSelect.TFyFlag ;		//��ҩ��־
	var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬

	if (fyFlag == "Y"){
		var tipMsg = $g("�ô���״̬Ϊ��") + dspStatus + $g("���ܾܾ���ҩ")
		$.messager.alert('��ʾ', tipMsg, "info");
		return;
	}

	if ((dspStatus.indexOf("�ܾ���ҩ") > -1)&&(dspStatus.indexOf("����") < 0)){
		var tipMsg = $g("�ô���״̬Ϊ��") + dspStatus + "�������ٴξܾ���ҩ"
		$.messager.alert('��ʾ',tipMsg,"info");
		return;
	}
	var orditm = gridSelect.TOeori;
	var prescNo = gridSelect.TPrescNo;
    ShowPHAPRASelReason({
		wayId: RefuseWay,
		oeori:"",
		prescNo:prescNo,
		selType:"PRESCNO"
	},SaveResultEX,{orditm:orditm}); 
	
}

function SaveResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	var phbdId = gridSelect.TPhbdId ;
	var retarr = reasonStr.split("@");
	var ret = "N";
	var reasondr = retarr[0];
	var phnote = retarr[3];
	var input = ret + tmpSplit + gUserID + tmpSplit + phnote + tmpSplit + DHCPHA_CONSTANT.DEFAULT.APPTYPE + tmpSplit + phbdId;
	SaveRefuse(reasondr, input)
}

function SaveRefuse(reasonStr, params)
{
	$.m({
		ClassName: "PHA.HERB.Audit.Save",
		MethodName: "SaveHerbAuditResult",
		reasonStr: reasonStr,
		params: params ,
		LogonInfo: LogonInfo
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		QueryOutPrescList();
	});

}

/*
 * ������ҩ�����ܷ�ҩ
 * @method CancelRefuse
 */
function CancelRefuse(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�����ܾ���ҩ�Ĵ���!","info");
		return;
	}
	var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬
	if (dspStatus.indexOf("�ܾ���ҩ")<0){
		$.messager.alert('��ʾ',"�ô���δ�ܾ���ҩ�����ܳ����ܾ���ҩ!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo ;
	var type = DHCPHA_CONSTANT.DEFAULT.APPTYPE ;
	var params = gUserID + tmpSplit + prescNo + tmpSplit + type ;
	$.m({
		ClassName: "PHA.HERB.Dispen.Save",
		MethodName: "CancelHerbRefDisp",
		params: params ,
		hospId: gHospID
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		QueryOutPrescList();
	});
	
}

/*
 * ��ҩ���������ҩ��
 * @method ApplyCook
 */
function ApplyCook(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ҩ����Ĵ���!","info");
		return;
	}
	var CookType=gridSelect.TCookType;
	if (CookType == "") {
		$.messager.alert('��ʾ',"��ҩ��ʽΪ�ղ�����ת����ҩ��ʽ��","info");
		return;
	};
	ShowChangeCookType("ApplyCookTypeWin", DoApplyCookType);
}

/*
 * ִ�м�ҩ���� 
 * @method DoApplyCookType
 */
function DoApplyCookType(ChangeCookJson){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	var prescNo = gridSelect.TPrescNo ;
	var cookTypeId = ChangeCookJson.cookTypeId ;
	SELCOOKTYPE = cookTypeId;
	var params = prescNo + tmpSplit + "" + tmpSplit + cookTypeId
	//debugger ;
	var ReqCookStr = tkMakeServerCall("PHA.HERB.Com.Method","IsInsertCookFee",params, LogonInfo);
	var ReqCookCode = ReqCookStr.split("^")[0];
	var ReqCookMessage = ReqCookStr.split("^")[1];
	if(ReqCookCode != 0){
		$.messager.alert('��ʾ', ReqCookMessage, "info");
		return;
	}
	$('#gridCookFee').window('open');
	var appendArcimArr = ReqCookMessage.split(",");
	var trHtml = "";
	for(var i = 0; i < appendArcimArr.length; i++){
		var arcimArr = appendArcimArr[i].split("&");
		var PresAppendItem = arcimArr[0];
		var PresAppendDesc = arcimArr[1];
		var PresAppendQty = arcimArr[2];
		var AricmIdHtml = '<td class="text-right" style="display: none;">'+ PresAppendItem +'</td>';
		var AricmDescHtml = '<td class="text-left" style="font-size:16px">'+ PresAppendDesc +"  /  "+PresAppendQty+'</td>';
		var tdHtml = '<tr>'+AricmIdHtml+AricmDescHtml+'</tr>'
		trHtml += tdHtml;
	}
	$('#gridCookFeeArcim').html(trHtml);

}

/*
 * ��ҩ����ת����ҩ��ʽ
 * @method ChangeCookType
 */
function ChangeCookType(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫת����ҩ��ʽ�Ĵ���!","info");
		return;
	}
	var CookType=gridSelect.TCookType;
	if (CookType == "") {
		$.messager.alert('��ʾ',"��ҩ��ʽΪ�ղ�����ת����ҩ��ʽ��","info");
		return;
	};
	ShowChangeCookType("ChangeCookTypeWin", DoExchange);

}

function DoExchange(ChangeCookJson){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('��ʾ',"����ѡ����Ҫת����ҩ��ʽ�Ĵ���!","info");
		return;
	}
	var index = $("#gridOutPrescList").datagrid("getRowIndex", gridSelect);
	var prescNo = gridSelect.TPrescNo;
	var phbdId = gridSelect.TPhbdId;
	var CookType = ChangeCookJson.cookTypeId ;
	var Ret = tkMakeServerCall("PHA.HERB.Dispen.Save","SavePrescCookType", prescNo, CookType, phbdId);
	var RetCode = Ret.split("^")[0];
	var RetMessage = Ret.split("^")[1];
	if(RetCode==0){
		$.messager.alert('��ʾ',"ת���ɹ���","info");
		$("#gridOutPrescList").datagrid('updateRow',{
		       index : parseInt(index),
		       row : {
		    	   TCookType: $('#sel-cook').combobox('getText')    //���µ�ֵ  
		       }
		   });
	}else{
		$.messager.alert('��ʾ',"ת��ʧ�ܣ�ԭ��"+RetMessage,"info");
		return;
	}
	
	PrescView(prescNo);
	return;
}

//��ʼ����ҩ����
function InitCookType(cookType){
	PHA.ComboBox("sel-cook", {
		url: PHA_HERB_STORE.CookType(encodeURI(cookType),gLocId).url ,
		onLoadSuccess: function(){
			var data= $("#sel-cook").combobox("getData");
			if (data.length > 0) {
				$('#sel-cook').combobox('setValue', data[0].RowId);
			}
		}
	});	

}

/// �����ҩ��
function SaveCookFee(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	var prescNo = gridSelect.TPrescNo;
	var admId = gridSelect.TAdm;
	var cookTypeDr = SELCOOKTYPE ;
	var InputData = admId +"^"+ prescNo +"^"+ gUserID+"^"+ gLocId +"^"+ cookTypeDr +"^"+ gGroupId;
	$('#gridCookFee').window('close');
	var RetStr=tkMakeServerCall("PHA.HERB.Dispen.Save","SaveCookFee",InputData);
	var RetCode=RetStr.split("^")[0];
	var RetMessage=RetStr.split("^")[1];
	if(RetCode!=0){
		var message=RetStr.split("^")[1];
		$.messager.alert('��ʾ',"����ʧ�ܣ�ԭ��"+ message,"info");
	}else{
		/*
		var newcookcost="��ҩ������";
		var newdata={
	    	TCookCost:newcookcost 
	    };
	    var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
		*/
	    //$("#grid-disp").jqGrid('setRowData',selectid,newdata);
		$.messager.alert('��ʾ',"��ҩ������ɹ������֮ǰ�Ѿ������˼�ҩ���뵽�շѴ��˷ѣ�Ȼ���ٽ����µļ�ҩ��","info");
	}
	SELCOOKTYPE = ""
	return;
}

/*
 * ��ҩ������¼��ҩ����
 * @method AddCookFee
 */
function AddCookFee(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��¼��ҩ���õĵĴ���!","info");
		return;
	}
	var CookTypeId = gridSelect.TCookTypeId;
	if(CookTypeId == "") {
		$.messager.alert('��ʾ',"��ҩ��ʽΪ�ղ��ܲ�¼��ҩ���ã�","info");
		return;
	};
	/* */
	var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬
	var fyFlag = gridSelect.TFyFlag;
	if (fyFlag=="Y"){
		$.messager.alert('��ʾ',"�ô����ѷ�ҩ�����ܲ�¼��ҩ��","info");
		return;
	}
	if (dspStatus==$g("�ܾ���ҩ")){
		$.messager.alert('��ʾ',"�ô����Ѿܾ���ҩ�����ܲ�¼��ҩ��!","info");
		return;
	}
	
	var prescNo = gridSelect.TPrescNo;

	ShowAddCookFeeDiag({
		prescNo : prescNo,
		cookType : CookTypeId
	},RetAddFeeInfo);

}

/// ��¼��ҩ�ѻص�����
/// params : ��Ҫ��¼�ļ�ҩ��ҽ����Ϣ
function RetAddFeeInfo(retVal){
	return ;
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridOutPrescList').datagrid('clear');
	$('#gridOutPrescList').datagrid('uncheckAll');
	$('#txtBarCode').val("");
	$('#chk-disp').checkbox("uncheck",true) ;
}

/*
 * ��Ϊ����
 * @method SaveAgreeRet
 */
function SaveAgreeRet(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��Ϊ���˵Ĵ���!","info");
		return;
	}
	// �ÿ���Ȩ���ж�
	if (ComPropData.IfAgreeReturn != "Y"){
		$.messager.alert('��ʾ',"��ǰ��¼��û���ÿ���Ȩ�ޣ����ʵ������","info");
		return;
	}
	var agreeRetFlag = gridSelect.TAgreeRetFlag ;		//�ÿ���״̬
	if (agreeRetFlag == $g("��")){
		$.messager.alert('��ʾ',"�ô������ǿ���״̬��������Ϊ����","info");
		return;
	}
	var phbdId = gridSelect.TPhbdId ;		//�ÿ���״̬
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Save", "ChkAgreeReturnState", phbdId)
	var chkRetArr = chkRet.split("^")
	if (chkRetArr[0] < 0) {
		$.messager.alert('��ʾ', chkRetArr[1], 'warning');
		return;
	}
	ShowAgreeRetWin("AgreeRetWin", ExeSaveAgreeRet);
}

/*
*	�����ÿ���ԭ��
*/
function ExeSaveAgreeRet(AgreeRetJson){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	var remark = AgreeRetJson.agreeRetRemark ;
	var agrRetUserId = gUserID ;	// ��ǰ��¼��
	var phbdId = gridSelect.TPhbdId ;
	var params = phbdId + tmpSplit + agrRetUserId + tmpSplit + remark ;
	$.m({
		ClassName: "PHA.HERB.Dispen.Save",
		MethodName: "SaveAgreeRet",
		params: params 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		else {
			$.messager.alert('��ʾ', "��Ϊ���˳ɹ�", 'success');
		}
		QueryOutPrescList();
		PrescView("") ;
	});
}

/*
/	���´򿪴��������Ϣ����
/*/
function ReShowDeliveryDiag(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴������Ϣ�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;		//��ҩ״̬
	var prescForm = gridSelect.TPrescTypeCode;
	var papmi = gridSelect.TPapmi;
	var patname = gridSelect.TPatName;
	var dspStatus = gridSelect.TDspStatus;
	var fyFlag = gridSelect.TFyFlag;

	var warnMsg = "��������:"+ patname +"</br>"+"������:"+ prescNo +"</br>"
	if (fyFlag !== "Y"){
		$.messager.alert('��ʾ', warnMsg + "�ü�¼δ��ҩ����ҩ�������鿴������Ϣ!", "info");
		return;
	}
	var postTypeStr = tkMakeServerCall("PHA.HERB.Com.Method","GetPostType",prescNo);
	var prescTakeModeDesc = postTypeStr.split("^")[2]
	/* ȡҩ��ʽΪ��ȡ����Ϳ�ʱ���ᵯ��������Ϣ�Ŀ� */
	if ((prescTakeModeDesc == "")||(prescTakeModeDesc == "��ȡ����")){
		if (prescTakeModeDesc == ""){
			var prescTakeModeDesc = "��"
		}
		$.messager.alert('��ʾ', warnMsg + "�ü�¼ȡҩ��ʽΪ ��"+ prescTakeModeDesc +"�� ��û��������Ϣ���Բ鿴!", "info");
		return;	
	}	
	
	var deliveryFlag = ComPropData.DeliveryFlag ;
	if (deliveryFlag == "Y") {
		ShowDeliveryDiag({
			prescNo : prescNo,
			prescForm : prescForm,
			papmi : papmi
		},GetReShowRet); 
	}
	else {
		$.messager.alert('��ʾ',"δ������ҩ������ݹ��ܣ������ڲ��������п������ú����ԣ�", "info");
		return;	
	}
}

function GetReShowRet(retVal){
	PrescView("");
	QueryOutPrescList();
	return ;	
}

function RetWinInfo(param){	
	var windowId = param.windowId;	
	var windowDesc = param.windowDesc;
	
	$("#currentWin").text(windowDesc);
	DHCPHA_CONSTANT.DEFAULT.DISPWINDOW = windowId;
	QueryWaitList();
}

function RetPYUserInfo(param){	
	var pyUserId = param.pyUserId;	
	var pyUserDesc = param.pyUserName;
	
	$("#pyUserName").text(pyUserDesc);
	DHCPHA_CONSTANT.DEFAULT.PYUSER = pyUserId;
}

/// ���Ĭ��
function Setfocus()
{
	$("#txtBarCode").val("");
	$("#txtCardNo").val("");
	if(ComPropData.FocusFlag==0){
		$('#txtCardNo').focus();
	}
	else{
		$('#txtBarCode').focus();
	}
}


//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, QueryOutPrescList) ; 
}

//��������
window.onload=function(){
	if (LoadPatNo != ""){
		var loadInfo = tkMakeServerCall("PHA.HERB.Com.Method", "GetLoadInfoByOeori", LoadOeori, LogonInfo)
		if(loadInfo != "{}"){
			$('#txtBarCode').val(LoadPatNo);
			var loadJson = JSON.parse(loadInfo)
			var phbdDate = loadJson.phbdDate;		
			$("#dateColStart").datebox("setValue", phbdDate);
			$("#dateColEnd").datebox("setValue", phbdDate);
			setTimeout("QueryOutPrescList()",500);
		}
	}
	else {
		if (ComPropData.DispByWindow == "Y"){
			ShowWindowInfo() ;
		}
		else {
			setTimeout("QueryWaitList()",500);
		}
	}
	
	
}
