///qqa

$(function(){
	///设置界面动态高度
	initPage();	
	
	initDateBox();
	
	initMethod();
	
	search();
})


function initDateBox(){
	$HUI.datebox("#stDate").setValue(formatDate(0));
	$HUI.datebox("#endDate").setValue(formatDate(0));
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

function search(){
	var stDate = $HUI.datebox("#stDate").getValue();
	var endDate = $HUI.datebox("#endDate").getValue();
	var params = stDate+"^"+endDate+"^"+HospID;
	runClassMethod("web.DHCEMAnalysessCheckLev","GetAnalysessData",
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
	var allNumData = data.GetCheckPatNum;
	$("#AllNumber").html(allNumData.AllCheckNum);
	$("#redNumber").html(allNumData.RedCheckNum);
	$("#yellowNumber").html(allNumData.YellowCheckNum);
	$("#greenNumber").html(allNumData.GreenCheckNum);
	$("#orangeNumber").html(allNumData.OrangeCheckNum); //hxy 2020-02-21
	
	var GreenPatNum = data.GreenPatNum;
	showEchartPie("lstdEcharts",GreenPatNum);
	
	var PatGetSource= data.PatGetSource;
	showEchartPie("brlyEcharts",PatGetSource);
	showEchartBars("brlyrsEcharts",PatGetSource);

	//var QsPatNum= data.QsPatNum;
	//showEchartPie("qsryEcharts",QsPatNum);

	var ThreeNoPatNum= data.ThreeNoPatNum;
	showEchartPie("swryEcharts",ThreeNoPatNum);
	
	
	var PatAgeAnalysess= data.PatAgeAnalysess;
	//alert(PatAgeAnalysess.length);
	showEchartBars("fznlEcharts",PatAgeAnalysess);
	
	var PatCheckLocNum= data.PatCheckLocNum;
	showEchartBars("fzksEcharts",PatCheckLocNum);
	//var PatAgeAnalysess = [{"name":"<1","value":"0"},{"name":"1-10","value":"0"},{"name":"10-20","value":"0"},{"name":"20-30","value":"0"},{"name":"30-40","value":"0"},{"name":"40-50","value":"0"},{"name":"60-70","value":"0"},{"name":"70-80","value":"0"},{"name":"80-90","value":"0"},{"name":"90-100","value":"0"},{"name":">100","value":"0"}]
	//showEchartPie("fznlEcharts",PatAgeAnalysess);
}


function showEchartBars(idName,data){
	var option = ECharts.ChartOptionTemplates.Bars(data); 
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