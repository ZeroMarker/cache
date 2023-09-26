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
			$(content).append('<div id="'+data[i].Values[j].Code+'" onclick="select(this)">'+data[i].Values[j].Desc+'</div>');	
		}
		if (i == data.length-1)
		{
			addTab(data[i].Code,data[i].Desc,content,false,true);
		}
		else
		{
			addTab(data[i].Code,data[i].Desc,content,false,false);
		}
	}	
}

//增加tab标签
function addTab(id,title,content,closable,selected)
{
	$('#spechars').tabs('add',{ 
	    id:id, 
	    title:title,  
	    content:content,  
	    closable:closable,
		selected:selected
	});  
}

//选择特殊字符
function select(selectSpechar){
	var values = $("#selectValue").html();
	var thisValue = selectSpechar.id;
	values=values+thisValue;
	$("#selectValue").html(values);
}

$("#sure").click(function(){
	var returnValue = "{\"items\":["
	var specharsValue  =$("#selectValue").html();
	 if(specharsValue.indexOf("<sup>")>0)
	 {
		returnValue=returnValue+"{\"STYLE\":[\"DEFAULT\"],\"TEXT\":\""
		specharsValue= specharsValue.replace(/<sup>/g,"\"},{\"STYLE\":[\"SUPER\"],\"TEXT\":\"");
		specharsValue= specharsValue.replace(/<\/sup>/g,"\"},{\"STYLE\":[\"DEFAULT\"],\"TEXT\":\"");
		 returnValue=returnValue+specharsValue+"\"}]}"
		 }
	 else{
		 returnValue=returnValue+"{\"STYLE\":[\"DEFAULT\"],\"TEXT\":\""+specharsValue+"\"}]}"
		 }
	window.returnValue = returnValue;
	closeWindow();
});

$("#clear").click(function(){
	$("#selectValue").html("");
	selectValue = "";
});

$("#close").click(function(){
	closeWindow();
});

//关闭窗口
function closeWindow()
{
	//window.opener=null;
	//window.open('','_self');
	//window.close();		
	parent.closeDialog("dialogSpechars");
}