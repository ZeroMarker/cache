/// 检验基础表
Class dbo.BTBaseTable Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_BaseTable, StorageStrategy = Default ]
{

Index IndexCode On (TableTypeDR, HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexDepartment On (TableTypeDR, DepartmentDR, Code) [ SqlName = Index_Department, Type = index, Unique ];

Index IndexSequence On (TableTypeDR, HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTBASETABLE On RowID [ PrimaryKey, SqlName = PK_BT_BASETABLE, Type = index, Unique ];

/// Foreign Key FKWorkGroupMachine created via DDL
ForeignKey FKWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroupDR ];

/// Foreign Key FKMachineWorkGroup created via DDL
ForeignKey FKWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_WorkGroupMachineDR ];

/// Foreign Key FKBTBASETHospital created via DDL
ForeignKey FKBTBASETHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BT_BASET_Hospital ];

/// Foreign Key FKBTBaseTableHospital created via DDL
ForeignKey FKBTBaseTableHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BT_BaseTable_Hospital ];

/// Foreign Key FKBTBaseTableType created via DDL
ForeignKey FKBTBaseTableType(TableTypeDR) References dbo.BTTableType(PKBTTABLETYPE) [ SqlName = FK_BT_BaseTableType ];

/// Foreign Key FKWorkGroupDepart created via DDL
ForeignKey FKBTBaseTableDepart(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_BT_BaseTableDepart ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 类型  
Property TableTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 4 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 5 ];

/// 描述  
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 800) [ SqlColumnNumber = 6 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// QSIType  {REPORTERR:报告不正确}
Property QSIType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 12 ];

/// Department  
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="BTBaseTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableTypeDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>WorkGroupDR</Value>
</Value>
<Value name="10">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="11">
<Value>QSIType</Value>
</Value>
<Value name="12">
<Value>DepartmentDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTBaseTableD</DataLocation>
<DefaultData>BTBaseTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTBaseTableD</IdLocation>
<IndexLocation>^dbo.BTBaseTableI</IndexLocation>
<StreamLocation>^dbo.BTBaseTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
