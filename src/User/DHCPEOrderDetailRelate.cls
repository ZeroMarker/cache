/// 科室站点大项细项组合表
Class User.DHCPEOrderDetailRelate Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ODR_RowId, SqlTableName = DHC_PE_OrderDetailRelate, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEOrderDetailRelate";

Parameter EXTENTSIZE = 250;

/// 医嘱项
Property ODRARCIMDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ODR_ARCIM_DR ];

/// 站点细项
Property ODRODDR As User.DHCPEOrderDetail [ SqlColumnNumber = 3, SqlFieldName = ODR_OD_DR ];

/// 顺序号
Property ODRSequence As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 4, SqlFieldName = ODR_Sequence ];

/// 是否必填项目
Property ODRRequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ODR_Required ];

/// 【作废】大类指针
Property ODRParentDR As User.DHCPEOrderDetailRelate [ SqlColumnNumber = 6, SqlFieldName = ODR_Parent_DR ];

/// 层次
Property ODRCascade As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 7, SqlFieldName = ODR_Cascade ];

/// 体检项目/站点项目
Property ODROrderDR As User.DHCPEStationOrder [ SqlColumnNumber = 8, SqlFieldName = ODR_OrderDR ];

/// 作废标记
Property ODRNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ODR_NoActive ];

/// 更新日期
Property ODRUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = ODR_UpdateDate ];

/// 更新时间
Property ODRUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = ODR_UpdateTime ];

/// 更信人 指向SS_User
Property ODRUpdateUserDR As %String [ SqlColumnNumber = 12, SqlFieldName = ODR_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEODR)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEODR">
<Data name="ODR_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ODR_Cascade">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ODR_NoActive">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ODR_OD_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ODR_OrderDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ODR_Parent_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ODR_Required">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ODR_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ODR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ODR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ODR_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCPEODR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{ODR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIMDR">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{ODR_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIMODDR">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ARCITMODDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ODR_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ODR_OD_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCascade">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Cascade"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ODR_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ODR_Cascade}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ODR_Sequence}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexODDR">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ODR_OD_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderDR">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrderID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ODR_OrderDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParentDR">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ParentDR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ODR_Parent_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ODR_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRequired">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Required"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ODR_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ODR_Required}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSequence">
<Global>^DHCPEODR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ODR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Sequence"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{ODR_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{ODR_Sequence}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ODR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEOrderDetailRelateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
