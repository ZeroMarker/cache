/// RespUnitHead(2507)
Class User.CTRespUnitHead Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_RespUnitHead, StorageStrategy = SQLStorage ]
{

/// Des Ref RespUnit
Property RUHRespUnitDR As CTResponsibleUnit [ SqlColumnNumber = 2, SqlFieldName = RUH_RespUnit_DR ];

/// Des Ref Hospital
Property RUHHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = RUH_Hospital_DR ];

/// Des Ref CareProv
Property RUHCareProvDR As CTCareProv [ SqlColumnNumber = 4, SqlFieldName = RUH_CareProv_DR ];

/// DateFrom
Property RUHDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = RUH_DateFrom ];

/// DateTo
Property RUHDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = RUH_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTRespUnitHead).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRespUnitHead","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTRespUnitHead).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRespUnitHead","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTRespUnitHead).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRespUnitHead","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTRespUnitHead).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRespUnitHead","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTRespUnitHead).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTRespUnitHead","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("RUHEAD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RUH_CareProv_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RUH_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RUH_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RUH_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RUH_RespUnit_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RUH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUHEAD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RUH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RUH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUHEAD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RUH_CareProv_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RUH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RUH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RUHEAD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RUH_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RUH_RespUnit_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RUH_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RUH_RowId</SqlRowIdName>
<StreamLocation>^User.CTRespUnitHeadS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
