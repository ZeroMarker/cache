$(function(){
	var girdParam = {
		GUID:GUID
	};
	var cols = [];
	var resColDesc = "";
	var resultColumnArr = resultColumn.split("&");
	$.each(resultColumnArr,function(i,item)
	{
		var itemArr = item.split("^");
		var tmpcol = {field:itemArr[1],title:itemArr[3]};
		cols.push(tmpcol);
		resColDesc = resColDesc+"/"+itemArr[3];
	})
	$('#taskResult').datagrid({
		title:"查询结果(条件："+conditionsDesc+")",
		headerCls:'panel-header-gray',
		pagination:true,
		rownumbers:true,
		pageSize:20,
		url: '../web.eprajax.query.medicalquerytask.cls?frameType=HISUI&actionType=GetTaskDitails',
		fit:true,
		queryParams:girdParam,
		columns:[cols],
		onLoadSuccess: function(data)
		{
			if (data.total == "0") 
			{
				//如果没有数据，设置不可导出，关闭页面直接删除记录
				$('#exportAllData').linkbutton('disable');
				returnValue.dataLength = "0";
			}
		}
	});

	document.getElementById("exportAllData").onclick = function(){
		//导出数据
		exportAllData();
	}

	//查看任务时记录日志
	var ipAddress = parent.getIpAddress();
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../web.eprajax.query.medicalquerytask.cls",
		async : true,
		data : {
		"actionType":"EMR.Query.Task.View",
		"userID":userId,
		"userName":userName,
		"ipAddress":ipAddress,			//当前ip
		"dataType":queryType,			//日期类型
		"conditions":conditionsDesc,	//条件描述
		"resultCol":resColDesc			//结果列
		}
	});	

})

//导出数据
function exportAllData()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.Tools.ExportToExcel",
			"Method":"toExcelByEMR",
			"p1":userName+"-"+conditionsDesc,
			"p2":"EPRservice.BLL.Query.BLMedicalQueryTasklist",
			"p3":"ExportTaskResultDetails",
			"p4":GUID
		},
		success: function(d) {
			var flag = d.substring(0,1);
			if(flag=="w"){
				returnValue.status = GUID;
				location.href=d;
			}else
			{
				returnValue.status = "0";
			}
			//if(judgeIsIE())	closeWindow();
		},
		error : function(d) { 
			alert("导出EXCEL错误");
		}
	})
	
}

function closeWindow()
{
	parent.closeDialog("dialogViewTaskResult");
}

function judgeIsIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}