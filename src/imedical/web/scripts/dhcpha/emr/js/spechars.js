$(function(){
	window.returnValue = "";
	getSpechars();	
});


//获取特殊字符
function getSpechars()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.spechars.cls",
		async: true,
		success: function(d) {
			setSpechars(eval(d))	
		},
		error : function(d) { alert(" error");}
	});
}

//初始化特殊字符
function setSpechars(data)
{
	for (var i=0;i<data.length;i++)
	{
		var content = $('<div class="content"></div>');
		for (var j=0;j<data[i].Values.length;j++)
		{
			$(content).append('<div id="'+data[i].Values[j].Code+'">'+data[i].Values[j].Desc+'</div>');	
		}
		addTab(data[i].Code,data[i].Desc,content);
	}	
}

//增加tab标签
function addTab(id,title,content)
{
	$('#spechars').tabs('add',{ 
	    id:id, 
	    title:title,  
	    content:content,  
	    closable:false 
	});  
}

//选择特殊字符
$(".content div").live("click",function(){
	var values = $("#selectValue").val();
	values = values + $(this).text();
	var thisValue = $(this)[0].id;
	if (thisValue.indexOf("<SUP>") > 0)
	{
		if (thisValue.substring(0,thisValue.indexOf("<SUP>"))!="" )
		{
			selectValue = selectValue + "^" + thisValue.substring(0,thisValue.indexOf("<SUP>")) + "#DEFAULT";
		}
		if (thisValue.substring(thisValue.indexOf("<SUP>")+5,thisValue.indexOf("</SUP>"))!="" )
		{
			selectValue = selectValue + "^" + thisValue.substring(thisValue.indexOf("<SUP>")+5,thisValue.indexOf("</SUP>")) + "#SUPER";
		}
		if (thisValue.substring(thisValue.indexOf("</SUP>")+6)!="" )
		{
			selectValue = selectValue + "^" + thisValue.substring(thisValue.indexOf("</SUP>")+6) + "#DEFAULT";
		}
	}
	else
	{
		selectValue = selectValue + "^" + thisValue + "#DEFAULT";
	}
	$("#selectValue").val(values);
});

$("#sure").click(function(){
	var returnValue = ""
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLSpechars",
					"Method":"GetSpecharsStyleTextJson",			
					"p1":selectValue
				},
			success : function(d) {
	           if ( d != "") 
			   {
					returnValue = d ;
			   }
			},
			error : function(d) { alert("delete getSpecharsStyleTextJson error");}
		});	
	window.returnValue = returnValue;
	closeWindow();
});

$("#clear").click(function(){
	$("#selectValue").val("");
});

$("#close").click(function(){
	closeWindow();
});

//关闭窗口
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}