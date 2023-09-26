Class User.DHCCTAntUsePurpose Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DTAUP_Rowid, SqlTableName = DHC_CT_AntUsePurpose, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DTAUP_Code
Property DTAUPCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DTAUP_Code ];

/// DTAUP_Desc
Property DTAUPDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DTAUP_Desc ];

/// DTAUP_ActiveFlag
Property DTAUPActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DTAUP_ActiveFlag ];

/// DTAUP_Desc
Property DTAUPAURDR As User.DHCCTAntUseReason [ SqlColumnNumber = 5, SqlFieldName = DTAUP_AUR_DR ];

/// DTAUP_ReqStr
Property DTAUPReqStr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DTAUP_ReqStr ];

/// DTAUP_Note
Property DTAUPNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DTAUP_Note ];

/// DTAUP_PurposeItem_Dr  2013-2-2
Property DTAUPPurposeItemDr As User.DHCCTAntUseReasonItem [ SqlColumnNumber = 8, SqlFieldName = DTAUP_PurposeItem_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DTAUP("AUP"))</SqlIdExpression>
<SQLMap name="AUPIndex">
<Global>^DTAUP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DTAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DTAUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DTAUP_AUR_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DTAUP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DTAUP_AUR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DTAUP_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DTAUP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DTAUP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DTAUP_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DTAUP_PurposeItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DTAUP_ReqStr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DTAUP</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DTAUP_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DTAUP_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCCTAntUsePurposeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
