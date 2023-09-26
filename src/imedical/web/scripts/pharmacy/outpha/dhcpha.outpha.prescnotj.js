/*
 *模块:门诊药房
 *子模块:药房统计-处方统计
 *createdate:2016-12-02
 *creator:dinghongying
*/
var gNewCatId=""
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
	InitPrescType();
	InitStk();
	/*药理分类 start*/
	$("#txt-phccat").next().children("i").on('click',function(event){
		ShowPHAINPhcCat({},function(catObj){
			if (catObj){
				$("#txt-phccat").val(catObj.text||'');
				gNewCatId=catObj.id||'';
			}
		})
	});	
	/*药理分类 end*/
	InitPrescnoTJList();
	ClearConditions();
	/* 绑定按钮事件 start*/
	$("#btn-find").on("click",Query);
	$("#btn-clear").on("click",ClearConditions);
	$("#btn-print").on("click",BPrintHandler);
	$("#btn-export").on("click",function(){
		ExportAllToExcel("prescnotjdg")
	});
	/* 绑定按钮事件 end*/;	
	$("#prescnotjdg").closest(".panel-body").height(GridCanUseHeight(1));	
	
})

//初始化处方类型
function InitPrescType(){
	var selectoption ={
		url:DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL+
			"?action=GetOutPrescType&style=select2",
		allowClear:true,
		minimumResultsForSearch: Infinity
	}
	
	$("#sel-presctype").dhcphaSelect(selectoption)
	$('#sel-presctype').on('select2:select', function (event) { 
		//alert(event)
	});
}
//初始化库存分类
function InitStk(){
	var selectoption={
		url:DHCPHA_CONSTANT.URL.COMMON_PHA_URL+
			"?action=GetStkCatDs&style=select2",
		allowClear:true,
		width:'175px'
	}
	$("#sel-stk").dhcphaSelect(selectoption)
	$('#sel-stk').on('select2:select', function (event) { 
		//alert(event)
	});
}

//处方信息列表
function InitPrescnoTJList(){
	//定义columns
	var columns=[[
		{field:'TPrescType',title:'费别',width:100,align:'center'},
	    {field:'TPrescNum',title:'处方数量',width:100,align:'right'},
	    {field:'TPrescTotal',title:'处方总数',width:100,align:'right'},
	    {field:'TPrescBL',title:'处方比率(%)',width:80,align:'right'},
	    {field:'TPrescMax',title:'最高处方',width:100,hidden:true},
	    {field:'TPrescMin',title:'最低处方',width:100,hidden:true},
	    {field:'TPrescMaxPmi',title:'最高方登记号',width:100,align:'center'},
	    {field:'TPrescMinPmi',title:'最低方登记号',width:100,align:'center'},
	    {field:'TPrescMaxMoney',title:'最高方金额',width:80,align:'right'},
	    {field:'TPrescMinMoney',title:'最低方金额',width:80,align:'right'},
	    {field:'TPrescMoney',title:'合计金额',width:100,align:'right'},
	    {field:'TPrescPhNum',title:'品种数',width:80,align:'right'},
	    {field:'TCYFS',title:'草药付数',width:80,align:'right'},
	    {field:'TJYFS',title:'代煎付数',width:80,align:'right'},
	    {field:'TJYCF',title:'代煎处方数量',width:80,align:'right'}
         ]];  
         
    var dataGridOption={
		url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
		columns:columns,
		fitColumns:true
	} 
   //定义datagrid	
   $('#prescnotjdg').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query()
{	
	var startdatetime=$("#date-start").val();
	var enddatetime=$("#date-end").val();
	var startdate=startdatetime.split(" ")[0];
	var starttime=startdatetime.split(" ")[1];
	var enddate=enddatetime.split(" ")[0];
	var endtime=enddatetime.split(" ")[1];
	var ctloc=DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var prescType="";
	var stkCatId=$("#sel-stk").val();
	if (stkCatId==null){
		stkCatId="";
	}
	var presctype=$("#sel-presctype").val();
	if (presctype==null){
		dhcphaMsgBox.alert("请选择需要统计的处方类型!");
		return;
	}
	/*var chkop="";
	if($("#chk-OP").is(':checked')){
		chkop="Y";
	}
	var chkem="";
	if($("#chk-EM").is(':checked')){
		chkem="Y";
	}
	if ((chkem=="")&&(chkop=="")){
		dhcphaMsgBox.alert("请勾选需要统计的门急诊处方类型!");
		return;
	}*/
	var phNum=$("#txt-phnum").val();
	var tmpSplit=DHCPHA_CONSTANT.VAR.SPLIT;
	gNewCatId=$("#txt-phccat").val()==""?"":gNewCatId;
	var FYFlag=1
	var params=startdate+tmpSplit+enddate+tmpSplit+starttime+tmpSplit+endtime+tmpSplit+ctloc+tmpSplit+prescType+tmpSplit+phNum+tmpSplit+stkCatId+tmpSplit+gNewCatId+tmpSplit+presctype+tmpSplit+"EasyUI"+tmpSplit+FYFlag;
	$('#prescnotjdg').datagrid({
     	queryParams:{
	     	ClassName:"PHA.OP.PreStat.Query",
	     	QueryName:"GLocPresc",
			Params:params //此处params参数分隔,最后从拆分个数以及顺序同对应query
		}
	});
		
}


//清空
function ClearConditions(){
	$("#date-start").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("T")+" "+"23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("T")+" "+"23:59:59");

	$("#txt-phnum").val("");
	$("#sel-stk").empty();
	gNewCatId="";
	$("#sel-presctype").empty();
	$("#txt-phccat").val("");
	//$("#chk-OP").iCheck('uncheck');
	//$("#chk-EM").iCheck('uncheck');
	$('#prescnotjdg').clearEasyUIGrid();
}


//打印
function BPrintHandler(){	
	if($('#prescnotjdg').datagrid('getData').rows.length == 0) //获取当面界面数据行数
	{
		dhcphaMsgBox.alert("页面没有数据");
		return ;
	}
	var PrescNotjdgOption=$("#prescnotjdg").datagrid("options")
	var PrescNotjdgparams=encodeURIComponent(PrescNotjdgOption.queryParams.Params);
	var PrescNotjdgUrl=PrescNotjdgOption.url;
	var classname="PHA.OP.PreStat.Query";
	var queryname="GLocPresc";
	$.ajax({
		type: "GET",
		url: PrescNotjdgUrl+"?page=1&rows=9999&ClassName="+classname+"&QueryName="+queryname+"&Params="+PrescNotjdgparams,
		async:false,
		dataType: "json",
		success: function(prescnotjdata){
			var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
			var startdatetime=$("#date-start").val();
			var enddatetime=$("#date-end").val();
			var datetimerange=startdatetime+" 至 "+enddatetime;
			PRINTCOM.XML({
				printBy: 'lodop',
				XMLTemplate: 'PHAOPPrescStat',
				data:{
					Para: {
						titlemain:HospitalDesc+"处方统计",
						titlesecond: "药房:"+DHCPHA_CONSTANT.DEFAULT.LOC.text+"     统计范围:"+datetimerange,
						lasttitle:"打印人:"+DHCPHA_CONSTANT.SESSION.GUSER_NAME+"      打印时间:"+getPrintDateTime()
					},
					List: prescnotjdata.rows
				},
				aptListFields: ["lasttitle"],
				listBorder: {style:4, startX:1, endX:195,space:1},
			})

			
		}
	});
}
	
