Class User.DHCDisAsseItem Extends %Library.Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AI_RowId, SqlTableName = DHC_DisAsseItem, StorageStrategy = SQLStorage ]
{

/// 代码  AI_Code
Property AICode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = AI_Code ];

/// 描述  AI_Desc
Property AIDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = AI_Desc ];

/// 是否可用  AI_ActiveFlag
Property AIActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = AI_ActiveFlag ];

/// 集团化医院  AI_Hosp_Dr
Property AIHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = AI_Hosp_Dr ];

///   得分 AI_Score
Property AIScore As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = AI_Score ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISAI)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AI_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AI_Score">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCDISAI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AI_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Index">
<Global>^DHCDISAI</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AI_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AI_Score}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AI_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisAsseItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
