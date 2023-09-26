/*
 *模块:门诊药房
 *子模块:日常业务-处方集中打印
 *createdate:2016-11-29
 *creator:dinghongying
*/
var QUERYPID="";
var GridSelect="";
$(function(){
	CheckPermission();
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
	InitLoc();
	InitPrescType();
	InitPrescInfoList();
	InitPrescDetailList();
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
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click",Query);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-print").on("click",BPrintHandler);
	$("#btn-export").on("click",function(){
		ExportAllToExcel("locprescdg")
	});
	/* 绑定按钮事件 end*/;	
	$("#locprescdg").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);	
	$("#prescdetaildg").closest(".panel-body").height(GridCanUseHeight(1)*0.5-20);	
	
})

//初始化科室
function InitLoc(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetCtLocDs&style=select2&custtype=DocLoc",
		allowClear:true
	}
	$("#sel-loc").dhcphaSelect(selectoption)
	$('#sel-loc').on('select2:select', function (event) { 
		//alert(event)
	});
}

//初始化处方类型
function InitPrescType(){
	var selectoption ={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetPrescType&style=select2",
		allowClear:true,
		minimumResultsForSearch: Infinity
	}
	
	$("#sel-presctype").dhcphaSelect(selectoption)
	$('#sel-presctype').on('select2:select', function (event) { 
		//alert(event)
	});
}

//处方信息列表
function InitPrescInfoList(){
	//定义columns
	var columns=[[
		{field:'gridSelect', title:"",checkbox: true },
        {field:'prescStat',title:'状态-todo',width:100,align:'center',hidden:true},
        {field:'docLocDesc',title:'开单科室',width:140,align:'left'},
        {field:'patNo',title:'登记号',width:90,align:'center'}, 
		{field:'patName',title:'姓名',width:100,align:'left'},   
		{field:'spAmt',title:'药费',width:75,align:'right'},
        {field:'prescNo',title:'处方号',width:125,align:'center'},
		{field:'prescType',title:'处方类别',width:75,align:'center'},
		{field:'diagDesc',title:'诊断',width:200,align:'left'},
		{field:'prtDate',title:'收费日期',width:90,align:'center'},
		{field:'prtTime',title:'收费时间',width:90,align:'center'},
		{field:'fyDate',title:'发药日期',width:90,align:'center'},
		{field:'fyTime',title:'发药时间',width:90,align:'center'},
		{field:'pyUserName',title:'配药人',width:90,align:'left'},
		{field:'fyUserName',title:'发药人',width:90,align:'left'},
		{field:'winDesc',title:'发药窗口',width:90,align:'left'},
		{field:'encryptLevel',title:'病人密级',width:100,align:'left'},
        {field:'patLevel',title:'病人级别',width:100,align:'left'}
         ]]; 
         
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.PreBatPrt.Display&MethodName=EuiGetPrescMain",
		columns:columns,
	  	singleSelect:false,
	    checkOnSelect: false,
	  	selectOnCheck: false,
		onSelect:function(rowIndex,rowData){
			if (GridSelect==""){
				GridSelect=1
				$(this).datagrid("unselectAll");
				$(this).datagrid("selectRow",rowIndex);
				GridSelect=""
			}
			QueryDetail();
		},
		onUnselect:function(rowIndex,rowData){
			$('#prescdetaildg').clearEasyUIGrid();
		},
		onLoadSuccess: function () {
         	if ($(this).datagrid("getRows").length>0){
	         	$(this).datagrid("selectRow", 0);
	         	QUERYPID=$(this).datagrid("getRows")[0].pid;
	         	$(this).datagrid("options").queryParams.Pid=QUERYPID ;	
         	}else{
				KillTmpGlobal();	
				$('#prescdetaildg').clearEasyUIGrid();     	 	
	        }
		}
	} 
   //定义datagrid	
   $('#locprescdg').dhcphaEasyUIGrid(dataGridOption);
    
}

