var placeNo="";
var oeordId="";
var sub="";
function BodyLoadHandler()
{
	//alert(1)
	var needflag=document.getElementById("oeordId").value;
	var str=needflag.split("^");
	if(str.length==2)
	{
      oeordId=str[1];
      sub=str[0];
	}

	var cnotes=document.getElementById("cnotes");
	if(sub==1)
	{
		cnotes.innerText="尿量";
		
	}
	if(sub==2)
	{
		cnotes.innerText="体温";
	}
	placeNo=document.getElementById("PlacerNo").value;

	//alert(oeordId+"oeordId"+placeNo)
	var button=document.getElementById("addbutton");
	var noteobj=document.getElementById("notes")
	if(noteobj){noteobj.onkeydown=onkeydown;}
	if(button)
	{
		button.onclick=ok_click;
	}
}
function onkeydown()
{
	if (event.keyCode==13)
	{
		ok_click();
  }
}
function ok_click()
{
	var notes=document.getElementById("notes").value;
	var ordnote=document.getElementById("OrdNote").value;
	if(sub==1)
	{
		if(notes=="")
		{
		  alert("尿量值不能为空!");
		  return;
		}
		else
		{
			var InfFlag=isIntValue(notes,1)
			if(InfFlag!=1)
			{
				alert(InfFlag)
				return;
			}
		}
	}
	if(sub==2)
	{
		if(notes=="")
		{
		  alert("体温值不能为空!");
		  return;
		}
		else
		{
			var InfFlag=isIntValue(notes,2)
			if(InfFlag!=1)
			{
				alert(InfFlag)
				return;
			}
		}
	}
	var OrdStr=cspRunServerMethod(ordnote,placeNo,notes,sub);
 
	BtUpdate_Click();
}
function BtUpdate_Click()
{
	//alert(1)
	var OrdStr=""
	var UserIdVal=session['LOGON.USERID'];
	var GetOrdStrObj=document.getElementById("GetOrdStr").value;
	var CurPlacerNoValTmp=document.getElementById("PlacerNo").value;
	var BtUpdatePlacerObj=document.getElementById("BtUpdatePlacer").value;
	if(GetOrdStrObj)
	{
		if(CurPlacerNoValTmp!="")
		{
			var OrdStr=cspRunServerMethod(GetOrdStrObj,CurPlacerNoValTmp);
		}
	}
	if((OrdStr!="")&(UserIdVal!=""))
	{
		if(BtUpdatePlacerObj)
		{
			var RetStr=cspRunServerMethod(BtUpdatePlacerObj,OrdStr,UserIdVal);
			if(RetStr=="0")
			{
			//	alert(t['alert:success'])
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
	 
	self.close();
    
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSpacerNo&PlacerNo="+CurPlacerNoValTmp
	opener.parent.location.href=lnk;
	//opener.parent.location.reload();
	


}
function isIntValue(valuestr,flag)
{
	if(isNaN(valuestr))
	{
		if((valuestr!="")&&(valuestr.split(".").length>2))
		{
			if(flag==1) return "尿量格式不对?包含多个点!"	
			if(flag==2) return "体温格式不对?包含多个点!"
		}
		else
		{
			return "请输入数字!"
		}
	}
	else
	{
		if(flag==2) 
		{
		   if((valuestr!="")&&((valuestr<35)||(valuestr>42)))
		  {
			return "体温应在35--42之间"
		  } 
		  else
		  return "1";
		}
		else
		return "1";	 
			

	}
}
document.body.onload = BodyLoadHandler;	