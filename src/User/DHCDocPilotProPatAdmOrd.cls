Class User.DHCDocPilotProPatAdmOrd Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPPAO_RowId, SqlTableName = DHC_DocPilotProPatAdmOrd, StorageStrategy = SQLStorage ]
{

/// PPPAO_Adm_Dr
Property PPPAOAdmDr As User.DHCDocPilotProPatAdm [ SqlColumnNumber = 2, SqlFieldName = PPPAO_Adm_Dr ];

/// PPPAO_OEORI_Dr
Property PPPAOOEORIDr As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PPPAO_OEORI_Dr ];

/// PPPAO_AddUser_Dr
Property PPPAOAddUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = PPPAO_AddUser_Dr ];

/// PPPAO_AddDate
Property PPPAOAddDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PPPAO_AddDate ];

/// PPPAO_AddTime
Property PPPAOAddTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PPPAO_AddTime ];

/// PPPAO_LastUpdateDate
Property PPPAOLastUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PPPAO_LastUpdateDate ];

/// PPPAO_LastUpdateTime
Property PPPAOLastUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PPPAO_LastUpdateTime ];

/// PPPAO_LastUpdateTime
Property PPPAOLastUpdateUserDr As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PPPAO_LastUpdate_User_Dr ];

/// PPPAO_FreeOrdFlag
Property PPPAOFreeOrdFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PPPAO_FreeOrdFlag ];

/// 阶段
Property PPPAOStage As User.DHCDocPilotProStage [ SqlColumnNumber = 11, SqlFieldName = PPPAO_Stage ];

/// 访视外医嘱
Property PPPAOVisitFlag As %Library.String [ SqlColumnNumber = 12, SqlFieldName = PPPAO_VisitFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDocPPPAO(0))</SqlIdExpression>
<SQLMap name="IdxOeori">
<Global>^DHCDocPPPAO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PPPAO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OEORI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPPAO_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPPAO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndedxOEORIDr">
<Global>^DHCDocPPPAO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PPPAO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PPPAOOEORIDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPPAO_Adm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPPAO_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PPPAO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPPPAOAdmDr">
<Global>^DHCDocPPPAO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PPPAO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PPPAOAdmDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PPPAO_Adm_Dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPPAO_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="PPPAO_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPPAO_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPPAO_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPPAO_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPPAO_FreeOrdFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPPAO_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPPAO_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPPAO_LastUpdate_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPPAO_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPPAO_Stage">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPPAO_VisitFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCDocPPPAO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPPAO_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPPAO_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PPPAO_RowId</SqlRowIdName>
<StreamLocation>^User.DHCDocPilotProPatAdmOrdS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
