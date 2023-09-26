Class User.DHCINVPRTReportsInsType Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ITC_RowID, SqlTableName = DHC_INVPRTReportsInsType, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ITCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INVPRTReports Parent Reference
Relationship ITCRepParRef As User.DHCINVPRTReports [ Cardinality = parent, Inverse = ChildDHCINVPRTReportsInsType, Required, SqlFieldName = ITC_Rep_ParRef ];

/// ITC_ChildSub
Property ITCChildSub As %Library.Float [ InitialExpression = {$i(^DHCOPInsFoot($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"IC",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ITC_ChildSub ];

/// ITC_InsType_DR 费别指针
Property ITCInsTypeDR As User.PACAdmReason [ SqlColumnNumber = 3, SqlFieldName = ITC_InsType_DR ];

/// ITC_Paymode_DR 支付方式指针
Property ITCPaymodeDR As User.CTPayMode [ SqlColumnNumber = 4, SqlFieldName = ITC_Paymode_DR ];

/// ITC_PRTPaySum 收费金额
Property ITCPRTPaySum As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = ITC_PRTPaySum ];

/// ITC_PRTPayNum 收费笔数
Property ITCPRTPayNum As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = ITC_PRTPayNum ];

/// ITC_PRTRefundSum 退费金额
Property ITCPRTRefundSum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = ITC_PRTRefundSum ];

/// ITC_PRTRefundNum 退费笔数
Property ITCPRTRefundNum As %Library.Integer [ SqlColumnNumber = 8, SqlFieldName = ITC_PRTRefundNum ];

/// ITC_APIPaySum 集中打印发票金额
Property ITCAPIPaySum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = ITC_APIPaySum ];

/// ITC_APIPayNum 集中打印发票笔数
Property ITCAPIPayNum As %Library.Integer [ SqlColumnNumber = 10, SqlFieldName = ITC_APIPayNum ];

/// ITC_APIRefundSum 集中打印发票作废/红冲金额
Property ITCAPIRefundSum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = ITC_APIRefundSum ];

/// ITC_APIRefundNum 集中打印发票作废/红冲笔数
Property ITCAPIRefundNum As %Library.Integer [ SqlColumnNumber = 12, SqlFieldName = ITC_APIRefundNum ];

/// ITC_ChargeType 业务类型
Property ITCChargeType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ITC_ChargeType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITC_APIPayNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ITC_APIPaySum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ITC_APIRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ITC_APIRefundSum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ITC_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ITC_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITC_PRTPayNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITC_PRTPaySum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITC_PRTRefundNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ITC_PRTRefundSum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ITC_Paymode_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCOPInsFoot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INVPRTReports.HIS_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ITC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INVPRTReports.HIS_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ITC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTReportsInsTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Parameter EXTENTSIZE = 250;

}
