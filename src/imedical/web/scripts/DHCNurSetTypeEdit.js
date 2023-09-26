function BodyLoadHandler()
{
    
	var obj=document.getElementById('add');
	if (obj) {obj.onclick=add_click;}
	var obj=document.getElementById('update');
	if (obj) {obj.onclick=update_click;}
	var obj=document.getElementById('del');
	if (obj) {obj.onclick=del_click;}
	//exedateobj.value=j;
}
function add_click() 
{//Add
  var mthadd=document.getElementById("mthadd").value;
  var code=document.getElementById("txtcode").value;
  var name=document.getElementById("txtname").value;
  var filename=document.getElementById("txtfilename").value;
  var byadm=document.getElementById("txtbyadm").value;
  var prnframe=document.getElementById("txtprnframe").value;
  var prechkdays=document.getElementById("txtprechkdays").value;
  var HospitalName=document.getElementById("txtHospitalName").value;
  var HospitalRowId=document.getElementById("HospitalRowId").value;
  if ((code=="")||(name=="")||((byadm!="Y")&&(byadm!="N"))||((prnframe!="Y")&&(prnframe!="N"))||((prechkdays!="")&&(prechkdays<0)))
  {//"代码和名称不能空!按病人和打印边框:填Y或N!默认天数为空或者大于零的数字!" 
  alert (t['alert:null/Y/N/num']);//code and name null?next two fill Y/N?last num>0
  return false;}
  if (HospitalName==""){HospitalRowId="0";}
  var res=cspRunServerMethod(mthadd,code,name+"^"+filename+"^"+byadm+"^"+prnframe+"^"+prechkdays,HospitalRowId)
     if (res==0)
    {//add ok
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}	  

  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetType";
  parent.frames["RPtop"].location.href=lnk; 

}
function update_click()
{//update
//	    resStr=#server(web.udhcclnurseexec.TypeUpdate(typeData[typeIndex][0],form1.txtCode.value,form1.txtDesc.value+"^"+form1.txtFilename.value+"^"+form1.txtPatOrder.value+"^"+form1.txtPrintFrame.value))#;
  var mthupdate=document.getElementById("mthupdate").value;
  var selrow=parent.frames["RPtop"].document.getElementById("selrow").value;
   //alert (selrow);
  if (selrow=="") return;
  var oldcode=parent.frames["RPtop"].document.getElementById("codez"+selrow).innerText;
  var oldHospitalRowId=parent.frames["RPtop"].document.getElementById("tHospitalRowIdz"+selrow).value;
  var code=document.getElementById("txtcode").value;
  var name=document.getElementById("txtname").value;
  var filename=document.getElementById("txtfilename").value;
  var byadm=document.getElementById("txtbyadm").value;
  var prnframe=document.getElementById("txtprnframe").value;
  var prechkdays=document.getElementById("txtprechkdays").value;
  var HospitalName=document.getElementById("txtHospitalName").value;
  var HospitalRowId=document.getElementById("HospitalRowId").value;
  if ((code=="")||(name=="")||((byadm!="Y")&&(byadm!="N"))||((prnframe!="Y")&&(prnframe!="N"))||((prechkdays!="")&&(prechkdays<0)))
  { alert (t['alert:null/Y/N/num']);
  return false;
  }
  if (HospitalName==""){HospitalRowId="0";}
  //alert(oldcode+"!"+code+"!"+name+"^"+filename+"^"+byadm+"^"+prnframe+"^"+prechkdays+"!"+oldHospitalRowId+"!"+HospitalRowId)
  var res=cspRunServerMethod(mthupdate,oldcode,code,name+"^"+filename+"^"+byadm+"^"+prnframe+"^"+prechkdays,oldHospitalRowId,HospitalRowId)
    if (res==0)
    {
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}

  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetType";
  parent.frames["RPtop"].location.href=lnk; 

}
function del_click() 
{ //delete
//	    resStr=#server(web.udhcclnurseexec.TypeDel(form1.txtCode.value))#;
    var mthdel=document.getElementById("mthdel").value;
    var code=document.getElementById("txtcode").value;
    var selrow=parent.frames["RPtop"].document.getElementById("selrow").value;
    if (selrow=="") return;
    var HospitalRowId=parent.frames["RPtop"].document.getElementById("tHospitalRowIdz"+selrow).value;
    var res=cspRunServerMethod(mthdel,code,HospitalRowId);
    if (res==0)
    {
	    alert(t['alert:success']);
	}
	else
	{
		alert(t['alert:error']);
	}
  var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSetType";
  parent.frames["RPtop"].location.href=lnk; 

}
function savecatdr(str)
{
	var obj=document.getElementById('catid');
	var tem=str.split("^");
	obj.value=tem[1];
	
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	
}
document.body.onload = BodyLoadHandler;
