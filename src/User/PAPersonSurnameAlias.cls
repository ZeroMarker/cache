/// PA Person Surname Alias(1923)
Class User.PAPersonSurnameAlias Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonSurnameAlias, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SURChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship SURParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonSurnameAlias, Required, SqlFieldName = SUR_ParRef ];

/// Childsub
Property SURChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SUR",0))}, SqlColumnNumber = 2, SqlFieldName = SUR_Childsub ];

/// Name
Property SURName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SUR_Name ];

/// Name2
Property SURName2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SUR_Name2 ];

/// Name3
Property SURName3 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = SUR_Name3 ];

/// Dob
Property SURDob As %Date [ SqlColumnNumber = 6, SqlFieldName = SUR_Dob ];

/// Active
Property SURActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SUR_Active ];

/// Patient From ID
Property SURPatientFromID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SUR_PatientFrom_ID ];

/// Date
Property SURDate As %Date [ SqlColumnNumber = 9, SqlFieldName = SUR_Date ];

/// Time
Property SURTime As %Time [ SqlColumnNumber = 10, SqlFieldName = SUR_Time ];

/// Des Ref User
Property SURUserDR As SSUser [ SqlColumnNumber = 11, SqlFieldName = SUR_User_DR ];

/// Des Ref LastUpdateHospital
Property SURLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 12, SqlFieldName = SUR_LastUpdateHospital_DR ];

/// Des Ref Sex
Property SURSexDR As CTSex [ SqlColumnNumber = 13, SqlFieldName = SUR_Sex_DR ];

/// Type
Property SURType As %String(DISPLAYLIST = ",DOB,Sex,Surname", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",D,S,SU") [ SqlColumnNumber = 14, SqlFieldName = SUR_Type ];

/// HL7FullAliasText
Property SURHL7FullAliasText As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = SUR_HL7FullAliasText ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonSurnameAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSurnameAlias","OnAfterDelete")
 d Table^HL7Outbound("PAPersonSurnameAlias",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonSurnameAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSurnameAlias","OnAfterInsert")
 d Table^HL7Outbound("PAPersonSurnameAlias",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonSurnameAlias).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSurnameAlias","OnAfterUpdate")
 d Table^HL7Outbound("PAPersonSurnameAlias",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonSurnameAlias).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSurnameAlias","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonSurnameAlias).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonSurnameAlias","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SUR_Active">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SUR_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SUR_Dob">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUR_HL7FullAliasText">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SUR_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SUR_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUR_Name2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SUR_Name3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUR_PatientFrom_ID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SUR_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SUR_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SUR_Type">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SUR_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SURALIAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SUR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUR_Time}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUR_Childsub}</Expression>
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
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SUR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"HL7"</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({SUR_HL7FullAliasText})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurnameGivNameDOB">
<Condition>{SUR_Active}'["N"</Condition>
<ConditionFields>SUR_Active</ConditionFields>
<Global>^PAPERi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SGD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({SUR_Name})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SUR_Name2})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{SUR_Dob}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurnameOtherName">
<Condition>{SUR_Active}'["N"</Condition>
<ConditionFields>SUR_Active</ConditionFields>
<Global>^PAPERi</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>SUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({SUR_Name})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SUR_Name3})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{SUR_Dob}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SUR_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonSurnameAliasS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
