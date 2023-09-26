Class CIS.OPApp.SRV.Event.Handler.Test Extends %RegisteredObject
{

ClassMethod Test(response As CIS.OPApp.DTO.Abstract.Response) As %String
{
	write "handler proceeding response...",!
	quit ""
}

}
