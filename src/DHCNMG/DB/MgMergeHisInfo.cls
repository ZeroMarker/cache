/// Creator:
/// Descriptions:同步HIS信息
/// Date:2017-11-22
/// 
Class DHCNMG.DB.MgMergeHisInfo Extends %Persistent
{

/// 人员表ID
Property MergeNurseID As %String [ SqlColumnNumber = 2, SqlFieldName = Merge_NurseID ];

/// HIS工号
Property MergeHISNo As %String [ SqlColumnNumber = 3, SqlFieldName = Merge_HISNo ];

/// 用户类型[Y:已经同步HIS，N：未同步HIS]
Property MergeType As %String [ SqlColumnNumber = 4, SqlFieldName = Merge_Type ];

Index type On MergeType;

Index ssid On MergeNurseID;

Index HIS On MergeHISNo;

Storage Default
{
<Data name="MgMergeHisInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MergeNurseID</Value>
</Value>
<Value name="3">
<Value>MergeHISNo</Value>
</Value>
<Value name="4">
<Value>MergeType</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.DB.MgMergeHisInfoD</DataLocation>
<DefaultData>MgMergeHisInfoDefaultData</DefaultData>
<IdLocation>^DHCNMG.DB.MgMergeHisInfoD</IdLocation>
<IndexLocation>^DHCNMG.DB.MgMergeHisInfoI</IndexLocation>
<StreamLocation>^DHCNMG.DB.MgMergeHisInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
