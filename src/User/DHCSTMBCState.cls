Class User.DHCSTMBCState Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MBCS_Rowid, SqlTableName = DHCST_MBCState, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MBCS_Number(10收药状态（住院门诊通用）20打印状态（住院门诊通用）30煎药状态（住院门诊通用）40煎药完成待接收状态（住院流程）50病区接收状态（住院流程）)
Property MBCSNumber As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = MBCS_Number ];

/// MBCS_Name
Property MBCSName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MBCS_Name ];

/// MBCS_Flag
Property MBCSFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = MBCS_Flag ];

/// MBCS_Type
Property MBCSType As %Library.String(DISPLAYLIST = ",Inpatient,Outpatient", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 5, SqlFieldName = MBCS_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCMBCSI</IdLocation>
<SqlIdExpression>$i(^DHCMBCS)</SqlIdExpression>
<SQLMap name="DATAMasterMBCState">
<Data name="MBCS_Flag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MBCS_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MBCS_Number">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MBCS_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCMBCS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MBCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MBCS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFlagNumber">
<Global>^DHCMBCS</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MBCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FN"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCS_Flag}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCS_Number}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MBCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCMBCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MBCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NAME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCS_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNumber">
<Global>^DHCMBCS</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MBCS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NUMBER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCS_Number}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeName">
<Global>^DHCMBCS</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPENAME"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCS_Name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeNumber">
<Global>^DHCMBCS</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TYPENUMBER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MBCS_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MBCS_Number}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MBCS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MBCS_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCSTMBCStateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
