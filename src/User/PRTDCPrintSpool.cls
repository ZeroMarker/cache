/// \PRTDC Print Spool DICOM(PRTDC)
Class User.PRTDCPrintSpool Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PRTDC_PrintSpool, StorageStrategy = SQLStorage ]
{

/// Description
Property PRTDCDescription As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PRTDC_Description ];

/// Page Layout Image List
Property PRTDCImages As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PRTDC_Images ];

/// Parameter
Property PRTDCParameter As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PRTDC_Parameter ];

/// Printed Date
Property PRTDCPrintedDate As %Date [ SqlColumnNumber = 9, SqlFieldName = PRTDC_PrintedDate ];

/// Printed Time
Property PRTDCPrintedTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PRTDC_PrintedTime ];

/// Requested Date
Property PRTDCRequestedDate As %Date [ SqlColumnNumber = 4, SqlFieldName = PRTDC_RequestedDate ];

/// Requested Time
Property PRTDCRequestedTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PRTDC_RequestedTime ];

/// Print Status
Property PRTDCStatus As %String(DISPLAYLIST = ",Ready,Hold,Printed,Errored", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",R,H,P,E") [ InitialExpression = "Ready", SqlColumnNumber = 2, SqlFieldName = PRTDC_Status ];

/// User Requested
Property PRTDCUserDR As SSUser [ SqlColumnNumber = 6, SqlFieldName = PRTDC_User_DR ];

/// User Location
Property PRTDCUserLocationDR As CTLoc [ SqlColumnNumber = 7, SqlFieldName = PRTDC_UserLocation_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PRTDCPrintSpool).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PRTDCPrintSpool","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PRTDCPrintSpool).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PRTDCPrintSpool","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PRTDCPrintSpool).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PRTDCPrintSpool","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PRTDCPrintSpool).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PRTDCPrintSpool","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PRTDCPrintSpool).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PRTDCPrintSpool","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PRTDCDescription">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCImages">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCParameter">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCPrintedDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCPrintedTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCRequestedDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCRequestedTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCStatus">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="PRTDCUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="PRTDCUserLocationDR">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PRTDCM(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRTDC_Description">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRTDC_Images">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PRTDC_Parameter">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PRTDC_PrintedDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PRTDC_PrintedTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PRTDC_RequestedDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PRTDC_RequestedTime">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRTDC_Status">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRTDC_UserLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PRTDC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PRTDCM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRTDC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PRTDC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateTime">
<Global>^PRTDCMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PRTDC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRTDC_RequestedDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRTDC_RequestedTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PRTDC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^PRTDCMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PRTDC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PRTDC_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRTDC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PRTDC_RowId</SqlRowIdName>
<StreamLocation>^User.PRTDCPrintSpoolS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
