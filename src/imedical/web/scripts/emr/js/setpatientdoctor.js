$(function(){
	getDoctor();
	initPatientDoctor();
});

function getDoctor()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPatientDoctor",
			"Method":"GetDoctors",
			"p1":userLoc
		},
		success: function(d) {
			if (d != "")
			{
				var data = eval(d);
				setDoctor("practice",data);
				setDoctor("resident",data);
				setDoctor("attending",data);
				setDoctor("chief",data);
			}
			else
			{
				alert("请维护医师级别范围");
			}
		},
		error : function(d) { 
			alert("initDoctorInfo error");
		}
	});	
}

function setDoctor(ctrName,data)
{
	$("#"+ctrName).combobox({  		
	    valueField:'userId',  
	    textField:'userName',
	    data:data
	});
}

function initPatientDoctor()
{
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPatientDoctor",
			"Method":"GetCurrentPatientDoctor",			
			"p1":episodeID
		},
		success: function(d){
			if (d == null) return;
			$('#practice').combobox('setValue', d[0].practiceId);
			$('#resident').combobox('setValue', d[0].residentId);
			$('#attending').combobox('setValue', d[0].attendingId);
			$('#chief').combobox('setValue', d[0].chiefId);
		},
		error: function(d){alert("error");}
	});
}

$("#btsure").click(function(){
	var practiceId = "";
	var residentId = "";
	var attendingId = "";
	var chiefId = "";
	if ($('#practice').combobox('getText') != "")
	{
		practiceId = $('#practice').combobox('getValue');
	}
	if ($('#resident').combobox('getText') != "")
	{
		residentId = $('#resident').combobox('getValue');
	}
	if ($('#attending').combobox('getText') != "")
	{
		attendingId = $('#attending').combobox('getValue');
	}
	if ($('#chief').combobox('getText') != "")
	{
		chiefId = $('#chief').combobox('getValue');
	}
	if ((practiceId == "")&&(residentId == "")&&(attendingId == "")&&(chiefId == ""))
	{
		alert("请设置患者医师");
		return;
	}
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPatientDoctor",
			"Method":"SetPatientDoctor",
			"p1":episodeID,		
			"p2":userID,
			"p3":userLoc,
			"p4":practiceId,
			"p5":residentId,
			"p6":attendingId,
			"p7":chiefId
		},
		success: function(d){

			if (d == "1")
			{
				alert("保存成功");
				CloseWindow();
			}
			else
			{
				alert("保存失败");
			}
			 
		},
		error: function(d){alert("error");}
	});
});


$("#btclose").click(function(){
	CloseWindow();
});

//关闭窗口
function CloseWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}