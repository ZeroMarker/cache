var CONST_HOSPID=""; 

function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	CONST_HOSPID=getHospID();
	//location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurAccess&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}
function BodyLoadHandler()
{
    
	setWay = document.getElementById("SetWay");
    if(setWay)
    {
		setWay=dhtmlXComboFromSelect("SetWay","ByAccess$c(2)安全组$c(1)ByLoc$c(2)科室");
		// setWay.setComboValue("ByAccess");
		setWay.selectHandle=function(){
			var selectedValue = setWay.getActualValue();
			document.getElementById("cdesc").innerText=setWay.getSelectedText();
			//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurAccess&SetWay="+setWay.getSelectedText();
			//windows.href=lnk
		}
    } 
	//exedateobj.value=j;
}

 function SelectRowHandler()
 {
    var selrow=document.getElementById("selrow");
    var resList=new Array();
    selrow.value=DHCWeb_GetRowIdx(window);
    var objtbl=document.getElementById('tDHCNUROPEXEC');
	var SSGRPID=document.getElementById("SSGRPIDz"+selrow.value).innerText;
	var setWay=document.getElementById("SetWayz"+selrow.value).value;
	var hospitalName=document.getElementById('HospitalName').value;
	var hospitalRowId=document.getElementById('HospitalRowId').value;
    var lnk;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurAccessDetail&ssgrp="+SSGRPID+"&setWay="+setWay+"&HospitalRowId="+hospitalRowId+"&HospitalName="+hospitalName;
    
    parent.frames[1].location.href=lnk; 
    //parent.frames[1].location.reload();
   

    
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
document.body.onload = BodyLoadHandler;
