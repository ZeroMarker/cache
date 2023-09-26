Class DHCWL.MRIPDay.ZCRSDef Extends %Persistent [ SqlRowIdName = ZCRSDef_RowID, SqlTableName = ZCRSDef ]
{

Property ZCRSDefDate As %Date [ SqlFieldName = ZCRSDef_Date ];

Index ZCRSDefDateIndex On ZCRSDefDate;

Property ZCRSDefTotalNum As %Integer [ SqlFieldName = ZCRSDef_TotalNum ];

Storage Default
{
<Data name="ZCRSDefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ZCRSDefDate</Value>
</Value>
<Value name="3">
<Value>ZCRSDefCreateDate</Value>
</Value>
<Value name="4">
<Value>ZCRSDefTotalNum</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDay.ZCRSDefD</DataLocation>
<DefaultData>ZCRSDefDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDay.ZCRSDefD</IdLocation>
<IndexLocation>^DHCWL.MRIPDay.ZCRSDefI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDay.ZCRSDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
