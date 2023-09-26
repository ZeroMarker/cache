/// CarerAvailabilityDet(2552)
Class User.PACCarerAvailabilityDet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CarerAvailabilityDet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DETChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_CarerAvailability Parent Reference
Relationship DETParRef As PACCarerAvailability [ Cardinality = parent, Inverse = ChildPACCarerAvailabilityDet, Required, SqlFieldName = DET_ParRef ];

/// Childsub
Property DETChildsub As %Float [ InitialExpression = {$i(^PAC("CARAVL",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DET",0))}, SqlColumnNumber = 2, SqlFieldName = DET_Childsub ];

/// Date From
Property DETDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = DET_DateFrom ];

/// Date To
Property DETDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = DET_DateTo ];

/// Discharge Type Codes
Property DETDischargeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DET_DischargeType ];

/// Care Type codes
Property DETCareTyp As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DET_CareTyp ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACCarerAvailabilityDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCarerAvailabilityDet","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACCarerAvailabilityDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCarerAvailabilityDet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACCarerAvailabilityDet).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCarerAvailabilityDet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACCarerAvailabilityDet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCarerAvailabilityDet","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACCarerAvailabilityDet).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCarerAvailabilityDet","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DET_CareTyp">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DET_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DET_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DET_DischargeType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PAC_CarerAvailability.CARAVL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DET_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CARAVL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PAC_CarerAvailability.CARAVL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DET"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DET_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DET_RowId</SqlRowIdName>
<StreamLocation>^User.PACCarerAvailabilityDetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
