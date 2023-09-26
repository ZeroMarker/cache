/// HL7 Order Number Setup
Class User.SSHL7OrdNumbers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7OrdNumbers, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (HL7ONSegmentType, HL7ONSegmentField) [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7ONParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7OrdNumbers, Required, SqlFieldName = HL7ON_ParRef ];

/// Number Type
Property HL7ONNumberType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7ON_NumberType ];

/// Segment Type
Property HL7ONSegmentType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7ON_SegmentType ];

/// Segment Field Number
Property HL7ONSegmentField As %Float [ SqlColumnNumber = 4, SqlFieldName = HL7ON_SegmentField ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7OrdNumbers).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OrdNumbers","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7OrdNumbers).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OrdNumbers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7OrdNumbers).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OrdNumbers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7OrdNumbers).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OrdNumbers","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7OrdNumbers).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7OrdNumbers","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7ON_NumberType">
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
<Field>HL7ON_SegmentType</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>HL7ON_SegmentField</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ORD-NUM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7ON_SegmentType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HL7ON_SegmentField}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7ON_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7OrdNumbersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
