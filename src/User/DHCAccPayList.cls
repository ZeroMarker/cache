Class User.DHCAccPayList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccPL_RowID, SqlTableName = DHC_AccPayList, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On AccPLSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccManager Parent Reference
Relationship AccPLParRef As User.DHCAccManager [ Cardinality = parent, Inverse = ChildDHCAccPayList, Required, SqlFieldName = AccPL_ParRef ];

/// AccPL_Sub
Property AccPLSub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccM",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"AccPL",0))}, SqlColumnNumber = 2, SqlFieldName = AccPL_Sub ];

/// AccPL_PAPMI_DR
Property AccPLPAPMIDR As User.PAPatMas [ SqlColumnNumber = 3, SqlFieldName = AccPL_PAPMI_DR ];

/// AccPL_InvPrt_DR
Property AccPLInvPrtDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AccPL_InvPrt_DR ];

/// AccPL_PAPMINo
Property AccPLPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AccPL_PAPMINo ];

/// AccPL_BillNo
Property AccPLBillNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AccPL_BillNo ];

/// AccPL_User_DR
Property AccPLUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = AccPL_User_DR ];

/// AccPL_PayDate
Property AccPLPayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = AccPL_PayDate ];

/// AccPL_PayTime
Property AccPLPayTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = AccPL_PayTime ];

/// AccPL_PayNum
Property AccPLPayNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = AccPL_PayNum ];

/// AccPL_Left
Property AccPLLeft As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = AccPL_Left ];

/// AccPL_PayRecLoc_DR
Property AccPLPayRecLocDR As User.CTLoc [ SqlColumnNumber = 12, SqlFieldName = AccPL_PayRecLoc_DR ];

/// AccPL_BusiType 业务类型(OP:门诊收费, CARD:卡费, PE:体检收费)
Property AccPLBusiType As %Library.String(MAXLEN = 30, TRUNCATE = 0, VALUELIST = ",OP,CARD,PE") [ SqlColumnNumber = 13, SqlFieldName = AccPL_BusiType ];

/// AccPL_Note2
Property AccPLNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccPL_Note2 ];

/// AccPL_Note3
Property AccPLNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AccPL_Note3 ];

/// AccPL_Note4
Property AccPLNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AccPL_Note4 ];

/// AccPL_Note5
Property AccPLNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AccPL_Note5 ];

/// AccPL_Hospital_DR
Property AccPLHospitalDR As User.CTHospital [ Required, SqlColumnNumber = 18, SqlFieldName = AccPL_Hospital_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AccPL_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccPL_BusiType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccPL_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccPL_InvPrt_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccPL_Left">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccPL_Note2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccPL_Note3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccPL_Note4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccPL_Note5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccPL_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccPL_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccPL_PayDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccPL_PayNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccPL_PayRecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccPL_PayTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccPL_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AccPL_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"AccPL"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPL_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInvPrtDR">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>AccPL_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"InvPrtDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AccPL_BusiType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPL_InvPrt_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>"AccPL"</Expression>
</Subscript>
<Subscript name="8">
<AccessType>sub</AccessType>
<Expression>{AccPL_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPayDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccManager.AccM_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPL_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccM"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PayDate"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPL_PayDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccManager.AccM_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"AccPL"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccPL_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPayListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
