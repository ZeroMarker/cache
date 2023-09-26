/// Desc:       收藏病历评论
/// Creator:    Candy
/// CreateDate: 2014-11-18
Class User.DHCPHFavRecordComment Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 评论内容
Property Content As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 评论人
Property UserID As %String;

/// 评论人科室
Property UserLocCode As %String;

/// 评论日期
Property OPDate As %Date;

/// 评论时间
Property OpTime As %Time;

/// 评论病历ID 指向User.FavRecord
Property InstanceID As %String;

/// 评论得分
Property Scores As %Integer;

Property FavInfoID As %String;

Relationship FavComment As User.DHCPHFavCommentReply [ Cardinality = children, Inverse = ParRef ];

Index IdxFavInstanceID On (FavInfoID, InstanceID);

Storage Default
{
<Data name="FavRecordCommentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Content</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>UserLocCode</Value>
</Value>
<Value name="5">
<Value>OPDate</Value>
</Value>
<Value name="6">
<Value>OpTime</Value>
</Value>
<Value name="7">
<Value>InstanceID</Value>
</Value>
<Value name="8">
<Value>Scores</Value>
</Value>
<Value name="9">
<Value>FavInfoID</Value>
</Value>
</Data>
<DataLocation>^DHCPHF.FavRecordCommentD</DataLocation>
<DefaultData>FavRecordCommentDefaultData</DefaultData>
<IdLocation>^DHCPHF.FavRecordCommentD</IdLocation>
<IndexLocation>^DHCPHF.FavRecordCommentI</IndexLocation>
<StreamLocation>^DHCPHF.FavRecordCommentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
