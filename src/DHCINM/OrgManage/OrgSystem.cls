/// Creater:dhh
/// Descriptions:制度维护表
/// Date:2020-07-27
Class DHCINM.OrgManage.OrgSystem Extends %Persistent
{

Relationship ChildSub As DHCINM.OrgManage.OrgSystemSub [ Cardinality = children, Inverse = Parref ];

/// 制度级别
Property SystemDesc As %String [ Required, SqlColumnNumber = 2, SqlFieldName = System_Desc ];

/// 父节点
Property SystemPar As %String [ SqlColumnNumber = 3, SqlFieldName = System_Par ];

/// 序号
Property SystemSort As %String [ SqlColumnNumber = 4, SqlFieldName = System_Sort ];

/// 启用日期
Property StartDate As %Date [ SqlColumnNumber = 5, SqlFieldName = StartDate ];

/// 停用日期
Property EndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = EndDate ];

/// 制度子节点正文【弃用】
Property SystemText As %String(MAXLEN = 1000000000) [ SqlColumnNumber = 7, SqlFieldName = System_Text ];

/// 制度子节点状态
Property SystemStatus As %String [ SqlColumnNumber = 8, SqlFieldName = System_Status ];

/// 文件路径
Property FileUrl As list Of %String(MAXLEN = 200) [ SqlColumnNumber = 9, SqlFieldName = FileUrl ];

/// 富文本
Property ContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 10, SqlFieldName = ContentExt ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 11, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 13, SqlFieldName = Create_Time ];

Index par On SystemPar;

Storage Default
{
<Data name="OrgSystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SystemDesc</Value>
</Value>
<Value name="3">
<Value>SystemPar</Value>
</Value>
<Value name="4">
<Value>SystemSort</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>EndDate</Value>
</Value>
<Value name="7">
<Value>SystemText</Value>
</Value>
<Value name="8">
<Value>SystemStatus</Value>
</Value>
<Value name="9">
<Value>FileUrl</Value>
</Value>
<Value name="10">
<Value>ContentExt</Value>
</Value>
<Value name="11">
<Value>Creator</Value>
</Value>
<Value name="12">
<Value>CreateDate</Value>
</Value>
<Value name="13">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.OrgManage.OrgSystemD</DataLocation>
<DefaultData>OrgSystemDefaultData</DefaultData>
<IdLocation>^DHCINM.OrgManage.OrgSystemD</IdLocation>
<IndexLocation>^DHCINM.OrgManage.OrgSystemI</IndexLocation>
<StreamLocation>^DHCINM.OrgManage.OrgSystemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
