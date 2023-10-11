/**
 * @ģ��:     �����ҩ�������
 * @��д����: 2020-10-27
 * @��д��:   MaYuqiang
 */
DHCPHA_CONSTANT.VAR.TIMER = '';
DHCPHA_CONSTANT.VAR.TIMERSTEP = 6 * 1000;
DHCPHA_CONSTANT.DEFAULT.APPTYPE="HERBOA";
DHCPHA_CONSTANT.DEFAULT.ADMTYPE="O";
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var str=tkMakeServerCall("web.DHCOutPhCommon", "GetPassProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var strArr=str.split("^");
var RePassNeedCancel=strArr[1];
var PatientInfo = {
	adm: 0,
	patientID: 0,
	prescno: 0,
	phbdId: ''
};
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;
$(function () {
	if (ReasonWayId == "") {
		$.messager.alert('��ʾ',"δ��ȡ�����ԭ����Ϣ������ά�����ԭ���ٽ�����˲���!","info");
        return;
    }
	InitGridOutPrescList();
	InitSetDefVal();
	$('#btnAuditOk').on('click', AuditOK);
	$('#btnAuditNo').on('click', AuditNO);
	$('#btnAdmInfo').on('click', AdmAddInfo);
	$('#btnAuditRecord').on('click', AuditLog);
	$('#btnAnalyPresc').on('click', PrescAnalyse);
	$('#btnClearScreen').on('click', Clear);
	$('#btnPrintPresc').on('click', PrintPresc);
	$("#txtCardNo").imedisabled();

	/* �ǼǺŻس��¼� */
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
	
	/* ���Żس��¼� */ 
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	
	$('#readCard').on('click', BtnReadCardHandler) ;
	
	/* �������лس��¼� */
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* �Զ�ˢ�� */
	$('#chk-autofresh').on('ifChanged', function () {
       if ($(this).is(':checked') == true) {
           	DHCPHA_CONSTANT.VAR.TIMER = setInterval('QueryOutPrescList();', DHCPHA_CONSTANT.VAR.TIMERSTEP);
       } else {  
       		clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
       }
    });
    
	$("#tabsForm").tabs({
        onSelect: function(title) {		    			
			var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
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
					$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?PatientID=' + patId+'&EpisodeID=' + EpisodeId+'&mradm=' + EpisodeId+'&OpenWinName=OPDocRecAdm');
				} 
			}
        }
    });
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
	
	$("#dateColStart").datebox("setValue", ComPropData.OPAuditStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.OPAuditEndDate);
	//$('#timeColStart').timespinner('setValue', ComPropData.QueryStartTime);
	//$('#timeColEnd').timespinner('setValue', ComPropData.QueryEndTime);
	PrescView("");
}

/**
 * ��ʼ�������б�
 * @method InitGridOutPrescList
 */
