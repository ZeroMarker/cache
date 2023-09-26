﻿var totalHeight = 390;
var openStatus = "both";
$(function(){
	totalHeight = window.parent.$("#templateCategory").layout("panel","center").panel('options').height-19;
});﻿

window.onresize = function(){
    if (totalHeight != (window.parent.$("#templateCategory").layout("panel","center").panel('options').height-19))
    {
    	totalHeight = window.parent.$("#templateCategory").layout("panel","center").panel('options').height-19;
    	if (openStatus == "both")
    	{
    		document.getElementById("createCord").style.height = totalHeight/2;
    		document.getElementById("templateCord").style.height = totalHeight/2;
    	}
    	else if(openStatus == "createCord")
    	{
	    	document.getElementById("createCord").style.height = totalHeight;
    	}
    	else if(openStatus == "templateCord")
    	{
	    	document.getElementById("templateCord").style.height = totalHeight;
    	}
    }
}

function hideCreateCord()
{
	$("#createCord").hide();
	$('#middlesecond').css('display','none');
	$('#middlefirst').css('display','block');
	document.getElementById("templateCord").style.height = totalHeight;
	openStatus = "templateCord";
}

function hideTemplateCord()
{
	$("#templateCord").hide();
	$('#middlesecond').css('display','none');
	$('#middlethird').css('display','block');
	document.getElementById("createCord").style.height = totalHeight;
	openStatus = "createCord";
}

function firstShowBoth()
{
	document.getElementById("createCord").style.height = totalHeight/2;
    document.getElementById("templateCord").style.height = totalHeight/2;
	$("#createCord").show();
	$('#middlefirst').css('display','none');
	$('#middlesecond').css('display','block');
	openStatus = "both";
}

function firstShowOnlyCreate()
{
	document.getElementById("createCord").style.height = totalHeight;
	$("#createCord").show();
	$("#templateCord").hide();
	$('#middlefirst').css('display','none');
	$('#middlethird').css('display','block');
	openStatus = "createCord";
}

function thirdShowBoth()
{
	document.getElementById("createCord").style.height = totalHeight/2;
    document.getElementById("templateCord").style.height = totalHeight/2;
	$("#templateCord").show();
	$('#middlethird').css('display','none');
	$('#middlesecond').css('display','block');
	openStatus = "both";
}

function thirdShowOnlyTemplate()
{
	document.getElementById("templateCord").style.height = totalHeight;
	$("#templateCord").show();
	$("#createCord").hide();
	$('#middlethird').css('display','none');
	$('#middlefirst').css('display','block');
	openStatus = "templateCord";
}

function showOnlyCreate()
{
	document.getElementById("createCord").style.height = totalHeight;
	$("#createCord").show();
	$("#templateCord").hide();
	$('#middlefirst').css('display','none');
	$('#middlesecond').css('display','none');
	$('#middlethird').css('display','block');
	openStatus = "createCord";
}

function showOnlyTemplate()
{
	document.getElementById("templateCord").style.height = totalHeight;
	$("#templateCord").show();
	$("#createCord").hide();
	$('#middlesecond').css('display','none');
	$('#middlethird').css('display','none');
	$('#middlefirst').css('display','block');
	openStatus = "templateCord";
}

function showBoth()
{
	document.getElementById("createCord").style.height = totalHeight/2;
    document.getElementById("templateCord").style.height = totalHeight/2;
	$("#createCord").show();
	$("#templateCord").show();
	$('#middlefirst').css('display','none');
	$('#middlethird').css('display','none');
	$('#middlesecond').css('display','block');
	openStatus = "both";
}

function resizeClassifWindow()
{
	totalHeight = window.parent.$("#templateCategory").layout("panel","center").panel('options').height-19;
    if ((templateLength > 0)&&(recordLength == 0))
    {
	     showOnlyCreate();
    }
    else if((templateLength == 0)&&(recordLength > 0))
    {
	    showOnlyTemplate();
    }
    else
    {
	    showBoth();
    }
}