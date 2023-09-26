/// Neonatal Morbidity(2260)
Class User.PACNeonatalMorbidity Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_NeonatalMorbidity, StorageStrategy = SQLStorage ]
{

/// Active flag
Property NEOMORBActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = NEOMORB_Active ];

/// Code
Property NEOMORBCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = NEOMORB_Code ];

/// Date from
Property NEOMORBDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = NEOMORB_DateFrom ];

/// Date To
Property NEOMORBDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = NEOMORB_DateTo ];

/// Description
Property NEOMORBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = NEOMORB_Desc ];

/// National Code
Property NEOMORBNationalCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = NEOMORB_NationalCode ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACNeonatalMorbidity).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNeonatalMorbidity","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACNeonatalMorbidity).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNeonatalMorbidity","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACNeonatalMorbidity).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNeonatalMorbidity","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACNeonatalMorbidity).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNeonatalMorbidity","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACNeonatalMorbidity).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACNeonatalMorbidity","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="NEOMORBActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="NEOMORBCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="NEOMORBDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="NEOMORBDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="NEOMORBDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="NEOMORBNationalCode">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("NEOMORB",0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="NEOMORB_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="NEOMORB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="NEOMORB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="NEOMORB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="NEOMORB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="NEOMORB_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>NEOMORB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NEOMORB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{NEOMORB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NEOMORB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NEOMORB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NEOMORB_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NEOMORB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>NEOMORB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"NEOMORB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({NEOMORB_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{NEOMORB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>NEOMORB_RowId</SqlRowIdName>
<StreamLocation>^User.PACNeonatalMorbidityS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
