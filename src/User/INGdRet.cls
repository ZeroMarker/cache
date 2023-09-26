/// IN Goods Return         (INGRR,480)
Class User.INGdRet Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_GdRet, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INGRRChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildINGdRetItm As INGdRetItm [ Cardinality = children, Inverse = INGRDINGRRParRef ];

/// Des Ref to INGR
Relationship INGRRINGRParRef As INGdRec [ Cardinality = parent, Inverse = ChildINGdRet, Required, SqlFieldName = INGRR_INGR_ParRef ];

/// INGRR ChildSub (New Key)
Property INGRRChildSub As %Float [ InitialExpression = {$i(^INGR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"GRR",0))}, SqlColumnNumber = 2, SqlFieldName = INGRR_ChildSub ];

/// Good Return Reference No
Property INGRRNo As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = INGRR_No ];

/// Good Return Date
Property INGRRDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 4, SqlFieldName = INGRR_Date ];

/// Des Ref to SSUSR
Property INGRRSSUSRDR As SSUser [ SqlColumnNumber = 5, SqlFieldName = INGRR_SSUSR_DR ];

/// Time
Property INGRRTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 6, SqlFieldName = INGRR_Time ];

/// Completed
Property INGRRCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = INGRR_Completed ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INGdRet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRet","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INGdRet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRet","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INGdRet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRet","OnBeforeDelete")
 d VALDEL^at480
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INGdRet).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRet","OnBeforeUpdate")
 d VALUPD^at480
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRet","OnBeforeInsert")
 d PRFILINS^at480
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INGdRet).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRet","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINGRR">
<Data name="INGRR_Completed">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRR_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRR_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_GdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INGRR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_GdRec.INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GRR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INGRR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINGRRDate">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IN_GdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INGRR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GRR_Date"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INGRR_Date}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IN_GdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGRR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINGRRNo">
<Global>^INGR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>IN_GdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INGRR_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"GRR_No"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INGRR_No})</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IN_GdRec.INGR_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INGRR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INGRR_RowId</SqlRowIdName>
<StreamLocation>^User.INGdRetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
