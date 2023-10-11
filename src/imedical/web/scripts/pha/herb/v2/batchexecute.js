/**
 * @模块:     草药处方状态批量执行
 * @编写日期: 2020-11-12
 * @编写人:   MaYuqiang
 * csp:pha.herb.v2.batchexecute.csp
 * js: pha/herb/v2/batchexecute.js
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
PHA_COM.App.ProCode = "HERB"
PHA_COM.App.ProDesc = "草药管理"
PHA_COM.App.Csp = "pha.herb.v2.batchexecute.csp"
PHA_COM.App.Name = "草药状态批量执行"
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var combWidth = 160;
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
    PHA_COM.SetPanel('#pha_herb_v2_scanexe', $('#pha_herb_v2_scanexe').panel('options').title);
	InitDict();
	InitSetDefVal();
	InitGridPrescList();
	
	//处方号回车事件
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				AddPrescInfo();
			}	
		}
	});
	//登记号回车事件
	$('#txtBarCode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txtBarCode").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryPreList();
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
	
});

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	//界面配置
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

	$("#dateColStart").datebox("setValue", ComPropData.ExecuteStartDate);
	$("#dateColEnd").datebox("setValue", ComPropData.ExecuteEndDate);
	$('#txtUserCode').val('');
	$('#txtPrescNo').val('');
	$('#txtBarCode').val('');
	$('#txtCardno').val('');
	var CancelExeFlag = ComPropData.CancelExecuteFlag;
	if (CancelExeFlag !== "Y"){
		$("#btnCancelExecute").attr({
            "style": "display:none"
        });
	}
	
}

function InitDict(){
	/// 执行状态列表
	var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
	var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
	var QueryType = "Exe" ;
	PHA.ComboBox("cmbState", {
		url: PHA_HERB_STORE.Process(gLocId,QueryType,gHospId,"","PC").url,
		width: combWidth,
		onLoadSuccess: function(){
			var data = $('#cmbState').combobox('getData');
			if (data.length > 0) {
				//如果有数据的话默认选中第一条数据
				$('#cmbState').combobox('select', data[0].RowId);
			}

		},
		onSelect: function (selData) {
			var selDesc = selData.Description;
			if(selDesc == $g("开始配药")){
				$("#btnAutoExecute").linkbutton('enable');
			}
			else {
				$("#btnAutoExecute").linkbutton('disable');
			}
			QueryPreList();
		}
	});
	// 病区列表
	PHA.ComboBox("cmbWard", {
		width: combWidth,
		url: PHA_STORE.WardLoc().url
	});
	// 医生科室
	PHA.ComboBox('cmbDocLoc', {
        width: combWidth,
        url: PHA_STORE.DocLoc().url
    });
	// 草药处方剂型
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
	});
	// 煎药方式
    PHA.ComboBox('conCookType', {
        width: 122,
        url: PHA_HERB_STORE.CookType('', gLocId).url,
        panelHeight: 'auto'
	});
	// 就诊类型
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O', Description: $g('门急诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {
	    	var admType = $("#conAdmType").combobox("getValue")||'';
			PHA.ComboBox("cmbState", {
				url: PHA_HERB_STORE.Process(gLocId,"Exe",gHospId,admType,"PC").url
			});    
	    }
	});
	// 发药窗口
	PHA.ComboBox('conDispWin', {
		multiple: true,
        width: combWidth,
        rowStyle: 'checkbox',
        url: PHA_HERB_STORE.WindowStore(gLocId).url
    });

	// 已执行
	$('#chk-execute').change(function() {
		if($(this).is(":checked")){
        	$("#btnExecute").linkbutton('disable');
		}
		else {
			$("#btnExecute").linkbutton('enable');
		}
		
	})


}
	
	/**
 * 初始化处方列表
 * @method InitGridOutPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	{
				field:'pdCheck',	
				checkbox: true 
			}, {
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 80,
				hidden:true
			}, {
				field: 'TPrescInfo',
				title: '处方信息',
				align: 'left',
				width: 1700
			}, {
				field: 'TOrdInfo',
				title: '药品信息',
				align: 'left',
				width: 100,
				hidden:true
			}, {
				field: 'TPhbdId',
				title: '草药业务表Id',
				align: 'left',
				width: 70,
				hidden:true
			},{
				field: 'TaltFlag',
				title: '行变色标志',
				align: 'left',
				width: 70,
				hidden:true
			}
			
		]
	];
	
	var dataGridOption = {
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap:false ,
		pagination: false,
		exportXls: false,
		singleSelect: false,
		toolbar: '#gridBatchExeBar',
		rowStyler: HERB.Grid.RowStyler.PersonAlt,
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Execute.Query",
			QueryName: "GetPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			//$("#gridPrescList").datagrid("expandRow",rowIndex);
		},
		groupField:'TPrescNo',
		view: detailview,
		detailFormatter:function(rowIndex, rowData){
			var ordInfo = rowData.TOrdInfo ;
			var ordInfoData = ordInfo.split("&&")
			var num = 0
			var detailHtml = '<div style="padding-top:0px">';
			for (num = 0;num<ordInfoData.length;num++){
				var ordDetailInfo = ordInfoData[num] ;
				var ordDetailData = ordDetailInfo.split("^")
				var inciDesc = ordDetailData[0] ;
				var qty = ordDetailData[1] ;
				var remark = ordDetailData[2] ;
				
				detailHtml += '<div class="herb">';
					detailHtml += '<div class="herb-name">' + inciDesc + '</div>';
					detailHtml += '<div class="herb-remark">' + remark + '</div>';
					detailHtml += '<div class="herb-qty">' + qty + '</div>';
				detailHtml += '</div>'	;				
			}
			detailHtml += '</div>'
			return detailHtml;
			
		},
		/*
		onExpandRow:function(rowIndex, rowData){
			alert(rowIndex)
		},*/
		onLoadSuccess:function(data){
			var row = $("#gridPrescList").datagrid("getRows");
			for (var r = 0; r < row.length; r++)
			{
				$("#gridPrescList").datagrid("expandRow",r);
			}	
		}
	};

	PHA.Grid("gridPrescList", dataGridOption);
}

