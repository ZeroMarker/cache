/// 基础数据平台-临床知识库-特殊人群与检查结果关联表
Class User.DHCSpecialPopuExa Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = SPEE_RowId, SqlTableName = DHC_SpecialPopuExa, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPEEChildsub [ IdKey, PrimaryKey, Unique ];

Relationship SPEEPODr As DHCSpecialPopu [ Cardinality = parent, Inverse = ChildDHCSpecialPopuExa, Required, SqlFieldName = SPEE_PO_Dr ];

/// Childsub
Property SPEEChildsub As %Float [ InitialExpression = {$i(^DHCSPEP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPEE",0))}, SqlColumnNumber = 2, SqlFieldName = SPEE_Childsub ];

Property SPEEEXDr As User.DHCExamineFeild [ SqlColumnNumber = 3, SqlFieldName = SPEE_EX_Dr ];

Property SPEEActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SPEE_ActiveFlag ];

Property SPEESysFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SPEE_SysFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPEE_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPEE_EX_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SPEE_SysFlag">
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
<Field>SPEE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"EXA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="ExaIndex">
<Global>^DHCSPEP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_SpecialPopu.SPE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>SPEE_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EXA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPEE_EX_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_SpecialPopu.SPE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SPEE_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPEE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCSpecialPopuExaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
