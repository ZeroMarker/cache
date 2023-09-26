Class User.DHCAccQueryFootSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccQFS_RowID, SqlTableName = DHC_AccQueryFootSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AccQFSSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccQueryFoot Parent Reference
Relationship AccQFSParRef As User.DHCAccQueryFoot [ Cardinality = parent, Inverse = ChildDHCAccQueryFootSub, Required, SqlFieldName = AccQFS_ParRef ];

/// AccQFS_Sub
Property AccQFSSub As %Library.Float [ InitialExpression = {$i(^DHCACDTMPQUERY(+%d(0),"QPF",0))}, SqlColumnNumber = 2, SqlFieldName = AccQFS_Sub ];

/// AccQFS_AccM_DR
Property AccQFSAccMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = AccQFS_AccM_DR ];

/// AccQFS_PreLeft
Property AccQFSPreLeft As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = AccQFS_PreLeft ];

/// AccQFS_CardPay
Property AccQFSCardPay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AccQFS_CardPay ];

/// AccQFS_CurLeft
Property AccQFSCurLeft As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AccQFS_CurLeft ];

/// AccQFS_RefundPrePay
Property AccQFSRefundPrePay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AccQFS_RefundPrePay ];

/// AccQFS_PrePay
Property AccQFSPrePay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AccQFS_PrePay ];

/// AccQFS_AccTimeType
Property AccQFSAccTimeType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AccQFS_AccTimeType ];

/// AccQFS_CurQFSum
Property AccQFSCurQFSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AccQFS_CurQFSum ];

/// AccQFS_Note1
Property AccQFSNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AccQFS_Note1 ];

/// AccQFS_Note2
Property AccQFSNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AccQFS_Note2 ];

/// AccQFS_Note3
Property AccQFSNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccQFS_Note3 ];

/// AccQFS_Note5
Property AccQFSNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccQFS_Note4 ];

/// AccQFS_Note5
Property AccQFSNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AccQFS_Note5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AccQFS_AccM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccQFS_AccTimeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccQFS_CardPay">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccQFS_CurLeft">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccQFS_CurQFSum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccQFS_Note1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccQFS_Note2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccQFS_Note3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccQFS_Note4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccQFS_Note5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccQFS_PreLeft">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccQFS_PrePay">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccQFS_RefundPrePay">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCACDTMPQUERY</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AccQueryFoot.AccQF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AccQFS_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_AccQueryFoot.AccQF_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"QPF"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AccQFS_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccQueryFootSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
