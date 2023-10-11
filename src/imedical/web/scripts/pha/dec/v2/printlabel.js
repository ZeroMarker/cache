/**
 * @模块:     煎药流程-打签
 * @编写日期: 2019-06-04
 * @编写人:   pushuangcai
 */
var decNumber = "DQ";	//煎药流程
var PAGESIZE = 30;		//行数
var NowTAB=""; 			//记录当前页签的tab
var ComPropData;		//公共参数
var PrintPropData;		//界面配置
var logonInfo = gGroupId + "^" + gLocId + "^" + gUserID + "^" + gHospID;
$(function () {
	InitDict();
	InitGridPresc();
	InitGridPrescList();
	InitGridPrescListPrt();
	
	$("#txtBarCode").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			savePrtLabState();
		}
	})
	$("#txtPackNum").on('keypress',function(event){
		if(window.event.keyCode == "13"){
			$("#txtBarCode").focus();
		}
	})
	//登记号回车事件
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryPrtLabList();
			}
		}
	});
//	setTimeout(function(){
//		$("#tabPrt").tabs({ 		// 绑定选中事件,切换页签自动查询
//			onSelect: function(title, index){ 
//				queryPrtLabList(); 
//			}
//		})
//	}, 1000);
	
	$("#tabPrt").on("click", ChangeTabs);
	SetDefVal(true);  
});
/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url,
	});
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_DEC_STORE.Pharmacy("").url
	});
	PHA.ComboBox("cmbDocLoc", {
		url: PHA_DEC_STORE.DocLoc().url
	});	
}
/**
 * 初始化设置默认值
 * @method SetDefVal
 * @InitFlag	加载页面时为true，清屏按钮调用时为false
 */
function SetDefVal(InitFlag) {
	if(typeof(InitFlag)=="undefined"){InitFlag=false} 
	ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	PrintPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.PRINTLAB", 
		AppCode:""
		},false)
			
	if(parseInt(ComPropData.ScanPageTbNum)>0){
		PAGESIZE=parseInt(ComPropData.ScanPageTbNum);
	}	
	if(ComPropData.ViewDecInfo=="Y") {
		//显示煎药信息panel
		var decInfoId = DEC_PRINT.DecInfo("mainLayout");	
		ComPropData.decInfoId = decInfoId;
		DEC_PRINT.VIEW(decInfoId, {PrescNo: ""});	
	}
	$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	if (InitFlag){
		$("#tabPrt").tabs("select",parseInt(ComPropData.OperateModel));
	}
	var tabId= $('#tabPrt').tabs('getSelected').attr("id");
	NowTAB=tabId;	
	
	$('#txtEditNum').val("");
	$('#txtPackNum').val("");
	$('#txtReEditNum').val("");
	$("#txtBarCode").val("");
	$("input[label='全部']").radio("check");
	
	//设置默认值
	if (NowTAB == "tabScanLable"){
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);		
	}
	else {		
		$("#dateStart").datebox("setValue", PrintPropData.PrtStartDate);
		$("#dateEnd").datebox("setValue", PrintPropData.PrtEndDate);
		$('#timeStart').timespinner('setValue',"00:00:00");
		$('#timeEnd').timespinner('setValue',"23:59:59");
		$('#cmbDocLoc').combobox("setValue","");
		$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
	
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
	}
}
/**
 * 初始化扫码打签表格
 * @method InitGridPresc
 */
