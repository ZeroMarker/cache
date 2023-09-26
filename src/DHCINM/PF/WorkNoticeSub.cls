/// Creater:lulin
/// Descriptions:通知公告子表
/// Date:2021-04-27
Class DHCINM.PF.WorkNoticeSub Extends %Persistent
{

Relationship Parref As DHCINM.PF.WorkNotice [ Cardinality = parent, Inverse = ChildSub ];

/// 通知人员
Property NoticeUser As CF.DHCINM.DB.MgUser [ SqlColumnNumber = 2, SqlFieldName = NoticeUser ];

/// 查看通知日期
Property LookDate As %Date [ SqlColumnNumber = 3, SqlFieldName = LookDate ];

/// 查看通知时间
Property LookTime As %Time [ SqlColumnNumber = 4, SqlFieldName = LookTime ];

Index User On (Parref, NoticeUser);

Index UserParref On NoticeUser;

Storage Default
{
<Data name="WorkNoticeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NoticeUser</Value>
</Value>
<Value name="3">
<Value>LookDate</Value>
</Value>
<Value name="4">
<Value>LookTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.PF.WorkNoticeSubD</DataLocation>
<DefaultData>WorkNoticeSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.PF.WorkNoticeSubI</IndexLocation>
<StreamLocation>^DHCINM.PF.WorkNoticeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
