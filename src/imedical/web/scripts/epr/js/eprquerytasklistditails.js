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
		url: '../web.eprajax.query.medicalquerytask.cls?actionType=GetTaskDitails',
		fit:true,
		queryParams:girdParam,
		columns:[cols],
		onLoadSuccess: function(data)
		{
			if (data.total == "0") 
			{
				//如果没有数据，设置不可导出，关闭页面直接删除记录
				$('#exportAllData').linkbutton('disable');
				window.returnValue.dataLength = "0";
			}
		}
	});

	document.getElementById("exportAllData").onclick = function(){
		//导出数据
		exportAllData();
	}

	//查看任务结果明细时记录日志
	var ipAddress = getIpAddress();
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
				window.returnValue.status = GUID;
				location.href=d;
			}else
			{
				window.returnValue.status = "0";
			}
			closeWindow();
		},
		error : function(d) { 
			alert("导出EXCEL错误");
		}
	})
	
}

//获取客户端IP地址
function getIpAddress()
{
	try
	{
		var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
		var e = new Enumerator (properties);
		{
		    var p = e.item();
		    var ip = p.IPAddress(0);
		    return ip
		}
	}
	catch(err)
	{
		return "";
	}
}

function closeWindow()
{
	window.opener = null;
    window.open('', '_self');
    window.close();
}