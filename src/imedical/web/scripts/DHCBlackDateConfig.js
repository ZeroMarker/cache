document.body.onload=ListDocCurrentLoadHandler;
function ListDocCurrentLoadHandler()
{
	var obj=document.getElementById("Update");
	if(obj) obj.onclick=updateHandler;
	var ConfigArr=tkMakeServerCall("web.InExportApp","GetBlackConfig")
	if(ConfigArr!=""){
	var Config=ConfigArr.split("^")
	  document.getElementById("Date").value=Config[0]
	  document.getElementById("SYCount").value=Config[1]
	  document.getElementById("SYDate").value=Config[2]
	}else{
		document.getElementById("Date").value=""
	  document.getElementById("SYCount").value=""
	  document.getElementById("SYDate").value=""
	}
}
function updateHandler()
{
	var Date=document.getElementById("Date").value
	var Count=document.getElementById("SYCount").value
	var SYDate=document.getElementById("SYDate").value
	var obj=document.getElementById('UpdateConfig');
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	var Stat=cspRunServerMethod(encmeth,Date,Count,SYDate);
	if(Stat=='0'){
		alert("更新成功")
	}
}