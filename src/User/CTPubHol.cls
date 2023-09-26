/// CT Public Holidays       (CTHOL,71)
Class User.CTPubHol Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_PubHol, StorageStrategy = SQLStorage ]
{

/// Public Holidays Code
Property CTHOLCode As %Date [ Required, SqlColumnNumber = 2, SqlFieldName = CTHOL_Code ];

/// Public Holidays Description
Property CTHOLDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTHOL_Desc ];

/// Des Ref Hospital
Property CTHOLHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = CTHOL_Hospital_DR ];

/// Not Use Flag
Property CTHOLNotUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 4, SqlFieldName = CTHOL_NotUseFlag ];

/// Use for Outpatients Only
Property CTHOLUseforOutpatientsOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CTHOL_UseforOutpatientsOnly ];

Parameter EXTENTSIZE = 27;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTPubHol).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPubHol","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTPubHol).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPubHol","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTPubHol).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPubHol","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTPubHol).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPubHol","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTPubHol).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTPubHol","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>27</ExtentSize>
<Property name="CTHOLCode">
<Selectivity>3.7037%</Selectivity>
</Property>
<Property name="CTHOLDesc">
<Selectivity>6.2500%</Selectivity>
</Property>
<Property name="CTHOLHospitalDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTHOLNotUseFlag">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="CTHOLUseforOutpatientsOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^CT("CTHOL",0))</SqlIdExpression>
<SQLMap name="CTHOLDataMasterMap">
<Data name="CTHOL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTHOL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTHOL_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTHOL_NotUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CTHOL_UseforOutpatientsOnly">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTHOL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTHOL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTHOL_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="CTHOLIndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTHOL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTHOL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTHOL_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{CTHOL_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTHOL_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="CTHOLIndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTHOL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"CTHOL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"CTHOL_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTHOL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTHOL_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTHOL_RowId</SqlRowIdName>
<StreamLocation>^User.CTPubHolS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
