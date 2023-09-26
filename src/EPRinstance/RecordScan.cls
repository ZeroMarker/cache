/// Creator: Candyx
/// Create Date:2012-08-13
/// Desc:知情同意书图片信息存储
Class EPRinstance.RecordScan Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 存储位置
Property Postion As %String(MAXLEN = 300, TRUNCATE = 1);

/// 父节点RowID
Property ParentID As %String(TRUNCATE = 1);

/// 操作用户
Property UserID As %String(TRUNCATE = 1);

/// 顺序号
Property Sequence As %Integer;

/// 别名
Property AliasName As %String(MAXLEN = 200, TRUNCATE = 1);

Property PatientID As %String(MAXLEN = 20, TRUNCATE = 1);

Property EpisodeID As %String(MAXLEN = 20, TRUNCATE = 1);

Index IdxParentEpisodeID On (ParentID, EpisodeID);

Index IdxPatientID On PatientID;

Index IdxEpisodeID On EpisodeID;

Index IdxParentPatientEpisodeID On (ParentID, PatientID, EpisodeID);

Storage Default
{
<Data name="RecordScanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>Postion</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>AliasName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.RecordScanD</DataLocation>
<DefaultData>RecordScanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.RecordScanD</IdLocation>
<IndexLocation>^DHCEPRI.RecordScanI</IndexLocation>
<StreamLocation>^DHCEPRI.RecordScanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
