/**
 * @模块:     门诊草药处方审核
 * @编写日期: 2020-10-27
 * @编写人:   MaYuqiang
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
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;
$(function () {
	if (ReasonWayId == "") {
		$.messager.alert('提示',"未获取到审核原因信息，请先维护审核原因再进行审核操作!","info");
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

	/* 登记号回车事件 */
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
	
	/* 卡号回车事件 */ 
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	
	$('#readCard').on('click', BtnReadCardHandler) ;
	
	/* 屏蔽所有回车事件 */
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	/* 自动刷新 */
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
				$.messager.alert('提示',"请先选中需要查看的处方!","info");
				return;
			}
			var prescNo = gridSelect.TPrescNo ;
			var EpisodeId = gridSelect.TAdm ;	
			var patId = gridSelect.TPapmi ;
			if (title=="病历浏览"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
                    $('#ifrmEMR').attr('src', 'emr.browse.csp'+ '?PatientID='+ patId + '&EpisodeID=' + EpisodeId + '&EpisodeLocID=' + gLocId );
		        } 
		    }else if (title=="过敏记录"){
			    if ($('#ifrmAllergy').attr('src')==""||"undefined"){
					$('#ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId+'&IsOnlyShowPAList=Y'); 
			    }
			}else if (title=="检查记录"){
				if ($('#ifrmRisQuery').attr('src')==""||"undefined"){
					$('#ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp'+'?EpisodeID=' + EpisodeId+'&PatientID='+patId);
				}
			}else if (title=="检验记录"){
				if ($('#ifrmLisQuery').attr('src')==""||"undefined"){
					$('#ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp'+'?EpisodeID=' + EpisodeId+'&NoReaded='+'1'+'&PatientID='+patId); 
				}
			}else if (title=="本次医嘱"){
				if ($('#ifrmOrdQuery').attr('src')==""||"undefined"){
					$('#ifrmOrdQuery').attr('src', 'oeorder.opbillinfo.csp'+'?PatientID=' + patId+'&EpisodeID=' + EpisodeId+'&mradm=' + EpisodeId+'&OpenWinName=OPDocRecAdm');
				} 
			}
        }
    });
});

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	// 公共设置
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
 * 初始化处方列表
 * @method InitGridOutPrescList
 */
