/// ARC Item Epis Billing(1849)
Class User.ARCItemEpisodicBilling Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemEpisodicBilling, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EPChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship EPParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemEpisodicBilling, Required, SqlFieldName = EP_ParRef ];

/// Childsub
Property EPChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"EP",0))}, SqlColumnNumber = 2, SqlFieldName = EP_Childsub ];

/// Date From
Property EPDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = EP_DateFrom ];

/// Date To
Property EPDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = EP_DateTo ];

/// Des Ref InsType
Property EPInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 5, SqlFieldName = EP_InsType_DR ];

/// Des Ref AuxInsType
Property EPAuxInsTypeDR As ARCAuxilInsurType [ SqlColumnNumber = 6, SqlFieldName = EP_AuxInsType_DR ];

/// BillField1
Property EPBillField1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = EP_BillField1 ];

/// BillField2
Property EPBillField2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = EP_BillField2 ];

/// BillField3
Property EPBillField3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = EP_BillField3 ];

/// BillField4
Property EPBillField4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = EP_BillField4 ];

/// BillField5
Property EPBillField5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = EP_BillField5 ];

/// BillField6
Property EPBillField6 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = EP_BillField6 ];

/// Des Ref Contract
Property EPContractDR As BLCContractDetails [ SqlColumnNumber = 13, SqlFieldName = EP_Contract_DR ];

/// Include Private Supplements
Property EPIncludePrivateSuppl As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = EP_IncludePrivateSuppl ];

/// Des Ref EpisBill
Property EPEpisBillDR As ARCEpisodicBilling [ SqlColumnNumber = 15, SqlFieldName = EP_EpisBill_DR ];

/// Des Ref CTCP
Property EPCTCPDR As CTCareProv [ SqlColumnNumber = 16, SqlFieldName = EP_CTCP_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemEpisodicBilling).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemEpisodicBilling","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemEpisodicBilling).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemEpisodicBilling","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemEpisodicBilling).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemEpisodicBilling","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemEpisodicBilling).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemEpisodicBilling","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemEpisodicBilling).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemEpisodicBilling","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EP_AuxInsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EP_BillField1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EP_BillField2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EP_BillField3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EP_BillField4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EP_BillField5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EP_BillField6">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EP_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EP_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EP_EpisBill_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EP_IncludePrivateSuppl">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EP_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>EP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>EP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EP_DateFrom}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{EP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EP_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemEpisodicBillingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
