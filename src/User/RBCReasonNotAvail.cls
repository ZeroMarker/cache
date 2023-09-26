/// RBC Reason for Not Available(1055)
Class User.RBCReasonNotAvail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_ReasonNotAvail, StorageStrategy = SQLStorage ]
{

/// Code
Property RNAVCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = RNAV_Code ];

/// Description
Property RNAVDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RNAV_Desc ];

/// Type
Property RNAVType As %String(DISPLAYLIST = ",Functional,Structural", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",F,S") [ SqlColumnNumber = 4, SqlFieldName = RNAV_Type ];

/// Date From
Property RNAVDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = RNAV_DateFrom ];

/// Date To
Property RNAVDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = RNAV_DateTo ];

Index RNAVCodeUnqIdx1 On RNAVCode [ Unique ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCReasonNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonNotAvail","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCReasonNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonNotAvail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCReasonNotAvail).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonNotAvail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCReasonNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonNotAvail","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonNotAvail","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCReasonNotAvail).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCReasonNotAvail","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RBC("NA",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RNAV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RNAV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RNAV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RNAV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RNAV_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RNAV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RNAV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNAV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RNAV_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^RBC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNAV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RNAV_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RNAV_RowId</SqlRowIdName>
<StreamLocation>^User.RBCReasonNotAvailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
