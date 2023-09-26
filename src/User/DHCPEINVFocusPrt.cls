/// 记录集中打印发票
Class User.DHCPEINVFocusPrt Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, %ZEN.DataModel.Adaptor) [ SqlTableName = DHC_PE_INVFocusprt ]
{

Parameter ClassName = "User.DHCPEINVFocusPrt";

/// DHCPEINVPRT表ID
Property IFPINVDR As %String [ Required, SqlFieldName = IFP_INV_DR ];

/// 发票号
Property IFPINVNo As %String [ Required, SqlFieldName = IFP_INVNo ];

/// 打印发票人
Property IFPUSERDR As User.SSUser [ Required, SqlFieldName = IFP_USER_DR ];

/// 打印日期
Property IFPDate As %Library.Date [ Required, SqlFieldName = IFP_Date ];

/// 打印时间
Property IFPTime As %Library.Time [ SqlFieldName = IFP_Time ];

/// 是否日结的标志YN
Property IFPReportFlag As %String(MAXLEN = 1) [ SqlFieldName = IFP_ReportFlag ];

// Property IFPReportDR As User.DHCPEFocusPrtReport [ SqlFieldName = IFP_Report_DR ];

// 计费日结报表DHCINVPRTReports

/// 日结ID
Property IFPReportDR As User.DHCINVPRTReports [ SqlFieldName = IFP_Report_DR ];

/// 是否使用医保重新打印了发票
Property IFPINSUFlag As %String(MAXLEN = 1) [ SqlFieldName = IFP_INSUFlag ];

/// dhc_invoice的id
Property IFPInvoiceDR As User.DHCINVOICE [ SqlFieldName = IFP_Invoice_DR ];

/// 发票类型Y：预交金  N：非预交金
Property IFPINVType As %String(MAXLEN = 1) [ SqlFieldName = IFP_INVType ];

/// IFPHospitalDR 院区
Property IFPHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlFieldName = IFP_Hospital_DR ];

/// IFP_RPDate 日结日期
Property IFPRPDate As %Library.Date [ SqlFieldName = IFP_RPDate ];

/// IFP_RPTime 日结时间
Property IFPRPTime As %Library.Time [ SqlFieldName = IFP_RPTime ];

/// IFP_RPUser 日结人
Property IFPRPUser As %Library.String(COLLATION = "Exact", MAXLEN = 31, TRUNCATE = 0) [ SqlFieldName = IFP_RPUser ];

/// 发票表id索引
Index IFPINVDRIndex On IFPINVDR [ Unique ];

/// 发票号索引
Index IFPINVNoIndex On IFPINVNo [ Unique ];

/// 集中打印日结ID索引
Index IFPReportDRIndex On IFPReportDR;

/// 是否结算、打印人、打印日期、的索引
Index FlagUserDateIndex On (IFPReportFlag As AlphaUp, IFPUSERDR, IFPDate);

/// 结算日期索引
Index IPFRPDate On IFPRPDate;

Storage Default
{
<Data name="DHCPEINVFocusPrtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IFPINVDR</Value>
</Value>
<Value name="3">
<Value>IFPINVNo</Value>
</Value>
<Value name="4">
<Value>IFPUSERDR</Value>
</Value>
<Value name="5">
<Value>IFPDate</Value>
</Value>
<Value name="6">
<Value>IFPTime</Value>
</Value>
<Value name="7">
<Value>IFPReportFlag</Value>
</Value>
<Value name="8">
<Value>IFPReportDR</Value>
</Value>
<Value name="9">
<Value>IFPINSUFlag</Value>
</Value>
<Value name="10">
<Value>IFPInvoiceDR</Value>
</Value>
<Value name="11">
<Value>IFPINVType</Value>
</Value>
<Value name="12">
<Value>IFPHospitalDR</Value>
</Value>
<Value name="13">
<Value>IFPRPDate</Value>
</Value>
<Value name="14">
<Value>IFPRPTime</Value>
</Value>
<Value name="15">
<Value>IFPRPUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEINVFocusPrtD</DataLocation>
<DefaultData>DHCPEINVFocusPrtDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEINVFocusPrtD</IdLocation>
<IndexLocation>^User.DHCPEINVFocusPrtI</IndexLocation>
<StreamLocation>^User.DHCPEINVFocusPrtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
