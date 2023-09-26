/// Body Parts Symptoms    (MRBPS,1067)
Class User.MRCBodyPartsSymptoms Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodyPartsSymptoms, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCBodyPartsSympSubsym As MRCBodyPartsSympSubsym [ Cardinality = children, Inverse = SUBSParRef ];

/// Childsub
Property SYMChildsub As %Float [ InitialExpression = {$i(^MRC("BODP",$p(%d(0),$c(1)),"SYM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = SYM_Childsub ];

/// Code
Property SYMCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SYM_Code ];

/// Description
Property SYMDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SYM_Desc ];

/// MRC_BodyParts Parent Reference
Relationship SYMParRef As MRCBodyParts [ Cardinality = parent, Inverse = ChildMRCBodyPartsSymptoms, Required, SqlFieldName = SYM_ParRef ];

Index RowIDBasedIDKeyIndex On SYMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 696;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodyPartsSymptoms).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSymptoms","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodyPartsSymptoms).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSymptoms","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodyPartsSymptoms).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSymptoms","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodyPartsSymptoms).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSymptoms","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodyPartsSymptoms).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSymptoms","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>696</ExtentSize>
<Property name="SYMChildsub">
<Selectivity>1.5152%</Selectivity>
</Property>
<Property name="SYMCode">
<Selectivity>0.2632%</Selectivity>
</Property>
<Property name="SYMDesc">
<Selectivity>0.2375%</Selectivity>
</Property>
<Property name="SYMParRef">
<Selectivity>1.5873%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SYM_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SYM_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_BodyParts.BODP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SYM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_BodyParts.BODP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SYM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SYM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SYM_RowId</SqlRowIdName>
<StreamLocation>^User.MRCBodyPartsSymptomsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
