Class User.DHCRBCAutoRuleDefine Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DAR_Rowid, SqlTableName = DHCRBC_AutoRuleDefine, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DAR_Rule
Property DARRule As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DAR_Rule ];

/// DAR_RuleResult
Property DARRuleResult As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DAR_RuleResult ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCAutoRuleDefine)</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="DAR_Rule">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DAR_RuleResult">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCAutoRuleDefine</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DAR_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DAR_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCAutoRuleDefineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
