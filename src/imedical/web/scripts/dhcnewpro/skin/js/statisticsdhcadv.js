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
	//���ͼ����ص�����
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
		dymObj.title="ֵ"+(i-1);
		colArray.push(dymObj);
	}
	
	var columns=[];
	columns.push(colArray);
	
	// ����datagrid
	$('#reportDataTable').datagrid({
		title:'',
		url:LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=GetTabeData", //huaxiaoying 2017-1-4 �淶����
		queryParams:{
			pid:pid
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    showHeader:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onLoadSuccess:function(data){
			globleTableData = data;
		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           
        }
	});
}

function initMehtod(){
	$("a:contains('���ɱ���')").on("click",initReportDatagrid);
	
	$("a:contains('��������')").on("click",exportExcelStatic);
	
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
///��ʼ��������
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
			   //���õ��ĸ�δ�˴�
			   reloadComboboxDataType("");
			}
		}
	};
	
	var url = uniturl+"JsonGetComboDataForStatFieldNoDate&FormNameID=''";
	new ListCombobox("statData",url,'',option).init();
	
	
	reloadComboboxDataType("");
}

//����Ǻ��ķ�����
//��Ϊ��ȡcolumn������
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
		$.messager.alert("��ʾ","�������Ͳ���Ϊ��");
		return ;
	}
	
	if(statTypeX==""){
		$.messager.alert("��ʾ","ͳ��X���������Ͳ���Ϊ��");
		return ;
	}
	
	if(statTypeY==""){
		$.messager.alert("��ʾ","ͳ��Y���������Ͳ���Ϊ��");
		return ;
	}
	
	if(statType=="") {
		$.messager.alert("��ʾ","ͳ�����Ͳ���Ϊ��");
		return ;	
	}
	
	var Params = stDate+"#"+endDate+"#"+statTypeY+"#"+statTypeX+"#"+formNameID+"#"+statType  //���column���������ѭ������

	runClassMethod("web.DHCADVStatisticsDhcadv","JsonListDataTable",{Params:Params},
		function(ret){
			initDataGrid(ret);
			initEchart(ret.split("^")[0],$("#statTypeX").combobox("getText"),$("#statTypeY").combobox("getText"));
		},
	"text",false) 
}

/*
function initDataGrid(ret){
	//��ȡcolumn����
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



///���¼���
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

///��ȡ��һ��ʱ��
function getBeforeYearDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}
///��ȡ��ǰʱ��
function getCurrentDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}



var LINK_CSP="dhcapp.broker.csp";
//��ǰ����
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

///�����¼���������excelͳ��
function exportExcelStatic(StDate,EndDate,filePath)
{ 
	
	
	var dataLen = globleTableData.rows.length;
	var exportData = globleTableData.rows;
	if(dataLen==0){
		$.messager.alert("��ʾ","û�е�������!");
		return;
	}
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add("");
	var objSheet = xlBook.ActiveSheet;
	var row=0;
	for (i=0;i<dataLen;i++){
		row=row+1;
		col=0;
		var dataObj = exportData[i];  //��������
		
		for (dataName in dataObj){
			col=col+1;
			objSheet.Cells(row,col).value=dataObj[dataName];
		}
	}
	

	xlApp.Visible=true;
	objSheet=null;
}
