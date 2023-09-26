Class User.DHCPHBaseMedicine Extends (%Library.Persistent, User.Abstract) [ SqlRowIdName = PHB_Rowid, SqlTableName = DHC_PHBaseMedicine, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHB_ArcItm_Dr
Property PHBArcItmDr As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = PHB_ArcItm_Dr ];

/// PHB_Instruc_Dr
Property PHBInstrucDr As User.PHCInstruc [ SqlColumnNumber = 3, SqlFieldName = PHB_Instruc_Dr ];

/// PHB_DocLoc_Dr (开单科室)
Property PHBDocLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PHB_DocLoc_Dr ];

/// PHB_UseLoc_Dr (取药科室)
Property PHBUseLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = PHB_UseLoc_Dr ];

/// PHB_Note
Property PHBNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PHB_Note ];

/// PHB_Type
Property PHBType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PHB_Type ];

/// PHB_ExeLoc_Dr (使用科室/执行科室)
Property PHBExeLocDr As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = PHB_ExeLoc_Dr ];

/// PHB_UseFlag 使用标志
Property PHBUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 9, SqlFieldName = PHB_UseFlag ];

/// PHB_UseFlag 开单置基数药
Property PHBMakeOrderBaseFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PHB_MakeOrderBaseFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHBMED)</SqlIdExpression>
<SQLMap name="DataMasterDHCPHBMED">
<Data name="PHB_ArcItm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHB_DocLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHB_ExeLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHB_Instruc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHB_MakeOrderBaseFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHB_Note">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHB_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHB_UseFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHB_UseLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCPHBMED</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHB_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcLoc">
<Global>^DHCPHBMEDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHB_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ArcLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHB_ArcItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHB_DocLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexArcUseLoc">
<Global>^DHCPHBMEDI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHB_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ArcUseLoc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHB_ArcItm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHB_UseLoc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHB_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPHBaseMedicineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

/// 编译时判断是否需要重生计数器
ClassMethod SetSqlIdExpression() [ CodeMode = objectgenerator ]
{
    s newI = +$g(^DHCPHBMED)
    s oldI = +$g(^mdata("DHCPHBASEMEDICINE"))
    s maxI = $s(newI > oldI : newI, 1 : oldI)
    s ^DHCPHBMED = maxI
    s ^mdata("DHCPHBASEMEDICINE") = maxI
}

}
