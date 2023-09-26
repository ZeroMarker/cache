/// PAC HRG Codes(1947)
Class User.PACHRGCodes Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_HRGCodes, StorageStrategy = SQLStorage ]
{

/// Code
Property HRGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = HRG_Code ];

/// Description
Property HRGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = HRG_Desc ];

/// Date From
Property HRGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = HRG_DateFrom ];

/// Date To
Property HRGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = HRG_DateTo ];

/// Episode Type
Property HRGEpisodeType As %String(DISPLAYLIST = ",Inpatient,Outpatient", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",I,O") [ SqlColumnNumber = 6, SqlFieldName = HRG_EpisodeType ];

/// CT_Loc des ref
Property HRGLocationDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = HRG_LocationDR ];

/// Department Group
Property HRGDepartmwentGroup As RBCDepartmentGroup [ SqlColumnNumber = 8, SqlFieldName = HRG_DepartmwentGroup ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACHRGCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACHRGCodes","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACHRGCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACHRGCodes","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACHRGCodes).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACHRGCodes","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACHRGCodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACHRGCodes","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACHRGCodes).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACHRGCodes","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("HRG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="HRG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="HRG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="HRG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="HRG_DepartmwentGroup">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="HRG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="HRG_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="HRG_LocationDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>HRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{HRG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HRG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>HRG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"HRG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({HRG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HRG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HRG_RowId</SqlRowIdName>
<StreamLocation>^User.PACHRGCodesS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
