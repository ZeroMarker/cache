Class web.DHCEkg.EKGGetPatInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	Write "11111"
	
	Quit $$$OK
}

ClassMethod OnPreHTTP() As %Boolean
{
	d %response.SetHeader("Access-Control-Allow-Origin","*")
	d %response.SetHeader("Access-Control-Allow-Methods",",OPTIONS,DELETE")
	d %response.SetHeader("Access-Control-Allow-Headers","x-requested-with,content-type")
	Quit 1
}

}
