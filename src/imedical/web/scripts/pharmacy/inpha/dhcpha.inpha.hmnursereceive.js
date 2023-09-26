/*
模块:		草药房
子模块:		草药房-颗粒剂护士接收
Creator:	dinghongying
CreateDate:	2017-07-13
*/
$(function(){
	/* 初始化插件 start*/
	/*
	$("#date-daterange").dhcphaDateRange();
	var tmpstartdate=FormatDateT("t-3")
	var tmpenddate=FormatDateT("t")
	$("#date-daterange").data('daterangepicker').setStartDate(tmpstartdate);
	$("#date-daterange").data('daterangepicker').setEndDate(tmpenddate);
	*/
	var daterangeoptions = {
        timePicker: false,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT		//+ ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t-3") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
	
	InitGraPrescnoList();
    /* 初始化插件 end*/
    $("#chk-receive").on("ifChanged",function(){
		QueryPhacPre()
	})
	
	$('#txt-barcode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			GetLablePres();	 
		}     
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
	
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("QueryPhacPre()",500);
}

//初始化颗粒剂处方列表
function InitGraPrescnoList(){
	var columns=[
		{header:'TPhac',index:'TPhac',name:'TPhac',width:5,align:'left',hidden:true},
	    {header:'住院号',index:'TPatMedNo',name:'TPatMedNo',width:50},
	    {header:'登记号',index:'TPatNo',name:'TPatNo',width:50},
		{header:'姓名',index:'TPatName',name:'TPatName',width:60},
		{header:'床位',index:'TBed',name:'TBed',width:30},
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:60},
		{header:'服药方式',index:'TInstruc',name:'TInstruc',width:50},
		{header:'付数',index:'TFacotor',name:'TFacotor',width:30,align:'right'},
		{header:'发药药房',index:'TPhaLoc',name:'TPhaLoc',width:60,align:'left'},
		{header:'发药人',index:'TCollectUser',name:'TCollectUser',width:60},
		{header:'发药时间',index:'TCollectDate',name:'TCollectDate',width:80},
		{header:'接收人',index:'TAuditor',name:'TAuditor',width:60},
		{header:'接收时间',index:'TAuitDate',name:'TAuitDate',width:80}
	];
	 var jqOptions={
		colModel: columns, //列
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMNurseReceive.NurseReceiveQuery&MethodName=GetNurRecPrescnoList',
		multiselect: true,
		shrinkToFit:false,
		rownumbers:true,		//是否显示行号
		height:GridCanUseHeight(2)+34,
	    pager: "#jqGridPager", 	//分页控件的id  
	    shrinkToFit:false,
	} 
   //定义datagrid	
   $('#grid-dispgrareceive').dhcphaJqGrid(jqOptions);
}

///查询
function QueryPhacPre()
{
	/*
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange); 
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var receive="N";
	if($("#chk-receive").is(':checked')){
		receive="Y";
	}
	var params=startdate+"^"+enddate+"^"+gWardID+"^"+receive;
	$("#grid-dispgrareceive").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///确认接收
function ConfirmReceive(){
	var selectids=$("#grid-dispgrareceive").jqGrid('getGridParam','selarrrow');
	if ((selectids=="")||(selectids==null)){
		dhcphaMsgBox.alert("请先选中需要接收的处方记录");
		return;
	}
	
	var PhacStr="";
	$.each(selectids,function(){
		var rowdata = $('#grid-dispgrareceive').jqGrid('getRowData',this);
		var Phac=rowdata.TPhac;
		if(PhacStr==""){
			PhacStr=Phac;	
		}else{
			PhacStr=PhacStr+"^"+Phac;
		}
	})
	var params=PhacStr+"&&"+gUserID;
	var ret=tkMakeServerCall("web.DHCINPHA.HMNurseReceive.NurseReceiveQuery","SavaPhacNurseRevice",params);
	if(ret!=0){
		if(ret==-1){
			dhcphaMsgBox.alert("未选中需要接收的信息，请核实!");
			return;	
		}else if(ret==-2){
			dhcphaMsgBox.alert("接受人为空，请核实!");
			return;
		}else if(ret==-3){
			dhcphaMsgBox.alert("该处方已接收，请核实!");
			return;
		}else{
			dhcphaMsgBox.alert("接收有误"+ret);
			return;
		}
	}else{
		dhcphaMsgBox.alert("接收成功！");
		QueryPhacPre();
	}
}

///清空
function ClearConditions(){	
	//给日期控件赋初始化值！
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#txt-barcode").val("");
	$("#chk-receive").iCheck("uncheck");
	$('#grid-dispgrareceive').clearJqGrid();
}

function GetLablePres(){
	DhcphaTempBarCode="";
	var barcode=$.trim($("#txt-barcode").val());
	if(barcode==""||barcode==null){
		return;
	}
	$("#txt-barcode").val("");
	var dispgridrows=$("#grid-dispgrareceive").getGridParam('records');
	var quitflag=0;
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$("#grid-dispgrareceive").jqGrid('getRowData',i);
		var tmpbarcode=tmpselecteddata["TPrescNo"];
		if (tmpbarcode==barcode){
			quitflag=1;
			$("#grid-dispgrareceive").jqGrid('setSelection',i);
			return;	
		}
	}
	if (quitflag==0){
		dhcphaMsgBox.alert("没有需要接收的处方！");
		return;
	}
}

function CheckTxtFocus(){
	var txtfocus=$("#txt-barcode").is(":focus");
	if (txtfocus!=true){
		return false;
	}
	return true;	
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler(){
	if (CheckTxtFocus()!=true){
		if (event.keyCode==13){
			var BarCode=tkMakeServerCall("web.DHCST.Common.JsonObj","GetData",DhcphaTempBarCode);
			if (BarCode.indexOf("I")>-1){
				$("#txt-barcode").val(BarCode);
				GetLablePres();
			}
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}