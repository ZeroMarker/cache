/// 收费项 新病案首页大类
/// chenying add@20170927 使用原来的global,增加表
Class User.DHCTarMCNew Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TARTMCNew_RowId, SqlTableName = DHC_TarMCNew, StorageStrategy = SQLStorage ]
{

/// 修复原来数据：1. s ^DHCTarC("TMCNew",0)=$o(^DHCTarC("TMCNew",""),-1)  2. K ^DHCTARMCNEW   /d ##class(User.DHCTarMCNew).%BuildIndices()
/// 数据^DHCTarC("TMCNew")
/// 索引^DHCTARMCNEW(0,"Code") ,^DHCTARMCNEW(0,"Desc")
Parameter EXTENTSIZE = 250;

/// 代码
Property TARTMCNewCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TARTMCNew_Code ];

/// 描述
Property TARTMCNewDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TARTMCNew_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTarC("TMCNew",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TARTMCNew_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TARTMCNew_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCTarC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TARTMCNew_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"TMCNew"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{TARTMCNew_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCTARMCNEW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARTMCNew_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARTMCNew_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARTMCNew_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCTARMCNEW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARTMCNew_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARTMCNew_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARTMCNew_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TARTMCNew_RowId</SqlRowIdName>
<StreamLocation>^User.DHCTarMCNewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
