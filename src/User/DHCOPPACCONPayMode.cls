Class User.DHCOPPACCONPayMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPM_RowID, SqlTableName = DHC_OPPACCONPayMode, StorageStrategy = SQLStorage ]
{

/// PPM_ADMR_DR
Property PPMADMRDR As User.PACAdmReason [ SqlColumnNumber = 2, SqlFieldName = PPM_ADMR_DR ];

/// PPM_PayMode_DR
Property PPMPayModeDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = PPM_PayMode_DR ];

/// PPM_IOType
Property PPMIOType As %Library.String(DISPLAYLIST = ",In Patient,Out Patient", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 4, SqlFieldName = PPM_IOType ];

/// PPM_DefPayMode
Property PPMDefPayMode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPM_DefPayMode ];

/// PPM_Note3
Property PPMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPM_Note3 ];

/// PPM_Note4
Property PPMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPM_Note4 ];

/// PPM_Note5
Property PPMNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PPM_Note5 ];

/// PPM_HospDR
Property PPMHospDR As User.CTHospital [ SqlColumnNumber = 9, SqlFieldName = PPM_HospDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPPARCONPMODE(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PPM_ADMR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPM_DefPayMode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPM_HospDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPM_IOType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPM_Note5">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCOPPARCONPMODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PPM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexADMRDR">
<Global>^DHCOPPARCONPMODEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADMRDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PPM_ADMR_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayModeDR">
<Global>^DHCOPPARCONPMODEi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PMDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PPM_PayMode_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PPM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPPACCONPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
