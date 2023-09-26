Class User.DHCEmDocUpdReason Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DUR_RowID, SqlTableName = DHC_EmDocUpdReason, StorageStrategy = SQLStorage ]
{

/// 代码 
Property DURCode As %Library.Text(MAXLEN = 10) [ SqlColumnNumber = 2, SqlFieldName = DUR_Code ];

/// 描述
Property DURDesc As %Library.Text(MAXLEN = 50) [ SqlColumnNumber = 3, SqlFieldName = DUR_Desc ];

/// 是否启用
Property DURActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DUR_ActiveFlag ];

/// 医院
Property DURHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = DUR_Hosp_Dr ];

/// 类型
Property DURType As %String [ SqlColumnNumber = 6, SqlFieldName = DUR_Type ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMDUR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DUR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DUR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DUR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DUR_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DUR_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMDUR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DUR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DUR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMDUR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DUR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUR_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDocUpdReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
