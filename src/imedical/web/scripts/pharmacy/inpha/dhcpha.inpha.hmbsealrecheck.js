/*
模块:		草药房
子模块:		草药房-封箱前复核
Creator:	hulihua
CreateDate:	2017-09-21
*/
$(function(){
	/* 初始化插件 start*/
	//$("#date-daterange").dhcphaDateRange();
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
	var startdate = FormatDateT("t") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime
    
	InitPhaWard(); 				//病区
	InitGraPrescnoList();
    /* 初始化插件 end*/
})

window.onload=function(){
	setTimeout("QueryBSealPre()",200);
}

//初始化颗粒剂处方列表
function InitGraPrescnoList(){
	var columns=[
		{header:'TPhmbi',index:'TPhmbi',name:'TPhmbi',width:5,hidden:true},
		{header:'TOldWardLocDr',index:'TOldWardLocDr',name:'TOldWardLocDr',width:5,hidden:true},
		{header:'TAdmWardLocDr',index:'TAdmWardLocDr',name:'TAdmWardLocDr',width:5,hidden:true},
		{header:'已揭病区',index:'TOldWardLoc',name:'TOldWardLoc',width:100},
		{header:'新病区',index:'TAdmWardLoc',name:'TAdmWardLoc',width:100},
	    {header:'住院号',index:'TPatCardNo',name:'TPatCardNo',width:50},
	    {header:'登记号',index:'TPatNo',name:'TPatNo',width:50},
		{header:'姓名',index:'TPatName',name:'TPatName',width:60},
		{header:'床位',index:'TBed',name:'TBed',width:30},
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:60},
		{header:'袋数',index:'TActUncovMedPocNum',name:'TActUncovMedPocNum',width:30,align:'right'},
		{header:'揭药人',index:'TBrothDispUser',name:'TBrothDispUser',width:60},
		{header:'揭药时间',index:'TActUncovMedDate',name:'TActUncovMedDate',width:80},
	];
	 var jqOptions={
		colModel: columns, //列
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery&MethodName=GetBSealPrescnoList',
		multiselect: true,
		shrinkToFit:false,		
		rownumbers: true,	//是否显示行号
		height:GridCanUseHeight(2)+34,
	    pager: "#jqGridPager", 	//分页控件的id  
	    shrinkToFit:false,
	} 
   //定义datagrid	
   $('#grid-bsealchprelist').dhcphaJqGrid(jqOptions);
}

///查询
function QueryBSealPre()
{
	/*
	var daterange=$("#date-daterange").val(); 
	daterange=FormatDateRangePicker(daterange); 
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var wardloc=$('#sel-phaward').val();
	if (wardloc==null){wardloc=""};
	var params=startdate+"^"+enddate+"^"+wardloc;
	$("#grid-bsealchprelist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///确认接收
function ConfirmReceive(){
	var selectids=$("#grid-bsealchprelist").jqGrid('getGridParam','selarrrow');
	if ((selectids=="")||(selectids==null)){
		dhcphaMsgBox.alert("请先选中需要复核的处方记录");
		return;
	}
	
	var ListDataStr="";
	$.each(selectids,function(){
		var rowdata = $('#grid-bsealchprelist').jqGrid('getRowData',this);
		var Phmbi=rowdata.TPhmbi;
		if(ListDataStr==""){
			ListDataStr=Phmbi;	
		}else{
			ListDataStr=ListDataStr+"&&"+Phmbi;
		}
	})
	
	var RetResult=tkMakeServerCall("web.DHCINPHA.HMBSealReCheck.BSealReCheckQuery","SaveBSealPre",ListDataStr);
	var RetCode=RetResult.split("^")[0];
	var RetMessage=RetResult.split("^")[1];
	if(RetCode!=0){
		dhcphaMsgBox.alert("复核失败，"+RetMessage);
		return;
	}else{
		dhcphaMsgBox.alert("复核成功！");
		QueryBSealPre();
	}
}

///清空
function ClearConditions(){	
	//给日期控件赋初始化值！
	//$("#date-daterange").data('daterangepicker').setStartDate(new Date());
	//$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#sel-phaward").empty();
	$('#grid-bsealchprelist').clearJqGrid();
}