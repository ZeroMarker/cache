$(function(){
	$("#userName").html(userName);
	getSuperior();
	initSuperior();
	
});

//加载上级医师
function initSuperior()
{
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSuperDoctor",
			"Method":"GetSuperiors",			
			"p1":userLoc
		},
		success: function(d){
			if (d == "") return;
			$('#superior').combobox({  
			    data:d,  
			    valueField:'userId',  
			    textField:'userName'  
			}); 
		},
		error: function(d){alert("error");}
	});
}

//加载上级医师
function getSuperior()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSuperDoctor",
			"Method":"GetCurrentSuperior",			
			"p1":userID,
			"p2":userLoc
		},
		success: function(d){
			if (d == "") return;
			$("#currentsuperior").html(d); 
		},
		error: function(d){alert("error");}
	});
}

$("#btsure").click(function(){
	var superiorId = $('#superior').combobox('getValue');
	if (superiorId == "") 
	{
		alert("请选择上级医师");
		return;
	}
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSuperDoctor",
			"Method":"SetSuperDoctor",			
			"p1":userID,
			"p2":superiorId,
			"p3":userLoc,
			"p4":ssgroupId
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