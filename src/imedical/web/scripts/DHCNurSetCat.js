function BodyLoadHandler()
{
	var obj=document.getElementById('butexcut');
	if (obj) {obj.onclick=savecatdr_click;}
	//exedateobj.value=j;butexcut
}
function savecatdr_click()
{
    //alert(parent.frames[0].window.frames[0].window.frames[0].name);
    var selrow=parent.frames[0].window.frames[0].window.frames[0].document.getElementById("selrow").value;
    //alert(selrow);
    if (selrow=="") return;
    var code=parent.frames[0].window.frames[0].window.frames[0].document.getElementById("codez"+selrow).innerText;
	var HospitalRowId=parent.frames[0].window.frames[0].window.frames[0].document.getElementById("tHospitalRowIdz"+selrow).value;
	if ((HospitalRowId=="")||(HospitalRowId=="")) HospitalRowId=0;
	var obj=document.getElementById('treatstatus');
	var disposeStatStr=selitem(obj);
	var obj=document.getElementById('ordcat');
	var orcatStr=selitem(obj);
	var obj=document.getElementById('priority');
	var oecprStr=selitem(obj);
	var obj=document.getElementById('ordstatus');
	var ordStatStr=selitem(obj);
	var obj=document.getElementById('method');
	var phcinStr=selitem(obj);
	var obj=document.getElementById('specCode');
	var specCode="";
	if (obj) specCode=selitem(obj);
	var obj=document.getElementById('recLoc');
	var recLoc=""; 
	if (obj) recLoc=selitem(obj);
	var SetQueryPara=document.getElementById('SetQueryPara').value;
    var resStr=cspRunServerMethod(SetQueryPara,code,disposeStatStr,orcatStr,oecprStr,ordStatStr,phcinStr,specCode,recLoc,HospitalRowId)
    if (resStr!="0")
    {
	    alert(t['alert:error']);
    }
    else {  alert(t['alert:success']);
    }
}
function selitem(selbox)
{
      var tmpList=new Array();
        for ( var i=0;i<selbox.options.length;i++)
		{   
			if (selbox.options[i].selected)
			{   //alert(tmpList.length+" //"+tmpList)
			    tmpList[tmpList.length]=selbox.options[i].value
			}
		}
		if (tmpList[0]=="") tmpList=tmpList.slice(1)
		var Str=tmpList.join("^");
  return Str
}
document.body.onload = BodyLoadHandler;
