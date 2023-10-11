/**
 * @模块:     草药处方状态扫码执行
 * @编写日期: 2021-04-23
 * @编写人:   MaYuqiang
 * csp:pha.herb.v2.scanexecute.csp
 * js: pha/herb/v2/scanexecute.js
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
PHA_COM.App.ProCode = "HERB"
PHA_COM.App.ProDesc = "草药管理"
PHA_COM.App.Csp = "pha.herb.v2.scanexecute.csp"
PHA_COM.App.Name = "草药状态扫码执行"
var ComPropData;	// 公共配置
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var prescArr = []	// 已扫码处方
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID ;
var PAPMINUM = 0;	// 患者顺序号
var CURPAPMI = "";
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_scanexe', $('#pha_herb_v2_scanexe').panel('options').title);
	InitGridPrescList();
	InitSetDefVal();
	InitDict();
	$('#btnExecute').on('click', Execute);
	$('#btnClear').on('click', Clear);
	
	//处方号回车事件
	$('#txtPrescNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var prescNo=$.trim($("#txtPrescNo").val());
			if (prescNo!=""){
				//AddPrescInfo(prescNo);
				ExecuteScan(prescNo)
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

function InitDict(){
	/// 执行状态列表	
	var QueryType = "Exe" ;
	PHA.ComboBox("cmbState", {
		url: PHA_HERB_STORE.Process(gLocId,QueryType,gHospId,"","PC").url,
		width: 155,
		onLoadSuccess: function(){
			
		},
		onSelect: function (selData) {
			$('#gridPrescList').datagrid('uncheckAll');
			$('#gridPrescList').datagrid('clear');
			prescArr = [] ;
			PAPMINUM = 0;
			CURPAPMI = "";
		}
	});
	//$("#chk-autoexe").parent().css('visibility','hidden');

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
				field: 'TPrescState',
				title: '当前状态',
				align: 'left',
				width: 100,
				hidden: true
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
			},{
				field: 'TPapmiNum',
				title: '患者顺序号',
				align: 'left',
				width: 70,
				hidden:true
			},{
				field: 'TPapmi',
				title: '患者id',
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
		toolbar: '#gridScanExeBar',
		rowStyler: HERB.Grid.RowStyler.PersonAlt,
		url: $URL,
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

/// 扫描执行
function ExecuteScan(prescNo){
	console.log("prescNo:"+prescNo);
	// 验证扫描处方
	var pJson = GetParamsJson();
	var jsonData = $.cm({
			ClassName: "PHA.HERB.Execute.Query",
			MethodName: "GetPrescInfo",
			prescNo: prescNo,
			pJsonStr: JSON.stringify(pJson),
			exeFlag: "N" ,
			HospId: gHospID ,
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
	//var prescNo = jsonData.TPrescNo ;
	var phbdId = jsonData.TPhbdId ;
	PAPMINUM = jsonData.TPapmiNum ;
	CURPAPMI = jsonData.TPapmi ;
	if ((prescArr.indexOf(prescNo) > -1)&&(prescArr.length > 0)){
		PHA.Popover({
			showType: "show", 
			msg: "该处方于当前界面已经扫过，请勿重复扫码！", 
			type: 'alert', 
			timeout:2000
		});
		return ;
	}
	
	// 执行状态
	var UserCode = $('#txtUserCode').val() ;
	var proDictId = $('#cmbState').combobox("getValue") ;
	var params = phbdId + tmpSplit + UserCode + tmpSplit + proDictId ;
	
	$.m({
		ClassName: "PHA.HERB.Execute.Save",
		MethodName: "Execute",
		param: params,
		logonInfo: LogonInfo 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		else {
			// 执行成功后将处方加入到已扫描
			prescArr.push(prescNo)
			// 将执行完的处方信息加载到界面上
			var jsonData = $.cm({
				ClassName: "PHA.HERB.Execute.Query",
				MethodName: "GetPrescInfo",
				prescNo: prescNo,
				pJsonStr: JSON.stringify(pJson),
				exeFlag: "Y" ,
				HospId: gHospID ,
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
			else {
				var printPYDProCode = ComPropData.PrintPYDProCode;
				var proDictCode =  tkMakeServerCall("PHA.HERB.Com.Data", "GetProCodeById", proDictId)
				if (proDictCode == printPYDProCode){
					HERB_PRINTCOM.PYD(phbdId,"");
				}
			}
			$('#gridPrescList').datagrid('insertRow', {
				index: 0,
				row: jsonData
			});
			$("#gridPrescList").datagrid("expandRow",0);		
			
			$('#txtPrescNo').val('');		
				
		}
		
	});
	
	
}

/**
 * 草药处方状态执行 扫处方
 * @method AddPrescInfo
 */
function AddPrescInfo(prescNo){	
	var pJson = GetParamsJson();
	var jsonData = $.cm({
			ClassName: "PHA.HERB.Execute.Query",
			MethodName: "GetPrescInfo",
			prescNo: prescNo,
			pJsonStr: JSON.stringify(pJson),
			HospId: gHospID ,
			dataType: 'json'
		}, false);
	
	//var jsonData = JSON.parse(jsonData)
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
	$("#gridPrescList").datagrid("expandRow",0);		
	
	$('#txtPrescNo').val('');	
}

/*
 * 草药处方配药确认
 * @method Confirm
 */
function Execute(){
	var gridSelect = $("#gridPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要执行的处方!","info");
		return;
	}	
	var phbdId = gridSelect.TPhbdId ;
	var UserCode = $('#txtUserCode').val() ;
	if (UserCode == ""){
		$.messager.alert('提示',"药师工号不能为空!","info");
		return;	
	}
	var proDictId = $('#cmbState').combobox("getValue")
	var params = phbdId + tmpSplit + UserCode + tmpSplit + proDictId ;
	
	$.m({
		ClassName: "PHA.HERB.Execute.Save",
		MethodName: "Execute",
		param: params,
		logonInfo: LogonInfo 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		else {
			HERB_PRINTCOM.PYD(phbdId,"");
				
		}
		//QueryExecutePreList();
	});
}

/**
 * 查询条件的JSON
 * @method GetParamsJson
 */
function GetParamsJson() {
    return {
        phaLocId: gLocId,
		toExeProId: $("#cmbState").combobox("getValue")||'',
		papmiNum: PAPMINUM,
		curPapmi: CURPAPMI
    };
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	InitSetDefVal();
	$("#cmbState").combobox("setValue", "");
	$('#gridPrescList').datagrid('uncheckAll');
	$('#gridPrescList').datagrid('clear');
	//$('#chk-confirm').checkbox("uncheck",true) ;
	prescArr = [] ;
	PAPMINUM = 0;
	CURPAPMI = "";
}

