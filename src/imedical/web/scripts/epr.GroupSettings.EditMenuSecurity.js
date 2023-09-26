//epr.GroupSettings.EditMenuSecurity
function outExp_click(){
	var groupDesc = document.getElementById("SSGRPDesc").innerText;
	var groupId = document.getElementById("GroupDR").value;
	var rtn = tkMakeServerCall("websys.Query","ToExcel","group("+groupDesc+")Menu","web.Util.Menu","SelectGroupMenu",groupId);
	location.href = rtn 
}
function bodyOnloadHandler() {
 	var prtobj=document.getElementById("ExportExcel");
  	if (prtobj){
     	 prtobj.onclick=outExp_click;	  
  	}
}
document.body.onload = bodyOnloadHandler;