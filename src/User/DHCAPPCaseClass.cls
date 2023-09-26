Class User.DHCAPPCaseClass Extends %Persistent [ Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ACC_RowId, SqlTableName = DHC_APPCaseClass, StorageStrategy = SQLStorage ]
{

/// 描述 ACC_Code
Property ACCCode As %String [ SqlColumnNumber = 2, SqlFieldName = ACC_Code ];

/// 代码 ACC_Desc
Property ACCDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ACC_Desc ];

/// 医院 ACC_Hosp_Dr
Property ACCHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = ACC_Hosp_Dr ];

/// 可用标志 ACC_ActiveFlag
Property ACCActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ACC_ActiveFlag ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPCC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ACC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ACC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCAPPCC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ACC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ACC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCAPPCC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ACC_Code})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCAPPCC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ACC_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ACC_Desc})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ACC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAPPCaseClassS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
