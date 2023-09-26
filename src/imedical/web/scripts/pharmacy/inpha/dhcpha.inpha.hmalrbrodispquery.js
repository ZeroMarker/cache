/*
模块:		住院草药房
子模块:		住院草药房-已揭药查询
Creator:	hulihua
CreateDate:	2017-11-24
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
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
    
	InitPhaWard();
    InitBroDispList();
    InitBroDispDetList();
    //登记号回车事件
	$('#txt-regno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-regno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryGridBroPre();
			}	
		}
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	ResizeDispQuery() ;
})

//初始化已揭药处方列表
function InitBroDispList(){
	//定义columns
	var columns=[
		{header:'TPid',index:'TPid',name:'TPid',width:30,hidden:true},
		{header:'TPhmbId',index:'TPhmbId',name:'TPhmbId',width:30,hidden:true},
		{header:'登记号',index:'TPatNo',name:'TPatNo',width:30},
		{header:'床号',index:'TBedNo',name:'TBedNo',width:20},
		{header:'姓名',index:'TPatName',name:'TPatName',width:40},
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:30},
		{header:'付数',index:'TFactor',name:'TFactor',width:15},
		{header:'剂型',index:'TPrescForm',name:'TPrescForm',width:20},
		{header:'用法',index:'TInstruc',name:'TInstruc',width:30},
		{header:'就诊科室',index:'TDocLoc',name:'TDocLoc',width:30},
		{header:'提交状态',index:'TSeekType',name:'TSeekType',width:30},
		{header:'提交护士',index:'TSeekUserName',name:'TSeekUserName',width:30},
		{header:'提交时间',index:'TSeekDate',name:'TSeekDate',width:40}
    ];
         
    var jqOptions={
	    colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.MS.AlrBroth.Query&MethodName=GetBroDispPreList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)*0.3+32,
		pager: "#jqGridPager", //分页控件的id
		onSelectRow:function(id,status){
			SelectQueryBroDetail();
			//$("#txt-regno").val("");
		},
		loadComplete: function(){ 
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				$("#grid-brodisppres").clearJqGrid();
			}else{
				$(this).jqGrid('setSelection',1);
			}
		}
	} 
   //定义datagrid	
   $('#grid-brodisppres').dhcphaJqGrid(jqOptions);
}

//初始化已揭药详细信息列表
function InitBroDispDetList(){
	//定义columns
	var columns=[
		{header:'应揭药日期',index:'TBrothDate',name:'TBrothDate',width:30},
		{header:'揭药人',index:'TBrothName',name:'TBrothName',width:30},
		{header:'揭药数量',index:'TActUnPocNum',name:'TActUnPocNum',width:30},
		{header:'实际揭药时间',index:'TActBrothDate',name:'TActBrothDate',width:30},
		{header:'状态',index:'TBrothStatue',name:'TBrothStatue',width:30},
		{header:'接收时间',index:'TNurCheckDate',name:'TNurCheckDate',width:30},
		{header:'接收人',index:'TNurCheckUser',name:'TNurCheckUser',width:30},
		{header:'接收科室',index:'TWardLoc',name:'TWardLoc',width:80,align:'left'}
    ];        
    var dataGridOption={
	    colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=PHA.MS.AlrBroth.Query&MethodName=GetBroDispDetList',
		height:GridCanUseHeight(1)*0.4,
		shrinkToFit:false,
		rownumbers: true,
		autoScroll:true
	} 
   //定义datagrid	
   $('#grid-brodispdetail').dhcphaJqGrid(dataGridOption);
}

///查询煎药处方信息
function QueryGridBroPre()
{
	var params=GetComCodtion();
	$("#grid-brodisppres").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///查询明细
function SelectQueryBroDetail(){
	var selectid = $("#grid-brodisppres").jqGrid('getGridParam', 'selrow');
	if(selectid==null){
		return;	
	}
	var selrowdata = $("#grid-brodisppres").jqGrid('getRowData', selectid);
	var phmbid=selrowdata.TPhmbId;
	if((phmbid==null)||(phmbid=="")){
		return;
	}
	var params=GetComCodtion()+tmpSplit+phmbid;
	$("#grid-brodispdetail").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

//获取界面的公共条件信息
function GetComCodtion(){
	$("#grid-brodispdetail").jqGrid("clearGridData");
	/*
	var daterange=$("#date-daterange").val();
	daterange=FormatDateRangePicker(daterange);
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	*/
	var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
	var wardLoc=$("#sel-phaward").val();
	if (wardLoc==null){
		wardLoc="";
	}
	var patno=$("#txt-regno").val();	
	var params=startdate+tmpSplit+enddate+tmpSplit+wardLoc+tmpSplit+patno;
	return params;
}

//清空
function ClearConditions(){
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#sel-phaward").empty();
	$("#txt-regno").val("");
	$('#grid-brodisppres').clearJqGrid();
	$('#grid-brodispdetail').clearJqGrid();
}

window.onresize = ResizeDispQuery;

function ResizeDispQuery() {
    var prestitleheight=$("#gview_grid-brodisppres .ui-jqgrid-hbox").height();
    var gridheight=DhcphaJqGridHeight(2,1)-prestitleheight;
	var winWidth=$(window).width()
	var gridWidth=winWidth-20
	var detailHeight=gridheight*0.5-20
	$("#grid-brodisppres").setGridWidth(gridWidth);
	$("#grid-brodisppres").setGridHeight(detailHeight);
	$("#grid-brodispdetail").setGridWidth(gridWidth);
	$("#grid-brodispdetail").setGridHeight(detailHeight);
}
