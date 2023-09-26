/// 基础数据平台-临床知识库-特殊人群与检验指标关联表
Class User.DHCSpecialPopuLab Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SPEL_RowId, SqlTableName = DHC_SpecialPopuLab, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPELChildsub [ IdKey, PrimaryKey, Unique ];

Relationship SPELPODr As DHCSpecialPopu [ Cardinality = parent, Inverse = ChildDHCSpecialPopuLab, Required, SqlFieldName = SPEL_PO_Dr ];

/// Childsub
Property SPELChildsub As %Float [ InitialExpression = {$i(^DHCSPEP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPEL",0))}, SqlColumnNumber = 2, SqlFieldName = SPEL_Childsub ];

Property SPELPhyDr As User.DHCLabItmFeild [ SqlColumnNumber = 3, SqlFieldName = SPEL_Phy_Dr ];

Property SPELActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPEL_ActiveFlag ];

Property SPELSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SPEL_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPEL_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEL_Phy_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEL_SysFlag">
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
<Field>SPEL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"LAB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="LabIndex">
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SpecialPopu.SPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SPEL_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LAB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEL_Phy_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPEL_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPEL_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSpecialPopuLabS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
