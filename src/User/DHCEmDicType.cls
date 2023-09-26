Class User.DHCEmDicType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmDicType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EM_Code  代码
Property EMCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EM_Code ];

/// EM_Desc  描述
Property EMDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EM_Desc ];

/// 是否可用  EM_ActiveFlag
Property EMActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = EM_ActiveFlag ];

/// 集团化医院  EM_Hosp_Dr
Property EMHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = EM_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEMDT)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEMDT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEMDT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EM_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCEMDT</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({EM_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_Hosp_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDicTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
