Class User.DHCCRMQRecordDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = QRD_RowId, SqlTableName = DHC_CRM_QRecordDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On QRDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_CRM_QRecord Parent Reference
Relationship QRDParRef As User.DHCCRMQRecord [ Cardinality = parent, Inverse = ChildDHCCRMQRecordDetail, Required, SqlFieldName = QRD_ParRef ];

/// QRD_ChildSub
Property QRDChildSub As %Library.Float [ InitialExpression = {$i(^DHCCRMQR($p(%d(0),$c(1),1),"Detail",0))}, Required, SqlColumnNumber = 2, SqlFieldName = QRD_ChildSub ];

/// QRD_Subject_DR
Property QRDSubjectDR As User.DHCCRMFUSubject [ SqlColumnNumber = 3, SqlFieldName = QRD_Subject_DR ];

/// QRD_SubjectDetail_DR
Property QRDSubjectDetailDR As User.DHCCRMFUSDetail [ SqlColumnNumber = 4, SqlFieldName = QRD_SubjectDetail_DR ];

/// QRD_SubjectDetailResult
Property QRDSubjectDetailResult As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = QRD_SubjectDetailResult ];

/// QRD_TemplateDesc
Property QRDTemplateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = QRD_TemplateDesc ];

/// QRD_UpdateDate
Property QRDUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = QRD_UpdateDate ];

/// QRD_UpdateTime
Property QRDUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = QRD_UpdateTime ];

/// QRD_UpdateUser_DR
Property QRDUpdateUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = QRD_UpdateUser_DR ];

/// QRD_Demo
Property QRDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = QRD_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterDHCCRMQR">
<Data name="QRD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QRD_SubjectDetailResult">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QRD_SubjectDetail_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QRD_Subject_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QRD_TemplateDesc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QRD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QRD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QRD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCCRMQR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_CRM_QRecord.QR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>QRD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_QRecord.QR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Detail"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{QRD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSubject">
<Global>^DHCCRMQR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_CRM_QRecord.QR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>QRD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QRD_Subject_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{QRD_Subject_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_QRecord.QR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{QRD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubjectDetail">
<Global>^DHCCRMQR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_CRM_QRecord.QR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>QRD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QRD_SubjectDetail_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{QRD_SubjectDetail_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_CRM_QRecord.QR_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{QRD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMQRecordDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
