/**
 * @模块:     草药房拒绝发药查询
 * @编写日期: 2021-08-09
 * @编写人:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var SessionWard = session['LOGON.WARDID'] || "";
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_queryrefusedisp', $('#pha_herb_v2_queryrefusedisp').panel('options').title);
	InitDict();
	InitGridRefuseDisp();
	InitSetDefVal();
	//登记号回车事件
	$('#conPatNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#conPatNo").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				queryRefuseDisp();
			}	
		}
	});
	if (SessionWard !="") {
    	$("#cancelRefuse").parent().css('visibility','hidden');
    }
});
//alert("EpisodeID:"+EpisodeID)
window.onload = function () {
    if (EpisodeID != '') {
        var patinfo = tkMakeServerCall('web.DHCSTPharmacyCommon', 'GetPatInfoByAdm', EpisodeID);
        patinfo = JSON.parse(patinfo);
        patinfo = patinfo[0];
        $('#conPatNo').val(patinfo.PatNo);
        queryRefuseDisp();
    }
    //Query();
};

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

    $("#conStartDate").datebox("setValue", ComPropData.QueryStartDate);
    $("#conEndDate").datebox("setValue", ComPropData.QueryEndDate);
	$('#conStartTime').timespinner('setValue', ComPropData.QueryStartTime);
	$('#conEndTime').timespinner('setValue', ComPropData.QueryEndTime);
	if (session['LOGON.WARDID'] == ""){
		$("#conPhaLoc").combobox("setValue", gLocId);
	}
	else {
		$("#conPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);
	}
	
}

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict(){
	var combWidth = 160;
	$('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '00:00:00');
    $('#conEndTime').timespinner('setValue', '23:59:59');
    // 发药科室
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('').url,
		panelHeight: 'auto',
		width: combWidth,
        onLoadSuccess: function (data) {
            //$(this).combobox('selectDefault', gLocId);
        }
    });
    
}

/**
 * 初始化拒发药查询Grid
 * @method InitGridRefuseDisp
 */
function InitGridRefuseDisp() {
	var columns = [[ 
		{
			field: 'phaomId',	
			title: '审核表Id',	
			align: 'left', 
			width: 100,
			hidden: true
		},{
			field: 'TPapmi',	
			title: '患者id',	
			align: 'left', 
			width: 100,
			hidden: true
		},{
			field: 'TPatName',	
			title: '患者姓名',	
			align: 'left', 
			width: 100
		},{
			field: 'TPatNo',	
			title: '登记号',	
			align: 'left', 
			width: 100
		},
		{
			field: 'TPhaLocId',		
			title: '发药科室Id',		
			align: 'left', 
			width: 100,
			hidden: true
		},
		{
			field: 'TPhaLocDesc',	
			title: '发药科室',
			align: 'left', 
			width: 100
		},
		{
			field: 'TAdmLocDesc',	
			title: '病区/医生科室',
			align: 'left', 
			showTip: true,
			tipWidth: 200,
			width: 120
		},
		{
			field: 'TPrescNo',
			title: '处方号', 	
			align: 'left', 
			width: 150
		},
		{
			field: 'TPrescState',
			title: '医嘱状态', 	
			align: 'left', 
			width: 100
		},
		{
			field: 'TOrdDateTime',
			title: '下医嘱时间', 	
			align: 'left', 
			width: 200
		},
		{
			field: 'TRefuseUserName',
			title: '拒绝人', 	
			align: 'left', 
			width: 100
		},
		{
			field: 'TRefuseDateTime', 	
			title: '拒绝时间', 	
			align: 'left',
			width: 200
		},
		{
			field: 'TRefuseReason', 	
			title: '拒绝原因', 	
			align: 'left', 
			showTip: true,
			width: 200
		},
		{
			field: 'TPhaomAppType', 	
			title: '拒绝类型', 	
			align: 'left', 
			width: 100,
			hidden: true
		}
	]];
	var dataGridOption = {
		fit: true,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarRefuseDisp',
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.RefuseDisp",
			QueryName: "QueryRefuseDisp",
		},
		rownumbers: true
	};
	PHA.Grid("gridRefuseDisp", dataGridOption);
}
/**
 * 查询草药房工作量
 * @method queryPrtLabList
 */
function queryRefuseDisp(){
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridRefuseDisp').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});
}

/**
 * 查询条件的JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	if (session['LOGON.WARDID'] == ""){
		var wardLocId = ""
	}
	else {
		var wardLocId = gLocId
	}
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		patNo: $('#conPatNo').val(),
		wardLocId: wardLocId
    };
}

/*
 * 撤消拒绝
 * @method cancelRefuse
 */
function cancelRefuse(){
	var gridSelect = $("#gridRefuseDisp").datagrid("getSelected");
	if (gridSelect == null){
		$.messager.alert('提示',"请先选中需要撤消拒绝发药的处方!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo;
	var type = gridSelect.TPhaomAppType;
	var phaomId = gridSelect.phaomId;
	var params = gUserID + tmpSplit + prescNo + tmpSplit + type + tmpSplit + phaomId ;
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
		queryRefuseDisp();
	});
	
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	$('#gridRefuseDisp').datagrid('clear');
	InitSetDefVal();
	$('#conPatNo').val("");
}
