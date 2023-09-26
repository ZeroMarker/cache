function BodyLoadHandler()
{
	var obj=document.getElementById("btnup");
    if (obj){obj.onclick=upcos;}
    var obj=document.getElementById("Clear");
    if (obj){obj.onclick=ClearData;}
    
}
function upcos()
{
	var obj=document.getElementById("arcimrow");
	if (obj) arcim=obj.value
	var obj=document.getElementById("toarcimrow");
    if (obj) toarcim=obj.value
    var obj=document.getElementById("upacosarcim");
	  if (obj) {var encmeth=obj.value} else {var encmeth=''};
	  //alert(arcim+","+toarcim)
	  var ret=cspRunServerMethod(encmeth,arcim,toarcim)
	  if (ret!=0){
		  alert("Ìæ»»Ê§°Ü:"+ret)
	  }
	  else{
		  alert("Ìæ»»³É¹¦")
	  }
}
function GetAppArcimId1(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("arcim");
	if (obj) obj.value=strValue[0];
	var obj=document.getElementById("arcimrow");
	if (obj) obj.value=strValue[1];
}
function GetAppArcimId2(str)
{
	var strValue=str.split("^");
	var obj=document.getElementById("toarcim");
	if (obj) obj.value=strValue[0];
	var obj=document.getElementById("toarcimrow");
	if (obj) obj.value=strValue[1];
}
function ClearData(){
	var obj=document.getElementById("arcim");
	if (obj) obj.value="";
	var obj=document.getElementById("arcimrow");
	if (obj) obj.value="";
	var obj=document.getElementById("toarcim");
	if (obj) obj.value="";
	var obj=document.getElementById("toarcimrow");
	if (obj) obj.value="";
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCArcositm";
}
document.body.onload = BodyLoadHandler;