
function BodyLoadHandler()
{
    
    GetLocID();
        
	var SendObj=document.getElementById("SendFilmBT");
	if (SendObj)
	{
		SendObj.onclick=Send_click;
	}
	var USendObj=document.getElementById("UnSent");
	if (USendObj)
	{
		USendObj.onclick=UnSend_click;
	}
		
	var oeorditemrowid=document.getElementById("oeorditem").value;
	var GetItemNameFunction=document.getElementById("GetItmName").value;
    var ItemNameInfo=cspRunServerMethod(GetItemNameFunction,oeorditemrowid);
    var ListInfo=ItemNameInfo.split("^");
    document.getElementById("ItmName").value=ListInfo[0];
    document.getElementById("TotalPrice").value=ListInfo[1];
	
	var paadmrowid=document.getElementById("EpisodeID").value;
	var GetPatientName=document.getElementById("Name").value;
	var Info=cspRunServerMethod(GetPatientName,paadmrowid);
	var patinfo=Info.split("^");
	document.getElementById("Name").value=patinfo[0];
	document.getElementById("RegNo").value=patinfo[2];
	document.getElementById("Sex").value=patinfo[1];
	
	GetStudyNo();
	
	GetNo();   //获得病人的检查病案号
	
	
			
	
}
//////////////////
function GetLocID()
{
	var LocID=document.getElementById("LoginLocID");
	var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	if (Getlocicvalue=="")
        LocID.value=session['LOGON.CTLOCID'];
     else 
 		LocID.value=Getlocicvalue;
}

function GetNo()
{
		var paadmrowid=document.getElementById("EpisodeID").value;
		var RegLOC=document.getElementById("LoginLocID").value;
		var GetNo=document.getElementById("GetNo").value;
		var strNo=cspRunServerMethod(GetNo,paadmrowid,RegLOC);
		var NoObj=document.getElementById("No");
	    NoObj.value=strNo;
		//GetNo.value=strNo;
		
}
function GetStudyNo()
{
	
	var oeorditemrowid=document.getElementById("oeorditem").value;
	var GetAcessionNumber=document.getElementById("StudyNo").value;
	var Acessioninfo=cspRunServerMethod(GetAcessionNumber,oeorditemrowid);
	var StudyNo=document.getElementById("StudyNo");
	StudyNo.value=Acessioninfo;
	  
}
function Send_click()
{
	//var OpUserid=document.getElementById("OpUserid").value;
	//var oeorditemrowid=document.getElementById("oeorditem").value;
	var StudyNo=document.getElementById("StudyNo").value;

	var SendFilmFunction=document.getElementById("SendFilmFunction").value;
	var ret=cspRunServerMethod(SendFilmFunction,StudyNo,t['SendFilm']);
	if (ret=="0")
	{
		alert(t['SendSucess']);
	}
	else
	{
		alert(t['SendFAILURE']);
	}
	var EXITObj=document.getElementById("EXIT");
	if (EXITObj)
	{
		EXITObj.click();
	}
}
function UnSend_click()
{
	var StudyNo=document.getElementById("StudyNo").value;

	var SendFilmFunction=document.getElementById("SendFilmFunction").value;
	var ret=cspRunServerMethod(SendFilmFunction,StudyNo,"");
	if (ret=="0")
	{
		alert(t['UnSendSucess']);
	}
	else
	{
		alert(t['UnSendFAILURE']);
	}
	var EXITObj=document.getElementById("EXIT");
	if (EXITObj)
	{
		EXITObj.click();
	}
	
}
document.body.onload = BodyLoadHandler;