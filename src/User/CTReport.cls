/// CT Report List             (RP,636)
Class User.CTReport Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_Report, StorageStrategy = SQLStorage ]
{

/// Report Code
Property RPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = RP_Code ];

/// Crystal Report Name
Property RPCrystalReportName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = RP_CrystalReportName ];

/// Des Ref to CT_Modules
Property RPMODDR As CTModules [ Required, SqlColumnNumber = 4, SqlFieldName = RP_MOD_DR ];

/// Report Name
Property RPName As %String(COLLATION = "AlphaUp", MAXLEN = 40, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = RP_Name ];

/// ActiveX Object Reference
Property RPObjectReference As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = RP_ObjectReference ];

/// P1 Conversion
Property RPP1Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 13, SqlFieldName = RP_P1Conversion ];

/// P2 Conversion
Property RPP2Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 14, SqlFieldName = RP_P2Conversion ];

/// P3 Conversion
Property RPP3Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 15, SqlFieldName = RP_P3Conversion ];

/// P4 Conversion
Property RPP4Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 16, SqlFieldName = RP_P4Conversion ];

/// P5 Conversion
Property RPP5Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 17, SqlFieldName = RP_P5Conversion ];

/// P6 Conversion
Property RPP6Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 18, SqlFieldName = RP_P6Conversion ];

/// P7 Conversion
Property RPP7Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 19, SqlFieldName = RP_P7Conversion ];

/// P8 Conversion
Property RPP8Conversion As %String(DISPLAYLIST = ",From Date,To Date", MAXLEN = 9, TRUNCATE = 1, VALUELIST = ",F,T") [ SqlColumnNumber = 20, SqlFieldName = RP_P8Conversion ];

/// Print Preview
Property RPPrintPreview As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = RP_PrintPreview ];

/// Program Name
Property RPProgramName As %String(COLLATION = "Exact", MAXLEN = 25, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = RP_ProgramName ];

/// Prompt For Parameters
Property RPPromptForParameters As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = RP_PromptForParameters ];

/// Remarks
Property RPRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = RP_Remarks, SqlListType = SUBNODE ];

/// CTRPT Row ID
Property RPRowId As %String(TRUNCATE = 1) [ InitialExpression = {$i(^SS("RP",0))}, Required, SqlFieldName = RP_RowId ];

Index RPCodeUnqIdx1 On RPCode [ Unique ];

Index RPNameUnqIdx2 On RPName [ Unique ];

Index RowIDBasedIDKeyIndex On RPRowId [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 572;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTReport).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTReport","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTReport).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTReport","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTReport).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTReport","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTReport).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTReport","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTReport).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CTReport","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>572</ExtentSize>
<Property name="RPCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RPCrystalReportName">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="RPMODDR">
<Selectivity>3.0303%</Selectivity>
</Property>
<Property name="RPName">
<Selectivity>1</Selectivity>
</Property>
<Property name="RPObjectReference">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP1Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP2Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP3Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP4Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP5Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP6Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP7Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPP8Conversion">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPPrintPreview">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPProgramName">
<Selectivity>1.2987%</Selectivity>
</Property>
<Property name="RPPromptForParameters">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RPRemarks">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="RPRowId">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^SS("RP",0))</SqlIdExpression>
<SQLMap name="DataMasterCTRP">
<Data name="RP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RP_CrystalReportName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RP_MOD_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RP_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RP_ObjectReference">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RP_P1Conversion">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RP_P2Conversion">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RP_P3Conversion">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RP_P4Conversion">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RP_P5Conversion">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="RP_P6Conversion">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="RP_P7Conversion">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="RP_P8Conversion">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="RP_PrintPreview">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RP_ProgramName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RP_PromptForParameters">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RP_Remarks">
<Node>"REM"</Node>
</Data>
<Global>^SS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTRPCode">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({RP_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RP_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTRPDesc">
<Global>^SS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"RP"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({RP_Name})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RP_RowId}</Expression>
<StartValue>1</StartValue>
<StopValue>999999999</StopValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RP_RowId</SqlRowIdName>
<StreamLocation>^User.CTReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
