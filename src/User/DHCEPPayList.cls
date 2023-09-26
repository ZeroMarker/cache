Class User.DHCEPPayList Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EPPL_RowID, SqlTableName = DHC_EPPayList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On EPPLSub [ IdKey, PrimaryKey, Unique ];

/// User.DHCEPManager Parent Reference
Relationship EPPLParref As User.DHCEPManager [ Cardinality = parent, Inverse = ChildDHCEPPayList, Required, SqlFieldName = EPPL_Parref ];

/// EPPL_Sub
Property EPPLSub As %Library.Float [ InitialExpression = {$i(^DHCEPM("EPM",+%d(0),"EPPL",0))}, SqlColumnNumber = 2, SqlFieldName = EPPL_Sub ];

/// EPPL_PAPMI_DR
Property EPPLPAPMIDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EPPL_PAPMI_DR ];

/// EPPL_InvPrt_DR
Property EPPLInvPrtDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EPPL_InvPrt_DR ];

/// EPPL_BillNo
Property EPPLBillNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EPPL_BillNo ];

/// EPPL_User_DR
Property EPPLUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EPPL_User_DR ];

/// EPPL_PayDate
Property EPPLPayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = EPPL_PayDate ];

/// EPPL_PayTime	
Property EPPLPayTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = EPPL_PayTime ];

/// EPPL_PayNum
Property EPPLPayNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = EPPL_PayNum ];

/// EPPL_Left
Property EPPLLeft As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = EPPL_Left ];

/// EPPL_PayRecLoc_DR
Property EPPLPayRecLocDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = EPPL_PayRecLoc_DR ];

/// EPPL_Hosp_DR
Property EPPLHospDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EPPL_Hosp_DR ];

/// EPPL_Note1
Property EPPLNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EPPL_Note1 ];

/// EPPL_Note2
Property EPPLNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = EPPL_Note2 ];

/// EPPL_Note3
Property EPPLNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EPPL_Note3 ];

/// EPPL_Note4
Property EPPLNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = EPPL_Note4 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EPPL_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EPPL_Hosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EPPL_InvPrt_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EPPL_Left">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EPPL_Note1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EPPL_Note2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EPPL_Note3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EPPL_Note4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EPPL_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EPPL_PayDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EPPL_PayNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EPPL_PayRecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EPPL_PayTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EPPL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEPM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>EPPL_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPPL"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPPL_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInvPrt">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPPL_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPPLInvPrt"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPPL_InvPrt_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPPL"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPPL_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayDate">
<Global>^DHCEPMi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_EPManager.EPM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>EPPL_Sub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"EPM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"EPPLPayDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{EPPL_PayDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{DHC_EPManager.EPM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>Sub</AccessType>
<Expression>"EPPL"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>Sub</AccessType>
<Expression>{EPPL_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEPPayListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
