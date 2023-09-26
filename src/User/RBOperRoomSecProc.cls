/// OperRoomSecondary Procedure(2506)
Class User.RBOperRoomSecProc Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_OperRoomSecProc, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SPRChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_OperatingRoom Parent Reference
Relationship SPRParRef As RBOperatingRoom [ Cardinality = parent, Inverse = ChildRBOperRoomSecProc, Required, SqlFieldName = SPR_ParRef ];

/// Childsub
Property SPRChildsub As %Float [ InitialExpression = {$i(^RBOP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPR",0))}, SqlColumnNumber = 2, SqlFieldName = SPR_Childsub ];

/// Des Ref StatePPP
Property SPRStatePPPDR As PACStatePPP [ SqlColumnNumber = 3, SqlFieldName = SPR_StatePPP_DR ];

/// Des Ref Operation
Property SPROperationDR As ORCOperation [ SqlColumnNumber = 4, SqlFieldName = SPR_Operation_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SPR_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SPR_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBOP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_OperatingRoom.RBOP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SPR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{RB_OperatingRoom.RBOP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SPR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SPR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SPR_RowId</SqlRowIdName>
<StreamLocation>^User.RBOperRoomSecProcS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
