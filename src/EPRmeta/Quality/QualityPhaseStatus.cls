/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityPhaseStatus
/// * Description:	颜色状态代码表
/// * Author:		Candyxu
/// * Create Date:	2011-11-23
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityPhaseStatus Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 阶段名称
Property PhaseName As %String(TRUNCATE = 1);

/// 阶段描述
Property PhaseDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 颜色代码
Property ColorID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Index idxSequence On Sequence;

/// do ##class(%ResultSet).RunQuery("EPRmeta.Quality.QualityPhaseStatus","SelectPhaseStatus")
Query SelectPhaseStatus() As %Query(ROWSPEC = "ID:%String,APhaseName:%String,APhaseDesc:%String,APhaseColor:%String,APhaseSequence:%String")
{
}

ClassMethod SelectPhaseStatusExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	set Seq = ""
 	for {
 	   set Seq=$o(^DHCEPRM.QualityPhaseStatusI("idxSequence",Seq))
 	   q:(Seq = "")
 	   set RowID = ""
 	   for {
	       set RowID=$o(^DHCEPRM.QualityPhaseStatusI("idxSequence",Seq,RowID))
	       q:(RowID = "")
	 	   set APhaseName = $list(^DHCEPRM.QualityPhaseStatusD(RowID),2)
	 	   set APhaseDesc = $list(^DHCEPRM.QualityPhaseStatusD(RowID),3)
	 	   set APhaseColor = $list(^DHCEPRM.QualityPhaseStatusD(RowID),4)
	 	   set APhaseSequence = $list(^DHCEPRM.QualityPhaseStatusD(RowID),5)
	 	
	 	   set data=$lb(RowID,APhaseName,APhaseDesc,APhaseColor,APhaseSequence)
	       set ^CacheTemp(repid,ind)=data
	       set ind=ind+1       
	   }
 	}
 	Quit $$$OK
}

ClassMethod SelectPhaseStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPhaseStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SelectPhaseStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPhaseStatusExecute ]
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
<Data name="QualityPhaseStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PhaseName</Value>
</Value>
<Value name="3">
<Value>PhaseDesc</Value>
</Value>
<Value name="4">
<Value>ColorID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityPhaseStatusD</DataLocation>
<DefaultData>QualityPhaseStatusDefaultData</DefaultData>
<IdLocation>^DHCEPRM.QualityPhaseStatusD</IdLocation>
<IndexLocation>^DHCEPRM.QualityPhaseStatusI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityPhaseStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
