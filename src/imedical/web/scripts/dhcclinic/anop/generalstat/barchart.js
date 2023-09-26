$(function(){
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
	$("#btnShow").click(function(){
		ClearChoices();
		var displayParaStr=$("#displayPara").val();
		var statType=$("#statType").val();
		var ifChangeAxis=$('#ifChangeAxis').prop('checked');
		var requestData={
			ClassName:"web.DHCANOPStat",
			QueryName:"GetInquiryChartData",
			Arg1:anciId,
			Arg2:displayParaStr,
			Arg3:"",
			Arg4:statType,
			Arg5:"1",
			Arg6:ifChangeAxis?"1":"0",
			Arg7:historySeq,
			ArgCnt:7
		};
		refreshData(requestData);
	});
	$('#btnShow').trigger("click");
	refreshSelectOption("statType",{
		ClassName:"web.DHCANOPStat",
		QueryName:"GetSummaryType",
		Arg1:anciId,
		ArgCnt:1
	});
	refreshSelectOption("displayPara",{
		ClassName:"web.DHCANOPStat",
		QueryName:"GetChartDisplayPara",
		Arg1:anciId,
		Arg2:historySeq,
		ArgCnt:2
	});
	$.ajax({
        type: "POST",
        url: "./dhcclinic.anop.testpost.csp",
		data: {},
        dataType: "json",
        success: function (data) {
		}
	});
	$('#chkAllChoices').click(function(){
		SetAllChoices($(this).prop("checked"));
	});
	$('#chkAllColChoices').click(function(){
		SetAllColChoices($(this).prop("checked"));
	});
});
var originDataSet = new Object();
var originTicks = new Object();
function refreshData(requestData) {
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

function initPlotData(data,tick)
{
	var tickArr = [];
	originDataSet = new Object();
	originTicks = new Object();
	var color = 0;
	$.each(tick,function(i,r){
		tickArr.push([r.value,r.desc]);
		originTicks["tick_"+i]=r;
	});
	$.each(data,function(i,r){
		r.data = eval('('+r.data+')');
		r.color = color;
		color++;
		originDataSet["dataItem_"+i]=r;
	});
	initPlotChoices();
}

function initPlot(data,tickArr)
{
	var placeholder = $("#placeholder");
	placeholder.unbind();
	var pl = $.plot($("#placeholder"),data,
	{
		series: {
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
		},
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

			$("#tooltip").html(item.series.label+":"+count)
				.css({top: item.pageY+5, left: item.pageX+5})
				.fadeIn(200);
		} else {
			$("#tooltip").hide();
		}
	});
}

function initPlotChoices()
{
	var choiceContainer = $("#choices");
	$.each(originDataSet, function(key, val) {
		choiceContainer.append("<input type='checkbox' name='" + key +
			"' checked='checked' id='id" + key + "'></input>" +
			"<label for='id" + key + "'>"
			+ val.label + "</label><br/>");
	});
	choiceContainer.find("input").click(plotAccordingToChoices);
	var columnChoicesContainer = $("#columnchoices");
	$.each(originTicks, function(key, val) {
		columnChoicesContainer.append("<input type='checkbox' name='" + key +
			"' checked='checked' id='id" + key + "'></input>" +
			"<label for='id" + key + "'>"
			+ val.desc + "</label><br/>");
	});
	columnChoicesContainer.find("input").click(plotAccordingToChoices);
	plotAccordingToChoices();
}

function SetAllChoices(ifChecked)
{
	if(ifChecked) $("#choices input").prop("checked",true);
	else $("#choices input").prop("checked",false);
	plotAccordingToChoices();
}

function SetAllColChoices(ifChecked)
{
	if(ifChecked) $("#columnchoices input").prop("checked",true);
	else $("#columnchoices input").prop("checked",false);
	plotAccordingToChoices();
}

function ClearChoices()
{
	var choiceContainer = $("#choices");
	choiceContainer.empty();
	var columnChoicesContainer = $("#columnchoices");
	columnChoicesContainer.empty();
}

function plotAccordingToChoices() {
	var tickArr = new Array();
	var xaixsArr = new Array();
	var xaixsArrDic = [];
	var columnChoicesContainer = $("#columnchoices");
	columnChoicesContainer.find("input:checked").each(function (){
		var key = $(this).attr("name");
		if (key && originTicks[key]) {
			tickArr.push([Number(originTicks[key].value),originTicks[key].desc]);
			xaixsArr.push(Number(originTicks[key].value));
			xaixsArrDic[Number(originTicks[key].value)]=1;
		}
	});
	var data = new Array();
	var choiceContainer = $("#choices");
	choiceContainer.find("input:checked").each(function () {
		var key = $(this).attr("name");
		var singleData = new Array();
		if (key && originDataSet[key]) {
			$.each(originDataSet[key].data,function(i,r){
				//if(xaixsArr.indexOf(r[0])>-1) singleData.push(r);
				if(xaixsArrDic[r[0]]) singleData.push(r);
			});
			data.push({label:originDataSet[key].label,data:singleData,color:originDataSet[key].color});
		}
	});
	if (data.length > 0) {
		initPlot(data,tickArr);
	}
}