function InitGridOutPrescList() {
	var columns = [
		[{
				field:'pdCheck',	
				checkbox: true 
			},{
				field: 'druguse',
				title: '�������',
				align: 'left',
				width: 70
			}, {
				field: 'TAuditResult',
				title: '�󷽽��',
				align: 'center',
				width: 90,
				styler: function(value, rowData, rowIndex) {
					if (rowData.TAuditResult == "ͨ��") {
						return 'background-color:#03ceb4; color:black;';
					}
					else if (rowData.TAuditResult == "�ܾ�") {
						return 'background-color:#ee4f38; color:black;';
					}
					else if(rowData.TAuditResult == "����") {
						return 'background-color:#f1c516; color:black;';
					}
				}
			}, {
				field: 'TDspStatus',
				title: '��ҩ״̬',
				align: 'left',
				width: 70,				
				hidden: true
			}, {
				field: 'TEmergFlag',
				title: '�Ƿ�Ӽ�',
				align: 'left',
				width: 80
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
				width: 130
			}, {
				field: 'TPrescType',
				title: '��������',
				align: 'left',
				width: 80
			}, {
				field: 'TCookType',
				title: '��ҩ��ʽ',
				align: 'left',
				width: 80
			}, {
				field: 'TPrescAmt',
				title: '�������',
				align: 'left',
				width: 80
			}, {
				field: 'TDispWin',
				title: '��ҩ����',
				align: 'left',
				width: 80
			}, {
				field: 'TFactor',
				title: '����',
				align: 'left',
				width: 50
			}, {
				field: 'TBillType',
				title: '�ѱ�',
				align: 'left',
				width: 80
			}, {
				field: 'TDiag',
				title: '���',
				align: 'left',
				width: 180
			}, {
				field: 'TMBDiagnos',
				title: '�������',
				align: 'left',
				width: 150,				
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
				field: 'TAdmLoc',
				title: '����/����',
				align: 'left',
				width: 120
			}, {
				field: 'TRefResult',
				title: '�ܾ�����',
				align: 'left',
				width: 150
			}, {
				field: 'TDocNote',
				title: '��������',
				align: 'left',
				width: 150
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
				width: 80
			}, {
				field: 'TPatLevel',
				title: '���˼���',
				align: 'left',
				width: 80
			}, {
				field: 'TPhbdId',
				title: 'TPhbdId',
				align: 'left',
				width: 80,				
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		pagination: true,
		pageSize:100,
		pageList:[100,300,500,999],
		singleSelect: false,
		toolbar: "#gridOutPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Audit.Query",
			QueryName: "GetOutPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			PrescView(prescNo);
		},
		onCheck: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			PrescView(prescNo);
        },
        onUncheck: function (rowIndex, rowData) {
			PrescView("");
        },
        onLoadSuccess:function(){
	        $('#gridOutPrescList').datagrid('uncheckAll');
	    	var rows = $("#gridOutPrescList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridOutPrescList').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridOutPrescList").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.TPrescNo;
				PrescView(prescNo);
			}    
	    }
	};
	PHA.Grid("gridOutPrescList", dataGridOption);
}

/**
 * ����Ԥ��
 * @method PrescView
 */
function PrescView(prescNo){
	var phartype = "O";
	if(prescNo.indexOf("I")>-1){
		phartype = "I";
	}
	var cyflag = "Y";
	PHA_HERB.Presc("colprelayout", {
		PrescNo: prescNo, 
		AdmType: phartype,
		CY: cyflag
	}); 
}

/**
 * ��ѯ����
 * @method QueryOutPrescList
 */
function QueryOutPrescList() {
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridOutPrescList').datagrid('uncheckAll');
	$('#gridOutPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		logonInfo: LogonInfo
	});
	Setfocus(); 
}

/**
 * ��ȡ����Ԫ��ֵ
 * @method GetParams
 */
function GetParams() {
	var startDate = $("#dateColStart").datebox('getValue');
	var endDate = $("#dateColEnd").datebox('getValue');
	var startTime = $('#timeColStart').timespinner('getValue');
	var endTime = $('#timeColEnd').timespinner('getValue');
	var locId = gLocId;
	var patNo = $('#txtBarCode').val()
	var auditFlag = ($('#chk-audit').checkbox('getValue')==true?'Y':'N');
	
	var params = startDate + tmpSplit + endDate + tmpSplit + startTime + tmpSplit + endTime + tmpSplit + locId ;
	var params = params + tmpSplit + patNo + tmpSplit + auditFlag
	return params;
}

// ��ѯ������JSON
function GetQueryParamsJson() {
    return {
        startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        loc: gLocId,
        patNo: $('#txtBarCode').val(),
        auditFlag: ($('#chk-audit').checkbox('getValue')==true?'Y':'N') ,
        admType: DHCPHA_CONSTANT.DEFAULT.ADMTYPE    
    };
}

/**
 * ���ͨ��(����������)
 * @method AuditOK
 */
function AuditOK() {
	var gridSelectRows = $("#gridOutPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��˵Ĵ���!","info");
		return;
	}
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var prescNo = gridSelect.TPrescNo;
        if (prescNo !== ""){
			var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬
			if (gridSelect=="C"){
				$.messager.alert('��ʾ',"����: " + prescNo + " �ѷ�ҩ�������ٴ����!","info");
				return;
			}
			var auditResult=gridSelect.TAuditResult;
			if (auditResult.indexOf("����")>-1) {
				$.messager.alert('��ʾ',"����: " + prescNo + " ���Ѿ�����,�������ͨ��!","info");
				return;
			}
			if(RePassNeedCancel=="Y"){
				if (auditResult == "ͨ��") {
					$.messager.alert('��ʾ',"����: " + prescNo + " ��ͨ��,�����ٴ����ͨ��!","info");
					return;
				}
				else if (auditResult.indexOf("�ܾ�") != "-1"){
					$.messager.alert('��ʾ',"����: " + prescNo + " �Ѿܾ�,�賷��֮ǰ����˼�¼�����ٴ����!","info");
					return;
				}
			}	
			var ret = "Y";
			var reasondr = "";
			var phnote = "";
			var phbdId = gridSelect.TPhbdId ;
			var input = ret + tmpSplit + gUserID + tmpSplit + phnote + tmpSplit + DHCPHA_CONSTANT.DEFAULT.APPTYPE + tmpSplit + phbdId;
			SaveAuditResult(reasondr, input);
		
		}	    
    }

	
}

