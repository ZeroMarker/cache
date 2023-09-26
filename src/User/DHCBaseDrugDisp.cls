Class User.DHCBaseDrugDisp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BDD_RowId, SqlTableName = DHC_BaseDrugDisp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCBaseDrugDispItm As User.DHCBaseDrugDispItm [ Cardinality = children, Inverse = BDDIBDDParRef ];

/// BDD_CreateDate
Property BDDCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = BDD_CreateDate ];

/// BDD_Createtime
Property BDDCreatetime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = BDD_Createtime ];

/// BDD_CreateUser_DR
Property BDDCreateUserDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = BDD_CreateUser_DR ];

/// BDD_DispLoc_DR
Property BDDDispLocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = BDD_DispLoc_DR ];

/// BDD_PharmacyLoc_DR
Property BDDPharmacyLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = BDD_PharmacyLoc_DR ];

/// BDD_FromDate
Property BDDFromDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = BDD_FromDate ];

/// BDD_ToDate
Property BDDToDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = BDD_ToDate ];

/// BDD_Remark
Property BDDRemark As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BDD_Remark ];

/// BDD_RepFlag
Property BDDRepFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = BDD_RepFlag ];

/// BDD_RepDate
Property BDDRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = BDD_RepDate ];

/// BDD_RepUser
Property BDDRepUserDR As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = BDD_RepUser_DR ];

/// BDD_INRQ_DR
Property BDDINRQDR As User.INRequest [ SqlColumnNumber = 13, SqlFieldName = BDD_INRQ_DR ];

/// BDD_ReqType
Property BDDReqType As %Library.String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BDD_ReqType ];

/// BDD_FromTime
Property BDDFromTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = BDD_FromTime ];

/// BDD_ToTime
Property BDDToTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = BDD_ToTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCBDD(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BDD_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BDD_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BDD_Createtime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BDD_DispLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BDD_FromDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BDD_FromTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BDD_INRQ_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BDD_PharmacyLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BDD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BDD_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BDD_RepFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BDD_RepUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BDD_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BDD_ToDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BDD_ToTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCBDD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BDD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BDD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDispLoc">
<Global>^DHCBDD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DISPLOC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BDD_DispLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocReqTypeToDate">
<Global>^DHCBDD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BDD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCRQTPTODATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BDD_DispLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDD_ReqType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDD_ToDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{BDD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoctoDate">
<Global>^DHCBDD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BDD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCTODATE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BDD_DispLoc_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDD_ToDate}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{BDD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequest">
<Global>^DHCBDD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>BDD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"REQ"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{BDD_INRQ_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{BDD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCBaseDrugDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
