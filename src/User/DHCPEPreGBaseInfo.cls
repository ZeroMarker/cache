Class User.DHCPEPreGBaseInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGBI_RowId, SqlTableName = DHC_PE_PreGBaseInfo, StorageStrategy = SQLStorage ]
{

Parameter ClassName = "User.DHCPEPreGBaseInfo";

Parameter EXTENTSIZE = 250;

Index PGBIPAPMINoUnqIndex On PGBIPAPMINo [ Unique ];

/// PGBI_Account 
Property PGBIAccount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PGBI_Account ];

/// PGBI_Address  地址
Property PGBIAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PGBI_Address ];

/// PGBI_Bank  银行
Property PGBIBank As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PGBI_Bank ];

/// PGBI_Code  编码
Property PGBICode As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PGBI_Code ];

/// PGBI_Desc  描述
Property PGBIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PGBI_Desc ];

/// PGBI_Email  邮箱
Property PGBIEmail As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PGBI_Email ];

/// PGBI_FAX   传真
Property PGBIFAX As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PGBI_FAX ];

/// PGBI_Linkman1 联系人1
Property PGBILinkman1 As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PGBI_Linkman1 ];

/// PGBI_Linkman2  联系人2
Property PGBILinkman2 As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PGBI_Linkman2 ];

/// PGBI_PAPMINo 登记号
Property PGBIPAPMINo As %Library.String(COLLATION = "Exact", MAXLEN = 12, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PGBI_PAPMINo ];

/// PGBI_Postalcode 邮编
Property PGBIPostalcode As %Library.String(COLLATION = "Exact", MAXLEN = 6, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PGBI_Postalcode ];

/// PGBI_Rebate 折扣率
Property PGBIRebate As %Library.Numeric(SCALE = 4) [ SqlColumnNumber = 16, SqlFieldName = PGBI_Rebate ];

/// PGBI_Tel1   联系电话1
Property PGBITel1 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PGBI_Tel1 ];

/// PGBI_Tel2   联系电话2
Property PGBITel2 As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PGBI_Tel2 ];

/// PGBI_TaxIDNum 纳税人识别号
Property PGBITaxIDNum As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PGBI_TaxIDNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPEPreGBI)</SqlIdExpression>
<SQLMap name="DataMasterDHCPEPreGBI">
<Data name="PGBI_Account">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PGBI_Address">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PGBI_Bank">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PGBI_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PGBI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PGBI_Email">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PGBI_FAX">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PGBI_Linkman1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PGBI_Linkman2">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PGBI_PAPMINo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PGBI_Postalcode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PGBI_Rebate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PGBI_TaxIDNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PGBI_Tel1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PGBI_Tel2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCPEPreGBI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PGBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PGBI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCPEPreGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGBI_Code}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCPEPreGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGBI_Desc}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMINo">
<Global>^DHCPEPreGBI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PGBI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPAMINo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PGBI_PAPMINo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PGBI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPEPreGBaseInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
