/**
 * @模块:     煎药室-药袋装箱
 * @编写日期: 2021-03-01
 * @编写人:   MaYuqiang
 */
var NowTAB = ""; 	//记录当前页签的tab
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
var curDeptId = ""	//本次物流箱接受科室(门诊->药房;住院->病区)
var curDeptDesc = ""
var prescrArr = []	// 处方数组
var LogonInfo = gGroupId + "^" + locId + "^" + opUser + "^" + gHospID;
var HDDActiveFlag = tkMakeServerCall("web.DHCST.Common.AppCommon", "GetAppPropValue","HDD.COMMON","SystemActiveFlag",LogonInfo)
$(function () {
	InitDict();
	InitGridScanPresc();
	InitGridBatchPresc();
	// 处方号回车事件
	$("#txtBarCode").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var barCode = $.trim($("#txtBarCode").val());
			if (barCode == "") {
				PHA.Popover({
					msg: "处方号为空！",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			}
			AddBarCodeInfo(barCode);
			$(this).val("");
		}
	})
	// 登记号回车事件
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				query();
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
	// 绑定选中事件,切换页签自动查询
	$("#dispTab").tabs({
		onSelect: function(title, index){
			var tabId = $('#dispTab').tabs('getSelected').attr("id");
			if (title == "扫码装箱"){
				NowTAB = tabId
				$('#txtBarCode').focus();
				$("#dateStart").datebox("setValue", "");
				$("#dateEnd").datebox("setValue", "");
				$('#timeStart').timespinner('setValue', "");
				$('#timeEnd').timespinner('setValue', "");
				$HUI.datebox("#dateStart").disable();
				$HUI.datebox("#dateEnd").disable();
				$HUI.timespinner("#timeStart").disable();
				$HUI.timespinner("#timeEnd").disable();
				$('#txtCardNo').val("").prop('disabled', true);
				$('#txtPatNo').val("").prop('disabled', true);
			}
			else {
				NowTAB = tabId
				$.cm({	
					ClassName: "PHA.DEC.Com.Method", 
					MethodName: "GetAppProp", 
					UserId: gUserID, 
					LocId: gLocId, 
					SsaCode: "DEC.OUTDISP", 
					AppCode:""
					}, function(AppPropData){
						$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
						$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
						$('#timeStart').timespinner('setValue', "00:00:00");
						$('#timeEnd').timespinner('setValue', "23:59:59");
					
						$HUI.datebox("#dateStart").enable();
						$HUI.datebox("#dateEnd").enable();
						$HUI.timespinner("#timeStart").enable();
						$HUI.timespinner("#timeEnd").enable();
						$('#txtCardNo').val("").prop('disabled', false);
						$('#txtPatNo').val("").prop('disabled', false);
						queryBatchPrescList() ;
				});
			}
			
		}
	})
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	PHA.ComboBox("cmbDecLoc", {
		width: '120',
		url: PHA_DEC_STORE.DecLoc().url,
		onLoadSuccess: function() {
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		}  
	});
	PHA.ComboBox("cmbPhaLoc", {
		width: '120',
		url: PHA_DEC_STORE.Pharmacy("").url,
		onLoadSuccess: function() {
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});
	PHA.ComboBox("cmbWardLoc", {
		width: '155',
		url: PHA_STORE.WardLoc("","").url,
		onLoadSuccess: function() {
			//$("#cmbWardLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});	
	
	// 就诊类型
    PHA.ComboBox('cmbAdmType', {
        width: '155',
        data: [
            { RowId: 'O', Description: $g('门诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onLoadSuccess: function(data) {
			//$("#cmbAdmType").combobox("setValue", "O");
		} 
	});
	//卡类型
	PHA.ComboBox("cmbCardType", {
		width: '110',
		url: PHA_DEC_STORE.CardType("").url,
		onLoadSuccess: function(data) {
			var data = $("#cmbCardType").combobox("getData")
			$.each(data, function(key, val){
				var defaultflag = val.RowId.split("^")[8];
				if(defaultflag=="Y"){
					$("#cmbCardType").combobox("setValue", val.RowId);
				}
			})	
		} 
	});
	// 设置默认值
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, function(AppPropData){
			var tabId= $('#dispTab').tabs('getSelected').attr("id");
			if (NowTAB == "tabScanDisp"){
				return ;	
			}
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
			//$("#txtBarCode").focus();
		});
		
	$("#dispTab").tabs("select",parseInt(ComPropData.OperateModel));	
	var tabId = $('#dispTab').tabs('getSelected').attr("id");
	NowTAB = tabId;	
	if (NowTAB == "tabScanDisp"){
		$('#txtBarCode').focus();
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue', "");
		$('#timeEnd').timespinner('setValue', "");
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$('#txtCardNo').val("").prop('disabled', true);
		$('#txtPatNo').val("").prop('disabled', true);	
	}
	else {
		$.cm({	
			ClassName: "PHA.DEC.Com.Method", 
			MethodName: "GetAppProp", 
			UserId: gUserID, 
			LocId: gLocId, 
			SsaCode: "DEC.OUTDISP", 
			AppCode:""
			}, function(AppPropData){
				$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
				$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
				$('#timeStart').timespinner('setValue', "00:00:00");
				$('#timeEnd').timespinner('setValue', "23:59:59");
				$HUI.datebox("#dateStart").enable();
				$HUI.datebox("#dateEnd").enable();
				$HUI.timespinner("#timeStart").enable();
				$HUI.timespinner("#timeEnd").enable();
				$('#txtCardNo').val("").prop('disabled', false);
				$('#txtPatNo').val("").prop('disabled', false);
			});	
	}
}
/**
 * 初始化扫码装箱处方列表
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [[ 
		{
			field:'pdCheck',
			checkbox: true	
		},
		{	field:'pdpmItmId',		
			title:'pdpmItmId',		
			hidden:'true',	
			width: 50
		},
		{
			field:'prescNo', 	
			title:'处方号',	  	
			align:'left', 
			width: 130
		},
		{
			field:'locDesc', 	
			title:'药房/病区',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'dispNum',	
			title:'发放付数',		
			align:'left', 
			width: 80
		},
		{
			field:'dispUserName',	
			title:'发放人员',		
			align:'left', 
			width: 80
		},
		{
			field:'dispDateTime',	
			title:'发放时间',		
			align:'left', 
			width: 120
		},
		{
			field:'patNo',		
			title:'登记号',		
			align:'left', 
			width: 100
		}, 
		{
			field:'patName',	
			title:'患者姓名',	
			align:'left', 
			width: 100
		}, 
		{
			field:'preFacTor',	
			title:'总付数',		
			align:'right', 
			width: 60
		}, 
		
		{
			field:'decTypeDesc', 	
			title:'就诊类型', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'收方时间', 	
			align:'left', 
			width: 150
		},
		{
			field:'preCount',	
			title:'味数',		
			align:'right', 
			width: 45
		}, 
		{
			field:'preForm',	
			title:'处方剂型',	
			align:'left', 
			width: 80
		}, 
		{
			field:'preEmFlag',	
			title:'是否加急',	
			align:'left', 
			width: 65
		}, 
		{
			field:'phaLocDesc',	
			title:'调剂科室',	
			align:'left', 
			width: 100
		}, 
		{
			field:'operUserName',	
			title:'调剂人',		
			align:'left', 
			width: 80
		},
		{
			field:'operDate',	
			title:'调剂时间',	
			align:'left', 
			width: 150
		},
		{
			field:'cookCost',	
			title:'煎药费',		
			align:'right', 
			width: 150,
			nowrap:false
		},
		{	field:'locId',		
			title:'药房/病区Id',		
			hidden:'true',	
			width: 50
		}
	]];
	var dataGridOption = {
		url: '',
		rownumbers: true,
		toolbar: '#gridScanDispBar',
		columns: columns,
		pagination: false,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		exportXls: false,
		nowrap:false
	};
	PHA.Grid("gridScanPresc", dataGridOption);
}

/**
 * 初始化扫码发放处方列表
 * @method InitGridBatchPresc
 */
function InitGridBatchPresc() {
	var columns = [[ 
		{
			field:'pdCheck',
			checkbox: true	
		},
		{	field:'pdpmItmId',		
			title:'pdpmItmId',		
			hidden:'true',	
			width: 50
		},
		{
			field:'prescNo', 	
			title:'处方号',	  	
			align:'left', 
			width: 130
		},
		{
			field:'locDesc', 	
			title:'药房/病区',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'dispNum',	
			title:'发放付数',		
			align:'left', 
			width: 80
		},
		{
			field:'dispUserName',	
			title:'发放人员',		
			align:'left', 
			width: 80
		},
		{
			field:'dispDateTime',	
			title:'发放时间',		
			align:'left', 
			width: 120
		},
		{
			field:'patNo',		
			title:'登记号',		
			align:'left', 
			width: 100
		}, 
		{
			field:'patName',	
			title:'患者姓名',	
			align:'left', 
			width: 100
		}, 
		{
			field:'preFacTor',	
			title:'总付数',		
			align:'right', 
			width: 60
		}, 
		
		{
			field:'decTypeDesc', 	
			title:'就诊类型', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'收方时间', 	
			align:'left', 
			width: 150
		},
		{
			field:'preCount',	
			title:'味数',		
			align:'right', 
			width: 45
		}, 
		{
			field:'preForm',	
			title:'处方剂型',	
			align:'left', 
			width: 80
		}, 
		{
			field:'preEmFlag',	
			title:'是否加急',	
			align:'left', 
			width: 65
		}, 
		{
			field:'phaLocDesc',	
			title:'调剂科室',	
			align:'left', 
			width: 100
		}, 
		{
			field:'operUserName',	
			title:'调剂人',		
			align:'left', 
			width: 80
		},
		{
			field:'operDate',	
			title:'调剂时间',	
			align:'left', 
			width: 150
		},
		{
			field:'cookCost',	
			title:'煎药费',		
			align:'right', 
			width: 150,
			nowrap:false
		},
		{	field:'locId',		
			title:'药房/病区Id',		
			hidden:'true',	
			width: 50
		}
	]];
	var dataGridOption = {
		toolbar: '#gridDispBatchBar',
		columns: columns,
		url: $URL,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		rownumbers: true,		
		queryParams: {
			ClassName: "PHA.DEC.DecPack.Query",
			QueryName: "QueryPrescList",
			pJsonStr: ''
		},
		onLoadSuccess: function () {
			$('#gridBatchPresc').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridBatchPresc", dataGridOption);
}

/**
 * 查询待装箱数据
 * @method query
 */
function query(){
	queryBatchPrescList() ;
}

/**
 * 扫码发放：查询待发放数据
 * @method queryPrtLabList
 */
function AddBarCodeInfo(barCode){	
	var pJson = GetParamsJson();
	var jsonArr = $.cm({
			ClassName: "PHA.DEC.DecPack.Query",
			MethodName: "GetBarCodeInfo",
			BarCode: barCode,
			pJsonStr: JSON.stringify(pJson),
			HospId: gHospID ,
			dataType: 'json'
		}, false);
	
	var jsonData = jsonArr[0] ;
	var jsonData = JSON.parse(jsonData)
	var retCode = jsonData.retCode ;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert'
		});
		return;
	}
	
	var deptId = jsonData.locId ;
	var prescNo = jsonData.prescNo ;
	
	if ((prescrArr.indexOf(prescNo)>-1)&&(prescrArr.length>0)){
		PHA.Popover({showType: "show", msg: "该处方于当前界面已经扫过，请勿重复扫码！", type: 'alert', timeout:2000});
		return ;
	}
	else {
		prescrArr.push(prescNo)	
	}
	
	if (curDeptId !== ""){
		if (curDeptId !== deptId){
			PHA.Popover({showType: "show", msg: "当前扫描处方非 "+curDeptDesc+" 的处方，与之前扫描药袋不一致！", type: 'alert', timeout:3000});
			return;	
		}
	}
	else {
		curDeptId = deptId
		curDeptDesc	= jsonData.locDesc
	}	
	
	for (var i = 0; i < jsonArr.length; i++){
		var jsonData = jsonArr[i] ;
		var jsonData = JSON.parse(jsonData) ;
		$('#gridScanPresc').datagrid('insertRow', {
			index: 0,
			row: jsonData
		});		
	}
		
}

/**
 * 批量发放：查询待发放数据
 * @method queryPrtLabList
 */
function queryBatchPrescList(){
	$('#gridBatchPresc').datagrid('clear');
	var pJson = GetParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridBatchPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}


/**
 * 获取扫码发放界面元素值
 * @method GetQueryParamsJson
 */
function GetParamsJson() {
	var startDate = $("#dateStart").datebox('getValue')||'' ;
	var endDate = $("#dateEnd").datebox('getValue')||''
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	var phaLocId = $('#cmbPhaLoc').combobox("getValue") || "";
	var admType = $('#cmbAdmType').combobox("getValue") || "";
	var wardLocId = $('#cmbWardLoc').combobox("getValue") || "";
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
	
	if (admType == ""){
		PHA.Popover({showType: "show", msg: "就诊类型不能为空！", type: 'alert', timeout:2000});
		return "";	
	}
	if (decLocId == ""){
		PHA.Popover({showType: "show", msg: "煎药室不能为空！", type: 'alert', timeout:2000});
		return "";	
	}
	if ((phaLocId == "")&&(admType == "O")){
		PHA.Popover({showType: "show", msg: "就诊类型为门诊时药房科室不能为空！", type: 'alert', timeout:2000});
		return "";	
	}
	if ((wardLocId == "")&&(admType == "I")){
		PHA.Popover({showType: "show", msg: "就诊类型为住院时病区不能为空！", type: 'alert', timeout:2000});
		return "";	
	}if ((wardLocId != "")&&(admType == "O")){
		PHA.Popover({showType: "show", msg: "就诊类型为门诊时不能再按照病区查询！", type: 'alert', timeout:2000});
		return "";	
	}
	if (tabId !== "tabScanDisp"){
		if ((startDate == "")||(endDate == "")){
			PHA.Popover({showType: "show", msg: "开始日期、截止日期不能为空！", type: 'alert'});
			return "";
		}
	}
    return {
		patNo : $('#txtPatNo').val(),
		startDate : startDate ,
		endDate : endDate ,
		startTime : $('#timeStart').timespinner('getValue')||'' ,
		endTime : $('#timeEnd').timespinner('getValue')||'' ,
		phaLocId : phaLocId ,
		decLocId : decLocId ,
		admType : admType ,
		wardLocId : wardLocId,
		logonLocId : locId

    };
}

//读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtPatNo"
	}
	PHA_COM.ReadCard(readcardoptions, query) ; 
}

/**
 * 确认装箱
 * @method Pack
 */
function Pack() {
	
	var decLocId = $('#cmbDecLoc').combobox("getValue")||'' ;
	if (decLocId == ""){
		PHA.Popover({ showType: "show",	msg: "物流箱出发科室不能为空，即煎药室不能为空！", type: 'error'});	
		return ;
	}
	var decType = $('#cmbAdmType').combobox("getValue") || "";
	if ((decType == "O")||(HDDActiveFlag == "Y")){
		var toLocId = $('#cmbPhaLoc').combobox("getValue") || "";
		if (toLocId == ""){
			PHA.Popover({ showType: "show",	msg: "物流箱接收科室不能为空，即药房科室不能为空！注：开启汤剂发放系统之后住院药袋不能发放到病区。", type: 'error'});	
			return ;
		}
	}
	else{
		var toLocId = $('#cmbWardLoc').combobox("getValue") || "";	
		if (toLocId == ""){
			PHA.Popover({ showType: "show",	msg: "物流箱接收科室不能为空，即病区不能为空！", type: 'error'});	
			return ;
		}
	}
	
	var boxStatus = "10"
	// 物流箱主信息
	var mainData = decLocId + "^" + toLocId + "^" + gUserID + "^" + boxStatus
	
	var preList = GetCheckedPreArr() ;
	if (preList == ""){
		PHA.Popover({ showType: "show",	msg: "未获取到待装箱信息", type: 'error'});	
		return ;
	}
		
	$cm({
		ClassName: "PHA.DEC.DecPack.OperTab",
		MethodName: "SavePack",
		params: mainData,
		preList: preList,
		logonInfo: LogonInfo,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
			return ;
		}else{
			PHA.Popover({ showType: "show",	msg: "装箱成功！", type: 'success' });
			PrintBoxLabel(result) ;
			
			DeleteCheckRows() ;
			return ;
		}
		
	});	
	
}

/**
 * 获取选中待装箱记录
 * @method SaveBat
 */
function GetCheckedPreArr() {
	var batPreArr = [];
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
	if (tabId == "tabScanDisp"){
		var selData = $("#gridScanPresc").datagrid("getChecked");
	}
	else {
		var selData = $("#gridBatchPresc").datagrid("getChecked");
	}
	if (selData==null){
		PHA.Popover({showType: "show", msg: "请先选择需要装箱的处方！", type: 'alert'});
		return;
	}
	
	for (var i = 0; i < selData.length; i++) {
		var checkedData = selData[i];
		var pdpmItmId = checkedData.pdpmItmId ;
		var dispNum = checkedData.dispNum ;
		var prescNo = checkedData.prescNo ;
		var dataStr = pdpmItmId + "^" + dispNum + "^" + prescNo;
		if (batPreArr.indexOf(dataStr) < 0) {
			batPreArr.push(dataStr);
		}
	}
	return batPreArr.join("!!");
}

/**
 * 已发放查询界面清屏
 * @method Clear
 */
function Clear(){
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	$('#txtBarCode').val("");
	$('#txtPatNo').val("");
	$('#txtCardNo').val("");
	$("#cmbAdmType").combobox("setValue", "");
	$('#cmbWardLoc').combobox("setValue","") ;
	$('#gridScanPresc').datagrid('clear');
	$('#gridScanPresc').datagrid('uncheckAll');
	$('#gridBatchPresc').datagrid('clear');
	$('#gridBatchPresc').datagrid('uncheckAll');
	$("#txtBarCode").focus();
	prescrArr = []
	if (NowTAB == "tabScanDisp"){
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue', "");
		$('#timeEnd').timespinner('setValue', "");
		
	}
	else {
		$.cm({	
			ClassName: "PHA.DEC.Com.Method", 
			MethodName: "GetAppProp", 
			UserId: gUserID, 
			LocId: gLocId, 
			SsaCode: "DEC.OUTDISP", 
			AppCode:""
			}, function(AppPropData){
				$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
				$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
				$('#timeStart').timespinner('setValue', "00:00:00");
				$('#timeEnd').timespinner('setValue', "23:59:59");
				
			});	
	}
}

/**
 * 删除选中行
 * @method DeleteCheckRows
 */
function DeleteCheckRows() {
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
	if (tabId == "tabScanDisp"){
		var gridId = "gridScanPresc" ;
	}
	else {
		var gridId = "gridBatchPresc" ;
	}
	var $grid = $("#" + gridId);
	var checkData = $grid.datagrid("getChecked");
	var length = checkData.length ;
	if(length == 0){
		return ;
	}
	
	for (var i = (length - 1); i >= 0; i--) {
		var row = $grid.datagrid('getRowIndex', checkData[i]);
		$grid.datagrid('deleteRow',row);
	}
	$grid.datagrid('uncheckAll');
	return ;	
}

