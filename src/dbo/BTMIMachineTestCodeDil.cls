/// 仪器项目稀释倍数
Class dbo.BTMIMachineTestCodeDil Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineTestCodeDil ]
{

/// Foreign Key FKMachineResultTranslate created via DDL
ForeignKey FKMachineTestCodeDR(MachineTestCodeDR) References dbo.BTMIMachineTestCode(PKBTMIMACHINETESTCODE) [ SqlName = FK_MachineTestCodeDR ];

Index IndexMaster On (MachineTestCodeDR, DilCode) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMACHINETESTCODEDIL On RowID [ PrimaryKey, SqlName = PK_BT_MIMACHINETESTCODEDIL, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 项目代码  
Property MachineTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 稀释代码  
Property DilCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 稀释名称  
Property DilName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineTestCodeDilDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineTestCodeDR</Value>
</Value>
<Value name="3">
<Value>DilCode</Value>
</Value>
<Value name="4">
<Value>DilName</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineTestCodeDilD</DataLocation>
<DefaultData>BTMIMachineTestCodeDilDefaultData</DefaultData>
<IdLocation>^dbo.BTMIMachineTestCodeDilD</IdLocation>
<IndexLocation>^dbo.BTMIMachineTestCodeDilI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineTestCodeDilS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
