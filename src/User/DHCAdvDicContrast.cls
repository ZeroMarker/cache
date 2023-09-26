Class User.DHCAdvDicContrast Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = AD_RowID, SqlTableName = DHC_AdvDicContrast, StorageStrategy = SQLStorage ]
{

/// 统计/接口元素AD_FormDicCode
Property ADFromDicCode As %String [ SqlColumnNumber = 2, SqlFieldName = AD_FromDicCode ];

/// 事件元素AD_ToDicCode
Property ADToDicCode As %String [ SqlColumnNumber = 3, SqlFieldName = AD_ToDicCode ];

/// 事件表单AD_ToFormNameCode
Property ADToFormNameCode As %String [ SqlColumnNumber = 4, SqlFieldName = AD_ToFormNameCode ];

/// 4.对照标识:0(统计)，1（接口）AD_ContrastFlag
Property ADContrastFlag As %String(DISPLAYLIST = ",统计,接口", MAXLEN = 4, SELECTIVITY = "33.3333%", VALUELIST = ",0,1") [ SqlColumnNumber = 5, SqlFieldName = AD_ContrastFlag ];

/// 医院 AD_HospDr 2021-07-05 多院区改造 cy
Property ADHospDr As User.CTHospital [ SqlColumnNumber = 6, SqlFieldName = AD_HospDr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVDC)</SqlIdExpression>
<SQLMap name="InxdeFromCode">
<Global>^DHCADVDC</Global>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FromCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AD_ContrastFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AD_FromDicCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AD_ToFormNameCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AD_ToDicCode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="AD_ContrastFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AD_FromDicCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AD_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AD_ToDicCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AD_ToFormNameCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvDicContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
