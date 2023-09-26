/// PersonCareProvider(2537)
Class User.PAPersonCareProvider Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonCareProvider, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CPChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship CPParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonCareProvider, Required, SqlFieldName = CP_ParRef ];

/// Childsub
Property CPChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CP",0))}, SqlColumnNumber = 2, SqlFieldName = CP_Childsub ];

/// Des Ref RespUnit
Property CPRespUnitDR As CTResponsibleUnit [ SqlColumnNumber = 3, SqlFieldName = CP_RespUnit_DR ];

/// Des Ref CareProv
Property CPCareProvDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = CP_CareProv_DR ];

/// DateFrom
Property CPDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = CP_DateFrom ];

/// DateTo
Property CPDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = CP_DateTo ];

/// CancelReason
Property CPCancelReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CP_CancelReason ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonCareProvider).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonCareProvider","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonCareProvider).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonCareProvider","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonCareProvider).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonCareProvider","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonCareProvider).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonCareProvider","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonCareProvider).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonCareProvider","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CP_CancelReason">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CP_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CP_RespUnit_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCareProv">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPCareProvDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CP_CareProv_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexrespUnit">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CPRespUnitDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CP_RespUnit_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CP_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonCareProviderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
