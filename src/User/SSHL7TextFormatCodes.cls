/// HL7 Text Formatting Codes
Class User.SSHL7TextFormatCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7TextFormatCodes, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On (HL7TFExternalSystem, HL7TFFormatCode) [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7TFParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7TextFormatCodes, Required, SqlFieldName = HL7TF_ParRef ];

/// External System
Property HL7TFExternalSystem As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HL7TF_ExternalSystem ];

/// Formatting Code
Property HL7TFFormatCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7TF_FormatCode ];

/// ASCII Conversion number
Property HL7TFAsciiConversion As %Float [ SqlColumnNumber = 4, SqlFieldName = HL7TF_AsciiConversion ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7TextFormatCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TextFormatCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7TextFormatCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TextFormatCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7TextFormatCodes).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TextFormatCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7TextFormatCodes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TextFormatCodes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7TextFormatCodes).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7TextFormatCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HL7TF_AsciiConversion">
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
<Field>HL7TF_ExternalSystem</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>HL7TF_FormatCode</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TEXT-FORMAT-CODE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7TF_ExternalSystem}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HL7TF_FormatCode}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7TF_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7TextFormatCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
