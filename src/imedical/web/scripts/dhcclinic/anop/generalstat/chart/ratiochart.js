var PageData = new Object();
PageData["Current"] = new Object();
PageData["Current"]["Nodes"] = ["Rows","Dates"];
PageData["Current"]["allowSelectNode"] = "Rows";
PageData["Current"]["title"] = title;
PageData["Current"]["subtitle"] = "";
PageData["Dates"] = new Array();
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
		currentText: "今天",
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
		currentText: "今天",
		monthNamesShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
	});
	$("#btnShow").button().click(function(){
		if(!setStartEndDate()) return;
		var displayParaStr=$("#displayPara").val();
		var dateListStr=getDateListStr();
		var requestData={
			ClassName:"web.DHCANOPChart",
			QueryName:"GetTimeLineChartData",
			Arg1:anciId,
			Arg2:displayParaStr,
			Arg3:dateListStr,
			ArgCnt:3
		};
		refreshData(requestData,initData);
	});
	
	$("#btnAddToList").button();
	$("#btnClearList").button();
	$("#datelist").tooltip();
	$("#btnShow").attr("disabled",true);

	refreshData({
		ClassName:"web.DHCANOPStat",
		QueryName:"GetTimeLineChartPara",
		Arg1:anciId,
		ArgCnt:1
	},initSelectPara);
	refreshData({
		ClassName:"web.DHCANOPChart",
		QueryName:"GetChartDateList",
		ArgCnt:0
	},function(data){
		data = eval("("+data+")");
		PageData["Dates"] = data.record;
		refreshListItem();
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
		refreshData(requestData,initRowList);
	});
	$(document).delegate('input.accordingcheck', 'click', function() {
		var check = $(this).prop("checked");
		$("input.accordingcheck").prop("checked",false);
		$(this).prop("checked",check);
	});
	$(document).delegate('#choices input', 'click', function() {
		initChart();
	});
	$(document).delegate('#columnchoices input', 'click', function() {
		$("#columnchoices input").prop("checked",false);
		$(this).prop("checked",true);
		initChart();
	});
	$(document).delegate('#changeAxis', 'click', function() {
		var nodes = new Array();
		nodes.push(PageData["Current"]["Nodes"][1]);
		nodes.push(PageData["Current"]["Nodes"][0]);
		PageData["Current"]["Nodes"] = nodes;
		initChart();
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

	$("#btnClearList").click(function(){
		PageData["Dates"] = new Array();
		$("#datelist").empty();
	});

	$(document).delegate('span.date-para-item', 'dblclick', function() {
		deleteListItem(this); 
	});
});

function refreshData(requestData,successFunction)
{
	$.ajax({
        type: "POST",
        url: "./dhcclinic.query.csp",
        data: requestData,
        dataType: "text",
        success: successFunction,
        error: function (msg) {
            alert("加载失败,请稍后重试!" + "\rCode:" + msg.status + " " + msg.statusText + "\r" + msg.responseText + "\r");
        },
        complete: function (data) {
        }
    });
}

function initSelectPara(data)
{
	data=eval('('+data+')');
    $.each(data.record,function(i,r){
		$("#displayPara").append("<option value='"+r.code+"'>"+r.desc+"</option>");
	});
	$("#displayPara").change();
}

function initRowList(data)
{
	data=eval('('+data+')');
	PageData["Rows"] = new Array();
	for(var i=0;i<data.record.length;i++)
	{
		PageData["Rows"].push({code:data.record[i].code,desc:data.record[i].desc});
	}

	initPlotChoices("choices",PageData["Rows"],true);
}

function initData(data)
{
	data=eval('('+data+')');
	PageData["Columns"] = new Array();
	for(var i=0;i<data.record.length;i++)
	{
		PageData["Columns"][i] = data.record[i];
		PageData["Columns"][i].data = eval("("+PageData["Columns"][i].data+")");
	}
	initPlotChoices("columnchoices",PageData["Columns"],false);
	initChart();
}

function setStartEndDate()
{
	if(PageData["Dates"].length>0) return true;

	PageData["Dates"] = new Array();
	var startDateStr=$("#startdatepicker").val();
	if(startDateStr=="")
	{
		alert("请输入开始日期!");
		$("#startdatepicker").focus();
		$("#startdatepicker").addClass("require");
		return false;
	}
	var endDateStr=$("#enddatepicker").val();
	if(endDateStr=="")
	{
		alert("请输入结束日期!");
		$("#enddatepicker").focus();
		$("#enddatepicker").addClass("require");
		return false;
	}
	addDateStrToList(startDateStr,endDateStr);
	return true;
}

