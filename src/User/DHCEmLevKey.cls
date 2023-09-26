Class User.DHCEmLevKey Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LK_RowID, SqlTableName = DHC_EmLevKey, StorageStrategy = SQLStorage ]
{

/// 代码 LK_Code	
Property LKCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = LK_Code ];

/// 描述 LK_Desc	
Property LKDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = LK_Desc ];

/// 是否可用 LK_ActiveFlag
Property LKActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LK_ActiveFlag ];

/// 备注 LK_Remark	
Property LKRemark As %Text(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = LK_Remark ];

/// 集团化医院 LK_Hosp_Dr
Property LKHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = LK_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMLK)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMLK</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LK_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LK_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LK_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LK_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LK_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LK_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LK_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LK_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMLK</Global>
<RowIdSpec name="1">
<Field>LK_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LK_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmLevKeyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
