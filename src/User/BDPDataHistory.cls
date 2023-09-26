/// 描述: 基础数据平台   用户最近操作数据
/// 编写者：谷雪萍
/// 编写日期: 2017-08-23
Class User.BDPDataHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = BDP_DataHistory ]
{

//    ^User.BDPDataHistoryD   ^User.BDPDataHistoryI

/// 表名称  节点 2  术语维护表存User.TKBTrem+base(术语库注册ID)
Property BDPDAHTableName As %String(MAXLEN = "") [ Required ];

/// 对应表数据RowId 节点 3
Property BDPDAHDataReference As %String(MAXLEN = "") [ Required ];

/// 对应表数据描述 节点 4
Property BDPDAHDesc As %String(MAXLEN = "") [ Required ];

/// 使用日期和时间 节点 5  保存时存$h
Property BDPDAHDate As %String(MAXLEN = "") [ Required ];

/// 使用用户 节点 6  从seeeion取——$Get(%session.Data("LOGON.USERID"))
Property BDPDAHUserID As User.SSUser [ Required ];

/// 表名的索引
Index TableNameIndex On BDPDAHTableName;

/// 表名称+日期 的索引  此索引用于保存的时候判断ＩＤ是否存在，存在则修改日期，不存在则添加一条数据(没根据用户来保存的时候)
Index TableDateIdx On (BDPDAHTableName, BDPDAHDate);

/// 表名称+rowID 的索引  此索引用于GetList方法  (没根据用户来保存的时候)
Index TableRefIdx On (BDPDAHTableName, BDPDAHDataReference);

/// 表名称+用户+日期 的索引  此索引用于GetList方法 
Index TableUserDateIdx On (BDPDAHTableName, BDPDAHUserID, BDPDAHDate);

/// 表名称+用户+rowID 的索引  此索引用于保存的时候判断ＩＤ是否存在，存在则修改日期，不存在则添加一条数据
Index TableUserRefIdx On (BDPDAHTableName, BDPDAHUserID, BDPDAHDataReference);

Storage Default
{
<Data name="BDPDataHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPDAHTableName</Value>
</Value>
<Value name="3">
<Value>BDPDAHDataReference</Value>
</Value>
<Value name="4">
<Value>BDPDAHDesc</Value>
</Value>
<Value name="5">
<Value>BDPDAHDate</Value>
</Value>
<Value name="6">
<Value>BDPDAHUserID</Value>
</Value>
</Data>
<DataLocation>^User.BDPDataHistoryD</DataLocation>
<DefaultData>BDPDataHistoryDefaultData</DefaultData>
<IdLocation>^User.BDPDataHistoryD</IdLocation>
<IndexLocation>^User.BDPDataHistoryI</IndexLocation>
<StreamLocation>^User.BDPDataHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
