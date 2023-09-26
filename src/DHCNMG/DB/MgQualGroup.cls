/// Creater:lulin
/// Descriptions:质控检查小组
/// Date:2018-05-23
Class DHCNMG.DB.MgQualGroup Extends %Persistent
{

/// 小组描述
Property GroupDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Desc ];

/// 小组成员
Property GroupMember As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Group_Member ];

/// 小组层级 H:护理部。L:大科。【W:病区:只有大科和护理部可以添加】
Property GroupLevel As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Level ];

/// 小组所属科室ID,层级为护理部：空
Property GroupLevelID As %String [ SqlColumnNumber = 5, SqlFieldName = Group_LevelID ];

/// 编辑人
Property GroupCreater As DHCNMG.HR.MgPersons [ SqlColumnNumber = 6, SqlFieldName = Group_Creater ];

/// 编辑日期
Property GroupDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Group_Date ];

/// 编辑时间
Property GroupTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Group_Time ];

/// 备注
Property GroupRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Group_Remark ];

Index level On GroupLevel;

Storage Default
{
<Data name="MgQualGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupDesc</Value>
</Value>
<Value name="3">
<Value>GroupMember</Value>
</Value>
<Value name="4">
<Value>GroupLevel</Value>
</Value>
<Value name="5">
<Value>GroupLevelID</Value>
</Value>
<Value name="6">
<Value>GroupCreater</Value>
</Value>
<Value name="7">
<Value>GroupDate</Value>
</Value>
<Value name="8">
<Value>GroupTime</Value>
</Value>
<Value name="9">
<Value>GroupRemark</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgQualGroupD</DataLocation>
<DefaultData>MgQualGroupDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgQualGroupD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgQualGroupI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgQualGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
