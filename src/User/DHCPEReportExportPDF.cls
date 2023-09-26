/// 报告归档导出pdf
Class User.DHCPEReportExportPDF Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ReportExportPDF ]
{

Parameter ClassName = "User.DHCPEReportExportPDF";

/// 就诊id
Property REPPAADMID As User.PAAdm [ Required, SqlFieldName = REP_PAADMID ];

Index REPPAADMIDIndex On REPPAADMID;

/// 状态0待导出，1已取消，2导出失败，3导出成功，4导到本地
Property REPStatus As %String [ SqlFieldName = REP_Status ];

/// 报告审核人（复检人）
Property REPAuditUserDR As User.SSUser [ SqlFieldName = REP_AuditUser_DR ];

/// 报告审核日期
Property REPAuditDate As %Date [ SqlFieldName = REP_AuditDate ];

/// 报告审核时间
Property REPAuditTime As %Time [ SqlFieldName = REP_AuditTime ];

/// 取消审核人
Property REPCancelUserDR As User.SSUser [ SqlFieldName = REP_CancelUser_DR ];

/// 报告取消审核日期
Property REPCancelDate As %Date [ SqlFieldName = REP_CancelDate ];

/// 报告取消时间
Property REPCancelTime As %Time [ SqlFieldName = REP_CancelTime ];

/// 导出日期
Property REPExportDate As %Date [ SqlFieldName = REP_ExportDate ];

/// 导出时间
Property REPExportTime As %Time [ SqlFieldName = REPExportTime ];

/// 导出文件名称
Property REPExportFileName As %String [ SqlFieldName = REP_ExportFileName ];

Property Businessno As %String [ SqlFieldName = REP_Businessno ];

Property Filedata As %Library.GlobalBinaryStream [ SqlFieldName = REP_Filedata ];

Property Filetypecode As %String [ SqlFieldName = REP_Filetypecode ];

Property Filetypename As %String [ SqlFieldName = REP_Filetypename ];

Property Datarank As %String [ SqlFieldName = REP_Datarank ];

/// 状态审核日期索引
Index StatusAuditDateIndex On (REPStatus As AlphaUp, REPAuditDate As AlphaUp);

/// 状态导出日期索引
Index StatusExportDateIndex On (REPStatus As AlphaUp, REPExportDate As AlphaUp);

Storage Default
{
<Data name="DHCPEReportExportPDFDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>REPPAADMID</Value>
</Value>
<Value name="3">
<Value>REPStatus</Value>
</Value>
<Value name="4">
<Value>REPAuditUserDR</Value>
</Value>
<Value name="5">
<Value>REPAuditDate</Value>
</Value>
<Value name="6">
<Value>REPAuditTime</Value>
</Value>
<Value name="7">
<Value>REPCancelUserDR</Value>
</Value>
<Value name="8">
<Value>REPCancelDate</Value>
</Value>
<Value name="9">
<Value>REPCancelTime</Value>
</Value>
<Value name="10">
<Value>REPExportDate</Value>
</Value>
<Value name="11">
<Value>REPExportTime</Value>
</Value>
<Value name="12">
<Value>REPExportFileName</Value>
</Value>
<Value name="13">
<Value>Businessno</Value>
</Value>
<Value name="14">
<Value>Filedata</Value>
</Value>
<Value name="15">
<Value>Filetypecode</Value>
</Value>
<Value name="16">
<Value>Filetypename</Value>
</Value>
<Value name="17">
<Value>Datarank</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEReportExportPDFD</DataLocation>
<DefaultData>DHCPEReportExportPDFDefaultData</DefaultData>
<IdLocation>^User.DHCPEReportExportPDFD</IdLocation>
<IndexLocation>^User.DHCPEReportExportPDFI</IndexLocation>
<StreamLocation>^User.DHCPEReportExportPDFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
