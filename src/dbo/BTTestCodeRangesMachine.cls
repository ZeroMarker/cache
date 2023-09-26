/// 检测项目参考范围
Class dbo.BTTestCodeRangesMachine Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeRangesMachine, StorageStrategy = Default ]
{

Index IndexMachineParameter On (MachineParameterDR, TestCodeDR) [ SqlName = Index_MachineParameter, Type = index ];

Index IndexMaster On (TestCodeDR, MachineParameterDR, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexTestCodeSex On (TestCodeDR, MachineParameterDR, SpeciesDR) [ SqlName = Index_TestCodeSex, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTCODERANGESMACHINE On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODERANGESMACHINE, Type = index, Unique ];

/// Foreign Key FKTestCodeRangesMachine created via DDL
ForeignKey FKTestCodeRangesMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_TestCodeRangesMachine ];

/// Foreign Key FKTestCodeRangesMachineCli created via DDL
ForeignKey FKTestCodeRangesMachineCli(ClinicalConditionsDR) References dbo.BTClinicalConditions(PKBTCLINICALCONDITIONS) [ SqlName = FK_TestCodeRangesMachineCli ];

/// Foreign Key FKTestCodeRangesMachineLoc created via DDL
ForeignKey FKTestCodeRangesMachineLoc(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_TestCodeRangesMachineLoc ];

/// Foreign Key FKTestCodeRangesMachineSex created via DDL
ForeignKey FKTestCodeRangesMachineSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_TestCodeRangesMachineSex ];

/// Foreign Key FKTestCodeRangesMachineSp created via DDL
ForeignKey FKTestCodeRangesMachineSp(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_TestCodeRangesMachineSp ];

/// Foreign Key FKTestCodeRangesMachineTC created via DDL
ForeignKey FKTestCodeRangesMachineTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeRangesMachineTC ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 仪器  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 年龄低值  
Property AgeLow As %Library.Float [ SqlColumnNumber = 7 ];

/// 年龄高值  
Property AgeHigh As %Library.Float [ SqlColumnNumber = 8 ];

/// 性别  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 临床条件  
Property ClinicalConditionsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 低值  
Property ValueLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

/// 高值  
Property ValueHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

/// 危机低值  
Property PanicLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 危机高值  
Property PanicHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 15 ];

/// 荒诞低值  
Property UnacceptLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 16 ];

/// 荒诞低值  
Property UnacceptHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 17 ];

/// 是否默认  {1:true,0:false}
Property IsDefault As %Library.Boolean [ SqlColumnNumber = 18 ];

/// RefRanges  
Property RefRanges As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

/// 参考范围生效开始时间
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 参考范围生效结束时间
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 显示年龄低值  
Property SAgeLow As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 22 ];

/// 显示年龄高值 
Property SAgeHigh As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 23 ];

/// 显示年龄低值单位 
Property SAgeLowUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

/// 显示年龄高值单位 
Property SAgeHighUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 25 ];

/// 临床症状  
Property Symptom As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="BTTestCodeRangesMachineDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>OrderNo</Value>
</Value>
<Value name="5">
<Value>SpeciesDR</Value>
</Value>
<Value name="6">
<Value>AgeLow</Value>
</Value>
<Value name="7">
<Value>AgeHigh</Value>
</Value>
<Value name="8">
<Value>SpecimenDR</Value>
</Value>
<Value name="9">
<Value>ClinicalConditionsDR</Value>
</Value>
<Value name="10">
<Value>LocationDR</Value>
</Value>
<Value name="11">
<Value>ValueLow</Value>
</Value>
<Value name="12">
<Value>ValueHigh</Value>
</Value>
<Value name="13">
<Value>PanicLow</Value>
</Value>
<Value name="14">
<Value>PanicHigh</Value>
</Value>
<Value name="15">
<Value>UnacceptLow</Value>
</Value>
<Value name="16">
<Value>UnacceptHigh</Value>
</Value>
<Value name="17">
<Value>IsDefault</Value>
</Value>
<Value name="18">
<Value>RefRanges</Value>
</Value>
<Value name="19">
<Value>StartDate</Value>
</Value>
<Value name="20">
<Value>EndDate</Value>
</Value>
<Value name="21">
<Value>SAgeLow</Value>
</Value>
<Value name="22">
<Value>SAgeHigh</Value>
</Value>
<Value name="23">
<Value>SAgeLowUnitDR</Value>
</Value>
<Value name="24">
<Value>SAgeHighUnitDR</Value>
</Value>
<Value name="25">
<Value>Symptom</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeRangesMachineD</DataLocation>
<DefaultData>BTTestCodeRangesMachineDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeRangesMachineD</IdLocation>
<IndexLocation>^dbo.BTTestCodeRangesMachineI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeRangesMachineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
