Class DHCINM.OrgManage.OrgHis Extends %Persistent
{

Property OrgDR As DHCINM.OrgManage.OrgSystem [ SqlColumnNumber = 2, SqlFieldName = Org_DR ];

Property OrgType As %String [ SqlColumnNumber = 3, SqlFieldName = Org_Type ];

Property Updator As %String [ SqlColumnNumber = 4, SqlFieldName = Updator ];

Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = UpdateDate ];

Property UpdateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = UpdateTime ];

Property OrgDRDesc As %String [ Required, SqlColumnNumber = 7, SqlFieldName = Org_DRDesc ];

Index type On (OrgType, OrgDR);

Storage Default
{
<Data name="OrgHisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrgDR</Value>
</Value>
<Value name="3">
<Value>OrgType</Value>
</Value>
<Value name="4">
<Value>Updator</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>OrgDRDesc</Value>
</Value>
</Data>
<DataLocation>^DHCINM.OrgManage.OrgHisD</DataLocation>
<DefaultData>OrgHisDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.OrgHisD</IdLocation>
<IndexLocation>^DHCINM.OrgManage.OrgHisI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.OrgHisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
