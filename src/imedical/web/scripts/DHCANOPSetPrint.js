function BodyLoadHandler()
{
	var obj=document.getElementById('add');
	if (obj) {obj.onclick=add_click;}
	var obj=document.getElementById('update');
	if (obj) {obj.onclick=update_click;}
	var obj=document.getElementById('del');
	if (obj) {obj.onclick=del_click;}
}
function add_click() 
{
  var mthadd=document.getElementById("mthadd").value;
  var code=document.getElementById("txtcode").value;
  var name=document.getElementById("txtname").value;
  var filename=document.getElementById("txtfilename").value;
  var txtOperStat=document.getElementById("txtOperStat").value
  var txtStatCode=document.getElementById("txtStatCode").value
  if ((code=="")||(name=="")||(filename==""))
  {
  	alert (t['alert:null']);
  	return false;
  }
  var res=cspRunServerMethod(mthadd,code,name+"^"+filename+"^"+txtOperStat+"^"+txtStatCode)
  if (res==0){
	    alert(t['alert:success']);
  }
  else
  {
		alert(t['alert:error']);
  }
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrint";
  window.location.href=lnk; 

}
function update_click()
{
  var mthupdate=document.getElementById("mthupdate").value;
  var selrow=document.getElementById("selrow").value;
  if (selrow=="") return;
  var oldcode=document.getElementById("codez"+selrow).innerText;
  var code=document.getElementById("txtcode").value;
  var name=document.getElementById("txtname").value;
  var filename=document.getElementById("txtfilename").value;
  var txtOperStat=document.getElementById("txtOperStat").value
  var txtStatCode=document.getElementById("txtStatCode").value
  if ((code=="")||(name=="")||(filename==""))
  {
  	alert (t['alert:null']);
  	return false;
  }
  var res=cspRunServerMethod(mthupdate,oldcode,code,name+"^"+filename+"^"+txtOperStat+"^"+txtStatCode)
  if (res==0)
  {
	alert(t['alert:success']);
  }
  else
  {
    alert(t['alert:error']);
  }
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrint";
  window.location.href=lnk; 

}
function del_click() 
{
    var mthdel=document.getElementById("mthdel").value;
    var code=document.getElementById("txtcode").value;
    var selrow=document.getElementById("selrow").value;
    if (selrow=="") return;
    var res=cspRunServerMethod(mthdel,code);
    if (res==0)
    {
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrint";
  window.location.href=lnk; 
}
 function SelectRowHandler()
 {
    var selrow=document.getElementById("selrow");
    selrow.value=DHCWeb_GetRowIdx(window);
    var code=document.getElementById("codez"+selrow.value).innerText;
    var name=document.getElementById("namez"+selrow.value).innerText;
    var filename=document.getElementById("filenamez"+selrow.value).innerText;
    var operStat=document.getElementById("operStatz"+selrow.value).innerText;
    var statCode=document.getElementById("statCodez"+selrow.value).value;

    var txtcode=document.getElementById("txtcode");
    var txtname=document.getElementById("txtname");
    var txtfilename=document.getElementById("txtfilename");
    var txtOperStat=document.getElementById("txtOperStat");
    var txtStatCode=document.getElementById("txtStatCode");

    txtcode.value=code;
    txtname.value=name;
    txtfilename.value=filename;
    txtOperStat.value=operStat;
    txtStatCode.value=statCode;
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPSetPrintList&queryTypeCode="+code;
    parent.frames[1].location.href=lnk; 

 }
 
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
function SaveOperStat(str)
{
	var operStat=str.split("^");
	var obj=document.getElementById("txtOperStat")
	if (obj) obj.value=operStat[0];
	var obj=document.getElementById("txtStatCode")
	if (obj) obj.value=operStat[1];	
}
document.body.onload = BodyLoadHandler;
