Class User.DHCSTMBCCollDrug Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MBC_RowId, SqlTableName = DHCST_MBCCollDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCSTMBCCollDrugItem As User.DHCSTMBCCollDrugItem [ Cardinality = children, Inverse = MBCIParref ];

/// MBC_PrescNo
Property MBCPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MBC_PrescNo ];

/// MBC_Adm_Dr
Property MBCAdmDr As User.PAAdm [ SqlColumnNumber = 3, SqlFieldName = MBC_Adm_Dr ];

/// MBC_Facotor
Property MBCFacotor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MBC_Facotor ];

/// MBC_Pointer
Property MBCPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MBC_Pointer ];

/// MBC_State_Dr
Property MBCStateDr As User.DHCSTMBCState [ SqlColumnNumber = 6, SqlFieldName = MBC_State_Dr ];

/// MBC_OrdDate
Property MBCOrdDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = MBC_OrdDate ];

/// MBC_OrdTime
Property MBCOrdTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = MBC_OrdTime ];

/// MBC_Type
Property MBCType As %Library.String(DISPLAYLIST = ",Inpatient,Outpatient", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 9, SqlFieldName = MBC_Type ];

/// MBC_LocDr
Property MBCLocDr As CTLoc [ SqlColumnNumber = 10, SqlFieldName = MBC_LocDr ];

/// MBC_Complete
Property MBCComplete As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = MBC_Complete ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMBC)</SqlIdExpression>
<SQLMap name="DataMasterMBC">
<Data name="MBC_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MBC_Complete">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MBC_Facotor">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MBC_LocDr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MBC_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MBC_OrdTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MBC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MBC_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MBC_State_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MBC_Type">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCMBC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MBC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdm">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexAdmPresc">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMPRESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_PrescNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_OrdDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDr">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_LocDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPoint">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POINT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Pointer}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPresc">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MBC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexState">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_State_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStateLoc">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"STATELOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_State_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_LocDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPEDATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_OrdDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeLocDr">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPELOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_LocDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePoint">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPEPOINT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePresc">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPEPRESC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_PrescNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeState">
<Global>^DHCMBC</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPESTATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBC_State_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCSTMBCCollDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