function InitGridOutPrescList() {
	var columns = [
		[{
				field:'pdCheck',	
				checkbox: true 
			},{
				field: 'druguse',
				title: '分析结果',
				align: 'left',
				width: 70
			}, {
				field: 'TAuditResult',
				title: '审方结果',
				align: 'center',
				width: 90,
				styler: function(value, rowData, rowIndex) {
					if (rowData.TAuditResult == "通过") {
						return 'background-color:#03ceb4; color:black;';
					}
					else if (rowData.TAuditResult == "拒绝") {
						return 'background-color:#ee4f38; color:black;';
					}
					else if(rowData.TAuditResult == "申诉") {
						return 'background-color:#f1c516; color:black;';
					}
				}
			}, {
				field: 'TDspStatus',
				title: '发药状态',
				align: 'left',
				width: 70,				
				hidden: true
			}, {
				field: 'TEmergFlag',
				title: '是否加急',
				align: 'left',
				width: 80
			}, {
				field: 'TPatName',
				title: '姓名',
				align: 'left',
				width: 70
			}, {
				field: 'TPmiNo',
				title: '登记号',
				align: 'left',
				width: 100,
				formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.TAdm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
			}, {
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 130
			}, {
				field: 'TPrescType',
				title: '处方剂型',
				align: 'left',
				width: 80
			}, {
				field: 'TCookType',
				title: '煎药方式',
				align: 'left',
				width: 80
			}, {
				field: 'TPrescAmt',
				title: '处方金额',
				align: 'left',
				width: 80
			}, {
				field: 'TDispWin',
				title: '发药窗口',
				align: 'left',
				width: 80
			}, {
				field: 'TFactor',
				title: '付数',
				align: 'left',
				width: 50
			}, {
				field: 'TBillType',
				title: '费别',
				align: 'left',
				width: 80
			}, {
				field: 'TDiag',
				title: '诊断',
				align: 'left',
				width: 180
			}, {
				field: 'TMBDiagnos',
				title: '慢病诊断',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TPatSex',
				title: '性别',
				align: 'left',
				width: 50
			}, {
				field: 'TPatAge',
				title: '年龄',
				align: 'left',
				width: 50
			}, {
				field: 'TAdmLoc',
				title: '科室/病区',
				align: 'left',
				width: 120
			}, {
				field: 'TRefResult',
				title: '拒绝理由',
				align: 'left',
				width: 150
			}, {
				field: 'TDocNote',
				title: '申诉理由',
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
				title: '病人密级',
				align: 'left',
				width: 80
			}, {
				field: 'TPatLevel',
				title: '病人级别',
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
 * 处方预览
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
 * 查询数据
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
 * 获取界面元素值
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

// 查询条件的JSON
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
 * 审核通过(可批量操作)
 * @method AuditOK
 */
function AuditOK() {
	var gridSelectRows = $("#gridOutPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('提示',"请先选中需要审核的处方!","info");
		return;
	}
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var prescNo = gridSelect.TPrescNo;
        if (prescNo !== ""){
			var dspStatus = gridSelect.TDspStatus ;		//发药状态
			if (gridSelect=="C"){
				$.messager.alert('提示',"处方: " + prescNo + " 已发药，不能再次审核!","info");
				return;
			}
			var auditResult=gridSelect.TAuditResult;
			if (auditResult.indexOf("接受")>-1) {
				$.messager.alert('提示',"处方: " + prescNo + " 审方已经接受,不能审核通过!","info");
				return;
			}
			if(RePassNeedCancel=="Y"){
				if (auditResult == "通过") {
					$.messager.alert('提示',"处方: " + prescNo + " 已通过,不能再次审核通过!","info");
					return;
				}
				else if (auditResult.indexOf("拒绝") != "-1"){
					$.messager.alert('提示',"处方: " + prescNo + " 已拒绝,需撤消之前的审核记录才能再次审核!","info");
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
 * 审核拒绝(仅单个处方操作)
 * @method AuditNO
 */
function AuditNO() {
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要审核的处方!","info");
		return;
	}
	var dspStatus = gridSelect.TDspStatus ;		//发药状态
	if (gridSelect=="C"){
		$.messager.alert('提示',"该处方已发药，不能再次审核!","info");
		return;
	}
	var auditResult = gridSelect.TAuditResult;
	if (auditResult.indexOf("接受")>-1) {
		$.messager.alert('提示',"该处方审方已经接受,不能审核通过!","info");
        return;
    }
	if(RePassNeedCancel=="Y"){
	    if (auditResult.indexOf("拒绝") != "-1"){
			$.messager.alert('提示',"您选择的处方已拒绝,需撤消之前的审核记录才能再次审核!","info");
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
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		else {
			/// 审核后自动执行开始配药的在此处打印配药单
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
 * 其他就诊信息
 * @method AdmAddInfo
 */
function AdmAddInfo() {
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方记录","info");
		return;
	}
	AppendPatientOrdInfo({
		id:'#dhcpha-patinfo',
		prescNo:gridSelect.TPrescNo
	})
	$('#diagAddInfo').dialog('open');
}


/**
 * 审核日志
 * @method AuditLog
 */
function AuditLog() {
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('提示',"请先选中需要查看日志的处方!","info");
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
 * 处方分析
 * @method PrescAnalyse
 */
function PrescAnalyse() {
	alert("PrescAnalyse")
	
}

/*
 * 清屏
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
 * 打印处方
 * PrintPresc
 */
function PrintPresc(){
	var gridSelectRows = $("#gridOutPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('提示',"请先选中需要打印的处方!","info");
		return;
	}
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
        var prescNo = gridSelectRows[pnum].TPrescNo;
        var phbdId = gridSelectRows[pnum].TPhbdId;
        if ( phbdId !== ""){
			OUTPHA_PRINTCOM.Presc(prescNo,"正方","","补"); 
        }	    
    }
    
}

/// 光标默认
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

//读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, QueryOutPrescList) ; 
}

//载入数据
window.onload=function(){
	setTimeout("QueryOutPrescList()",500);
}

function addStatCellAttr(rowId, val, rawObject, cm, rdata){
	if (val=="通过"){
		return "class=pha-herb-record-passed";
	}else if (val=="申诉"){
		return "class=pha-herb-record-appeal";
	}else if (val=="拒绝"){
		return "class=pha-herb-record-refused";
	}else{
		return "";
	}
}
