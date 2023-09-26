/// Creater:lulin
/// Descriptions:通知公告
/// Date:2021-04-27
Class DHCINM.PF.WorkNotice Extends %Persistent
{

Relationship ChildSub As DHCINM.PF.WorkNoticeSub [ Cardinality = children, Inverse = Parref ];

/// 标题
Property NoticeTitle As %String [ SqlColumnNumber = 2, SqlFieldName = Notice_Title ];

/// 重要等级
Property NoticeLevel As %String [ SqlColumnNumber = 3, SqlFieldName = Notice_Level ];

/// 通知日期
Property NoticeDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Notice_Date ];

/// 通知时间
Property NoticeTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Notice_Time ];

/// 通知病区[空着为所有病区]
Property NoticeWard As %String(MAXLEN = 2000) [ SqlColumnNumber = 6, SqlFieldName = Notice_Ward ];

/// 内容
Property NoticeContext As %Stream.GlobalCharacter [ SqlColumnNumber = 7, SqlFieldName = Notice_Context ];

/// 文件存储路径
Property NoticeFileUrl As list Of %String(MAXLEN = 2000) [ SqlColumnNumber = 8, SqlFieldName = Notice_FileUrl ];

/// 状态:N:保存，Y:提交
Property NoticeStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Notice_Status ];

/// 创建人
Property NoticeCreator As %String [ SqlColumnNumber = 10, SqlFieldName = Notice_Creator ];

/// 创建日期
Property NoticeCreatDate As %Date [ SqlColumnNumber = 11, SqlFieldName = Notice_CreatDate ];

/// 创建时间
Property NoticeCreatTime As %Time [ SqlColumnNumber = 12, SqlFieldName = Notice_CreatTime ];

/// 发布日期
Property NoticePubLishDate As %Date [ SqlColumnNumber = 13, SqlFieldName = Notice_PubLishDate ];

/// 发布时间
Property NoticePubLishTime As %Time [ SqlColumnNumber = 14, SqlFieldName = Notice_PubLishTime ];

Index Creator On (NoticeCreator, NoticeDate);

Index DateTime On (NoticeDate, NoticeTime);

Storage Default
{
<Data name="WorkNoticeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NoticeTitle</Value>
</Value>
<Value name="3">
<Value>NoticeLevel</Value>
</Value>
<Value name="4">
<Value>NoticeDate</Value>
</Value>
<Value name="5">
<Value>NoticeTime</Value>
</Value>
<Value name="6">
<Value>NoticeWard</Value>
</Value>
<Value name="7">
<Value>NoticeContext</Value>
</Value>
<Value name="8">
<Value>NoticeFileUrl</Value>
</Value>
<Value name="9">
<Value>NoticeStatus</Value>
</Value>
<Value name="10">
<Value>NoticeCreator</Value>
</Value>
<Value name="11">
<Value>NoticeCreatDate</Value>
</Value>
<Value name="12">
<Value>NoticeCreatTime</Value>
</Value>
<Value name="13">
<Value>NoticePubLishDate</Value>
</Value>
<Value name="14">
<Value>NoticePubLishTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.PF.WorkNoticeD</DataLocation>
<DefaultData>WorkNoticeDefaultData</DefaultData>
<IdLocation>^DHCINM.PF.WorkNoticeD</IdLocation>
<IndexLocation>^DHCINM.PF.WorkNoticeI</IndexLocation>
<StreamLocation>^DHCINM.PF.WorkNoticeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
