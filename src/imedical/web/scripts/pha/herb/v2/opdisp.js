/**
 * @模块:     门诊草药处方发药
 * @编写日期: 2020-11-06
 * @编写人:   MaYuqiang
 */
DHCPHA_CONSTANT.DEFAULT.APPTYPE="HERBOR";
DHCPHA_CONSTANT.DEFAULT.DISPWINDOW="";
DHCPHA_CONSTANT.DEFAULT.PYUSER="";
PHA_COM.Val.CAModelCode = "PHAHERBOPFY"; 
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var ProDictCode = "Dispen";
var PYDictCode = "CompleteDisp"
var AppPropData;	// 模块配置
var ComPropData;	// 公共配置
var SELCOOKTYPE;
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_opdisp', $('#pha_herb_v2_opdisp').panel('options').title);
	InitGridOutPrescList();
	InitGridWaitList();
	InitSetDefVal();
	InitEvent();            //  按钮事件
	ResizePanel();          //  布局调整
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
	
	$("#dateColStart").datebox("setValue", ComPropData.OPDispStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.OPDispEndDate);
	$('#timeColStart').timespinner('setValue', "00:00:00");
	$('#timeColEnd').timespinner('setValue', "23:59:59");
	
	/* 初始化发药窗口 */ 
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

	/* 初始化配药人选择 */ 
	if (ComPropData.SelectPYUser == "Y"){
		InitPYUserDialog({callback: RetPYUserInfo});	// 配药药师
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

/* 按钮事件 */
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

	//登记号回车事件
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
	
	// 卡号回车事件
	$("#txtCardNo").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardNo = $.trim($("#txtCardNo").val());
			if (cardNo != "") {
				BtnReadCardHandler();
			}
		}
	})
	$('#readCard').on('click', BtnReadCardHandler) ;
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
}

// 布局调整
function ResizePanel(){
    setTimeout(function () {    
        var flag = 0.4;
        if(PHA_COM.Window.Width()<1500 ){flag = 0.5}         
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb—grid',
            region: 'west',
            width: flag
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb—grid-list',
            region: 'south',
            height: 0.5 
        });
    }, 0);
}

/**
 * 初始化处方列表
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
				title: '发药状态',
				align: 'left',
				showTip: true,
				tipWidth: 100,
				width: 90,
				styler: function(value, rowData, rowIndex) {
					if (rowData.TDspStatus == $g("拒绝发药")) {
						return 'background-color:#ee4f38; color:white;';
					}
					else if(rowData.TDspStatus == $g("申诉")) {
						return 'background-color:#f1c516; color:white;';
					}
				}
			},{
				field: 'TPrescPro',
				title: '当前流程',
				align: 'left',
				hidden: true,
				showTip: true,
				width: 90
			}, {
				field: 'TEmergFlag',
				title: '是否加急',
				align: 'left',
				width: 70
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
				showTip: true,
				width: 130
			}, {
				field: 'TFyFlag',
				title: '发药标志',
				align: 'left',
				width: 30,
				hidden: true
			}, {
				field: 'TPrescType',
				title: '处方剂型',
				align: 'left',
				width: 80
			}, {
				field: 'TFactor',
				title: '付数',
				align: 'left',
				width: 50
			}, {
				field: 'TPrescTakeMode',
				title: '取药方式',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TCookType',
				title: '煎药方式',
				align: 'left',
				width: 80
			}, {
				field: 'TCookCost',
				title: '煎药费/申请状态',
				align: 'left',
				showTip: true,
				width: 180
			}, {
				field: 'TBillType',
				title: '费别',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TMBDiagnos',
				title: '慢病诊断',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TDiag',
				title: '诊断',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TAdmLoc',
				title: '科室/病区',
				align: 'left',
				showTip: true,
				width: 120
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
				field: 'TRefResult',
				title: '拒绝理由',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TDocNote',
				title: '申诉理由',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TAgreeRetFlag',
				title: '是否可退',
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
				title: '病人密级',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPatLevel',
				title: '病人级别',
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
				title: '处方剂型代码',
				align: 'left',
				width: 80,
				hidden: true
			}, {
				field: 'TCookTypeId',
				title: '煎药方式Id',
				align: 'left',
				width: 80,
				hidden: true
			}, {
				field: 'TPrescFormula',
				title: '协定方',
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
 * 初始化处方列表
 * @method InitGridOutPrescList
 */
