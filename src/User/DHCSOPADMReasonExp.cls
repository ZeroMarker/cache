Class User.DHCSOPADMReasonExp Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SARE_RowID, SqlTableName = DHC_SOPADMReasonExp, StorageStrategy = SQLStorage ]
{

/// SARE_ADMReason_DR
Property SAREADMReasonDR As User.PACAdmReason [ SqlColumnNumber = 2, SqlFieldName = SARE_ADMReason_DR ];

/// SARE_UseFareType
Property SAREUseFareType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SARE_UseFareType ];

/// SARE_Note1
Property SARENote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SARE_Note1 ];

/// SARE_Note2
Property SARENote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SARE_Note2 ];

/// SARE_Note3
Property SARENote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SARE_Note3 ];

/// SARE_Note4
Property SARENote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SARE_Note4 ];

/// SARE_Note5
Property SARENote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SARE_Note5 ];

/// SARE_HospDR
Property SAREHospDR As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = SARE_HospDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCSOPADMRExp)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SARE_ADMReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SARE_HospDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SARE_Note1">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SARE_Note2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SARE_Note3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SARE_Note4">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SARE_Note5">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SARE_UseFareType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSOPADMRExp</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SARE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{SARE_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexADMReasonDR">
<Global>^DHCSOPADMRExpi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SARE_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADMR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SARE_ADMReason_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SARE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSOPADMReasonExpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
