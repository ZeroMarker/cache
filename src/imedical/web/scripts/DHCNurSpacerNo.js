
function BodyLoadHandler()
{
	var Placerobj=document.getElementById("CurPlacerNo");
	if (Placerobj) {Placerobj.onkeydown=PlacerNo_blur;}
	//if (Placerobj) {Placerobj.onblur=PlacerNo_blur;}
	obj=document.getElementById("BtUpdate");
	if (obj){obj.onclick=BtUpdateHandler;}
	websys_setfocus('CurPlacerNo');
}
function BtUpdateHandler() {
	return BtUpdate_Click();
}
function PlacerNo_blur()

{
	if (event.keyCode==13){
		BtUpdate_Click();
  	}
} 
function DHCC_GetElementData(ElementName){
  var obj=document.getElementById(ElementName);
  if (obj){
    if (obj.tagName=='LABEL'){
      return obj.innerText;
    }else{
      if (obj.type=='checkbox') return obj.checked;
      return obj.value;
    }
  }
  return "";
}
function DHCC_SetElementData(ElementName,value){
  var obj=document.getElementById(ElementName);
  if (obj){
    obj.value=value;
  }
  return "";
}
function BtUpdate_Click2()
{
	var UserIdVal=DHCC_GetElementData("UserId");
	var CurPlacerNoVal=DHCC_GetElementData("CurPlacerNo");
	var BtUpdateGatherTimeObj=DHCC_GetElementData("BtUpdateGatherTime");
	
	if((CurPlacerNoVal!="")&(UserIdVal!=""))
	{
		if(BtUpdateGatherTimeObj)
		{
			var RetStr=cspRunServerMethod(BtUpdateGatherTimeObj,CurPlacerNoVal,UserIdVal);
			if(RetStr=="0")
			{
			    alert(t['alert:success'])
			}
			else
			{
				alert(RetStr+t['alert:false'])
			}
		}
	}
	else
	{
		alert("请扫条码或者手动输入条码号!")
	}
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSpacerNo&PlacerNo="+CurPlacerNoVal
	window.location.href=lnk;
	//self.location.reload() 
}
function BtUpdate_Click()
{
	var OrdStr=""
	var UserIdVal=DHCC_GetElementData("UserId");
	var GetOrdStrObj=DHCC_GetElementData("GetOrdStr");
	var CurPlacerNoVal=DHCC_GetElementData("CurPlacerNo");
	var BtUpdatePlacerObj=DHCC_GetElementData("BtUpdatePlacer");
	if(GetOrdStrObj)
	{
		if(CurPlacerNoVal!="")
		{
			var OrdStr=cspRunServerMethod(GetOrdStrObj,CurPlacerNoVal);
		}
	}
	if((OrdStr!="")&(UserIdVal!=""))
	{
		if(BtUpdatePlacerObj)
		{
			var RetStr=cspRunServerMethod(BtUpdatePlacerObj,OrdStr,UserIdVal);
			if(RetStr=="0")
			{
				alert(t['alert:success'])
			}
			else
			{
				alert(RetStr+t['alert:false'])
			}
		}
	}
	else
	{
		alert(t['alert:NoOrder'])
	}
	//alert(UserIdVal.value)
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSpacerNo&PlacerNo="+CurPlacerNoVal
	window.location.href=lnk;
	//self.location.reload() 
}
document.body.onload = BodyLoadHandler;	