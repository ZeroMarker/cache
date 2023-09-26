Class User.DHCLocDiagnose Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LocDia_Rowid, SqlTableName = DHC_LocDiagnose, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// LocDia_CTLoc_DR
Property LocDiaCTLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LocDia_CTLoc_DR ];

/// LocDia_MRICD_Dr
Property LocDiaMRCICDDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LocDia_MRCICD_Dr ];

/// LocDia_Sort
Property LocDiaSort As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = LocDia_Sort ];

/// LocDia_CTLoc_DR
Property LocDiaUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LocDia_User_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCLocDiagnose)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LocDia_CTLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LocDia_MRCICD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LocDia_Sort">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LocDia_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCLocDiagnose</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LocDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{LocDia_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^DHCLocDiagnoseI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>LocDia_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"Location"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{LocDia_CTLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{LocDia_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCLocDiagnoseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
