function BodyLoadHandler() {
	var obj=document.getElementById("BSave");
	if (obj) obj.onclick=buttoncclick;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=buttoncclick;
	var obj=document.getElementById("BUpLoad");
	if (obj) obj.onclick=buttoncclick;
}

function SelectEDAfter(value){
	var aiList=value.split("^");
	if (""==value){return false;}
	obj=document.getElementById("EDDesc");
	if (obj) { obj.value=aiList[1]; }
}

function buttoncclick()
{
	alert("该功能暂不可用!")
	
}
document.body.onload = BodyLoadHandler;