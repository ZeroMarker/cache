//DHCRisAppointmentLoc.js
//sunyi 2011-10-12

function BodyLoadHandler()
{

	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var ModiObj=document.getElementById("Update");
	if (ModiObj)
	{
		ModiObj.onclick=Updata_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}

}

function Add_click()
{
	 var OperateCode="I";
	 var Rowid="";
	 var LocName=document.getElementById("LocName").value;
	 
	 if(LocName=="")
	 {
		 var error="请选择关联科室!";
		 alert(error);
		 return ;
	 }
	 
	 var LocID=document.getElementById("LocID").value;
	 var AppDesc=document.getElementById("AppDesc").value;
	 var Location=document.getElementById("Location").value;
	 var TelNo=document.getElementById("TelNo").value;
	  
     if (document.getElementById("InValidate").checked)
     {
  	     var InValidate="Y";
     }
     else
     {
  	     var InValidate="N";
     }
     
	 var Info=Rowid+"^"+LocID+"^"+AppDesc+"^"+Location+"^"+TelNo+"^"+InValidate;
	 SetAppointmentLoc(Info,OperateCode);
}



function Updata_click()
{
	
	var SelRowid=document.getElementById("SelRowid").value;
	var OperateCode="U";
	
	if (SelRowid=="")
	{
		alert("未选择记录不能更新!")
		return;	
	}
	
	 
	 var LocID=document.getElementById("LocID").value;
	 var AppDesc=document.getElementById("AppDesc").value;
	 var Location=document.getElementById("Location").value;
	 var TelNo=document.getElementById("TelNo").value;
	 
	 if (document.getElementById("InValidate").checked)
     {
  	     var InValidate="Y";
     }
     else
     {
  	     var InValidate="N";
     }
     
	 var Info=SelRowid+"^"+LocID+"^"+AppDesc+"^"+Location+"^"+TelNo+"^"+InValidate;
	 SetAppointmentLoc(Info,OperateCode);
	
	
}

function Delete_click()
{
    var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	
	var str="^^^^^";
    var Info=SelRowid+str;
    SetAppointmentLoc(Info,OperateCode);
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisAppointmentLoc');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var LocID=document.getElementById("TLocIDz"+selectrow).value;
	var LocName=document.getElementById("TLocNmaez"+selectrow).innerText;
	var AppDesc=document.getElementById("TAppDescz"+selectrow).innerText;
	
	var Location=document.getElementById("TLocationz"+selectrow).innerText;
	var TelNo=document.getElementById("TTelNoz"+selectrow).innerText;
	var InValidate=document.getElementById("TInValidatez"+selectrow).innerText;
	
	/*Info=SelRowid+"^"+LocID+"^"+LocName+"^"+AppDesc+"^"+Location+"^"+TelNo+"^"+InValidate;
	alert(Info);*/
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var LocIDObj=document.getElementById("LocID");
	if (LocIDObj)
	{
		LocIDObj.value=LocID;
	}
	var LocNameObj=document.getElementById("LocName");
	if (LocNameObj)
	{
		LocNameObj.value=LocName;
	}

	var AppDescObj=document.getElementById("AppDesc");
	if (AppDescObj)
	{
		AppDescObj.value=AppDesc;
	}	
	
	var LocationObj=document.getElementById("Location");
	if (LocationObj)
	{
		LocationObj.value=Location;
	}	
	
	var TelNoObj=document.getElementById("TelNo");
	if (TelNoObj)
	{
		TelNoObj.value=TelNo;
	}	
	
	var InValidateObj=document.getElementById("InValidate");
	if (InValidateObj)
	{
		InValidateObj.value=InValidate;
		
		if (InValidateObj.value=="Y")
        {
  	       InValidateObj.checked=true;
  	    }
        else
        {
  	       InValidateObj.checked=false
        }
	}
		
}



function SetAppointmentLoc(Info,OperateCode)
{
	var SetAppointmentLocFun=document.getElementById("SetAppointmentLoc").value;
	var value=cspRunServerMethod(SetAppointmentLocFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 else
		 {
			var Info="删除失败:SQLCODE="+value;
	     }	 
		
	     alert(Info);
	}
	else
	{   
		/*var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppointmentLoc";
   		location.href=lnk;*/
   		window.location.reload(); 
	}
	
}

function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("LocName").value=Item[0];
  document.getElementById("LocID").value=Item[1]; 
}

document.body.onload = BodyLoadHandler;


