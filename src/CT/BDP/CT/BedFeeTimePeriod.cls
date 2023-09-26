/// 功能:时段信息表
/// 创建人：鲁俊文
/// 创建时间：2022-10-17
/// 父表(床位费时制表）：CT.BDP.CT.BedFeeTime
Class CT.BDP.CT.BedFeeTimePeriod Extends (%Persistent, User.Abstract) [ SqlTableName = BedFeeTimePeriod ]
{

/// 定义关系(床位费时制)
Relationship ParRef As CT.BDP.CT.BedFeeTime [ Cardinality = parent, Inverse = TimePeriod ];

/// 开始日期
Property DateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = DateFrom ];

/// 结束日期
Property DateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = DateTo ];

Storage Default
{
<Data name="BedFeeTimePeriodDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateFrom</Value>
</Value>
<Value name="3">
<Value>DateTo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TimePeriod")</DataLocation>
<DefaultData>BedFeeTimePeriodDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.BedFeeTimeC("TimePeriod")</IdLocation>
<IndexLocation>^CT.BDP.CT.BedFeeTimePeriodI</IndexLocation>
<StreamLocation>^CT.BDP.CT.BedFeeTimePeriodS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
