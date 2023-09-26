/*
模块:		草药房
子模块:		草药房-装箱采集
Creator:	hulihua
CreateDate:	2018-01-15
*/
DhcphaTempBarCode="";
var SendVoiceStr="";

$(function(){
	/* 初始化插件 start*/
	//$("#date-daterange").dhcphaDateRange();
	//给日期控件赋初始化值！
	//startdate=FormatDateT("t-3");
	//$("#date-daterange").data('daterangepicker').setStartDate(startdate);
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
	
	InitPhaWard(); 				//病区
	InitMedBatNo();				//揭药批次
	InitCollectDataList();
    /* 初始化插件 end*/
    
    //物流人员工号回车触发事件
	$('#txt-userlogistics').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			SetLogisticsInfo();	 
		}     
	});
	
	//揭药箱号回车触发查询事件
	$('#txt-barcode').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			QueryCollectData();
			DhcphaTempBarCode="";	 
		}     
	});
	
    
    //屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})
	//屏蔽所有按钮事件
	$("button").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});
		
	document.onkeydown=OnKeyDownHandler;
})

window.onload=function(){
	setTimeout("$(window).focus()",100);
}

//初始化揭药批次
function InitMedBatNo(){
	var data = [
		{ id: 2, text: '第二批' },
	 	{ id: 1, text: '第一批' }
	 ];
	var selectoption={
	  data: data,
      width:'8em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-medbatno").dhcphaSelect(selectoption);			
}

//初始化采集数据列表
function InitCollectDataList(){
	var columns=[
		{header:'TphmbiId',index:'TphmbiId',name:'TphmbiId',width:5,hidden:true},
		{header:'病区',index:'TWardLoc',name:'TWardLoc',width:120,align:'left'},
		{header:'病区简称',index:'TWardAbbr',name:'TWardAbbr',width:50,align:'left'},
		{header:'患者姓名',index:'TPatName',name:'TPatName',width:100},
		{header:'处方号',index:'TPrescNo',name:'TPrescNo',width:80},
		{header:'处方剂型',index:'TPreFormType',name:'TPreFormType',width:50},
		{header:'用药日期',index:'TBrothDate',name:'TBrothDate',width:60},
		{header:'袋数',index:'TActUnPocNum',name:'TActUnPocNum',width:50},
		{header:'膏方总罐数',index:'TOrPasJarNum',name:'TOrPasJarNum',width:60},
	    {header:'揭药人',index:'TBrothName',name:'TBrothName',width:80},
		{header:'揭药日期',index:'TActBrothDate',name:'TActBrothDate',width:100},
		{header:'当前状态',index:'TBrothStatue',name:'TBrothStatue',width:60},
		{header:'备注',index:'TRemark',name:'TRemark',width:80}
	];
	 var jqOptions={
		colModel: columns, //列
		url:LINK_CSP+'?ClassName=web.DHCINPHA.HMMedBroth.MedBrothDispQuery&MethodName=GetCollectDataList',
		multiselect: false,
		shrinkToFit:false,		
		rownumbers: true,	//是否显示行号
		height:GridCanUseHeight(2)+40,
	    pager: "#jqGridPager", 	//分页控件的id  
	    shrinkToFit:false,
		loadComplete: function(){
			var grid_records = $(this).getGridParam('records');
			if (grid_records==0){
				if(($('#txt-barcode').val())!=""){
					SendVoiceStr="该药袋在揭药室";
					SendVocie(SendVoiceStr);
				}
				$("#grid-colldatalist").clearJqGrid();
			}else{
				if(($('#txt-barcode').val())!=""){
					ConfirmDisp();
				}
			}
			$("#txt-barcode").val("");
		}
	} 
   //定义datagrid	
   $('#grid-colldatalist').dhcphaJqGrid(jqOptions);
}

///查询
function QueryCollectData()
{
	$("#grid-colldatalist").jqGrid("clearGridData");
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
	var barcode=$('#txt-barcode').val();
	//如果条码在揭药表不存在，则先要收集插入该条码的揭药信息！
	//alert("barcode:"+barcode)
	if((barcode!="")&&(barcode!=null)){
		var ret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SaveMedBrothNoData",barcode,gUserID,gLocId);
		if(ret!=0){
			if (ret=="-1"){
				SendVoiceStr="条码有误"
			}else if(ret=="-2"){
				SendVoiceStr="该处方不存在"
			}else if(ret=="-3"){
				SendVoiceStr="该处方还未发药"
			}else if(ret=="-4"){
				SendVoiceStr="该处方发药有误"
			}else if(ret=="-5"){
				SendVoiceStr="该处方还未煎药"
			}else if(ret=="-6"){
				SendVoiceStr="该处方未煎药完成"
			}else if(ret=="-7"){
				SendVoiceStr="该标签已采集"
			}else if(ret=="-8"){
				SendVoiceStr="该处方已采集"
			}else if(ret=="-9"){
				SendVoiceStr="该处方非本院区处方,请核实!"
			}else{
				SendVoiceStr="采集数据失败,"+ret
			}
			SendVocie(SendVoiceStr);
			return false;
		}
	}	
	var params=startdate+"^"+enddate+"^"+wardloc+"^"+gLocId+"^"+barcode;
	$("#grid-colldatalist").setGridParam({
		postData:{
			'params':params
		}
	}).trigger("reloadGrid");
}

///确认收集
function ConfirmDisp(){
	var MedBatNo=$('#sel-medbatno').val();
	if((MedBatNo=="")||(MedBatNo==null)){
		SendVoiceStr="请先选择揭药批次"
		SendVocie(SendVoiceStr);
		return false;
	}
	var ListDataStr="";
	var WardLoc="";
	var PatName="";
	var thisrecords=$("#grid-colldatalist").getGridParam('records');
	if (thisrecords>0){
	    var ids = $("#grid-colldatalist").getDataIDs();
	    for(var i=1;i<ids.length+1;i++){	
			var tmpselecteddata=$("#grid-colldatalist").jqGrid('getRowData',i);
			var tmpphmbiid=tmpselecteddata["TphmbiId"]; 
			if((WardLoc=="")||(PatName=="")){
				WardLoc=tmpselecteddata["TWardAbbr"];
				PatName=tmpselecteddata["TPatName"];
			}
			if(ListDataStr==""){
				ListDataStr=tmpphmbiid;
			}else{
				ListDataStr=ListDataStr+"&&"+tmpphmbiid;
			}
	    }
	}
	var ret=tkMakeServerCall("web.DHCINPHA.HMMedBroth.MedBrothDispQuery","SaveCollectData",ListDataStr,MedBatNo,gUserID);
	if(ret!=0){
		if(ret==-1){
			SendVoiceStr="请先选择揭药批次"
			SendVocie(SendVoiceStr);
		}else if(ret==-2){
			SendVoiceStr="扫描条码不存在"
			SendVocie(SendVoiceStr);
		}else{
			SendVoiceStr="收集数据失败"
			SendVocie(SendVoiceStr);
		}
	}else{
		SendVoiceStr=WardLoc;
		SendVocie(SendVoiceStr);
	}
	return false;
}

///清空
function ClearConditions(){	
	//给日期控件赋初始化值！
	//$("#date-daterange").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	//$("#date-daterange").data('daterangepicker').setEndDate(new Date());
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-3"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-3"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
	$("#sel-phaward").empty();	
	$("#txt-barcode").val("");
	$("#sel-medbatno").empty();
	InitMedBatNo();
    $('#grid-colldatalist').clearJqGrid();
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
			$("#txt-barcode").val(BarCode);
			QueryCollectData();
			DhcphaTempBarCode="";
		}else{
			DhcphaTempBarCode+=String.fromCharCode(event.keyCode);
		}
	}
}

function FindBroDisp(){
	var lnk="dhcpha/dhcpha.inpha.hmalrbrodispquery.csp";
	websys_createWindow(lnk,"已揭药查询","width=95%,height=75%")	
}