function InitGridWaitList() {
	var columns = [
		[	
			{
				field: 'TPapmi',
				title: '主索引',
				align: 'left',
				hidden: true,
				width: 90
			}, { 
				field: 'TSendVoice',		
				title: $g('叫号'),			
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
				title: '登记号',
				align: 'left',
				width: 200
			}, {
				field: 'TPatName',
				title: '姓名',
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
				title: '叫号id',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TQueNo',
				title: '排队号',
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
				$.messager.alert('提示',"没有报到排队,不需过号!","info");
				return;
			}
			var state = "Skip";
			var retInfo = tkMakeServerCall("PHA.OP.Queue.OperTab", "UpdQueueState", phwQuId, state);
			QueryWaitList();
		}
	})

	
	
}

/**
 * 处方预览
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
	var zfFlag = "底方"
	var dispFlag = "OK"
	if (dispFlag !== "OK"){
        var useFlag = "3"       // 未发药
    }
    else {
        var useFlag = "4"       // 已发药
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
 * 查询数据
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
 * 查询待发药患者
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
 * 查询条件的JSON
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

/* 点击发药按钮 */
function ClickDispBtn(){
	PHA_COM.CACert("PHAHERBOPFY", ShowHerbDeliveryDiag);	
}

/*
 * 快递窗口打开
 * @method ShowHerbDeliveryDiag
 */
function ShowHerbDeliveryDiag(){
	if ((ComPropData.SelectPYUser == "Y")&&(DHCPHA_CONSTANT.DEFAULT.PYUSER == "")){
		$.messager.alert('提示',"请先选择配药药师再进行发药!","info");
		return;
	}
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要发药的处方!","info");
		return;
	}	
	var dspStatus = gridSelect.TDspStatus;
	if (dspStatus==$g("拒绝发药")){
		$.messager.alert('提示',"该处方已拒绝发药，请取消拒绝后重试","info");
		return;
	}
	var fyFlag = gridSelect.TFyFlag;
	if (fyFlag=="Y"){
		$.messager.alert('提示',"该处方已发药，不能再次发药!","info");
		return;
	}

	var phbdId = gridSelect.TPhbdId ;
	var prescNo = gridSelect.TPrescNo ;
	var prescForm = gridSelect.TPrescTypeCode ;
	var papmi = gridSelect.TPapmi;
	// 处方是否可以发药
	var stateId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", ProDictCode)
	var params = phbdId + tmpSplit + stateId + tmpSplit + gUserID ;
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Biz", "CheckBeforeExe", params, LogonInfo)
	if (chkRet != 0){
		$.messager.alert('提示', chkRet, "info");
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
 * 草药处方发药入口
 * @method ExecuteDisp
 */
function ExecuteDisp(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要发放的处方!","info");
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
				$.messager.alert('提示', retArr[1], 'warning');
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
 * 执行草药处方发药
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
		$.messager.alert('提示', retArr[1], 'warning');
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
 * 草药处方退药(连接出退药界面)
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

/* 点击全发按钮 */
function ClickDispAllBtn(){
	var deliveryFlag = ComPropData.DeliveryFlag ;
	if (deliveryFlag == "Y"){
		$.messager.alert('提示',"已开启快递配送业务，不能使用全发功能","info");
		return;
	}
	var prescRows = $("#gridOutPrescList").datagrid("getRows");
	if (prescRows.length == 0){
		$.messager.alert('提示',"请先查询出需要全发的处方!","info");
		return;
	}
	PHA_COM.CACert("PHAHERBOPAllFY", ExecuteDispAll);	
}

/*
 * 草药处方全发
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
					$.messager.alert('提示', retArr[1], 'warning');
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
 * 草药处方拒发药
 * @method RefuseDisp
 */
function ExecuteRefuseDisp(){
	
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要拒绝发药的处方!","info");
		return;
	}
	var fyFlag = gridSelect.TFyFlag ;		//发药标志
	var dspStatus = gridSelect.TDspStatus ;		//发药状态

	if (fyFlag == "Y"){
		var tipMsg = $g("该处方状态为：") + dspStatus + $g("不能拒绝发药")
		$.messager.alert('提示', tipMsg, "info");
		return;
	}

	if ((dspStatus.indexOf("拒绝发药") > -1)&&(dspStatus.indexOf("申诉") < 0)){
		var tipMsg = $g("该处方状态为：") + dspStatus + "，不能再次拒绝发药"
		$.messager.alert('提示',tipMsg,"info");
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
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		QueryOutPrescList();
	});

}