/**
 * ��˾ܾ�(��������������)
 * @method AuditNO
 */
function AuditNO() {
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��˵Ĵ���!","info");
		return;
	}
	var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬
	if (gridSelect=="C"){
		$.messager.alert('��ʾ',"�ô����ѷ�ҩ�������ٴ����!","info");
		return;
	}
	var auditResult = gridSelect.TAuditResult;
	if (auditResult.indexOf("����")>-1) {
		$.messager.alert('��ʾ',"�ô������Ѿ�����,�������ͨ��!","info");
        return;
    }
	if(RePassNeedCancel=="Y"){
	    if (auditResult.indexOf("�ܾ�") != "-1"){
			$.messager.alert('��ʾ',"��ѡ��Ĵ����Ѿܾ�,�賷��֮ǰ����˼�¼�����ٴ����!","info");
	        return;
		}
    }
	var orditm = gridSelect.TOeori;
	var prescNo = gridSelect.TPrescNo;
    ShowPHAPRASelReason({
		wayId:ReasonWayId,
		oeori:"",
		prescNo:prescNo,
		selType:"PRESCNO",
		orderRequired: "0"
	},SaveCommontResultEX,{orditm:orditm}); 
}

function SaveCommontResultEX(reasonStr,origOpts){
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
	SaveAuditResult(reasondr, input)
}

function SaveAuditResult(reasonStr, params)
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
		else {
			/// ��˺��Զ�ִ�п�ʼ��ҩ���ڴ˴���ӡ��ҩ��
			var paramsArr = params.split(tmpSplit) ;
			var ret = paramsArr[0] ;
			if ((ComPropData.AutoExeObtainPresc == "Y")&&(ret == "Y")){
				var phbdId = paramsArr[4] ;
				HERB_PRINTCOM.PYD(phbdId,"")	
			}	
		}
		QueryOutPrescList();
	});

}

/**
 * ����������Ϣ
 * @method AdmAddInfo
 */
function AdmAddInfo() {
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴�Ĵ�����¼","info");
		return;
	}
	AppendPatientOrdInfo({
		id:'#dhcpha-patinfo',
		prescNo:gridSelect.TPrescNo
	})
	$('#diagAddInfo').dialog('open');
}


/**
 * �����־
 * @method AuditLog
 */
function AuditLog() {
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴��־�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
	var logoptions = {
		fromgrid : "#gridAuditLog",
		params : prescNo
	};
	
	InitAuditLogBody(logoptions);
	$('#diagAuditLog').dialog('open');
	
	
}

/**
 * ��������
 * @method PrescAnalyse
 */
function PrescAnalyse() {
	alert("PrescAnalyse")
	
}

/*
 * ����
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridOutPrescList').datagrid('clear');
	$('#gridOutPrescList').datagrid('uncheckAll');
	PrescView("")
	$('#txtBarCode').val("");
	$('#txtCardNo').val("");
	$('#chk-audit').checkbox("uncheck",true) ;
}

/*
 * ��ӡ����
 * PrintPresc
 */
function PrintPresc(){
	var gridSelectRows = $("#gridOutPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ӡ�Ĵ���!","info");
		return;
	}
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
        var prescNo = gridSelectRows[pnum].TPrescNo;
        var phbdId = gridSelectRows[pnum].TPhbdId;
        if ( phbdId !== ""){
			OUTPHA_PRINTCOM.Presc(prescNo,"����","","��"); 
        }	    
    }
    
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
	setTimeout("QueryOutPrescList()",500);
}

function addStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val=="ͨ��"){
		return "class=pha-herb-record-passed";
	}else if (val=="����"){
		return "class=pha-herb-record-appeal";
	}else if (val=="�ܾ�"){
		return "class=pha-herb-record-refused";
	}else{
		return "";
	}
}
