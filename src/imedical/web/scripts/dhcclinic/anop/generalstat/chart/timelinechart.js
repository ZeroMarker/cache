var dateformat = "";
$(function(){
	$.ajax({
		type:"POST",
		url:"./dhcclinic.jquery.method.csp",
		data:{
			ClassName:"web.DHCClinicCom",
			MethodName:"GetDateFormat",
			ArgCnt:0
		},
		dataType:"text",
		async:false,
		success:function(data){
			dateformat = data.trim().toLowerCase();
			dateformat = dateformat == "y-m-d"?"yy-mm-dd":dateformat;
			dateformat = dateformat == "j/n/y"?"dd/mm/yy":dateformat;
		}
	});
	$("<div id='tooltip'></div>").css({
		position: "absolute",
		display: "none",
		border: "1px solid rgb(255,255,255)",
		"border-radius": "5px",
		padding: "5px",
		color:"rgb(255,255,255)",
		font:"12px arial",
		"background-color": "rgb(0,0,0)",
		opacity: 0.80
	}).appendTo("body");
	$("#startdatepicker").datepicker({
		dateFormat: dateformat,
		gotoCurrent: true,
		yearRange: 'c-10:c',
		prevText: '上个月',
		nextText: '下个月',
		showMonthAfterYear: true,
		changeMonth: true,
		changeYear: true,
		dayNamesMin: ['日', '一', '二', '三', '四', '五', '六'],
		currentText: "today",
		monthNamesShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
	});
	$("#enddatepicker").datepicker({
		dateFormat: dateformat,
		gotoCurrent: true,
		yearRange: 'c-10:c',
		prevText: '上个月',
		nextText: '下个月',
		showMonthAfterYear: true,
		changeMonth: true,
		changeYear: true,
		dayNamesMin: ['日', '一', '二', '三', '四', '五', '六'],
		currentText: "today",
		monthNamesShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
	});
	$("#btnShow").button();
	$("#btnAddToList").button();
	$("#btnClearList").button();
	$("#datelist").tooltip();
	$("#btnShow").attr("disabled",true);
	$(document).delegate('span.date-para-item', 'dblclick', function() {
		deleteListItem(this); 
	});
	$(document).delegate('input.require', 'change', function() {
		if($(this).val()!="" && $(this).val()!="undefined") $(this).removeClass("require");
	});
	$(document).delegate('#displayPara', 'change', function() {
		var displayParaStr=$("#displayPara").val();
		var requestData={
			ClassName:"web.DHCANOPStat",
			QueryName:"GetTimeLineChartPara",
			Arg1:anciId,
			Arg2:displayParaStr,
			ArgCnt:2
		};
		refreshChioces("choices",requestData);
	});
	$(document).delegate('#choices input', 'click', function() {
		if(!$("#chkAllChoices").prop("checked"))
		{
			$("#choices input").prop("checked",false);
			$(this).prop("checked",true);
		}
		plotAccordingToChoices();
	});
	$(document).delegate('#columnchoices input', 'click', function() {
		if(!$("#chkAllColChoices").prop("checked"))
		{
			$("#columnchoices input").prop("checked",false);
			$(this).prop("checked",true);
		}
		plotAccordingToChoices();
	});
	$(document).delegate('input.accordingcheck', 'click', function() {
		var check = $(this).prop("checked");
		$("input.accordingcheck").prop("checked",false);
		$(this).prop("checked",check);
	});
	$("#btnAddToList").click(function(){
		var startDateStr=$("#startdatepicker").val();
		if(startDateStr=="")
		{
			alert("请输入开始日期!");
			$("#startdatepicker").focus();
			$("#startdatepicker").addClass("require");
			return;
		}
		var endDateStr=$("#enddatepicker").val();
		if(endDateStr=="")
		{
			alert("请输入结束日期!");
			$("#enddatepicker").focus();
			$("#enddatepicker").addClass("require");
			return;
		}
		$("#btnShow").attr("disabled",false);
		addDateStrToList(startDateStr,endDateStr);
		$("#startdatepicker").val("");
		$("#enddatepicker").val("");
	});
	$("#btnShow").click(function(){
		var displayParaStr=$("#displayPara").val();
		var statType=$("#statType").val();
		var dateListStr=getDateListStr();
		var requestData={
			ClassName:"web.DHCANOPStat",
			QueryName:"GetTimeLineChartData",
			Arg1:anciId,
			Arg2:displayParaStr,
			Arg3:dateListStr,
			Arg4:statType,
			ArgCnt:4
		};
		refreshData(requestData);
	});
	$("#btnClearList").click(function(){
		originDateList = new Array();
		$("#datelist").empty();
	});
	//$('#btnShow').trigger("click");
	refreshChioces("columnchoices",{
			ClassName:"web.DHCANOPStat",
			QueryName:"GetChartSearchLevel",
			Arg1:anciId,
			ArgCnt:1
	});
	var displayParaStr = "总计";
	refreshChioces("choices",{
			ClassName:"web.DHCANOPStat",
			QueryName:"GetTimeLineChartPara",
			Arg1:anciId,
			Arg2:displayParaStr,
			ArgCnt:2
	});
	refreshSelectOption("statType",{
		ClassName:"web.DHCANOPStat",
		QueryName:"GetSummaryType",
		Arg1:anciId,
		ArgCnt:1
	});
	refreshSelectOption("displayPara",{
		ClassName:"web.DHCANOPStat",
		QueryName:"GetTimeLineChartPara",
		Arg1:anciId,
		ArgCnt:1
	});
	$('#chkAllChoices').click(function(){
		SetAllChoices("chkAllChoices");
		plotAccordingToChoices();
	});
	$('#chkAllColChoices').click(function(){
		SetAllChoices("chkAllColChoices");
		plotAccordingToChoices();
	});
	$('#chkShowBar').click(function(){
		plotAccordingToChoices();
	});
	$('#chkShowDataGrid').click(function(){
		if($(this).prop("checked"))
		{
			$("#plotdatagrid").css("display","block");
		}
		else
		{
			$("#plotdatagrid").css("display","none");
		}
	});
});
var originDataSet = new Object();
var originChoices = new Object();
var originTicks = new Object();
var originTickArr = new Array();
var originDateList = new Array();
function refreshData(requestData)
{
	$('#btnShow').attr('disabled',true); 
    $.ajax({
        type: "POST",
        url: "./dhcclinic.query.csp",
        data: requestData,
        dataType: "text",
        success: function (data) {
			data=eval('('+data+')');
			$.ajax({
					type: "POST",
					url: "./dhcclinic.query.csp",
					data: {
						ClassName:"web.DHCANOPStat",
						QueryName:"GetChartTicks",
						Arg1:anciId,
						ArgCnt:1
					},
					dataType: "text",
					success: function (nextdata) {
						nextdata=eval('('+nextdata+')');
						initPlotData(data.record,nextdata.record);
					},
					error: function (msg) {
						alert("加载失败,请稍后重试!" + "\rCode:" + msg.status + " " + msg.statusText + "\r" + msg.responseText + "\r");
					},
					complete: function (data) {
						$('#btnShow').attr('disabled',false);
					}
				});
        },
        error: function (msg) {
            alert("加载失败,请稍后重试!" + "\rCode:" + msg.status + " " + msg.statusText + "\r" + msg.responseText + "\r");
        },
        complete: function (data) {
			$('#btnShow').attr('disabled',false); 
        }
    });
}
function refreshSelectOption(select_id,requestData)
{
	$.ajax({
        type: "POST",
        url: "./dhcclinic.query.csp",
        data: requestData,
        dataType: "text",
        success: function (data) {
			data=eval('('+data+')');
            $.each(data.record,function(i,r){
				$("#"+select_id).append("<option value='"+r.code+"'>"+r.desc+"</option>");
			});
        },
        error: function (msg) {
            alert("加载失败,请稍后重试!" + "\rCode:" + msg.status + " " + msg.statusText + "\r" + msg.responseText + "\r");
        },
        complete: function (data) {
        }
    });
}
function refreshChioces(choices_id,requestData)
{
	$.ajax({
        type: "POST",
        url: "./dhcclinic.query.csp",
        data: requestData,
        dataType: "text",
        success: function (data) {
			data=eval('('+data+')');
            originChoices[choices_id]=data.record;
			initPlotChoices(choices_id);
        },
        error: function (msg) {
            alert("加载失败,请稍后重试!" + "\rCode:" + msg.status + " " + msg.statusText + "\r" + msg.responseText + "\r");
        },
        complete: function (data) {
        }
    });
}
function addDateStrToList(startdate,enddate)
{
	var ifaccordingyear=$("#accordingyear").prop("checked");
	var ifaccordingmouth=$("#accordingmouth").prop("checked");
	var ifaccordingday=$("#accordingday").prop("checked");
	var date = new Date();
	var separator = '-';
	if(dateformat.indexOf('-')>=0)
	{
		separator = '-';
	}
	else if(dateformat.indexOf('/')>=0)
	{
		separator = '/';
	}
	
	var dateformatArr = dateformat.split(separator);
	var startdateArr = startdate.split(separator);
	var startdateArr2 = startdate.split(separator);
	var enddateArr = enddate.split(separator);
	var enddateArr2 = enddate.split(separator);
	
	$.each(dateformatArr,function(ind,e){
		if(e.indexOf("y")>=0) {
			startdateArr[0] = startdateArr2[ind];enddateArr[0] = enddateArr2[ind];
		}
		else if(e.indexOf("m")>=0) {
			startdateArr[1] = startdateArr2[ind];enddateArr[1] = enddateArr2[ind];
		}
		else if(e.indexOf("d")>=0) {
			startdateArr[2] = startdateArr2[ind];enddateArr[2] = enddateArr2[ind];
		}
	});
	
	if(ifaccordingyear)
	{
		for(var y=Number(startdateArr[0]);y<=Number(enddateArr[0]);y++)
		{
			if(!addToList(y+"-01-01",y+"-12-31")) return;
		}
	}
	else if(ifaccordingmouth)
	{
		for(var y=Number(startdateArr[0]);y<=Number(enddateArr[0]);y++)
		{
			var startMouth = 1;var endMouth = 12;
			if(y==Number(startdateArr[0])) startMouth = Number(startdateArr[1]);
			if(y==Number(enddateArr[0])) endMouth = Number(enddateArr[1]);
			for(var m=startMouth;m<=endMouth;m++)
			{
				date.setFullYear(y,m,0);
				var nextyear=date.getFullYear();
				var nextmonth=date.getMonth();
				nextmonth = nextmonth+1;
				nextmonth = nextmonth<10?"0"+nextmonth:""+nextmonth;
				var nextday=date.getDate();
				nextday = nextday<10?"0"+nextday:""+nextday;
				if(!addToList(y+"-"+(m<10?"0"+m:""+m)+"-01",nextyear+"-"+nextmonth+"-"+nextday)) return;
			}
		}
	}
	else if(ifaccordingday)
	{
		var endDate = new Date();
		endDate.setFullYear(Number(enddateArr[0]),Number(enddateArr[1])-1,Number(enddateArr[2]));
		date.setFullYear(Number(startdateArr[0]),Number(startdateArr[1])-1,Number(startdateArr[2]));
		while(date<=endDate)
		{
			var nextyear=date.getFullYear();
			var nextmonth=date.getMonth();
			nextmonth = nextmonth+1;
			nextmonth = nextmonth<10?"0"+nextmonth:""+nextmonth;
			var nextday=date.getDate();
			nextday = nextday<10?"0"+nextday:""+nextday;
			if(!addToList(nextyear+"-"+nextmonth+"-"+nextday,nextyear+"-"+nextmonth+"-"+nextday)) return;
			date.setDate(date.getDate() + 1);
		}
	}
	else
	{
		addToList(startdate,enddate);
	}
}
function addToList(startdate,enddate)
{
	var itemStr = startdate+"~"+enddate;
	if(originDateList.length>=50)
	{
		alert("时间序列数量已达到上限50,不能继续增加!");
		return false;
	}
	if(originDateList.length>0 && originDateList.length%4 == 0)$("#datelist").append("<br/>");
	originDateList.push(itemStr);
	$("#datelist").append("<span title=\"双击清除此项\" class=\"date-para-item\" id=\"date-i-"+originDateList.length+"\">"+originDateList.length+(originDateList.length<10?". ":".")+"<span class=\"date-item\">"+startdate+"</span>~<span class=\"date-item\">"+enddate+"</span></span>");
	return true;
}
function deleteListItem(thisDom)
{
	var idStr = $(thisDom).attr('id');
	var index = Number(idStr.split('-')[2])-1;
	if(index>-1)
	{
		originDateList.splice(index,1);
	}
	refreshListItem();
}
function refreshListItem()
{
	$("#datelist").empty();
	if(originDateList.length <= 0) $("#btnShow").attr("disabled",true);
	var dateListItemArr = new Array();
	for(var i=0;i<originDateList.length;i++)
	{
		dateListItemArr = originDateList[i].split("~");
		if(i%4 == 0 && i/4>=1)$("#datelist").append("<br/>");
		$("#datelist").append("<span title=\"双击清除此项\" class=\"date-para-item\" id=\"date-i-"+(i+1)+"\">"+(i+1)+(i<9?". ":".")+"<span class=\"date-item\">"+dateListItemArr[0]+"</span>~<span class=\"date-item\">"+dateListItemArr[1]+"</span></span>");
	}
}
function getDateListStr()
{
	var dateListStr="";
	for(var i=0;i<originDateList.length;i++)
	{
		if(dateListStr.length > 0) dateListStr=dateListStr+"^";
		dateListStr = dateListStr+originDateList[i];
	}
	return dateListStr;
}
function initPlotData(data,tick)
{
	originTickArr = new Array();
	originDataSet = new Object();
	var dataRecord = new Array();
	originTicks = new Object();
	var shortShowTick = (tick.length>15);
	$.each(tick,function(i,r){
		originTickArr.push([r.value,shortShowTick?r.value:r.desc]);
		originTicks["tick_"+r.value]=r;
	});
	$.each(data,function(i,r){
		dataRecord = new Array();
		r.data = eval('('+r.data+')');
		$.each(r.data,function(index,arr){
			if(dataRecord[arr[0]])dataRecord[arr[0]][arr[1]]=arr[2];
			else
			{
				dataRecord[arr[0]] = new Array();
				dataRecord[arr[0]][arr[1]]=arr[2];
			}
		});
		originDataSet["dataItem_"+r.dateIndex]=dataRecord;
	});
	plotAccordingToChoices();
}

