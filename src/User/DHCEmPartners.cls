Class User.DHCEmPartners Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = PA_RowID, SqlTableName = DHC_EmPartners, StorageStrategy = Storage ]
{

/// 代码  PA_Code
Property PACode As %Text(MAXLEN = 30) [ SqlColumnNumber = 2, SqlFieldName = PA_Code ];

/// 描述  PA_Desc
Property PADesc As %Text(MAXLEN = 30) [ SqlColumnNumber = 3, SqlFieldName = PA_Desc ];

/// 是否可用  PA_ActiveFlag
Property PAActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PA_ActiveFlag ];

/// 集团化医院  PA_Hosp_Dr
Property PAHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PA_Hosp_Dr ];

Storage Default
{
<Data name="DHCEmPartnersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PACode</Value>
</Value>
<Value name="3">
<Value>PADesc</Value>
</Value>
<Value name="4">
<Value>PAActiveFlag</Value>
</Value>
<Value name="5">
<Value>PAHospDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPartnersD</DataLocation>
<DefaultData>DHCEmPartnersDefaultData</DefaultData>
<IdLocation>^User.DHCEmPartnersD</IdLocation>
<IndexLocation>^User.DHCEmPartnersI</IndexLocation>
<SqlIdExpression>$i(^User.DHCEmPartnersD)</SqlIdExpression>
<StreamLocation>^User.DHCEmPartnersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage Storage
{
<SQLMap name="DataMaster">
<Data name="PA_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PA_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMPA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexcode">
<Global>^DHCEMPA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPartnersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
