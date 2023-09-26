var Rowid
var currRow;

function BodyLoadHandler()
{
	var obj=document.getElementById("Update")
	if (obj) obj.onclick=Update;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=Exit;
	var obj=document.getElementById("add")
	if (obj) obj.onclick=Add;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=Delete;
}

function Update()
{ 
    var obj=document.getElementById("Rrowid"+"z"+currRow)
    if (obj) Rowid=obj.value;
  
		var obj=document.getElementById("appname")
		if (obj) appname=obj.value;
		var obj=document.getElementById("healthwebsite")
		if (obj) healthwebsite=obj.value;
		var obj=document.getElementById("serverip")
		if (obj) serverip=obj.value;
		var obj=document.getElementById("servername")
		if (obj) servername=obj.value;
		var obj=document.getElementById("serverport")
		if (obj) serverport=obj.value;
  
	var obj=document.getElementById("mUpdateRepServerConfig")
	if (obj) exe=obj.value;
    else exe=""
    if (Rowid=="") {alert("更新未取到ROWID");return;}
    var result=cspRunServerMethod(exe,Rowid,appname,healthwebsite,serverip,servername,serverport)
    // var locationD=window.location;
  	//alert(locationD);
	//window.location.reload();   //刷新
	//window.close();
	treload("")
}

function Add()
{ 
	var obj=document.getElementById("appname")
	if (obj) appname=obj.value;
	var obj=document.getElementById("healthwebsite")
	if (obj) healthwebsite=obj.value;
	var obj=document.getElementById("serverip")
	if (obj) serverip=obj.value;
	var obj=document.getElementById("servername")
	if (obj) servername=obj.value;
	var obj=document.getElementById("serverport")
	if (obj) serverport=obj.value;
  
	var obj=document.getElementById("mUpdateRepServerConfig")
	if (obj) exe=obj.value;
    else exe=""
    var result=cspRunServerMethod(exe,"",appname,healthwebsite,serverip,servername,serverport)
	//window.location.reload();   //刷新
	//window.close();
	treload("")
	//refreshwindow();
}
function Delete()
{
    var obj=document.getElementById("Rrowid"+"z"+currRow)
    
    if (obj) Rowid=obj.value;
	if (Rowid=="") {alert("未选中一行数据");return;}
	var obj=document.getElementById("mDeleteRepServerConfig")
	if (obj) exe=obj.value;
    else exe=""
    var result=cspRunServerMethod(exe,Rowid)
    //window.location.reload();
    treload("")
}
function SelectRowHandler()
{
	currRow=selectedRow(window)
	var objAppName=document.getElementById("AppName"+"z"+currRow)
	var objAN=document.getElementById("appname")
	if (objAN) objAN.value=objAppName.innerText;
	var objHealthWebSite=document.getElementById("HealthWebSite"+"z"+currRow)
	var objHT=document.getElementById("healthwebsite")
	if (objHT) objHT.value=objHealthWebSite.innerText;
	var objServerIP=document.getElementById("ServerIP"+"z"+currRow)
	var objSI=document.getElementById("serverip")
	if (objSI) objSI.value=objServerIP.innerText;
	var objServerName=document.getElementById("ServerName"+"z"+currRow)
	var objSN=document.getElementById("servername")
	if (objSN) objSN.value=objServerName.innerText;
	var objServerPort=document.getElementById("ServerPort"+"z"+currRow)
	var objSP=document.getElementById("serverport")
	if (objSP) objSP.value=objServerPort.innerText;

}
function refreshwindow(){
	window.location.reload();
}
function Exit()
{window.close();}
document.body.onload=BodyLoadHandler