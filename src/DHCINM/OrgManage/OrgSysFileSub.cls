/// Creater:dhh
/// Descriptions:护理文件子表
/// Date:2020-07-27
Class DHCINM.OrgManage.OrgSysFileSub Extends %Persistent
{

Relationship Parref As DHCINM.OrgManage.OrgSysFile [ Cardinality = parent, Inverse = ChildSub ];

/// 文件名称
Property FileName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = File_Name ];

/// 启用日期
Property StartDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Start_Date ];

/// 停用日期
Property EndDate As %Date [ SqlColumnNumber = 4, SqlFieldName = End_Date ];

/// 文件大小
Property FileSize As %String [ SqlColumnNumber = 5, SqlFieldName = FileSize ];

/// 文件路径
Property FileUrl As list Of %String(MAXLEN = 2000) [ SqlColumnNumber = 6, SqlFieldName = FileUrl ];

/// 上传人
Property Creator As %String [ SqlColumnNumber = 7, SqlFieldName = Creator ];

/// 保存(上传)日期
Property CreateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CreateDate ];

/// 文件类型
Property FileType As %String [ SqlColumnNumber = 9, SqlFieldName = FileType ];

/// 文件序号
Property SubSort As %String [ SqlColumnNumber = 10, SqlFieldName = SubSort ];

Index parr On Parref;

Index Sort On (Parref, SubSort);

Storage Default
{
<Data name="OrgSysFileSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>StartDate</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>FileSize</Value>
</Value>
<Value name="6">
<Value>FileUrl</Value>
</Value>
<Value name="7">
<Value>Creator</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>FileType</Value>
</Value>
<Value name="10">
<Value>SubSort</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>OrgSysFileSubDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.OrgSysFileC("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.OrgManage.OrgSysFileSubI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.OrgSysFileSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
