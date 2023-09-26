/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityPhasesModify
/// * Description:	阶段维护表
/// * Author:		Candyxu
/// * Create Date:	2011-11-23
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityPhasesModify Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 指控项目RowID
Property QualityEntryDR As %Integer;

/// 阶段名称
Property QualityPhaseStatusDR As %Integer;

/// 阶段参数
Property QualityQueryDR As %Integer;

/// 备注
Property PhaseDemo As %String(MAXLEN = 500, TRUNCATE = 1);

Index idxQualityEntryDR On QualityEntryDR;

/// do ##class(%ResultSet).RunQuery("EPRmeta.Quality.QualityPhasesModify","SelectDataByEntryID","31584")
Query SelectDataByEntryID(PQEntryID As %String) As %Query(ROWSPEC = "RID:%String,AQEntryID:%String,AQPhaseStatusID:%String,AQphaseStatusDesc:%String,AQueryID:%String,AQueryDesc:%String,APhaseDemo:%String")
{
}

ClassMethod SelectDataByEntryIDExecute(ByRef qHandle As %Binary, PQEntryID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	set RowID = $o(^DHCEPRM.QualityPhasesModifyI("idxQualityEntryDR",PQEntryID,""))
	while RowID '=""
	{
		set AQEntryID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),2)
		set AQPhaseStatusID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),3)
		set AQphaseStatusDesc = $list(^DHCEPRM.QualityPhaseStatusD(AQPhaseStatusID),2) //阶段条目名称
		set AQueryID = $list(^DHCEPRM.QualityPhasesModifyD(RowID),4)
		set AQueryDesc = $list(^DHCEPRM.QualityQueryD(AQueryID),2)  //检查条件条目名称
		set APhaseDemo = $list(^DHCEPRM.QualityPhasesModifyD(RowID),5)
		 	
	    set data=$lb(RowID,AQEntryID,AQPhaseStatusID,AQphaseStatusDesc,AQueryID,AQueryDesc,APhaseDemo)
	    set ^CacheTemp(repid,ind)=data
	    set ind=ind+1
	        
	    set RowID = $o(^DHCEPRM.QualityPhasesModifyI("idxQualityEntryDR",PQEntryID,RowID))    
	}

 	
 	Quit $$$OK
}

ClassMethod SelectDataByEntryIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectDataByEntryIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SelectDataByEntryIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectDataByEntryIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="QualityPhasesModifyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QualityEntryDR</Value>
</Value>
<Value name="3">
<Value>QualityPhaseStatusDR</Value>
</Value>
<Value name="4">
<Value>QualityQueryDR</Value>
</Value>
<Value name="5">
<Value>PhaseDemo</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityPhasesModifyD</DataLocation>
<DefaultData>QualityPhasesModifyDefaultData</DefaultData>
<IdLocation>^DHCEPRM.QualityPhasesModifyD</IdLocation>
<IndexLocation>^DHCEPRM.QualityPhasesModifyI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityPhasesModifyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
