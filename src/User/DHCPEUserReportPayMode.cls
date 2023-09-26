Class User.DHCPEUserReportPayMode Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RPM_RowId, SqlTableName = DHC_PE_UserReportPayMode, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEUserReportPayMode";

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On RPMChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_PE_USERREPORT Parent Reference
Relationship RPMParRef As User.DHCPEUSERREPORT [ Cardinality = parent, Inverse = ChildDHCPEUserReportPayMode, Required, SqlFieldName = RPM_ParRef ];

/// RPM_ChildSub
Property RPMChildSub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCPEUSERREPORT($p(%d(0),$c(1),1),"PAYMODE",0))}, Required, SqlColumnNumber = 2, SqlFieldName = RPM_ChildSub ];

/// RPM_PayMode_DR
Property RPMPayModeDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RPM_PayMode_DR ];

/// RPM_PayAmount
Property RPMPayAmount As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RPM_PayAmount ];

/// RPM_NormalAmount
Property RPMNormalAmount As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = RPM_NormalAmount ];

/// RPM_NormalNum
Property RPMNormalNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RPM_NormalNum ];

/// RPM_RefundAmount
Property RPMRefundAmount As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = RPM_RefundAmount ];

/// RPM_RefundNum
Property RPMRefundNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = RPM_RefundNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="RPM_NormalAmount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RPM_NormalNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RPM_PayAmount">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RPM_PayMode_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RPM_RefundAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RPM_RefundNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPEUSERREPORT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_PE_USERREPORT.RP_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>RPM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_USERREPORT.RP_ROWID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAYMODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{RPM_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexPayMode">
<Global>^DHCPEUSERREPORT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHC_PE_USERREPORT.RP_ROWID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>RPM_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"USERPAYMODE"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHC_PE_USERREPORT.RP_ROWID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{RPM_PayMode_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{RPM_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEUserReportPayModeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
