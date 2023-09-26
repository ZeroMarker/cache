/// 日间手术表
/// 基础数据平台-李可凡
/// 2021-05-08
Class User.ORCDaySurgery Extends (%Persistent, User.Abstract) [ SqlRowIdName = DS_RowId, SqlTableName = ORC_DaySurgery ]
{

/// 日间手术DR
Property DSDaySurgeryDR As ORCOperation [ Required, SqlColumnNumber = 2, SqlFieldName = DS_DaySurgeryDR ];

/// 日间手术索引
Index DaySurgeryIndex On DSDaySurgeryDR As Exact;

Storage Default
{
<Data name="ORCDaySurgeryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSDaySurgeryDR</Value>
</Value>
</Data>
<DataLocation>^User.ORCDaySurgeryD</DataLocation>
<DefaultData>ORCDaySurgeryDefaultData</DefaultData>
<IdLocation>^User.ORCDaySurgeryD</IdLocation>
<IndexLocation>^User.ORCDaySurgeryI</IndexLocation>
<StreamLocation>^User.ORCDaySurgeryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