//处方明细列表
function InitPrescDetailList(){
	//定义columns
	var columns=[[
        {field:'oeoriStatDesc',title:'状态',width:60,align:'center',
	        styler: function(value, row, index) {
	            var colorStyle = "";
	            if ((value.indexOf("停止") >= 0)||(value.indexOf("作废") >= 0)) {
	                colorStyle = "background:#F4868E;color:white;"
	            }
	            return colorStyle;
	        }
        }, 
	    {field:'arcItmDesc',title:'药品',width:200,align:'left'},  
        {field:'oeoriQty',title:'医嘱数量',width:65,align:'right'},     
        {field:'uomDesc',title:'单位',width:80,align:'center'},    
        {field:'sp',title:'价格',width:80,align:'right'},
        {field:'spAmt',title:'金额',width:80,align:'right'},
        {field:'dosage',title:'剂量',width:80,align:'left'},    
        {field:'freqDesc',title:'频次',width:80,align:'left'},
        {field:'instrucDesc',title:'用法',width:80,align:'left'},    
        {field:'duraDesc',title:'疗程',width:80,align:'left'},
		{field:'dispQty',title:'已发药',width:50,align:'left'}, 
        {field:'retQty',title:'已退药',width:50,align:'left'},    
        {field:'oeoriRemark',title:'医嘱备注',width:120,align:'left'}
    ]];  
    var dataGridOption={
		url:"/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=PHA.OP.PreBatPrt.Display&MethodName=EuiGetPrescItm",
		columns:columns,
		fitColumns:true,
		pagination:false
	}
   //定义datagrid
   $('#prescdetaildg').dhcphaEasyUIGrid(dataGridOption);	
   
}

///处方查询
function Query(){
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var admlocdata=$("#sel-loc").select2("data");
	var admloc=(admlocdata=="")?"":admlocdata[0].id;
	var presctypedata=$("#sel-presctype").select2("data");
	var presctype=(presctypedata=="")?"":presctypedata[0].text;
	var pmino=$("#txt-patno").val();;
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;	
	KillTmpGlobal();
	var params=startdate+tmpSplit+enddate+tmpSplit+ctloc+tmpSplit+pmino+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+admloc+tmpSplit+presctype;
	$('#locprescdg').datagrid({
     	queryParams:{
			InputStr:params,
			Pid:""
		}
	});
		
}

//查询明细
function QueryDetail(){
	var selectdata=$("#locprescdg").datagrid("getSelected")
	if (selectdata==null){
		dhcphaMsgBox.alert("选中数据异常!");
		return;
	}
	var prescno=selectdata.prescNo;	
	$('#prescdetaildg').datagrid({
     	queryParams:{
	     	InputStr:prescno
		}
	});
}

//清空
function ClearConditions(){
	KillTmpGlobal();
	$("#sel-loc").empty();
	$("#sel-presctype").empty();
	$("#txt-patno").val("");
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"23:59:59");
	$('#locprescdg').clearEasyUIGrid();
	$('#prescdetaildg').clearEasyUIGrid();
}


//打印
function BPrintHandler(){
    var gridChecked = $('#locprescdg').datagrid('getChecked');
    if (gridChecked == "") {
        dhcphaMsgBox.alert("请勾选需要打印的数据!","info");
        return;
    }
    var cLen = gridChecked.length
    for (var cI = 0; cI < cLen; cI++) {
        var prescNo = gridChecked[cI].prescNo;
	    OUTPHA_PRINTCOM.Presc(prescNo,"正方","");  
    }
}
function CheckPermission(){
	$.ajax({
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission'+
			'&groupId='+DHCPHA_CONSTANT.SESSION.GROUP_ROWID+
			'&gUserId='+DHCPHA_CONSTANT.SESSION.GUSER_ROWID+
			'&gLocId='+DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type:'post',   
		success:function(data){ 
			var retjson=JSON.parse(data);
			var retdata= retjson[0];
			DHCPHA_CONSTANT.DEFAULT.CYFLAG=retdata.phcy;
		},  
		error:function(){}  
	})
}
// 清除临时global
function KillTmpGlobal(){
	tkMakeServerCall("PHA.OP.PreBatPrt.Global","Kill",QUERYPID);
}

window.onbeforeunload = function (){
	KillTmpGlobal();
}