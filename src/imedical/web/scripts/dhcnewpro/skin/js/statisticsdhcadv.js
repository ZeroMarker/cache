///congyue
///2017-12-14

$(function (){
	initParam();
	
	initCombobox();
	
	initDateBox();
	
	initMehtod();
	
	//initEchart();
})

function initParam(){
	//存放图像加载的数据
	globleImgData={
		dataX:"",
		dataY:"",
		data:""	
	};
	
	globleTableData={rows:[],totle:0};	
}

function initDataGrid(params){

	var pid = params.split("^")[0];
	var columNum= params.split("^")[1];
	var colArray=[];
	for(i=1;i<=columNum;i++){
		dymObj={};
		dymObj.field="field"+i;
		dymObj.align="center";
		dymObj.title="值"+(i-1);
		colArray.push(dymObj);
	}
	
	var columns=[];
	columns.push(colArray);
	
	// 定义datagrid
	$('#reportDataTable').datagrid({
		title:'',
		url:LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=GetTabeData", //huaxiaoying 2017-1-4 规范名字
		queryParams:{
			pid:pid
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // 每页显示的记录条数
		pageList:[30,60],   // 可以设置每页记录条数的列表
	    singleSelect:true,
	    showHeader:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		onLoadSuccess:function(data){
			globleTableData = data;
		},
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
           
        }
	});
}

function initMehtod(){
	$("a:contains('生成报表')").on("click",initReportDatagrid);
	
	$("a:contains('导出报表')").on("click",exportExcelStatic);
	
	$(".statImgType").on("click",setSelImgType);
}

function setSelImgType(){
	$(".statImgType").not(this).each(function(){
		$(this).removeClass("selStatImgType");	
	})
	if(!$(this).hasClass("selStatImgType")){
		$(this).toggleClass("selStatImgType");	
	}
	
	showEchart($(".selStatImgType").attr("data-type"))
	
}
//getBeforeYearDate()
///初始化下拉款
function initDateBox(){
	$("#stDate").datebox("setValue",getBeforeYearDate());
	
	$("#endDate").datebox("setValue",getCurrentDate());	
}

function initCombobox(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       reloadCombobox(option.value);
	    }
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statTypeX",url,'',option).init();
	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    }
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statTypeY",url,'',option).init();
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		panelHeight:"auto",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       reloadComboboxDataType(option.value);
	    },
	    onChange:function(newValue,oldValue){
		    if(newValue==""){
			   //设置第四个未人次
			   reloadComboboxDataType("");
			}
		}
	};
	
	var url = uniturl+"JsonGetComboDataForStatFieldNoDate&FormNameID=''";
	new ListCombobox("statData",url,'',option).init();
	
	
	reloadComboboxDataType("");
}

//这个是核心方法：
//分为获取column和数据
function initReportDatagrid(){
	var formID = $("#reportType").datebox("getValue")
	var stDate = $("#stDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	var statTypeX = $("#statTypeX").combobox("getValue");
	var statTypeY = $("#statTypeY").combobox("getValue");
	var formNameID = $("#reportType").combobox("getValue");
	var statData = $("#statData").combobox("getValue");
	var statType = $("#statType").combobox("getValue");
	
	if(formID==""){
		$.messager.alert("提示","报告类型不能为空");
		return ;
	}
	
	if(statTypeX==""){
		$.messager.alert("提示","统计X轴数据类型不能为空");
		return ;
	}
	
	if(statTypeY==""){
		$.messager.alert("提示","统计Y轴数据类型不能为空");
		return ;
	}
	
	if(statType=="") {
		$.messager.alert("提示","统计类型不能为空");
		return ;	
	}
	
	var Params = stDate+"#"+endDate+"#"+statTypeY+"#"+statTypeX+"#"+formNameID+"#"+statType  //这个column就是你二次循环内容

	runClassMethod("web.DHCADVStatisticsDhcadv","JsonListDataTable",{Params:Params},
		function(ret){
			initDataGrid(ret);
			initEchart(ret.split("^")[0],$("#statTypeX").combobox("getText"),$("#statTypeY").combobox("getText"));
		},
	"text",false) 
}

/*
function initDataGrid(ret){
	//获取column内容
	var columStr=""
	for(x in ret){
		if(columStr==""){
			columStr=ret[x].field;
		}else{
			columStr=columStr+"^"+ret[x].field;	
		}	
	}
	
	
}
*/

function initEchart(pid,DicXDesc,DicYDesc){
	alert(pid+":"+DicXDesc+":"+DicYDesc);
	runClassMethod("web.DHCADVStatisticsDhcadv","GetTabeImgDataAll",{pid:pid,DicXDesc:DicXDesc,DicYDesc:DicYDesc},
		function(ret){
			globleImgData.dataX=ret.DataX;
			globleImgData.dataY=ret.DataY;
			globleImgData.data=ret.Data;
			showEchart($(".selStatImgType").attr("data-type"));
		},
	"json",false) 	
}

function showEchart(param){

	var data="";
	if(param==="X"){
		data = globleImgData.dataX;
	}
	
	if(param==="Y"){
		data = globleImgData.dataY;
	}
	
	if(param==="XY"){
		data = globleImgData.data;
	}

	showEchartPie(data);
	showEchartBars(data);
}

	
function showEchartBars(data){
	var option = ECharts.ChartOptionTemplates.Bars(data); 
	option.title ={
		
	}
	var container = document.getElementById('typechartsbar');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(data){
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById('typechartspie');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}



///重新加载
function reloadCombobox(value){
	$("#statTypeX").combobox("setValue","");
	$("#statTypeY").combobox("setValue","");
	$("#statData").combobox("setValue","");
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataForStatField&FormNameID="+value;
	$("#statTypeX").combobox("reload",uniturl);	
	$("#statTypeY").combobox("reload",uniturl);	
	
	
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataForStatFieldNoDate&FormNameID="+value;
	$("#statData").combobox("reload",uniturl);	
}

function reloadComboboxDataType(value){
	$("#statType").combobox("setValue","");
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataType&FormDicID="+value;
	$("#statType").combobox("reload",uniturl);	
		
}

///获取上一年时间
function getBeforeYearDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}
///获取当前时间
function getCurrentDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}



var LINK_CSP="dhcapp.broker.csp";
//当前索引
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
}


function serverCallJson(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"json",false)
	return ret.responseText
}

///不良事件朝阳导出excel统计
function exportExcelStatic(StDate,EndDate,filePath)
{ 
	
	
	var dataLen = globleTableData.rows.length;
	var exportData = globleTableData.rows;
	if(dataLen==0){
		$.messager.alert("提示","没有导出数据!");
		return;
	}
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add("");
	var objSheet = xlBook.ActiveSheet;
	var row=0;
	for (i=0;i<dataLen;i++){
		row=row+1;
		col=0;
		var dataObj = exportData[i];  //导出数据
		
		for (dataName in dataObj){
			col=col+1;
			objSheet.Cells(row,col).value=dataObj[dataName];
		}
	}
	

	xlApp.Visible=true;
	objSheet=null;
}
