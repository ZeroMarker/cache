Class web.DHCENS.STBLL.DICTNew.METHOD.wyrtest Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetJsonFromObj(inputObj As %RegisteredObject) As %String
{
	set jsonObj=##class(%Library.DynamicObject).%New()
	set className=inputObj.%ClassName(2)
	set classDef=##class(%Dictionary.CompiledClass).%OpenId(className)
	set proCount=classDef.Properties.Count()
	for i=1:1:proCount{
		set proDef=##class(%Dictionary.PropertyDefinition).%New()
		set proDef=classDef.Properties.GetAt(i)
		set XMLName=proDef.SqlFieldName
		set proName=proDef.Name
		continue:$e(proName,1)="%"
		set value=$PROPERTY(inputObj,proName)
		do jsonObj.%Set(XMLName,value)	
	}
	q jsonObj.%ToJSON()
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.wyrtest).test()
ClassMethod test()
{
	set obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSex).%New()
	set obj.CTSCode="1"
	set obj.CTSDesc="女"
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.wyrtest).GetJsonFromObj(obj)	
	q tSC
}

}
