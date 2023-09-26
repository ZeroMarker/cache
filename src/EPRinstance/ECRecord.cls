Class EPRinstance.ECRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID);

Index IdxEpisodeIDChartItemID On (EpisodeID, ChartItemID) [ Unique ];

Property CategoryID As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EpisodeType As %String(TRUNCATE = 1);

Property GroupCategoryID As %String(TRUNCATE = 1);

Property InstanceCount As %Integer;

Relationship Instances As EPRinstance.InstanceData [ Cardinality = children, Inverse = TheECRecord ];

/// the rowid of papatmas
Property PatientID As %String(TRUNCATE = 1);

ClassMethod CheckInstanceExist(APatientID As %String, AEpisodeID As %String, AChartItemID As %String) As %Integer
{
 new Result
 &sql(SELECT Count(EpisodeID)
 into :Result 
 FROM EPRinstance.ECRecord
 WHERE EpisodeID = :AEpisodeID
 And ChartItemID = :AChartItemID )
 if Result=""
 {s Result=0 }
 QUIT Result
}

ClassMethod GetECRecordID(APatientID As %String, AEpisodeID As %String, AChartItemID As %String) As %Integer
{
 new Result
 &sql(SELECT ID
 into :Result 
 FROM EPRinstance.ECRecord
 WHERE EpisodeID = :AEpisodeID
 And ChartItemID = :AChartItemID )
 QUIT Result
}

ClassMethod GetIDByEpisodeAndCategoryID(AEpisodeID As %String, ACategoryID As %String) As %Integer
{
 new Result
 &sql(SELECT ID
 into :Result 
 FROM EPRinstance.ECRecord
 WHERE EpisodeID = :AEpisodeID
 And CategoryID = :ACategoryID )
 QUIT Result
}

/// Desc: 取某个病人的ECRecord记录中旧框架生成的记录的个数，
/// 用于判断该病人的病历是由新框架产生的还是旧框架产生的
/// Input: parEpisodeID:就诊rowid
/// Output: 
/// Return：-1：出错，>-1：病历数
ClassMethod GetOldRecCount(parEpisodeID As %String) As %Integer
{
	s $zt="errhandler"
	k SLQCODE
	s count=-1
	&sql(select count(*) into :count from EPRinstance.ECRecord where EpisodeID = :parEpisodeID and ChartItemID = (+ChartItemID))
	q count
errhandler
	q -1
}

Storage Default
{
<Data name="ECRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChartItemID</Value>
</Value>
<Value name="3">
<Value>ChartItemType</Value>
</Value>
<Value name="4">
<Value>EpisodeID</Value>
</Value>
<Value name="5">
<Value>InstanceCount</Value>
</Value>
<Value name="6">
<Value>PateintID</Value>
</Value>
<Value name="7">
<Value>PatientID</Value>
</Value>
<Value name="8">
<Value>CategoryID</Value>
</Value>
<Value name="9">
<Value>CategoryType</Value>
</Value>
<Value name="10">
<Value>EpisodeType</Value>
</Value>
<Value name="11">
<Value>GroupCategoryID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ECRecordD</DataLocation>
<DefaultData>ECRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRI.ECRecordD</IdLocation>
<IndexLocation>^DHCEPRI.ECRecordI</IndexLocation>
<StreamLocation>^DHCEPRI.ECRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
