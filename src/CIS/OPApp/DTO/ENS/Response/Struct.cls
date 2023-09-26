Class CIS.OPApp.DTO.ENS.Response.Struct Extends (CIS.OPApp.DTO.Abstract.Model, %XML.Adaptor)
{

Parameter XMLNAME = "Struct";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Length As %Integer;

Property Models As list Of CIS.OPApp.DTO.Abstract.Model;

ClassMethod Create() As CIS.OPApp.DTO.ENS.Response.Struct
{
	quit ##class(CIS.OPApp.DTO.ENS.Response.Struct).%New()
}

ClassMethod CloneFromObject(object As %RegisteredObject, modelName As %String = "") As CIS.OPApp.DTO.ENS.Request.Struct
{
	set result=##class(CIS.OPApp.DTO.ENS.Response.Struct).%New()
	
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
	set ##this.Models=models
	set ##this.Length=##this.Models.Count()
	quit $$$OK
}

}
