/// ServiceChargeRate(2639)
Class User.ARCServiceChargeRate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ServiceChargeRate, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RATEChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ServiceCharge Parent Reference
Relationship RATEParRef As ARCServiceCharge [ Cardinality = parent, Inverse = ChildARCServiceChargeRate, Required, SqlFieldName = RATE_ParRef ];

/// Childsub
Property RATEChildsub As %Float [ InitialExpression = {$i(^ARC("SERCH",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"RATE",0))}, SqlColumnNumber = 2, SqlFieldName = RATE_Childsub ];

/// DateFrom
Property RATEDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = RATE_DateFrom ];

/// DateTo
Property RATEDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = RATE_DateTo ];

/// OP Rate
Property RATEOPRate As %Float [ SqlColumnNumber = 5, SqlFieldName = RATE_OPRate ];

/// IP Rate
Property RATEIPRate As %Float [ SqlColumnNumber = 6, SqlFieldName = RATE_IPRate ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCServiceChargeRate).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCServiceChargeRate","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCServiceChargeRate).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCServiceChargeRate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCServiceChargeRate).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCServiceChargeRate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCServiceChargeRate).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCServiceChargeRate","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCServiceChargeRate).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCServiceChargeRate","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="RATE_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RATE_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RATE_IPRate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RATE_OPRate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ServiceCharge.SERCH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RATE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SERCH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ServiceCharge.SERCH_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RATE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>RATE_RowId</SqlRowIdName>
<StreamLocation>^User.ARCServiceChargeRateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
