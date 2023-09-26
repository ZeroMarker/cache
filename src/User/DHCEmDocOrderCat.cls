Class User.DHCEmDocOrderCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DOC_RowID, SqlTableName = DHC_EmDocOrderCat, StorageStrategy = SQLStorage ]
{

/// 序号 
Property DOCNumber As %Library.Integer [ SqlColumnNumber = 2, SqlFieldName = DOC_Number ];

/// 医嘱大类
Property DOCOecDr As User.OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = DOC_Oec_Dr ];

/// 是否启用
Property DOCActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DOC_ActiveFlag ];

/// 医院
Property DOCHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = DOC_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMDOCA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DOC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOC_Number">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOC_Oec_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMDOCA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DOC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOec">
<Global>^DHCEMDOCA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexOec"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOC_Oec_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmOnlyDocAdviceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
