///qqa

$(function(){
	///设置界面动态高度
	initPage();	
	
	initDateBox();
	
	initDatagrid();
	
	initMethod();
	
	initRunMethod();
	
	initCss();
	//showImg();
	
})

function initCss(){
	if(HISUIStyleCode==="lite"){
		$(".heading").css("background","none")
	}
}

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
		bodyCls:'panel-header-gray', //hxy 2022-11-18
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		singleSelect:true,
		pageSize:60,  
		pageList:[60],
		loadMsg: $g('正在加载信息...'),
		rownumbers : false,
		showHeader:false,
		pagination:false,
		
		onSelect:function (rowIndex, rowData){
			
		},
		onLoadSuccess:function(data){
			var imgData = data.imgData;
			showEchartBars("showImgBedInfo",imgData.DataCheck,$g("预检分级"));
			showEchartBars("showImgPatInfo",imgData.DataSex,$g("性别"));
		}
	});
		
}

function initMethod(){
	$("#search").on("click",search)
}

function initPage(){

	var heightEchart = $("#getHeightDiv").height()-20;
	
	///图标的高度
	$(".echartBody").each(function (){
		$(this).height(heightEchart);	
	})
	///图标的高度
	$(".echartBodyPie").each(function (){
		$(this).height(heightEchart-40);	
	})
}

function showImg(){
	var data = [{name:$g("周一"),group:$g("床位"),value:4},{name:$g("周二"),group:$g("床位"),value:6},{name:$g("周三"),group:$g("床位"),value:1},{name:$g("周四"),group:$g("床位"),value:3},{name:$g("周五"),group:$g("床位"),value:4},{name:$g("周六"),group:$g("床位"),value:4},{name:$g("周末"),group:$g("床位"),value:4}]
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
			$("span[name='"+NumData.split("^")[0].escapeJquery()+"']").html(NumData.split("^")[1]);
		}
	}else{
		$(".tdDiv").find(".tdRightDivBottomSpan").html(0);	
	}
	
	var QsPatNum = data.QsPatNum;
	if(QsPatNum.length){
		showEchartPie("fjrsEcharts",QsPatNum,$g("分级人数统计"));
	}else{
		showEchartPie("fjrsEcharts",['',''],$g("分级人数统计"));	
	}
	
	var ParseInPatNum = data.ParseInPatNum;
	if(ParseInPatNum.length){
		showEchartBars("zryksEcharts",ParseInPatNum,$g("转入院科室统计"));
	}else{
		showEchartBars("zryksEcharts",[],$g("转入院科室统计"));	
	}
	
	var KeyDiseasePatNum = data.KeyDiseasePatNum;
	if(KeyDiseasePatNum.length){
		showEchartPie("zdbzEcharts",KeyDiseasePatNum,$g("重点病种分布"));
	}else{
		showEchartPie("zdbzEcharts",['',''],$g("重点病种分布"));	
	}
	
	var InLocPatNum = data.InLocPatNum;
	if(InLocPatNum.length){
		showEchartBars("zkztEcharts",InLocPatNum,$g("在科状态统计"));
	}else{
		showEchartBars("zkztEcharts",[],$g("在科状态统计"));
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
	//alert(PatAgeAnalysess.length);
	showEchartBars("fznlEcharts",PatAgeAnalysess);
	
	var PatCheckLocNum= data.PatCheckLocNum;
	showEchartBars("fzksEcharts",PatCheckLocNum);
	//var PatAgeAnalysess = [{"name":"<1","value":"0"},{"name":"1-10","value":"0"},{"name":"10-20","value":"0"},{"name":"20-30","value":"0"},{"name":"30-40","value":"0"},{"name":"40-50","value":"0"},{"name":"60-70","value":"0"},{"name":"70-80","value":"0"},{"name":"80-90","value":"0"},{"name":"90-100","value":"0"},{"name":">100","value":"0"}]
	//showEchartPie("fznlEcharts",PatAgeAnalysess);
}


function showEchartBars(idName,data,saveName){
	var obj={
		grid:{
			y:40	
		},
		toolbox: {
	   			showTitle:false,
                show: true, //是否显示工具栏
                feature: {
                	mark : { show: true }, //画线
                    restore : { show: true }, //复原
                    saveAsImage : { show: true,name:saveName}, //是否保存图片
                    magicType : { show: true, type: ['line', 'bar']} //支持柱形图和折线图的切换 
                }
        }
	}
	var option = ECharts.ChartOptionTemplates.Bars(data,"","",obj); 
	option.title ={
		
	}
	
	var container = document.getElementById(idName);
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(idName,data,saveName){
	if(idName=="fjrsEcharts"){
		var obj={
		color: ['#BCBCBC','#f00', '#ff793e', '#f9bf3b','#13987e'],
		toolbox: {
	   			showTitle:false,
                show: true, //是否显示工具栏
                feature: {
                	mark : { show: true }, //画线
                    restore : { show: true }, //复原
                    saveAsImage : { show: true,name:saveName}, //是否保存图片
                }
        }
		}
	}else{
		var obj={
			toolbox: {
		   			showTitle:false,
	                show: true, //是否显示工具栏
	                feature: {
	                	mark : { show: true }, //画线
	                    restore : { show: true }, //复原
	                    saveAsImage : { show: true,name:saveName}, //是否保存图片
	                }
	        }
		}
	}
	var option = ECharts.ChartOptionTemplates.Pie(data,"",obj); 
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
