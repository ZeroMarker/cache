
var CurrentSel=0
function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}    
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	var CreateTypeObj=document.getElementById("CreateType");
	if (CreateTypeObj)
		CreateTypeObj.onclick=SetCreateType_click;
	var GetCreateTypefunction=document.getElementById("GetCreateType").value;
	var value=cspRunServerMethod(GetCreateTypefunction);
	if (value=="1")
	  CreateTypeObj.checked=true;
	else
	  CreateTypeObj.checked=false;
	  
			
	
}
function SetCreateType_click()
{
	var IsAuto=0;
	var CreateTypeObj=document.getElementById("CreateType");
	if (CreateTypeObj.checked==true)
	{
		 IsAuto=1;
	}
	var CreateType=document.getElementById("SetStudyNo").value;
	var ret=cspRunServerMethod(CreateType,IsAuto);
	if (ret==0)
	  alert(t['SetSuccess']);
	else
	  alert(t['SetFaiure']);
	
}
function Add_click()
{
	var LocName=document.getElementById("LocName");
	var EQGroup=document.getElementById("EQGroup");
	var Prefix=document.getElementById("Prefix");
	var maxnumber=document.getElementById("MaxNumber");
	var CreateType=document.getElementById("CreateType");
	if (maxnumber.value=="")
	{
		 maxnumber.value="0";
	}
	
	if (EQGroup.value=="") EQGroup.text="";
    if (LocName.value=="") LocName.text="";

	if ((LocName.text=="")&&(EQGroup.text==""))
	{
		alert(t['Select']);
		return;
	}
	var IsAuto=CreateType.value;
	var info=LocName.text+"^"+EQGroup.text+"^"+Prefix.value+"^"+maxnumber.value;
	var InsertInfo=document.getElementById("addfunction").value;
	var Acessioninfo=cspRunServerMethod(InsertInfo,info);
	
	
	
	
}
function Delete_click()
{
	rowid =document.getElementById("strrowid").value;
	if (rowid=="")
	{
		alert(t['selectsettype']);
		return;
	}
	var deletefunction=document.getElementById("deletefunction").value;
	alert(deletefunction);
	var ret=cspRunServerMethod(deletefunction,rowid);
	if (ret==0)
	  alert(t['DeleteSuccess']);
	else
	  alert(t['DeleteFaiure']);
}


function Modi_click()
{
	var strrowid=document.getElementById("strrowid");
	var LocName=document.getElementById("LocName");
	var EQGroup=document.getElementById("EQGroup");
	var Prefix=document.getElementById("Prefix");
	var maxnumber=document.getElementById("MaxNumber");
	var CreateType=document.getElementById("CreateType");
	if (strrowid.value=="")
	{
		alert(t['SelectCodeSet']);
		return; 
	}
	if (maxnumber.value=="")
	{
		 maxnumber.value="0";
	}

	if (EQGroup.value=="") EQGroup.text="";
    if (LocName.value=="") LocName.text="";

	if ((LocName.text=="")&&(EQGroup.text==""))
	{
		alert(t['Select']);
		return;
	}
	var IsAuto=CreateType.value;
	var info=LocName.text+"^"+EQGroup.text+"^"+Prefix.value+"^"+maxnumber.value+"^"+strrowid.value;
	alert(info);
	var modifunction=document.getElementById("modifunction").value;
	var ret=cspRunServerMethod(modifunction,info);
	if (ret==0)
	{
		alert(t['ModSetSuccess']);
	}
	else
	{
		alert(t['ModiFailure']);
	}
}

function AddLocInfo(Info)
{
	var tem=Info.split("^");
	var locname=document.getElementById('LocName'); 
	locname.text=tem[1];
	locname.value=tem[0];
	
}
function AddEQGroupInfo(Info)
{
	var tem=Info.split("^");
	var EQGroup=document.getElementById('EQGroup');
	EQGroup.text=tem[1];
	EQGroup.value=tem[0];
	
}

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisStudyNoSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
     
    var locDR=document.getElementById("TLocDrz"+selectrow).innerText;
    var locName=document.getElementById("TLocNamez"+selectrow).innerText;
  	var EQGroupDR=document.getElementById("TEQGroupDRz"+selectrow).innerText;
    var EQGroupDesc=document.getElementById("TEQGroupz"+selectrow).innerText;
    var Prefix=document.getElementById("TPrefixz"+selectrow).innerText;
    var TMaxNumber=document.getElementById("TMaxNumberz"+selectrow).innerText;
    var Trowid=document.getElementById("TRowidz"+selectrow).innerText;
    
    //var LocDrObj=document.getElementById("LocDR");
    var locNameObj=document.getElementById("LocName");
    //var EQGroupDRObj=document.getElementById("EQGroupDR");  
    var EQGroupObj=document.getElementById("EQGroup");
    var PrexfixObj=document.getElementById("Prefix");
    var MaxNumberObj=document.getElementById("MaxNumber");
    var strrowidObj=document.getElementById("strrowid");
    
    strrowidObj.value=Trowid;
    locNameObj.text=locDR;
    locNameObj.value=locName;
    EQGroupObj.text=EQGroupDR;
    EQGroupObj.value=EQGroupDesc;
    PrexfixObj.value=Prefix;
    MaxNumberObj.value=TMaxNumber;

}

document.body.onload = BodyLoadHandler;