/// 集中打印发票日结表
Class User.DHCPEFocusPrtReport Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, %ZEN.DataModel.Adaptor) [ SqlTableName = DHC_PE_FocusPrtReport ]
{

Parameter ClassName = "User.DHCPEFocusPrtReport";

/// 日结日期
Property FPRDate As %Library.Date [ SqlFieldName = FPR_Date ];

/// 结算人
Property FPRUSERDR As User.SSUser [ SqlFieldName = FPR_USER_DR ];

/// 结算时间
Property FPRTime As %Library.Time [ SqlFieldName = FPR_Time ];

// Property FPRINVStr As %String [ SqlFieldName = FPR_INVStr ];

/// 发票号段
Property FPRINVStr As %Library.String(COLLATION = "Exact", MAXLEN = 800, TRUNCATE = 0) [ SqlFieldName = FPR_INVStr ];

/// 打印发票总金额
Property FPRAmt As %Float [ SqlFieldName = FPR_Amt ];

/// 打印发票总张数
Property FPRInvNum As %Integer [ SqlFieldName = FPR_InvNum ];

/// 日期索引
Index FPRDateIndex On FPRDate;

Storage Default
{
<Data name="DHCPEFocusPrtReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FPRDate</Value>
</Value>
<Value name="3">
<Value>FPRUSERDR</Value>
</Value>
<Value name="4">
<Value>FPRTime</Value>
</Value>
<Value name="5">
<Value>FPRINVStr</Value>
</Value>
<Value name="6">
<Value>FPRAmt</Value>
</Value>
<Value name="7">
<Value>FPRInvNum</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEFocusPrtReportD</DataLocation>
<DefaultData>DHCPEFocusPrtReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEFocusPrtReportD</IdLocation>
<IndexLocation>^User.DHCPEFocusPrtReportI</IndexLocation>
<StreamLocation>^User.DHCPEFocusPrtReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
