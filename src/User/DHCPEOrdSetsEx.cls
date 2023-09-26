/// 体检医嘱套扩展表
Class User.DHCPEOrdSetsEx Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OSE_RowId, SqlTableName = DHC_PE_OrdSetsEx, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEOrdSetsEx";

Parameter EXTENTSIZE = 250;

Index OSEOrdSetsDRUnqIdx1 On OSEOrdSetsDR [ Unique ];

/// 医嘱套
Property OSEOrdSetsDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OSE_OrdSets_DR ];

/// 可否拆分
Property OSEBreak As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = OSE_Break ];

/// 性别
Property OSESexDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = OSE_Sex_DR ];

/// 套餐定价
Property OSEPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = OSE_Price ];

/// 是否有早餐
Property OSEDeit As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = OSE_Deit ];

/// VIP等级
Property OSEVIPlevel As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = OSE_VIPlevel ];

/// 科室（多值，英文逗号分割）
Property OSELoc As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = OSE_Loc ];

/// 开始日期
Property OSEDateBegin As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = OSE_DateBegin ];

/// 结束日期
Property OSEDateEnd As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = OSE_DateEnd ];

/// OSE_PGBase_DR
Property OSEPGBaseDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = OSE_PGBase_DR ];

/// 更新日期
Property OSEUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = OSE_UpdateDate ];

/// 更新时间
Property OSEUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = OSE_UpdateTime ];

/// 更信人 指向SS_User
Property OSEUpdateUserDR As %String [ SqlColumnNumber = 14, SqlFieldName = OSE_UpdateUserDR ];

/// 套餐顺序
Property OSEOrder As %Library.Integer [ SqlColumnNumber = 15, SqlFieldName = OSE_Order ];

/// 使用频次
Property OSEFrequency As %Library.Integer [ SqlColumnNumber = 16, SqlFieldName = OSE_Frequency ];

/// 禁用标志 Y禁用 N启用
Property OSEDisabled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = OSE_Disabled ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEOSE)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEOSE">
<Data name="OSE_Break">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OSE_DateBegin">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OSE_DateEnd">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OSE_Deit">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OSE_Disabled">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OSE_Frequency">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OSE_Loc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OSE_OrdSets_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OSE_Order">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OSE_PGBase_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OSE_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OSE_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OSE_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OSE_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OSE_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OSE_VIPlevel">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCPEOSE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OSE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OSE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCPEOSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrderSetDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OSE_DateBegin}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSE_DateEnd}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGBaseInfo">
<Global>^DHCPEOSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GBaseInfo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OSE_PGBase_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrdSets">
<Global>^DHCPEOSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OSE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OrdSets"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OSE_OrdSets_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrder">
<Global>^DHCPEOSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Order"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OSE_Order}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSex">
<Global>^DHCPEOSE</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Field>OSE_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OSE_Sex_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OSE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEOrdSetsExS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
