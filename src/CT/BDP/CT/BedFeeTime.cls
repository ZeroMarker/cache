/// 功能:床位费时制表
/// 创建人：鲁俊文
/// 创建时间：2022-10-14
Class CT.BDP.CT.BedFeeTime Extends (%Persistent, User.Abstract) [ SqlTableName = BedFeeTime ]
{

/// 定义关系(时制关联时段)
Relationship TimePeriod As CT.BDP.CT.BedFeeTimePeriod [ Cardinality = children, Inverse = ParRef ];

/// 代码
Property BedFeeTimeCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = BedFeeTime_Code ];

/// 名称
Property BedFeeTimeName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = BedFeeTime_Name ];

/// 开始日期
Property BedFeeDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = BedFee_DateFrom ];

/// 结束日期
Property BedFeeDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = BedFee_DateTo ];

/// 名称索引
Index NameIndex On BedFeeTimeName As Exact;

/// 代码索引
Index CodeIndex On BedFeeTimeCode;

Storage Default
{
<Data name="BedFeeTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BedFeeTimeCode</Value>
</Value>
<Value name="3">
<Value>BedFeeTimeName</Value>
</Value>
<Value name="4">
<Value>BedFeeDateFrom</Value>
</Value>
<Value name="5">
<Value>BedFeeDateTo</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.BedFeeTimeD</DataLocation>
<DefaultData>BedFeeTimeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.BedFeeTimeD</IdLocation>
<IndexLocation>^CT.BDP.CT.BedFeeTimeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.BedFeeTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
