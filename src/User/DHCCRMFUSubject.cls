Class User.DHCCRMFUSubject Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = FUS_RowId, SqlTableName = DHC_CRM_FUSubject, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCCRMFUSDetail As User.DHCCRMFUSDetail [ Cardinality = children, Inverse = SDParRef ];

Relationship ChildDHCCRMFUSDiseases As User.DHCCRMFUSDiseases [ Cardinality = children, Inverse = SDISParRef ];

Relationship ChildDHCCRMFUSLoc As User.DHCCRMFUSLoc [ Cardinality = children, Inverse = SLParRef ];

/// FUS_Code
Property FUSCode As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = FUS_Code ];

/// FUS_Desc
Property FUSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = FUS_Desc ];

/// FUS_Diseases_Dr
Property FUSDiseasesDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = FUS_Diseases_Dr ];

/// FUS_DateLimit
Property FUSDateLimit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = FUS_DateLimit ];

/// FUS_DateBegin
Property FUSDateBegin As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = FUS_DateBegin ];

/// FUS_DateEnd
Property FUSDateEnd As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = FUS_DateEnd ];

Property FUSActive As %Library.String [ SqlFieldName = FUS_Active ];

/// 随访级别
Property FUSLevel As %Library.String [ SqlFieldName = FUS_Level ];

/// 链接主问卷
Property FUSLinkSubjectDR As User.DHCCRMFUSubject [ SqlFieldName = FUS_LinkSubject_DR ];

Index FUSCodeUnqIdx1 On FUSCode [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCCRMFUS)</SqlIdExpression>
<SQLMap name="DataMasterDHCCRMFUS">
<Data name="FUS_Active">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="FUS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FUS_DateBegin">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FUS_DateEnd">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FUS_DateLimit">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FUS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FUS_Diseases_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FUS_Level">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="FUS_LinkSubject_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCCRMFUS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FUS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{FUS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUS_Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({FUS_Code})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUS_Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({FUS_Desc})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDiseases">
<Global>^DHCCRMFUS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FUS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FUS_Diseases"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({FUS_Diseases_Dr})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{FUS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCCRMFUSubjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
