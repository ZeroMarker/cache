/// Creater:wangpf
/// Descriptions:质控检查组
/// Date:2020-06-15
Class DHCINM.CHK.MgQualGroup Extends %Persistent
{

/// 小组描述
Property GroupDesc As %String [ SqlColumnNumber = 2, SqlFieldName = Group_Desc ];

/// 小组成员
Property GroupMember As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Group_Member ];

/// 小组层级 H:护理部 L:大科 W:病区
Property GroupLevel As %String [ SqlColumnNumber = 4, SqlFieldName = Group_Level ];

/// 备注
Property GroupRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Group_Remark ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = CreateTime ];

Index Level On GroupLevel;

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
<Value>GroupRemark</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgQualGroupD</DataLocation>
<DefaultData>MgQualGroupDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgQualGroupD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgQualGroupI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgQualGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
