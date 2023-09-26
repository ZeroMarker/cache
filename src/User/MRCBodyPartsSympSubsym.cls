/// MRC BodyPartsSympSubsym(1328)
Class User.MRCBodyPartsSympSubsym Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodyPartsSympSubsym, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SUBSChildsub As %Float [ InitialExpression = {$i(^MRC("BODP",$p(%d(0),"||"),"SYM",$p(%d(0),"||",2),"SUBS",0))}, SqlColumnNumber = 2, SqlFieldName = SUBS_Childsub ];

/// Code
Property SUBSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SUBS_Code ];

/// Description
Property SUBSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SUBS_Desc ];

/// MRC_BodyPartsSymptoms Parent Reference
Relationship SUBSParRef As MRCBodyPartsSymptoms [ Cardinality = parent, Inverse = ChildMRCBodyPartsSympSubsym, Required, SqlFieldName = SUBS_ParRef ];

Index RowIDBasedIDKeyIndex On SUBSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2452;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodyPartsSympSubsym).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSympSubsym","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodyPartsSympSubsym).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSympSubsym","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodyPartsSympSubsym).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSympSubsym","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodyPartsSympSubsym).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSympSubsym","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodyPartsSympSubsym).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodyPartsSympSubsym","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2452</ExtentSize>
<Property name="SUBSChildsub">
<Selectivity>3.6895%</Selectivity>
</Property>
<Property name="SUBSCode">
<Selectivity>0.1329%</Selectivity>
</Property>
<Property name="SUBSDesc">
<Selectivity>2.2448%</Selectivity>
</Property>
<Property name="SUBSParRef">
<Selectivity>0.8377%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SUBS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBS_Desc">
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
<Field>MRC_BodyPartsSymptoms.SYM_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SUBS_Childsub</Field>
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
<Expression>{MRC_BodyPartsSymptoms.SYM_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SUBS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUBS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUBS_RowId</SqlRowIdName>
<StreamLocation>^User.MRCBodyPartsSympSubsymS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
