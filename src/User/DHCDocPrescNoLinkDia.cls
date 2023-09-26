Class User.DHCDocPrescNoLinkDia Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocPrescNoLinkDia, StorageStrategy = DateStorage ]
{

Index DHCDocPrescNoIndex On DHCDocPrescNo;

Index DHCDocEpisodeIDIndex On DHCDocEpisodeID;

Index DHCDocOEORDIndex On DHCDocOEORD;

/// 最后操作人
Property DHCDocPrescNo As %String [ SqlColumnNumber = 2, SqlFieldName = DHCDoc_PrescNo ];

Property DHCDocOEORD As %String [ SqlColumnNumber = 3, SqlFieldName = DHCDoc_OEORD ];

Property DHCDocMRDiaStr As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DHCDoc_MRDiaStr ];

Property DHCDocEpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCDoc_EpisodeID ];

Storage DateStorage
{
<Data name="DHCDocPrescNoLinkDiaData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCDocEpisodeID</Value>
</Value>
<Value name="3">
<Value>DHCDocPrescNo</Value>
</Value>
<Value name="4">
<Value>DHCDocMRDiaStr</Value>
</Value>
<Value name="5">
<Value>DHCDocOEORD</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPrescNoLinkDiaD</DataLocation>
<DefaultData>DHCDocPrescNoLinkDiaData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCDocPrescNoLinkDiaD</IdLocation>
<IndexLocation>^User.DHCDocPrescNoLinkDiaI</IndexLocation>
<StreamLocation>^User.DHCDocPrescNoLinkDiaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
