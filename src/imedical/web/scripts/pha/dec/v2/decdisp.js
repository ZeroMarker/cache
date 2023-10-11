/**
 * @模块:     煎药室-煎药发放
 * @编写日期: 2021-01-18
 * @编写人:   MaYuqiang
 */
var decCode = "FF";	// 煎药流程标识
var NowTAB = ""; 	// 记录当前页签的tab
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
var logonInfo = gGroupId + "^" + gLocId + "^" + gUserID + "^" + gHospID;
var ComPropData ;	// 公共参数
var AppPropData ;	// 界面配置
PHA_COM.ResizePhaColParam.auto = false;
$(function () {
	InitDict();
	InitGridScanPresc();
	InitGridBatchPresc();
	InitGridDispedPresc();
	// 处方号回车事件
	$("#txtBarCode").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var barCode = $.trim($("#txtBarCode").val());
			if (barCode != "") {
				queryScanPrescList();
			}
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
			var tabId= $('#dispTab').tabs('getSelected').attr("id");
			NowTAB = tabId;	
			ColPrescView("");
			if (title == "扫码发放"){
				$('#txtBarCode').focus();
				$("#dateStart").datebox("setValue", "");
				$("#dateEnd").datebox("setValue", "");
				$('#timeStart').timespinner('setValue', "");
				$('#timeEnd').timespinner('setValue', "");
				$HUI.datebox("#dateStart").disable();
				$HUI.datebox("#dateEnd").disable();
				$HUI.timespinner("#timeStart").disable();
				$HUI.timespinner("#timeEnd").disable();
				
				$("#cmbPhaLoc").combobox("setValue","")
				$('#cmbAdmType').combobox("setValue","")
				$HUI.combobox("#cmbDecLoc").disable();
				$HUI.combobox("#cmbPhaLoc").disable();
				$HUI.combobox("#cmbAdmType").disable();
				$('#txtCardNo').val("").prop('disabled', true);
				$('#txtPatNo').val("").prop('disabled', true);
			}
			else {
			
				$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
				$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
				$('#timeStart').timespinner('setValue', "00:00:00");
				$('#timeEnd').timespinner('setValue', "23:59:59");
				$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
				$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
				
				$HUI.datebox("#dateStart").enable();
				$HUI.datebox("#dateEnd").enable();
				$HUI.timespinner("#timeStart").enable();
				$HUI.timespinner("#timeEnd").enable();
				$HUI.combobox("#cmbDecLoc").enable();
				$HUI.combobox("#cmbPhaLoc").enable();
				$HUI.combobox("#cmbAdmType").enable();
				$('#txtCardNo').val("").prop('disabled', false);
				$('#txtPatNo').val("").prop('disabled', false);
				if (title == "批量发放"){		
					$('#gridBatchPresc').datagrid('clear');
					setTimeout("queryBatchPrescList();",500)
				}
				else {
					$('#gridDispedPresc').datagrid('clear');
					setTimeout("queryDispedPrescList();",500)
				}
				
			}
			
		}
	})
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	// 模块设置
	AppPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, false);
		
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//显示处方预览panel
	};
	PHA.ComboBox("cmbDecLoc", {
		width: '120',
		url: PHA_DEC_STORE.DecLoc().url
	});
	PHA.ComboBox("cmbPhaLoc", {
		width: '120',
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	
	$("#dispTab").tabs("select", parseInt(ComPropData.OperateModel));
	
	// 就诊类型
    PHA.ComboBox('cmbAdmType', {
        data: [
            { RowId: 'O', Description: $g('门诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
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
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		
	var tabId= $('#dispTab').tabs('getSelected').attr("id");
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
		$HUI.combobox("#cmbDecLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$HUI.combobox("#cmbAdmType").disable();
		$('#txtCardNo').val("").prop('disabled', true);
		$('#txtPatNo').val("").prop('disabled', true);	
	}
	else {
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
			
			$HUI.datebox("#dateStart").enable();
			$HUI.datebox("#dateEnd").enable();
			$HUI.timespinner("#timeStart").enable();
			$HUI.timespinner("#timeEnd").enable();
			$HUI.combobox("#cmbDecLoc").enable();
			$HUI.combobox("#cmbPhaLoc").enable();
			$HUI.combobox("#cmbAdmType").enable();
			$('#txtCardNo').val("").prop('disabled', false);
			$('#txtPatNo').val("").prop('disabled', false);	
			if (NowTAB == "tabDispBatch"){						
				setTimeout("queryBatchPrescList();",1000)
			}
			else {
				setTimeout("queryDispedPrescList();",1000)
			}
	}
}
/**
 * 初始化扫码发放处方列表
 * @method InitGridScanPresc
 */
function InitGridScanPresc() {
	var columns = [[ 
//		{
//			field:'pdCheck',
//			checkbox: true	
//		},
		{
			field:'curProDesc', 	
			title:'当前流程',	
			align:'left', 
			width: 70, 
			styler:function(value,row,index){
				if (row.curProDesc == "打签") {
                        return 'background-color:#a849cb;color:white;';
                    }
                else if (row.curProDesc == "发放") {
					return 'background-color:#6557d3;color:white;';
                }
			}
		},
		{
			field:'dispNum',	
			title:'发放付数',		
			align:'right', 
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					required: false,
					onChange: function(nval, oval){
		            	$("#gridScanPresc").datagrid('endEditing');
		        	}
				}
			}
		},
		{	field:'pdpmId',		
			title:'pdpmId',		
			hidden:'true',	
			width: 50
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
			field:'prescNo', 	
			title:'处方号',	  	
			align:'left', 
			width: 130
		},
		{
			field: 'dispedNum',	
			title: '已发放付数',	
			align: 'right', 
			width: 90
		},
		{
			field: 'toDispNum',	
			title: '待发放付数',	
			align: 'right', 
			width: 90
		},
		{
			field:'preFacTor',	
			title:'总付数',		
			align:'right', 
			width: 60
		}, 
		{
			field:'deptLocDesc', 	
			title:'科室',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'decTypeDesc', 	
			title:'煎药类型', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'收方时间', 	
			align:'left', 
			width: 160
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
			width: 160
		},
		{
			field:'cookCost',	
			title:'煎药费',		
			align:'left', 
			width: 150,
			nowrap:false
		},
		{
			field:'allDispFlag',	
			title:'全部发放标志',		
			align:'left', 
			width: 150,
			hidden:true
		}
	]];
	var dataGridOption = {
		url: $URL,
		toolbar: '#gridScanDispBar',
		columns: columns,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		rownumbers: true,		
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPrescInfo",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "dispNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'dispNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function(data) {
			if(data.rows.length==0){ return; }
			var row = data.rows[0];
			var prescNo = row.prescNo;
			$('#gridScanPresc').datagrid('selectRow', 0);
			ColPrescView(prescNo);
		}
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
		{
			field:'curProDesc', 	
			title:'当前流程',	
			align:'left', 
			width: 70, 
			styler:function(value,row,index){
				if (row.curProDesc == "打签") {
                	return 'background-color:#a849cb;color:white;';
                }
                else {
					return 'background-color:#6557d3;color:white;';
                }
			}
		},
		{
			field:'dispNum',	
			title:'发放付数',		
			align:'right', 
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					onChange: function(nval, oval){
		            	$("#gridBatchPresc").datagrid('endEditing');
		        	}
				}
			}
		},
		{	field:'pdpmId',		
			title:'pdpmId',		
			hidden:'true',	
			width: 50
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
			field:'prescNo', 	
			title:'处方号',	  	
			align:'left', 
			width: 130
		},
		{
			field: 'dispedNum',	
			title: '已发放付数',	
			align: 'right', 
			width: 90
		},
		{
			field: 'toDispNum',	
			title: '待发放付数',	
			align: 'right', 
			width: 90
		},
		{
			field:'preFacTor',	
			title:'总付数',		
			align:'right', 
			width: 60
		}, 
		{
			field:'deptLocDesc', 	
			title:'科室',	  	
			align:'left', 
			width: 150
		}, 
		{
			field:'decTypeDesc', 	
			title:'煎药类型', 	
			align:'left', 
			width: 70
		}, 
		{
			field:'decDate',	
			title:'收方时间', 	
			align:'left', 
			width: 160
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
			width: 160
		},
		{
			field:'cookCost',	
			title:'煎药费',		
			align:'left', 
			width: 150,
			nowrap:false
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
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPrescList",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "dispNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'dispNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function(data) {
			if(data.rows.length==0){ return; }
			$("#gridBatchPresc").datagrid("checkAll");
			var row = data.rows[0];
			var prescNo = row.prescNo;
			ColPrescView(prescNo);
		}
	};
	PHA.Grid("gridBatchPresc", dataGridOption);
}

/**
 * 初始化已发放处方列表
 * @method InitGridDispedPresc
 */
function InitGridDispedPresc() {
	var columns = [[ 
		{
			field:'pdpmItmId',		
			title:'煎药子表Id',		
			hidden:true, 	
			width: 70 
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
			field:'prescNo', 	
			title:'处方号',	  	
			align:'left', 
			width: 130
		}, 
		{
			field:'ordLocDesc', 	
			title:'开单科室',	  	
			align:'left', 
			width: 150
		},
		{
			field:'phaLocDesc',	
			title:'调剂药房',	
			align:'left', 
			width: 100
		},
		{
			field:'decTypeDesc', 	
			title:'煎药类型', 	
			align:'left', 
			width: 70 
		},
		{
			field:'dispNum',	
			title:'发放付数',		
			align:'right', 
			width: 80 
		},
		{
			field:'preFacTor',	
			title:'总付数',		
			align:'right', 
			width: 60 
		},
		{
			field:'dispUser',	
			title:'发放人',		
			align:'left', 
			width: 80 
		},
		{
			field:'dispDate',	
			title:'发放时间',	
			align:'left', 
			width: 160
		},
		{
			field:'comFlag',	
			title:'完成标志', 	
			align:'left', 
			width: 70 
		},
		{
			field:'pdDate',	
			title:'收方时间', 	
			align:'left', 
			hidden : true ,
			width: 160
		},
		{
			field:'preCount',	
			title:'味数',		
			align:'left', 
			hidden:true ,
			width: 45 
		}, 
		{
			field:'preForm',	
			title:'处方剂型',	
			align:'left', 
			hidden:true ,
			width: 80 
		}, 
		{
			field:'preEmFlag',	
			title:'是否加急',	
			align:'left', 
			width: 70 
		}, 
		{
			field:'operUser',	
			title:'调剂人',		
			align:'left', 
			hidden:true ,
			width: 80 
		},
		{
			field:'operDate',	
			title:'调剂时间',	
			align:'left', 
			hidden:true ,
			width: 160
		},
		{
			field:'cookCost',	
			title:'煎药费',		
			align:'left', 
			hidden : true ,
			width: 150
		}
	]];
	var dataGridOption = {
		toolbar: [],
		columns: columns,
		url: $URL,
		rownumbers: true,
		nowrap:false,
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryDispedPrescList",
			pJsonStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescNo = rowData.prescNo;
			ColPrescView(prescNo);
		}
	};
	PHA.Grid("gridDispedPresc", dataGridOption);
}

