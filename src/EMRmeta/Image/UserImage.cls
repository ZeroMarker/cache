/// Desc:		个人图库
/// Creator:	Candyxu
/// CreateDate:	2017-07-13
Class EMRmeta.Image.UserImage Extends (%Persistent, %XML.Adaptor)
{

Index IdxUserSequence On (UserID, Frequency);

/// 图库ID
Property ItemID As %Integer;

/// 用户ID
Property UserID As %Integer;

/// 频次
Property Frequency As %Integer;

Index IdxUserSequenceItemID On (UserID, Frequency, ItemID);

Index IdxUserItemID On (UserID, ItemID);

Storage Default
{
<Data name="UserImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemID</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>Frequency</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.Image.UserImageD</DataLocation>
<DefaultData>UserImageDefaultData</DefaultData>
<IdLocation>^DHCEMRM.Image.UserImageD</IdLocation>
<IndexLocation>^DHCEMRM.Image.UserImageI</IndexLocation>
<StreamLocation>^DHCEMRM.Image.UserImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
