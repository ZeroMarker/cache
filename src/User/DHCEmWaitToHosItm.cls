Class User.DHCEmWaitToHosItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EW_RowID, SqlTableName = DHC_EmWaitToHosItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EWChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_EmWaitToHos Parent Reference EW_ParRef_Dr
Relationship EWParRefDr As User.DHCEmWaitToHos [ Cardinality = parent, Inverse = ChildDHCEMWAITTOHOSITM, Required, SqlFieldName = EW_ParRef_Dr ];

/// EW_ChildSub
Property EWChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = EW_ChildSub ];

/// 拟入院科室  EW_Loc_Dr
Property EWLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = EW_Loc_Dr ];

/// 会诊结果  EW_CsRes
Property EWCsRes As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EW_CsRes ];

/// 拟入院病区  EW_Ward_Dr
Property EWWardDr As User.PACWard [ SqlColumnNumber = 5, SqlFieldName = EW_Ward_Dr ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="EW_CsRes">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EW_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EW_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMWH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_EmWaitToHos.EW_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>EW_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_EmWaitToHos.EW_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EW_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmWaitToHosItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
