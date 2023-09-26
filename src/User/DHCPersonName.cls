Class User.DHCPersonName Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DHCPN_Rowid, SqlTableName = DHC_PersonName, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PA_Person表id
Property DHCPNPAPersonDR As User.PAPerson [ SqlColumnNumber = 2, SqlFieldName = DHCPN_PAPerson_DR ];

/// 姓名类型
Property DHCPNNameTypeDR As CT.BDP.CT.CTPatMasNameType [ SqlColumnNumber = 3, SqlFieldName = DHCPN_NameType_DR ];

/// 患者姓名
Property DHCPNPatName As %String [ SqlColumnNumber = 4, SqlFieldName = DHCPN_PatName ];

/// 创建人
Property DHCPNCreateUserDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = DHCPN_CreateUser_DR ];

/// 创建日期
Property DHCPNCreateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = DHCPN_CreateDate ];

/// 创建时间
Property DHCPNCreateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = DHCPN_CreateTime ];

/// 更新人
Property DHCPNUpdateUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = DHCPN_UpdateUser_DR ];

/// 更新日期
Property DHCPNUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = DHCPN_UpdateDate ];

/// 更新时间
Property DHCPNUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = DHCPN_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPN(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCPN_CreateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DHCPN_CreateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCPN_CreateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCPN_NameType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCPN_PAPerson_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCPN_PatName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCPN_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCPN_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCPN_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCPN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCPN_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHCPN_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNameType">
<Global>^DHCPN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCPN_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NameType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPN_NameType_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPersonType">
<Global>^DHCPN</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHCPN_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PersonType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCPN_PAPerson_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCPN_NameType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCPN_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DHCPN_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCPersonNameS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
