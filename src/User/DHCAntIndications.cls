Class User.DHCAntIndications Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAIND_Rowid, SqlTableName = DHC_Ant_Indications, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAIND_Code 代码
Property DAINDCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DAIND_Code ];

/// DAIND_Desc 描述
Property DAINDDesc As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = DAIND_Desc ];

/// DAIND_AUR_DR 关联抗生素使用原因
Property DAINDAURDR As DHCCTAntUseReason [ SqlColumnNumber = 4, SqlFieldName = DAIND_AUR_DR ];

/// DAIND_ActiveFlag 是否激活
Property DAINDActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DAIND_ActiveFlag ];

/// DAIND_Note 激活标志
Property DAINDNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DAIND_Note ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DAIND("DAIND"))</SqlIdExpression>
<SQLMap name="AURIndex">
<Global>^DAIND</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DAIND_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"AUR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAIND_AUR_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DAIND_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="DataMaster">
<Data name="DAIND_AUR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DAIND_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DAIND_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAIND_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DAIND_Note">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DAIND</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DAIND_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DAIND"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DAIND_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAntIndicationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
