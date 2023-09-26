function GetCareProv(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("careProv")
	if(obj) obj.value=tem[0];
	var obj=document.getElementById("careProvDr")
	if(obj) obj.value=tem[1];
}
function GetRoom(str)
{
	var tem=str.split("^");
	var obj=document.getElementById("opRoom")
	if(obj) obj.value=tem[0];
	var obj=document.getElementById("roomId")
	if(obj) obj.value=tem[1];
}