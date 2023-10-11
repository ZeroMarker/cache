/**
 * @模块:     煎药流程-收方
 * @编写日期: 2019-07-05
 * @编写人:   hulihua
 */
var decPdCode = "SF";
var Number = 0;
var pageTbNum = 15;
var NowTAB=""; 			//记录当前页签的tab
$(function () {
	InitDict();
	InitGridScanPresc();
	InitGridBatPresc();
	InitGridColPresc();
	InitSetDefVal("");
	$('#txtBarCode').on('keypress', function (event) {
		if (event.keyCode == "13") {
			var tabTitle = $('#tabsColPre').tabs('getSelected').panel('options').title;
			if (tabTitle != "扫码收方") {
				$("#tabsColPre").tabs("select", 0);
			}
			var barDecLocId = $("#cmbBarDecLoc").combobox('getValue');
			if (barDecLocId == "") {
				PHA.Popover({
					msg: "请先选择煎药科室！",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			};
			if (this.value.trim() == "") {
				PHA.Popover({
					msg: "处方号为空！",
					type: 'alert'
				});
				$('#txtBarCode').val("");
				return;
			}
			
			ScanExecute(this.value);
			$(this).val("");
		}
	});

	$("#tabsColPre").on("click", ChangeTabs);
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	PHA.ComboBox("cmbBarDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url
	});
}

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
function InitSetDefVal(clearFlag) {
	//公共配置
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
		$HUI.radio("#radioAll").setValue(true);
		if(parseInt(ComPropData.ScanPageTbNum)>0){
			pageTbNum=parseInt(ComPropData.ScanPageTbNum);
		}
		$("#cmbBarDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);	
		if (clearFlag ==""){
			$("#tabsColPre").tabs("select", parseInt(ComPropData.OperateModel));
		}
		if(ComPropData.PrescView=="Y") { 
			DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//显示处方预览panel
		}
		var tabId= $('#tabsColPre').tabs('getSelected').attr("id");
		NowTAB = tabId;		
		if (NowTAB == "tabPresc") {
			//$('#colprelayout').layout('collapse', 'north');
			$("#chkOnlyColPre").parent().css('visibility','hidden');
			$('#txtBarCode').focus(); 
			$("#cmbDecLoc").combobox("setValue", "");
			$("#cmbPhaLoc").combobox("setValue", "");
			$HUI.datebox("#dateColStart").disable();
			$HUI.datebox("#dateColEnd").disable();
			$HUI.timespinner("#timeColStart").disable();
			$HUI.timespinner("#timeColEnd").disable();
			$HUI.combobox("#cmbDecLoc").disable();
			$HUI.combobox("#cmbPhaLoc").disable();
			$HUI.radio("[name='busType']").disable();
			$HUI.checkbox("#onlyColPre").disable();
			
		} else {
			if (NowTAB == "tabBatPresc") {
				$("#chkOnlyColPre").parent().css('visibility','hidden');
			}
			else{
				$("#chkOnlyColPre").parent().css('visibility','visible');
			}	
			//$('#colprelayout').layout('expand', 'north');
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
			$HUI.datebox("#dateColStart").enable();
			$HUI.datebox("#dateColEnd").enable();
			$HUI.timespinner("#timeColStart").enable();
			$HUI.timespinner("#timeColEnd").enable();
			$HUI.combobox("#cmbDecLoc").enable();
			$HUI.combobox("#cmbPhaLoc").enable();
			$HUI.radio("[name='busType']").enable();
			$HUI.checkbox("#onlyColPre").enable();
		
			//界面配置
			$.cm({
				ClassName: "PHA.DEC.Com.Method",
				MethodName: "GetAppProp",
				UserId: gUserID,
				LocId: gLocId,
				SsaCode: "DEC.COLPRESC"
			}, function (jsonColData) {
				if (NowTAB == "tabPresc"){
					return ;
				}
				$("#dateColStart").datebox("setValue", jsonColData.ColStartDate);
				$("#dateColEnd").datebox("setValue", jsonColData.ColEndDate);
				$('#timeColStart').timespinner('setValue', "00:00:00");
				$('#timeColEnd').timespinner('setValue', "23:59:59");
				
			});
			if (clearFlag ==""){
				setTimeout("Query()",1000);
			}
		}
}

/**
 * 切换页签
 * @method ChangeTabs
 */
function ChangeTabs() {
	var tabId= $('#tabsColPre').tabs('getSelected').attr("id");
	if(NowTAB==tabId){
		return;
	}
	NowTAB=tabId;
	if (NowTAB == "tabPresc") {
		//$('#colprelayout').layout('collapse', 'north');
		$("#chkOnlyColPre").parent().css('visibility','hidden');
		$('#txtBarCode').focus();
		$("#dateColStart").datebox("setValue", "");
		$("#dateColEnd").datebox("setValue", "");
		$('#timeColStart').timespinner('setValue', "");
		$('#timeColEnd').timespinner('setValue', "");
		$("#cmbDecLoc").combobox("setValue", "");
		$("#cmbPhaLoc").combobox("setValue", "");
		$HUI.datebox("#dateColStart").disable();
		$HUI.datebox("#dateColEnd").disable();
		$HUI.timespinner("#timeColStart").disable();
		$HUI.timespinner("#timeColEnd").disable();
		$HUI.combobox("#cmbDecLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$HUI.radio("[name='busType']").disable();
		$HUI.checkbox("#onlyColPre").disable();
	}else{
		//公共配置
		$.cm({
			ClassName: "PHA.DEC.Com.Method",
			MethodName: "GetAppProp",
			UserId: gUserID,
			LocId: gLocId,
			SsaCode: "DEC.COMMON",
		}, function (jsonComData) {
			$("#cmbDecLoc").combobox("setValue", jsonComData.DefaultDecLoc);
			$("#cmbPhaLoc").combobox("setValue", jsonComData.DefaultPhaLoc);	
		});
			
		$HUI.datebox("#dateColStart").enable();
		$HUI.datebox("#dateColEnd").enable();
		$HUI.timespinner("#timeColStart").enable();
		$HUI.timespinner("#timeColEnd").enable();
		$HUI.combobox("#cmbDecLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$HUI.radio("[name='busType']").enable();
		$HUI.checkbox("#onlyColPre").enable();
		//界面配置
		$.cm({
			ClassName: "PHA.DEC.Com.Method",
			MethodName: "GetAppProp",
			UserId: gUserID,
			LocId: gLocId,
			SsaCode: "DEC.COLPRESC"
		}, function (jsonColData) {
			$("#dateColStart").datebox("setValue", jsonColData.ColStartDate);
			$("#dateColEnd").datebox("setValue", jsonColData.ColEndDate);
			$('#timeColStart').timespinner('setValue', "00:00:00");
			$('#timeColEnd').timespinner('setValue', "23:59:59");
			
		});
		
		if ($(".panel.layout-panel.layout-panel-north").css("top") != "0px"){
			//$('#colprelayout').layout('expand', 'north');
		}
		
		if(NowTAB == "tabBatPresc"){
			$("#chkOnlyColPre").parent().css('visibility','hidden');
			$('#gridBatPresc').datagrid('clear');	
		}else{
			$("#chkOnlyColPre").parent().css('visibility','visible');
			$('#gridColPresc').datagrid('clear');	
		}
		
	
		setTimeout("Query()",500);
	}
	
}

/**
 * 初始化扫码收方表格
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [
		[{
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 120
			}, {
				field: 'TPreFacTor',
				title: '付数',
				align: 'left',
				width: 70
			}, {
				field: 'TPreCount',
				title: '味数',
				align: 'left',
				width: 70
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '是否加急',
				align: 'left',
				width: 70
			}, {
				field: 'TPhaLocDesc',
				title: '调剂科室',
				align: 'left',
				width: 120
			}, {
				field: 'TOperUser',
				title: '调剂人',
				align: 'left',
				width: 100
			}, {
				field: 'TOperDate',
				title: '调剂时间',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '登记号',
				align: 'left',
				width: 120
			}, {
				field: 'TPatName',
				title: '患者姓名',
				align: 'left',
				width: 120
			}, {
				field: 'TDocLocDesc',
				title: '开单科室',
				align: 'left',
				width: 180
			}, {
				field: 'TCookCost',
				title: '煎药费',
				align: 'left',
				width: 150
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
		toolbar: '#gridScanPrescBar',
		singleSelect: true,
		onRowContextMenu: function(){
			return false;	
		},
		onSelect: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			ColPrescView(prescNo);
		},
	};
	PHA.Grid("gridScanPresc", dataGridOption);
}

/**
 * 初始化批量收方表格
 * @method InitGridBatPresc
 */
function InitGridBatPresc() {
	var columns = [
		[{
				field: 'gridPreSelect',
				checkbox: true
			}, {
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 120
			}, {
				field: 'TPreFacTor',
				title: '付数',
				align: 'left',
				width: 60
			}, {
				field: 'TPreCount',
				title: '味数',
				align: 'left',
				width: 60
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '是否加急',
				align: 'left',
				width: 70
			}, {
				field: 'TPhaLocDesc',
				title: '调剂科室',
				align: 'left',
				width: 120
			}, {
				field: 'TOperUser',
				title: '调剂人',
				align: 'left',
				width: 100
			}, {
				field: 'TOperDate',
				title: '调剂时间',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '登记号',
				align: 'left',
				width: 120
			}, {
				field: 'TPatName',
				title: '患者姓名',
				align: 'left',
				width: 120
			}, {
				field: 'TDocLocDesc',
				title: '开单科室',
				align: 'left',
				width: 180
			}, {
				field: 'TCookCost',
				title: '煎药费',
				align: 'left',
				width: 140
			}, {
				field: 'TPointer',
				title: '指针ID',
				align: 'left',
				hidden: true
			}, {
				field: 'TDispType',
				title: '煎药类型',
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		toolbar: '#gridBatPrescBar',
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false ,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ColPre.Query",
			QueryName: "BatColPre",
		},
		onLoadSuccess: function () {
			$('#gridBatPresc').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridBatPresc", dataGridOption);
}

/**
 * 初始化已收方表格
 * @method InitGridColPresc
 */
function InitGridColPresc() {
	var columns = [
		[{
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 130
			}, {
				field: 'TPreFacTor',
				title: '付数',
				align: 'left',
				width: 70
			}, {
				field: 'TPreCount',
				title: '味数',
				align: 'left',
				width: 70
			}, {
				field: 'TPreForm',
				title: '处方剂型',
				align: 'left',
				width: 80
			}, {
				field: 'TPreEmFlag',
				title: '是否加急',
				align: 'left',
				width: 70
			}, {
				field: 'TPhaLocDesc',
				title: '调剂科室',
				align: 'left',
				width: 130
			}, {
				field: 'TColUser',
				title: '收方人',
				align: 'left',
				width: 130
			}, {
				field: 'TColDate',
				title: '收方时间',
				align: 'left',
				width: 150
			}, {
				field: 'TPatNo',
				title: '登记号',
				align: 'left',
				width: 120
			}, {
				field: 'TPatName',
				title: '患者姓名',
				align: 'left',
				width: 140
			}, {
				field: 'TDecLocDesc',
				title: '煎药科室',
				align: 'left',
				width: 130
			}, {
				field: 'TDecType',
				title: '煎药类型',
				align: 'left',
				width: 80
			}, {
				field: 'TPdpmId',
				title: '煎药ID',
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 200],
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.ColPre.Query",
			QueryName: "AlrColPre",
		}
	};
	PHA.Grid("gridColPresc", dataGridOption);
}

/**
 * 扫描执行
 * @method ScanExecute
 */
function ScanExecute(barCode) {
	var barCode = barCode.trim();
	//var prescNo = rowData.TPrescNo;
	var barDecLocId = $("#cmbBarDecLoc").combobox('getValue');
	var LogonInfo = gGroupId + "^" + barDecLocId+ "^" + gUserID
			
	var jsonData = $cm({
			ClassName: "PHA.DEC.ColPre.Query",
			MethodName: "GetBarCodeInfo",
			BarCode: barCode,
			DecLocID: barDecLocId,
			LogonInfo: LogonInfo ,
			dataType: 'json'
		}, false);
	var retCode = jsonData.retCode;
	if (retCode < 0) {
		PHA.Popover({
			msg: jsonData.retMessage,
			type: 'alert'
		});
		return;
	} else {
		var decLocId = $('#cmbBarDecLoc').combobox("getValue") || "";
		$.m({
			ClassName: "PHA.DEC.ColPre.OperTab",
			MethodName: "ScanSave",
			PrescNo: barCode,
			ProUserId: gUserID,
			ProdCode: decPdCode,
			DecLodId: decLocId,
			HospId: gHospID
		}, function (retData) {
			var retArr = retData.split("^");
			if (retArr[0] < 0) {
				$.messager.alert('提示', retArr[1], 'warning');
				return ;
			} else {
				PHA.Popover({
					msg: "收方成功！",
					type: 'success'
				});
				ColPrescView(barCode);
				$('#gridScanPresc').datagrid('insertRow', {
					index: 0,
					row: jsonData
				});
				Number = Number + 1; //增加行id顺序号
				$('#gridScanPresc').datagrid('selectRow', 0);
				var totalRows = $('#gridScanPresc').datagrid('getRows').length;
				if (totalRows > pageTbNum) { //超过设置的行数，每增加一条，就删除一条之前的数据
					if ((Number - pageTbNum) != 0) {
						$('#gridScanPresc').datagrid('deleteRow', pageTbNum);
					}
				}
			}
			$('#txtBarCode').focus();
		});
	}

}

/**
 * 处方预览
 * @method PrescView
 */
function ColPrescView(prescno){
	var phartype = "O";
	if(prescno.indexOf("I")>-1){
		phartype = "I";
	}
	var cyflag = "Y";
	DEC_PRESC.Presc("divPreLayout", {
		PrescNo: prescno, 
		AdmType: phartype,
		CY: cyflag
	}); 
}

/**
 * 查询数据
 * @method Query
 */
function Query() {
	if (NowTAB == "tabPresc") {
		return;
	}
	var params = GetParams();
	if (params == "") {
		return;
	}
	var tabTitle = $('#tabsColPre').tabs('getSelected').panel('options').title;
	if (tabTitle == "批量收方") {
		//$('#gridBatPresc').datagrid('uncheckAll');
		$('#gridBatPresc').datagrid('query', {
			ParamStr: params
		});
	} else if (tabTitle == "已收方查询") {
		var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
		if (decLocId == "") {
			PHA.Popover({
				msg: "请先选择需要查询的煎药室！",
				type: 'alert'
			});
			return;
		}
		$('#gridColPresc').datagrid('query', {
			ParamStr: params
		});
	} else {
		$.messager.alert("提示", "此页签无需查询！", "info");
		return;
	}
}

/*
 * 清屏
 * @method Clear
 */
function Clear() {
	InitSetDefVal("Y");
	$('#gridScanPresc').datagrid('clear');
	$('#gridBatPresc').datagrid('clear');
	$('#gridColPresc').datagrid('clear');
	ColPrescView("")
	$('#txtBarCode').val("");
}

/**
 * 获取界面元素值
 * @method GetParams
 */
function GetParams() {
	var stDate = $("#dateColStart").datebox('getValue');
	var enDate = $("#dateColEnd").datebox('getValue');
	var stTime = $('#timeColStart').timespinner('getValue');
	var enTime = $('#timeColEnd').timespinner('getValue');
	var locId = $('#cmbPhaLoc').combobox("getValue") || "";
	var type = $("input[name='busType']:checked").val() || ""; 
	var onlyCPFlag = ($('#chkOnlyColPre').checkbox('getValue')==true?'Y':'N');
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	
	var params = stDate + "^" + enDate + "^" + stTime + "^" + enTime + "^" + locId ;
	var params = params + "^" + type +"^"+ onlyCPFlag +"^"+ decLocId + "^" + gGroupId + "^" + gUserID;
	
	return params;
}

/**
 * 获取选中记录的申请明细的处方号
 * @method SaveBat
 */
function GetCheckedPreArr() {
	var batPreArr = [];
	var gridBatPrescChecked = $('#gridBatPresc').datagrid('getChecked');
	for (var i = 0; i < gridBatPrescChecked.length; i++) {
		var checkedData = gridBatPrescChecked[i];
		var dispType = checkedData.TDispType;
		var pointer = checkedData.TPointer;
		var dataStr = dispType + "^" + pointer;
		if (batPreArr.indexOf(dataStr) < 0) {
			batPreArr.push(dataStr);
		}
	}
	return batPreArr.join("!!");
}

/**
 * 批量收方
 * @method SaveBat
 */
function SaveBat() {
	var preDataStr = GetCheckedPreArr();
	if (preDataStr == "") {
		PHA.Popover({
			msg: "请勾选需要收取的处方！",
			type: 'alert'
		});
		return;
	}
	var decLocId = $('#cmbDecLoc').combobox("getValue") || "";
	if (decLocId == "") {
		PHA.Popover({
			msg: "请选择接收的煎药室！",
			type: 'alert'
		});
		return;
	}
	$.m({
		ClassName: "PHA.DEC.ColPre.OperTab",
		MethodName: "SaveBatch",
		MultiDataStr: preDataStr,
		ProUserId: gUserID,
		ProdCode: decPdCode,
		DecLodId: decLocId,
		HospId: gHospID
	}, function (retData) {
		if (retData.indexOf("Msg") >= 0) {
			$.messager.alert('提示', JSON.parse(retData).msg, 'error');
			return;
		}
		var retArr = retData.split("^");
		if (retArr[0] < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		} else {
			PHA.Popover({
				msg: "收方成功！",
				type: 'success'
			})
		}
		Query();
	});

}
