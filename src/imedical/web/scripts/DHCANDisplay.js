document.write("<object id='FormICU' classid='../service/DHCClinic/App/AN/UI.dll#UI.Mon' height='1024' width='1280' VIEWASTEXT/>")
//document.write("<object id='FormICU' classid='../custom/DHCClinic/ICUMon.dll#ICU.ICUMon' height='1024' width='1280' VIEWASTEXT/>")
document.write("</object>");

function BodyLoadHandler()
{   
	var icuaId=document.getElementById('icuaId').value;
	var userId=session['LOGON.USERID'];
	var documentType=document.getElementById('documentType').value;
	if (documentType=="") documentType="ICU";
	var EpisodeID=""
	if ((icuaId=="")&&(documentType=="ICU"))
	{
		EpisodeID=document.getElementById('EpisodeID').value;
		if (EpisodeID=="")
		{
			alert(t['alert:noEpisodeID']);
			return;
		}
		var GetIcuaId=document.getElementById('GetIcuaId').value;
		var icuaId=cspRunServerMethod(GetIcuaId,EpisodeID,"",userId,"Y","Y");
	}
	if(icuaId=="") 
	{
		alert(t['alert:noIcuaId']);
		return;
	}
	//alert(EpisodeID+"/"+icuaId);
	
	objConnectStr=document.getElementById('connectStr');
	var connectStr=cspRunServerMethod(objConnectStr.value);
	var isSuperUser=document.getElementById('isSuperUser').value;
	if (isSuperUser=="") isSuperUser=false;
	var userGroupId=session['LOGON.GROUPID'];
	var ctlocId=session['LOGON.CTLOCID'];
	var filePath=""
	var objFilePath=document.getElementById('filePath');
	if (objFilePath) filePath=cspRunServerMethod(objFilePath.value);
	var configXmlFilePath=filePath+'ICUXMLConfiguration'+ctlocId+documentType+'.xml';
	var printXlsFilePath=filePath+'ICUPrintRpt'+ctlocId+documentType+'.xls';
	var printXmlFilePath=filePath+'ICUPrintConfig'+ctlocId+documentType+'.xml';
	var filePathStr=configXmlFilePath+"!"+printXlsFilePath+"!"+printXmlFilePath;
	var filePathStr=configXmlFilePath+"!"+printXlsFilePath+"!"+printXmlFilePath;
	var curLocation=unescape(window.location);
	curLocation=curLocation.toLowerCase();
	filePathStr=curLocation.substr(0,curLocation.indexOf('/csp/'))+"/service/DHCClinic/Configuration/";
	//alert(icuaId+"#"+userId+"#"+connectStr+"#"+isSuperUser+"#"+userGroupId+"#"+ctlocId+"#"+filePathStr+"#"+documentType);
	FormICU.SetVal(icuaId,userId,connectStr,isSuperUser,userGroupId,ctlocId,filePathStr,documentType,""); 
}

document.body.onload = BodyLoadHandler;
