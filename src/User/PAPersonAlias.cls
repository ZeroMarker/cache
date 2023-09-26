/// PA Person Alias(1815)
Class User.PAPersonAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonAlias, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ALIASChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship ALIASParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonAlias, Required, SqlFieldName = ALIAS_ParRef ];

/// Childsub
Property ALIASChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ALIAS",0))}, SqlColumnNumber = 2, SqlFieldName = ALIAS_Childsub ];

/// Text
Property ALIASText As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ALIAS_Text ];

/// Active
Property ALIASActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ALIAS_Active ];

/// Date
Property ALIASDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ALIAS_Date ];

/// Time
Property ALIASTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ALIAS_Time ];

/// Des Ref User
Property ALIASUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = ALIAS_User_DR ];

/// Surname
Property ALIASSurname As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ALIAS_Surname ];

/// DOB
Property ALIASDOB As %Date [ SqlColumnNumber = 9, SqlFieldName = ALIAS_DOB ];

/// Patient From
Property ALIASPatientFromID As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ALIAS_PatientFrom_ID ];

/// Des Ref LastUpdateHospital
Property ALIASLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 11, SqlFieldName = ALIAS_LastUpdateHospital_DR ];

/// Type
Property ALIASType As %String(DISPLAYLIST = ",GivenName,OtherName", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",G,O") [ SqlColumnNumber = 12, SqlFieldName = ALIAS_Type ];

/// HL7FullAliasText
Property ALIASHL7FullAliasText As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ALIAS_HL7FullAliasText ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAlias","OnAfterDelete")
 d Table^HL7Outbound("PAPersonAlias",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAlias","OnAfterInsert")
 d Table^HL7Outbound("PAPersonAlias",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAlias","OnAfterUpdate")
 d Table^HL7Outbound("PAPersonAlias",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonAlias).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAlias","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonAlias).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonAlias","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ALIAS_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALIAS_DOB">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ALIAS_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALIAS_HL7FullAliasText">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ALIAS_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ALIAS_PatientFrom_ID">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ALIAS_Surname">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALIAS_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALIAS_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALIAS_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ALIAS_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALIAS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlias">
<Condition>{ALIAS_Active}'["N"</Condition>
<ConditionFields>ALIAS_Active</ConditionFields>
<Global>^PAPERi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GSD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ALIAS_Surname})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{ALIAS_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateTime">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALIAS_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALIAS_Time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHL7">
<Global>^PAPER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"HL7"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_HL7FullAliasText})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurname">
<Condition>{ALIAS_Active}'["N"</Condition>
<ConditionFields>ALIAS_Active</ConditionFields>
<Global>^PAPERi</Global>
<PopulationPct>20</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SGD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({ALIAS_Surname})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({ALIAS_Text})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{ALIAS_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexText">
<Global>^PAPER</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ALIAS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALIAS"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Text"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({ALIAS_Text})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALIAS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALIAS_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
