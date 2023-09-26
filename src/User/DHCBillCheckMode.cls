Class User.DHCBillCheckMode Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DBCM_RowID, SqlTableName = DHC_BillCheckMode, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DBCM_Desc
Property DBCMDesc As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DBCM_Desc ];

/// DBCM_ClassName
Property DBCMClassName As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DBCM_ClassName ];

/// DBCM_MethodName
Property DBCMMethodName As %Library.String(TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DBCM_MethodName ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBILLCHECKMODE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DBCM_ClassName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DBCM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DBCM_MethodName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCBILLCHECKMODE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DBCM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DBCM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCBillCheckModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
