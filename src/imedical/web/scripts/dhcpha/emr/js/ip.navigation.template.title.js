$(function(){
	init();
});


function init()
{
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTitleConfig",
			"Method":"GetTitleConfigByCode",
			"p1":docId,
			"p2":titleCode
		},
		success: function(d) {
			if (d == "") return;
			$("#lbDateTime").html(dateTime);
			$("#lbTitle").html(" "+d.Title);
			$("#dateTime").datetimebox('setValue',dateTime);
			$("#title").html(d.Title);
			for (var i=0;i<d.Config.length;i++)
			{
				if (d.Config[i].ReadOnly == "True")
				{
					if (d.Config[i].Type == "Title")
					{
						$("#titlebefore").attr("disabled","disabled");
						$("#titleafter").attr("disabled","disabled")						
					}
					else
					{
						$("#dateTime").datetimebox({disabled:true});
					}
				}
			}
			
		},
		error : function(d) { 
			alert("initConfig error");
		}
	});	
}

$("#sure").click(function(){
	var tmpTitle = $("#titlebefore").val()+$("#title").text()+$("#titleafter").val();
	var tmpDateTime = $('#dateTime').datetimebox('getValue');
	if (createAdvance == "N")
	{
		if (!compareDateTime(tmpDateTime,dateTime))
		{
			alert("不可以提前写病历，请修改病历时间小于当前时间");
			return;
		}
	}
	if (!compareDateTimeByFisrtRecord(tmpDateTime)) return;
	window.returnValue = {"title":tmpTitle,"dateTime":tmpDateTime};
	closeWindow();
});

$("#cancel").click(function(){
	closeWindow();
});
///日期比较
function compareDateTime(startDate, endDate) 
{   
    var startDateTemp = startDate.split(" ");   
    var endDateTemp = endDate.split(" ");   

    var arrStartDate = startDateTemp[0].split("-");   
    var arrEndDate = endDateTemp[0].split("-");   

    var arrStartTime = startDateTemp[1].split(":");   
    var arrEndTime = endDateTemp[1].split(":");   

	var allStartDate = new Date(arrStartDate[0], arrStartDate[1], arrStartDate[2], arrStartTime[0], arrStartTime[1], arrStartTime[2]);   
	var allEndDate = new Date(arrEndDate[0], arrEndDate[1], arrEndDate[2], arrEndTime[0], arrEndTime[1], arrEndTime[2]);   

	if (allStartDate.getTime() > allEndDate.getTime()) 
	{   
        return false;   
	} 
	else
	{   
		return true;   
    }   
}
//与首次病程日期比较
function compareDateTimeByFisrtRecord(dateTime)
{
	var result = true;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTitleConfig",
			"Method":"CanCreateTitle",
			"p1":episodeId,
			"p2":docId,
			"p3":titleCode,
			"p4":dateTime
		},
		success: function(d) {
			if (d == "-1")
			{
				result = false;
				alert("请先创建首次病程记录");
			}
			else if (d == "0")
			{
				result = false;
				alert("所建病程不能早于首次病程");
			}
		},
		error : function(d) { 
			alert("compareDateTimeByFisrtRecord error");
		}
	});	
	return result
}
//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}


