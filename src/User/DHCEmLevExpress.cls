Class User.DHCEmLevExpress Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = LEX_RowID, SqlTableName = DHC_EmLevExpress, StorageStrategy = SQLStorage ]
{

/// 代码 LEX_Code	
Property LEXCode As %Text(MAXLEN = 5000) [ SqlColumnNumber = 2, SqlFieldName = LEX_Code ];

/// 描述 LEX_Desc	
Property LEXDesc As %Text(MAXLEN = 5000) [ SqlColumnNumber = 3, SqlFieldName = LEX_Desc ];

/// 表达式 LEX_Text
Property LEXText As %Text(MAXLEN = 5000) [ SqlColumnNumber = 4, SqlFieldName = LEX_Text ];

/// 是否可用 LEX_ActiveFlag	
Property LEXActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = LEX_ActiveFlag ];

/// 备注 LEX_Remark	
Property LEXRemark As %Text(MAXLEN = 100) [ SqlColumnNumber = 6, SqlFieldName = LEX_Remark ];

/// 集团化医院 LEX_Hosp_Dr	
Property LEXHospDr As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = LEX_Hosp_Dr ];

Storage Default
{
<Data name="DHCEmLevExpressDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LEXCode</Value>
</Value>
<Value name="3">
<Value>LEXDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmLevExpressD</DataLocation>
<DefaultData>DHCEmLevExpressDefaultData</DefaultData>
<IdLocation>^User.DHCEmLevExpressD</IdLocation>
<IndexLocation>^User.DHCEmLevExpressI</IndexLocation>
<SqlIdExpression>$i(^User.DHCEmLevExpressD)</SqlIdExpression>
<StreamLocation>^User.DHCEmLevExpressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.DHCEmLevExpressD)</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCEMLEX</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>LEX_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LEX_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LEX_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="LEX_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LEX_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LEX_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LEX_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LEX_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LEX_Text">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEMLEX</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>LEX_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{LEX_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmLevExpressS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
