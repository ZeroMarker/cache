Class User.DHCEQCRoleLimitAmount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RLA_RowID, SqlTableName = DHC_EQCRoleLimitAmount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RLA_ApproveRoleDR
Property RLAApproveRoleDR As User.DHCEQCApproveRole [ SqlColumnNumber = 2, SqlFieldName = RLA_ApproveRoleDR ];

/// RLA_ApproveTypeDR
Property RLAApproveTypeDR As User.DHCEQCApproveType [ SqlColumnNumber = 3, SqlFieldName = RLA_ApproveTypeDR ];

/// RLA_MonthLimitFee
Property RLAMonthLimitFee As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = RLA_MonthLimitFee ];

/// RLA_YearLimitFee
Property RLAYearLimitFee As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = RLA_YearLimitFee ];

/// RLA_Hold1
Property RLAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = RLA_Hold1 ];

/// RLA_Hold2
Property RLAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RLA_Hold2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCRoleLimitAmount",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RLA_ApproveRoleDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RLA_ApproveTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RLA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RLA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RLA_MonthLimitFee">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RLA_YearLimitFee">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RLA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCRoleLimitAmount"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{RLA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexApproveRole">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RLA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCRoleLimitAmount"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ApproveRole"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RLA_ApproveRoleDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RLA_ApproveTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RLA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCRoleLimitAmountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
