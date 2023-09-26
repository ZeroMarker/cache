Class User.DHCRBItemBookSave Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DIB_RowID, SqlTableName = DHCRB_ItemBookSave, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DIB_Paadm_DR
Property DIBPaadmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = DIB_Paadm_DR ];

/// DIB_ResSchdule_DR
Property DIBResSchduleDR As User.DHCRBCResSchdule [ SqlColumnNumber = 3, SqlFieldName = DIB_ResSchdule_DR ];

/// DIB_ArcItmMast_DR
Property DIBArcItmMastDR As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = DIB_ArcItmMast_DR ];

/// DIB_Resource_DR
Property DIBResourceDR As User.RBResource [ SqlColumnNumber = 5, SqlFieldName = DIB_Resource_DR ];

/// DIB_AppDate
Property DIBAppDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DIB_AppDate ];

/// DIB_AppTime
Property DIBAppTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = DIB_AppTime ];

/// DIB_IsUseResource
Property DIBIsUseResource As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DIB_IsUseResource ];

/// DIB_SaveDate
Property DIBSaveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = DIB_SaveDate ];

/// DIB_SaveTime
Property DIBSaveTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DIB_SaveTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBItemBookSave)</SqlIdExpression>
<SQLMap name="IndexPaadmdr">
<Global>^DHCRBItemBookSavei</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DIB_Paadm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DIB_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DIB_AppDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DIB_AppTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DIB_ArcItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DIB_IsUseResource">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DIB_Paadm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DIB_ResSchdule_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DIB_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DIB_SaveDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DIB_SaveTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCRBItemBookSave</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DIB_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DIB_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBItemBookSaveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
