var ExtDeignerHelper = new Object();


ExtDeignerHelper.HandleResize = function(objControl)
{
	var objItm = null;
	for(var index in objControl)
	{
		objItm = objControl[index];
		if (objItm.on != null)
		{
			objItm.on("resize", ExtDeignerHelper.ResizeHandler, ExtDeignerHelper);
		}
	}
}

ExtDeignerHelper.ResizeHandler = function(thisObj)
{
			try{
				window.external.HtmlEventHandler("resize", thisObj.initialConfig.id, thisObj.getWidth(), thisObj.getHeight());
			}catch(e)
			{
				window.alert(e.description);
			}
	
}

window.onerror = function(sMsg,sUrl,sLine)
{
	try
	{
		window.external.HtmlEventHandler("error", sMsg, sUrl, sLine);
		return true;
	}catch(e)
	{}
	return true;
}