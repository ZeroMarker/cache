/// 仪器项目翻译
Class dbo.BTMIMachineTestCodeTrans Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTMI_MachineTestCodeTrans, StorageStrategy = Default ]
{

/// Foreign Key FKMachineResultTranslate created via DDL
ForeignKey FKMachineResultTranslate(MachineTestCodeDR) References dbo.BTMIMachineTestCode(PKBTMIMACHINETESTCODE) [ SqlName = FK_MachineResultTranslate ];

Index IndexMaster On (MachineTestCodeDR, Result) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTMIMACHINETESTCODETRANS On RowID [ PrimaryKey, SqlName = PK_BTMI_MACHINETESTCODETRANS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 仪器项目代码  
Property MachineTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 结果  
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 结果（新）  
Property NewResult As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BTMIMachineTestCodeTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineTestCodeDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>NewResult</Value>
</Value>
</Data>
<DataLocation>^dbo.BTMIMachineTestCodeTransD</DataLocation>
<DefaultData>BTMIMachineTestCodeTransDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTMIMachineTestCodeTransD</IdLocation>
<IndexLocation>^dbo.BTMIMachineTestCodeTransI</IndexLocation>
<StreamLocation>^dbo.BTMIMachineTestCodeTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