/**
 * 查询待发放数据
 * @method queryPrtLabList
 */
function query(){
	var tab = $('#dispTab').tabs('getSelected');
	var tabIndex = $('#dispTab').tabs('getTabIndex',tab);
	if (tabIndex == 0){
		queryScanPrescList()
	}
	else if (tabIndex == 1){
		queryBatchPrescList()
	}
	else if (tabIndex == 2){
		queryDispedPrescList()
	}
}

/**
 * 扫码发放：查询待发放数据
 * @method queryPrtLabList
 */
function queryScanPrescList(){
	var pJson = GetScanParamsJson();
	if (pJson == "") {
		return;
	}
	
	$('#gridScanPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		logonInfo: logonInfo
	});
}

/**
 * 批量发放：查询待发放数据
 * @method queryPrtLabList
 */
function queryBatchPrescList(){
	if (NowTAB == "tabScanDisp") {
		return;
	}
	$('#gridBatchPresc').datagrid('uncheckAll');
	ColPrescView("");
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridBatchPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson),
		logonInfo: logonInfo
	});
}

/**
 * 查询已发放数据
 * @method queryDispedList
 */
function queryDispedPrescList(){
	
	if (NowTAB == "tabScanDisp") {
		return;
	}
	ColPrescView("");
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}

	$('#gridDispedPresc').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});

}

