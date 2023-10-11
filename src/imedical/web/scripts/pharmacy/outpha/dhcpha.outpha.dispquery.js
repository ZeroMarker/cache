/*
 *模块:门诊药房
 *子模块:药房统计-发药查询
 *createdate:2016-12-08
 *creator:dinghongying
*/
DHCPHA_CONSTANT.VAR.INVROWID="";
var QUERYPID="";	
$(function(){
	/* 初始化插件 start*/
	var daterangeoptions={
		timePicker : true, 
		timePickerIncrement:1,
		timePicker24Hour:true,
		timePickerSeconds:true,
		singleDatePicker:true,
		locale: {
			format: DHCPHA_CONSTANT.PLUGINS.DATEFMT+" HH:mm:ss"
		}
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);
	//屏蔽所有回车事件
		
	
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	})

	InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
	InitDispStat();
	InitPyUser();
	InitFyUser();
    InitDispMainList();	
	InitDispDetailList();
	InitDispInclbList();
	ClearConditions();
	//登记号回车事件
	$('#txt-patno').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#txt-patno").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				Query();
			}	
		}
	});
	//卡号回车事件
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
			}
		}
	});
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click",Query);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-export").on('click',function(){
		ExportAllToExcel("gird-dispquery")

	});
	$("#btn-exportdetail").on('click',function(){
		if ($("#sp-title").text()==$g("发药批次列表")){
		   ExportAllToExcel("gird-dispinclbdetail")
		}else{
		   ExportAllToExcel("gird-dispquerydetail")
		}
	});
	$("#btn-readcard").on("click",BtnReadCardHandler); //读卡
	/* 绑定按钮事件 end*/;	
	$("#gird-dispquery").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);	
	$("#gird-dispquerydetail").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);
	$("#gird-dispinclbdetail").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);
	$("#a-change").on("click",ChangeDispQuery);
	$("#div-inclbdetail").hide();
	//setTimeout(function(){$("#div-inclbdetail").hide();},1000)
	InitBodyStyle();
})
function InitBodyStyle() {
	var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
	var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
	var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
	var height5 = parseFloat($("[class='panel-heading']").height());
	var height6 = parseFloat($("[class='row dhcpha-row-split']").height());
	var tableheight = $(window).height() - height1 - height3 - height4 - height5 -height6- 27;
	$("#presctimeline").height(tableheight)
	
}

//初始化发药状态
function InitDispStat(){
	var data = [
		{ id: 1, text: $g("已发药") },
		{ id: 2, text: $g("未发药") },
		{ id: 3, text: $g("未配药确认") }, 
		{ id: 4, text: $g("已配药未确认") }, 
		{ id: 0, text: $g("已配药未发药") }
	 ];
	var selectoption={
	  data: data,
      width:'9em',
      allowClear:false,
      minimumResultsForSearch: Infinity
	};
	$("#sel-dispstat").dhcphaSelect(selectoption);
	$('#sel-dispstat').on('select2:select', function (event) { 
		Query();
	})	
		
}

 //初始化药品选择
