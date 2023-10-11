/**
 * @ģ��:     סԺ��ҩ�������
 * @��д����: 2020-11-14
 * @��д��:   MaYuqiang
 */
DHCPHA_CONSTANT.DEFAULT.APPTYPE="HERBIA";
DHCPHA_CONSTANT.DEFAULT.ADMTYPE="I";
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var str=tkMakeServerCall("web.DHCOutPhCommon", "GetPassProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var strArr=str.split("^");
var RePassNeedCancle=strArr[1];
var ComPropData		// ��������
var AppPropData		// ģ������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;

$(function () {
	if (ReasonWayId == "") {
		$.messager.alert('��ʾ',"δ��ȡ�����ԭ����Ϣ������ά�����ԭ���ٽ�����˲���!","info");
        return;
    }
	InitDict();
	InitSetDefVal();
	InitGridInPrescList();
	InitGridWardList();
	$('#btnAuditOk').on('click', AuditOK);
	$('#btnAuditNo').on('click', AuditNO);
	$('#btnAdmInfo').on('click', AdmAddInfo);
	$('#btnAuditRecord').on('click', AuditLog);
	$('#btnAnalyPresc').on('click', PrescAnalyse);
	$('#btnClearScreen').on('click', Clear);
	$('#btnPrintPresc').on('click', PrintPresc);
	
	$('#btnQueryPrescList').on('click', QueryInPrescList);
	$('#btnSearchWardList').on('click', QueryWardList);
	//�ǼǺŻس��¼�
	$('#txtBarCode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txtBarCode").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				//QueryWardList();
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
	PrescView("");
	PHA.ComboBox("cmbWard", {
		url: PHA_STORE.WardLoc().url
		//width:155
	});
	
}

function InitSetDefVal(){
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)
	
	$("#dateColStart").datebox("setValue", ComPropData.IPAuditStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.IPAuditEndDate);
	//$('#timeColStart').timespinner('setValue', ComPropData.QueryStartTime);
	//$('#timeColEnd').timespinner('setValue', ComPropData.QueryEndTime);
	PrescView("") ;
}

/**
 * ��ʼ�������б�
 * @method InitGridInPrescList
 */
function InitGridInPrescList() {
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
				width: 70,
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
				field: 'TWardLoc',
				title: '����',
				align: 'left',
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
				field: 'TFactor',
				title: '����',
				align: 'left',
				width: 50
			}, {
				field: 'TPrescAmt',
				title: '�������',
				align: 'left',
				width: 80
			}, {
				field: 'TSeekUserName',
				title: '�ύ��ʿ',
				align: 'left',
				width: 100
			}, {
				field: 'TSeekDate',
				title: '�ύʱ��',
				align: 'left',
				width: 100
			}, {
				field: 'TPhaomName',
				title: '���ҩʦ',
				align: 'left',
				width: 100
			}, {
				field: 'TPhaomDate',
				title: '���ʱ��',
				align: 'left',
				width: 180
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
				field: 'TDiag',
				title: '���',
				align: 'left',
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
		pagination: false,
		pageSize:999,
		singleSelect: false,
		toolbar: "#gridInPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Audit.Query",
			QueryName: "GetInPrescList",
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
	    	var rows = $("#gridInPrescList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridInPrescList').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridInPrescList").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.TPrescNo;
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
				width: 150
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
		nowrap:false ,
		pagination: true,
		pageSize:100,
		pageList:[100,300,500,999],
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		toolbar: [],
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Audit.Query",
			QueryName: "GetWardList",
		},
		onCheck: function () {
			QueryInPrescList() ;
		},
		onCheckAll: function () {
			QueryInPrescList() ;
		},
		onUncheck: function () {
			QueryInPrescList() ;
		},	
		onUncheckAll: function () {
			QueryInPrescList() ;
		},
		onLoadSuccess: function () {
			/*
			var rows = $("#gridWardList").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridWardList').datagrid('selectRow', 0);
			}
			*/
		}
	};
	PHA.Grid("gridWardList", dataGridOption);
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
		CY: cyflag,
		zf:"�׷�"
	}); 
}

/**
 * ��ѯ����
 * @method QueryWardList
 */
function QueryWardList() {
	$('#gridWardList').datagrid('uncheckAll');
	$('#gridWardList').datagrid('clear');
	$('#gridInPrescList').datagrid('uncheckAll');
	$('#gridInPrescList').datagrid('clear');
	
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridWardList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
	 
}

/**
 * ��ѯ����
 * @method QueryInPrescList
 */
function QueryInPrescList() {
	$('#gridInPrescList').datagrid('uncheckAll');
	$('#gridInPrescList').datagrid('clear');
	
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridInPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
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
        auditFlag: ($('#chk-audit').checkbox('getValue')==true?'Y':'N'), 
		wardLocId: wardLocId,
		admType: DHCPHA_CONSTANT.DEFAULT.ADMTYPE 
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

/**
 * ���ͨ��
 * @method AuditOK
 */
function AuditOK() {
	var gridSelectRows = $("#gridInPrescList").datagrid("getSelections");
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
			var auditResult = gridSelect.TAuditResult;
			if (auditResult.indexOf("����")>-1) {
				$.messager.alert('��ʾ',"����: " + prescNo + " ���Ѿ�����,�������ͨ��!","info");
				return;
			}
			if(RePassNeedCancle=="Y"){
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
    QueryWardList();
    QueryInPrescList();
	PrescView("") ;
    	
}

/**
 * ��˾ܾ�
 * @method AuditNO
 */
function AuditNO() {
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��˵Ĵ���!","info");
		return;
	}
	var dspStatus = gridSelect.TDspStatus ;		//��ҩ״̬
	if (gridSelect == "C"){
		$.messager.alert('��ʾ',"�ô����ѷ�ҩ�������ٴ����!","info");
		return;
	}
	var auditResult = gridSelect.TAuditResult;
	if (auditResult.indexOf("����") > -1) {
		$.messager.alert('��ʾ',"�ô������Ѿ�����,�������ͨ��!","info");
        return;
    }
	if(RePassNeedCancle == "Y"){
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
		selType:"PRESCNO"
	},SaveResultEX,{orditm:orditm}); 
	
}

function SaveResultEX(reasonStr,origOpts){
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
	});
	QueryWardList();
    QueryInPrescList();
}

/**
 * ����������Ϣ
 * @method AdmAddInfo
 */
function AdmAddInfo() {
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ�鿴��־�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
	var logoptions={
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
	$('#gridWardList').datagrid('clear');
	$('#gridWardList').datagrid('uncheckAll');
	$('#gridInPrescList').datagrid('clear');
	$('#gridInPrescList').datagrid('uncheckAll');
	$('#txtBarCode').val("");
	$('#chk-audit').checkbox("uncheck",true) ;
}

/*
 * ��ӡ����
 * PrintPresc
 */
function PrintPresc(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('��ʾ',"����ѡ����Ҫ��ӡ�Ĵ���!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
    OUTPHA_PRINTCOM.Presc(prescNo,"����","","��"); 
}

//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, QueryWardList()) ; 
}

//��������
window.onload=function(){
	setTimeout("QueryWardList()",500);
}