/**
 * 获取扫码发放界面元素值
 * @method GetScanParamsJson
 */
function GetScanParamsJson() {
    return {
		barCode : $('#txtBarCode').val(),
		logonLocId : $('#cmbDecLoc').combobox("getValue")||''		//locId
    };
}

/**
 * 获取扫码发放界面元素值
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
	var startDate = $("#dateStart").datebox('getValue')||'' ;
	var endDate = $("#dateEnd").datebox('getValue')||''
	var decLocId = $('#cmbDecLoc').combobox("getValue")||'' ;
	if ((startDate == "")||(endDate == "")){
		PHA.Popover({showType: "show", msg: "开始日期、截止日期不能为空！", type: 'alert'});
		return;
	}
	if (decLocId == ""){
		PHA.Popover({showType: "show", msg: "煎药室不能为空！", type: 'alert'});
		return;
	}
    return {
		// barCode : $('#txtBarCode').val(),
		patNo : $('#txtPatNo').val(),
		startDate : startDate ,
		endDate : endDate ,
		startTime : $('#timeStart').timespinner('getValue')||'' ,
		endTime : $('#timeEnd').timespinner('getValue')||'' ,
		phaLocId : $('#cmbPhaLoc').combobox("getValue")||'' ,
		decLocId : decLocId ,
		admType : $('#cmbAdmType').combobox("getValue")||'' ,
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
 * 确认发放
 * @method dispPresc
 */