/**
 * 查询数据
 * @method QueryPreList
 */
function QueryPreList() {
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});	 
	Setfocus();
}

/**
 * 查询条件的JSON
 * @method GetParamsJson
 */
function GetParamsJson() {
	var startDate = $("#dateColStart").datebox('getValue') ;
    var endDate = $("#dateColEnd").datebox('getValue') ;
    var exeDictId = $("#cmbState").combobox("getValue") || '' ;
    if ((startDate == "")||(endDate == "")||(exeDictId == "")){
		$.messager.alert('提示',"日期范围以及执行状态不能为空!","info");
		return;
	}
    return {
        startDate: startDate,
        endDate: endDate,
        loc: gLocId,
        exeDictId: exeDictId,
        ordLocId: $("#cmbDocLoc").combobox("getValue") || '',
        wardLocId: $("#cmbWard").combobox("getValue") || '',
        patNo: $('#txtBarCode').val(),
		prescNo: $('#txtPrescNo').val(),		
		cookType: $('#conCookType').combobox('getValue') || '',
		preFormCode: $('#conForm').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		exeFlag: ($('#chk-execute').checkbox('getValue')==true?'Y':'N') ,
		dispWinStr: ($('#conDispWin').combobox('getValues') || []).join(',')
    };
}


/*
 * 草药处方状态执行
 * @method Execute
 */
function Execute(){
	var gridSelectRows = $("#gridPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('提示',"请先选中需要执行的处方!","info");
		return;
	}
	var UserCode = $('#txtUserCode').val() ;
	if (UserCode == ""){
		$.messager.alert('提示',"药师工号不能为空!","info");
		return;	
	}
	var proDictId = $('#cmbState').combobox("getValue")
	if (proDictId == ""){
		$.messager.alert('提示',"执行状态不能为空!","info");
		return;	
	}
	var proDictDesc = $('#cmbState').combobox("getText") ;
	
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var phbdId = gridSelect.TPhbdId;
		var prescNo = gridSelect.TPrescNo;
		var params = phbdId + tmpSplit + UserCode + tmpSplit + proDictId ;
		//DoExecute(params);
		var ret = $.m({
			ClassName: "PHA.HERB.Execute.Save",
			MethodName: "Execute",
			param: params,
			logonInfo: LogonInfo
		}, false);
		
		var retArr = ret.split("^")
		if (retArr[0] > 0) {
			var printPhbdId = retArr[0];
			var printPYDProCode = ComPropData.PrintPYDProCode;
			var proDictCode =  tkMakeServerCall("PHA.HERB.Com.Data", "GetProCodeById", proDictId)
			if (proDictCode == printPYDProCode){
				HERB_PRINTCOM.PYD(printPhbdId,"");
			}
		}
		else {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}

	}
	QueryPreList();
}

function DoExecute(params){
	var proDictDesc = $('#cmbState').combobox("getText") ;
	$.m({
		ClassName: "PHA.HERB.Execute.Save",
		MethodName: "Execute",
		param: params,
		logonInfo: LogonInfo
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] > 0) {
			var printPhbdId = retArr[0];
			var printPhbdId 
			// 执行获取处方时打印配药单
			if (proDictDesc.indexOf("获取处方")>-1){
				HERB_PRINTCOM.PYD(printPhbdId,"");
			}
		}
		else {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
	});

}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	$('#chk-execute').checkbox("uncheck",true) ;
	$('#txtTimeStep').val("");
	$('#txtCardNo').val("");
	prescrArr = [] ;
	InitDict();
}