function InitGridPresc() {
	var columns = [[ 
		{field: 'type',		title: '煎药类型',	align: 'left', width: 80},
		{field: 'labNum',	title: '标签数',	align: 'left', width: 80},
		{field: 'patNo',	title: '登记号',	align: 'left', width: 120},
		{field: 'patName',	title: '患者姓名',	align: 'left', width: 100},
		{field: 'prescno', 	title: '处方号', 	align: 'left', width: 150},
		{field: 'pdLoc', 	title: '科室', 		align: 'left', width: 200}
	]];
	var dataGridOption = {
		url: '',
		fit: true,
		pagination: false,
		singleSelect: true,
		columns: columns,
		toolbar: '#toolBarPresc',
		queryParams: {
			ClassName: "",
			QueryName: ""
		},
		rownumbers: true,
		idField: "prescno",
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			if(ComPropData.ViewDecInfo=="Y") { 
				DEC_PRINT.VIEW(ComPropData.decInfoId, {PrescNo: prescno});	
			}
		},
        	onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridPresc", dataGridOption);
}
/**
 * 初始化批量打签表格
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [[ 
		{field:'pdCheck',	checkbox: true },
		{field:'labNum',	title:'标签数',		align:'left', width: 60,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					onChange: function(nval, oval){
		            	$("#gridPrescList").datagrid('endEditing');
		        	}
				}
			}
		},
		{field:'patNo',		title:'登记号',		align:'left', width: 100}, 
		{field:'patName',	title:'患者姓名',	align:'left', width: 80 }, 
		{field:'prescno', 	title:'处方号',	  	align:'left', width: 130}, 
		{field:'deptLoc', 	title:'科室',	  	align:'left', width: 150}, 
		{field:'pdPst', 	title:'当前流程',	align:'left', width: 70 }, 
		{field:'pdType', 	title:'煎药类型', 	align:'left', width: 70 }, 
		{field:'comFlag',	title:'完成标志', 	align:'left', width: 70 }, 
		{field:'pdDate',	title:'生成时间', 	align:'left', width: 150},
		{field:'preFacTor',	title:'付数',		align:'left', width: 45 }, 
		{field:'preCount',	title:'味数',		align:'left', width: 45 }, 
		{field:'preForm',	title:'处方剂型',	align:'left', width: 70 }, 
		{field:'preEmFlag',	title:'是否加急',	align:'left', width: 70 }, 
		{field:'phaLoc',	title:'调剂科室',	align:'left', width: 100}, 
		{field:'operUser',	title:'调剂人',		align:'left', width: 80 },
		{field:'operDate',	title:'调剂时间',	align:'left', width: 150},
		{field:'cookCost',	title:'煎药费',		align:'right', width: 150}
	]];
	var dataGridOption = {
		fit: true,
		toolbar: '#toolBarPrescList',
		rownumbers: true,
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		columns: columns,
		url: $URL,
		idField: 'prescno',
		queryParams: {
			ClassName: "PHA.DEC.PrtLab.Query",
			QueryName: "QueryPrtLabList",
			inputStr: '',
			logonInfo: logonInfo
		},
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			if(ComPropData.ViewDecInfo=="Y") { 
				DEC_PRINT.VIEW(ComPropData.decInfoId, {PrescNo: prescno});	
			}
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "labNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'labNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function () {
			$('#gridPrescList').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridPrescList", dataGridOption);
}
/**
 * 初始化已打签打签表格
 * @method InitGridPrescListPrt
 */
function InitGridPrescListPrt() {
	var columns = [[ 
		{field:'pdCheck',	checkbox: true },
		{field:'labNum',	title:'标签数',		align:'left', width: 60,
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					onChange: function(nval, oval){
		            	$("#gridPrescListPrt").datagrid('endEditing');
		        	}
				}
		}},
		{field:'patNo',		title:'登记号',		align:'left', width: 100}, 
		{field:'patName',	title:'患者姓名',	align:'left', width: 80 }, 
		{field:'prescno', 	title:'处方号',	  	align:'left', width: 130}, 
		{field:'deptLoc', 	title:'科室',	  	align:'left', width: 150}, 
		{field:'pdPst', 	title:'当前流程',	align:'left', width: 70 }, 
		{field:'pdPrtDate',	title:'打签时间', 	align:'left', width: 150},
		{field:'pdPrtUser',	title:'打签人',		align:'left', width: 80 },
		{field:'pdType', 	title:'煎药类型', 	align:'left', width: 70 }, 
		{field:'comFlag',	title:'完成标志', 	align:'left', width: 70 }, 
		{field:'pdDate',	title:'生成时间', 	align:'left', width: 150},
		{field:'preFacTor',	title:'付数',		align:'left', width: 45 }, 
		{field:'preCount',	title:'味数',		align:'left', width: 45 }, 
		{field:'preForm',	title:'处方剂型',	align:'left', width: 70 }, 
		{field:'preEmFlag',	title:'是否加急',	align:'left', width: 70 }, 
		{field:'phaLoc',	title:'调剂科室',	align:'left', width: 100}, 
		{field:'operUser',	title:'调剂人',		align:'left', width: 80 },
		{field:'operDate',	title:'调剂时间',	align:'left', width: 150},
		{field:'cookCost',	title:'煎药费',		align:'right', width: 150}
	]];
	var dataGridOption = {
		fit: true,
		toolbar: '#toolBarPrescListPrt',
		rownumbers: true,
		pagination: true,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		width : 1500 ,
		nowrap:false,
		idField: 'prescno',
		columns: columns,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.PrtLab.Query",
			QueryName: "QueryPrtLabList",
			inputStr: ''
		},
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			if(ComPropData.ViewDecInfo=="Y") { 
				DEC_PRINT.VIEW(ComPropData.decInfoId, {PrescNo: prescno});	
			}
		},
		onClickCell: function(rowIndex, field, value) {
			if (field == "labNum"){
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'labNum'
                });
            }else {
                $(this).datagrid('endEditing');
            }
        },
		onLoadSuccess: function () {
			$('#gridPrescListPrt').datagrid('uncheckAll');
		}
	};
	PHA.Grid("gridPrescListPrt", dataGridOption);
}
/**
 * 保存打签数据,并且预览显示、打印、列表增加数据
 * @method savePrtLabState
 */
