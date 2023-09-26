Class CIS.OPApp.DTO.Test Extends %RegisteredObject
{

ClassMethod GenerateRequest() As %String
{
}

ClassMethod GenerateResponse() As %String
{
	set arrangement=##class(CIS.OPApp.DTO.OP.Arrangement).%New()
	set className=arrangement.%ClassName(1)
	write "className:",className,!
	
	set result=arrangement.ToJSON()
	
	quit ""
}

}
