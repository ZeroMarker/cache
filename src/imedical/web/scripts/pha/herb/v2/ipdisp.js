/**
 * @ģ��:     סԺ��ҩ������ҩ
 * @��д����: 2020-11-14
 * @��д��:   MaYuqiang
 */
DHCPHA_CONSTANT.DEFAULT.APPTYPE="HERBIR";
DHCPHA_CONSTANT.DEFAULT.PYUSER="";
PHA_COM.Val.CAModelCode = "PHAHERBIPFY"; 
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var ProDictCode = "Dispen"
var PYDictCode = "CompleteDisp"
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_ipdisp', $('#pha_herb_v2_ipdisp').panel('options').title);
	InitDict();
	InitSetDefVal();
	InitGridInPrescList();
	InitGridWardList();
	InitEvent();            //  ��ť�¼�
	ResizePanel();          //  ���ֵ���
	//$('#btnDisp').on('click', ExecuteDisp);
	
	$("#tabsForm").tabs({
        onSelect: function(title) {		    			
			var gridSelect = $("#gridInPrescList").datagrid("getSelected");
			if (gridSelect==null){
				$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĵ���!","info");
				return;
			}
			var prescNo = gridSelect.TPrescNo ;
			var EpisodeId = gridSelect.TAdm ;	
			var patId = gridSelect.TPapmi ;
			if (title=="�������"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?PatientID='+ patId + '&EpisodeID=' + EpisodeId + '&EpisodeLocID=' + gLocId );
		        } 
		    }else if (title=="������¼"){
			    if ($('#ifrmAllergy').attr('src')==""||"undefined"){
					$('#ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId+'&IsOnlyShowPAList=Y'); 
			    }
			}else if (title=="����¼"){
				if ($('#ifrmRisQuery').attr('src')==""||"undefined"){
					$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);
				}
			}else if (title=="�����¼"){
				if ($('#ifrmLisQuery').attr('src')==""||"undefined"){
					$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + EpisodeId+'&NoReaded='+'1'+'&PatientID='+patId); 
				}
			}else if (title=="����ҽ��"){
				if ($('#ifrmOrdQuery').attr('src')==""||"undefined"){
					$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + EpisodeId+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
				} 
			}
        }
    });
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbWard", {
		url: PHA_STORE.WardLoc().url,
		//width:155
	});
	
}

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
	
	$("#dateColStart").datebox("setValue", ComPropData.IPDispStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.IPDispEndDate);
	$('#timeColStart').timespinner('setValue', "00:00:00");
	$('#timeColEnd').timespinner('setValue', "23:59:59");
	/* ��ʼ����ҩ��ѡ�� */ 
	if (ComPropData.SelectPYUser == "Y"){
		InitPYUserDialog({callback: RetPYUserInfo});	// ��ҩҩʦ
	}
	else{
		$('#pyUserNameLable').parent().css('visibility','hidden');
		$('#pyUserName').parent().css('visibility','hidden');
		$("#btn-ChangePYUser").attr({
            "style": "display:none"
        });
	}
	PrescView("");
}
/* ��ť�¼� */
function InitEvent(){
	$('#btnDisp').on('click', ClickDispBtn);
	$('#btnReturn').on('click', LinkReturn);
	$('#btnDispAll').on('click', ClickDispAllBtn);
	$('#btnDispRefuse').on('click', ExecuteRefuseDisp);
	$('#btnCancelRefuse').on('click', CancelRefuse);
	//$('#btnClearScreen').on('click', Clear);
	$('#btnSaveAgreeRet').on('click', SaveAgreeRet);
	$('#btnChangeCook').on('click', ChangeCookType);
	$('#btnDeliveryInfo').on('click', ReShowDeliveryDiag);
	$("#btn-ChangePYUser").on("click", function () {
		ShowPYUserInfo() ;
	});
	
	//�ǼǺŻس��¼�
	$('#txtBarCode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txtBarCode").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryWardList();
				QueryInPrescList();
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
            height: 0.6 
        });
    }, 0);
}