function InitThisLocInci(locrowid){
	var locincioptions={
		id:"#sel-locinci",
		locid:locrowid,
		width:'28em'
	}
	InitLocInci(locincioptions)
}
//初始化配药人
function InitPyUser(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPYUserList&style=select2&gLocId="+
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+"&gUserId="+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+"&flag=PY",
		allowClear:true,
	 	placeholder:$g("配药人")+"..."
	}
	$("#sel-pyuser").dhcphaSelect(selectoption)
	$('#sel-pyuser').on('select2:select', function (event) { 
		//alert(event)
	});
}
//初始化发药人
function InitFyUser(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPYUserList&gLocId="+
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID+"&gUserId="+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+"&style=select2"+"&flag=FY",
		allowClear:true,
		placeholder:$g("发药人")+"..."
	}
	$("#sel-fyuser").dhcphaSelect(selectoption)
	$("#sel-fyuser").on('select2:select', function (event) { 
		//alert(event)
	});
}
//初始化发药查询列表
function InitDispMainList(){
	//定义columns
	var columns=[[
		{field:'pid',title:$g("进程号"),width:100,align:'left',hidden:true},
        {field:'docLocDesc',title:$g("开单科室"),width:120},
        {field:'admId',title:"admId",width:100,align:'left',hidden:true},
        {field:'patNo',title:$g("登记号"),width:90,align:'center',
        	formatter:function(cellvalue, options, rowObject){
			    return "<a style='text-decoration:underline;'>"+cellvalue+"</a>";
			}}, 
        {field:'patName',title:$g("姓名"),width:100,align:'left'},
        {field:'admReasonDesc',title:$g("费别"),width:80,align:'center'},
        {field:'prescNo',title:$g("处方号"),width:120,algin:'center'},
        {field:'fyWinDesc',title:$g("发药窗口"),width:80},
        {field:'spAmt',title:$g("药费"),width:80,align:'right'},
        {field:'prtDate',title:$g("收费日期"),width:90,align:'center'}, 
        {field:'pyDate',title:$g("配药日期"),width:90,align:'center'}, 
        {field:'fyDate',title:$g("发药日期"),width:90,align:'center'}, 
        {field:'pyUserName',title:$g("配药人"),width:80},
        {field:'fyUserName',title:$g("发药人"),width:80},
        {field:'prtTime',title:$g("收费时间"),width:70,align:'center'}, 
        {field:'pyTime',title:$g("配药时间"),width:70,align:'center'}, 
        {field:'fyTime',title:$g("发药时间"),width:70,align:'center'}, 
        {field:'oeoriDateTime',title:$g("医嘱时间"),width:90},
        {field:'prescRemark',title:$g("处方备注"),width:80},
        {field:'diagDesc',title:$g("诊断"),width:200},
        {field:'rpAmt',title:$g("进价金额"),width:100,align:'right',hidden:true},
        {field:'encryptLevel',title:$g("病人密级"),width:80,hidden:true},
        {field:'patLevel',title:$g("病人级别"),width:80,hidden:true},
        {field:'phdId',title:$g("发药表Id"),width:80,hidden:true},
        {field:'phdOweId',title:$g("欠药指针Id"),width:80,hidden:true}
  	]];    
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispMain",
		columns:columns,
		fitColumns:false,
		onSelect:function(rowIndex,rowData){
		    QueryDetail();
		    ShowPrescTimeLine();
	    },
	    onLoadSuccess: function () {
         	if ($(this).datagrid("getRows").length>0){
	         	$(this).datagrid("selectRow", 0)
	         	$(this).datagrid('getPanel').panel('panel').focus() ;  // 直接默认可上下键
	         	QUERYPID=$(this).datagrid("getRows")[0].pid;
	         	$(this).datagrid("options").queryParams.Pid=QUERYPID ;	
         	}else{
				KillTmpGloal();	
				QueryDetail();
				ShowPrescTimeLine();        	 	
	        }
		},
		onClickCell:function(rowIndex,field,value){
			if(field=="patNo"){
				var selecteddata=$(this).datagrid("getRows")[rowIndex]
				var admId=selecteddata["admId"]
				var regNo=selecteddata["patNo"]
				var PrescNo=selecteddata["prescNo"];
				var qOpts={
					admId:admId,
					prescNo:PrescNo};
				ShowPatInfoWindow(qOpts);
			}
			
		}
	} 
   //定义datagrid	
   $('#gird-dispquery').dhcphaEasyUIGrid(dataGridOption);
}

//初始化发药明细列表
function InitDispDetailList(){
	//定义columns
	var columns=[[
		{field:'incDesc',title:$g("药品名称"),width:200}, 
		{field:'dspQty',title:$g("医嘱数量"),width:60,align:'right'},   
        {field:'qty',title:$g("实发数量"),width:60,align:'right'},
        {field:'uomDesc',title:$g("单位"),width:80},
        {field:'spAmt',title:$g("金额"),width:80,align:'right'},
        {field:'oeoriStatDesc',title:$g("状态"),width:60},
        {field:'dosage',title:$g("剂量"),width:70},
        {field:'freqDesc',title:$g("频次"),width:70},
        {field:'instrucDesc',title:$g("用法"),width:70},
        {field:'duraDesc',title:$g("疗程"),width:70},
        {field:'docName',title:$g("医师"),width:70,hidden:true},
        {field:'stkBinStr',title:$g("货位"),width:100},
        {field:'retQty',title:$g("退药"),width:70},
        {field:'oeoriRemark',title:$g("医嘱备注"),width:100},
		{field:'cInsuCode',title: $g("国家医保编码"),width:120},
		{field:'cInsuDesc',title: $g("国家医保名称"),width:120}
         ]];  
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispIncDetail",
		columns:columns,
		fitColumns:true,
		pagination:false
	} 
   //定义datagrid	
   $('#gird-dispquerydetail').dhcphaEasyUIGrid(dataGridOption);
}
//初始化批次明细列表
function InitDispInclbList(){
	//定义columns
	var columns=[[
		{field:'incDesc',title:$g("药品名称"),width:250} ,
		{field:'qty',title:$g("数量"),width:60}, 
		{field:'uomDesc',title:$g("单位"),width:60} ,
		{field:'sp',title:$g("售价"),width:60,align:"right"} ,
		{field:'spAmt',title:$g("售价金额"),width:60,align:"right"} ,
		{field:'batNo',title:$g("批号"),width:100} ,
		{field:'expDate',title:$g("效期"),width:100} ,
		{field:'retQty',title:$g("退药数量"),width:100},
		{field:'inclb',title:'inclb',width:100,hidden:true},
		{field:'cInsuCode',title: $g("国家医保码"),width:120},
		{field:'cInsuDesc',title: $g("国家医保描述"),width:120}
         ]];  
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispInclbDetail",
		columns:columns,
		fitColumns:true,
		pagination:false
	} 
   //定义datagrid	
   $('#gird-dispinclbdetail').dhcphaEasyUIGrid(dataGridOption);
}


