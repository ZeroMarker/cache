Class dbo.SYSConnectionTest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_ConnectionTest ]
{

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property Tes As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Storage Default
{
<Data name="SYSConnectionTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Tes</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSConnectionTestD</DataLocation>
<DefaultData>SYSConnectionTestDefaultData</DefaultData>
<IdLocation>^dbo.SYSConnectionTestD</IdLocation>
<IndexLocation>^dbo.SYSConnectionTestI</IndexLocation>
<StreamLocation>^dbo.SYSConnectionTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
