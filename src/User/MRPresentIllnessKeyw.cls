/// MR Pres Illness Keywords(1085)
Class User.MRPresentIllnessKeyw Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PresentIllnessKeyw, StorageStrategy = SQLStorage ]
{

/// Childsub
Property KEYWChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PRESI",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"KEYW",0))}, SqlColumnNumber = 2, SqlFieldName = KEYW_Childsub ];

/// Des Ref to MRCDKeyw
Property KEYWMRCDKeywDR As MRCPresIllKeywords [ SqlColumnNumber = 3, SqlFieldName = KEYW_MRCDKeyw_DR ];

/// MR_PresentIllness Parent Reference
Relationship KEYWParRef As MRPresentIllness [ Cardinality = parent, Inverse = ChildMRPresentIllnessKeyw, Required, SqlFieldName = KEYW_ParRef ];

Index RowIDBasedIDKeyIndex On KEYWChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 33;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPresentIllnessKeyw).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllnessKeyw","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPresentIllnessKeyw).OnTrigger($g(%d(1)))             
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllnessKeyw","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPresentIllnessKeyw).OnTrigger($g(%d(1))) 
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllnessKeyw","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPresentIllnessKeyw).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllnessKeyw","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPresentIllnessKeyw).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPresentIllnessKeyw","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>33</ExtentSize>
<Property name="KEYWChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWMRCDKeywDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="KEYWParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="KEYW_MRCDKeyw_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_PresentIllness.PRESI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRESI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_PresentIllness.PRESI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexKeywords">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MR_PresentIllness.PRESI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INDKEYW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_MRCDKeyw_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_PresentIllness.PRESI_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.MRPresentIllnessKeywS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
