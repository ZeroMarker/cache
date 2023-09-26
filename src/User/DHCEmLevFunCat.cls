Class User.DHCEmLevFunCat Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LFC_RowID, SqlTableName = DHC_EmLevFunCat, StorageStrategy = SQLStorage ]
{

/// 代码  LFC_Code
Property LFCCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = LFC_Code ];

/// 描述  LFC_Desc
Property LFCDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = LFC_Desc ];

/// 是否可用  LFC_ActiveFlag
Property LFCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LFC_ActiveFlag ];

/// 备注  LFC_Remark
Property LFCRemark As %Text(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = LFC_Remark ];

/// 集团化医院  LFC_Hosp_Dr
Property LFCHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = LFC_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMLFC)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMLFC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LFC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LFC_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LFC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LFC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LFC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LFC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LFC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LFC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMLFC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LFC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LFC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmLevFunCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
