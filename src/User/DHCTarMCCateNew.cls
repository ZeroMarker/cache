/// 收费项 新病案首页子类
/// chenying add@20170927 使用原来的global,增加表
Class User.DHCTarMCCateNew Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TARMCCNew_RowId, SqlTableName = DHC_TarMCCateNew, StorageStrategy = SQLStorage ]
{

/// /// 修复原来数据：1. s ^DHCTarC("MCNew",0)=$o(^DHCTarC("MCNew",""),-1)  2. K ^DHCTARMRCATENEW   /  d ##class(User.DHCTarMCCateNew).%BuildIndices()
/// 数据^DHCTarC("MCNew")
/// 索引^DHCTARMRCATENEW(0,"Code") ,^DHCTARMRCATENEW(0,"Desc"),^DHCTARMRCATENEW(0,"TMC")
Parameter EXTENTSIZE = 250;

/// 代码
Property TARMCCNewCode As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TARMCCNew_Code ];

/// 描述
Property TARMCCNewDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TARMCCNew_Desc ];

/// 新病案首页大类
Property TARMCCNewTARTMCDR As User.DHCTarMCNew [ SqlColumnNumber = 4, SqlFieldName = TARMCCNew_TARTMC_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTarC("MCNew",0))</SqlIdExpression>
<SQLMap name="DHCTarECMaster">
<Data name="TARMCCNew_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TARMCCNew_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TARMCCNew_TARTMC_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCTarC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TARMCCNew_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"MCNew"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{TARMCCNew_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCTARMRCATENEW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARMCCNew_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARMCCNew_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARMCCNew_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCTARMRCATENEW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARMCCNew_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARMCCNew_Desc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARMCCNew_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTMC">
<Global>^DHCTARMRCATENEW</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TARMCCNew_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TMC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TARMCCNew_TARTMC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TARMCCNew_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>TARMCCNew_RowId</SqlRowIdName>
<StreamLocation>^User.DHCTarMCCateNewS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
