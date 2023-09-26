/// Coda Extract Build(2595)
Class User.PACodaExtractBuild Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CodaExtractBuild, StorageStrategy = SQLStorage ]
{

/// Date From
Property EXBDateFrom As %Date [ SqlColumnNumber = 2, SqlFieldName = EXB_DateFrom ];

/// Date To
Property EXBDateTo As %Date [ SqlColumnNumber = 3, SqlFieldName = EXB_DateTo ];

/// Des Ref Hospital
Property EXBHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = EXB_Hospital_DR ];

/// Des Ref AccountPeriod
Property EXBAccountPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 5, SqlFieldName = EXB_AccountPeriod_DR ];

/// DateRun
Property EXBDateRun As %Date [ SqlColumnNumber = 6, SqlFieldName = EXB_DateRun ];

/// TimeRun
Property EXBTimeRun As %Time [ SqlColumnNumber = 7, SqlFieldName = EXB_TimeRun ];

/// Des Ref User
Property EXBUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = EXB_User_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACodaExtractBuild).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtractBuild","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACodaExtractBuild).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtractBuild","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACodaExtractBuild).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtractBuild","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACodaExtractBuild).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtractBuild","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACodaExtractBuild).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtractBuild","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PA("CODAEXB",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="EXB_AccountPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EXB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EXB_DateRun">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EXB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EXB_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EXB_TimeRun">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EXB_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EXB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODAEXB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EXB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccountPeriod">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EXB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODAEXB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"AccPer"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXB_AccountPeriod_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EXB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODAEXB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EXB_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EXB_RowId</SqlRowIdName>
<StreamLocation>^User.PACodaExtractBuildS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
