/// Person Keywords(1587)
Class User.PAPersonKeywords Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PersonKeywords, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1000000;

Index RowIDBasedIDKeyIndex On KEYWChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_Person Parent Reference
Relationship KEYWParRef As PAPerson [ Cardinality = parent, Inverse = ChildPAPersonKeywords, Required, SqlFieldName = KEYW_ParRef ];

/// Childsub
Property KEYWChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"KEYW",0))}, SqlColumnNumber = 2, SqlFieldName = KEYW_Childsub ];

/// Name
Property KEYWName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = KEYW_Name ];

/// Name1
Property KEYWName1 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = KEYW_Name1 ];

/// Name2
Property KEYWName2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = KEYW_Name2 ];

/// Episode Flag
Property KEYWEpisodeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlComputeCode = { s {KEYW_EpisodeFlag}=$$CO6^at1587({KEYW_ParRef})
}, SqlComputed, SqlFieldName = KEYW_EpisodeFlag, Transient ];

/// Des Ref Alias
Property KEYWAliasDR As PAPersonAlias [ SqlColumnNumber = 7, SqlFieldName = KEYW_Alias_DR ];

/// Surname
Property KEYWSurname As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = KEYW_Surname ];

/// GivenName
Property KEYWGivenName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = KEYW_GivenName ];

/// DOB
Property KEYWDOB As %Date [ SqlColumnNumber = 10, SqlFieldName = KEYW_DOB ];

/// Soundex
Property KEYWSoundex As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = KEYW_Soundex ];

/// Other Name
Property KEYWOtherName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = KEYW_OtherName ];

/// Des Ref PatType
Property KEYWPatTypeDR As PACPatientType [ SqlColumnNumber = 13, SqlFieldName = KEYW_PatType_DR ];

/// Soundex
Property KEYWSndx As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = KEYW_Sndx ];

/// Sndx1
Property KEYWSndx1 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = KEYW_Sndx1 ];

/// Sndx2
Property KEYWSndx2 As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = KEYW_Sndx2 ];

/// GNSoundex
Property KEYWGNSoundex As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = KEYW_GNSoundex ];

/// ONSoundex
Property KEYWONSoundex As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = KEYW_ONSoundex ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPersonKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonKeywords","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPersonKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonKeywords","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPersonKeywords).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonKeywords","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPersonKeywords).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonKeywords","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPersonKeywords).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPersonKeywords","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1000000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="KEYW_Alias_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="KEYW_DOB">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="KEYW_GNSoundex">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="KEYW_GivenName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="KEYW_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="KEYW_Name1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="KEYW_Name2">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="KEYW_ONSoundex">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="KEYW_OtherName">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="KEYW_PatType_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="KEYW_Sndx">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="KEYW_Sndx1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="KEYW_Sndx2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="KEYW_Soundex">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="KEYW_Surname">
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
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"KEYW"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDOB">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOB1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_GivenName})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDOBSoundex">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DOB1Z"</Expression>
</Subscript>
<Subscript name="2">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_GNSoundex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGSD">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GSD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_GivenName})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGSDsoundex">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"GSDZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_GNSoundex}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Keyw"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName1">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Keyw1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Name1})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Name2})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName1Episode">
<Condition>{KEYW_EpisodeFlag}["Y"</Condition>
<ConditionFields>KEYW_EpisodeFlag,KEYW_Name1,KEYW_Name2</ConditionFields>
<Global>^PAPERi</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Keyw1A"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Name1})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Name2})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNameEpisode">
<Condition>{KEYW_EpisodeFlag}["Y"</Condition>
<ConditionFields>KEYW_EpisodeFlag,KEYW_Name</ConditionFields>
<Global>^PAPERi</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KeywA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOtherName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OSD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_OtherName})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOtherNamesoundex">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OSDZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_ONSoundex}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatTypeName">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"KeywP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_PatType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatTypeName2">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Keyw1P"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_PatType_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Name1})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_Name2})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGD">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SGD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_GivenName})_" "</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGDS">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SGDS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_Soundex}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({KEYW_GivenName})_" "</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGDSZ">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SGDSZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_Soundex}</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_GNSoundex}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSGDZ">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SGDZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_GNSoundex}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSODsoundex">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SODZ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_ONSoundex}</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSndx">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Sndx"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_Sndx}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSndx1">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Sndx1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{KEYW_Sndx1}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{KEYW_Sndx2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSurnameOthername">
<Global>^PAPERi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PA_Person.PAPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>KEYW_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SOD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>$$ALPHAUP({KEYW_Surname})</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({KEYW_OtherName})</Expression>
</Subscript>
<Subscript name="4">
<Expression>+{KEYW_DOB}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PA_Person.PAPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{KEYW_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>KEYW_RowId</SqlRowIdName>
<StreamLocation>^User.PAPersonKeywordsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
