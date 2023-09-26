/*
 *模块:移动住院药房
 *子模块:移动住院药房-护士领药审核
 *createdate:2016-10-21
 *creator:dinghongying
*/

$(function(){
	/* 初始化插件 start*/
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		locale: {
			format: DATEFMT
		}
	}
	$("#date-daterange").dhcphaDateRange(daterangeoptions);
	
	//给日期控件赋初始化值！
	var configstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaflag",gLocId);
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateT(startdate);
	enddate=FormatDateT(enddate);
	$("#date-daterange").data('daterangepicker').setStartDate(startdate);
	$("#date-daterange").data('daterangepicker').setEndDate(enddate);
	
	InitGirdPreList();
	InitGridPreIncList();
	InitGirdPreOrderList();
	
	/* 表单元素事件 start*/
	//卡号失去焦点触发事件
	$('#txt-cardno').on('blur',function(event){
		var cardno=$.trim($("#txt-cardno").val());
		$('#currentnurse').text("");
		$('#currentctloc').text("");
		if (cardno!=""){
			var defaultinfo=tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod","GetUserDefaultInfo",cardno);
			if (defaultinfo==null||defaultinfo==""){
			dhcphaMsgBox.alert("输入工号有误，请核实!");
			$('#txt-cardno').val("");
			return;
			}
		var ss=defaultinfo.split("^");
		$('#currentnurse').text(ss[2]);
		$('#currentctloc').text(ss[4]);
		$('#txt-cardno').val("");				
		}
	});

	InitBodyStyle();
})

//初始化备药单列表table
function InitGirdPreList(){
	var columns=[
		{header:'ID',index:'TPhdwID',name:'TPhdwID',width:60,hidden:true},
		{header:'备药单号',index:'TPhdwNo',name:'TPhdwNo',width:160},
		{header:'备药日期',index:'TPhdwDate',name:'TPhdwDate',width:100},
		{header:'备药时间',index:'TPhdwTime',name:'TPhdwTime',width:100},
		{header:'备药人',index:'TPhdwCompUser',name:'TPhdwCompUser',width:100}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhDrawList',	
	    height: OutFYCanUseHeight()+120,
	    recordtext:"",
	    pgtext:"",
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridPreInc();
		},loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-dispdetail").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
		
	};
	$("#grid-preparelist").dhcphaJqGrid(jqOptions);
}

//初始化备药单药品汇总table
function InitGridPreIncList(){
	var columns=[
		{header:'TPhdwiID',index:'TPhdwiID',name:'TPhdwiID',width:60,hidden:true},
	    {header:'药品名称',index:'TInciDesc',name:'TInciDesc',width:360},
	    {header:'规格',index:'TSpec',name:'TSpec',width:100},
	    {header:'单位',index:'TPhdwUom',name:'TPhdwUom',width:100},
	    {header:'备药数量',index:'TQtyTotal',name:'TQtyTotal',width:80},
	    {header:'实发数量',index:'TQtyActual',name:'TQtyActual',width:80}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhDrawIncList',		
	    height: OutFYCanUseHeight()*0.5,
	    multiselect: false,
	    pager: "#jqGridPager", //分页控件的id  
	    shrinkToFit:false,
	    onSelectRow:function(id,status){
			QueryGridPreOrder();
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-preorderlist").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	};
	$("#grid-preinclist").dhcphaJqGrid(jqOptions);
}

//备药单病人明细table
function InitGirdPreOrderList(){
	var columns=[
		{header:'登记号',index:'TPatNo',name:'TPatNo',width:80,align:'left'},
	    {header:'姓名',index:'TPatName',name:'TPatName',width:150,align:'left'},
		{header:'床位号',index:'TBed',name:'TBed',width:80,align:'right'},
		{header:'单位',index:'TDspUom',name:'TDspUom',width:60},
		{header:'应发数',index:'TDspQty',name:'TDspQty',width:100},
		{header:'备药数',index:'TQty',name:'TQty',width:100}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhDrawOrderList',	
	    height: OutFYCanUseHeight()*0.5,
	    shrinkToFit:false
	};
	$("#grid-preorderlist").dhcphaJqGrid(jqOptions);
}

//查询备药单列表
function QueryGridPre(){
	var currentnurse=$.trim($("#currentnurse").text());
	var currentctloc=$.trim($("#currentctloc").text());
	if (currentnurse==null||currentnurse==""||currentctloc==null||currentctloc==""){
	    dhcphaMsgBox.alert("请先刷领药人的卡或者输入工号!");
	    return;
	}
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange);                       
 	var stdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];	
	var params=stdate+"^"+enddate+"^"+gLocId;

	$("#grid-preparelist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//查询备药单药品汇总
function QueryGridPreInc(){
	var selectid = $("#grid-preparelist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-preparelist").jqGrid('getRowData', selectid);
	var phdwid=selrowdata.TPhdwID;
	var params=phdwid;

	$("#grid-preinclist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
	$("#grid-preorderlist").clearJqGrid();
}

//查询备药单病人明细
function QueryGridPreOrder(){
	var selectid = $("#grid-preinclist").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-preinclist").jqGrid('getRowData', selectid);
	var phdwiid=selrowdata.TPhdwiID;
	var params=phdwiid;
	$("#grid-preorderlist").setGridParam({
		postData:{
			'params':params
		}	
	}).trigger("reloadGrid");
}

//清空
function ClearConditions(){
	$('#currentnurse').text("");
	$('#currentctloc').text("");
	$("#grid-preparelist").clearJqGrid();
	$("#grid-preinclist").clearJqGrid();
	$("#grid-preorderlist").clearJqGrid();
	var tmpstartdate=FormatDateT("t-2")
	$("#date-daterange").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	return
	if ($("#col-right").is(":hidden")==false){
		$("#col-right").hide();
		$("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
	}else{
		$("#col-right").show()
		$("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
	}
	$("#grid-preparelist").setGridWidth("")
	$("#grid-preinclist").setGridWidth("")
	$("#grid-preorderlist").setGridWidth("")
}

//本页面table可用高度
function OutFYCanUseHeight(){
	var height1=$("[class='container-fluid dhcpha-condition-container']").height();
	var height3=parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4=parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5=parseFloat($("[class='panel-heading']").height());
	var tableheight=$(window).height()-height1*2-2*height3-2*height4-2*height5-125;
	return tableheight;
}

function InitBodyStyle(){
	$("#grid-preparelist").setGridWidth("")
}

