Class web.eprajax.Observer.SaveCase Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s pateintID = $Get(%request.Data("PateintID",1),"-1")
	s changedata = $Get(%request.Data("changedata",1),"1")
	s userID = $Get(%request.Data("userid",1),"1")
	s IPaddress = $Get(%request.Data("IPAddress",1),"1")
	s ret = ##class(EPRservice.Observer).BLUpdateData(pateintID,changedata,userID,IPaddress)
	w ret
	Quit $$$OK
}

}
