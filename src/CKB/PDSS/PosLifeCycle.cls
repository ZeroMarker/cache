Class CKB.PDSS.PosLifeCycle Extends (%Persistent, User.Abstract) [ SqlRowIdName = PLC_RowID, SqlTableName = PosLifeCycle ]
{

/// 岗位id
Property PLCJobDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 2, SqlFieldName = PLC_Job_Dr ];

/// 权限类别
Property PLCAuthType As %String [ SqlColumnNumber = 3, SqlFieldName = PLC_AuthType ];

/// 生命周期节点
Property PLCLifeNode As %String [ SqlColumnNumber = 4, SqlFieldName = PLC_LifeNode ];

/// 是否授权
Property PLCAuthFlag As %String [ SqlColumnNumber = 5, SqlFieldName = PLC_AuthFlag ];

Storage Default
{
<Data name="PosLifeCycleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PLCJobDr</Value>
</Value>
<Value name="3">
<Value>PLCAuthType</Value>
</Value>
<Value name="4">
<Value>PLCLifeNode</Value>
</Value>
<Value name="5">
<Value>PLCAuthFlag</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.PosLifeCycleD</DataLocation>
<DefaultData>PosLifeCycleDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.PosLifeCycleD</IdLocation>
<IndexLocation>^CKB.PDSS.PosLifeCycleI</IndexLocation>
<StreamLocation>^CKB.PDSS.PosLifeCycleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
