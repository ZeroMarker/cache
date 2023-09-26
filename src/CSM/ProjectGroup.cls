/// 项目组
Class CSM.ProjectGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 当前项目组子组数
Property ChildCount As %Integer;

/// ID
/// Property GroupID As %Integer [ Required ];
/// 当前项目组所在层数
Property GrpLevel As %Integer;

/// 项目组名称
Property Name As %String(TRUNCATE = 1) [ Required ];

/// 上级项目组ID，0为最高级
Property ParentID As %Integer [ Required ];

/// 所属项目ID
Property ProjectID As %Integer [ Required ];

/// 在维护界面中本层次的显示顺序
Property ShowOrder As %Integer;

/// 项目组状态：删除0/正常1
Property Status As %String(MAXLEN = 1, TRUNCATE = 1) [ Required ];

Index IdxUniqueName On (ProjectID, Name) [ Unique ];

///    Index MainIdx On GroupID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ProjectGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChildCount</Value>
</Value>
<Value name="3">
<Value>GroupID</Value>
</Value>
<Value name="4">
<Value>GrpLevel</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
<Value name="7">
<Value>ProjectID</Value>
</Value>
<Value name="8">
<Value>ShowOrder</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^CSM.ProjectGroupD</DataLocation>
<DefaultData>ProjectGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ProjectGroupD</IdLocation>
<IndexLocation>^CSM.ProjectGroupI</IndexLocation>
<StreamLocation>^CSM.ProjectGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