function initPlot(data,tickArr)
{
	var placeholder = $("#placeholder");
	placeholder.unbind();
	var barSeries = {
		stack: 0,
		lines: {
			show: false,
			fill: true,
			steps: false
		},
		bars: {
			show: true,
			barWidth: 0.6,
			align: "center"
		}
	};
	var lineSeries = {
		lines: {show: true},  
		points: {show: true} 
	};
	var ifBar = $("#chkShowBar").prop("checked");
	var plotSeries = lineSeries;
	if (ifBar) plotSeries = barSeries;
	var pl = $.plot($("#placeholder"),data,
	{
		series: plotSeries,
		legend: {
				noColumns: 2
		},
		grid: {
			show:true,
			hoverable: true,
			clickable: true,
			borderColor:'#000',
			borderWidth:1
		},  
		xaxis: 
		{
			ticks: tickArr
		}
    }
	);
	$("#placeholder").bind("plothover", function (event, pos, item) {
		if (item) {
			var x = item.datapoint[0],//.toFixed(2),
				y = item.datapoint[1];//.toFixed(2);
			var count = y;
			if(item.datapoint[2]) count = y-item.datapoint[2];
			count = count.toFixed(2);
			var tick = originTicks["tick_"+x];
			var tickDesc = "";
			if(tick) tickDesc = tick.desc;

			$("#tooltip").html("<p>"+tickDesc+"<br/><br/>"+item.series.label+":"+count+"</p>")
				.css({top: item.pageY+5, left: item.pageX+5})
				.fadeIn(200);
		} else {
			$("#tooltip").hide();
		}
	});
}