function Disp() {
	var selData = $("#gridScanPresc").datagrid("getSelected");
	if(selData==null){
		PHA.Popover({showType: "show", msg: "请先选择需要发放的处方！", type: 'alert'});
		return;
	}
	
	var prescNo = selData.prescNo ;
	var dispNum = selData.dispNum ;
	var toDispNum = selData.toDispNum ;
	if (dispNum > toDispNum){
		PHA.Popover({ showType: "show",	msg: "发放付数不能大于待发放付数", type: 'error'	});
		return ;
	}
	if ((dispNum == "")||(dispNum.length == 0)){
		PHA.Popover({ showType: "show",	msg: "发放付数不能小于等于0", type: 'error'	});
		return ;
	}
	if (dispNum <= 0){
		PHA.Popover({ showType: "show",	msg: "发放付数不能小于等于0", type: 'error'	});
		return ;
	}
	var dispNumStr = dispNum.split(".")
	if (dispNumStr[0] !== dispNum){
		PHA.Popover({ showType: "show",	msg: "发放付数不能是小数", type: 'error' });
		return ;		
	}
	var chkDispNumFlag = tkMakeServerCall("PHA.DEC.DecDisp.OperTab","ChkDispNumFlag",prescNo,dispNum,toDispNum,logonInfo)
	if (chkDispNumFlag !== "Y"){
		PHA.Popover({ showType: "show",	msg: chkDispNumFlag, type: 'error' });
		return ;		
	}
	var dispStr = prescNo + "," + dispNum
	if(!dispStr) return;
	var params = dispStr +"^"+ decCode +"^"+ opUser +"^"+ "" +"^"+ locId;
	
	$cm({
		ClassName: "PHA.DEC.DecDisp.OperTab",
		MethodName: "SaveDispPstBatch",
		params: params,
		logonInfo: logonInfo,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
		}else{
			PHA.Popover({ showType: "show",	msg: "发放成功！", type: 'success' });
			queryScanPrescList();
			//ColPrescView("");
		}
		$('#txtBarCode').val("");
		$("#txtBarCode").focus();
	});	
	
}

