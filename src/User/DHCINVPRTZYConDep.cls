/// 名称: User.DHCINVPRTZYConDep.cls
/// 描述: 住院发票押金关联表
/// 编写者: ZhYW
/// 编写日期: 2022-12-22
/// 产品组：计费医保组
Class User.DHCINVPRTZYConDep Extends (%Persistent, User.Abstract) [ SqlRowIdName = ICD_RowId, SqlTableName = DHC_INVPRTZYConDep, StorageStrategy = SQLStorage ]
{

Property ICDAdmDR As User.PAAdm(CAPTION = "就诊表ID") [ SqlColumnNumber = 2, SqlFieldName = ICD_Adm_DR ];

Property ICDInvDR As User.DHCINVPRTZY(CAPTION = "发票表ID") [ Required, SqlColumnNumber = 3, SqlFieldName = ICD_Inv_DR ];

Property ICDDepDR As User.dhcsfprintdetail(CAPTION = "住院押金表ID") [ Required, SqlColumnNumber = 4, SqlFieldName = ICD_Dep_DR ];

Property ICDDepStatus As %String(CAPTION = "结算时住院押金表状态") [ SqlColumnNumber = 5, SqlFieldName = ICD_DepStatus ];

Property ICDOptUserDR As User.SSUser(CAPTION = "创建人ID") [ SqlColumnNumber = 6, SqlFieldName = ICD_OptUser_DR ];

Property ICDOptDate As %Date(CAPTION = "创建日期", FORMAT = 1) [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = ICD_OptDate ];

Property ICDOptTime As %Time(CAPTION = "创建时间") [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = ICD_OptTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCINVPRTZYCONDEP)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ICD_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICD_DepStatus">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ICD_Dep_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICD_Inv_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ICD_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ICD_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ICD_OptUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINVPRTZYCONDEP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ICD_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxAdmDR">
<Global>^DHCINVPRTZYCONDEPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICD_Adm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxDepDR">
<Global>^DHCINVPRTZYCONDEPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Dep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICD_Dep_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxInvDR">
<Global>^DHCINVPRTZYCONDEPi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ICD_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Inv"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ICD_Inv_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ICD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINVPRTZYConDepS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
