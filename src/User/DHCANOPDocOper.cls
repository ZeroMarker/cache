Class User.DHCANOPDocOper Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = DHC_ANOP_DocOper, StorageStrategy = CacheStorage ]
{

Property AnOpCtcpId As %String [ SqlColumnNumber = 2, SqlFieldName = AnOp_CtcpId ];

Property AnOpOperId As %String [ SqlColumnNumber = 3, SqlFieldName = AnOp_OperId ];

Property AnOpCreateDate As %Library.Date [ SqlColumnNumber = 4, SqlFieldName = AnOp_CreateDate ];

Property AnOpCreateTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = AnOp_CreateTime ];

Property AnOpCreateUserId As %String [ SqlColumnNumber = 6, SqlFieldName = AnOp_CreateUserId ];

Storage CacheStorage
{
<Data name="ClassName">
<Attribute>%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DefaultData">
<Value name="1">
<Value>AnOpCtcpId</Value>
</Value>
<Value name="2">
<Value>AnOpOperId</Value>
</Value>
<Value name="3">
<Value>AnOpCreateDate</Value>
</Value>
<Value name="4">
<Value>AnOpCreateTime</Value>
</Value>
<Value name="5">
<Value>AnOpCreateUserId</Value>
</Value>
<Value name="6">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCANOPDocOper("DocOper")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCANOPDocOper("DocOper")</IdLocation>
<IndexLocation>^DHCANOPDocOper("DocOper",0)</IndexLocation>
<SqlRowIdName>AnOp_RowId</SqlRowIdName>
<StreamLocation>^User.^DHCANOPDocOperS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index OperCtcp On (AnOpOperId As Exact, AnOpCtcpId As Exact);

Index CtcpOper On (AnOpCtcpId As Exact, AnOpOperId As Exact);

}
