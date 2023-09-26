/// 体检配置-参数值
Class User.DHCPESettingsValue Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SV_RowId, SqlTableName = DHC_PE_SettingsValue, StorageStrategy = SQLStorage ]
{

/// 参数DR
Property SVSPDR As User.DHCPESettingsParam [ SqlColumnNumber = 2, SqlFieldName = SV_SP_DR ];

/// 参数类型 H：院区 -- L：科室 -- G：安全组 -- U：用户 -- C：自定义
Property SVType As %Library.String [ SqlColumnNumber = 3, SqlFieldName = SV_Type ];

/// 类型值
Property SVTypeValue As %Library.String [ SqlColumnNumber = 4, SqlFieldName = SV_TypeValue ];

/// 参数值
Property SVParamValue As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = SV_ParamValue ];

/// 备注
Property SVRemark As %Library.String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = SV_Remark ];

Storage SQLStorage
{
<SqlIdExpression>$i(^mdata("DHCPESettingsValue"))</SqlIdExpression>
<SQLMap name="ParamTypeIndex">
<Global>^DHCPESettingsValue</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParamDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_SP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SV_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ParamTypeValue">
<Global>^DHCPESettingsValue</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ParamTV"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_SP_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SV_Type}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SV_TypeValue}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SV_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="TypeIndex">
<Global>^DHCPESettingsValue</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SV_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="ValueDataMast">
<Data name="SV_ParamValue">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SV_Remark">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SV_SP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SV_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SV_TypeValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPESettingsValue</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SV_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SV_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPESettingsValueS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
