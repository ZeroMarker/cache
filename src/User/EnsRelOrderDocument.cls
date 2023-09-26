/// 院内文档关联表
Class User.EnsRelOrderDocument Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = Ens_RelOrderDocument ]
{

Index INDEXODORDERITEMID On (RelODPatientID, RelODVisitNumber, RelODOrderItemID) [ Type = index ];

Index INDEXODRISEXAMID On (RelODPatientID, RelODVisitNumber, RelODRisExamID) [ Type = index ];

Index INDEXODSPECIMENID On (RelODPatientID, RelODVisitNumber, RelODSpecimenID) [ Type = index ];

Index INDEXODDocumentID On RelODDocumentID [ Type = index ];

Index RelODRisReportIDIndex On (RelODRisReportID, RelODDocumentType) [ Type = index ];

Index RelODLisReportIDIndex On (RelODLisReportID, RelODDocumentType) [ Type = index ];

Index RelODOrderItemIDIndex On (RelODOrderItemID, RelODDocumentType) [ Type = index ];

/// 文档ID上的外键
/// ForeignKey FKRelODDocumentIDREFHOSDocument(RelODDocumentID) References User.HOSDocument(HOSDOCUMENTPKey) [ SqlName = FK_RelODDocumentID_REF_HOSDocument ];
ForeignKey FKRELORDDOCUDOCUMENTID(RelODDocumentID) References User.EnsHOSDocument(HOSDOCUMENTPKey) [ SqlName = FK_RELORDDOCU_DOCUMENTID ];

/// 患者基本信息表rowId
Property RelODPatientID As User.PAPatMas [ Required, SqlColumnNumber = 2, SqlFieldName = RelOD_PatientID ];

/// 就诊表rowId 
Property RelODVisitNumber As User.PAAdm [ Required, SqlColumnNumber = 3, SqlFieldName = RelOD_VisitNumber ];

/// 医嘱ID
Property RelODOrderItemID As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = RelOD_OrderItemID ];

/// 检查号  dhcrb_reginfo
Property RelODRisExamID As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 5, SqlFieldName = RelOD_RisExamID ];

/// 标本号
Property RelODSpecimenID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ SqlColumnNumber = 6, SqlFieldName = RelOD_SpecimenID ];

/// 文档ID 
Property RelODDocumentID As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 7, SqlFieldName = RelOD_DocumentID ];

/// 文档类型
Property RelODDocumentType As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 8, SqlFieldName = RelOD_DocumentType ];

/// 检验报告ID
Property RelODLisReportID As %Library.String [ SqlColumnNumber = 9, SqlFieldName = RelOD_LisReportID ];

/// 检查报告ID
Property RelODRisReportID As %Library.String [ SqlColumnNumber = 10, SqlFieldName = RelOD_RisReportID ];

/// 条码号
Property RelODLisLabNo As %Library.String [ SqlColumnNumber = 11, SqlFieldName = RelOD_LisLabNo ];

Storage Default
{
<Data name="EnsRelOrderDocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RelODDocumentID</Value>
</Value>
<Value name="3">
<Value>RelODLisReportID</Value>
</Value>
<Value name="4">
<Value>RelODRisReportID</Value>
</Value>
<Value name="5">
<Value>RelODDocumentType</Value>
</Value>
<Value name="6">
<Value>RelODOrderItemID</Value>
</Value>
<Value name="7">
<Value>RelODRisExamID</Value>
</Value>
<Value name="8">
<Value>RelODPatientID</Value>
</Value>
<Value name="9">
<Value>RelODVisitNumber</Value>
</Value>
<Value name="10">
<Value>RelODSpecimenID</Value>
</Value>
<Value name="11">
<Value>RelODLisLabNo</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsRelOrderDocumentD</DataLocation>
<DefaultData>EnsRelOrderDocumentDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsRelOrderDocumentD</IdLocation>
<IndexLocation>^Busi.ENS.EnsRelOrderDocumentI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsRelOrderDocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
