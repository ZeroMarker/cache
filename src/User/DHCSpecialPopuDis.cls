/// 基础数据平台-临床知识库-特殊人群与病症关联表
Class User.DHCSpecialPopuDis Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SPED_RowId, SqlTableName = DHC_SpecialPopuDis, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPEDChildsub [ IdKey, PrimaryKey, Unique ];

Relationship SPEDPODr As DHCSpecialPopu [ Cardinality = parent, Inverse = ChildDHCSpecialPopuDis, Required, SqlFieldName = SPED_PO_Dr ];

/// Childsub
Property SPEDChildsub As %Float [ InitialExpression = {$i(^DHCSPEP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPED",0))}, SqlColumnNumber = 2, SqlFieldName = SPED_Childsub ];

Property SPEDDISDr As User.DHCPHDiseaseList [ SqlColumnNumber = 3, SqlFieldName = SPED_DIS_Dr ];

Property SPEDActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPED_ActiveFlag ];

Property SPEDSysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SPED_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPED_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPED_DIS_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPED_SysFlag">
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
<Field>SPED_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"DIS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{SPED_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="DisIndex">
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SpecialPopu.SPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SPED_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DIS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPED_DIS_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPED_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPED_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSpecialPopuDisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
