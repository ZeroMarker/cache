Class CIS.OPApp.DTO.ENS.Response.Body Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLTYPE = "Body";

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

Property ResultCode As %String;

Property ResultContent As %String;

Property ResultStruct As CIS.OPApp.DTO.ENS.Response.Struct;

ClassMethod Create() As CIS.OPApp.DTO.ENS.Response.Body
{
	set result=##class(CIS.OPApp.DTO.ENS.Response.Body).%New()
	set result.ResultStruct=##class(CIS.OPApp.DTO.ENS.Response.Struct).Create()
	quit result
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.OPApp.DTO.ENS.Request.Body
{
	set result=##class(CIS.OPApp.DTO.ENS.Response.Body).%New()
	set result.ResultCode=$property(object,"ResultCode")
	set result.ResultContent=$property(object,"ResultContent")
	set result.ResultStruct=##class(CIS.OPApp.DTO.ENS.Response.Struct).CloneFromObject($property(object,"ResultStruct"),modelName)
	
	quit result
}

Method Succeed() As %Status
{
	set ##this.ResultCode=0
	set ##this.ResultContent="成功"
}

Method Fail(reason As %String) As %Status
{
	set ##this.ResultCode=-1
	set ##this.ResultContent="失败："_reason
}

Method IsSuccess() As %Boolean
{
	quit ##this.ResultCode=0
}

Method IsFailed() As %Boolean
{
	quit ##this.ResultCode'=0
}

Method Compose(models As %ListOfObjects) As %Status
{
	do ##this.ResultStruct.Compose(models)
	quit $$$OK
}

}
