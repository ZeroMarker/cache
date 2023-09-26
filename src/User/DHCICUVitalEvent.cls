Class User.DHCICUVitalEvent Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlTableName = DHC_ICU_VitalEvent ]
{

Property ICUVIEICUADr As %String [ SqlColumnNumber = 2, SqlFieldName = ICUVIE_ICUADr ];

Property ICUVIECode As %String [ SqlColumnNumber = 3, SqlFieldName = ICUVIE_Code ];

Property ICUVIEFromDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ICUVIE_FromDate ];

Property ICUVIEToDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ICUVIE_ToDate ];

Property ICUVIECreateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = ICUVIE_CreateDate ];

Property ICUVIECreateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = ICUVIE_CreateTime ];

Property ICUVIEDisposal As %String(DISPLAYLIST = ",Original,Verified,Ignore", VALUELIST = ",O,V,I") [ SqlColumnNumber = 8, SqlFieldName = ICUVIE_Disposal ];

Property ICUVIEDisposalUserDr As %String [ SqlColumnNumber = 9, SqlFieldName = ICUVIE_DisposalUserDr ];

Property ICUVIEDisposalDate As %Date [ SqlColumnNumber = 10, SqlFieldName = ICUVIE_DisposalDate ];

Property ICUVIEDisposalTime As %Time [ SqlColumnNumber = 11, SqlFieldName = ICUVIE_DisposalTime ];

Index DateCode On (ICUVIEFromDate As Exact, ICUVIECode As Exact);

Storage Default
{
<Data name="DHCICUVitalEventDefaultData">
<Value name="1">
<Value>ICUVIEICUADr</Value>
</Value>
<Value name="2">
<Value>ICUVIECode</Value>
</Value>
<Value name="3">
<Value>ICUVIEFromDate</Value>
</Value>
<Value name="4">
<Value>ICUVIEToDate</Value>
</Value>
<Value name="5">
<Value>ICUVIECreateDate</Value>
</Value>
<Value name="6">
<Value>ICUVIECreateTime</Value>
</Value>
<Value name="7">
<Value>ICUVIEDisposal</Value>
</Value>
<Value name="8">
<Value>ICUVIEDisposalUserDr</Value>
</Value>
<Value name="9">
<Value>ICUVIEDisposalDate</Value>
</Value>
<Value name="10">
<Value>ICUVIEDisposalTime</Value>
</Value>
</Data>
<DataLocation>^DHCICUVitalEventD</DataLocation>
<DefaultData>DHCICUVitalEventDefaultData</DefaultData>
<IdLocation>^DHCICUVitalEventD</IdLocation>
<IndexLocation>^DHCICUVitalEventI</IndexLocation>
<StreamLocation>^DHCICUVitalEventS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
