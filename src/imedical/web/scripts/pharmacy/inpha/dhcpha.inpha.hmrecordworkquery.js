/*
模块:		草药房
子模块:		草药房-手工记录工作量查询
Creator:	hulihua
CreateDate:	2018-03-01
*/
var tmpSplit=DHCPHA_CONSTANT.VAR.MSPLIT;
$(function(){
	/* 初始化插件 start*/
	$("#date-daterange").dhcphaDateRange();
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	InitPhaLoc(); 				//药房科室
	InitDecCond();				//状态
    InitRecordWorkList();
	$("#recordworkdg").closest(".panel-body").height(GridCanUseHeight(1));
})

//初始化发药工作量列表
function InitRecordWorkList(){
	//定义columns
	var columns=[
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:80},
		{header:'味数',index:'TPrescNoCount',name:'TPrescNoCount',width:15},
		{header:'付数',index:'TFactor',name:'TFactor',width:15},
		{header:'剂型',index:'TPrescForm',name:'TPrescForm',width:60},
		{header:'煎药方式',index:'TCoookType',name:'TCoookType',width:30},
		{header:'状态记录人',index:'TOperator',name:'TOperator',width:100},
		{header:'状态记录时间',index:'TOperatorDate',name:'TOperatorDate',width:120}
    ];
         
    var jqOptions={
	    colModel: columns, //列
		url:ChangeCspPathToAll(LINK_CSP)+'?ClassName=web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery&MethodName=GetRecordWorkList',
		shrinkToFit:false,
		rownumbers: true,
		height:GridCanUseHeight(1)-100,
		pager: "#jqGridPager", 	//分页控件的id
		loadComplete: function(){
			var grid_records = $(this).getGridParam('records');
			if (grid_records!=0){
				var RecordInfo=tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery","GetRecordInfo",gUserID);
				$('#recordinfo').text(RecordInfo);
			}else{
				$('#recordinfo').text("");
			}
		} 
	} 
   //定义datagrid	
   $('#recordworkdg').dhcphaJqGrid(jqOptions);
}

///查询
function QueryGridRecord()
{
	var daterange=$("#date-daterange").val();
	daterange=FormatDateRangePicker(daterange);
 	var startdate=daterange.split(" - ")[0];
	var enddate=daterange.split(" - ")[1];
	var phaLoc=$("#sel-phaloc").val();
	if (phaLoc==null){
		dhcphaMsgBox.alert("请选择科室!");
		return;
	}
	var deccondesc=$.trim($('#sel-deccond option:checked').text());
	var decconid=$('#sel-deccond').val();
	if ((decconid=="")||(decconid==null)){
		dhcphaMsgBox.alert("记录状态不能为空!");
		return false;
	}
	var params=startdate+tmpSplit+enddate+tmpSplit+phaLoc+tmpSplit+deccondesc+tmpSplit+gUserID;
	$("#recordworkdg").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");

}
