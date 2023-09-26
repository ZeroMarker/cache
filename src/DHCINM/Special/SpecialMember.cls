/// Creater:wangpf
/// Descriptions:专业组成员
/// Date:2020-07-20
Class DHCINM.Special.SpecialMember Extends %Persistent
{

/// 人员
Property MemberPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Member_Per ];

/// 专业组
Property MemberGroup As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Member_Group ];

/// 职务
Property MemberPost As %String [ SqlColumnNumber = 4, SqlFieldName = Member_Post ];

/// 开始日期
Property MemberStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Member_StDate ];

/// 结束日期
Property MemberEndDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Member_EndDate ];

/// 备注
Property MemberRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 7, SqlFieldName = Member_Remark ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = Create_Time ];

Index Per On (MemberPer, MemberGroup);

Index Group On (MemberGroup, MemberPost);

Index StDate On (MemberPer, MemberStDate);

Storage Default
{
<Data name="SpecialMemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MemberPer</Value>
</Value>
<Value name="3">
<Value>MemberGroup</Value>
</Value>
<Value name="4">
<Value>MemberPost</Value>
</Value>
<Value name="5">
<Value>MemberStDate</Value>
</Value>
<Value name="6">
<Value>MemberEndDate</Value>
</Value>
<Value name="7">
<Value>MemberRemark</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialMemberD</DataLocation>
<DefaultData>SpecialMemberDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialMemberD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialMemberI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialMemberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
