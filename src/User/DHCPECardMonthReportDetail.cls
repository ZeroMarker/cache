Class User.DHCPECardMonthReportDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock ]
{

Parameter ClassName = "User.DHCPECardMonthReportDetail";

Relationship ParentRef As User.DHCPECardMonthReport [ Cardinality = parent, Inverse = ChildDetail ];

/// 预缴金主表ID
Property CMRDAPDR As User.DHCPEAdvancePayment;

/// 上次余额
Property CMRDPreAmount As %String;

/// 预存金额
Property CMRDAddAmount As %String;

/// 消费金额
Property CMRDLesAmount As %String;

/// 消费退回
Property CMRDBackAmount As %String;

/// 退存钱
Property CMRDOutAmount As %String;

/// 转出
Property CMRDMoveOutAmount As %String;

/// 转入
Property CMRDMoveInAmount As %String;

/// 当前余额
Property CMRDCurAmount As %String;

/// 预缴金索引
Index APDRIndex On CMRDAPDR;

Storage Default
{
<Data name="DHCPECardMonthReportDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMRDAPDR</Value>
</Value>
<Value name="3">
<Value>CMRDPreAmount</Value>
</Value>
<Value name="4">
<Value>CMRDAddAmount</Value>
</Value>
<Value name="5">
<Value>CMRDLesAmount</Value>
</Value>
<Value name="6">
<Value>CMRDBackAmount</Value>
</Value>
<Value name="7">
<Value>CMRDOutAmount</Value>
</Value>
<Value name="8">
<Value>CMRDCurAmount</Value>
</Value>
<Value name="9">
<Value>CMRDMoveOutAmount</Value>
</Value>
<Value name="10">
<Value>CMRDMoveInAmount</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDetail")</DataLocation>
<DefaultData>DHCPECardMonthReportDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPECardMonthReportC("ChildDetail")</IdLocation>
<IndexLocation>^User.DHCPECardMonthReportI</IndexLocation>
<StreamLocation>^User.DHCPECardMo8D63S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
