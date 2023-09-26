Class User.DHCWLACCDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACCDET_Rowid, SqlTableName = DHCWLACCDetail, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ACCDET_Account_Dr
Property ACCDETAccountDr As User.DHCWLAccount [ SqlColumnNumber = 2, SqlFieldName = ACCDET_Account_Dr ];

/// ACCDET_Type
Property ACCDETType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ACCDET_Type ];

/// ACCDET_Loc_Dr
Property ACCDETLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = ACCDET_Loc_Dr ];

/// ACCDET_Item_Dr
/// Property ACCDETItemDr As User.DHCWLSTItem [ SqlColumnNumber = 5, SqlFieldName = ACCDET_Item_Dr ];
Property ACCDETItemDr As DHCWL.CodeCfg.SubGroup [ SqlColumnNumber = 5, SqlFieldName = ACCDET_Item_Dr ];

/// ACCDET_Fee
Property ACCDETFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = ACCDET_Fee ];

/// ACCDET_PAADM_Dr
Property ACCDETPAADMDr As User.PAAdm [ SqlColumnNumber = 7, SqlFieldName = ACCDET_PAADM_Dr ];

/// ACCDET_DiscAmount
Property ACCDETDiscAmount As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ACCDET_DiscAmount ];

/// ACCDET_PayorShare
Property ACCDETPayorShare As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ACCDET_PayorShare ];

/// ACCDET_PatientShare
Property ACCDETPatientShare As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = ACCDET_PatientShare ];

/// ACCDET_Ward_Dr
Property ACCDETWardDr As User.PACWard [ SqlColumnNumber = 11, SqlFieldName = ACCDET_Ward_Dr ];

/// ACCDET_Doc_Dr
Property ACCDETDocDr As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = ACCDET_Doc_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWLACCDETAIL(0))</SqlIdExpression>
<SQLMap name="DataMast">
<Data name="ACCDET_Account_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACCDET_DiscAmount">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ACCDET_Doc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ACCDET_Fee">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACCDET_Item_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACCDET_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACCDET_PAADM_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACCDET_PatientShare">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ACCDET_PayorShare">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ACCDET_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACCDET_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCWLACCDETAIL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACCDET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ACCDET_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexACCType">
<Global>^DHCWLACCDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ACCDET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ACCType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACCDET_Account_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACCDET_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCDET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^DHCWLACCDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ACCDET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Account"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACCDET_Account_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCDET_Doc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ACCDET_Type}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ACCDET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCWLACCDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ACCDET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Account"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACCDET_Account_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCDET_Loc_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ACCDET_Type}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ACCDET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAADM">
<Global>^DHCWLACCDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ACCDET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Account"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACCDET_Account_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCDET_PAADM_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ACCDET_Type}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ACCDET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWard">
<Global>^DHCWLACCDETAIL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>ACCDET_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Account"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ACCDET_Account_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Ward"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACCDET_Ward_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ACCDET_Type}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ACCDET_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCWLACCDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
