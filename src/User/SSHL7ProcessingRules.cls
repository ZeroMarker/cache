/// HL7 Processing Rules
Class User.SSHL7ProcessingRules Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_HL7ProcessingRules, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 5;

Index RowIDBasedIDKeyIndex On HL7PRCount [ IdKey, PrimaryKey, Unique ];

/// SS_HL7 Parent Reference
Relationship HL7PRParRef As SSHL7 [ Cardinality = parent, Inverse = ChildSSHL7ProcessingRules, Required, SqlFieldName = HL7PR_ParRef ];

/// Rule Count - Always 1
Property HL7PRCount As %Float [ SqlColumnNumber = 2, SqlFieldName = HL7PR_Count ];

/// ADT^A03 Discharge summary not required
Property HL7PRDischSumNotRequired As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HL7PR_DischSumNotRequired ];

/// File ST Results as Comments
Property HL7PRFileSTResultComments As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = HL7PR_FileSTResultComments ];

/// Save permanent address as previous permanent
Property HL7PRSavePermAddPrevPerm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = HL7PR_SavePermAddPrevPerm ];

/// Previous permanent address type
Property HL7PRPreviousPermAddType As CTAddrType [ SqlColumnNumber = 6, SqlFieldName = HL7PR_PreviousPermAddType ];

/// Overseas address classed as permanent address
Property HL7PROverseasAddPermAdd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = HL7PR_OverseasAddPermAdd ];

/// Overseas address type
Property HL7PROverseasAddType As CTAddrType [ SqlColumnNumber = 8, SqlFieldName = HL7PR_OverseasAddType ];

/// End date or delete temporary address
Property HL7PRTempAddEndDelete As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = HL7PR_TempAddEndDelete ];

/// Use EVN fields or current date/time
Property HL7PRUpdateDateTime As %String(DISPLAYLIST = ",EVN-2,EVN-6,Current Date/Time", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",EVN2,EVN6,CDT") [ SqlColumnNumber = 10, SqlFieldName = HL7PR_UpdateDateTime ];

/// Match patient for result/order on UR only
Property HL7PRMatchOnUROnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = HL7PR_MatchOnUROnly ];

/// Temporary address from date
Property HL7PRTempAddFromDate As %String(DISPLAYLIST = ",EVN-2,EVN-6,Current Date/Time", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",EVN2,EVN6,CDT") [ SqlColumnNumber = 12, SqlFieldName = HL7PR_TempAddFromDate ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSHL7ProcessingRules).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7ProcessingRules","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSHL7ProcessingRules).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7ProcessingRules","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSHL7ProcessingRules).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7ProcessingRules","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSHL7ProcessingRules).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7ProcessingRules","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSHL7ProcessingRules).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSHL7ProcessingRules","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="HL7PRCount">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="HL7PRDischSumNotRequired">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HL7PRFileSTResultComments">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PRMatchOnUROnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PROverseasAddPermAdd">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PROverseasAddType">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HL7PRParRef">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="HL7PRPreviousPermAddType">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HL7PRSavePermAddPrevPerm">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="HL7PRTempAddEndDelete">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="HL7PRTempAddFromDate">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="HL7PRUpdateDateTime">
<Selectivity>25.0000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="HL7PR_DischSumNotRequired">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HL7PR_FileSTResultComments">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HL7PR_MatchOnUROnly">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="HL7PR_OverseasAddPermAdd">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HL7PR_OverseasAddType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="HL7PR_PreviousPermAddType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HL7PR_SavePermAddPrevPerm">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HL7PR_TempAddEndDelete">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HL7PR_TempAddFromDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="HL7PR_UpdateDateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^SSHL7</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SS_HL7.HL7_Code</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HL7PR_Count</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{SS_HL7.HL7_Code}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"RULES"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HL7PR_Count}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>HL7PR_RowId</SqlRowIdName>
<StreamLocation>^User.SSHL7ProcessingRulesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
