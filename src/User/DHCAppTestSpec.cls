Class User.DHCAppTestSpec Extends (%Persistent, User.Abstract) [ SqlRowIdName = ATS_RowID, SqlTableName = DHC_AppTestSpec, StorageStrategy = SQLStorage ]
{

/// 标本代码 ATS_Code
Property ATSCode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = ATS_Code ];

/// 标本描述 ATS_Desc
Property ATSDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ATS_Desc ];

/// 标本所属分类 ATS_Cat_Dr
Property ATSCatDr As User.DHCAppArcCat [ SqlColumnNumber = 4, SqlFieldName = ATS_Cat_Dr ];

/// 医院标识 ATS_Hosp_Dr
Property ATSHospDr As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = ATS_Hosp_Dr ];

/// 是否可用 ATS_ActiveFlag
Property ATSActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ATS_ActiveFlag ];

/// 是否可多选 ATS_MulFlag
Property ATSMulFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = ATS_MulFlag ];

/// 是否穿刺 ATS_CatIns
Property ATSCatIns As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ATS_CatIns ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTS)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPTS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ATS_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATS_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ATS_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATS_CatIns">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ATS_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATS_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATS_MulFlag">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCAPPTS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATS_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ATS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestSpecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