///查询
function Query(){
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var patNo=$("#txt-patno").val();
	var patName=$("#txt-patname").val();
	var prescNo=$("#txt-prescno").val();
	var inciRowId=$("#sel-locinci").val();
	if (inciRowId==null){
		inciRowId="";
	}
	var pyUser=$("#sel-pyuser").val();
	if (pyUser==null){
		pyUser="";
	}
	var fyUser=$("#sel-fyuser").val();
	if (fyUser==null){
		fyUser="";
	}
	var manaFlag="";
	if($("#chk-mana").is(':checked')){
		manaFlag="Y";
	}
	var dispStat=$("#sel-dispstat").val();
	if (dispStat==""){
		dhcphaMsgBox.alert($g("请选择发药状态!"));
		return;
	}
	var depcode="";
	var doctor="";
	var recoverFlag="";	//
	if($("#chk-recover").is(':checked')){
		recoverFlag="Y";
	}
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;	
	KillTmpGloal();
	var params=startdate+tmpSplit+enddate+tmpSplit+ctloc+tmpSplit+patNo+tmpSplit+patName+tmpSplit+prescNo+tmpSplit+inciRowId+tmpSplit+pyUser+tmpSplit+fyUser+tmpSplit+dispStat+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+manaFlag+tmpSplit+depcode+tmpSplit+doctor+tmpSplit+recoverFlag;
	$('#gird-dispquery').datagrid({
     	queryParams:{
			InputStr:params,
			Pid:""
		}
	});

		
}

///发药明细查询
function QueryDetail(){
	var selecteddata = $('#gird-dispquery').datagrid('getSelected');
	if(selecteddata==null){
		var params="";
	}else{
		var phdRowId=selecteddata["phdId"];
		var prescNo=selecteddata["prescNo"];
		var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;
		var params=phdRowId+tmpSplit+prescNo+tmpSplit+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	}
	if ($("#sp-title").text()==$g("发药批次列表")){
		$('#gird-dispinclbdetail').datagrid({
	     	queryParams:{
				InputStr:params 
			}
		});
	}else{
		$('#gird-dispquerydetail').datagrid({
	     	queryParams:{
				InputStr:params 
			}
		});
	}

}

//清空
function ClearConditions(){
	KillTmpGloal();
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"23:59:59");
	
	$("#txt-prescno").val("");
	$("#txt-patname").val("");
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	DHCPHA_CONSTANT.VAR.INVROWID="";
	$("#sel-pyuser").empty();
	$("#sel-fyuser").empty();
	$("#sel-locinci").empty();
	$("#sel-dispstat").select2('val','1')
	$("#chk-mana").iCheck("uncheck");
	$("#chk-recover").iCheck('uncheck')
	$('#gird-dispquery').clearEasyUIGrid();
	$('#gird-dispquerydetail').clearEasyUIGrid();
	$('#gird-dispinclbdetail').clearEasyUIGrid();

}

//读卡
function BtnReadCardHandler(){
	var readcardoptions={
		CardTypeId:"sel-cardtype",
		CardNoId:"txt-cardno",
		PatNoId:"txt-patno"		
	}
	DhcphaReadCardCommon(readcardoptions,ReadCardReturn)
}
//读卡返回操作
function ReadCardReturn(){
	Query();
}

function ChangeDispQuery(){
	if ($("#sp-title").text()==$g("药品列表")){
		$("#sp-title").text($g("发药批次列表"));
		$("#div-incdetail").hide();
		$("#div-inclbdetail").show();
	}else{
		$("#sp-title").text($g("药品列表"))
		$("#div-inclbdetail").hide();
		$("#div-incdetail").show(); 
	}
	QueryDetail();
}

// 清除临时global
function KillTmpGloal(){
	tkMakeServerCall("PHA.OP.DispQuery.Global","Kill",QUERYPID);
}

window.onbeforeunload = function (){
	KillTmpGloal();
}

function ShowPrescTimeLine(){
	var selecteddata = $('#gird-dispquery').datagrid('getSelected');
	if(selecteddata==null){
		var prescNo="";
	}else{
		var phdRowId=selecteddata["phdId"];
		var prescNo=selecteddata["prescNo"];
	}
	$("#presctimeline").attr("src", ChangeCspPathToAll("pha.op.v4.presctimeline.csp") + "?prescNo=" + prescNo);

}
