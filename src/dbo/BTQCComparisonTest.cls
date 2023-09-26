/// 质控对比实验
Class dbo.BTQCComparisonTest Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ComparisonTest ]
{

Index IndexMachine1 On MachineParameterDR1 [ SqlName = Index_Machine1, Type = index, Unique ];

Index IndexMachine2 On MachineParameterDR2 [ SqlName = Index_Machine2, Type = index, Unique ];

Index IndexMachine3 On MachineParameterDR3 [ SqlName = Index_Machine3, Type = index, Unique ];

Index IndexMachine4 On MachineParameterDR4 [ SqlName = Index_Machine4, Type = index, Unique ];

Index IndexMachine5 On MachineParameterDR5 [ SqlName = Index_Machine5, Type = index, Unique ];

/// Foreign Key FKBTQCComparisonTestMachineDR created via DDL
ForeignKey FKBTQCComparisonTestMachineDR1(MachineParameterDR1) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCComparisonTestMachineDR1 ];

ForeignKey FKBTQCComparisonTestMachineDR2(MachineParameterDR2) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCComparisonTestMachineDR2 ];

ForeignKey FKBTQCComparisonTestMachineDR3(MachineParameterDR3) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCComparisonTestMachineDR3 ];

ForeignKey FKBTQCComparisonTestMachineDR4(MachineParameterDR4) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCComparisonTestMachineDR4 ];

ForeignKey FKBTQCComparisonTestMachineDR5(MachineParameterDR5) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCComparisonTestMachineDR5 ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupMachine(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupMachine ];

/// DDL Primary Key Specification
Index PKBTQCCOMPARISONTEST On RowID [ PrimaryKey, SqlName = PK_BTQC_COMPARISONTEST, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 3 ];

/// 仪器1  
Property MachineParameterDR1 As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 仪器2  
Property MachineParameterDR2 As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 仪器3  
Property MachineParameterDR3 As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 仪器4  
Property MachineParameterDR4 As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 仪器5  
Property MachineParameterDR5 As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTQCComparisonTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR1</Value>
</Value>
<Value name="4">
<Value>MachineParameterDR2</Value>
</Value>
<Value name="5">
<Value>MachineParameterDR3</Value>
</Value>
<Value name="6">
<Value>MachineParameterDR4</Value>
</Value>
<Value name="7">
<Value>MachineParameterDR5</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCComparisonTestD</DataLocation>
<DefaultData>BTQCComparisonTestDefaultData</DefaultData>
<IdLocation>^dbo.BTQCComparisonTestD</IdLocation>
<IndexLocation>^dbo.BTQCComparisonTestI</IndexLocation>
<StreamLocation>^dbo.BTQCComparisonTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
