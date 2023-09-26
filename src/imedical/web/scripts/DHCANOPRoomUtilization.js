//DHCANOPRoomUtilization.JS
function BodyLoadHandler()
{
	var stdate=document.getElementById("stdate");
    var enddate=document.getElementById("enddate");
    var today=document.getElementById("getToday").value;
    if (stdate.value=="") {stdate.value=today;}
    if (enddate.value=="") {enddate.value=today;}
    var objOPRCTLoc=document.getElementById("OPRCTLoc");
	var objOPRCTLocId=document.getElementById("OPRCTLocId");
	if (objOPRCTLoc.value=="") objOPRCTLocId.value="";
}
function GetOPRCTLoc(str)
{
	var Str=str.split("^");
	var obj=document.getElementById("OPRCTLocId")
	if (obj) obj.value=Str[0];
	var obj=document.getElementById("OPRCTLoc")
	if (obj) obj.value=Str[1];
}
document.body.onload = BodyLoadHandler;