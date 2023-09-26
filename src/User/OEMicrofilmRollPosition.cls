/// MicrofilmRollPosition(2436)
Class User.OEMicrofilmRollPosition Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_MicrofilmRollPosition, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On POSChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_MicrofilmRoll Parent Reference
Relationship POSParRef As OEMicrofilmRoll [ Cardinality = parent, Inverse = ChildOEMicrofilmRollPosition, Required, SqlFieldName = POS_ParRef ];

/// Childsub
Property POSChildsub As %Float [ InitialExpression = {$i(^OEMF($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"POS",0))}, SqlColumnNumber = 2, SqlFieldName = POS_Childsub ];

/// Position
Property POSPosition As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = POS_Position ];

/// Des Ref RTMAS
Property POSRTMASDR As RTMaster [ SqlColumnNumber = 4, SqlFieldName = POS_RTMAS_DR ];

/// Comment
Property POSComment As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = POS_Comment, SqlListType = SUBNODE ];

/// Date Entered
Property POSDateEntered As %Date [ SqlColumnNumber = 6, SqlFieldName = POS_DateEntered ];

/// Time Entered
Property POSTimeEntered As %Time [ SqlColumnNumber = 7, SqlFieldName = POS_TimeEntered ];

/// Des Ref MRecordType
Property POSMRecordTypeDR As RTCMRecordType [ SqlColumnNumber = 8, SqlFieldName = POS_MRecordType_DR ];

/// Des Ref LastUpdateUser
Property POSLastUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = POS_LastUpdateUser_DR ];

/// Des Ref LastUpdateHospital
Property POSLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 10, SqlFieldName = POS_LastUpdateHospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEMicrofilmRollPosition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRollPosition","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEMicrofilmRollPosition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRollPosition","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEMicrofilmRollPosition).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRollPosition","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEMicrofilmRollPosition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRollPosition","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEMicrofilmRollPosition).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEMicrofilmRollPosition","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="POS_Comment">
<Node>"RMK"</Node>
</Data>
<Data name="POS_DateEntered">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="POS_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="POS_LastUpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="POS_MRecordType_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="POS_Position">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="POS_RTMAS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="POS_TimeEntered">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEMF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_MicrofilmRoll.OEMF_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>POS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_MicrofilmRoll.OEMF_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"POS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{POS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>POS_RowId</SqlRowIdName>
<StreamLocation>^User.OEMicrofilmRollPositionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