/**
 * ��ʼ�������б�
 * @method InitGridInPrescList
 */
function InitGridInPrescList() {
	var columns = [
		[	{
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
				width: 90
			}, {
				field: 'TEmergFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 80
			}, {
				field: 'TWardLoc',
				title: '����',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TBedNo',
				title: '����',
				align: 'left',
				width: 60
			}, {
				field: 'TPatName',
				title: '����',
				align: 'left',
				showTip: true,
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
				width: 130
			}, {
				field: 'TPrescType',
				title: '��������',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TPrescTakeMode',
				title: 'ȡҩ��ʽ',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				align: 'left',
				width: 80
			}, {
				field: 'TFactor',
				title: '����',
				align: 'left',
				width: 50
			}, {
				field: 'TSeekUserName',
				title: '�ύ��ʿ',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TSeekDate',
				title: '�ύʱ��',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TPhaomName',
				title: '���ҩʦ',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TPhaomDate',
				title: '���ʱ��',
				align: 'left',
				showTip: true,
				width: 100,
				hidden: true
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
				field: 'TDiag',
				title: '���',
				align: 'left',
				showTip: true,
				width: 180
			}, {
				field: 'TWardLocId',
				title: '����Id',
				align: 'left',
				width: 180,				
				hidden: true
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
				field: 'druguseresult',
				title: '����������',
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
			}, {
				field: 'TFyFlag',
				title: '��ҩ��־',
				align: 'left',
				width: 30,
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:true ,
		pagination: true,
		pageSize:100,
		pageList:[100,300,500,999],
		singleSelect: true,
		exportXls: false,
		toolbar: "#gridInPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Dispen.Query",
			QueryName: "GetInPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			PrescView(prescNo);
			PHAHERB_COM.Default.selCookTypeDesc = rowData.TCookType;
		},
		onLoadSuccess: function () {
			var rows = $("#gridInPrescList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridInPrescList').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridInPrescList").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.TPrescNo;
				PHAHERB_COM.Default.selCookTypeDesc = gridSelect.TCookType;
				PrescView(prescNo);
			}
		}
	};
	PHA.Grid("gridInPrescList", dataGridOption);
}

/**
 * ��ʼ�������б�
 * @method InitGridWardList
 */
function InitGridWardList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			},{
				field: 'TWardLocId',
				title: '����Id',
				align: 'left',
				width: 70,
				hidden: true
			}, {
				field: 'TWardLocDesc',
				title: '��������',
				align: 'left',
				showTip: true,
				width: 130
			}, {
				field: 'TPrescNum',
				title: '��������',
				align: 'left',
				width: 70
			}
		]
	];
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap: true ,
		pagination: false,
		pageSize:999,
		//pageList:[100,300,500,999],
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		exportXls: false,
		toolbar: [],
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Dispen.Query",
			QueryName: "GetWardList",
		},
		onCheck: function () {
			QueryInPrescList() ;
		},
		onCheckAll: function () {
			var rows = $("#gridWardList").datagrid("getRows");
		    if (rows.length > 0) {
				QueryInPrescList() ;
			}
		},
		onUncheck: function () {
			QueryInPrescList() ;
		},	
		onUncheckAll: function () {
			var rows = $("#gridWardList").datagrid("getRows");
		    if (rows.length > 0) {
				QueryInPrescList() ;
			}
		},
		onLoadSuccess: function () {
			var rows = $("#gridWardList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridWardList').datagrid('selectAll');
			}
		}
	};
	PHA.Grid("gridWardList", dataGridOption);
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
 * @method QueryWardList
 */
function QueryWardList() {
	ClearWardList();
	ClearPrescList();
	PrescView("") ;
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridWardList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		LogonInfo: LogonInfo
	});
	 
}

/**
 * ��ѯ����
 * @method QueryInPrescList
 */
