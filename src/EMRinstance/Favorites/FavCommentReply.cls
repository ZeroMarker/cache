/// Desc:    	评论回复
/// Creator: 	Candy
/// CreateDate:	2014-12-12
Class EMRinstance.Favorites.FavCommentReply Extends (%Persistent, %XML.Adaptor)
{

/// 父节点ID 
Property ParentID As %Integer;

/// 回复内容
Property ReplyContent As %String;

/// 回复用户ID
Property ReplyUser As %String;

/// 回复日期
Property ReplyDate As %Date;

/// 回复时间
Property ReplyTime As %Time;

Relationship ParRef As EMRinstance.Favorites.FavRecordComment [ Cardinality = parent, Inverse = FavComment ];

Index IdxParRefParentID On (ParRef, ParentID);

Storage Default
{
<Data name="FavCommentReplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentID</Value>
</Value>
<Value name="3">
<Value>ReplyContent</Value>
</Value>
<Value name="4">
<Value>ReplyUser</Value>
</Value>
<Value name="5">
<Value>ReplyDate</Value>
</Value>
<Value name="6">
<Value>ReplyTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("FavComment")</DataLocation>
<DefaultData>FavCommentReplyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("FavComment")</IdLocation>
<IndexLocation>^DHCEMRF.FavCommentReplyI</IndexLocation>
<StreamLocation>^DHCEMRF.FavCommentReplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
