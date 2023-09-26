/// LocApprovedBeds(2578)
Class User.CTLocApprovedBeds Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocApprovedBeds, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APBChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Loc Parent Reference
Relationship APBParRef As CTLoc [ Cardinality = parent, Inverse = ChildCTLocApprovedBeds, Required, SqlFieldName = APB_ParRef ];

/// Childsub
Property APBChildsub As %Float [ InitialExpression = {$i(^CTLOCF($p(%d(0),$c(1)),"APB",0))}, SqlColumnNumber = 2, SqlFieldName = APB_Childsub ];

/// DateFrom
Property APBDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = APB_DateFrom ];

/// DateTo
Property APBDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = APB_DateTo ];

/// Number Of Beds
Property APBNumberOfBeds As %Float [ SqlColumnNumber = 5, SqlFieldName = APB_NumberOfBeds ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocApprovedBeds).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocApprovedBeds","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocApprovedBeds).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocApprovedBeds","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocApprovedBeds).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocApprovedBeds","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocApprovedBeds).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocApprovedBeds","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocApprovedBeds).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocApprovedBeds","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APB_NumberOfBeds">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CTLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CT_Loc.CTLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>APB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{CT_Loc.CTLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"APB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{APB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>APB_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocApprovedBedsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
