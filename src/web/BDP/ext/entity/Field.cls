Class web.BDP.ext.entity.Field Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Method GetJosnData() As %String
{
	s myjosnstr=""
	
	i (..name'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"'name'"_":"_"'"_..name_"'"
	}

	i (..type'=""){
		s:myjosnstr'="" myjosnstr=myjosnstr_","
		s myjosnstr=myjosnstr_"'type'"_":"_"'"_..type_"'"
	}
	
	s myjosnstr="{"_myjosnstr_"}"
	
	q myjosnstr
}

Property name As %String;

Property type As %String;

Method typeGet() As %String
{
	s mytype="string"	;##class(ext.entity.Field).GetExtDataType(..type)
	
	q mytype
}

ClassMethod GetExtDataType(CacheType As %String) As %String
{
	q "string"
}

}