/*
 * 撤消草药处方拒发药
 * @method CancelRefuse
 */
function CancelRefuse(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要撤消拒绝发药的处方!","info");
		return;
	}
	var dspStatus = gridSelect.TDspStatus ;		//发药状态
	if (dspStatus.indexOf("拒绝发药")<0){
		$.messager.alert('提示',"该处方未拒绝发药，不能撤消拒绝发药!","info");
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
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		QueryOutPrescList();
	});
	
}

/*
 * 草药处方申请煎药费
 * @method ApplyCook
 */
function ApplyCook(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要煎药申请的处方!","info");
		return;
	}
	var CookType=gridSelect.TCookType;
	if (CookType == "") {
		$.messager.alert('提示',"煎药方式为空不允许转换煎药方式！","info");
		return;
	};
	ShowChangeCookType("ApplyCookTypeWin", DoApplyCookType);
}

/*
 * 执行煎药申请 
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
		$.messager.alert('提示', ReqCookMessage, "info");
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
 * 草药处方转换煎药方式
 * @method ChangeCookType
 */
function ChangeCookType(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要转换煎药方式的处方!","info");
		return;
	}
	var CookType=gridSelect.TCookType;
	if (CookType == "") {
		$.messager.alert('提示',"煎药方式为空不允许转换煎药方式！","info");
		return;
	};
	ShowChangeCookType("ChangeCookTypeWin", DoExchange);

}

function DoExchange(ChangeCookJson){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('提示',"请先选中需要转换煎药方式的处方!","info");
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
		$.messager.alert('提示',"转换成功！","info");
		$("#gridOutPrescList").datagrid('updateRow',{
		       index : parseInt(index),
		       row : {
		    	   TCookType: $('#sel-cook').combobox('getText')    //更新的值  
		       }
		   });
	}else{
		$.messager.alert('提示',"转换失败，原因："+RetMessage,"info");
		return;
	}
	
	PrescView(prescNo);
	return;
}

//初始化煎药类型
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

/// 保存煎药费
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
		$.messager.alert('提示',"申请失败，原因："+ message,"info");
	}else{
		/*
		var newcookcost="煎药已申请";
		var newdata={
	    	TCookCost:newcookcost 
	    };
	    var selectid = $("#grid-disp").jqGrid('getGridParam', 'selrow');
		*/
	    //$("#grid-disp").jqGrid('setRowData',selectid,newdata);
		$.messager.alert('提示',"煎药费申请成功！如果之前已经缴纳了煎药费请到收费处退费，然后再缴纳新的煎药费","info");
	}
	SELCOOKTYPE = ""
	return;
}

/*
 * 草药处方补录煎药费用
 * @method AddCookFee
 */
