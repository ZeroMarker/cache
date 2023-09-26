Class User.DHCEQCheckList Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CHL_RowID, SqlTableName = DHC_EQCheckList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CHL_CheckDR
Property CHLCheckDR As User.DHCEQCheck [ SqlColumnNumber = 2, SqlFieldName = CHL_CheckDR ];

/// CHL_CheckItemDR
Property CHLCheckItemDR As User.DHCEQCCheckItem [ SqlColumnNumber = 3, SqlFieldName = CHL_CheckItemDR ];

/// CHL_CheckResultDR
Property CHLCheckResultDR As User.DHCEQCCheckResult [ SqlColumnNumber = 4, SqlFieldName = CHL_CheckResultDR ];

/// CHL_Remark
Property CHLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CHL_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCheckList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CHL_CheckDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CHL_CheckItemDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CHL_CheckResultDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CHL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCheckList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CHL_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CHL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCheckListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