function savePrtLabState(){
	var prescno = $("#txtBarCode").val();
	if(prescno==""){
		PHA.Popover({showType: "show", msg: "处方号为空！", type: 'alert'});
		return;
	}
	var type = $("input[name='busType']:checked").val() || "";
	var decLocId = $('#cmbDecLoc').combobox("getValue")||session['LOGON.CTLOCID'];
	var opUser = session['LOGON.USERID'];
	var packNum = $('#txtPackNum').numberbox('getValue');
	/*
	if(packNum == ""){
		PHA.Popover({showType: "show", msg: "请输入标签数量！", type: 'alert'});
		return;
	}else
	*/ 
	if((packNum <=0)&&(packNum !== "")){
		PHA.Popover({showType: "show", msg: "标签数量必须大于0！", type: 'alert'});
		return;
	}

	var params = prescno +"^"+ decNumber +"^"+ opUser +"^"+ type +"^"+ decLocId +"^"+ packNum;
	$cm({
		ClassName: "PHA.DEC.PrtLab.OperTab",
		MethodName: "SavePrtLabSta",
		params: params,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({
				showType: "show",
				msg: retData,
				type: 'error'
			});
		}else{
			var prtData = DEC_PRINT.Data({PrescNo: prescno});
			$("#gridPresc").datagrid("insertRow",{
				index: 0, 
				row:{
					type: prtData.Para.Type, 
					labNum: prtData.Para.LabNum,
					patNo: prtData.Para.PatNo,
					patName: prtData.Para.PatName, 
					prescno: prescno, 
					pdLoc: prtData.Para.DeptLoc 
				}
			})
			$("#gridPresc").datagrid("selectRecord",prescno);
			var totalRows =$('#gridPresc').datagrid('getRows').length;
			if(totalRows>PAGESIZE){		//超过设置的行数，每增加一条，就删一条之前的数据
				$("#gridPresc").datagrid("deleteRow",PAGESIZE);
			}
			DEC_PRINT.PRINT.LodopPrint({PrescNo: prescno});
		}
		$("#txtBarCode").val("");
		$('#txtPackNum').numberbox('setValue', '');
		$("#txtBarCode").focus();
	});	
}
/**
 * 查询打签数据
 * @method queryPrtLabList
 */
function queryPrtLabList(){	
	var tabTitle = $('#tabPrt').tabs('getSelected').panel('options').title;
	if (tabTitle == "扫码打签") {
		PHA.Popover({showType: "show", msg: "扫码打签无需查询，直接扫码即可！", type: 'alert'});
		return ;
	}
	var inputStr = getParams();
	if(!inputStr) return;
	
	if (tabTitle == "批量打签") {
		var prtFalg = "false";
		inputStr = inputStr +"^"+ prtFalg;
		$('#gridPrescList').datagrid('query', {
			inputStr: inputStr
		});
	}else if(tabTitle == "已打签查询"){
		var prtFalg = "true";
		inputStr = inputStr +"^"+ prtFalg;
		$('#gridPrescListPrt').datagrid('query', {
			inputStr: inputStr
		});
	}
}
/**
 * 获取界面元素值
 * @method getParams
 */
