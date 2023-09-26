/// 描述: 基础数据平台   用户使用频率记录
/// 编写者：陈莹
/// 编写日期: 2017-06-23
Class User.BDPDataFrequency Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = BDP_DataFrequency ]
{

//    ^User.BDPDataFrequencyD   ^User.BDPDataFrequencyI

/// 表名称  节点 2
Property BDPDAFTableName As %String(MAXLEN = "") [ Required ];

/// 对应表数据RowId 节点 3
Property BDPDAFDataReference As %String(MAXLEN = "") [ Required ];

/// 对应表数据描述 节点 4
Property BDPDAFDesc As %String(MAXLEN = "") [ Required ];

/// 使用频次 节点 5
Property BDPDAFFrequency As %Float;

/// 使用用户 节点 6
Property BDPDAFUserID As User.SSUser;

/// 频次类型 节点 7
Property BDPDAFType As %String;

/// 用户科室 节点 8 add@2018-06-19
Property BDPCTLocDR As User.CTLoc;

Index TableNameIndex On BDPDAFTableName;

/// 表名称+频率 的索引
Index TableFreqIdx On (BDPDAFTableName, BDPDAFFrequency);

/// 表名称+描述 的索引
Index TableDescIdx On (BDPDAFTableName, BDPDAFDesc);

/// 表名称+数据rowid 的索引
Index TableReferenceIdx On (BDPDAFTableName, BDPDAFDataReference);

/// 2018-6-20
Index TableFrequencyIdx On BDPDAFFrequency;

/// 表名称+科室+数据rowid 的索引  2018-11-09
Index TableLocReferenceIdx On (BDPDAFTableName, BDPCTLocDR, BDPDAFDataReference);

/// 表名称+科室+频次 的索引  2018-11-09
Index TableLocFreqIdx On (BDPDAFTableName, BDPCTLocDR, BDPDAFFrequency);

/// 表名称+科室+用户+频次 的索引  2019-7-17
Index TableLocUserFreqIdx On (BDPDAFTableName, BDPCTLocDR, BDPDAFUserID, BDPDAFFrequency);

Storage Default
{
<Data name="BDPDataFrequencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPDAFTableName</Value>
</Value>
<Value name="3">
<Value>BDPDAFDataReference</Value>
</Value>
<Value name="4">
<Value>BDPDAFDesc</Value>
</Value>
<Value name="5">
<Value>BDPDAFFrequency</Value>
</Value>
<Value name="6">
<Value>BDPDAFUserID</Value>
</Value>
<Value name="7">
<Value>BDPDAFType</Value>
</Value>
<Value name="8">
<Value>BDPCTLocDR</Value>
</Value>
</Data>
<DataLocation>^User.BDPDataFrequencyD</DataLocation>
<DefaultData>BDPDataFrequencyDefaultData</DefaultData>
<IdLocation>^User.BDPDataFrequencyD</IdLocation>
<IndexLocation>^User.BDPDataFrequencyI</IndexLocation>
<StreamLocation>^User.BDPDataFrequencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
