/// Payor Office / Debtor (ARCIA,1165)
Class User.ARCInsurAssociation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_InsurAssociation, StorageStrategy = SQLStorage ]
{

/// Address
Property INSASAddress As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = INSAS_Address, SqlListType = SUBNODE ];

/// Billing Address
Property INSASBillingAddress As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 12, SqlFieldName = INSAS_BillingAddress, SqlListType = SUBNODE ];

/// Des Ref City
Property INSASCityDR As CTCity [ SqlColumnNumber = 14, SqlFieldName = INSAS_City_DR ];

/// Code
Property INSASCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = INSAS_Code ];

/// Date To
Property INSASDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = INSAS_DateTo ];

/// Insur Assoc Name
Property INSASDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = INSAS_Desc ];

/// Fax
Property INSASFax As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INSAS_Fax ];

/// Government Number
Property INSASGovernmentNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = INSAS_GovernmentNumber ];

/// Des Ref to InsType
Property INSASInsTypeDR As ARCInsuranceType [ Required, SqlColumnNumber = 8, SqlFieldName = INSAS_InsType_DR ];

/// Invoice Way
Property INSASInvoiceWay As %String(DISPLAYLIST = ",On Line,Delayed,Batch", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",O,D,B") [ SqlColumnNumber = 16, SqlFieldName = INSAS_InvoiceWay ];

/// Notes
Property INSASNotes As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 15, SqlFieldName = INSAS_Notes, SqlListType = SUBNODE ];

/// Des Ref OfficeAgent
Property INSASOfficeAgentDR As ARCOfficeAgent [ SqlColumnNumber = 17, SqlFieldName = INSAS_OfficeAgent_DR ];

/// Des Ref OfficeCateg
Property INSASOfficeCategDR As ARCOfficeCategory [ SqlColumnNumber = 18, SqlFieldName = INSAS_OfficeCateg_DR ];

/// Des Ref OfficePaymCondition
Property INSASOfficePaymConditDR As ARCOfficePaymCondition [ SqlColumnNumber = 19, SqlFieldName = INSAS_OfficePaymCondit_DR ];

/// Phone
Property INSASPhone As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = INSAS_Phone ];

/// Start Date of Service
Property INSASStartDate As %Date [ SqlColumnNumber = 6, SqlFieldName = INSAS_StartDate ];

/// State Number
Property INSASStateNumber As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = INSAS_StateNumber ];

/// Des Ref to CTZip
Property INSASZipDR As CTZip [ SqlColumnNumber = 9, SqlFieldName = INSAS_Zip_DR ];

Parameter EXTENTSIZE = 3;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsurAssociation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAssociation","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsurAssociation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAssociation","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsurAssociation).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAssociation","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsurAssociation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAssociation","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsurAssociation).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.ARCInsurAssociation","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="INSASAddress">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INSASBillingAddress">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INSASCityDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASCode">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INSASDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASDesc">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INSASFax">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASGovernmentNumber">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASInsTypeDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INSASInvoiceWay">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INSASNotes">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INSASOfficeAgentDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASOfficeCategDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASOfficePaymConditDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASPhone">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASStartDate">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASStateNumber">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INSASZipDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ARC("INSAS",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INSAS_Address">
<Node>"ADDR"</Node>
</Data>
<Data name="INSAS_BillingAddress">
<Node>"BILL"</Node>
</Data>
<Data name="INSAS_City_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSAS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSAS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSAS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSAS_Fax">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INSAS_GovernmentNumber">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSAS_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSAS_InvoiceWay">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSAS_Notes">
<Node>"NOTES"</Node>
</Data>
<Data name="INSAS_OfficeAgent_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INSAS_OfficeCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INSAS_OfficePaymCondit_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INSAS_Phone">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSAS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSAS_StateNumber">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSAS_Zip_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INSAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INSAS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INSAS_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INSAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INSAS_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INSAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INSAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSAS_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INSAS_Desc})_"Z"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsTypeCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INSAS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSAS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INSAS_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({INSAS_Code})_"Z"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INSAS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INSAS_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsurAssociationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
