function BodyLoadHandler()
{	
	var obj
	
	obj=document.getElementById("Print");
	if (obj) {obj.onclick=Print_Click;}
		
	obj=document.getElementById("GBDesc");
	if (obj) { obj.onchange=GBDesc_Change; }
	
	
}

function AfterGroupSelected(value)
{
	if (value=="") return;
	var obj;
	obj=document.getElementById("GBID");
	if (obj) obj.value=value.split("^")[2];
}
function GBDesc_Change()
{
	var obj;
	obj=document.getElementById("GBID");
	if (obj) obj.value="";
	
	
}

document.body.onload = BodyLoadHandler;