/// 床位
Class DHCCL.Config.Bed Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Bed ]
{

/// 床位代码
Property Code As %String [ SqlColumnNumber = 2 ];

/// 床位名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 床位所在的房间
Property Room As DHCCL.Config.Room [ SqlColumnNumber = 4 ];

/// 床位所在的科室
Property Ward As DHCCL.Config.Ward [ SqlColumnNumber = 5 ];

/// 床位类型
Property BedType As DHCCL.Config.BedType [ SqlColumnNumber = 6 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7 ];

/// 归档标志
Property Archived As %String [ SqlColumnNumber = 8 ];

/// 是否隔离床
Property Isolated As %String [ SqlColumnNumber = 9 ];

/// 激活日期
Property ActiveDate As %Date [ SqlColumnNumber = 10 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 11 ];

/// 外部系统ID
Property ExternalID As %String [ SqlColumnNumber = 12 ];

Index Ward On Ward;

Index Type On BedType;

Index Room On Room;

Index Active On Active;

Index Isolated On Isolated;

Storage Default
{
<Data name="BedDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Room</Value>
</Value>
<Value name="4">
<Value>Ward</Value>
</Value>
<Value name="5">
<Value>BedType</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>Archived</Value>
</Value>
<Value name="8">
<Value>Isolated</Value>
</Value>
<Value name="9">
<Value>ActiveDate</Value>
</Value>
<Value name="10">
<Value>ExpireDate</Value>
</Value>
<Value name="11">
<Value>ExternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Config.BedD</DataLocation>
<DefaultData>BedDefaultData</DefaultData>
<IdLocation>^DHCCL.Config.BedD</IdLocation>
<IndexLocation>^DHCCL.Config.BedI</IndexLocation>
<StreamLocation>^DHCCL.Config.BedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
