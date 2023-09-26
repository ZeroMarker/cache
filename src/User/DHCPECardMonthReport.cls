Class User.DHCPECardMonthReport Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract)
{

Parameter ClassName = "User.DHCPECardMonthReport";

Relationship ChildDetail As User.DHCPECardMonthReportDetail [ Cardinality = children, Inverse = ParentRef ];

/// 月结人
Property CMRUserDR As User.SSUser;

/// 月结日期
Property CMRDate As %Date;

/// 月结时间
Property CMRTime As %Time;

/// 余额
Property CMRPreAmount As %String;

/// 存款金额
Property CMRAddAmount As %String;

/// 转出
Property CMRMoveOutAmount As %String;

/// 转入
Property CMRMoveInAmount As %String;

/// 消费金额
Property CMRLesAmount As %String;

/// 消费退回
Property CMRBackAmount As %String;

/// 退存钱
Property CMROutAmount As %String;

/// 当前余额
Property CMRCurAmount As %String;

Index DateIndex On CMRDate;

Storage Default
{
<Data name="DHCPECardMonthReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMRUserDR</Value>
</Value>
<Value name="3">
<Value>CMRDate</Value>
</Value>
<Value name="4">
<Value>CMRTime</Value>
</Value>
<Value name="5">
<Value>CMRPreAmount</Value>
</Value>
<Value name="6">
<Value>CMRAddAmount</Value>
</Value>
<Value name="7">
<Value>CMRLesAmount</Value>
</Value>
<Value name="8">
<Value>CMRDBackAmount</Value>
</Value>
<Value name="9">
<Value>CMRDOutAmount</Value>
</Value>
<Value name="10">
<Value>CMRBackAmount</Value>
</Value>
<Value name="11">
<Value>CMROutAmount</Value>
</Value>
<Value name="12">
<Value>CMRCurAmount</Value>
</Value>
<Value name="13">
<Value>CMRMoveOutAmount</Value>
</Value>
<Value name="14">
<Value>CMRMoveInAmount</Value>
</Value>
</Data>
<DataLocation>^User.DHCPECardMonthReportD</DataLocation>
<DefaultData>DHCPECardMonthReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPECardMonthReportD</IdLocation>
<IndexLocation>^User.DHCPECardMonthReportI</IndexLocation>
<StreamLocation>^User.DHCPECardMonthReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
