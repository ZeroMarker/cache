/// 住院药房针对医嘱子类的设置
Class User.PHAIPLocArcCat Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = PHAIP_LocArcCat, StorageStrategy = CacheSQLStorage ]
{

/// 药房
Property PLACLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PLAC_Loc_Dr ];

/// 医嘱子类
Property PLACArcCatDr As User.ARCItemCat [ SqlColumnNumber = 3, SqlFieldName = PLAC_ArcCat_Dr ];

/// 不需要领药审核
Property PLACPassAudit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PLAC_PassAudit ];

Storage CacheSQLStorage
{
<SqlIdExpression>$i(^CF.PHA.IP.LOCARCCAT(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PLAC_ArcCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PLAC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PLAC_PassAudit">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CF.PHA.IP.LOCARCCAT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PLAC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PLAC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocCat">
<Global>^CF.PHA.IP.LOCARCCATi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PLAC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"LOCARCCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PLAC_Loc_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PLAC_ArcCat_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PLAC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PLAC_RowId</SqlRowIdName>
<StreamLocation>^User.PHAIPLocArcCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
