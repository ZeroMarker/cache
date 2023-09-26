
function BodyLoadHandler()
{
	var obj=document.getElementById("Close")
	if (obj) obj.onclick=closewin;
	var obj=document.getElementById("Close2")
	if (obj) obj.onclick=closewin;
}
function closewin()
{
	window.close() ;}

document.body.onload=BodyLoadHandler;