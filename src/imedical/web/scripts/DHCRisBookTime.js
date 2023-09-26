//DHCRisBookTime.js

function BodyLoadHandler()
{
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}

	var showNotAvailObj=document.getElementById("ShowNotAvail");
	if (showNotAvailObj)
	{
		showNotAvailObj.onclick=clickShowNotAvail;
	}
	
	//alert(document.getElementById("FindNotAvail").value);
	if (document.getElementById("FindNotAvail").value=="Y")
	{
		document.getElementById("ShowNotAvail").checked=true;
	}
}

function clickShowNotAvail()
{
	var FindNotAvail="";
	//alert(document.getElementById("FindNotAvial").value);
	if (document.getElementById("ShowNotAvail").checked)
		FindNotAvail="Y";
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookTime&FindNotAvail="+FindNotAvail;
	//alert(lnk);
   	location.href=lnk; 
}

function Add_click()
{
	var ErrorInfo;
	//时间段代码
	var Code=document.getElementById("TimeCode").value;
	
	if (Code=="")
	{
		alert("Code不能为空!");
		return;
	}

	var Time=document.getElementById("TimeDesc").value;

	var StartTime=document.getElementById("StartTime").value;
	var ret=isTime(StartTime);
	if (ret==false)
	{
		ErrorInfo="开始时间格式不对,时间格式应为[xx:xx:xx]";
		alert(ErrorInfo);
		return ;
	}
	var EndTime=document.getElementById("EndTime").value;
	var ret=isTime(EndTime);
	if (ret==false)
	{
		ErrorInfo="结束时间格式不对,时间格式应为[xx:xx:xx]";
		alert(ErrorInfo);
		return ;
	}
	
	var EndChargeTime=Trim(document.getElementById("EndChargeTime").value);
	if  (EndChargeTime!="")
	{
		var ret=isTime(EndChargeTime);
		if (ret==false)
		{
			ErrorInfo="收费时间格式不对,时间格式应为[xx:xx:xx]";
			alert(ErrorInfo);
			return ;
		}
	}
	
	var notAvail="";
	if ( document.getElementById("notAvail").checked)
		notAvail="Y";
	
	var Info=""+"^"+Code+"^"+Time+"^"+StartTime+"^"+EndTime+"^"+EndChargeTime+"^"+notAvail;
	
	//web.DHCRisBookParam.InsertTimePeriod
	var UpdateTimeDurationFun=document.getElementById("UpdateTimeDurationInfo").value;
	var value=cspRunServerMethod(UpdateTimeDurationFun,Info);
	if (value!="0")
	{
		var Info="增加时间段失败 : "+getErrorInfo(value);
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookTime";
   		location.href=lnk; 
	}
	
}

function Modi_click()
{
	var ErrorInfo;
	//时间段代码
	var Code=document.getElementById("TimeCode").value;
	
	if (Code=="")
	{
		alert("Code不能为空!");
		return;
	}


	var Time=document.getElementById("TimeDesc").value;

	var StartTime=document.getElementById("StartTime").value;
	var ret=isTime(StartTime);
	if (ret==false)
	{
		ErrorInfo="开始时间格式不对,时间格式应为[xx:xx:xx]";
		alert(ErrorInfo);
		return ;
	}
	var EndTime=document.getElementById("EndTime").value;
	var ret=isTime(EndTime);
	if (ret==false)
	{
		ErrorInfo="结束时间格式不对,时间格式应为[xx:xx:xx]";
		alert(ErrorInfo);
		return ;
	}
	
	
	var EndChargeTime=Trim(document.getElementById("EndChargeTime").value);
	if  (EndChargeTime!="")
	{
		var ret=isTime(EndChargeTime);
		if (ret==false)
		{
			ErrorInfo="收费时间格式不对,时间格式应为[xx:xx:xx]";
			alert(ErrorInfo);
			return ;
		}
	}
	
	var notAvail="";
	if ( document.getElementById("notAvail").checked)
		notAvail="Y";
		
	var SelRowid=document.getElementById("SelRowid").value;
	
	var Info=SelRowid+"^"+Code+"^"+Time+"^"+StartTime+"^"+EndTime+"^"+EndChargeTime+"^"+notAvail;
	
	//web.DHCRisBookParam.InsertTimePeriod
	var UpdateTimeDurationFun=document.getElementById("UpdateTimeDurationInfo").value;
	var value=cspRunServerMethod(UpdateTimeDurationFun,Info);
	if (value!="0")
	{
		var Info="更新时间段失败 : "+getErrorInfo(value);
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookTime";
   		location.href=lnk; 
	}
	
}

function getErrorInfo(code)
{
	var desc=""
	switch(code)
	{
		case "200":
			desc="代码不能为空!";
			break;
		case "300":
			desc="代码重复!";
			break;
		case "400":
			desc="已经使用,不能删除！";
			break;
		default:
			desc=code;
			
	}
	return desc;
}

function Delete_click()
{

	var SelRowid=document.getElementById("SelRowid").value;
	
	//web.DHCRisBookParam.DeleteTimePeriod
	var UpdateTimeDurationFun=document.getElementById("DeleteInfo").value;
	var value=cspRunServerMethod(UpdateTimeDurationFun,SelRowid);
	if (value!="0")
	{
		var Info="删除时间段失败 : "+getErrorInfo(value);
		alert(Info);
	}
	else
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookTime";
   		location.href=lnk; 
	}
	
}



function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisBookTime');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

 	var SelRowid= document.getElementById("RowIdz"+selectrow).value;
	var Code=document.getElementById("Codez"+selectrow).innerText;
	var Time=document.getElementById("TimeDescz"+selectrow).innerText;
	var TStartTime= document.getElementById("TStartTimez"+selectrow).innerText;
	var TEndTime = document.getElementById("TEndTimez"+selectrow).innerText;
	var ChargeTime=document.getElementById("TEndChargeTimez"+selectrow).innerText;
	
	//alert(">"+document.getElementById("TIsAvailz"+selectrow).innerText+"<");
	if ( document.getElementById("TNotAvailz"+selectrow).innerText=="Y" )
	{
		document.getElementById("notAvail").checked=true;
	}
	else
	{
		document.getElementById("notAvail").checked=false;
	}
	
	var TimeCodeObj=document.getElementById("TimeCode");
	if (TimeCodeObj)
	{
		TimeCodeObj.value=Code;
	}
	var TimeDescObj=document.getElementById("TimeDesc");
	if (TimeDescObj)
	{
		TimeDescObj.value=Time;
	}

	var StartTimeObj=document.getElementById("StartTime");
	if (StartTimeObj)
	{
		StartTimeObj.value=TStartTime;
	}
	

	var EndTimeObj=document.getElementById("EndTime");
	if (EndTimeObj)
	{
		EndTimeObj.value=TEndTime;
		
	}
	var EndChargeTimeObj=document.getElementById("EndChargeTime");
	if (EndChargeTimeObj)
	{
		EndChargeTimeObj.value=ChargeTime;
	}
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
}

function isTime(str) 
{ 
	var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/); 
	if (a == null)
	{
		return false;
	} 
	if (a[1]>23 || a[3]>60 || a[4]>60) 
	{ 
		return false 
	} 
	return true; 
} 


function Trim(info)
{
	 return info.replace(/(^\s*)|(\s*$)/g,'');
}


document.body.onload = BodyLoadHandler;


