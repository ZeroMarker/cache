/// Creater:dhh
/// Descriptions:护理文件表
/// Date:2020-07-27
Class DHCINM.OrgManage.OrgSysFile Extends %Persistent
{

Relationship ChildSub As DHCINM.OrgManage.OrgSysFileSub [ Cardinality = children, Inverse = Parref ];

/// 文件夹名称
Property FileDesc As %String [ Required, SqlColumnNumber = 2, SqlFieldName = File_Desc ];

/// 父节点
Property FilePar As %String [ SqlColumnNumber = 3, SqlFieldName = File_Par ];

/// 序号
Property FileSort As %String [ SqlColumnNumber = 4, SqlFieldName = File_Sort ];

/// 浏览权限类型 (A:全员,L:行政级别,W:指定病区)
Property LimiteType As %String [ SqlColumnNumber = 5, SqlFieldName = Limite_Type ];

/// 浏览级别/病区)
Property Limits As %String [ SqlColumnNumber = 6, SqlFieldName = Limits ];

Index par On FilePar;

Storage Default
{
<Data name="OrgSysFileDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileDesc</Value>
</Value>
<Value name="3">
<Value>FilePar</Value>
</Value>
<Value name="4">
<Value>FileSort</Value>
</Value>
<Value name="5">
<Value>LimiteType</Value>
</Value>
<Value name="6">
<Value>Limits</Value>
</Value>
</Data>
<DataLocation>^DHCINM.OrgManage.OrgSysFileD</DataLocation>
<DefaultData>OrgSysFileDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.OrgSysFileD</IdLocation>
<IndexLocation>^DHCINM.OrgManage.OrgSysFileI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.OrgSysFileS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
