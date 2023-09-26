/// ADLCareTypeSub(2474)
Class User.PACADLCareTypeSub Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ADLCareTypeSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 3;

Index RowIDBasedIDKeyIndex On SUBChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_ADLCareType Parent Reference
Relationship SUBParRef As PACADLCareType [ Cardinality = parent, Inverse = ChildPACADLCareTypeSub, Required, SqlFieldName = SUB_ParRef ];

/// Childsub
Property SUBChildsub As %Float [ InitialExpression = {$i(^PAC("ADLCT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SUB",0))}, SqlColumnNumber = 2, SqlFieldName = SUB_Childsub ];

/// Des Ref ADLSubType
Property SUBADLSubTypeDR As PACADLSubType [ SqlColumnNumber = 3, SqlFieldName = SUB_ADLSubType_DR ];

/// Min
Property SUBMin As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SUB_Min ];

/// Max
Property SUBMax As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SUB_Max ];

/// Date From
Property SUBDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = SUB_DateFrom ];

/// Date To
Property SUBDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = SUB_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACADLCareTypeSub).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareTypeSub","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACADLCareTypeSub).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareTypeSub","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACADLCareTypeSub).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareTypeSub","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACADLCareTypeSub).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareTypeSub","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACADLCareTypeSub).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACADLCareTypeSub","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="SUBADLSubTypeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SUBChildsub">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="SUBDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBMax">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SUBMin">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="SUBParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="SUB_ADLSubType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUB_Max">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUB_Min">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ADLCareType.ADLCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ADLCareType.ADLCT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSubType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_ADLCareType.ADLCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ADLCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_ADLCareType.ADLCT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SubType"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUB_ADLSubType_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SUB_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUB_RowId</SqlRowIdName>
<StreamLocation>^User.PACADLCareTypeSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
