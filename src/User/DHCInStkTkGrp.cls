/// Relate DHC_InStkTk And  DHC_LocManG
Class User.DHCInStkTkGrp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TG_RowId, SqlTableName = DHC_InStkTkGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On TGChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_InStkTk Parent Reference
Relationship TGINSTParRef As User.DHCInStkTk [ Cardinality = parent, Inverse = ChildDHCInStkTkGrp, Required, SqlFieldName = TG_INST_ParRef ];

/// TG_Childsub
Property TGChildsub As %Library.Float [ InitialExpression = {$i(^DHCINST($p(%d(0),$c(1)),"TG",0))}, Required, SqlColumnNumber = 2, SqlFieldName = TG_Childsub ];

/// TG_LMG_DR
Property TGLMGDR As User.DHCLocManGrp [ SqlColumnNumber = 3, SqlFieldName = TG_LMG_DR ];

/// 是否包含此管理组 Y包含 N不包含
Property TGIFInclud As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = TG_IFInclud ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="TG_IFInclud">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TG_LMG_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCINST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>TG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TG"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TG_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCINST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_InStkTk.INST_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>TG_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TGGRP"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{TG_LMG_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_InStkTk.INST_RowId}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{TG_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCInStkTkGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
