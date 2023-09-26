Class User.DHCEQCSysGroupMenu Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GM_RowID, SqlTableName = DHC_EQCSysGroupMenu, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// GM_GroupDR
Property GMGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = GM_GroupDR ];

/// GM_MenuDR
Property GMMenuDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = GM_MenuDR ];

/// GM_RedefineParams
Property GMRedefineParams As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = GM_RedefineParams ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCSysGroupMenu",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="GM_GroupDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="GM_MenuDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GM_RedefineParams">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>GM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCSysGroupMenu"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{GM_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroupDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCSysGroupMenu"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GMGroupDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GM_GroupDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMenuDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>GM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCSysGroupMenu"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GMMenuDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GM_MenuDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{GM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCSysGroupMenuS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