function AddCookFee(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要补录煎药费用的的处方!","info");
		return;
	}
	var CookTypeId = gridSelect.TCookTypeId;
	if(CookTypeId == "") {
		$.messager.alert('提示',"煎药方式为空不能补录煎药费用！","info");
		return;
	};
	/* */
	var dspStatus = gridSelect.TDspStatus ;		//发药状态
	var fyFlag = gridSelect.TFyFlag;
	if (fyFlag=="Y"){
		$.messager.alert('提示',"该处方已发药，不能补录煎药费","info");
		return;
	}
	if (dspStatus==$g("拒绝发药")){
		$.messager.alert('提示',"该处方已拒绝发药，不能补录煎药费!","info");
		return;
	}
	
	var prescNo = gridSelect.TPrescNo;

	ShowAddCookFeeDiag({
		prescNo : prescNo,
		cookType : CookTypeId
	},RetAddFeeInfo);

}

/// 补录煎药费回调方法
/// params : 需要补录的煎药费医嘱信息
function RetAddFeeInfo(retVal){
	return ;
}

/*
 * 清屏
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
 * 置为可退
 * @method SaveAgreeRet
 */
function SaveAgreeRet(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要置为可退的处方!","info");
		return;
	}
	// 置可退权限判断
	if (ComPropData.IfAgreeReturn != "Y"){
		$.messager.alert('提示',"当前登录人没有置可退权限，请核实后重试","info");
		return;
	}
	var agreeRetFlag = gridSelect.TAgreeRetFlag ;		//置可退状态
	if (agreeRetFlag == $g("是")){
		$.messager.alert('提示',"该处方已是可退状态，无需置为可退","info");
		return;
	}
	var phbdId = gridSelect.TPhbdId ;		//置可退状态
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Save", "ChkAgreeReturnState", phbdId)
	var chkRetArr = chkRet.split("^")
	if (chkRetArr[0] < 0) {
		$.messager.alert('提示', chkRetArr[1], 'warning');
		return;
	}
	ShowAgreeRetWin("AgreeRetWin", ExeSaveAgreeRet);
}

/*
*	保存置可退原因
*/
function ExeSaveAgreeRet(AgreeRetJson){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	var remark = AgreeRetJson.agreeRetRemark ;
	var agrRetUserId = gUserID ;	// 当前登录人
	var phbdId = gridSelect.TPhbdId ;
	var params = phbdId + tmpSplit + agrRetUserId + tmpSplit + remark ;
	$.m({
		ClassName: "PHA.HERB.Dispen.Save",
		MethodName: "SaveAgreeRet",
		params: params 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		else {
			$.messager.alert('提示', "置为可退成功", 'success');
		}
		QueryOutPrescList();
		PrescView("") ;
	});
}

/*
/	重新打开处方快递信息弹框
/*/
function ReShowDeliveryDiag(){
	var gridSelect = $("#gridOutPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看配送信息的处方!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;		//发药状态
	var prescForm = gridSelect.TPrescTypeCode;
	var papmi = gridSelect.TPapmi;
	var patname = gridSelect.TPatName;
	var dspStatus = gridSelect.TDspStatus;
	var fyFlag = gridSelect.TFyFlag;

	var warnMsg = "病人姓名:"+ patname +"</br>"+"处方号:"+ prescNo +"</br>"
	if (fyFlag !== "Y"){
		$.messager.alert('提示', warnMsg + "该记录未发药，发药后才允许查看配送信息!", "info");
		return;
	}
	var postTypeStr = tkMakeServerCall("PHA.HERB.Com.Method","GetPostType",prescNo);
	var prescTakeModeDesc = postTypeStr.split("^")[2]
	/* 取药方式为现取现配和空时不会弹出配送信息的框 */
	if ((prescTakeModeDesc == "")||(prescTakeModeDesc == "现取现配")){
		if (prescTakeModeDesc == ""){
			var prescTakeModeDesc = "空"
		}
		$.messager.alert('提示', warnMsg + "该记录取药方式为 “"+ prescTakeModeDesc +"” ，没有配送信息可以查看!", "info");
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
		$.messager.alert('提示',"未开启草药处方快递功能，请先在参数设置中开启配置后重试！", "info");
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