function getParams(){
	var stDate = $("#dateStart").datebox('getValue');
	if(stDate==""){
		PHA.Popover({showType: "show", msg: "请选择开始时间！", type: 'alert'});
		return null;
	}
	var enDate = $("#dateEnd").datebox('getValue');
	if(enDate==""){
		PHA.Popover({showType: "show", msg: "请选择截止时间！", type: 'alert'});
		return null;
	}
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var locId = $('#cmbDecLoc').combobox("getValue")||"";
	if(locId==""){
		PHA.Popover({showType: "show", msg: "请选择煎药室！", type: 'alert'});
		return null;
	}
	var type = $("input[name='busType']:checked").val() || "";
	var phaLocId = $('#cmbPhaLoc').combobox("getValue")||"";
	var docLocId = $('#cmbDocLoc').combobox("getValue")||"";
	var patNo = $('#txtPatNo').val();
	var params = stDate +"^"+ enDate +"^"+ stTime +"^"+ enTime +"^"+ locId; 
		params += "^"+ type +"^"+ phaLocId +"^"+ decNumber +"^"+ docLocId +"^"+ patNo;
	return params;
}
/**
 * 批量打印标签
 * @method printSelPrtLab
 */
function printSelPrtLab(){
	var checkedData = $('#gridPrescList').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要打印的处方！", type: 'alert'});
		return;
	}
	var prescnoStr = "";
	for(var i in checkedData){
		var prescno = checkedData[i].prescno;
		var labNum = checkedData[i].labNum;
		if (labNum>0){
			var tmpPrescno = prescno +"@"+ labNum;
			prescnoStr = prescnoStr == "" ? tmpPrescno : prescnoStr +"!!"+ tmpPrescno;
		}
	}
	savePrtLabStateBatch(prescnoStr);
}
/**
 * 批量保存打签数据
 * @method savePrtLabStateBatch
 */
function savePrtLabStateBatch(prescnoStr){
	if(prescnoStr == ""){ return; }
	var type = $("input[name='busType']:checked").val() || "";
	var decLocId = $('#cmbDecLoc').combobox("getValue")||"";
	var opUser = session['LOGON.USERID'];
	var params = prescnoStr +"^"+ decNumber +"^"+ opUser +"^"+ type +"^"+ decLocId + "^" ;
	$cm({
		ClassName: "PHA.DEC.PrtLab.OperTab",
		MethodName: "SavePrtLabStaBatch",
		params: params,
		dataType: "text"
	},function(retData) {
		var result = retData.split("^")[0];
		var errCode = retData.split("^")[1];
		if (result < 0){ 
			PHA.Popover({
				showType: "show",
				msg: retData,
				type: 'error'
			});
		}else{
			var prescnoArr = prescnoStr.split("!!");
			for(var i in prescnoArr){
				var prescno = prescnoArr[i].split("@")[0];
				DEC_PRINT.PRINT.LodopPrint({PrescNo: prescno});
			}
			queryPrtLabList();	
		}
	})
}
/**
 * 重打标签
 * @method printPrtLab
 */
function printPrtLab(){
	var checkedData = $('#gridPrescListPrt').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要打印的处方！", type: 'alert'});
		return;
	}
	for(var i in checkedData){
		var prescno = checkedData[i].prescno;
		var labNum = checkedData[i].labNum;
		if (labNum>0){
			DEC_PRINT.PRINT.LodopPrint({PrescNo: prescno, Num: labNum});
		}
	}
}
/**
 * 批量修改标签数量
 * @method editLabNumBat
 */
