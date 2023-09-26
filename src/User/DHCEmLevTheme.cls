Class User.DHCEmLevTheme Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LTH_RowID, SqlTableName = DHC_EmLevTheme, StorageStrategy = SQLStorage ]
{

/// 代码 LTH_Code	
Property LTHCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = LTH_Code ];

/// 描述 LTH_Desc	
Property LTHDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = LTH_Desc ];

/// 是否可用 LTH_ActiveFlag	
Property LTHActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LTH_ActiveFlag ];

/// 备注 LTH_Remark
Property LTHRemark As %Text(MAXLEN = 100) [ SqlColumnNumber = 5, SqlFieldName = LTH_Remark ];

/// 集团化医院 LTH_Hosp_Dr	
Property LTHHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = LTH_Hosp_Dr ];

/// 产品类型 LTH_ProType	
Property LTHProType As %Text(MAXLEN = 30) [ SqlColumnNumber = 7, SqlFieldName = LTH_ProType ];

Relationship ChildDHCEMLEVTHEITM As User.DHCEmLevTheItm [ Cardinality = children, Inverse = LTITheParRef ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMLTH)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMLTH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LTH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LTH_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LTH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LTH_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LTH_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LTH_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LTH_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LTH_ProType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LTH_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMLTH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LTH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LTH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmLevThemeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
