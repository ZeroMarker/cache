Class User.DHCPEIDRelate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IDR_RowId, SqlTableName = DHC_PE_IDRelate, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEIDRelate";

Parameter EXTENTSIZE = 250;

/// IDR_ED_DR
Property IDREDDR As User.DHCPEExpertDiagnosis [ SqlColumnNumber = 2, SqlFieldName = IDR_ED_DR ];

/// IDR_ILLS_DR
Property IDRILLSDR As User.DHCPEIllnessStandard [ SqlColumnNumber = 3, SqlFieldName = IDR_ILLS_DR ];

/// 作废标记
Property IDRNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = IDR_NoActive ];

/// 更新日期
Property IDRUpdateDate As %Date [ SqlFieldName = IDR_UpdateDate ];

/// 更新时间
Property IDRUpdateTime As %Time [ SqlFieldName = IDR_UpdateTime ];

/// 更信人 指向SS_User
Property IDRUpdateUserDR As %String [ SqlFieldName = IDR_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEIDR)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEIDR">
<Data name="IDR_ED_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IDR_ILLS_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IDR_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IDR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IDR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IDR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPEIDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IDR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxOfILLSED">
<Global>^DHCPEIDR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IDR_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ILLSED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IDR_ILLS_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IDR_ED_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEDDR">
<Global>^DHCPEIDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"EDDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IDR_ED_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexILLSDR">
<Global>^DHCPEIDR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IDR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ILLSDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IDR_ILLS_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{IDR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEIDRelateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
