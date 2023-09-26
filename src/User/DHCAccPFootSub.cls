Class User.DHCAccPFootSub Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccPFS_RowID, SqlTableName = DHC_AccPFootSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AccPFSSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AccPFoot Parent Reference
Relationship AccPFSParRef As User.DHCAccPFoot [ Cardinality = parent, Inverse = ChildDHCAccPFootSub, Required, SqlFieldName = AccPFS_ParRef ];

/// AccPFS_Sub
Property AccPFSSub As %Library.Float [ InitialExpression = {$i(^DHCACD("AccPF",+%d(0),"PF",0))}, SqlColumnNumber = 2, SqlFieldName = AccPFS_Sub ];

/// AccPFS_AccM_DR
Property AccPFSAccMDR As User.DHCAccManager [ SqlColumnNumber = 3, SqlFieldName = AccPFS_AccM_DR ];

/// AccPFS_PreLeft
Property AccPFSPreLeft As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = AccPFS_PreLeft ];

/// AccPFS_CardPay
Property AccPFSCardPay As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = AccPFS_CardPay ];

/// AccPFS_CurLeft
Property AccPFSCurLeft As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = AccPFS_CurLeft ];

/// AccPFS_RefundPrePay
Property AccPFSRefundPrePay As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = AccPFS_RefundPrePay ];

/// AccPFS_PrePay
Property AccPFSPrePay As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = AccPFS_PrePay ];

/// AccPFS_AccTimeType
Property AccPFSAccTimeType As %Library.String(DISPLAYLIST = ",PayDate,UseRepDate,GetRepDate", MAXLEN = 10, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",PD,RD,GRD") [ SqlColumnNumber = 9, SqlFieldName = AccPFS_AccTimeType ];

/// AccPFS_CuQFSum
Property AccPFSCurQFSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AccPFS_CurQFSum ];

/// AccPFS_Note4
Property AccPFSNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AccPFS_Note4 ];

/// AccPFS_Note5
Property AccPFSNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AccPFS_Note5 ];

/// AccPFS_Note6
Property AccPFSNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccPFS_Note6 ];

/// AccPFS_Note7
Property AccPFSNote7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccPFS_Note7 ];

/// AccPFS_Note8
Property AccPFSNote8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = AccPFS_Note8 ];

/// AccPFS_Note9
Property AccPFSNote9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AccPFS_Note9 ];

/// AccPFS_Note10
Property AccPFSNote10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AccPFS_Note10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AccPFS_AccM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccPFS_AccTimeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccPFS_CardPay">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccPFS_CurLeft">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccPFS_CurQFSum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccPFS_Note10">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccPFS_Note4">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccPFS_Note5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccPFS_Note6">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccPFS_Note7">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccPFS_Note8">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccPFS_Note9">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccPFS_PreLeft">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccPFS_PrePay">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccPFS_RefundPrePay">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_AccPFoot.AccPF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>AccPFS_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DHC_AccPFoot.AccPF_RowID}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"PF"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPFS_Sub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAccMDR">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_AccPFoot.AccPF_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>AccPFS_Sub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPF"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"AccMDR"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPFS_AccM_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DHC_AccPFoot.AccPF_RowID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>"PF"</Expression>
</Subscript>
<Subscript name="7">
<AccessType>sub</AccessType>
<Expression>{AccPFS_Sub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPFootSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
