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
		if ($("#sp-title").text()=="发药批次列表"){
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
	
})


//初始化发药状态
function InitDispStat(){
	var data = [
		{ id: 1, text: '已发药' },
		{ id: 2, text: '未发药' },
		{ id: 3, text: '未配药确认' }, 
		{ id: 4, text: '已配药未确认' }, 
		{ id: 0, text: '已配药未发药' }
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
	 	placeholder:'配药人...'
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
		placeholder:'发药人...'
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
		{field:'pid',title:'进程号',width:100,align:'left',hidden:true},
        {field:'docLocDesc',title:'开单科室',width:120},
        {field:'patNo',title:'登记号',width:90,align:'center'}, 
        {field:'patName',title:'姓名',width:100,align:'left'},
        {field:'admReasonDesc',title:'费别',width:80,align:'center'},
        {field:'prescNo',title:'处方号',width:120,algin:'center'},
        {field:'spAmt',title:'药费',width:80,align:'right'},
        {field:'prtDate',title:'收费日期',width:90,align:'center'}, 
        {field:'pyDate',title:'配药日期',width:90,align:'center'}, 
        {field:'fyDate',title:'发药日期',width:90,align:'center'}, 
        {field:'pyUserName',title:'配药人',width:80},
        {field:'fyUserName',title:'发药人',width:80},
        {field:'prtTime',title:'收费时间',width:70,align:'center'}, 
        {field:'pyTime',title:'配药时间',width:70,align:'center'}, 
        {field:'fyTime',title:'发药时间',width:70,align:'center'}, 
        {field:'oeoriDateTime',title:'医嘱时间',width:90},
        {field:'prescRemark',title:'处方备注',width:80},
        {field:'diagDesc',title:'诊断',width:200},
        {field:'rpAmt',title:'进价金额',width:100,align:'right',hidden:true},
        {field:'encryptLevel',title:'病人密级',width:80,hidden:true},
        {field:'patLevel',title:'病人级别',width:80,hidden:true},
        {field:'phdId',title:'发药表Id',width:80,hidden:true},
        {field:'phdOweId',title:'欠药指针Id',width:80,hidden:true}
  	]];    
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.DispQuery.Display&MethodName=EuiGetDispMain",
		columns:columns,
		fitColumns:false,
		onSelect:function(rowIndex,rowData){
		    QueryDetail();
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
		{field:'incDesc',title:'药品名称',width:200}, 
		{field:'dspQty',title:'医嘱数量',width:60,align:'right'},   
        {field:'qty',title:'数量',width:60,align:'right'},
        {field:'uomDesc',title:'单位',width:80},
        {field:'spAmt',title:'金额',width:80,align:'right'},
        {field:'oeoriStatDesc',title:'状态',width:60},
        {field:'dosage',title:'剂量',width:70},
        {field:'freqDesc',title:'频次',width:70},
        {field:'instrucDesc',title:'用法',width:70},
        {field:'duraDesc',title:'疗程',width:70},
        {field:'docName',title:'医师',width:70,hidden:true},
        {field:'stkBinStr',title:'货位',width:100},
        {field:'retQty',title:'退药',width:70},
        {field:'oeoriRemark',title:'医嘱备注',width:100}
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
		{field:'incDesc',title:'药品名称',width:250} ,
		{field:'qty',title:'数量',width:60}, 
		{field:'uomDesc',title:'单位',width:60} ,
		{field:'sp',title:'售价',width:60,align:"right"} ,
		{field:'spAmt',title:'售价金额',width:60,align:"right"} ,
		{field:'batNo',title:'批号',width:100} ,
		{field:'expDate',title:'效期',width:100} ,
		{field:'retQty',title:'退药数量',width:100},
		{field:'inclb',title:'inclb',width:100,hidden:true}
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
		dhcphaMsgBox.alert("请选择发药状态!");
		return;
	}
	var depcode="";
	var doctor="";
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;	
	KillTmpGloal();
	var params=startdate+tmpSplit+enddate+tmpSplit+ctloc+tmpSplit+patNo+tmpSplit+patName+tmpSplit+prescNo+tmpSplit+inciRowId+tmpSplit+pyUser+tmpSplit+fyUser+tmpSplit+dispStat+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+manaFlag+tmpSplit+depcode+tmpSplit+doctor;
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
	if ($("#sp-title").text()=="发药批次列表"){
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
	if ($("#sp-title").text()=="药品列表"){
		$("#sp-title").text("发药批次列表");
		$("#div-incdetail").hide();
		$("#div-inclbdetail").show();
	}else{
		$("#sp-title").text("药品列表")
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