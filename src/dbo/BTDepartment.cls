/// 检验科室
Class dbo.BTDepartment Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Department, StorageStrategy = Default ]
{

/// Foreign Key FKReagDepartment created via DDL
ForeignKey FKReagDepartment(ReagDepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_ReagDepartment ];

/// Foreign Key FKDepartmentHospital created via DDL
ForeignKey FKDepartmentHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_DepartmentHospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTDEPARTMENT On RowID [ PrimaryKey, SqlName = PK_BT_DEPARTMENT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 试剂基础数据归属科室
Property ReagDepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BTDepartmentDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>ReagDepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTDepartmentD</DataLocation>
<DefaultData>BTDepartmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTDepartmentD</IdLocation>
<IndexLocation>^dbo.BTDepartmentI</IndexLocation>
<StreamLocation>^dbo.BTDepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
