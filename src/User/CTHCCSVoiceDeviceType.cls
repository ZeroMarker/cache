/// 描述：语音备忘类型字典
/// 创建人：丁亚男-基础数据平台
/// 创建日期：2021-1-25
Class User.CTHCCSVoiceDeviceType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = CT_HCCSVoiceDeviceType, StorageStrategy = SQLStorage ]
{

/// 备忘类型编码
Property VDTCode As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = VDT_Code ];

/// 备忘类型描述
Property VDTDesc As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = VDT_Desc ];

/// 是否启用
Property VDTActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = VDT_ActiveFlag ];

/// 应用类型
Property VDTType As %String(DISPLAYLIST = ",NURSE,DOCTOR", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",NURSE,DOCTOR") [ SqlColumnNumber = 5, SqlFieldName = VDT_Type ];

/// 备注
Property VDTRemarks As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = VDT_Remarks ];

Storage SQLStorage
{
<ExtentSize>10000</ExtentSize>
<SqlIdExpression>$i(^CT("HCCSVDT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="VDT_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VDT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VDT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VDT_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="VDT_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>{VDT_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSVDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{VDT_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VDT_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSVDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VDT_Code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>VDT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"HCCSVDT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{VDT_Desc}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{VDT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>VDT_RowId</SqlRowIdName>
<StreamLocation>^User.CTHCCSVoiceDeviceTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
