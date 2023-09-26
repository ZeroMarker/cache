Class User.DHCOPApproved Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPA_RowID, SqlTableName = DHC_OPApproved, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPA_DateFrom
Property OPADateFrom As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OPA_DateFrom ];

/// OPA_DateTo
Property OPADateTo As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = OPA_DateTo ];

/// OPA_DisAppAR_Dr
Property OPADisAppARDr As User.PACAdmReason [ SqlColumnNumber = 4, SqlFieldName = OPA_DisAppAR_Dr ];

/// OPA_OPAC_Dr
Property OPAOPACDr As User.DHCOPAppCon [ SqlColumnNumber = 5, SqlFieldName = OPA_OPAC_Dr ];

/// OPA_OrdAppAR_Dr
Property OPAOrdAppARDr As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = OPA_OrdAppAR_Dr ];

/// OPA_PatAdmAR_Dr
Property OPAPatAdmARDr As User.PACAdmReason [ SqlColumnNumber = 2, SqlFieldName = OPA_PatAdmAR_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPApproved)</SqlIdExpression>
<SQLMap name="dataDHCOPApproved">
<Data name="OPA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPA_DisAppAR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPA_OPAC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPA_OrdAppAR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPA_PatAdmAR_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCOPApproved</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OPA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexOrdAppAr">
<Global>^DHCOPApproved</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrdAppAR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPA_PatAdmAR_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPA_OrdAppAR_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{OPA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPApprovedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