function QueryInPrescList() {
	ClearPrescList();
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	
	$('#gridInPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		LogonInfo: LogonInfo
	});
	 
}

/**
 * 
 *  ��ѯ������JSON
 */
function GetQueryParamsJson() {	
	
	var wardLocId = $('#cmbWard').combobox('getValue') ;
	if (wardLocId == "") {	
		var wardLocId = GetSelWardStr() ;
	}
    return {
        startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        loc: gLocId,
        patNo: $('#txtBarCode').val(),
        dispFlag: ($('#chk-disp').checkbox('getValue')==true?'Y':'N'), 
		wardLocId: wardLocId
    };
}

/**
 * 
 *  ��ȡ�����б�ѡ�Ĳ���
 */
function GetSelWardStr(){
	var checkedData = $('#gridWardList').datagrid('getChecked');
	if(checkedData.length==0){
		return "";
	}
	var selWardStr = "";
	for(var i in checkedData){
		var wardLocId = checkedData[i].TWardLocId;
		selWardStr = selWardStr == "" ? wardLocId : selWardStr +","+ wardLocId;
	}
	return selWardStr
}

/* �����ҩ��ť */
function ClickDispBtn(){
	PHA_COM.CACert("PHAHERBIPFY", ShowHerbDeliveryDiag);	
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
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ҩ�Ĵ���!","info");
		return;
	}	
	var dspStatus = gridSelect.TDspStatus;
	var fyFlag = gridSelect.TFyFlag;
	if (dspStatus==$g("�ܾ���ҩ")){
		$.messager.alert('��ʾ',"�ô����Ѿܾ���ҩ����ȡ���ܾ�������","info");
		return;
	}
	if (fyFlag=="Y"){
		$.messager.alert('��ʾ',"�ô����ѷ�ҩ�������ٴη�ҩ!","info");
		return;
	}

	var phbdId = gridSelect.TPhbdId ;
	var prescNo = gridSelect.TPrescNo ;
	var prescForm = gridSelect.TPrescTypeCode ;
	var papmi = gridSelect.TPapmi;
	var deliveryFlag = ComPropData.DeliveryFlag ;
	if (deliveryFlag == "Y") {
		ShowDeliveryDiag({
			prescNo : prescNo,
			prescForm : prescForm,
			papmi : papmi
		},GetDeliveryRet); 
	}
	else {
		ExecuteDisp() ;	
	}

}


function GetDeliveryRet(retVal){
	if (retVal == 1){
		ExecuteDisp() ;
	}
	return ;
}

/*
 * ��ҩ������ҩ
 * @method ExecuteDisp
 */
function ExecuteDisp(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	QueryInPrescList();
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
			type: "PH"
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
	var prescRows = $("#gridInPrescList").datagrid("getRows");
	if (prescRows.length == 0){
		$.messager.alert('��ʾ',"���Ȳ�ѯ����Ҫȫ���Ĵ���!","info");
		return;
	}
	PHA_COM.CACert("PHAHERBIPAllFY", ExecuteDispAll);	
}

/*
 * ȫ��
 * @method ExecuteDispAll
 */
function ExecuteDispAll(){
	var prescRows = $("#gridInPrescList").datagrid("getRows");
	for (var i = 0; i < prescRows.length; i++) {
		var phbdId = prescRows[i].TPhbdId;
		if (ComPropData.SelectPYUser == "Y"){
			var pyStateId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", PYDictCode)
			var params = phbdId + tmpSplit + pyStateId + tmpSplit + DHCPHA_CONSTANT.DEFAULT.PYUSER ;

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
				DoExecuteDisp(phbdId);
			}
		}
		else {
			DoExecuteDisp(phbdId);
		}
	}
	
	PrescView("");
	QueryInPrescList();

}

/*
 * ��ҩ�����ܷ�ҩ
 * @method RefuseDisp
 */
