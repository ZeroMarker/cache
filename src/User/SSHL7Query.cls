/// HL7 Query Setup
Class User.SSHL7Query Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7Query, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7QUCount [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7QUParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7Query, Required, SqlFieldName = HL7QU_ParRef ];

/// Part of RowId - Always 1
Property HL7QUCount As %Float [ SqlColumnNumber = 2, SqlFieldName = HL7QU_Count ];

/// Number of records requested
Property HL7QUNumberRecordsRequested As %Float [ SqlColumnNumber = 3, SqlFieldName = HL7QU_NumberRecordsRequested ];

/// Allow search continuation
Property HL7QUAllowContinuation As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = HL7QU_AllowContinuation ];

/// Search types allowed
Property HL7QUSearchTypes As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HL7QU_SearchTypes ];

/// Unique key counter
Property HL7QUQueryUniqueKey As %Float [ SqlColumnNumber = 6, SqlFieldName = HL7QU_QueryUniqueKey ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7Query).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Query","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7Query).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Query","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7Query).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Query","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7Query).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Query","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7Query).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7Query","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7QU_AllowContinuation">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7QU_NumberRecordsRequested">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7QU_QueryUniqueKey">
<Delimiter>"^"</Delimiter>
<Node>"QUERY-CNT"</Node>
<Piece>1</Piece>
</Data>
<Data name="HL7QU_SearchTypes">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7QU_Count</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QUERY"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7QU_Count}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7QU_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7QueryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
