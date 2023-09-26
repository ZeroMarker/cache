Class User.SSExtMeunGroup Extends %Persistent [ SqlRowIdName = DHCEMG_RowId, SqlTableName = DHC_ExtMenuGroup, StorageStrategy = NewStorage1 ]
{

Property DHCEMGExtMenu As %String [ SqlColumnNumber = 2, SqlFieldName = DHCEMG_ExtMenu ];

Property DHCLVNote As %String [ SqlColumnNumber = 3, SqlFieldName = DHCEMG_Note ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="MasterMap">
<Data name="DHCEMG_ExtMenu">
<Delimiter>"^"</Delimiter>
<Node>"Menu"</Node>
<Piece>1</Piece>
</Data>
<Data name="DHCEMG_Note">
<Delimiter>"^"</Delimiter>
<Node>"Menu"</Node>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>{DHCEMG_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHCEMG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.SSExtMeunGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