/*
 * 草药处方状态自动执行
 * @method CancelExecute
*/
function CancelExecute(){
	var gridSelectRows = $("#gridPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('提示',"请先选中需要撤消执行的处方!","info");
		return;
	}
	var proDictId = $('#cmbState').combobox("getValue")
	if (proDictId == ""){
		$.messager.alert('提示',"执行状态不能为空!","info");
		return;	
	}
	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var phbdId = gridSelect.TPhbdId;
		var prescNo = gridSelect.TPrescNo;
		var params = phbdId +"^"+ proDictId;
		//DoExecute(params);
		var ret = $.m({
			ClassName: "PHA.HERB.Execute.Biz",
			MethodName: "CancelExecute",
			param: params,
			logonInfo: LogonInfo
		}, false);
		
		var retArr = ret.split("^")
		if (retArr[0] == 0) {
			//var printPhbdId = retArr[0];
		}
		else {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}

	}
	QueryPreList();
}

/*
 * 草药处方状态自动执行
 * @method AutoExecute
 */
function StartAutoExecute(){
	
	var timeStep = $("#txtTimeStep").val().trim();
	if (timeStep == "") {
		$.messager.alert('提示', "自动执行的时间间隔不能为空", 'warning');
		return false;
	}
	if ($.trim(timeStep) != "") {
		DHCPHA_CONSTANT.VAR.TIMERSTEP = $("#txtTimeStep").val()*1000;
	}	
	var userCode = $('#txtUserCode').val() ;
	if (userCode == ""){
		$.messager.alert('提示',"执行人工号不能为空!","info");
		return;	
	}
	
	var stateId = $('#cmbState').combobox("getValue") ;
	if (stateId == ""){
		$.messager.alert('提示',"执行状态不能为空!","info");
		return;	
	}
	var stateDesc = $('#cmbState').combobox("getText") ;
	//console.log("stateDesc:"+stateDesc)
	var ret = PHAHERB_COM.Window.Open({
		type:"AutoExe",
		title: $g("正在自动执行") + stateDesc
	},AutoExecute)
	
}

function AutoExecute(){
	$("#"+PHAHERB_COM.Element.AutoExeErrInfo).text("");
	//DHCPHA_CONSTANT.VAR.TIMER = setInterval("AutoPrint()", DHCPHA_CONSTANT.VAR.TIMERSTEP);	
	DHCPHA_CONSTANT.VAR.TIMER = setTimeout("AutoPrint()", DHCPHA_CONSTANT.VAR.TIMERSTEP);	
}


function AutoPrint(){
	
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	var proDictDesc = $('#cmbState').combobox("getText") ;
	var retVal = $.m({
		ClassName: 'PHA.HERB.Execute.Biz',
		MethodName: 'AutoExecute',
		pJsonStr: JSON.stringify(pJson),
		userCode: $('#txtUserCode').val(),
		logonInfo: LogonInfo
	},false);

	/* 返回值异常时结束轮询 */
	if (typeof retVal === 'undefined') {
		//clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
		StopAutoExe();
		return ;	
	}

	var retArr = retVal.split("$$");
	var prtInfo = retArr[0];
	var errInfo = retArr[1];
	
	if (errInfo!=""){
		var errInfoData=$("#"+PHAHERB_COM.Element.AutoExeErrInfo).text();
		if(errInfoData!="") {
			errInfo=errInfo+" \n"+errInfoData
		}
		$("#"+PHAHERB_COM.Element.AutoExeErrInfo).text(errInfo)
	}	
	DHCPHA_CONSTANT.VAR.TIMER = setTimeout("AutoPrint()", DHCPHA_CONSTANT.VAR.TIMERSTEP);	
}

// 停止自动配药
function StopAutoExe(){
	//clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
	if(PHAHERB_COM.Window.ComInfo.winId){
        $('#'+ PHAHERB_COM.Window.ComInfo.winId ).window('close');
    }

}

//读卡
function BtnReadCardHandler() {
	/*
	var readcardoptions = {
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	PHA_COM.ReadCard(readcardoptions, setTimeout("QueryPreList()",100)) ; 
	*/
	PHA_COM.ReadCard({
        CardNoId : "txtCardNo",
        PatNoId : "txtBarCode"
    },QueryPreList)
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

//载入数据
window.onload=function(){
	//setTimeout("QueryPreList()",500);
}
