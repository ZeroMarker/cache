Class User.DHCAuditStatus Extends %Persistent [ SqlRowIdName = Status_RowId, SqlTableName = DHC_AuditStatus ]
{

Property StatusCode As %String [ Required, SqlFieldName = Status_Code ];

Property StatusDesc As %String [ Required, SqlFieldName = Status_Desc ];

Index Code On StatusCode [ Unique ];

Storage Default
{
<Data name="DHCAuditStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StatusCode</Value>
</Value>
<Value name="3">
<Value>StatusDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCAuditStatusD</DataLocation>
<DefaultData>DHCAuditStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCAuditStatusD</IdLocation>
<IndexLocation>^User.DHCAuditStatusI</IndexLocation>
<StreamLocation>^User.DHCAuditStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