/**
 * 批量发放
 * @method DispBatch
 */
function DispBatch() {
	var checkedData = $("#gridBatchPresc").datagrid("getChecked");
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要发放的处方！", type: 'alert'});
		return;
	}
	var prescNoStr = "";
	for(var i in checkedData){
		var prescNo = checkedData[i].prescNo;
		var dispNum = checkedData[i].dispNum;
		var toDispNum = checkedData[i].toDispNum;
		if (dispNum > toDispNum){
			PHA.Popover({ showType: "show",	msg: "发放付数不能大于待发放付数", type: 'error'	});
			return ;
		}
		if ((dispNum == "")||(dispNum.length == 0)){
			PHA.Popover({ showType: "show",	msg: "发放付数不能小于等于0", type: 'error'	});
			return ;
		}
		if (dispNum <= 0){
			PHA.Popover({ showType: "show",	msg: "发放付数不能小于等于0", type: 'error'	});
			return ;
		}
		var dispNumStr = dispNum.split(".")
		if (dispNumStr[0] !== dispNum){
			PHA.Popover({ showType: "show",	msg: "发放付数不能是小数", type: 'error' });
			return ;		
		}
		var chkDispNumFlag = tkMakeServerCall("PHA.DEC.DecDisp.OperTab","ChkDispNumFlag",prescNo,dispNum,toDispNum,logonInfo)
		if (chkDispNumFlag !== "Y"){
			PHA.Popover({ showType: "show",	msg: chkDispNumFlag, type: 'error' });
			return ;		
		}
		var dispStr = prescNo + "," + dispNum
		prescNoStr = prescNoStr == "" ? dispStr : prescNoStr +"!!"+ dispStr;
	}
	if(!prescNoStr) return;
	var params = prescNoStr +"^"+ decCode +"^"+ opUser +"^"+ "" +"^"+ locId;
	$cm({
		ClassName: "PHA.DEC.DecDisp.OperTab",
		MethodName: "SaveDispPstBatch",
		params: params,
		logonInfo: logonInfo,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
		}else{
			PHA.Popover({ showType: "show",	msg: "发放成功！", type: 'success' });
			queryBatchPrescList();
			ColPrescView("");
		}

	});	
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
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//显示处方预览panel
	}
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	$('#txtBarCode').val("");
	$('#txtPatNo').val("");
	$('#txtCardNo').val("");
	$('#txtBarCode').focus();
	$('#cmbAdmType').combobox("setValue","") ,
	$('#gridBatchPresc').datagrid('uncheckAll');
	$('#gridScanPresc').datagrid('clear');
	$('#gridBatchPresc').datagrid('clear');
	$('#gridDispedPresc').datagrid('clear');
	ColPrescView("");
	
	if (NowTAB == "tabScanDisp"){
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue', "");
		$('#timeEnd').timespinner('setValue', "");
		$("#cmbPhaLoc").combobox("setValue","")
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
		$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
	}
	
	
}

/**
 * 处方预览
 * @method PrescView
 */
function ColPrescView(prescNo){
	var phartype = "O";
	DEC_PRESC.Presc("divPreLayout", {
		PrescNo: prescNo, 
		AdmType: phartype,
		CY: "Y"
	}); 
}

