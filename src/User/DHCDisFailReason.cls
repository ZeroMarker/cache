Class User.DHCDisFailReason Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = FR_RowID, SqlTableName = DHC_DisFailReason, StorageStrategy = SQLStorage ]
{

/// 代码  FR_Code
Property FRCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = FR_Code ];

/// 描述  FR_Desc
Property FRDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = FR_Desc ];

/// 是否可用  FR_ActiveFlag
Property FRActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = FR_ActiveFlag ];

/// 集团化医院  FR_Hosp_Dr
Property FRHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = FR_Hosp_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISFR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="FR_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="FR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FR_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISFR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>FR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{FR_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCDISFR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>FR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FR_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisFailReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
