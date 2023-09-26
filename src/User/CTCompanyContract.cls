/// CT Company Contract
Class User.CTCompanyContract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_CompanyContract, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CONTChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_Company Parent Reference
Relationship CONTParRef As CTCompany [ Cardinality = parent, Inverse = ChildCTCompanyContract, Required, SqlFieldName = CONT_ParRef ];

/// Childsub
Property CONTChildsub As %Float [ InitialExpression = {$i(^CT("CTCO",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CONT",0))}, SqlColumnNumber = 2, SqlFieldName = CONT_Childsub ];

/// Contract Code
Property CONTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CONT_Code ];

/// Start Date
Property CONTStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CONT_StartDate ];

/// End Date
Property CONTEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CONT_EndDate ];

/// Discount Amt
Property CONTDiscAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = CONT_DiscAmt ];

/// Discount %
Property CONTDiscPerc As %Float [ SqlColumnNumber = 7, SqlFieldName = CONT_DiscPerc ];

/// Notes
Property CONTNotes As list Of %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CONT_Notes, SqlListType = SUBNODE ];

/// No of people
Property CONTNo As %Float [ SqlColumnNumber = 9, SqlFieldName = CONT_No ];

/// Des Ref to ARCOS
Property CONTTestTypeDR As ARCOrdSets [ SqlColumnNumber = 10, SqlFieldName = CONT_TestType_DR ];

/// Des Ref to ARCOS
Property CONTAdditTestItemsDR As ARCOrdSets [ SqlColumnNumber = 11, SqlFieldName = CONT_AdditTestItems_DR ];

/// Des Ref  to DiscReason
Property CONTDiscReasonDR As HPCDiscountReason [ SqlColumnNumber = 12, SqlFieldName = CONT_DiscReason_DR ];

/// Des Ref INCI
Property CONTINCIDR As INCItm [ SqlColumnNumber = 13, SqlFieldName = CONT_INCI_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTCompanyContract).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCompanyContract","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTCompanyContract).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCompanyContract","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTCompanyContract).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCompanyContract","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTCompanyContract).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCompanyContract","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTCompanyContract).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTCompanyContract","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CONT_AdditTestItems_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CONT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CONT_DiscAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CONT_DiscPerc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CONT_DiscReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CONT_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CONT_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CONT_No">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CONT_Notes">
<Node>"REM"</Node>
</Data>
<Data name="CONT_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CONT_TestType_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_Company.CTCO_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CONT_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CTCO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_Company.CTCO_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CONT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CONT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CONT_RowId</SqlRowIdName>
<StreamLocation>^User.CTCompanyContractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
