$(function(){
    setData();
});

function getData()
{
	var result = {};
	var ClassName = $("#class").val();
	var MethodName = $("#method").val();
	
	var result = {"ClassName":ClassName,"MethodName":MethodName};
	return JSON.stringify(result);
}

function setData()
{
	if (url == "") return;
	var urlObj = JSON.parse(url);
	$("#class").val(urlObj.ClassName);
	$("#method").val(urlObj.MethodName);
	
}

function confirm()
{
 	var result = getData();
 	window.returnValue = result;
	closeWindow();
}

function cancel()
{
	window.returnValue = "";
	closeWindow();
}
//关闭窗口
function closeWindow()
{
	parent.closeDialog("AddURLDialog");
}