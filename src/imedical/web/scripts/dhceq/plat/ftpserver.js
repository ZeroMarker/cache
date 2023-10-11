//界面入口
jQuery(document).ready
(    
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initMessage();
	initButton();
    initButtonWidth();
    setRequiredElements("FtpServer^FtpUser^FtpPassWord^FtpPort")
}
function BSave_Clicked()
{
	if (checkMustItemNull()) return;
	var ftpserver=getElementValue("FtpServer")
	var ftpuser=getElementValue("FtpUser")
	var ftppassword=getElementValue("FtpPassWord")
	var ftpport=getElementValue("FtpPort")
	var SSRowID=getElementValue("SSRowID")		//CZF0138 2021-05-24
	var rtn=tkMakeServerCall("web.DHCEQCSysSet","UpdateFtpServer",ftpserver,ftpuser,ftppassword,ftpport,SSRowID)
	if (rtn=="0")
	{
		messageShow("","","",t[0]);
	}
	else
	{
		messageShow("","","",t[-9200]);
	}
}