function initPlotChoices(choices_id)
{
	var choiceContainer = $("#"+choices_id);
	choiceContainer.empty();
	$.each(originChoices[choices_id], function(key, val) {
		choiceContainer.append("<input type='checkbox' name='" + choices_id + val.code +
			"' checked='checked' id='id-" + choices_id + val.code + "'></input>" +
			"<label for='id-" + choices_id + val.code + "'>"
			+ val.desc + "</label><br/>");
		if(!originChoices[(choices_id + val.code)])
		{
			originChoices[(choices_id + val.code)]=new Object();
			originChoices[(choices_id + val.code)]["label"]=val.desc;
			originChoices[(choices_id + val.code)]["color"]=Number(val.code);
		}
		else
		{
			originChoices[(choices_id + val.code)]["label"]=val.desc;
		}
	});
	SetAllChoices("chkAllChoices");
	//choiceContainer.find("input").click(plotAccordingToChoices);
}

function SetAllChoices(thisId)
{
	if(((thisId=="chkAllChoices") && $("#chkAllChoices").prop("checked")) ||((thisId=="chkAllColChoices") && !$("#chkAllColChoices").prop("checked"))) 
	{
		$("#chkAllChoices").prop("checked",true);
		$("#chkAllColChoices").prop("checked",false);
		$("#choices input").prop("checked",true);
		$("#columnchoices input").prop("checked",false);
		$("#columnchoices input").first().prop("checked",true);
	}
	else
	{
		$("#chkAllChoices").prop("checked",false);
		$("#chkAllColChoices").prop("checked",true);
		$("#choices input").prop("checked",false);
		$("#choices input").first().prop("checked",true);
		$("#columnchoices input").prop("checked",true);
	}
}

