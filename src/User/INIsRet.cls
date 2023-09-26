/// IN Issue Return(1784)
Class User.INIsRet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_IsRet, StorageStrategy = SQLStorage ]
{

Relationship ChildINIsRetItems As INIsRetItems [ Cardinality = children, Inverse = INIRIParRef ];

/// Return No
Property INIRNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INIR_No ];

/// Date
Property INIRDate As %Date [ SqlColumnNumber = 3, SqlFieldName = INIR_Date ];

/// Time
Property INIRTime As %Time [ SqlColumnNumber = 4, SqlFieldName = INIR_Time ];

/// Des Ref User
Property INIRUserDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = INIR_User_DR ];

/// Des Ref INIT
Property INIRINITDR As INIsTrf [ SqlColumnNumber = 6, SqlFieldName = INIR_INIT_DR ];

/// Completed
Property INIRCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = INIR_Completed ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INIsRet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsRet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INIsRet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsRet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INIsRet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsRet","OnBeforeDelete")
 d VALDEL^at1784
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INIsRet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsRet","OnBeforeUpdate")
 d VALUPD^at1784
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsRet","OnBeforeInsert")
 d VALINS^at1784
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INIsRet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INIsRet","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INIR(0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="INIR_Completed">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INIR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INIR_INIT_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INIR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INIR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INIR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INIR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INIR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{INIR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIssue">
<Global>^INIR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INIT"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIR_INIT_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^INIR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({INIR_No})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexdate">
<Global>^INIR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INIR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INIR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INIR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INIR_RowId</SqlRowIdName>
<StreamLocation>^User.INIsRetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