function addDateStrToList(startdate,enddate)
{
	var ifaccordingyear=$("#accordingyear").prop("checked");
	var ifaccordingquarter=$("#accordingquarter").prop("checked");
	var ifaccordingmouth=$("#accordingmouth").prop("checked");

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
	
	var subtitle = "";

	if(ifaccordingyear)
	{
		for(var y=Number(startdateArr[0]);y<=Number(enddateArr[0]);y++)
		{
			if(!addToList(y+"年",y+"-01-01",y+"-12-31")) return;
		}
		subtitle = Number(startdateArr[0])+"年到"+Number(enddateArr[0])+"年";
	}
	else if(ifaccordingquarter)
	{
		for(var y=Number(startdateArr[0]);y<=Number(enddateArr[0]);y++)
		{
			addToList(y+"年Q1",y+"-01-01",y+"-03-31");
			addToList(y+"年Q2",y+"-04-01",y+"-06-30");
			addToList(y+"年Q3",y+"-07-01",y+"-09-30");
			addToList(y+"年Q4",y+"-10-01",y+"-12-31");
		}
		subtitle = Number(startdateArr[0])+"年一季度到"+Number(enddateArr[0])+"年四季度";
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
				if(!addToList(y+"年"+m+"月",y+"-"+(m<10?"0"+m:""+m)+"-01",nextyear+"-"+nextmonth+"-"+nextday)) return;
			}
		}
		subtitle = Number(startdateArr[0])+"年"+Number(startdateArr[1])+"月到"+Number(enddateArr[0])+"年"+Number(enddateArr[1])+"月";
	}
	else
	{
		var datename = Number(startdateArr[0])+"年"+Number(startdateArr[1])+"月"+Number(startdateArr[2])+"日到"+Number(enddateArr[0])+"年"+Number(enddateArr[1])+"月"+Number(enddateArr[2])+"日";
		addToList(datename,startdate,enddate);
	}

	PageData["Current"]["subtitle"] = subtitle;
}

function addToList(name,startdate,enddate)
{
	var itemStr = startdate+"~"+enddate;
	if(PageData["Dates"].length>=50)
	{
		alert("时间序列数量已达到上限50,不能继续增加!");
		return false;
	}
	PageData["Dates"].push({"desc":name,"duration":itemStr});
	$("#datelist").append("<span title=\"双击清除此项\" class=\"date-para-item\" id=\"date-i-"+PageData["Dates"].length+"\">"+PageData["Dates"].length+(PageData["Dates"].length<10?". ":".")+"<span class=\"date-item\">"+name+"</span></span>");
	return true;
}

function deleteListItem(item)
{
	var idStr = $(item).attr('id');
	var index = Number(idStr.split('-')[2])-1;
	if(index>-1)
	{
		PageData["Dates"].splice(index,1);
	}
	refreshListItem();
}

function refreshListItem()
{
	$("#datelist").empty();
	if(PageData["Dates"].length <= 0) $("#btnShow").attr("disabled",true);
	else $("#btnShow").attr("disabled",false);
	var dateListItemArr = new Array();
	for(var i=0;i<PageData["Dates"].length;i++)
	{
		dateListItemArr = PageData["Dates"][i].duration.split("~");
		if(i%4 == 0 && i/4>=1)$("#datelist").append("<br/>");
		$("#datelist").append("<span title=\"双击清除此项\" class=\"date-para-item\" id=\"date-i-"+(i+1)+"\">"+(i+1)+(i<9?". ":".")+"<span class=\"date-item\">"+PageData["Dates"][i].desc+"</span></span>");
	}
}

function getDateListStr()
{
	var dateArray=new Array();
	$.each(PageData["Dates"],function(ind,e){
		dateArray.push(e.duration+"|"+e.desc);
	});

	return dateArray.join("^");
}

