/// Billing Point for Order SubCategory
Class User.DHCBillCondition Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BC_RowId, SqlTableName = DHC_BillCondition, StorageStrategy = SQLStorage ]
{

/// Order SubCategory
Property BCSubCateDr As User.ARCItemCat [ SqlColumnNumber = 2, SqlFieldName = BC_SubCate_Dr ];

/// Billing Condition
Property BCCondition As %Library.String(DISPLAYLIST = ",Order Entry or Discontinued,Order Executed,Nurse Executed,Result Return,Pharmacy Collected or Return,Specimen Collected", MAXLEN = 28, SELECTIVITY = "14.2857%", VALUELIST = ",OD,OE,NE,RR,CR,SC") [ SqlColumnNumber = 3, SqlFieldName = BC_Condition ];

/// BC_Hosp_Dr
Property BCHospDr As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = BC_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCTarC("BC"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BC_Condition">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BC_SubCate_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCTarC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{BC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXARCItmCat">
<Global>^DHCTarC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"BC"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BC_SubCate_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBillConditionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
