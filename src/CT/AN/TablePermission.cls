/// 基础数据的多院区权限类型
Class CT.AN.TablePermission Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = TablePermission ]
{

/// 类名
Property TableName As %String [ Required, SqlColumnNumber = 2 ];

/// 类描述
Property Description As %String [ SqlColumnNumber = 3 ];

/// 权限类型
Property Permission As %String(DISPLAYLIST = ",公有,私有,管控", VALUELIST = ",Public,Private,Control") [ Required, SqlColumnNumber = 4 ];

Index IName On TableName [ Unique ];

Index IPermission On (TableName, Permission);

Storage Default
{
<Data name="TablePermissionDefaultData">
<Value name="1">
<Value>TableName</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Permission</Value>
</Value>
</Data>
<DataLocation>^CT.AN.TablePermissionD</DataLocation>
<DefaultData>TablePermissionDefaultData</DefaultData>
<IdLocation>^CT.AN.TablePermissionD</IdLocation>
<IndexLocation>^CT.AN.TablePermissionI</IndexLocation>
<StreamLocation>^CT.AN.TablePermissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