function initChart()
{
	var title = PageData["Current"].title;
	var subtitle = PageData["Current"].subtitle;
	var columnInd = getSelectColumnInd();
	setSelectRow();
	setPlotContainerWidth();
	$('#container').highcharts({
        chart: {
            type: 'column'
        },
        title: {
            text: title
        },
        subtitle: {
            text: subtitle
        },
        xAxis: {
            categories: getCategories(),
            crosshair: true
        },
        yAxis: {
            min: 0,
            title: {
                text: getColumnName(columnInd)
            }
        },
        tooltip: {
            //headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            /*pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                '<td style="padding:0"><b>{point.y:.0f}'+getColumnUom(columnInd)+'</b></td></tr>',
            footerFormat: '</table>',*/
            shared: true,
            useHTML: true,
            formatter:function(){
            	var headerHtml='<span style="font-size:10px">'+this.x+'</span><table>';
            	var pointsHtml='';
            	var footerHtml='</table>';
            	var lastY=0;
            	$.each(this.points,function(ind,e){
            		pointsHtml=pointsHtml+'<tr><td style="color:'+e.series.color+';padding:0">'
            			+e.series.name+': </td>'
                		+'<td style="padding:0"><b>'+e.y+getColumnUom(columnInd)+'</b></td>'
                		+'<td style="padding:0 5px;color:#2363CA"><b>增长率:'
                		+(lastY==0?'--':((e.y-lastY)/lastY*100).toFixed(2))+'%</b></td>'
                		+'</tr>';
                	lastY = e.y;
            	});
            	return headerHtml+pointsHtml+footerHtml;
            }
        },
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                    align:'center',
                    //useHTML:true,
                    //format: '{point.y}'
                    formatter:function(){
                    	var html="";
                    	var growth=0;
                    	var ind=this.series._i;
                    	var point=this.point;
                    	var lastPointY;
                    	//html += "<pre style='text-align:center;margin:0;'>"+point.y;
                    	html += point.y;
                    	if(ind>0)
                    	{
                    		lastPointY = PageData["Current"]["series"][ind-1].data[point.index];
                    		if(lastPointY!=0)
                    		{
                    			growth = ((point.y-lastPointY)/lastPointY*100).toFixed(0);
                    			/*html += "<br><span "+"style='color:"
                    				+(growth>0?"#F00":"#0F0")+"'>"
                    				+growth+"% "
                    				+(growth>0?"↑":"↓")+"</span>";*/
                    			html += "<br>"+growth+"% "+(growth>0?"↑":"↓");
                    		}
                    	}
                    	//html += "</pre>";

                    	return html;
                    }
                }
            }
        },
        series: getSeries(columnInd)
    });
}

function setPlotContainerWidth()
{
	var width = 60 * PageData["Rows"].length * PageData["Dates"].length;
	$('#container').width(width);
}

function getSelectColumnInd()
{
	var columnInd = Number($("#columnchoices").find("input:checked")[0].name);
	$.each(PageData["Columns"],function(ind,e){e["Checked"]=false;})
	PageData["Columns"][columnInd]["Checked"]=true;

	return columnInd;
}

function setSelectRow()
{
	var selectRowCodeArr =new Array();
	$.each(PageData["Rows"],function(ind,e){e["Checked"]=false;});
	$("#choices").find("input:checked").each(function(){
		PageData["Rows"][Number($(this).attr("name"))]["Checked"]=true;
	});
}

function getColumnName(columnInd)
{
	return PageData["Columns"][columnInd].desc;
}

function getColumnUom(columnInd)
{
	return PageData["Columns"][columnInd].uom;
}

function getSeries(columnInd)
{
	var firstNode = PageData["Current"].Nodes[0];
	var secondNode = PageData["Current"].Nodes[1];
	var allowSelectNode = PageData["Current"]["allowSelectNode"];
	var chartSeries = new Array();
	var name = "";
	var data = new Array();
	for (var i = 0;i < PageData[secondNode].length; i++)
	{
		if(allowSelectNode == secondNode && !PageData[secondNode][i]["Checked"]) continue;
		name = PageData[secondNode][i].desc;
		data = new Array();
		if(allowSelectNode == secondNode) data = PageData["Columns"][columnInd].data[i];
		else
		{
			for(var j = 0;j < PageData[firstNode].length;j++)
			{
				if(PageData[firstNode][j]["Checked"])
					data.push(PageData["Columns"][columnInd].data[j][i]);
			}
		}
		
		chartSeries.push({"name":name,"data":data});
	}
	PageData["Current"]["series"]=chartSeries;
	return chartSeries;
}

function getCategories()
{
	var node = PageData["Current"].Nodes[0];
	var ifAllowSelect = (PageData["Current"]["allowSelectNode"] == node);
	var xAxisCats = new Array();
	for (var i = 0; i < PageData[node].length; i++)
	{
		if(ifAllowSelect && !PageData[node][i]["Checked"]) continue;
		xAxisCats.push(PageData[node][i].desc);
	}
	return xAxisCats;
}

function initPlotChoices(choices_id,choices,checkAll)
{
	var choiceContainer = $("#"+choices_id);
	choiceContainer.empty();
	$.each(choices, function(ind, e) {
		choiceContainer.append("<span><input type='checkbox' name='" + ind +"'"
			+ ((checkAll || ind==0)?" checked='checked'":"")
			+ " id='id-" + choices_id + e.code + "'></input>"
			+ "<label for='id-" + choices_id + e.code + "'>"
			+ e.desc + "</label></span><br/>");
	});
}