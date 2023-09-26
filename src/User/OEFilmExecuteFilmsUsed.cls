/// Film Execute Films Used(2093)
Class User.OEFilmExecuteFilmsUsed Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_FilmExecuteFilmsUsed, StorageStrategy = SQLStorage ]
{

/// Childsub
Property FUChildsub As %Float [ InitialExpression = {$i(^OEFE($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"FU",0))}, SqlColumnNumber = 2, SqlFieldName = FU_Childsub ];

/// Des Ref FilmType
Property FUFilmTypeDR As OECFilmTypeSize [ SqlColumnNumber = 4, SqlFieldName = FU_FilmType_DR ];

/// Number Of Films
Property FUNumberOfFilms As %Float [ SqlColumnNumber = 3, SqlFieldName = FU_NumberOfFilms ];

/// Des Ref OEFilmExecuteItems
Property FUOEFilmExecuteItemsDR As OEFilmExecuteItems [ SqlColumnNumber = 7, SqlFieldName = FU_OEFilmExecuteItems_DR ];

/// OE_FilmExecute Parent Reference
Relationship FUParRef As OEFilmExecute [ Cardinality = parent, Inverse = ChildOEFilmExecuteFilmsUsed, Required, SqlFieldName = FU_ParRef ];

/// Des Ref ReasonForRejection
Property FUReasonForRejectionDR As OECFilmReasonForReject [ SqlColumnNumber = 6, SqlFieldName = FU_ReasonForRejection_DR ];

/// Usage Type
Property FUUsageType As %String(DISPLAYLIST = ",Used,Rejected", MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",U,R") [ SqlColumnNumber = 5, SqlFieldName = FU_UsageType ];

Index RowIDBasedIDKeyIndex On FUChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 502;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteFilmsUsed).OnTrigger($g(%d(1)))
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteFilmsUsed).OnTrigger($g(%d(1)))
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEFilmExecuteFilmsUsed).OnTrigger($g(%d(1)))
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEFilmExecuteFilmsUsed).getOld($g(%d(1)))
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEFilmExecuteFilmsUsed).getOld($g(%d(1)))
}

Storage SQLStorage
{
<ExtentSize>502</ExtentSize>
<Property name="FUChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="FUFilmTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="FUNumberOfFilms">
<Selectivity>1</Selectivity>
</Property>
<Property name="FUOEFilmExecuteItemsDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="FUParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="FUReasonForRejectionDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="FUUsageType">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="FU_FilmType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FU_NumberOfFilms">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FU_OEFilmExecuteItems_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="FU_ReasonForRejection_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="FU_UsageType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^OEFE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_FilmExecute.OEFE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FU_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_FilmExecute.OEFE_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FU"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FU_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FU_RowId</SqlRowIdName>
<StreamLocation>^User.OEFilmExecuteFilmsUsedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
