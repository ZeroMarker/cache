Class DHCWL.MRIPDay.ZCRSDetailDef Extends %Persistent [ SqlRowIdName = ZCRSDetail_RowID, SqlTableName = ZCRSDetailDef ]
{

Property ZCRSDetailParRef As ZCRSDef [ SqlColumnNumber = 2, SqlFieldName = ZCRSDetail_ParRef ];

Index ZCRSDetailParRefIndex On ZCRSDetailParRef;

Property ZCRSDetailPaadmID As %String [ SqlColumnNumber = 3, SqlFieldName = ZCRSDetail_PaadmID ];

Property ZCRSDetailCTlocID As %String [ SqlColumnNumber = 4, SqlFieldName = ZCRSDetail_CTlocID ];

Property ZCRSDetailWardID As %String [ SqlColumnNumber = 5, SqlFieldName = ZCRSDetail_WardID ];

Property ZCRSDetailBedID As %String [ SqlColumnNumber = 6, SqlFieldName = ZCRSDetail_BedID ];

Property ZCRSDetailTransID As %String [ SqlColumnNumber = 7, SqlFieldName = ZCRSDetail_TransID ];

Storage Default
{
<Data name="ZCRSDetailDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ZCRSDetailPaadmID</Value>
</Value>
<Value name="3">
<Value>ZCRSDetailCTlocID</Value>
</Value>
<Value name="4">
<Value>ZCRSDetailWardID</Value>
</Value>
<Value name="5">
<Value>ZCRSDetailBedID</Value>
</Value>
<Value name="6">
<Value>ZCRSDetailTransID</Value>
</Value>
<Value name="7">
<Value>ZCRSDetailParRef</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.ZCRSDetailDefD</DataLocation>
<DefaultData>ZCRSDetailDefDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.ZCRSDetailDefD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.ZCRSDetailDefI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.ZCRSDetailDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
