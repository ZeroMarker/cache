/// ARC Item Message(1718)
Class User.ARCItemMessage Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemMessage, StorageStrategy = SQLStorage ]
{

/// Age From
Property MESSAgeFrom As %Float [ SqlColumnNumber = 3, SqlFieldName = MESS_AgeFrom ];

/// Age To
Property MESSAgeTo As %Float [ SqlColumnNumber = 4, SqlFieldName = MESS_AgeTo ];

/// Childsub
Property MESSChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"MESS",0))}, SqlColumnNumber = 2, SqlFieldName = MESS_Childsub ];

/// Message
Property MESSMessage As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = MESS_Message, SqlListType = SUBNODE ];

/// ARC_ItmMast Parent Reference
Relationship MESSParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemMessage, Required, SqlFieldName = MESS_ParRef ];

/// Des Ref Sex
Property MESSSexDR As CTSex [ SqlColumnNumber = 5, SqlFieldName = MESS_Sex_DR ];

Index RowIDBasedIDKeyIndex On MESSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 5;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemMessage).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemMessage","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemMessage).OnTrigger($g(%d(1)))             

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemMessage","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemMessage).OnTrigger($g(%d(1))) 

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemMessage","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ClassName).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ClassName","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemMessage).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemMessage","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="MESSAgeFrom">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MESSAgeTo">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MESSChildsub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="MESSMessage">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="MESSParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="MESSSexDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MESS_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MESS_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MESS_Message">
<Node>"TXT"</Node>
</Data>
<Data name="MESS_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>MESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSexDR">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>MESS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Sex"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESS_Sex_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MESS_AgeFrom}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{MESS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MESS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
