/// PAC Source of attendance(1945)
Class User.PACSourceOfAttendance Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SourceOfAttendance, StorageStrategy = SQLStorage ]
{

/// Code
Property ATTENDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ATTEND_Code ];

/// Date From
Property ATTENDDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = ATTEND_DateFrom ];

/// Date To
Property ATTENDDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = ATTEND_DateTo ];

/// Description
Property ATTENDDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ATTEND_Desc ];

/// Episode Type
Property ATTENDEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ATTEND_EpisodeType ];

/// Mandatory Ref Doctor
Property ATTENDMandatoryRefDoctor As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = ATTEND_MandatoryRefDoctor ];

/// Mandatory Ref Hospital
Property ATTENDMandatoryRefHospital As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ATTEND_MandatoryRefHospital ];

/// National Code
Property ATTENDNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ATTEND_NationalCode ];

/// Referrer Type
Property ATTENDRefType As %String(DISPLAYLIST = ",Doctor,Consultant,Dentist,CareProvider,Others", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",GP,CONS,DENT,CP,O") [ SqlColumnNumber = 9, SqlFieldName = ATTEND_RefType ];

/// Status Indicator
Property ATTENDStatisticIndicator As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ATTEND_StatisticIndicator ];

Parameter EXTENTSIZE = 12;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSourceOfAttendance).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfAttendance","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSourceOfAttendance).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfAttendance","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSourceOfAttendance).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfAttendance","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSourceOfAttendance).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfAttendance","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSourceOfAttendance).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSourceOfAttendance","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>12</ExtentSize>
<Property name="ATTENDCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ATTENDDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="ATTENDDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="ATTENDDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="ATTENDEpisodeType">
<Selectivity>1</Selectivity>
</Property>
<Property name="ATTENDMandatoryRefDoctor">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ATTENDMandatoryRefHospital">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ATTENDNationalCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="ATTENDRefType">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="ATTENDStatisticIndicator">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("ATTEND",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ATTEND_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ATTEND_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATTEND_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATTEND_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATTEND_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ATTEND_MandatoryRefDoctor">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ATTEND_MandatoryRefHospital">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ATTEND_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ATTEND_RefType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ATTEND_StatisticIndicator">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ATTEND_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ATTEND"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ATTEND_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ATTEND_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ATTEND"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ATTEND_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATTEND_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ATTEND_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ATTEND"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({ATTEND_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATTEND_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ATTEND_RowId</SqlRowIdName>
<StreamLocation>^User.PACSourceOfAttendanceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
