/// 仪器日间质控
Class dbo.QCMachineTCTotal Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = QC_MachineTCTotal ]
{

/// Foreign Key FKMachineTCTotalMachine created via DDL
ForeignKey FKMachineTCTotalMachine(MachineParameterDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_MachineTCTotalMachine ];

/// Foreign Key FKMachineTCTotalTestCode created via DDL
ForeignKey FKMachineTCTotalTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_MachineTCTotalTestCode ];

Index IndexMaster On (MachineParameterDR, TestDate, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKQCMachineTCTotal On RowID [ PrimaryKey, SqlName = PK_QC_MachineTCTotal, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 检测日期  
Property TestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 仪器号  
Property MachineParameterDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 检测项目  
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 结果  
Property ResultNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// Mean  
Property Mean As %Library.Float [ SqlColumnNumber = 7 ];

/// SD值  
Property SD As %Library.Float [ SqlColumnNumber = 8 ];

/// 最大值  
Property MaxValue As %Library.Float [ SqlColumnNumber = 9 ];

/// MaxEpis  
Property MaxEpis As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 10 ];

/// 最小值  
Property MinValue As %Library.Float [ SqlColumnNumber = 11 ];

/// MinEpis  
Property MinEpis As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 12 ];

/// 前次检测日期  
Property LastTestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 前次检测时间  
Property LastTestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// RgLot  
Property RgLot As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 15 ];

/// CurRgMean  
Property CurRgMean As %Library.Float [ SqlColumnNumber = 16 ];

/// CurRgSD  
Property CurRgSD As %Library.Float [ SqlColumnNumber = 17 ];

/// HasQC  {1:true,0:false}
Property HasQC As %Library.Boolean [ SqlColumnNumber = 25 ];

/// QcNum  
Property QcNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 26 ];

Storage Default
{
<Data name="QCMachineTCTotalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestDate</Value>
</Value>
<Value name="3">
<Value>MachineParameterDR</Value>
</Value>
<Value name="4">
<Value>TestCodeDR</Value>
</Value>
<Value name="5">
<Value>ResultNum</Value>
</Value>
<Value name="6">
<Value>Mean</Value>
</Value>
<Value name="7">
<Value>SD</Value>
</Value>
<Value name="8">
<Value>MaxValue</Value>
</Value>
<Value name="9">
<Value>MaxEpis</Value>
</Value>
<Value name="10">
<Value>MinValue</Value>
</Value>
<Value name="11">
<Value>MinEpis</Value>
</Value>
<Value name="12">
<Value>LastTestDate</Value>
</Value>
<Value name="13">
<Value>LastTestTime</Value>
</Value>
<Value name="14">
<Value>RgLot</Value>
</Value>
<Value name="15">
<Value>CurRgMean</Value>
</Value>
<Value name="16">
<Value>CurRgSD</Value>
</Value>
<Value name="17">
<Value>TextRes</Value>
</Value>
<Value name="18">
<Value>MachineFlag</Value>
</Value>
<Value name="19">
<Value>QCRulesDR</Value>
</Value>
<Value name="20">
<Value>DQIVStatus</Value>
</Value>
<Value name="21">
<Value>ExcludeType</Value>
</Value>
<Value name="22">
<Value>ResultType</Value>
</Value>
<Value name="23">
<Value>OriginalValue</Value>
</Value>
<Value name="24">
<Value>HasQC</Value>
</Value>
<Value name="25">
<Value>QcNum</Value>
</Value>
</Data>
<DataLocation>^dbo.QCMachineTCTotalD</DataLocation>
<DefaultData>QCMachineTCTotalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.QCMachineTCTotalD</IdLocation>
<IndexLocation>^dbo.QCMachineTCTotalI</IndexLocation>
<StreamLocation>^dbo.QCMachineTCTotalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
