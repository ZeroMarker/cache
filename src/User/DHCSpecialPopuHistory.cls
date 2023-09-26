/// 基础数据平台-临床知识库-特殊人群与既往史关联表
Class User.DHCSpecialPopuHistory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SPEH_RowId, SqlTableName = DHC_SpecialPopuHistory, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPEHChildsub [ IdKey, PrimaryKey, Unique ];

Relationship SPEHPODr As DHCSpecialPopu [ Cardinality = parent, Inverse = ChildDHCSpecialPopuHistory, Required, SqlFieldName = SPEH_PO_Dr ];

/// Childsub
Property SPEHChildsub As %Float [ InitialExpression = {$i(^DHCSPEP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPEH",0))}, SqlColumnNumber = 2, SqlFieldName = SPEH_Childsub ];

Property SPEHDHDr As User.DHCDisHistoryFeild [ SqlColumnNumber = 3, SqlFieldName = SPEH_DH_Dr ];

Property SPEHActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPEH_ActiveFlag ];

Property SPEHSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SPEH_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPEH_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEH_DH_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEH_SysFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_SpecialPopu.SPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SPEH_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"DH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEH_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="HistoryIndex">
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SpecialPopu.SPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SPEH_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DH"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEH_DH_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPEH_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPEH_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSpecialPopuHistoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
