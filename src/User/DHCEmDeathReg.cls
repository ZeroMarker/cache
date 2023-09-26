Class User.DHCEmDeathReg Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DR_RowID, SqlTableName = DHC_EmDeathReg, StorageStrategy = SQLStorage ]
{

/// 患者ID  DR_PAPMI_Dr
Property DRPAPMIDr As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = DR_PAPMI_Dr ];

/// 死亡患者编号  DR_DeathPatNum
Property DRDeathPatNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DR_DeathPatNum ];

/// 送预防科日期  DR_DelPreSecDate	
Property DRDelPreSecDate As %Date [ SqlColumnNumber = 4, SqlFieldName = DR_DelPreSecDate ];

/// 送病历室日期  DR_DelMedRecDate	
Property DRDelMedRecDate As %Date [ SqlColumnNumber = 5, SqlFieldName = DR_DelMedRecDate ];

/// 根本致死原因  DR_FundLetDis	
Property DRFundLetDis As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DR_FundLetDis ];

/// 户主姓名  DR_HouHolderName	
Property DRHouHolderName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DR_HouHolderName ];

/// 创建人  DR_CreateUser
Property DRCreateUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DR_CreateUser ];

/// 创建日期  DR_CreateDate	
Property DRCreateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = DR_CreateDate ];

/// 创建时间  DR_CreateTime	
Property DRCreateTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DR_CreateTime ];

/// 更新人  DR_UpdateUser
Property DRUpdateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = DR_UpdateUser ];

/// 更新日期  DR_UpdateDate
Property DRUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = DR_UpdateDate ];

/// 更新时间  DR_UpdateTime	
Property DRUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = DR_UpdateTime ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMDR)</SqlIdExpression>
<SQLMap name="IndexPapmi">
<Global>^DHCEMDR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DR_PAPMI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="DR_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DR_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DR_CreateUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DR_DeathPatNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DR_DelMedRecDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DR_DelPreSecDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DR_FundLetDis">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DR_HouHolderName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DR_PAPMI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DR_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DR_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DR_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEMDR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDeathRegS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
