/// Ord Action(2666)
Class User.OEOrdAction Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdAction, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ACTChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdItem Parent Reference
Relationship ACTParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdAction, Required, SqlFieldName = ACT_ParRef ];

/// Childsub
Property ACTChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ACT",0))}, SqlColumnNumber = 2, SqlFieldName = ACT_Childsub ];

/// Action
Property ACTAction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ACT_Action ];

/// Date
Property ACTDate As %Date [ SqlColumnNumber = 4, SqlFieldName = ACT_Date ];

/// Time
Property ACTTime As %Time [ SqlColumnNumber = 5, SqlFieldName = ACT_Time ];

/// Des Ref User
Property ACTUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = ACT_User_DR ];

/// Des Ref UpdateUser
Property ACTUpdateUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = ACT_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property ACTUpdateHospitalDR As CTHospital [ SqlColumnNumber = 8, SqlFieldName = ACT_UpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdAction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAction","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdAction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAction","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdAction).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAction","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdAction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAction","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdAction).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdAction","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="ACT_Action">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ACT_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ACT_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ACT_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ACT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ACT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ACT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ACT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ACT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAction">
<Global>^OEORD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>ACT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ACT"</Expression>
</Subscript>
<Subscript name="5">
<Expression>0</Expression>
</Subscript>
<Subscript name="6">
<Expression>"Action"</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ACT_Action}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ACT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ACT_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdActionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
