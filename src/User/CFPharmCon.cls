/// Pharmacy Configuration  (PHCF,5002)
Class User.CFPharmCon Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_PharmCon, StorageStrategy = SQLStorage ]
{

/// Auto Refresh Queue
Property PHCFAutoRefreshQueue As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 8, SqlFieldName = PHCF_AutoRefreshQueue ];

/// Customise Drug Label
Property PHCFCustomiseDrgLabelDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PHCF_CustomiseDrgLabel_DR ];

/// Default Dispensing Confirmation (Yes/No)
Property PHCFDefDispConfirm As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 16, SqlFieldName = PHCF_DefDispConfirm ];

/// Default In Patient dispensing item
Property PHCFDefInPatDisp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 15, SqlFieldName = PHCF_DefInPatDisp ];

/// Default Out Patient Dispensing Item
Property PHCFDefOutPatDisp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 7, SqlFieldName = PHCF_DefOutPatDisp ];

/// Description
Property PHCFDescription As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = PHCF_Description ];

/// Allowance for Expiry Date
Property PHCFExpAllow As %Float(MAXVAL = 999, MINVAL = 0) [ SqlColumnNumber = 6, SqlFieldName = PHCF_ExpAllow ];

/// Print Drug Label
Property PHCFPrintDrgLabel As %String(DISPLAYLIST = ",Auto Print,Prompt,None", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",A,P,N") [ InitialExpression = "None", Required, SqlColumnNumber = 13, SqlFieldName = PHCF_PrintDrgLabel ];

/// Last Update Date
Property PHCFUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PHCF_UpdateDate ];

/// Last Update Time
Property PHCFUpdateTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PHCF_UpdateTime ];

/// Last Update User
Property PHCFUpdateUserDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 11, SqlFieldName = PHCF_UpdateUser_DR ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFPharmCon).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFPharmCon","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFPharmCon).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFPharmCon","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFPharmCon).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFPharmCon","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFPharmCon).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFPharmCon","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFPharmCon).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.CFPharmCon","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="PHCFAutoRefreshQueue">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHCFCustomiseDrgLabelDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PHCFDefDispConfirm">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHCFDefInPatDisp">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHCFDefOutPatDisp">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="PHCFDescription">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PHCFExpAllow">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PHCFPrintDrgLabel">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="PHCFUpdateDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PHCFUpdateTime">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="PHCFUpdateUserDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^CF("PH",0))</SqlIdExpression>
<SQLMap name="DataMasterPHCF">
<Data name="PHCF_AutoRefreshQueue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHCF_CustomiseDrgLabel_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHCF_DefDispConfirm">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHCF_DefInPatDisp">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHCF_DefOutPatDisp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHCF_Description">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHCF_ExpAllow">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHCF_PrintDrgLabel">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHCF_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHCF_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHCF_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>PHCF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"PH"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{PHCF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PHCF_RowId</SqlRowIdName>
<StreamLocation>^User.CFPharmConS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
