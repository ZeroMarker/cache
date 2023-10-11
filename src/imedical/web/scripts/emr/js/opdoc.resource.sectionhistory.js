$(function(){
	$("#selectDiv").hide();
	$HUI.radio("[name='time']",{
        onChecked:function(e,value){
            var value = $(e.target).attr("value");
            if (value === "selectTime")
            {
				$("#selectDiv").show();
				$('#select').panel('resize', {
			        height: 130
			    });
			    $('body').layout('resize'); 
	        } 
	        else
	        {
				$("#selectDiv").hide();
				$('#select').panel('resize', {
			        height: 65
			    });
			    $('body').layout('resize'); 
				queryData("");
		    }
        }
    });
    
    $HUI.radio("[name='loc']",{
        onChecked:function(e,value){
            queryData("");
        }
    });
});

function GetSectionHistory(SecParam)
{
	if (typeof SecParam === "undefined" || SecParam === "") return;
	
	if (SecParam["code"]==undefined) return;
	sectionCode = SecParam["code"];
	
	if (SecParam["templateId"]==undefined) return;
	templateID = SecParam["templateId"];
	
	queryData("");
}

function queryData(lastEpisode)
{
	var startDate = "",
        endDate = "";
    var locSelect = "Loc";
    if ($('#All')[0].checked) {
	    locSelect = "All";
    }
        
    if ($('#fifteenDays')[0].checked) {
        var start = new Date();
        start.setDate(start.getDate() - 14);
        startDate = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        endDate = new Date().format("yyyy-MM-dd");
    } else if ($('#oneMonth')[0].checked) {
        var start = new Date();
        start.setDate(start.getDate() - 29);
        startDate = start.getFullYear() + "-" + (start.getMonth() + 1) + "-" + start.getDate();
        endDate = new Date().format("yyyy-MM-dd");
    } else if ($('#selectTime')[0].checked)
	{
		startDate = dateFormat($('#startDate').datebox('getText'));
	    endDate = dateFormat($('#endDate').datebox('getText'));
		if (startDate==""&&endDate!=""){
			endDateObj = Dateparser(endDate);
			var newDate=new Date(endDateObj.getTime()-(7*24*3600*1000))
			newDate=Dateformatter(newDate);
			$('#startDate').datebox('setValue',newDate);
			startDate=newDate;
		}else if(startDate!=""&&endDate=="")
		{
			var nowDate = new Date();
			nowDate=Dateformatter(nowDate);
			$('#endDate').datebox('setValue',nowDate);
			endDate=nowDate;
		}
	}
	
	jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLSectionHistory",
            "Method":"GetEpisodeList",
            "p1":patientID,
            "p2":userLocID,
            "p3":templateID,
            "p4":sectionCode,
        	"p5":startDate,
        	"p6":endDate,
        	"p7":locSelect,
        	"p8":lastEpisode,
        	"p9":episodeID
        },
        success: function(d) 
        {
            if (lastEpisode == "") 
            {
	            $('#timeline').empty();
            }
            if (d != "")
            {
	            setList(eval("["+d+"]")[0]);
            }
        },
        error : function(d) { 
            alert("queryData error");
        }
    });		
}

function Dateformatter(date)
{
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function Dateparser(s)
{
	if (!s) return new Date();
	var ss = s.split('-');
	var y = parseInt(ss[0],10);
	var m = parseInt(ss[1],10);
	var d = parseInt(ss[2],10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d))
	{
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}

//加载时间轴
function setList(data)
{
    for (var i=0;i<data.length;i++)
    {
    	$('#timeline').append(setlistdata(data[i]));
    }  
}

//加载具体信息
function setlistdata(data)
{
    var li = $('<li class="work"></li>');
    $(li).attr({"episodeID":data.EpisodeID});
    var first = $('<div class="relative"></div>');
    var text = "<span class='data'>" + data.EpisodeDate + "</span>" + " "  + data.MainDocName  + " " + data.EpisodeDeptDesc;
    $(first).append('<label for="work2">'+text+'</label>');
    var title = data.EpisodeDate + " " + data.MainDocName + " " + data.EpisodeDeptDesc;
    $(first).attr({"title":title});
    $(first).append('<span class="circle"></span>');
    $(li).append(first);
    var content = $('<div class="content"></div>');
    var second = ""
	var strs = data.SectionData.split("@@@"); 
	for (i=0;i<strs.length;i++ )
	{
		if (document.getElementById(strs[i]) != "")
		{
			if (i == "0")
			{
				second = second + '<p class="">'+strs[i]+'</p>';
			}
			else
			{
				second = second + '<p class="bottomp">'+strs[i]+'</p>';
			}
			
		}	
	} 	  
    
    $(content).append(second);
    $(li).append(content);
    return li;
}

$('#btnLoadMore').bind('click', function (evt) {
    var items = $('.work');
    var lastEpisodeID = items.length === 0 ? episodeID : items.last().attr('episodeID');
    
    queryData(lastEpisodeID)
});

if (isModelDlg) {
    invoker.emrEditor.refreshSecHistoryFunc = GetSectionHistory;
    window.onunload = function(){
        invoker.emrEditor.refreshSecHistoryFunc = null;
    }
}

