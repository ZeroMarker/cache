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
		var searchLevel=$("#searchLevel").val();
		var statType=$("#statType").val();
		var requestData={
			ClassName:"web.DHCANOPStat",
			QueryName:"GetInquiryChartData",
			Arg1:anciId,
			Arg2:displayParaStr,
			Arg3:searchLevel,
			Arg4:statType,
			Arg5:"0",
			Arg6:"0",
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
	refreshSelectOption("searchLevel",{
		ClassName:"web.DHCANOPStat",
		QueryName:"GetChartSearchLevel",
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
	$('#chkAllChoices').click(function(){
		SetAllChoices($(this).prop("checked"));
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
            initPlotData(data.record);
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
function initPlotData(data)
{
	originDataSet = new Object();
	var color = 0;
	$.each(data,function(i,r){
		r.data = eval('('+r.data+')');
		r.color = color;
		color++;
		originDataSet["dataItem_"+i]=r;
	});
	initPlotChoices();
}
function initPlot(data)
{
	var placeholder = $("#placeholder");
	placeholder.unbind();
	$.plot(placeholder, data, {
		series: {
			pie: { 
				show: true
			}
		},
		legend: {
				noColumns: 2
		},
		grid: {
			hoverable: true,
			clickable: true
		}
	});
	placeholder.bind("plothover", function(event, pos, obj) {
		if (obj) {
			var percent = parseFloat(obj.series.percent).toFixed(2);
			$("#tooltip").html("<span style='font-weight:bold; color:#fff;'>" + obj.series.label +"</span><br><span style='font-weight:bold; color:#fff;'>"+obj.series.data[0][1]+"  (" + percent + "%)</span>")
				.css({top: pos.pageY+5, left: pos.pageX+5})
				.fadeIn(200);
		}else {
			$("#tooltip").hide();
		} 
	});

	placeholder.bind("plotclick", function(event, pos, obj) {
		if (!obj) {
			return;
		}
		var percent = parseFloat(obj.series.percent).toFixed(2);
		alert(""  + obj.series.label + ": " + percent + "%");
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
	plotAccordingToChoices();
}

function SetAllChoices(ifChecked)
{
	if(ifChecked) $("#choices input").prop("checked",true);
	else $("#choices input").prop("checked",false);
	plotAccordingToChoices();
}

function ClearChoices()
{
	var choiceContainer = $("#choices");
	choiceContainer.empty();
}

function plotAccordingToChoices() {
	var data = [];
	var choiceContainer = $("#choices");
	choiceContainer.find("input:checked").each(function () {
		var key = $(this).attr("name");
		var singleData = [];
		if (key && originDataSet[key]) {
			data.push($.extend({},originDataSet[key],{
				label: originDataSet[key].label.length > 8 ? (originDataSet[key].label.slice(0,8) + '...') : originDataSet[key].label
			}));
		}
	});
	initPlot(data);
}