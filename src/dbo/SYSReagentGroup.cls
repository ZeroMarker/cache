///     
Class dbo.SYSReagentGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_ReagentGroup, StorageStrategy = Default ]
{

Index IndexMaster On (DepartmentDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequece On Sequence [ SqlName = Index_Sequece, Type = index ];

Index IndexReagentGroup On ReagentGroupDR [ SqlName = Index_ReagentGroup, Type = index ];

/// DDL Primary Key Specification
Index PKSYSREAGENTGROUP On RowID [ PrimaryKey, SqlName = PK_SYS_REAGENTGROUP, Type = index, Unique ];

/// Foreign Key FKRGGroupRGGroup created via DDL
ForeignKey FKRGGroupRGGroup(ReagentGroupDR) References dbo.SYSReagentGroup(PKSYSREAGENTGROUP) [ SqlName = FK_RG_Group_RGGROUP ];

/// Foreign Key FKRGGroupPurhcaser created via DDL
ForeignKey FKRGGroupPurhcaser(PurchaserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RG_Group_Purhcaser ];

/// Foreign Key FKRGReagentGroupDepartment created via DDL
ForeignKey FKRGReagentGroupDepartment(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_RG_ReagentGroup_Department ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ReagentGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property ReagentLevel As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 7 ];

Property PurchaserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="SYSReagentGroupDefaultData">
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
<Value>DepartmentDR</Value>
</Value>
<Value name="5">
<Value>ReagentLevel</Value>
</Value>
<Value name="6">
<Value>PurchaserDR</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>Active</Value>
</Value>
<Value name="10">
<Value>ReagentGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSReagentGroupD</DataLocation>
<DefaultData>SYSReagentGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSReagentGroupD</IdLocation>
<IndexLocation>^dbo.SYSReagentGroupI</IndexLocation>
<StreamLocation>^dbo.SYSReagentGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
