
function setTitle(titleCode)
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
			var showFlag = "false";
			for (var i=0;i<d.Config.length;i++)
			{
				if (d.Config[i].Type == "Title")
				{
					if ((d.Config[i].Format.indexOf("DoctorName") != -1 )&&(d.Config[i].Visible == "TRUE"))
					{
						var showFlag = "true";
						$(".doctor").css('display','block');
						initDoctorInfo(d.Config[i].Format,d.Config[i].Params);	
						if (action == "updateTitle")
						{
							document.getElementById("doctorInfo").value = titlePrefix;
						}
					}
					else
					{
						$(".doctor").css('display','none');
					}
					
				}
				else
				{
					if (d.Config[i].ReadOnly == "True")
					{
						$("#dateTime").datetimebox({disabled:true});
					}
					else
					{
						$("#dateTime").datetimebox({disabled:false});
					}
					if (d.Config[i].Visible == "FALSE")
					{
						var showFlag = "true";
					}
				}
			}
			if ((action == "updateTitle")&&(dateTime != ""))
			{
				$("#lbDateTime").html(dateTime);
			}
			else
			{
				$("#lbDateTime").html(d.DateTime);
			}
			dateTime = d.DateTime;
			$("#lbTitleName").html(" "+d.Title);
			$("#dateTime").datetimebox('setValue',d.DateTime);
			$("#titleName").html(d.Title);	
			if ((showFlag == "false")&&(action != "updateTitle"))
			{
				checkSure();
			}	
		},
		error : function(d) { 
			alert("initConfig error");
		}
	});	
}

$("#sure").click(function(){
	checkSure();
});

function checkSure()
{
	var tmpTitlePrefix = "";
	var tmpDoctorID = "";
	if ($(".doctor").css("display") == "block")
	{
		tmpTitlePrefix = $('#doctorInfo').combobox('getText');
		tmpDoctorID = $('#doctorInfo').combobox('getValue');
	}
	var tmpTitle = $("#titleName").text();
	var tmpDateTime = $('#dateTime').datetimebox('getValue');
	if (createAdvance == "N")
	{
		if (!compareDateTime(tmpDateTime,dateTime))
		{
			alert("不可以提前写病历，请修改病历时间小于当前时间");
			return;
		}
	}
	if (!compareDateTimeByEpisodeTime(tmpDateTime)) return;
	if (!compareDateTimeByFisrtRecord(tmpDateTime,g_returnData.titleCode)) return;
	if (!checkAllowModifyCreateRange(tmpDateTime)) return;
	g_returnData.titleName = tmpTitle;
	g_returnData.dateTime = tmpDateTime;
	g_returnData.titlePrefix = tmpTitlePrefix;
	g_returnData.doctorID = tmpDoctorID;
	window.returnValue = g_returnData;
	closeWindow();
}

$("#cancel").click(function(){
	if (action == "updateTitle")
	{
		closeWindow();
	}
	else
	{
		g_returnData = {};
		$("#title").css("display","none");
		$("#list").css("display","block");
		$.parser.parse(); 
	}
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

	var allStartDate = new Date(arrStartDate[0], arrStartDate[1]-1, arrStartDate[2], arrStartTime[0], arrStartTime[1], arrStartTime[2]);   
	var allEndDate = new Date(arrEndDate[0], arrEndDate[1]-1, arrEndDate[2], arrEndTime[0], arrEndTime[1], arrEndTime[2]);   

	if (allStartDate.getTime() > allEndDate.getTime()) 
	{   
        return false;   
	} 
	else
	{   
		return true;   
    }   
}

//与入院出院日期比较
function compareDateTimeByEpisodeTime(dateTime)
{
	var setDocCode = openDocCode;
	var isCreate = 0;
	var createCode = g_returnData.titleCode;
	for(i=0;i<setDocCode.length;i++)
	{
		if(createCode == setDocCode[i])
		{
			isCreate = 1;
		}
	}
	var result = true;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLTitleConfig",
			"Method":"CanCreateByEpisodeTime",
			"p1":episodeId,
			"p2":dateTime,
			"P3":isCreate
		},
		success: function(d) {
			if (d != "1")
			{
				result = false;
				$.messager.alert("提示",d.substring(2));
			}
		},
		error : function(d) { 
			alert("compareDateTimeByFisrtRecord error");
		}
	});	
	return result	
}

//与首次病程日期比较
function compareDateTimeByFisrtRecord(dateTime,titleCode)
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
			if (d != "1")
			{
				result = false;
				$.messager.alert("提示",d.substring(2));
			}
		},
		error : function(d) { 
			alert("compareDateTimeByFisrtRecord error");
		}
	});	
	return result
}


function initDoctorInfo(format,params)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLPowerUser",
			"Method":"GetDoctorsCTLoc",
			"p1":locId,
			"p2":format,
			"p3":params,
			"p4":episodeId,
			"p5":userID
		},
		success: function(d) {
			if (d == "") return;
			var docInfo = eval("("+d+")");
			var defaultDoc = docInfo.DefaultDoc;
			var data = docInfo.DocData;
				$("#doctorInfo").combobox({
					valueField:"RowID",
					textField:"Desc",
					data:data,
					filter: function (q, row) {
		                var opts = $(this).combobox('options');
		                return (row["Code"].toLowerCase().indexOf(q.toLowerCase()) >= 0)||(row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0);
		            },
		            onLoadSuccess:function(d){
						if (defaultDoc != "")
						{
							$.each(data,function(idx,val){
			    				if (val.RowID == defaultDoc){	
				    				$('#doctorInfo').combobox('select',defaultDoc);
				    			return;
				    			}
							});
						}
					}
			});
		},
		error : function(d) { 
			alert("initDoctorInfo error");
		}
	});	
}

//判断是否在可修改时间范围内
function checkAllowModifyCreateRange(tmpdateTime)
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
			"Method":"CheckAllowModifyCreateRange",
			"p1":tmpdateTime
		},
		success: function(d) {
			if (d != "1")
			{
				result = false;
				parent.$.messager.alert("提示",d.substring(2));
			}
		},
		error : function(d) { 
			alert("checkAllowModifyCreateRange error");
		}
	});	
	return result
}