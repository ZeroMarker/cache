
/**
 *	麻醉药品、第一类精神药品回收登记
 */
var url="dhcpha.clinical.action.csp";
$(function(){
	
	//初始化界面默认信息
	InitUIDefault();
	
	//初始化咨询信息列表
	InitDetList();
	
	//初始化界面按钮事件
	InitWidListener();
})

///初始化界面默认信息
function InitUIDefault(){

	/**
	 * 起始、截止日期
	 */
	$("#startDate").datebox("setValue", formatDate(0));
	$("#endDate").datebox("setValue", formatDate(0));

	/**
	 * 供给科别
	 */
	var srInDeptCombobox = new ListCombobox("srInDept",url+'?action=QueryConDept','');
	srInDeptCombobox.init();
	//$("#srInDept").combobox("setValue",LgCtLocID);
}

/// 界面元素监听事件
function InitWidListener(){

	$("a:contains('查询')").bind("click",findPoiExaReg);
	$("a:contains('导出')").bind("click",expPoiExaReg);
	$("a:contains('打印')").bind("click",prtPoiExaReg);
	$("#srInciDesc").bind("keydown",function(event){
        if(event.keyCode == "13"){
			if ($("#srInciDesc").val() == ""){return;}
			var mydiv = new UIDivWindow($("#srInciDesc"), $("#srInciDesc").val(), setCurrEditCellVal);
            mydiv.init();
        }
    });
}

/// 给当前编辑栏赋值
function setCurrEditCellVal(rowObj){
	
	if (rowObj == null){
		$("#srInciDesc").focus().select();  ///设置焦点 并选中内容
		return;
	}
	///药品名称	
	$("#srInciDesc").val(rowObj.InciDesc);
	///药品名称ID	
	$("#srInci").val(rowObj.InciDr);
}

///初始化病人列表
function InitDetList(){

	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'srIngrDate',title:'日期',width:100},
		{field:'srInciDesc',title:'药品名称',width:220},
		{field:'srForm',title:'剂型',width:80},
		{field:'srSpec',title:'规格',width:80},
		{field:'srCertNo',title:'凭证号',width:100},
		{field:'srVendor',title:'供货单位/领用部门',width:320},
		{field:'srUomDesc',title:'单位',width:80},
		{field:'srInQty',title:'领入数量',width:80},
		{field:'srOutQty',title:'消耗数量',width:80},
		{field:'srResQty',title:'结余数量(基本单位)',width:120},
		{field:'srBatNo',title:'批号',width:100},
		{field:'srExpDate',title:'有效期',width:100},
		{field:'srManf',title:'生产企业',width:120},
		{field:'srSendFlag',title:'发药人',width:100},
		{field:'srExaUsr',title:'复核人',width:100},
		{field:'srIngUsr',title:'领用人',width:100}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'明细',
		//nowrap:false,
		singleSelect : true
	};
		
	var srDetListComponent = new ListComponent('srDetList', columns, '', option);
	srDetListComponent.Init();

	initScroll("#srDetList");//初始化显示横向滚动条
}

///  查找验收单据
function findPoiExaReg(){
	
	//1、清空datagrid 
	$('#srDetList').datagrid('loadData', {total:0,rows:[]}); 

	//2、查询
	var srStartDate = $('#startDate').datebox('getValue');   //起始日期
	var srEndDate = $('#endDate').datebox('getValue'); 	     //截止日期
	var srInDept = $('#srInDept').combobox('getValue');      //入库科室
	if (srInDept == ""){
		$.messager.alert("提示:","查询失败，原因："+"请先选择入库部门！");
	}
	var srInci = $('#srInci').val();  	 					 //药品ID

	var ListData = srStartDate + "^" + srEndDate + "^" + srInDept + "^" + srInci;

	$('#srDetList').datagrid({
		url:url+'?action=jsonpoidruginoutloc',
		queryParams:{
			param : ListData}
	});
}
function expPoiExaReg(){

gridSaveAsExcel(datagrid);
}

/*
/// 导出验收单据
function expPoiExaReg(){

	//2、查询
	var srStartDate = $('#startDate').datebox('getValue');   //起始日期
	var srEndDate = $('#endDate').datebox('getValue'); 	     //截止日期
	var srInDept = $('#srInDept').combobox('getValue');      //入库科室
	if (srInDept == ""){
	
		$.messager.alert("提示:","导出失败，原因："+"请先选择入库部门！");
	}
	var srInci = $('#srInci').val();  	 					 //药品ID

    fileName="DHCST_INGd_YKExport.raq&StartDate="+srStartDate+"&EndDate="+srEndDate+"&LocID="+srInDept+"&Inci="+srInci;
	DHCCPM_RQPrint(fileName);
	
}
*/
/// 打印验收单据
function prtPoiExaReg(){
	$(".my_show").jqprint(findPoiExaReg()); 
	
    //fileName="DHCST_INGd_YKExport.raq&StartDate="+srStartDate+"&EndDate="+srEndDate+"&LocID="+srInDept+"&Inci="+srInci;
	//DHCCPM_RQPrint(fileName);

}