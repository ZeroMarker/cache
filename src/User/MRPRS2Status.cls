/// MR_PRS2Status(2570)
Class User.MRPRS2Status Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PRS2Status, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 10;

Index RowIDBasedIDKeyIndex On PRS2Childsub [ IdKey, PrimaryKey, Unique ];

/// MR_Adm Parent Reference
Relationship PRS2ParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRPRS2Status, Required, SqlFieldName = PRS2_ParRef ];

/// Childsub
Property PRS2Childsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PRS2",0))}, SqlColumnNumber = 2, SqlFieldName = PRS2_Childsub ];

/// UpdateDate
Property PRS2UpdateDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PRS2_UpdateDate ];

/// UpdateTime
Property PRS2UpdateTime As %Time [ SqlColumnNumber = 4, SqlFieldName = PRS2_UpdateTime ];

/// Status
Property PRS2Status As %String(DISPLAYLIST = ",Verified,Sent,Flagged to resubmit,Accepted,Episode Deletion,Diagnosis Deletion,Extra Diagnosis Deletion,Sub Acute Deletion,Rollback,Resent with changes", MAXLEN = 24, TRUNCATE = 1, VALUELIST = ",V,S,F,A,E,D,ED,SA,R,D1") [ SqlColumnNumber = 5, SqlFieldName = PRS2_Status ];

/// RecordTypes
Property PRS2RecordTypes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PRS2_RecordTypes ];

/// Des Ref Extract
Property PRS2ExtractDR As PAExtract [ SqlColumnNumber = 7, SqlFieldName = PRS2_Extract_DR ];

/// PreviousStatus
Property PRS2PreviousStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PRS2_PreviousStatus ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPRS2Status).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPRS2Status","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPRS2Status).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPRS2Status","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPRS2Status).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPRS2Status","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPRS2Status).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPRS2Status","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPRS2Status).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPRS2Status","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="PRS2Childsub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="PRS2ExtractDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PRS2ParRef">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PRS2PreviousStatus">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PRS2RecordTypes">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="PRS2Status">
<Selectivity>9.0909%</Selectivity>
</Property>
<Property name="PRS2UpdateDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PRS2UpdateTime">
<Selectivity>10.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="PRS2_Extract_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRS2_PreviousStatus">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRS2_RecordTypes">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRS2_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRS2_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRS2_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PRS2_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRS2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRS2_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>PRS2_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PRS2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRS2_UpdateDate}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PRS2_UpdateTime}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{PRS2_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtract">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PRS2_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAExtract"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRS2_Extract_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRS2_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRS2_RowId</SqlRowIdName>
<StreamLocation>^User.MRPRS2StatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
