/*
模块:		移动药房
子模块:		移动药房-病区已签收查询
Creator:	hulihua
CreateDate:	2017-05-25
*/
$(function(){	
	/* 初始化插件 start*/
	/*
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT+" HH:mm:ss"
		}
	}
	$("#date-daterange").dhcphaDateRange(daterangeoptions);
	*/
	
	var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t-3") ;
	var enddate = FormatDateT("t") ;
    var starttime = '00:00:00';
    var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate+ ' ' + starttime);
    $('#date-start').data('daterangepicker').setEndDate(startdate+ ' ' + starttime);
    $('#date-end').data('daterangepicker').setStartDate(enddate+ ' ' + endtime);			
    $('#date-end').data('daterangepicker').setEndDate(enddate+ ' ' + endtime);				
	
  	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	InitNurseRecList();

	$("#nurserecdg").closest(".panel-body").height(GridCanUseHeight(1)-26);	
	
})

//初始化护士已签收列表
function InitNurseRecList(){
	var columns=[
		{header:'TPhbID',index:'TPhbID',name:'TPhbID',width:30,hidden:true},
	    {header:'箱号',index:'TPhbNo',name:'TPhbNo',width:60},
		{header:'箱数',index:'TPhbNum',name:'TPhbNum',width:30},
		{header:'药房交接人',index:'TUserPhHand',name:'TUserPhHand',width:60},
		{header:'药房交接日期',index:'TDatePhHand',name:'TDatePhHand',width:60},
		{header:'药房交接时间',index:'TTimePhHand',name:'TTimePhHand',width:60},
		{header:'物流人员',index:'TUserLogistics',name:'TUserLogistics',width:60},
		{header:'病区交接人',index:'TUserWardHand',name:'TUserWardHand',width:60},
		{header:'病区交接日期',index:'TDateWardHand',name:'TDateWardHand',width:60},
		{header:'病区交接时间',index:'TTimeWardHand',name:'TTimeWardHand',width:60},
		{header:'病区核对人',index:'TUserWardChk',name:'TUserWardChk',width:60},
		{header:'病区核对日期',index:'TDateWardChk',name:'TDateWardChk',width:60},
		{header:'病区核对时间',index:'TTimeWardChk',name:'TTimeWardChk',width:60}
	    
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTNurseReceive.NurseReceiveQuery&MethodName=GetWardNurseRecList',	
	    height:GridCanUseHeight(1)-36,
	    shrinkToFit:true
	};
	$("#nurserecdg").dhcphaJqGrid(jqOptions);
}

///药房工作量统计查询
function Query()
{
	var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var params=startdate+"^"+starttime+"^"+enddate+"^"+endtime+"^"+gLocId;
	$("#nurserecdg").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
		
}

//清空
function ClearConditions(){
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t")+" "+"23:59:59");
	$('#nurserecdg').clearJqGrid();
}