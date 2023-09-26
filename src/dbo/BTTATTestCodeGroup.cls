/// 项目结果分组
Class dbo.BTTATTestCodeGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TATTestCodeGroup, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTTATTESTCODEGROUP On RowID [ PrimaryKey, SqlName = PK_BT_TATTESTCODEGROUP, Type = index, Unique ];

/// Foreign Key FKWorkGroup created via DDL
ForeignKey FKWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroup ];

/// Foreign Key FKTATTestCodeHospital created via DDL
ForeignKey FKTATTestCodeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TATTestCodeHospital ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 类型 ?是否其它查询  
Property GroupType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 病人基本信息  
Property PatientInfoJson As %Library.String(COLLATION = "Exact", MAXLEN = 32767) [ SqlColumnNumber = 8 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 公式  
Property FormulaItems As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 10 ];

/// 横纵向配置
Property ShowType As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BTTATTestCodeGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>GroupType</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>PatientInfoJson</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
<Value name="9">
<Value>FormulaItems</Value>
</Value>
<Value name="10">
<Value>ShowType</Value>
</Value>
<Value name="11">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTATTestCodeGroupD</DataLocation>
<DefaultData>BTTATTestCodeGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTATTestCodeGroupD</IdLocation>
<IndexLocation>^dbo.BTTATTestCodeGroupI</IndexLocation>
<StreamLocation>^dbo.BTTATTestCodeGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
