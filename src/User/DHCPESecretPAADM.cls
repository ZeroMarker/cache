Class User.DHCPESecretPAADM Extends %Persistent [ ClassType = persistent, SqlRowIdName = RowID, SqlTableName = DHC_PE_SecretPAADM, StorageStrategy = NewStorage1 ]
{

Relationship ChildDHCPESecretItem As User.DHCPESecretItem [ Cardinality = children, Inverse = DHCPESecretParRef ];

/// 院外预约id
Property OutPreIADM As %Library.String [ SqlColumnNumber = 2, SqlFieldName = OutPreIADM ];

/// 院外就诊id
Property OutPAADM As %Library.String [ SqlColumnNumber = 3, SqlFieldName = OutPAADM ];

/// 姓名
Property PatName As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PatName ];

/// 性别
Property PatSex As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PatSex ];

/// 出生日期
Property PatAge As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = PatAge ];

/// 身份证号
Property PatIDCard As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PatIDCard ];

/// 电话
Property PatTel As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PatTel ];

/// 检验串
Property LisStr As %Library.String(COLLATION = "Exact", MAXLEN = 100000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = LisStr ];

/// 院内预约id
Property InPreIADM As %Library.String [ SqlColumnNumber = 10, SqlFieldName = InPreIADM ];

/// 院内就诊id
Property InPAADM As %Library.String [ SqlColumnNumber = 11, SqlFieldName = InPAADM ];

/// 院外就诊时间
Property ADMDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 12, SqlFieldName = ADMDate ];

Storage NewStorage1
{
<SqlIdExpression>$I(^mdata("DHCPESecretPAADM"))</SqlIdExpression>
<SQLMap name="Data">
<Data name="ADMDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="InPAADM">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="InPreIADM">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LisStr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OutPAADM">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OutPreIADM">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PatAge">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PatIDCard">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PatName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PatSex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PatTel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexADMDate">
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ADMDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ADMDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInPAADM">
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InPAADMDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InPAADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInPreIADM">
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"InPreIADMDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InPreIADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutPAADM">
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutPAADMDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutPAADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutPreIADM">
<Global>^DHCPESecretPAADM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutPreIADMDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OutPreIADM}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPESecretPAADMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
