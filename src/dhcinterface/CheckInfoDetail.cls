Class dhcinterface.CheckInfoDetail Extends (%Persistent, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// HIS预约纪录ID
Property ApptId As %String(TRUNCATE = 1);

/// 预约费
Property BookedFee As %String(TRUNCATE = 1);

/// 诊查费
Property ExamineFee As %String(TRUNCATE = 1);

/// 挂号费
Property RegistrationFee As %String(TRUNCATE = 1);

/// 交易日期
Property TransactionDate As %Date;

/// 交易类型?约定?T01预约?T02取消预约?T03取号?T04违约?
Property TransactionType As %String(TRUNCATE = 1);

}
