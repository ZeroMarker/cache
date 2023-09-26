/// Creater:wangpf
/// Descriptions:换班申请表
/// Date:2020-06-30
Class DHCINM.Arg.MgArgExchangeApp Extends %Persistent
{

/// 换班病区
Property ExchangeWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Exchange_Ward ];

/// 申请人(创建人)
Property ExchangeFromNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 3, SqlFieldName = Exchange_FromNurse ];

/// 申请人排班
Property ExchangeFromArg As DHCINM.Arg.MgArrangeSub [ SqlColumnNumber = 4, SqlFieldName = Exchange_FromArg ];

/// 申请人排班日期
Property ExchangeFromArgDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Exchange_FromArgDate ];

/// 被换班人
Property ExchangeToNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = Exchange_ToNurse ];

/// 被换班人排班
Property ExchangeToArg As DHCINM.Arg.MgArrangeSub [ SqlColumnNumber = 7, SqlFieldName = Exchange_ToPost ];

/// 被换班人排班日期
Property ExchangeToArgDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Exchange_ToArgDate ];

/// 状态 B:驳回 Y:提交 A:审核
Property ExchangeStatus As %String(DISPLAYLIST = ",驳回,提交,审核", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",B,Y,A") [ SqlColumnNumber = 9, SqlFieldName = Exchange_Status ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = CreateTime ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 12, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 13, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 14, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = AuditOpinion ];

Index Status On ExchangeStatus;

Storage Default
{
<Data name="MgArgExchangeAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExchangeWard</Value>
</Value>
<Value name="3">
<Value>ExchangeFromNurse</Value>
</Value>
<Value name="4">
<Value>ExchangeFromArg</Value>
</Value>
<Value name="5">
<Value>ExchangeFromArgDate</Value>
</Value>
<Value name="6">
<Value>ExchangeToNurse</Value>
</Value>
<Value name="7">
<Value>ExchangeToArg</Value>
</Value>
<Value name="8">
<Value>ExchangeToArgDate</Value>
</Value>
<Value name="9">
<Value>ExchangeStatus</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
<Value name="12">
<Value>Auditor</Value>
</Value>
<Value name="13">
<Value>AuditDate</Value>
</Value>
<Value name="14">
<Value>AuditTime</Value>
</Value>
<Value name="15">
<Value>AuditOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Arg.MgArgExchangeAppD</DataLocation>
<DefaultData>MgArgExchangeAppDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgArgExchangeAppD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgArgExchangeAppI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgArgExchangeAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
