Class User.DHCAccPayINVMode Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = APM_RowID, SqlTableName = DHC_AccPayINVMode, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APMSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccPayINV Parent Reference
Relationship APMAPIParRef As User.DHCAccPayINV [ Cardinality = parent, Inverse = ChildDHCAccPayINVMode, Required, SqlFieldName = APM_API_ParRef ];

/// APM_Sub
Property APMSub As %Library.Float [ InitialExpression = {$i(^DHCINVPRTAP($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"P",0))}, SqlColumnNumber = 2, SqlFieldName = APM_Sub ];

/// APM_PayMode_DR
Property APMPayModeDR As User.CTPayMode [ SqlColumnNumber = 3, SqlFieldName = APM_PayMode_DR ];

/// APM_CMBank_DR
Property APMCMBankDR As User.CMCBankMas [ SqlColumnNumber = 4, SqlFieldName = APM_CMBank_DR ];

/// APM_Amt
Property APMAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = APM_Amt ];

/// APM_CardChequeNo
Property APMCardChequeNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = APM_CardChequeNo ];

/// APM_Card_DR
Property APMCardDR As User.ARCBankCardType [ SqlColumnNumber = 7, SqlFieldName = APM_Card_DR ];

/// APM_Date
Property APMDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = APM_Date ];

/// APM_Time
Property APMTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = APM_Time ];

/// APM_Unit
Property APMUnit As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = APM_Unit ];

/// APM_PayAccNO
Property APMPayAccNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = APM_PayAccNO ];

/// APM_Note1
Property APMNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = APM_Note1 ];

/// APM_Note2
Property APMNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = APM_Note2 ];

/// APM_Note3
Property APMNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = APM_Note3 ];

/// APM_Note4
Property APMNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = APM_Note4 ];

/// APM_Note5
Property APMNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = APM_Note5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="APM_Amt">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="APM_CMBank_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="APM_CardChequeNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="APM_Card_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="APM_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="APM_Note1">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="APM_Note2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="APM_Note3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="APM_Note4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="APM_Note5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="APM_PayAccNO">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="APM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="APM_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="APM_Unit">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^DHCINVPRTAP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AccPayINV.API_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>APM_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_AccPayINV.API_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{APM_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPayINVModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
