Class User.DHCAntChangeReason Extends %Persistent [ SqlTableName = DHC_AntChangeReason ]
{

/// Code
Property CHRCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CHR_Code ];

/// Desc
Property CHRDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CHR_Desc ];

/// ActiveFlag
Property CHRActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = CHR_ActiveFlag ];

/// Text
Property CHRText As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CHR_Text ];

Storage Default
{
<Data name="DHCAntChangeReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CHRCode</Value>
</Value>
<Value name="3">
<Value>CHRDesc</Value>
</Value>
<Value name="4">
<Value>CHRActiveFlag</Value>
</Value>
<Value name="5">
<Value>CHRText</Value>
</Value>
</Data>
<DataLocation>^User.DHCAntChangeReasonD</DataLocation>
<DefaultData>DHCAntChangeReasonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAntChangeReasonD</IdLocation>
<IndexLocation>^User.DHCAntChangeReasonI</IndexLocation>
<StreamLocation>^User.DHCAntChangeReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
