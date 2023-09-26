/// HL7 Patient Number Setup (2466)
Class User.SSHL7PatNumbers Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7PatNumbers, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HL7PNNumberType [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7PNParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7PatNumbers, Required, SqlFieldName = HL7PN_ParRef ];

/// Number Type
Property HL7PNNumberType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7PN_NumberType ];

/// Segment Type
Property HL7PNSegmentType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7PN_SegmentType ];

/// Segment Field Number
Property HL7PNSegmentField As %Float [ SqlColumnNumber = 4, SqlFieldName = HL7PN_SegmentField ];

/// Assigning Type
Property HL7PNAssignType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = HL7PN_AssignType ];

/// Assigning Code
Property HL7PNAssignCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = HL7PN_AssignCode ];

/// Identifier Code
Property HL7PNIdentCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = HL7PN_IdentCode ];

/// Use MR Type as Identifying Code
Property HL7PNIdentCodeMRType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = HL7PN_IdentCodeMRType ];

/// Expiry Date
Property HL7PNExpiryDate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = HL7PN_ExpiryDate ];

/// Expiry Date Field
Property HL7PNExpiryDateField As %Float [ SqlColumnNumber = 10, SqlFieldName = HL7PN_ExpiryDateField ];

/// Validate Number
Property HL7PNValidate As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = HL7PN_Validate ];

/// Expiry Date Format
Property HL7PNExpiryDateFormat As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = HL7PN_ExpiryDateFormat ];

/// Use Card Type as Identifying Code
Property HL7PNIdentCodeCardType As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = HL7PN_IdentCodeCardType ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.SSHL7PatNumbers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7PatNumbers","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.SSHL7PatNumbers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7PatNumbers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.SSHL7PatNumbers).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7PatNumbers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.SSHL7PatNumbers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7PatNumbers","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7PatNumbers","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.SSHL7PatNumbers).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7PatNumbers","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>60</ExtentSize>
<Property name="HL7PNAssignCode">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="HL7PNAssignType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PNExpiryDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PNExpiryDateField">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HL7PNExpiryDateFormat">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HL7PNIdentCode">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="HL7PNIdentCodeCardType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PNIdentCodeMRType">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PNNumberType">
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="HL7PNParRef">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="HL7PNSegmentField">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="HL7PNSegmentType">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HL7PNValidate">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="HL7PN_AssignCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7PN_AssignType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7PN_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HL7PN_ExpiryDateField">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="HL7PN_ExpiryDateFormat">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HL7PN_IdentCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HL7PN_IdentCodeCardType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="HL7PN_IdentCodeMRType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HL7PN_SegmentField">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7PN_SegmentType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HL7PN_Validate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7PN_NumberType</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAT-NUM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7PN_NumberType}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7PN_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7PatNumbersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
