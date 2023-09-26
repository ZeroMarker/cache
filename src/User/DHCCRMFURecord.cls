Class User.DHCCRMFURecord Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FUR_RowId, SqlTableName = DHC_CRM_FURecord, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// FUR_FUP_DR
Property FURFUPDR As User.DHCCRMFUPlan [ SqlColumnNumber = 2, SqlFieldName = FUR_FUP_DR ];

/// FUR_PAADM_DR
Property FURPAADMDR As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = FUR_PAADM_DR ];

/// FUR_Subject_DR
Property FURSubjectDR As User.DHCCRMFUSubject [ SqlColumnNumber = 4, SqlFieldName = FUR_Subject_DR ];

/// FUR_SubjectDetail_DR
Property FURSubjectDetailDR As User.DHCCRMFUSDetail [ SqlColumnNumber = 5, SqlFieldName = FUR_SubjectDetail_DR ];

/// FUR_SubjectDetailResult
Property FURSubjectDetailResult As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = FUR_SubjectDetailResult ];

/// FUR_TemplateDesc
Property FURTemplateDesc As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = FUR_TemplateDesc ];

/// FUR_FUDate
Property FURFUDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = FUR_FUDate ];

/// FUR_FUTime
Property FURFUTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = FUR_FUTime ];

/// FUR_FUUser_DR
Property FURFUUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = FUR_FUUser_DR ];

/// FUR_Demo
Property FURDemo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = FUR_Demo ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMFUR)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMFUR">
<Data name="FUR_Demo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="FUR_FUDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FUR_FUP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FUR_FUTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="FUR_FUUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="FUR_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FUR_SubjectDetailResult">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FUR_SubjectDetail_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FUR_Subject_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FUR_TemplateDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCCRMFUR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFUDateTime">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_FUDateTime"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_FUDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_FUTime}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFUP">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_FUP_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_FUP_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFUUser">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_FUUser_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_FUUser_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_PAADM_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_PAADM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSDResult">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_SubjectDetailResult"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_SubjectDetailResult}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubject">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_Subject_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_Subject_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSubjectDetail">
<Global>^DHCCRMFUR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUR_SubjectDetail_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{FUR_SubjectDetail_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFURecordS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
