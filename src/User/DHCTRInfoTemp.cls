Class User.DHCTRInfoTemp Extends %Persistent [ SqlTableName = DHC_TRInfoTemp ]
{

Index UniqueName On (HospitalDR, Name) [ Unique ];

Property Name As %String [ SqlColumnNumber = 2 ];

Property TimeRangeDR As DHCTimeRange [ SqlColumnNumber = 3 ];

Property Data As %String(MAXLEN = 9999999) [ SqlColumnNumber = 4 ];

Property InsertUserDR As SSUser [ SqlColumnNumber = 5 ];

Property InsertDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6 ];

Property InsertTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7 ];

Property HospitalDR As CTHospital [ SqlColumnNumber = 8 ];

Property TempListType As %String [ SqlColumnNumber = 9 ];

Property TempListTypeID As %String [ SqlColumnNumber = 10 ];

Storage Default
{
<Data name="DHCTRInfoTempDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TempName</Value>
</Value>
<Value name="3">
<Value>TimeRangeDR</Value>
</Value>
<Value name="4">
<Value>TempData</Value>
</Value>
<Value name="5">
<Value>InsertUserDR</Value>
</Value>
<Value name="6">
<Value>InsertDate</Value>
</Value>
<Value name="7">
<Value>InsertTime</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Data</Value>
</Value>
<Value name="10">
<Value>HospitalDR</Value>
</Value>
<Value name="11">
<Value>TempListType</Value>
</Value>
<Value name="12">
<Value>TempListTypeID</Value>
</Value>
</Data>
<DataLocation>^User.DHCTRInfoTempD</DataLocation>
<DefaultData>DHCTRInfoTempDefaultData</DefaultData>
<IdLocation>^User.DHCTRInfoTempD</IdLocation>
<IndexLocation>^User.DHCTRInfoTempI</IndexLocation>
<StreamLocation>^User.DHCTRInfoTempS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
