/// 打印模块定义表
Class User.DHCEventModel Extends %Persistent [ ClassType = persistent, SqlRowIdName = Model_RowId, SqlTableName = DHC_EventModel ]
{

Property ModelCode As %String [ Required, SqlFieldName = Model_Code ];

Property ModelDesc As %String [ Required, SqlFieldName = Model_Desc ];

/// 模块日志开关
Property ModelActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlFieldName = Model_Active ];

/// 模块类型
Property ModelType As %String(DISPLAYLIST = ",Login,Print,Query,View,Operate", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",L,P,Q,V,O") [ InitialExpression = "P", Required, SqlFieldName = Model_Type ];

/// 日志的字段集合
Property ModelFiledSet As %String [ SqlFieldName = Model_FiledSet ];

/// 备注 可以写产品组名
Property ModelNote As %String [ SqlFieldName = Model_Note ];

Index Code On ModelCode [ Unique ];

Index Desc On ModelDesc [ Unique ];

Storage Default
{
<Data name="DHCEventModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelCode</Value>
</Value>
<Value name="3">
<Value>ModelDesc</Value>
</Value>
<Value name="4">
<Value>ModelActive</Value>
</Value>
<Value name="5">
<Value>ModelType</Value>
</Value>
<Value name="6">
<Value>ModelFiledSet</Value>
</Value>
<Value name="7">
<Value>ModelNote</Value>
</Value>
</Data>
<DataLocation>^User.DHCEventModelD</DataLocation>
<DefaultData>DHCEventModelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCEventModelD</IdLocation>
<IndexLocation>^User.DHCEventModelI</IndexLocation>
<StreamLocation>^User.DHCEventModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
