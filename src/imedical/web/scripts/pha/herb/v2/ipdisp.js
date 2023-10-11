/**
 * @模块:     住院草药处方发药
 * @编写日期: 2020-11-14
 * @编写人:   MaYuqiang
 */
DHCPHA_CONSTANT.DEFAULT.APPTYPE="HERBIR";
DHCPHA_CONSTANT.DEFAULT.PYUSER="";
PHA_COM.Val.CAModelCode = "PHAHERBIPFY"; 
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
var ProDictCode = "Dispen"
var PYDictCode = "CompleteDisp"
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_ipdisp', $('#pha_herb_v2_ipdisp').panel('options').title);
	InitDict();
	InitSetDefVal();
	InitGridInPrescList();
	InitGridWardList();
	InitEvent();            //  按钮事件
	ResizePanel();          //  布局调整
	//$('#btnDisp').on('click', ExecuteDisp);
	
	$("#tabsForm").tabs({
        onSelect: function(title) {		    			
			var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
					$('#ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp'+'?EpisodeID=' + EpisodeId+'&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
				} 
			}
        }
    });
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbWard", {
		url: PHA_STORE.WardLoc().url,
		//width:155
	});
	
}

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
	
	$("#dateColStart").datebox("setValue", ComPropData.IPDispStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.IPDispEndDate);
	$('#timeColStart').timespinner('setValue', "00:00:00");
	$('#timeColEnd').timespinner('setValue', "23:59:59");
	/* 初始化配药人选择 */ 
	if (ComPropData.SelectPYUser == "Y"){
		InitPYUserDialog({callback: RetPYUserInfo});	// 配药药师
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
/* 按钮事件 */
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
	
	//登记号回车事件
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
            height: 0.6 
        });
    }, 0);
}

/**
 * 初始化处方列表
 * @method InitGridInPrescList
 */
function InitGridInPrescList() {
	var columns = [
		[	{
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
				width: 90
			}, {
				field: 'TEmergFlag',
				title: '是否加急',
				align: 'left',
				width: 80
			}, {
				field: 'TWardLoc',
				title: '病区',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TBedNo',
				title: '床号',
				align: 'left',
				width: 60
			}, {
				field: 'TPatName',
				title: '姓名',
				align: 'left',
				showTip: true,
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
				showTip: true,
				width: 80
			}, {
				field: 'TPrescTakeMode',
				title: '取药方式',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TCookType',
				title: '煎药方式',
				align: 'left',
				width: 80
			}, {
				field: 'TFactor',
				title: '付数',
				align: 'left',
				width: 50
			}, {
				field: 'TSeekUserName',
				title: '提交护士',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TSeekDate',
				title: '提交时间',
				align: 'left',
				showTip: true,
				width: 100
			}, {
				field: 'TPhaomName',
				title: '审核药师',
				align: 'left',
				width: 100,
				hidden: true
			}, {
				field: 'TPhaomDate',
				title: '审核时间',
				align: 'left',
				showTip: true,
				width: 100,
				hidden: true
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
				field: 'TDiag',
				title: '诊断',
				align: 'left',
				showTip: true,
				width: 180
			}, {
				field: 'TWardLocId',
				title: '病区Id',
				align: 'left',
				width: 180,				
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
				field: 'druguseresult',
				title: '合理分析结果',
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
			}, {
				field: 'TFyFlag',
				title: '发药标志',
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
 * 初始化处方列表
 * @method InitGridWardList
 */
function InitGridWardList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			},{
				field: 'TWardLocId',
				title: '病区Id',
				align: 'left',
				width: 70,
				hidden: true
			}, {
				field: 'TWardLocDesc',
				title: '病区名称',
				align: 'left',
				showTip: true,
				width: 130
			}, {
				field: 'TPrescNum',
				title: '处方数量',
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
 * 查询数据
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
 *  查询条件的JSON
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
 *  获取病区列表勾选的病区
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

/* 点击发药按钮 */
function ClickDispBtn(){
	PHA_COM.CACert("PHAHERBIPFY", ShowHerbDeliveryDiag);	
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
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要发药的处方!","info");
		return;
	}	
	var dspStatus = gridSelect.TDspStatus;
	var fyFlag = gridSelect.TFyFlag;
	if (dspStatus==$g("拒绝发药")){
		$.messager.alert('提示',"该处方已拒绝发药，请取消拒绝后重试","info");
		return;
	}
	if (fyFlag=="Y"){
		$.messager.alert('提示',"该处方已发药，不能再次发药!","info");
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
 * 草药处方发药
 * @method ExecuteDisp
 */
function ExecuteDisp(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	QueryInPrescList();
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
	var prescRows = $("#gridInPrescList").datagrid("getRows");
	if (prescRows.length == 0){
		$.messager.alert('提示',"请先查询出需要全发的处方!","info");
		return;
	}
	PHA_COM.CACert("PHAHERBIPAllFY", ExecuteDispAll);	
}

/*
 * 全发
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
				$.messager.alert('提示', retArr[1], 'warning');
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
 * 草药处方拒发药
 * @method RefuseDisp
 */
function ExecuteRefuseDisp(){
	
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要拒发的处方!","info");
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
		var tipMsg = "该处方已" + dspStatus + "，不能再次拒绝发药"
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
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		QueryInPrescList();
	});

}



/*
 * 撤消草药处方拒发药
 * @method CancelRefuse
 */
function CancelRefuse(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
		QueryInPrescList();
	});
	
}

/*
 * 清屏
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
 * 置为可退
 * @method SaveAgreeRet
 */
function SaveAgreeRet(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
		QueryInPrescList();
		PrescView("") ;
	});
}


/*
 * 草药处方申请转换
 * @method ChangeCookType
 */
function ChangeCookType(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要转换煎药方式的处方!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
	var phbdId = gridSelect.TPhbdId;
	var cookType = gridSelect.TCookTypeId;
	if ((cookType == "")||(cookType == 0)) {
		$.messager.alert('提示',"煎药方式为空不允许转换煎药方式！","info");
		return;
	};
	var cookTypeDesc = gridSelect.TCookType;
	ShowChangeCookType("ChangeCookTypeWin", DoExchange);

}

//初始化煎药类型
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
		$.messager.alert('提示',"请先选中需要转换煎药方式的处方!","info");
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
		$.messager.alert('提示',"转换成功！","info");
		$("#gridInPrescList").datagrid('updateRow',{
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

//读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, QueryInPrescList()) ; 
}



/*
/	重新打开处方快递信息弹框
/*/
function ReShowDeliveryDiag(){
	var gridSelect = $("#gridInPrescList").datagrid("getSelected");
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
	QueryInPrescList();
	return ;	
}

function RetPYUserInfo(param){	
	var pyUserId = param.pyUserId;	
	var pyUserDesc = param.pyUserName;
	
	$("#pyUserName").text(pyUserDesc);
	DHCPHA_CONSTANT.DEFAULT.PYUSER = pyUserId;
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
			setTimeout("QueryInPrescList()",500);
		}
	}
	else {
		setTimeout("QueryWardList()",500);
	}
	
}
