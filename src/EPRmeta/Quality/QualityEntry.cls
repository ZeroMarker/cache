/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityEntry
/// * Description:	The model of quality entry, include integrity and consistence items
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityEntry Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxRuleDR On RuleDR;

Index IdxPoolDR On PoolDR;

Index IdxStructDR On StructDR;

Index IdxRuleStruct On (RuleDR, StructDR);

Index IdxIsVetoGrade On (IsVeto, VetoGrade);

Index IdxRulePool On (RuleDR, PoolDR) [ Unique ];

/// Rule reference
Property RuleDR As %String(TRUNCATE = 1);

/// Pool reference
Property PoolDR As %String(TRUNCATE = 1);

/// Struct reference
Property StructDR As %String(TRUNCATE = 1);

/// The score of this entry
Property Score As %String(TRUNCATE = 1);

/// Sequence of problem list
Property Sequence As %String(TRUNCATE = 1);

/// 用于预警;
Property ChkConditionDR As %String(TRUNCATE = 1);

/// Allow multiple evaluate
Property IsMultiErr As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Whether one-vote-down entry
Property IsVeto As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Veto grade
Property VetoGrade As %String(TRUNCATE = 1);

Property IsTakeAssess As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Whether active to evaluate
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Resume of this entry
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0);

/// 条目检查条件
Property EntryConditionDR As %String(TRUNCATE = 1);

/// The Maxscore of this entry
Property MaxScore As %String(TRUNCATE = 1);

/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.Quality.QualityEntry","GetEntriesByRuleStructID",3,10)
Query GetEntriesByRuleStructID(ARuleID As %String, AStructID As %String) As %Query(ROWSPEC = "RuleID,StructID,EntryID,Title,Score,Sequence,IsMultiErr,IsVeto,IsActive,VetoGrade")
{
}

ClassMethod GetEntriesByRuleStructIDExecute(ByRef qHandle As %Binary, ARuleID As %String, AStructID As %String) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:($d(ARuleID) = 0||$d(AStructID) = 0) $$$OK
	q:(ARuleID = "")||(AStructID = "") $$$OK
	
	s (EntryID,Title,Score,Sequence,IsMultiErr,IsVeto,IsActive,VetoGrade) = $C(0)
	s RowID = $o(^DHCEPRM.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_AStructID,""))
	While(RowID '= "")
	{
		s objEntry = $g(^DHCEPRM.QualityEntryD(RowID))
		
		s EntryID = RowID	
		s PoolID = $list(objEntry,1)
		s Title = ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID(PoolID)
		s Score = $list(objEntry,4)
		s Sequence = $list(objEntry,5)
		s IsMultiErr = $list(objEntry,6)
		s IsVeto = $list(objEntry,7)
		s IsActive = $list(objEntry,8)
		s VetoGrade = $list(objEntry,11)
		
		if (IsActive = "Y")
		{
			s Data = $lb(ARuleID,AStructID,EntryID,Title,Score,Sequence,IsMultiErr,IsVeto,IsActive,VetoGrade)
			s ^CacheTemp(repid,ind) = Data
			s ind = ind+1
		}
		
		s RowID = $o(^DHCEPRM.QualityEntryI("IdxRuleStruct"," "_ARuleID," "_AStructID,RowID))	
	}
	q $$$OK
}

ClassMethod GetEntriesByRuleStructIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEntriesByRuleStructIDExecute ]
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
	q $$$OK
}

ClassMethod GetEntriesByRuleStructIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEntriesByRuleStructIDExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="QualityEntryDefaultData">
<Value name="1">
<Value>PoolDR</Value>
</Value>
<Value name="2">
<Value>RuleDR</Value>
</Value>
<Value name="3">
<Value>StructDR</Value>
</Value>
<Value name="4">
<Value>Score</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>IsMultiErr</Value>
</Value>
<Value name="7">
<Value>IsVeto</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>ResumeText</Value>
</Value>
<Value name="10">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="11">
<Value>VetoGrade</Value>
</Value>
<Value name="12">
<Value>IsTakeAssess</Value>
</Value>
<Value name="13">
<Value>ChkConditionDR</Value>
</Value>
<Value name="14">
<Value>EntryConditionDR</Value>
</Value>
<Value name="15">
<Value>MaxScore</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityEntryD</DataLocation>
<DefaultData>QualityEntryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityEntryD</IdLocation>
<IndexLocation>^DHCEPRM.QualityEntryI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityEntryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