function editLabNumBat(){
	var labNum = $('#txtEditNum').numberbox('getValue');
	if(labNum == ""){
		PHA.Popover({showType: "show", msg: "请输入标签数量！", type: 'alert'});
		return;
	}else if(labNum <=0){
		PHA.Popover({showType: "show", msg: "标签数量必须大于0！", type: 'alert'});
		return;
	}
	var checkedData = $('#gridPrescList').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要修改的处方！", type: 'alert'});
		return;
	}
	for(var i in checkedData){
		checkedData[i].labNum = labNum;
		var rowIndex = $('#gridPrescList').datagrid('getRowIndex', checkedData[i].prescno);
		$('#gridPrescList').datagrid('refreshRow', rowIndex)
	}
	$('#txtEditNum').numberbox('setValue', '');
}

/**
 * 批量修改标签数量(已打签查询)
 * @method editLabNumBat
 */
function reEditLabNumBat(){
	var labNum = $('#txtReEditNum').numberbox('getValue');
	if(labNum == ""){
		PHA.Popover({showType: "show", msg: "请输入标签数量！", type: 'alert'});
		return;
	}else if(labNum <=0){
		PHA.Popover({showType: "show", msg: "标签数量必须大于0！", type: 'alert'});
		return;
	}
	var checkedData = $('#gridPrescListPrt').datagrid('getChecked');
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要修改的处方！", type: 'alert'});
		return;
	}
	for(var num in checkedData){
		checkedData[num].labNum = labNum;
		var rowIndex = $('#gridPrescListPrt').datagrid('getRowIndex', checkedData[num].prescno);
		$('#gridPrescListPrt').datagrid('refreshRow', rowIndex)
	}
	$('#txtReEditNum').numberbox('setValue', '');
}

/**
 * 切换页签
 * @method ChangeTabs
 */
function ChangeTabs() {
	var tabId= $('#tabPrt').tabs('getSelected').attr("id");
	if(NowTAB==tabId){
		return;
	}
	if(ComPropData.ViewDecInfo=="Y"){
		var decInfoId = DEC_PRINT.DecInfo("mainLayout");	
		DEC_PRINT.VIEW(decInfoId, {PrescNo: ""});
	}	
		
	NowTAB=tabId;
	if (NowTAB == "tabScanLable") {
		$('#gridPresc').datagrid('clear');
		$("#dateStart").datebox("setValue", "");
		$("#dateEnd").datebox("setValue", "");
		$('#timeStart').timespinner('setValue',"");
		$('#timeEnd').timespinner('setValue',"");
		$('#cmbDocLoc').combobox("setValue","");
		$("#cmbPhaLoc").combobox("setValue", "");
		$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		$("#txtBarCode").focus();
		$HUI.datebox("#dateStart").disable();
		$HUI.datebox("#dateEnd").disable();
		$HUI.timespinner("#timeStart").disable();
		$HUI.timespinner("#timeEnd").disable();
		$HUI.combobox("#cmbDocLoc").disable();
		$HUI.combobox("#cmbPhaLoc").disable();
		$('#txtPatNo').val("").prop('disabled', true);
	}
	else{
		if (NowTAB == "tabPrintBatLable") {
			$('#gridPrescList').datagrid('clear');
		}
		else {
			$('#gridPrescListPrt').datagrid('clear');
		}
		$("#dateStart").datebox("setValue", PrintPropData.PrtStartDate);
		$("#dateEnd").datebox("setValue", PrintPropData.PrtEndDate);
		$('#timeStart').timespinner('setValue',"00:00:00");
		$('#timeEnd').timespinner('setValue',"23:59:59");
		$('#cmbDocLoc').combobox("setValue","");
		$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		$HUI.datebox("#dateStart").enable();
		$HUI.datebox("#dateEnd").enable();
		$HUI.timespinner("#timeStart").enable();
		$HUI.timespinner("#timeEnd").enable();
		$HUI.combobox("#cmbDocLoc").enable();
		$HUI.combobox("#cmbPhaLoc").enable();
		$('#txtPatNo').val("").prop('disabled', false);	
		setTimeout("queryPrtLabList();",500);
	}
}



/*
 * 清屏
 * @method Clear
 */
function Clear() {
	$('#gridPresc').datagrid('clear');
	$('#gridPrescList').datagrid('clear');
	$('#gridPrescListPrt').datagrid('clear');
	SetDefVal(false);
	
}
