///qqa

$(function(){
	///设置界面动态高度
	initPage();	
	
	initDateBox();
	
	initDatagrid();
	
	initMethod();
	
	initRunMethod();
	//showImg();
	
})

///默认需要执行的方法
function initRunMethod(){
	search();
}

function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
}


function initDatagrid(){
	
	var columns=[[
          { field: 'field1', title: '科室', width: 100, sortable: false, align: 'center' },
          { field: 'field2', title: '人数', width: 100, sortable: false, align: 'center' },
        ]]

	$HUI.datagrid('#keptBedTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMKeptPatAna&MethodName=JsonBedTable&HospID="+HospID,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		singleSelect:true,
		pageSize:60,  
		pageList:[60],
		loadMsg: '正在加载信息...',
		rownumbers : false,
		showHeader:false,
		pagination:false,
		
		onSelect:function (rowIndex, rowData){
			
		},
		onLoadSuccess:function(data){
			var imgData = data.imgData;
			showEchartBars("showImgBedInfo",imgData.DataCheck);
			showEchartBars("showImgPatInfo",imgData.DataSex);
		}
	});
		
}

function initMethod(){
	$("#search").on("click",search)
}

function initPage(){

	var heightEchart = $("#getHeightDiv").height()-30;
	
	///图标的高度
	$(".echartBody").each(function (){
		$(this).height(heightEchart);	
	})
}

function showImg(){
	var data = [{name:"周一",group:"床位",value:4},{name:"周二",group:"床位",value:6},{name:"周三",group:"床位",value:1},{name:"周四",group:"床位",value:3},{name:"周五",group:"床位",value:4},{name:"周六",group:"床位",value:4},{name:"周末",group:"床位",value:4}]
	showEchartBars("showImgBedInfo",data);		
}

function search(){
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();
	var params = HospID+"^"+stDate+"^"+endDate;
	runClassMethod("web.DHCEMKeptPatAna","GetObsAreaAnaData",
		{
			Params:params	
		},
		function(data){
			showPageImg(data);
		}	
	)
	
	//showEchartBars(data); //条形图
	//showEchartPie(data); //原型图	
}

function showPageImg(data){
	var allNumData = data.ObsPatNum;
	if(allNumData!==""){
		for (i=0;i<allNumData.split(":").length;i++){
			var NumData = allNumData.split(":")[i];
			$("span[name="+NumData.split("^")[0].escapeJquery()+"]").html(NumData.split("^")[1]);
		}
	}else{
		$(".tdDiv").find(".tdRightDivBottomSpan").html(0);	
	}
	
	var QsPatNum = data.QsPatNum;
	if(QsPatNum.length){
		showEchartPie("fjrsEcharts",QsPatNum);
	}else{
		showEchartPie("fjrsEcharts",[]);	
	}
	
	var ParseInPatNum = data.ParseInPatNum;
	if(ParseInPatNum.length){
		showEchartBars("zryksEcharts",ParseInPatNum);
	}else{
		showEchartBars("zryksEcharts",[]);	
	}
	
	var KeyDiseasePatNum = data.KeyDiseasePatNum;
	if(KeyDiseasePatNum.length){
		showEchartPie("zdbzEcharts",KeyDiseasePatNum);
	}else{
		showEchartPie("zdbzEcharts",[]);	
	}
	
	var InLocPatNum = data.InLocPatNum;
	if(InLocPatNum.length){
		showEchartBars("zkztEcharts",InLocPatNum);
	}else{
		showEchartBars("zkztEcharts",[]);
	}
	return;
	
	var GreenPatNum = data.GreenPatNum;
	showEchartPie("lstdEcharts",GreenPatNum);
	
	var PatGetSource= data.PatGetSource;
	showEchartPie("brlyEcharts",PatGetSource);

	var QsPatNum= data.QsPatNum;
	showEchartPie("qsryEcharts",QsPatNum);

	var ThreeNoPatNum= data.ThreeNoPatNum;
	showEchartPie("swryEcharts",ThreeNoPatNum);
	
	
	var PatAgeAnalysess= data.PatAgeAnalysess;
	alert(PatAgeAnalysess.length);
	showEchartBars("fznlEcharts",PatAgeAnalysess);
	
	var PatCheckLocNum= data.PatCheckLocNum;
	showEchartBars("fzksEcharts",PatCheckLocNum);
	//var PatAgeAnalysess = [{"name":"<1","value":"0"},{"name":"1-10","value":"0"},{"name":"10-20","value":"0"},{"name":"20-30","value":"0"},{"name":"30-40","value":"0"},{"name":"40-50","value":"0"},{"name":"60-70","value":"0"},{"name":"70-80","value":"0"},{"name":"80-90","value":"0"},{"name":"90-100","value":"0"},{"name":">100","value":"0"}]
	//showEchartPie("fznlEcharts",PatAgeAnalysess);
}


function showEchartBars(idName,data){
	var obj={
		grid:{
			y:40	
		}	
	}
	var option = ECharts.ChartOptionTemplates.Bars(data,"","",obj); 
	option.title ={
		
	}
	
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(idName,data){
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}


String.prototype.escapeJquery=function() {
    // 转义之后的结果
    var escapseResult = this;
    // javascript正则表达式中的特殊字符
    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
        "]", "|", "{", "}"
    ];

    // jquery中的特殊字符,不是正则表达式中的特殊字符
    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
        ":", ";", "<", ">", ",", "/"
    ];

    for (var i = 0; i < jsSpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp("\\" +
                jsSpecialChars[i], "g"), "\\" +
            jsSpecialChars[i]);
    }

    for (var i = 0; i < jquerySpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
            "g"), "\\" + jquerySpecialChars[i]);
    }

    return escapseResult;
}
