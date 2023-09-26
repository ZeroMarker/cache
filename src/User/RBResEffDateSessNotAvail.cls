/// RB Res Eff Date NotAvail(1545)
Class User.RBResEffDateSessNotAvail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSessNotAvail, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On NAChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_ResEffDateSession Parent Reference
Relationship NAParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessNotAvail, Required, SqlFieldName = NA_ParRef ];

/// Childsub
Property NAChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"NA",0))}, SqlColumnNumber = 2, SqlFieldName = NA_Childsub ];

/// Date From
Property NADateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = NA_DateFrom ];

/// Date To
Property NADateTo As %Float [ SqlColumnNumber = 4, SqlFieldName = NA_DateTo ];

/// Des Ref Reason not avail
Property NAReasonDR As RBCReasonNotAvail [ SqlColumnNumber = 5, SqlFieldName = NA_Reason_DR ];

/// Remarks
Property NARemarks As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = NA_Remarks, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessNotAvail","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessNotAvail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessNotAvail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSessNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessNotAvail","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSessNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessNotAvail","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="NA_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NA_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NA_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NA_Remarks">
<Node>"REM"</Node>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>NA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{NA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>NA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"DateFrom"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{NA_DateFrom}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{NA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NA_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessNotAvailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
