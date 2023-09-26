Class User.DHCEQCManageLimitList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MLL_RowID, SqlTableName = DHC_EQCManageLimitList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// MLL_AccessFlag
Property MLLAccessFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = MLL_AccessFlag ];

/// MLL_ManageLimitDR
Property MLLManageLimitDR As User.DHCEQCManageLimit [ SqlColumnNumber = 2, SqlFieldName = MLL_ManageLimitDR ];

/// MLL_Type
Property MLLType As %Library.String(DISPLAYLIST = ",类组,类型,分类,科室,设备,设备项", MAXLEN = 5, SELECTIVITY = "14.2857%", VALUELIST = ",1,2,3,4,5,6") [ SqlColumnNumber = 3, SqlFieldName = MLL_Type ];

/// MLL_Value
Property MLLValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MLL_Value ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCManageLimitList",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MLL_AccessFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MLL_ManageLimitDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MLL_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MLL_Value">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCManageLimitList"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{MLL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccessFlag">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCManageLimitList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AccessFlag"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MLL_ManageLimitDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MLL_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MLL_AccessFlag}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLimitValue">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCManageLimitList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LimitValue"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MLL_ManageLimitDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MLL_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MLL_Value}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexValue">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCManageLimitList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Value"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MLL_Value}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexlimit">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MLL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCManageLimitList"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LimitDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MLL_ManageLimitDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MLL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCManageLimitListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
