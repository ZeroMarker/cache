/**
 * @模块:     草药处方护士领药登记
 * @编写日期: 2023-01-03
 * @编写人:   MaYuqiang
 * csp:pha.herb.v2.nursetakereg.csp
 * js: pha/herb/v2/nursetakereg.js
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
PHA_COM.App.ProCode = "HERB"
PHA_COM.App.ProDesc = "草药管理"
PHA_COM.App.Csp = "pha.herb.v2.nursetakereg.csp"
PHA_COM.App.Name = "草药处方护士领药登记"
var ComPropData;	// 公共配置
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var prescArr = []	// 已扫码处方
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;
$(function () {
	InitGridPrescList();
	InitSetDefVal();
	$('#btnExecuteReg').on('click', ExecuteReg);
	$('#btnClear').on('click', Clear);
	
	//处方号回车事件
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				AddPrescInfo(prescNo);
				//ExecuteScan(prescNo)
			}	
		}
	});
	
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
	$('#txtUserCode').val('');
	$('#txtPrescNo').val('');
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
	}, false)
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
				width: 120,
				hidden:false
			}, {
				field: 'TOrdLocDesc',
				title: '开方科室',
				align: 'left',
				width: 120,
				hidden: false
			}, {
				field: 'TPatNo',
				title: '登记号',
				align: 'left',
				width: 100
			}, {
				field: 'TPatName',
				title: '患者姓名',
				align: 'left',
				width: 100,
				hidden:false
			}, {
				field: 'TPatSex',
				title: '患者性别',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TPrescFac',
				title: '付数',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TInstruc',
				title: '用法',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TCookType',
				title: '煎药方式',
				align: 'left',
				width: 80,
				hidden:false
			}, {
				field: 'TDispUser',
				title: '发药人',
				align: 'left',
				width: 100,
				hidden:false
			}, {
				field: 'TDispDate',
				title: '发药日期',
				align: 'left',
				width: 200,
				hidden:false
			}, {
				field: 'TPhbdId',
				title: '业务主表Id',
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
		exportXls: false,
		pagination: false,
		singleSelect: false,
		url: $URL
	};
	PHA.Grid("gridPrescList", dataGridOption);
}

/// 批量执行领取操作
function ExecuteReg(){
	var gridSelectRows = $("#gridPrescList").datagrid("getSelections");
	if (gridSelectRows.length == 0){
		$.messager.alert('提示',"请先选中需要领药登记的处方!","info");
		return;
	}
	var UserCode = $('#txtUserCode').val() ;
	if (UserCode == ""){
		$.messager.alert('提示',"领药人工号不能为空!","info");
		return;	
	}

	for (var pnum = 0; pnum < gridSelectRows.length; pnum++) {
		var gridSelect = gridSelectRows[pnum] ;
        var phbdId = gridSelect.TPhbdId;
		var prescNo = gridSelect.TPrescNo;
		var params = phbdId + tmpSplit + UserCode ;
		var ret = $.m({
			ClassName: "PHA.HERB.NurseTakeReg.Biz",
			MethodName: "ExecuteReg",
			params: params,
			logonInfo: LogonInfo
		}, false);
		
		var retArr = ret.split("^")
		if (retArr[0] == 0) {

		}
		else {
			$.messager.alert('提示', prescNo + retArr[1], 'warning');
			return;
		}
	}
	Clear();
}

/**
 * 草药处方状态执行 扫处方
 * @method AddPrescInfo
 */
function AddPrescInfo(prescNo){	
	var jsonData = $.cm({
			ClassName: "PHA.HERB.NurseTakeReg.Query",
			MethodName: "GetPrescInfo",
			prescNo: prescNo,
			LogonInfo: LogonInfo,
			dataType: 'json'
		}, false);
	
	var retCode = jsonData.retCode ;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert',
			timeout: 2000
		});
		return;
	}
	
	var prescNo = jsonData.TPrescNo ;
	
	if ((prescArr.indexOf(prescNo)>-1)&&(prescArr.length>0)){
		PHA.Popover({
			showType: "show", 
			msg: "该处方于当前界面已经扫过，请勿重复扫码！", 
			type: 'alert', 
			timeout:2000
		});
		return ;
	}
	else {
		prescArr.push(prescNo)	
	}	
	
	$('#gridPrescList').datagrid('insertRow', {
		index: 0,
		row: jsonData
	});
	
	$('#txtPrescNo').val('');	
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$('#gridPrescList').datagrid('clear');
	$('#gridPrescList').datagrid('uncheckAll');
	prescArr = []
}

