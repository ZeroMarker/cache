/// MRC ICD Alias(1895)
Class User.MRCICDAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ICDAlias, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ALIASChildsub As %Float [ InitialExpression = {$i(^MRC("ID",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ALIAS",0))}, SqlColumnNumber = 2, SqlFieldName = ALIAS_Childsub ];

/// MRC_ICDDx Parent Reference
Relationship ALIASParRef As MRCICDDx [ Cardinality = parent, Inverse = ChildMRCICDAlias, Required, SqlFieldName = ALIAS_ParRef ];

/// Text
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALIAS_Text ];

Index RowIDBasedIDKeyIndex On ALIASChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 6;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCICDAlias).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDAlias","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCICDAlias).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDAlias","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCICDAlias).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDAlias","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCICDAlias).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDAlias","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCICDAlias).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCICDAlias","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>6</ExtentSize>
<Property name="ALIASChildsub">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ALIASParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ALIASText">
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ALIAS_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRC_ICDDx.MRCID_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ID"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRC_ICDDx.MRCID_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALIAS_RowId</SqlRowIdName>
<StreamLocation>^User.MRCICDAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
