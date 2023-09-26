/// GenericRtFormsTherCat(2619)
Class User.PHCGenericRtFormsTherCat Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PHC_GenericRtFormsTherCat, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On THCChildsub [ IdKey, PrimaryKey, Unique ];

/// PHC_GenericRtForms Parent Reference
Relationship THCParRef As PHCGenericRtForms [ Cardinality = parent, Inverse = ChildPHCGenericRtFormsTherCat, Required, SqlFieldName = THC_ParRef ];

/// Childsub
Property THCChildsub As %Float [ InitialExpression = {$i(^PHCGE("GE",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"RTF",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"THC",0))}, SqlColumnNumber = 2, SqlFieldName = THC_Childsub ];

/// Des Ref TherCateg
Property THCTherCategDR As PHCTheraputicCateg [ SqlColumnNumber = 3, SqlFieldName = THC_TherCateg_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsTherCat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsTherCat","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsTherCat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsTherCat","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PHCGenericRtFormsTherCat).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsTherCat","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PHCGenericRtFormsTherCat).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsTherCat","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PHCGenericRtFormsTherCat).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PHCGenericRtFormsTherCat","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="THC_TherCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PHCGE</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_GenericRtForms.RTF_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>THC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_GenericRtForms.RTF_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"THC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{THC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTherCat">
<Global>^PHCGE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHC_Generic.PHCGE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PHC_GenericRtForms.RTF_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>THC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHC_Generic.PHCGE_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RTF"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHC_GenericRtForms.RTF_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"THC"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ThCat"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{THC_TherCateg_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{THC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>THC_RowId</SqlRowIdName>
<StreamLocation>^User.PHCGenericRtFormsTherCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
