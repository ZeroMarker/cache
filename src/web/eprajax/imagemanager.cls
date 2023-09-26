Class web.eprajax.imagemanager Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	if (episodeID = -1)
	{
		set resultString = "<0|0|0|0"	
	}
	else
	{
		set resultString = ##class(EPRservice.BOEPImage).GetImagesByFile(episodeID)
		if (resultString = ""){s resultString = "<0|0|0|0"}
		else{s resultString = "<"_resultString}
	}
	
	w resultString,!

	q $$$OK
	
	
	s image = ##class(EPRservice.BOEPImage).GetEPImage("56", "86", "59||1")
	
	if (image '= "")
	{
		s page =  ##class(EPRservice.BOEPImage).GetEEPImagePage(image.ID, "1")
		while (page.ImageData.AtEnd = 0) 
		{ w page.ImageData.Read(1024)}
	

	}
	q $$$OK
}

}
