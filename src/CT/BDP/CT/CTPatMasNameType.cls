/// Function: 病人姓名类型
/// CreateDate:2022-07-22
/// Creator:sunfengchao
/// sql表：CT_BDP_CT.CTPatMasNameType
Class CT.BDP.CT.CTPatMasNameType Extends (%Persistent, User.Abstract)
{

/// 代码 
Property CTPMNTCode As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTPMNT_Code ];

/// 描述
Property CTPMNTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTPMNT_Desc ];

/// 开始日期
Property CTPMNTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CTPMNT_DateFrom ];

/// 结束日期
Property CTPMNTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CTPMNT_DateTo ];

/// 代码索引
Index CodeIndex On CTPMNTCode As Exact;

/// 描述索引
Index DescIndex On CTPMNTDesc As Exact;

Storage Default
{
<Data name="CTPatMasNameTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTPMNTCode</Value>
</Value>
<Value name="3">
<Value>CTPMNTDesc</Value>
</Value>
<Value name="4">
<Value>CTPMNTDateFrom</Value>
</Value>
<Value name="5">
<Value>CTPMNTDateTo</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.CTPatMasNameTypeD</DataLocation>
<DefaultData>CTPatMasNameTypeDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.CTPatMasNameTypeD</IdLocation>
<IndexLocation>^CT.BDP.CT.CTPatMasNameTypeI</IndexLocation>
<StreamLocation>^CT.BDP.CT.CTPatMasNameTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