function ClearChoices()
{
	var choiceContainer = $("#choices");
	choiceContainer.empty();
	var columnChoicesContainer = $("#columnchoices");
	columnChoicesContainer.empty();
}

function plotAccordingToChoices() {
	if(!originDataSet["dataItem_1"]) return;
	var checkChoices = $("#chkAllChoices").prop("checked");
	var checkColChoices = $("#chkAllColChoices").prop("checked");
	var chioceId = "choices";
	var oneCheckChioceId="columnchoices";
	var oneCheckIndex = 1;
	if(checkColChoices)
	{
		chioceId="columnchoices";
		oneCheckChioceId = "choices";
		oneCheckIndex = 0;
	}
	var oneCheckChioceValue = 0;
	var oneCheckChioceContainer = $("#"+oneCheckChioceId);
	oneCheckChioceContainer.find("input:checked").each(function (){
		var key = $(this).attr("name");
		if (key) {
			oneCheckChioceValue = Number(key.replace(oneCheckChioceId,""));
			return;
		}
	});
	var data = [];
	var chioceValue = 0;
	var choiceContainer = $("#"+chioceId);
	var theader = getDateListHeader();
	var tbody = "";
	choiceContainer.find("input:checked").each(function () {
		var key = $(this).attr("name");
		var singleData = [];
		var singleValue = 0;
		var trow = "";
		if (key) {
			chioceValue = Number(key.replace(chioceId,""));
			$.each(originDataSet,function(i,r){
				singleValue = 0;
				if(oneCheckIndex) 
				{
					if(r[chioceValue])singleValue = Number(r[chioceValue][oneCheckChioceValue]);
				}
				else 
				{
					if(r[oneCheckChioceValue])singleValue = Number(r[oneCheckChioceValue][chioceValue]);
				}
				singleData.push([Number(i.replace("dataItem_","")),singleValue]);
				trow = trow+"<td>"+singleValue+"</td>";
			});
			data.push({label:originChoices[key].label,data:singleData,color:originChoices[key].color});
			trow = "<tr><td>"+originChoices[key].label+"</td>"+trow+"</tr>";
			tbody = tbody+trow;
		}
	});
	if (data.length > 0) {
		initPlot(data,originTickArr);
		$("#chartdatatable thead").empty();
		$("#chartdatatable thead").append(theader);
		$("#chartdatatable tbody").empty();
		$("#chartdatatable tbody").append(tbody);
	}
}
function getDateListHeader()
{
	var theader = "";
	for(var i in originTicks)
	{
		if(originTicks[i])
		{
			if(originTicks[i]["desc"])
			{
				theader = theader+"<th title=\""+originTicks[i]["value"]+"\">"+originTicks[i]["desc"]+"</th>";
			}
		}
	}
	theader = "<tr><th><div class=\"th-header\">项目</div></th>"+theader+"</tr>";
	return theader;
}
