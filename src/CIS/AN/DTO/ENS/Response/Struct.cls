Class CIS.AN.DTO.ENS.Response.Struct Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Struct";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Models As list Of CIS.AN.DTO.Abstract.Model;

ClassMethod Create() As CIS.AN.DTO.ENS.Response.Struct
{
	quit ##class(CIS.AN.DTO.ENS.Response.Struct).%New()
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.AN.DTO.ENS.Response.Struct
{
	set result=##class(CIS.AN.DTO.ENS.Response.Struct).%New()
	
	set models=$property(object,"Models")
	if modelName'=""
	{
		while (models.Next(.key))
		{
			set model=$classmethod(modelName,"%New")
			do $method(model,"CloneInit",models.GetAt(key))
			do result.Models.Insert(model)
		}
	}
	
	quit result
}

Method Compose(models As %ListOfObjects) As %Status
{
	set ##this.Models = models
	quit $$$OK
}

}
