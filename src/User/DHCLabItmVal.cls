/// 基础数据平台-临床知识库-检验项目与指标关联表
Class User.DHCLabItmVal Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = PHLFI_RowId, SqlTableName = DHC_LabItmVal, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PHLFIChildsub [ IdKey, PrimaryKey, Unique ];

Relationship PHLFIParRefDr As DHCLabItmFeild [ Cardinality = parent, Inverse = ChildDHCLabItmVal, Required, SqlFieldName = PHLFI_ParRef_Dr ];

/// Childsub
Property PHLFIChildsub As %Float [ InitialExpression = {$i(^DHCLABIF($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PHLFI",0))}, SqlColumnNumber = 2, SqlFieldName = PHLFI_Childsub ];

Property PHLFIGenDr As User.DHCPHExtGeneric [ SqlColumnNumber = 3, SqlFieldName = PHLFI_Gen_Dr ];

Property PHLFIVal As %String(DISPLAYLIST = ",高,低,正常,包含,阴性,阳性", VALUELIST = ",H,L,N,I,NT,PT") [ SqlColumnNumber = 4, SqlFieldName = PHLFI_Val ];

Property PHLFIRelation As %String(DISPLAYLIST = ",Or,And", VALUELIST = ",O,A") [ SqlColumnNumber = 5, SqlFieldName = PHLFI_Relation ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PHLFI_Gen_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHLFI_Relation">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHLFI_Val">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCLABIF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LabItmFeild.PHLF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PHLFI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_LabItmFeild.PHLF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"VAL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLFI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="GenIndex">
<Global>^DHCLABIF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LabItmFeild.PHLF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PHLFI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VAL"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHLFI_Gen_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LabItmFeild.PHLF_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PHLFI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PHLFI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCLabItmValS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
