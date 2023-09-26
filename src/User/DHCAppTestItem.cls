Class User.DHCAppTestItem Extends %Persistent [ SqlRowIdName = ATI_RowID, SqlTableName = DHC_AppTestItem, StorageStrategy = SQLStorage ]
{

/// 项目代码 ATI_Code
Property ATICode As %Text(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = ATI_Code ];

/// 项目描述 ATI_Desc
Property ATIDesc As %Text(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = ATI_Desc ];

/// 医嘱子类 ATI_Arc_Dr
Property ATIArcDr As User.ARCItmMast [ SqlColumnNumber = 4, SqlFieldName = ATI_Arc_Dr ];

/// 医院标识 ATI_Hosp_Dr
Property ATIHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = ATI_Hosp_Dr ];

/// 是否可用 ATI_ActiveFlag
Property ATIActiveFlag As %String(DISPLAYLIST = ",Y,N", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = ATI_ActiveFlag ];

/// 检查分类 ATI_Cat_Dr
Property ATICatDr As User.DHCAppArcCat [ SqlColumnNumber = 7, SqlFieldName = ATI_Cat_Dr ];

/// 检测分类 ATI_TestCat_Dr
Property ATITestCatDr As User.DHCAppTestCat [ SqlColumnNumber = 8, SqlFieldName = ATI_TestCat_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPTI)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCAPPTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP^SSUTIL4({ATI_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPTI</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP^SSUTIL4({ATI_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="ATI_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATI_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATI_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ATI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATI_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATI_TestCat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCAPPTI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATI_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ATI_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppTestItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
