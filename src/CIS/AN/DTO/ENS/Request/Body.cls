Class CIS.AN.DTO.ENS.Request.Body Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property Arguments As CIS.AN.DTO.ENS.Request.Arguments;

Property Struct As CIS.AN.DTO.ENS.Request.Struct;

ClassMethod Create() As CIS.AN.DTO.ENS.Request.Body
{
	set result=##class(CIS.AN.DTO.ENS.Request.Body).%New()
	set result.Arguments=##class(CIS.AN.DTO.ENS.Request.Arguments).Create()
	set result.Struct=##class(CIS.AN.DTO.ENS.Request.Struct).Create()
	quit result
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.AN.DTO.ENS.Request.Body
{
	set result=##class(CIS.AN.DTO.ENS.Request.Body).%New()
	if ..#DEBUG=1 write "AIS: request body arguments clone start..."
	set result.Arguments=##class(CIS.AN.DTO.ENS.Request.Arguments).CloneFromObject($property(object,"Arguments"))
	if ..#DEBUG=1 write "AIS: request body struct clone start..."
	set result.Struct=##class(CIS.AN.DTO.ENS.Request.Struct).CloneFromObject($property(object,"Struct"),modelName)
	
	quit result
}

Method Compose(models As %ListOfObjects) As %Status
{
	do ##this.Struct.Compose(models)
	quit $$$OK
}

Method MatchArgs(arguments As CIS.AN.DTO.Abstract.Arguments) As %Status
{
	quit ##this.Arguments.MatchArgs(arguments)
}

}
