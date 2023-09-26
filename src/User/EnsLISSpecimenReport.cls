/// 标本报告关联表
Class User.EnsLISSpecimenReport Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = Ens_LISSpecimenReport ]
{

ForeignKey FKSPECIDREFERENCESPECREPORT(LISSRReportID) References User.EnsLISReportResult(LISREPORTRESULTPKey) [ SqlName = FK_SPECID_REFERENCE_SPECREPORT ];

/// DDL Primary Key Specification
Index LISSPECIMENREPORTPKey On (LISSRReportID, LISSRSpecimenID, LISSROrderItemID);

Index RELORDERSPECIMENHOSCODE On LISSRSpecimenID;

/// 报告ID 
Property LISSRReportID As %Library.String [ SqlColumnNumber = 2, SqlFieldName = LISSR_ReportID ];

/// 标本号 
Property LISSRSpecimenID As %Library.String [ SqlColumnNumber = 3, SqlFieldName = LISSR_SpecimenID ];

/// 医嘱号
Property LISSROrderItemID As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = LISSR_OrderItemID ];

/// 患者ID
Property LISSRPatientID As User.PAPatMas [ SqlColumnNumber = 5, SqlFieldName = LISSR_PatientID ];

/// 就诊号
Property LISSRVisitNumber As User.PAAdm [ SqlColumnNumber = 6, SqlFieldName = LISSR_VisitNumber ];

/// 时间戳 
Property LISSRUpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 7, SqlFieldName = LISSR_UpdateDate ];

/// 时间戳
Property LISSRUpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 8, SqlFieldName = LISSR_UpdateTime ];

Storage Default
{
<Data name="EnsLISSpecimenReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LISSRReportID</Value>
</Value>
<Value name="3">
<Value>LISSRSpecimenID</Value>
</Value>
<Value name="4">
<Value>LISSROrderItemID</Value>
</Value>
<Value name="5">
<Value>LISSRPatientID</Value>
</Value>
<Value name="6">
<Value>LISSRVisitNumber</Value>
</Value>
<Value name="7">
<Value>LISSRUpdateDate</Value>
</Value>
<Value name="8">
<Value>LISSRUpdateTime</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsLISSpecimenReportD</DataLocation>
<DefaultData>EnsLISSpecimenReportDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsLISSpecimenReportD</IdLocation>
<IndexLocation>^Busi.ENS.EnsLISSpecimenReportI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsLISSpecimenReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
