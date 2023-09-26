Class User.DHCAPPSpecSlideType Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AST_RowId, SqlTableName = DHC_APPSpecSlideType, StorageStrategy = SQLStorage ]
{

/// 描述 AST_Code
Property ASTCode As %String [ SqlColumnNumber = 2, SqlFieldName = AST_Code ];

/// 代码 AST_Desc
Property ASTDesc As %String [ SqlColumnNumber = 3, SqlFieldName = AST_Desc ];

/// 医院 AST_Hosp_Dr
Property ASTHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = AST_Hosp_Dr ];

/// 可用标志 AST_ActiveFlag`
Property ASTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = AST_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPSST)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AST_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AST_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPSST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPSST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AST_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPSST</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AST_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({AST_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAPPSpecSlideTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
