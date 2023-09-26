/// MR Floor plan notes(1912)
Class User.MRFloorPlanNotes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_FloorPlanNotes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On FLOORChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship FLOORParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRFloorPlanNotes, Required, SqlFieldName = FLOOR_ParRef ];

/// Childsub
Property FLOORChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"FLOOR",0))}, SqlColumnNumber = 2, SqlFieldName = FLOOR_Childsub ];

/// Text
Property FLOORText As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FLOOR_Text, SqlListType = SUBNODE ];

/// Date
Property FLOORDate As %Date [ SqlColumnNumber = 4, SqlFieldName = FLOOR_Date ];

/// Time
Property FLOORTime As %Time [ SqlColumnNumber = 5, SqlFieldName = FLOOR_Time ];

/// Des Ref UpdateUser
Property FLOORUpdateUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = FLOOR_UpdateUser_DR ];

/// Des Ref UpdateHospital
Property FLOORUpdateHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = FLOOR_UpdateHospital_DR ];

/// Update Date
Property FLOORUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = FLOOR_UpdateDate ];

/// Update Time
Property FLOORUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = FLOOR_UpdateTime ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRFloorPlanNotes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRFloorPlanNotes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRFloorPlanNotes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRFloorPlanNotes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRFloorPlanNotes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRFloorPlanNotes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRFloorPlanNotes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRFloorPlanNotes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRFloorPlanNotes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRFloorPlanNotes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="FLOOR_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FLOOR_Text">
<Node>"TXT"</Node>
</Data>
<Data name="FLOOR_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FLOOR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FLOOR_UpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FLOOR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="FLOOR_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FLOOR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FLOOR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FLOOR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FLOOR_RowId</SqlRowIdName>
<StreamLocation>^User.MRFloorPlanNotesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
