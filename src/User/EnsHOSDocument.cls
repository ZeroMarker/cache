/// 院内文档(索引)表
Class User.EnsHOSDocument Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = HOSD_DocumentID, SqlRowIdPrivate, SqlTableName = Ens_HOSDocument ]
{

// ForeignKey FKORGREFERENCEPATHOSPATORGID(HOSDOrganId) References hdc.User.CTHospital(CTHOSPITALPKey) [ SqlName = FK_ORG_REFERENCE_HOSPATORGID ];

/// Foreign Key FKPAPATIENTREFERENCEHOSDOC created via DDL
/// Foreign Key FKCODESYSREFERENCEPATDOCTYPE created via DDL
Index HOSDOCUMENTPKey On HOSDDocumentID [ PrimaryKey, Type = index, Unique ];

Index HOSDOCUMENTSerialIndex On HOSDSerialNumber [ Type = index, Unique ];

Index HOSDPatientIDIndex On (HOSDPatientID, HOSDClassificationCode, HOSDUpdateDate, HOSDUpdateTime);

Index HOSDVersionNumberIndex On (HOSDOrganId, HOSDClassificationCode, HOSDFormat, HOSDSubsysDocumentID, HOSDTemplateVersionNumber) [ Type = index, Unique ];

Index HOSDClassificationCodeIndex On (HOSDOrganId, HOSDClassificationCode, HOSDUpdateDate, HOSDUpdateTime);

Index HOSDUpdateTimeIndex On (UpdateDate, UpdateTime);

Index HOSDVisitNumberIndex On (HOSDVisitNumber, HOSDClassificationCode);

/// RowID(文档ID)
Property HOSDDocumentID As %Library.Integer [ InitialExpression = {$I(^Busi.ENS.EnsHOSDocumentC)}, Required, SqlColumnNumber = 2, SqlFieldName = HOSD_DocumentID ];

/// 文档流水号
Property HOSDSerialNumber As %Library.String(COLLATION = "EXACT", MAXLEN = 100) [ Required, SqlColumnNumber = 3, SqlFieldName = HOSD_SerialNumber ];

/// 医疗机构编码
Property HOSDOrganId As %Library.String(COLLATION = "EXACT", MAXLEN = 30) [ Required, SqlColumnNumber = 4, SqlFieldName = HOSD_OrganId ];

/// 患者主索引
Property HOSDPatientID As User.PAPatMas [ Required, SqlColumnNumber = 5, SqlFieldName = HOSD_PatientID ];

/// 就诊号
Property HOSDVisitNumber As User.PAAdm [ Required, SqlColumnNumber = 6, SqlFieldName = HOSD_VisitNumber ];

/// 文档来源
Property HOSDManufacturerID As %Library.Integer [ Required, SqlColumnNumber = 7, SqlFieldName = HOSD_ManufacturerID ];

/// 子系统内文档唯一标识
Property HOSDSubsysDocumentID As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ Required, SqlColumnNumber = 8, SqlFieldName = HOSD_SubsysDocumentID ];

/// 文档分类代码
Property HOSDClassificationCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 9, SqlFieldName = HOSD_ClassificationCode ];

/// 文档模板版本号
Property HOSDTemplateVersionNumber As %Library.String(COLLATION = "EXACT", MAXLEN = 18) [ Required, SqlColumnNumber = 10, SqlFieldName = HOSD_TemplateVersionNumber ];

/// 文档类型代码
Property HOSDTypeCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ SqlColumnNumber = 11, SqlFieldName = HOSD_TypeCode ];

/// 文档格式
Property HOSDFormat As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ Required, SqlColumnNumber = 12, SqlFieldName = HOSD_Format ];

/// 文档状态
Property HOSDStatus As %Library.String(COLLATION = "EXACT", MAXLEN = 4) [ Required, SqlColumnNumber = 13, SqlFieldName = HOSD_Status ];

/// 最后更新人编码
Property HOSDUpdateUserCode As %Library.String(COLLATION = "EXACT", MAXLEN = 50) [ InitialExpression = 1, Required, SqlColumnNumber = 14, SqlFieldName = HOSD_UpdateUserCode ];

/// 最后更新日期
Property HOSDUpdateDate As %Library.Date [ SqlColumnNumber = 15, SqlFieldName = HOSD_UpdateDate ];

/// 最后更新时间
Property HOSDUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = HOSD_UpdateTime ];

/// 时间戳日期
Property UpdateDate As %Library.Date [ InitialExpression = {$P($H,",")}, Required, SqlColumnNumber = 17, SqlFieldName = UpdateDate ];

/// 时间戳时间
Property UpdateTime As %Library.Time [ InitialExpression = {$P($H,",",2)}, Required, SqlColumnNumber = 18, SqlFieldName = UpdateTime ];

/// 文档路径
Property HOSDUrl As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = HOSD_Url ];

/// 文档内容
Property HOSDCContent As %Stream.GlobalCharacter [ SqlColumnNumber = 20, SqlFieldName = HOSDC_Content ];

/// 图像路径
Property HOSDCPicUrl As %Library.String(COLLATION = "EXACT", MAXLEN = 1000) [ SqlColumnNumber = 21, SqlFieldName = HOSDC_PicUrl ];

Storage Default
{
<Data name="EnsHOSDocumentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HOSDDocumentID</Value>
</Value>
<Value name="3">
<Value>HOSDSerialNumber</Value>
</Value>
<Value name="4">
<Value>HOSDOrganId</Value>
</Value>
<Value name="5">
<Value>HOSDPatientID</Value>
</Value>
<Value name="6">
<Value>HOSDVisitNumber</Value>
</Value>
<Value name="7">
<Value>HOSDManufacturerID</Value>
</Value>
<Value name="8">
<Value>HOSDSubsysDocumentID</Value>
</Value>
<Value name="9">
<Value>HOSDClassificationCode</Value>
</Value>
<Value name="10">
<Value>HOSDTemplateVersionNumber</Value>
</Value>
<Value name="11">
<Value>HOSDTypeCode</Value>
</Value>
<Value name="12">
<Value>HOSDFormat</Value>
</Value>
<Value name="13">
<Value>HOSDStatus</Value>
</Value>
<Value name="14">
<Value>HOSDUpdateUserCode</Value>
</Value>
<Value name="15">
<Value>HOSDUpdateDate</Value>
</Value>
<Value name="16">
<Value>HOSDUpdateTime</Value>
</Value>
<Value name="17">
<Value>UpdateDate</Value>
</Value>
<Value name="18">
<Value>UpdateTime</Value>
</Value>
<Value name="19">
<Value>HOSDUrl</Value>
</Value>
<Value name="20">
<Value>HOSDCContent</Value>
</Value>
<Value name="21">
<Value>HOSDCPicUrl</Value>
</Value>
</Data>
<DataLocation>^Busi.ENS.EnsHOSDocumentD</DataLocation>
<DefaultData>EnsHOSDocumentDefaultData</DefaultData>
<IdLocation>^Busi.ENS.EnsHOSDocumentD</IdLocation>
<IndexLocation>^Busi.ENS.EnsHOSDocumentI</IndexLocation>
<StreamLocation>^Busi.ENS.EnsHOSDocumentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
