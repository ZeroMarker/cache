Class EPRmeta.SelfPrintOption Extends %Persistent [ ProcedureBlock ]
{

Property OptionName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property OptionDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property OptionValue As %String(MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Index IdxOptionName On OptionName [ Unique ];

ClassMethod GetOptionID(AOptionName As %String) As %String
{
	s id = $O(^DHCEPRM.SelfPrintOptionI("IdxOptionName"," "_$zcvt(AOptionName,"u"),""))
	q id
}

/// w ##Class(EPRmeta.SelfPrintOption).GetOptionValue("OutPrintCountLimit")
ClassMethod GetOptionValue(AOptionName As %String) As %String
{
	s id =  $O(^DHCEPRM.SelfPrintOptionI("IdxOptionName"," "_$zcvt(AOptionName,"u"),""))
	s obj = ##Class(EPRmeta.SelfPrintOption).%OpenId(id)
	q:(obj = "") ""
	
	q obj.OptionValue
}

/// w ##Class(EPRmeta.SelfPrintOption).RegOption("OutPrintCountLimit","门诊病历自助打印次数上限[默认值为1]","1")
ClassMethod RegOption(AOptionName, AOptionDesc, AOptionValue) As %String
{
	s id = ..GetOptionID(AOptionName)
	if (id = "")
	{	s obj = ##Class(EPRmeta.SelfPrintOption).%New()}
	else
	{	s obj = ##Class(EPRmeta.SelfPrintOption).%OpenId(id)}
	q:(obj = "") ""
	
	s obj.OptionName = AOptionName
	s obj.OptionDesc = AOptionDesc
	s obj.OptionValue = AOptionValue
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

Storage Default
{
<Data name="SelfPrintOptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OptionName</Value>
</Value>
<Value name="3">
<Value>OptionDesc</Value>
</Value>
<Value name="4">
<Value>OptionValue</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.SelfPrintOptionD</DataLocation>
<DefaultData>SelfPrintOptionDefaultData</DefaultData>
<IdLocation>^DHCEPRM.SelfPrintOptionD</IdLocation>
<IndexLocation>^DHCEPRM.SelfPrintOptionI</IndexLocation>
<StreamLocation>^DHCEPRM.SelfPrintOptionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
