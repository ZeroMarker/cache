Class User.DHCAntCombinedUseReason Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AntCombinedUseReason ]
{

/// Code
Property CURCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CUR_Code ];

/// Desc
Property CURDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CUR_Desc ];

/// ActiveFlag
Property CURActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CUR_ActiveFlag ];

/// Text
Property CURText As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CUR_Text ];

Storage Default
{
<Data name="DHCAntCombinedUseReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CURCode</Value>
</Value>
<Value name="3">
<Value>CURDesc</Value>
</Value>
<Value name="4">
<Value>CURActiveFlag</Value>
</Value>
<Value name="5">
<Value>CURText</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntCombinedUseReasonD</DataLocation>
<DefaultData>DHCAntCombinedUseReasonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAntCombinedUseReasonD</IdLocation>
<IndexLocation>^User.DHCAntCombinedUseReasonI</IndexLocation>
<StreamLocation>^User.DHCAntCombinedUseReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
