/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityEntryScore
/// * Description:	The entry score at special time
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-07-21
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityEntryScore Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxEntry On EntryID;

Property EntryID As %String(TRUNCATE = 1);

Property EntryScore As %String(TRUNCATE = 1);

Property StartDate As %String(TRUNCATE = 1);

Property EndDate As %String(TRUNCATE = 1);

Property IsActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

Property ResumeText As %String(TRUNCATE = 1);

/*
Query GetScoresByEntryID(AEntryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,EntryID,EntryScore,StartDate,EndDate,IsActive,ResumeText")
{
	SELECT ID,EntryID,EntryScore,StartDate,EndDate,IsActive,ResumeText
	FROM EPRmeta_Quality.QualityEntryScore
	WHERE EntryID =:AEntryID
	ORDER BY ID
}
*/
Query GetScoresByEntryID(pEntryID As %String) As %Query(ROWSPEC = "ID:%String,EntryID:%String,EntryScore:%String,ScoreDesc:%String,StartDate:%String,EndDate:%String,IsActive:%String,ResumeText:%String")
{
}

ClassMethod GetScoresByEntryIDExecute(ByRef qHandle As %Binary, pEntryID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	q:(pEntryID = "")
	s RowID = "0"
	for {
		s RowID = $o(^DHCEPRM.QualityEntryScoreI("IdxEntry"," "_pEntryID,RowID))
		q:(RowID = "")
		s obj = ##Class(EPRmeta.Quality.QualityEntryScore).%OpenId(RowID)
		s EntryID = obj.EntryID
		s EntryScore = obj.EntryScore
		s objEResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
		s ScoreDesc =  objEResult.GetEvaluationValue(EntryScore)
		d objEResult.%Close()
		s objEResult = ""
		s StartDate = obj.StartDate
		s EndDate = obj.EndDate
		s IsActive = obj.IsActive
		s ResumeText = obj.ResumeText
		
		d obj.%Close()
		s obj = ""
	    s Data = $lb(RowID,EntryID,EntryScore,ScoreDesc,StartDate,EndDate,IsActive,ResumeText)
	    s ^CacheTemp(repid,ind) = Data
	    s ind = ind + 1
	}
	Quit $$$OK
}

ClassMethod GetScoresByEntryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScoresByEntryIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetScoresByEntryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScoresByEntryIDExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{				
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="QualityEntryScoreDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EntryID</Value>
</Value>
<Value name="3">
<Value>EntryScore</Value>
</Value>
<Value name="4">
<Value>StartDate</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityEntryScoreD</DataLocation>
<DefaultData>QualityEntryScoreDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityEntryScoreD</IdLocation>
<IndexLocation>^DHCEPRM.QualityEntryScoreI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityEntryScoreS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
