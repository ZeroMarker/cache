/// BTWorkGroup
Class dbo.BTWorkGroup Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroup, StorageStrategy = Default ]
{

/// Foreign Key FKWorkGroup created via DDL
ForeignKey FKWorkGroup(LinkWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_WorkGroup ];

/// Foreign Key FKWorkGroupDepart created via DDL
ForeignKey FKWorkGroupDepart(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_WorkGroupDepart ];

/// Foreign Key FKWorkGroupRoom created via DDL
ForeignKey FKWorkGroupRoom(RoomDR) References dbo.BTRoom(PKBTROOM) [ SqlName = FK_WorkGroupRoom ];

Index IndexCode On (DepartmentDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (DepartmentDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTWORKGROUP On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUP, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 检验科室  
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 负责人  
Property Leader As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 联系电话  
Property Telephone As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 显示操作者  {1:True,0:False}
Property ShowOperator As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 双签字  {1:True,0:False}
Property DoubleCheck As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 报告模版  
Property ReportTempl As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 所在房间  
Property RoomDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// WHONET导出路径  
Property WPath As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 12 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 14 ];

/// LabType  
Property LabType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// 开启电子签名  {1:是,0:否}
Property IsCALogin As %Library.Boolean [ SqlColumnNumber = 16 ];

/// 是否显示设置窗  {1:true,0:false}
Property IsShowSet As %Library.Boolean [ SqlColumnNumber = 17 ];

/// LockUserSecond  
Property LockUserSecond As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// IsUnacceptToClinical  {1:true,0:false}
Property IsUnacceptToClinical As %Library.Boolean [ SqlColumnNumber = 19 ];

/// LinkWorkGroupDR  
Property LinkWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// HISWorkGroup HIS对应的检验科室Code
Property HISWorkGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 21 ];

Storage Default
{
<Data name="BTWorkGroupDefaultData">
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
<Value>Leader</Value>
</Value>
<Value name="6">
<Value>Telephone</Value>
</Value>
<Value name="7">
<Value>ShowOperator</Value>
</Value>
<Value name="8">
<Value>DoubleCheck</Value>
</Value>
<Value name="9">
<Value>ReportTempl</Value>
</Value>
<Value name="10">
<Value>RoomDR</Value>
</Value>
<Value name="11">
<Value>WPath</Value>
</Value>
<Value name="12">
<Value>Sequence</Value>
</Value>
<Value name="13">
<Value>Active</Value>
</Value>
<Value name="14">
<Value>LabType</Value>
</Value>
<Value name="15">
<Value>IsCALogin</Value>
</Value>
<Value name="16">
<Value>IsShowSet</Value>
</Value>
<Value name="17">
<Value>LockUserSecond</Value>
</Value>
<Value name="18">
<Value>IsUnacceptToClinical</Value>
</Value>
<Value name="19">
<Value>LinkWorkGroupDR</Value>
</Value>
<Value name="20">
<Value>HISWorkGroup</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupD</DataLocation>
<DefaultData>BTWorkGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTWorkGroupD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