function ExecuteRefuseDisp(){
	
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�ܷ��Ĵ���!","info");
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
		var tipMsg = "�ô�����" + dspStatus + "�������ٴξܾ���ҩ"
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
	},SaveRefuseEX,{orditm:orditm}); 
	
}

function SaveRefuseEX(reasonStr,origOpts){
	if (reasonStr==""){
		return "";
	}
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
		hospId: gHospID
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		QueryInPrescList();
	});

}



/*
 * ������ҩ�����ܷ�ҩ
 * @method CancelRefuse
 */
function CancelRefuse(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
		QueryInPrescList();
	});
	
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	$('#chk-disp').checkbox("uncheck",true) ;
	$('#cmbWard').combobox('clear');
	$('#txtBarCode').val("");
	InitSetDefVal();
	ClearWardList();
	ClearPrescList();
	
}

function ClearWardList(){
	$('#gridWardList').datagrid('clear');
	$('#gridWardList').datagrid('uncheckAll');
}

function ClearPrescList(){
	$('#gridInPrescList').datagrid('clear');
	$('#gridInPrescList').datagrid('uncheckAll');
	PrescView("") ;
}

/*
 * ��Ϊ����
 * @method SaveAgreeRet
 */
function SaveAgreeRet(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
		QueryInPrescList();
		PrescView("") ;
	});
}


/*
 * ��ҩ��������ת��
 * @method ChangeCookType
 */
function ChangeCookType(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫת����ҩ��ʽ�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
	var phbdId = gridSelect.TPhbdId;
	var cookType = gridSelect.TCookTypeId;
	if ((cookType == "")||(cookType == 0)) {
		$.messager.alert('��ʾ',"��ҩ��ʽΪ�ղ�����ת����ҩ��ʽ��","info");
		return;
	};
	var cookTypeDesc = gridSelect.TCookType;
	ShowChangeCookType("ChangeCookTypeWin", DoExchange);

}

//��ʼ����ҩ����
function InitCookType(cookType){
	PHA.ComboBox("sel-cook", {
		url: PHA_HERB_STORE.CookType(encodeURI(cookType),gLocId).url,
		onLoadSuccess: function(){
			var data= $("#sel-cook").combobox("getData");
			if (data.length > 0) {
				$('#sel-cook').combobox('setValue', data[0].RowId);
			}
		}
	});
}

function DoExchange(ChangeCookJson){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('��ʾ',"����ѡ����Ҫת����ҩ��ʽ�Ĵ���!","info");
		return;
	}
	var index = $("#gridInPrescList").datagrid("getRowIndex", gridSelect);
	var prescNo = gridSelect.TPrescNo;
	var phbdId = gridSelect.TPhbdId;
	var cookType = gridSelect.TCookTypeId;
	var toCookTypeId = ChangeCookJson.cookTypeId ;
	var cookTypeStr = cookType + tmpSplit + toCookTypeId;
	var Ret = tkMakeServerCall("PHA.HERB.Dispen.Save","ChangeCookTypeForI", phbdId, cookTypeStr, LogonInfo);
	var RetCode = Ret.split("^")[0];
	var RetMessage = Ret.split("^")[1];
	if(RetCode==0){
		$.messager.alert('��ʾ',"ת���ɹ���","info");
		$("#gridInPrescList").datagrid('updateRow',{
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

//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, QueryInPrescList()) ; 
}



/*
/	���´򿪴��������Ϣ����
/*/
function ReShowDeliveryDiag(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	QueryInPrescList();
	return ;	
}

function RetPYUserInfo(param){	
	var pyUserId = param.pyUserId;	
	var pyUserDesc = param.pyUserName;
	
	$("#pyUserName").text(pyUserDesc);
	DHCPHA_CONSTANT.DEFAULT.PYUSER = pyUserId;
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
			setTimeout("QueryInPrescList()",500);
		}
	}
	else {
		setTimeout("QueryWardList()",500);
	}
	
}
