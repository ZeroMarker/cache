Class User.DHCAdvRepOnlineAcc Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ROA_RowID, SqlTableName = DHC_AdvRepOnlineAcc, StorageStrategy = NewStorage1 ]
{

Property ROAOnlineDr As %String [ SqlColumnNumber = 2, SqlFieldName = ROA_Online_Dr ];

Property ROADATE As %Date [ SqlColumnNumber = 3, SqlFieldName = ROA_DATE ];

Property ROATime As %Time [ SqlColumnNumber = 4, SqlFieldName = ROA_Time ];

Property ROAUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = ROA_User ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCADVROA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ROA_DATE">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ROA_Online_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ROA_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ROA_User">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCADVROA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ROA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ROA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCADVROA</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ROA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ROA_Online_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ROA_User}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ROA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvRepOnlineAccS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
