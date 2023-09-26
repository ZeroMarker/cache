var EpisodeID=document.getElementById('EpisodeID').value;
function BodyOnloadHandler() 
{   
	var objPAADMAdmDate=document.getElementById('PAADMAdmDate');
	var objPAADMAdmTime=document.getElementById('PAADMAdmTime');
	var objDHCADMDischgDate=document.getElementById('DHCADMDischgDate');
	var objDHCADMDischgTime=document.getElementById('DHCADMDischgTime');
	var objDHCADMReturnDate=document.getElementById('DHCADMReturnDate');
	var objDHCADMReturnTime=document.getElementById('DHCADMReturnTime');
	var objGetAdmDateTime=document.getElementById("GetAdmDateTime");
	if (objGetAdmDateTime)
	{
		var AdmDateTime=cspRunServerMethod(objGetAdmDateTime.value,EpisodeID);
		tmpList=AdmDateTime.split("^");
		if (tmpList.length>1){
			objPAADMAdmDate.value=tmpList[0];
			objPAADMAdmTime.value=tmpList[1];
			objDHCADMDischgDate.value=tmpList[5];
			objDHCADMDischgTime.value=tmpList[6];
			objDHCADMReturnDate.value=tmpList[7];
			objDHCADMReturnTime.value=tmpList[8];
			objPAADMAdmDate.disabled=true;
			objPAADMAdmTime.disabled=true;
			
			if (tmpList[3]=="")
			{
				alert(t['alert:MedDischFirst']);
				objDHCADMDischgDate.disabled=true;
				objDHCADMDischgTime.disabled=true;
				objDHCADMReturnDate.disabled=true;
				objDHCADMReturnTime.disabled=true;	
				obj=document.getElementById('btnDischg');
				if (obj) obj.style.display ="none";	
				obj=document.getElementById('btnReturn');
				if (obj) obj.style.display ="none";				
				
			}
			if (tmpList[4]=="D")
			{
				objDHCADMDischgDate.disabled=true;
				objDHCADMDischgTime.disabled=true;
				obj=document.getElementById('btnDischg');
				if (obj) obj.style.display ="none";	
			}
			if (tmpList[4]=="R")
			{
				objDHCADMReturnDate.disabled=true;
				objDHCADMReturnTime.disabled=true;
				obj=document.getElementById('btnReturn');
				if (obj) obj.style.display ="none";	
			}

		}
	}
	/*var objGetCurDateTime=document.getElementById("GetCurDateTime");
	if (objGetCurDateTime){
		var curDateTime=cspRunServerMethod(objGetCurDateTime.value);
		tmpList=curDateTime.split("^");
		if (tmpList.length>1){
			if ((objDHCADMDischgDate)&&(objDHCADMDischgTime)){
				if((objDHCADMDischgDate.value=="")&&(objDHCADMDischgTime.value=="")){
					objDHCADMDischgDate.value=tmpList[0];
					objDHCADMDischgTime.value=tmpList[1];
				}
			}
			if ((objDHCADMReturnDate)&&(objDHCADMReturnTime)){
				if((objDHCADMReturnDate.value=="")&&(objDHCADMReturnTime.value=="")){
					objDHCADMReturnDate.value=tmpList[0];
					objDHCADMReturnTime.value=tmpList[1];
				}
			}
		
		}			
	}*/
	obj=document.getElementById('btnDischg');
	if (obj) obj.onclick=btnDischg_click;	
	obj=document.getElementById('btnReturn');
	if (obj) obj.onclick=btnReturn_click;	
}

function btnDischg_click()
{
	
	if(IsValidDate(document.getElementById('DHCADMDischgDate'))!=1){
		alert("日期格式不正确")
		return;
	}
	if(IsValidTime(document.getElementById('DHCADMDischgTime'))!=1){
		alert("时间格式不正确")
		return;
	}
	var obj=document.getElementById('DHCADMDischgDate');
	if (obj) var DHCADMDischgDate=obj.value;
	var obj=document.getElementById('DHCADMDischgTime');
	if (obj) var DHCADMDischgTime=obj.value;
	if ((DHCADMDischgDate=="")||(DHCADMDischgTime==""))
	{
		alert(t['alert:DischgDateTimeNull']);
		return;
	}
    var userId=session['LOGON.USERID'];
    var EpisodeID=document.getElementById('EpisodeID').value;
	var obj=document.getElementById("UpdateDelayDischarge");
	if (obj) {encmeth=obj.value} else {encmeth=''};
    retStr=cspRunServerMethod(encmeth,EpisodeID,"D",userId,DHCADMDischgDate,DHCADMDischgTime);
    if (retStr!=0) 
    {
	    alert(retStr); 
		return;
	}
	else 
	{
		alert(t['alert:Success']);		
		//return;
		//var lnk="epr.default.csp";
		//window.location=lnk;
		self.location.reload();return;
	}

   
}

function btnReturn_click()
{
	
	if(IsValidDate(document.getElementById('DHCADMReturnDate'))!=1){
		alert("日期格式不正确")
		return;
	}
	if(IsValidTime(document.getElementById('DHCADMReturnTime'))!=1){
		alert("时间格式不正确")
		return;
	}
	var obj=document.getElementById('DHCADMReturnDate');
	if (obj) var DHCADMReturnDate=obj.value;
	var obj=document.getElementById('DHCADMReturnTime');
	if (obj) var DHCADMReturnTime=obj.value;
	if ((DHCADMReturnDate=="")||(DHCADMReturnTime==""))
	{
		alert(t['alert:ReturnDateTimeNull']);
		return;
	}
    var userId=session['LOGON.USERID'];
    var EpisodeID=document.getElementById('EpisodeID').value;
	var obj=document.getElementById("UpdateDelayDischarge");
	if (obj) {encmeth=obj.value} else {encmeth=''};
    retStr=cspRunServerMethod(encmeth,EpisodeID,"R",userId,DHCADMReturnDate,DHCADMReturnTime);
    if (retStr!=0) 
    {
	    alert(retStr); 
		return;
	}   
	else 
	{
		alert(t['alert:Success']);
		//return;
		//var lnk="epr.default.csp";
		//window.location=lnk;
		self.location.reload();return;
	}  
}

document.body.onload = BodyOnloadHandler;