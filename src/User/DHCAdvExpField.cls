Class User.DHCAdvExpField Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ADVEXPF_RowID, SqlTableName = DHC_AdvExpField, StorageStrategy = SQLStorage ]
{

/// 	统计表单	 				
Property ADVEXPFFormNameDr As User.DHCAdvFormName [ SqlColumnNumber = 2, SqlFieldName = ADVEXPF_FormName_Dr ];

/// 	统计表单元素					
Property ADVEXPFFormDicDr As User.DHCAdvFormDic [ SqlColumnNumber = 3, SqlFieldName = ADVEXPF_FormDic_Dr ];

/// 	顺序号			
Property ADVEXPFnum As %String [ SqlColumnNumber = 4, SqlFieldName = ADVEXPF_num ];

/// 	表单元素code			
Property ADVEXPFFormDicCode As %String [ SqlColumnNumber = 5, SqlFieldName = ADVEXPF_FormDicCode ];

/// 	关联表指向			
Property ADVEXPFLinkDr As User.DHCAdvExpFieldLink [ SqlColumnNumber = 6, SqlFieldName = ADVEXPF_Link_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVEXPF)</SqlIdExpression>
<SQLMap name="IndexFormName">
<Global>^DHCADVEXPF</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ADVEXPF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FormName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVEXPF_FormName_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFormNameDic">
<Global>^DHCADVEXPF</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADVEXPF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FormNameDic"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVEXPF_FormName_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVEXPF_FormDic_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexFormNamenum">
<Global>^DHCADVEXPF</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADVEXPF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FormNamenum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVEXPF_FormName_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVEXPF_num}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLink">
<Global>^DHCADVEXPF</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Link"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVEXPF_Link_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinkDicCode">
<Global>^DHCADVEXPF</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LinkDicCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVEXPF_Link_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVEXPF_FormDicCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLinknum">
<Global>^DHCADVEXPF</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Linknum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADVEXPF_Link_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADVEXPF_num}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="ADVEXPF_FormDicCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADVEXPF_FormDic_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADVEXPF_FormName_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADVEXPF_Link_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADVEXPF_num">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCADVEXPF</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ADVEXPF_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ADVEXPF_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvExpFieldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
