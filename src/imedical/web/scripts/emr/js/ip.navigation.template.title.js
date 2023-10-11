
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
			"p2":titleCode,
			"p3":episodeId
		},
		success: function(d) {
			if (d == "") return;
			var showFlag = "false";
			//dateTime=="" 为病历创建时的情况，!=""为已创建病历再次修改情况。
			//首程否则首次病程会一直默认去创建。
			if ((d.DefaultLoad=="True")&&(dateTime==""))
			{
				dateTime = d.DateTime;
				$("#dateTime").datetimebox('setValue',dateTime);
				$("#titleName").html(d.Title);	
				checkSure();
			}
			for (var i=0;i<d.Config.length;i++)
			{
				if (d.Config[i].Type == "Title")
				{
					if ((d.Config[i].Format.indexOf("DoctorName") != -1 )&&(d.Config[i].Visible == "TRUE"))
					{
						var showFlag = "true";
						$(".doctor").css('display','block');
						initDoctorInfo(d.Config[i].Format,d.Config[i].Params,titlePrefix);	
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
						//日期不只读的情况下，不论标题是否显示均应该可编辑时间。
						showFlag = "true";
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
				dateTime = d.DateTime;
			}			
			$("#lbTitleName").html(" "+d.Title);
			$("#dateTime").datetimebox('setValue',dateTime);
			$("#titleName").html(d.Title);	
			if ((showFlag == "false")&&(action != "updateTitle"))
			{
				checkSure();
			}
			if (d.EventType != "")
			{
				$(".event").css('display','block');
				strXml = d.EventConfig;
				eventType = d.EventType;
				initEventInfo(d.EventData);
			}	
			else
			{
				$(".event").css('display','none');
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
        if ((isCanModifyTitle == "Y")&&(tmpTitlePrefix == "")) {
			$.messager.alert("提示","请选择医生后再进行修改");
            return;
        }
	}
	var tmpTitle = $("#titleName").text();
	var tmpDateTime = $('#dateTime').datetimebox('getValue');
	if (createAdvance == "N")
	{
		var compareTime = createDateTime;
		if (compareTime == "") {compareTime = dateTime;}
		if (!compareDateTime(tmpDateTime,compareTime))
		{
			if (createDateTime == "")
			{
				$.messager.alert("提示","不可以提前写病历，请修改病历时间小于当前时间");
			}
			else
			{
				$.messager.alert("提示","不可以提前写病历，请修改病历时间小于病历创建时间");
			}
			return;
		}
	}
	var tmpEventID = "";
	var isRefresh = "0";
	if (eventType != "")
	{
		var eventInfo = $('#eventValues').combogrid('getValues');
		for (i=0;i<eventInfo.length;i++)
		{
			if (tmpEventID != "")
			{
				tmpEventID = tmpEventID + "@"; 
			}
			tmpEventID = tmpEventID + eventInfo[i];
		}
		var g = $('#eventValues').combogrid('grid');	// 获取表格控件对象
		var rows = g.datagrid('getRows');	//获取表格当前选中行
		if ((rows.length > 0)&&(tmpEventID == ""))
		{
			$.messager.alert("提示","未关联不可创建病历，请先选择关联！");
			return;
		}
		if (eventID != tmpEventID)
		{
			isRefresh = "1";
		}
	}
	if (!compareDateTimeByEpisodeTime(tmpDateTime)) return;
	if (!compareDateTimeByFisrtRecord(tmpDateTime,g_returnData.titleCode)) return;
	if (!checkAllowModifyCreateRange(tmpDateTime)) return;
	g_returnData.titleName = tmpTitle;
	g_returnData.dateTime = tmpDateTime;
	g_returnData.titlePrefix = tmpTitlePrefix;
	g_returnData.doctorID = tmpDoctorID;
	g_returnData.eventID = tmpEventID;
	g_returnData.eventType = eventType;
	g_returnData.isRefresh = isRefresh;
	window.returnValue = g_returnData;
	closeWindow();
}

$("#cancel").click(function(){
	if ((action == "updateTitle")||(action == "modifyTitle"))
	{
		closeWindow();
	}
	else
	{
		g_returnData = {};
		eventType = "";
		$("#title").css("display","none");
		$("#list").css("display","block");
		$.parser.parse(); 
	}
});

///病历创建的createdatetime和修改时间做对比
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
	var createCode = g_returnData.titleCode;
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
			"p3":createCode
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


function initDoctorInfo(format,params,titlePrefix)
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
						if ((titlePrefix != "undefined")&&(titlePrefix != ""))
						{
							$.each(data,function(idx,val){
			    				if (val.Desc == titlePrefix){	
				    				$('#doctorInfo').combobox('select',val.RowID);
				    			return;
				    			}
							});
						}
						else if (defaultDoc != "")
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

//取危机值
function initEventInfo(data)
{
	$('#eventValues').combogrid({
		fit:true,
		headerCls:'panel-header-gray',
	    loadMsg:'数据装载中......',
	    data:data, 
	    multiple:true,
	    idField:'ID',
	    textField:'TextField',
	    fitColumns:false,
	    checkOnSelect:true,
	    selectOnCheck:true,
	    columns:getColumnScheme("show>item"),
	    rowStyler: function(index,row){
			var values = eventID.split("@");
			if ((row.IsLink == "已关联")&&($.inArray(row.ID,values) == -1))
			{
				return 'color:#CCCCCC;';
			}
			if ((eventType == "Consult")||(eventType == "MDTConsult"))
			{
				if (((row.ConsultStatus == "取消")||(row.ConsultStatus == "驳回"))&&($.inArray(row.ID,values) == -1))
				{
					return 'color:#CCCCCC;';
				}
			}
			if (eventType == "Operation")
			{
				if (((row.OperPAStatus == "拒绝")||(row.OperPAStatus == "撤销"))&&($.inArray(row.ID,values) == -1))
				{
					return 'color:#CCCCCC;';
				}
			}
		},
		onBeforeSelect: function(rowIndex, rowData){
	    	//如果当前的复选框不可选，则不让其选中
	    	var values = eventID.split("@");
			if ((rowData.IsLink == "已关联")&&($.inArray(rowData.ID,values) == -1))
			{
	            return false;
	        }
	        if ((eventType == "Consult")||(eventType == "MDTConsult"))
			{
				if (((rowData.ConsultStatus == "取消")||(rowData.ConsultStatus == "驳回"))&&($.inArray(rowData.ID,values) == -1))
				{
					return false;
				}
			}
			if (eventType == "Operation")
			{
				if (((rowData.OperPAStatus == "拒绝")||(rowData.OperPAStatus == "撤销"))&&($.inArray(rowData.ID,values) == -1))
				{
					return false;
				}
			}
	    },
	    onLoadSuccess:function(data){
			if (data.rows.length > 0) {
				if ((action == "updateTitle")&&(eventID != ""))
				{
					var values = eventID.split("@");
					$('#eventValues').combogrid('setValues', values);
				}
				for (var i = 0; i < data.rows.length; i++) {
					if ((data.rows[i].IsLink == "已关联")&&($.inArray(data.rows[i].ID,values) == -1)) {
						
						$("input[type='checkbox']").eq(i + 1).attr("disabled",'disabled');
					}
					if ((eventType == "Consult")||(eventType == "MDTConsult"))
					{
						if (((data.rows[i].ConsultStatus == "取消")||(data.rows[i].ConsultStatus == "驳回"))&&($.inArray(data.rows[i].ID,values) == -1)) {
							
							$("input[type='checkbox']").eq(i + 1).attr("disabled",'disabled');
						}
					}
					if (eventType == "Operation")
					{
						if (((data.rows[i].ConsultStatus == "拒绝")||(data.rows[i].ConsultStatus == "撤销"))&&($.inArray(data.rows[i].ID,values) == -1)) {
							
							$("input[type='checkbox']").eq(i + 1).attr("disabled",'disabled');
						}
					}
				}
			}
		} 
	});	
	$(".datagrid-header-check").attr("disabled","disabled"); 
	$(".datagrid-header-check").html("");
}

//表字段Scheme
function getColumnScheme(path)
{
	var columns = new Array();
	columns.push({field:'ck',checkbox:true});
	columns.push({field:'ID',hidden:true});
    var showparent = $(strXml).find(path).each(function(){
	    var code = $(this).find("code").text();
	    if (code != "IsActive")
	    {
		    var desc = $(this).find("desc").text();
		    var sortable = $(this).find("sortable").text()=="Y"?true:false;
		    var hidden = $(this).find("hidden").text()=="Y"?true:false; 
		    var colwidth = $(this).find("width").text();
		        //colwidth = (colwidth=="")?100:colwidth;     
		    columns.push({field:code,title:desc,width:colwidth,hidden:hidden,sortable:sortable});
    	}
    });
    return [columns];
}
