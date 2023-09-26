/// HL7 Segments
Class User.SSHL7Segment Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7Segment, StorageStrategy = SQLStorage ]
{

/// Mandatory
Property HL7SEGMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = HL7SEG_Mandatory ];

/// Maximum Number of Repeats
Property HL7SEGMaxNumberOfRepeats As %Float [ SqlColumnNumber = 6, SqlFieldName = HL7SEG_MaxNumberOfRepeats ];

/// SS_HL7MessageType Parent Reference
Relationship HL7SEGParRef As SSHL7MessageType [ Cardinality = parent, Inverse = ChildSSHL7Segment, Required, SqlFieldName = HL7SEG_ParRef ];

/// Repeat
Property HL7SEGRepeatable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = HL7SEG_Repeatable ];

/// Sequence number
Property HL7SEGSequence As %Float [ SqlColumnNumber = 2, SqlFieldName = HL7SEG_Sequence ];

/// Segment Type
Property HL7SEGType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7SEG_Type ];

Index RowIDBasedIDKeyIndex On HL7SEGSequence [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 33;

Storage SQLStorage
{
<ExtentSize>33</ExtentSize>
<Property name="HL7SEGMandatory">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7SEGMaxNumberOfRepeats">
<Selectivity>1</Selectivity>
</Property>
<Property name="HL7SEGParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="HL7SEGRepeatable">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7SEGSequence">
<Selectivity>1</Selectivity>
</Property>
<Property name="HL7SEGType">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="HL7SEG_Mandatory">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7SEG_MaxNumberOfRepeats">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7SEG_Repeatable">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7SEG_Type">
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
<Field>SS_HL7MessageType.HL7MSG_Type</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>HL7SEG_Sequence</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MSG-TYPE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SS_HL7MessageType.HL7MSG_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"SEG"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HL7SEG_Sequence}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7SEG_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7SegmentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
