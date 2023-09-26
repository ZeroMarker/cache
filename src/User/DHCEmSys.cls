Class User.DHCEmSys Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = SY_RowID, SqlTableName = DHC_EmSys, StorageStrategy = SQLStorage ]
{

/// 代码 SY_Code
Property SYCode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = SY_Code ];

/// 描述 SY_Desc	
Property SYDesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = SY_Desc ];

/// 标识 SY_GroupName	
Property SYGroupName As %Text(MAXLEN = 30) [ SqlColumnNumber = 4, SqlFieldName = SY_GroupName ];

/// 是否可用  SY_ActiveFlag
Property SYActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SY_ActiveFlag ];

/// 集团化医院  SY_Hosp_Dr
Property SYHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = SY_Hosp_Dr ];

Relationship ChildDHCEMSYSITM As User.DHCEmSysItm [ Cardinality = children, Inverse = SYParRefDr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMS)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SY_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SY_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SY_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="SY_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SY_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SY_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SY_GroupName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SY_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCEMS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SY_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SY_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmSysS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
