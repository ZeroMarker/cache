/// Item Dependent(2527)
Class User.ARCItemDependent Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemDependent, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DEPChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship DEPParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemDependent, Required, SqlFieldName = DEP_ParRef ];

/// Childsub
Property DEPChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"DEPEND",0))}, SqlColumnNumber = 2, SqlFieldName = DEP_Childsub ];

/// Date From
Property DEPDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DEP_DateFrom ];

/// Date To
Property DEPDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DEP_DateTo ];

/// Des Ref ARCIM
Property DEPARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = DEP_ARCIM_DR ];

/// TimeFrame
Property DEPTimeFrame As %Float [ SqlColumnNumber = 6, SqlFieldName = DEP_TimeFrame ];

/// Period
Property DEPPeriod As %String(DISPLAYLIST = ",Day,Month,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 7, SqlFieldName = DEP_Period ];

/// Same Resource
Property DEPSameResource As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = DEP_SameResource ];

/// 数量 chenying2019-03-19
Property DEPDoseQty As %Float [ SqlColumnNumber = 9, SqlFieldName = DEP_DoseQty ];

/// 单位 chenying2019-03-19
Property DEPUnitDR As ARCItmMast [ SqlColumnNumber = 10, SqlFieldName = DEP_Unit_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemDependent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDependent","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemDependent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDependent","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemDependent).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDependent","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemDependent).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDependent","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemDependent).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemDependent","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DEP_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DEP_DoseQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DEP_Period">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEP_SameResource">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DEP_TimeFrame">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEP_Unit_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
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
<Field>DEP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DEPEND"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DEP_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemDependentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
