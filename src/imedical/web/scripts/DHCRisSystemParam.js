//DHCRisSystemParam.js
//2012-03-11 sunyi

function BodyLoadHandler()
{
    
    LoadSystemParam();
    
	var ModiObj=document.getElementById("Save");
	if (ModiObj)
	{
		ModiObj.onclick=Save_click;
	}
	

}


function LoadSystemParam()
{
	var GetSystemParamFun=document.getElementById("GetSystemParamFun").value;
	var value=cspRunServerMethod(GetSystemParamFun);
	if (value!="")
	{
		Item=value.split("^");
		
		if (Item[0]=="Y")  
		{
			document.getElementById("MoreReport").checked=true;
		}
		if (Item[1]=="Y")  
		{
			document.getElementById("MoreItem").checked=true;
		}
		if (Item[2]=="Y")
		{  
		   document.getElementById("SendApptoLoc").checked=true;
		}
		
		if (Item[3]=="Y")
		{  
		    document.getElementById("SendInPItoLoc").checked=true;
		}
		
		if (Item[4]=="Y")
		{  
		    document.getElementById("SendOutPItoLoc").checked=true;
		}
		
		if (Item[5]=="Y")
		{  
		    document.getElementById("SendEmergItoLoc").checked=true;
		}
		if (Item[6]=="Y")
		{  
		   document.getElementById("AppointmentConflict").checked=true;
		}
	
		document.getElementById("AppointmentInterval").Value=Item[7];
		
		if (Item[8]=="Y")
		{ 
		   document.getElementById("OnlyQueryExamItm").checked=true; 
		}
		
		if (Item[9]=="Y")
		{  
		   document.getElementById("SendHPtoLoc").checked=true;
		}
		if (Item[10]=="Y")
		{
		   document.getElementById("AllowOPRegNotPaid").checked=true;	  
		}
		
		if (Item[11]=="Y")
		{  
		   document.getElementById("AllowIPRegNotPaid").checked=true;
		}
		
		if (Item[12]=="Y")
		{  
		   document.getElementById("AllowHPRegNotPaid").checked=true;
		}
		
		if (Item[13]=="Y")
		{  
		   document.getElementById("AllowEMRegNotPaid").checked=true;
		}
		
		document.getElementById("Version").value=Item[14];
		document.getElementById("FileVersion").value=Item[15];
		document.getElementById("FilePath").value=Item[16];
		if (Item[17]=="1")
		{
			document.getElementById("SendMutiOrdItem").checked=false;
			
		}
		else
		{
			document.getElementById("SendMutiOrdItem").checked=true;
			
		}
		/*
		if (Item[18]=="Y")
		{
			document.getElementById("UseKnowledge").checked=true;
			
		}
		else
		{
			document.getElementById("UseKnowledge").checked=false;
			
		}
		*/
	}
	
}


function Save_click()
{
	
	 var OperateCode="U"
	 
	 var ConFlag=confirm('您确定保存配置信息?');
     if (ConFlag==false)
     {
	    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisSystemParam";
   		location.href=lnk;
   		return;
	 }
     
	 var GetData=SetSystemParam();
	 Info=""+"^"+GetData
	 SystemParamFun(Info,OperateCode);
	
}


function SetSystemParam()
{
	if(document.getElementById("MoreReport").checked)
	{
	   MoreReport="Y";	
	}
	else
	{
	   MoreReport="N";	
	}
	
	if(document.getElementById("MoreItem").checked)
	{
	   MoreItem="Y";
	}
	else
	{
	   MoreItem="N";	
	}
	
	if(document.getElementById("SendApptoLoc").checked)
	{
	  SendApptoLoc="Y";	
	}
	else
	{
	  SendApptoLoc="N"	
	}
	
	if(document.getElementById("SendInPItoLoc").checked)
	{
		SendInPItoLoc="Y";
	}
	else
	{
		SendInPItoLoc="N";
	}
	
	/////////////////////////////////////////////////////////////
	
	if (document.getElementById("SendOutPItoLoc").checked)
	{  
		SendOutPItoLoc="Y";
	}
	else
	{
		SendOutPItoLoc="N";
	}
		
	if (document.getElementById("SendEmergItoLoc").checked)
	{  
		SendEmergItoLoc="Y";
	}
	else
	{
		SendEmergItoLoc="N";
	}
		
	if (document.getElementById("AppointmentConflict").checked)
	{  
		AppointmentConflict="Y";
	}
	else
	{
		AppointmentConflict="N";
	}
	
	var AppointmentInterval=document.getElementById("AppointmentInterval").Value
		
	if (document.getElementById("OnlyQueryExamItm").checked)
	{ 
		OnlyQueryExamItm="Y"; 
	}
	else
	{
		OnlyQueryExamItm="N";
	}
		
	if (document.getElementById("SendHPtoLoc").checked)
	{  
		SendHPtoLoc="Y";
	}
	else
	{
		SendHPtoLoc="N";
	}
	if (document.getElementById("AllowOPRegNotPaid").checked)
	{
		AllowOPRegNotPaid="Y";	  
	}
	else
	{
		AllowOPRegNotPaid="N";
	}
		
	if (document.getElementById("AllowIPRegNotPaid").checked)
	{  
		AllowIPRegNotPaid="Y";
	}
	else
	{
		AllowIPRegNotPaid="N";
	}
		
	if (document.getElementById("AllowHPRegNotPaid").checked)
	{  
		AllowHPRegNotPaid="Y";
	}
	else
	{
		AllowHPRegNotPaid="N";
	}
		
	if (document.getElementById("AllowEMRegNotPaid").checked)
	{  
		AllowEMRegNotPaid="Y";
	}
	else
	{
		AllowEMRegNotPaid="N";
	}
		
	var Version=document.getElementById("Version").value;
	var	FileVersion=document.getElementById("FileVersion").value;
	var	FilePath=document.getElementById("FilePath").value;
	
	if (document.getElementById("SendMutiOrdItem").checked)
	{
		sendMutiOrd="2";
	}
	else
	{
		sendMutiOrd="1";
	}
	/*
	if (document.getElementById("UseKnowledge").checked)
	{
		UseKnowledge="Y";
	}else
	{
		UseKnowledge="N";
    }
	*/   
	var Info=MoreItem+"^"+MoreReport+"^"+SendOutPItoLoc+"^"+SendEmergItoLoc+"^"+SendInPItoLoc+"^"+SendApptoLoc+"^"+SendHPtoLoc;
	    Info=Info+"^"+AppointmentConflict+"^"+AppointmentInterval+"^"+OnlyQueryExamItm+"^"+AllowOPRegNotPaid+"^"+AllowIPRegNotPaid+"^"+AllowHPRegNotPaid+"^"+AllowEMRegNotPaid+"^"+Version+"^"+FileVersion+"^"+FilePath+"^"+sendMutiOrd+"^"; //  +UseKnowledge;   
	return Info    
}


function SystemParamFun(Info,OperateCode)
{
	var SystemParamFun=document.getElementById("SystemParamFun").value;
	var value=cspRunServerMethod(SystemParamFun,Info,OperateCode);
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
	    alert("保存成功!");
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisSystemParam";
   		location.href=lnk; 
	}
	
}

document.body.onload = BodyLoadHandler;