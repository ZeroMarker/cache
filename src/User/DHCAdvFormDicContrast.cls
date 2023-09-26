Class User.DHCAdvFormDicContrast Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_AdvFormDicContrast, StorageStrategy = SQLStorage ]
{

/// 字段ID  AF_Field_Dr
Property AFFieldDr As User.DHCAdvFormField [ SqlColumnNumber = 2, SqlFieldName = AF_Field_Dr ];

/// 元素ID  AF_FormDic_Dr
Property AFFormDicDr As User.DHCAdvFormDic [ SqlColumnNumber = 3, SqlFieldName = AF_FormDic_Dr ];

/// 表单ID  AF_Form_Dr
Property AFFormDr As User.DHCAdvFormName [ SqlColumnNumber = 4, SqlFieldName = AF_Form_Dr ];

/// 元素Code  AF_FormDicCode
Property AFFormDicCode As %String [ SqlColumnNumber = 5, SqlFieldName = AF_FormDicCode ];

/// 表单Code  AF_FormNameCode
Property AFFormNameCode As %String [ SqlColumnNumber = 6, SqlFieldName = AF_FormNameCode ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVFDC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_Field_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_FormDicCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AF_FormDic_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AF_FormNameCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AF_Form_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVFDC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFieldCode">
<Global>^DHCADVFDC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FieldCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_Field_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_Form_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFieldFormName">
<Global>^DHCADVFDC</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FieldFormName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_Field_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_FormNameCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFormNameDic">
<Global>^DHCADVFDC</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FormNameDic"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AF_FormNameCode}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AF_FormDicCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvFormDicContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
