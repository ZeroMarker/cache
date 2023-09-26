Class DHCDoc.OPDoc.PatientListConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 门诊排队顺序设置界面修
Query GetPatientListConfigList(HospId As %String = "", ExaBorough As %String = "") As %Query(ROWSPEC = "RowID:%String,DocPatientDesc:%String,DocPatientPorio:%String,DocPatientSeries:%String,DocPatientFunction:%String,DocPatientStatusPorio:%String")
{
}

ClassMethod GetPatientListConfigListExecute(ByRef qHandle As %Binary, HospId As %String = "", ExaBorough As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PrescriptSet","GetPrescriptSetList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    if (ExaBorough'=""){
	    s RowID=""
	    for {
		    s RowID=$O(^DHCDocOutPatientListConfigi("Exabor",ExaBorough,RowID))
		    q:RowID=""
		    s DocPatientDesc=$P(^DHCDocOutPatientListConfig(RowID),"^",1)
		    s DocPatientPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",2)
		    s DocPatientSeries=$P(^DHCDocOutPatientListConfig(RowID),"^",3)
		    s DocPatientStatusPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",6)
		    s DocPatientFunction=$g(^DHCDocOutPatientListConfig(RowID,"Function"))
		    d OutputRowPatientListConfig
		}
	}else{
    	s RowID=""
	    for {
		    s RowID=$O(^DHCDocOutPatientListConfigi("HospID",HospId,RowID))
		    q:RowID=""
		    s ExaBoroughdr=$P(^DHCDocOutPatientListConfig(RowID),"^",4)
		    continue:ExaBoroughdr'=""
		    s DocPatientDesc=$P(^DHCDocOutPatientListConfig(RowID),"^",1)
		    s DocPatientPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",2)
		    s DocPatientSeries=$P(^DHCDocOutPatientListConfig(RowID),"^",3)
		    s DocPatientFunction=$g(^DHCDocOutPatientListConfig(RowID,"Function"))
		    s DocPatientStatusPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",6)
		    d OutputRowPatientListConfig
		    }
 
    }

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPatientListConfig
	set Data=$lb(RowID,DocPatientDesc,DocPatientPorio,DocPatientSeries,DocPatientFunction,DocPatientStatusPorio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPatientListConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListConfigListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPatientListConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListConfigListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod Insert(RowID, Desc, Porio, Series, ExaBorough, HospDr, DocPatientFunction, DocPatientStatusPorio)
{
	if (RowID=""){
		s count=0
		&sql(select count(RowID) into :count from SQLUser.DHCDocOutPatientListConfig 
		where (DocPatientDesc=:Desc or DocPatientPorio=:Porio or DocPatientStatusPorio=:DocPatientStatusPorio) and DocPatientHospDr=:HospDr and DocPatientExaBorough=:ExaBorough)
		Q:count'=0 "记录重复!"
		k PLIST
		s PLIST(2)=Desc
		s PLIST(3)=Porio
		s PLIST(4)=Series
		s PLIST(5)=ExaBorough
		s PLIST(6)=HospDr
		s PLIST(7)=DocPatientFunction
		s PLIST(8)=DocPatientStatusPorio
		&sql(insert into SQLUser.DHCDocOutPatientListConfig values :PLIST())
	}else{
		s count=0
		&sql(select count(RowID) into :count from SQLUser.DHCDocOutPatientListConfig 
		where (DocPatientDesc=:Desc or DocPatientPorio=:Porio or DocPatientStatusPorio=:DocPatientStatusPorio) and DocPatientHospDr=:HospDr  and RowID<>:Rowid and DocPatientExaBorough=:ExaBorough)
		Q:count'=0 "记录重复!"
		&sql(update SQLUser.DHCDocOutPatientListConfig 
           set DocPatientDesc=:Desc,DocPatientPorio=:Porio,DocPatientSeries=:Series,DocPatientExaBorough=:ExaBorough,
               DocPatientHospDr=:HospDr,DocPatientFunction=:DocPatientFunction,DocPatientStatusPorio=:DocPatientStatusPorio
           where RowID=:RowID )
	}
	q SQLCODE
}

ClassMethod Delete(RowID)
{
	&sql(delete SQLUser.DHCDocOutPatientListConfig where RowID=:RowID)
	q SQLCODE
}

/// 获得门诊排队顺序golbal
/// w #class(DHCDoc.OPDoc.PatientListConfig).GetOutPatientConfigStr(1)
ClassMethod GetOutPatientConfigStr(DepID)
{
	q:DepID=""
	s ExaBorDepID=$O(^User.DHCExaBorDepI("BordDepDrIndex",DepID,""))
	s HospId=$p($g(^CTLOC(DepID)),"^",22)
	s ExaBorough=""
	s rtn=""
	b ;01
	k OutPatientConfigArry
	if (ExaBorDepID'=""){
		s ExaBorough=$lg(^User.DHCExaBorDepD(ExaBorDepID),6)
		if (ExaBorough'=""){
		    s RowID=""
			for {
			    s RowID=$O(^DHCDocOutPatientListConfigi("Exabor",ExaBorough,RowID))
			    q:RowID=""
			    s DocPatientDesc=$P(^DHCDocOutPatientListConfig(RowID),"^",1)
			    s DocPatientPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",2)
			    s DocPatientSeries=$P(^DHCDocOutPatientListConfig(RowID),"^",3)
				s OutPatientConfigArry(DocPatientPorio)=DocPatientDesc_$C(1)_DocPatientSeries
				}
		}
	
	}
	b ;00
	if ($o(OutPatientConfigArry(""))=""){
		 s RowID=""
			for {
			    s RowID=$O(^DHCDocOutPatientListConfigi("HospID",HospId,RowID))
			    q:RowID=""
			    s ExaBoroughdr=$P(^DHCDocOutPatientListConfig(RowID),"^",4)
		    	continue:ExaBoroughdr'=""
			    s DocPatientDesc=$P(^DHCDocOutPatientListConfig(RowID),"^",1)
			    s DocPatientPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",2)
			    s DocPatientSeries=$P(^DHCDocOutPatientListConfig(RowID),"^",3)
				s OutPatientConfigArry(DocPatientPorio)=DocPatientDesc_$C(1)_DocPatientSeries
				}
	}
	s PorioID=""
	for {
		s PorioID=$O(OutPatientConfigArry(PorioID))
		q:PorioID=""
		s Desc=$P(OutPatientConfigArry(PorioID),$C(1),1)
		s Series=$P(OutPatientConfigArry(PorioID),$C(1),2)
		for i=1:1:Series{
			if rtn="" s rtn=Desc
			else  s rtn=rtn_"^"_Desc
		}
	}
	q rtn
}

/// 得到患者的状态
/// w ##class(DHCDoc.OPDoc.PatientListConfig).GetQueueStatus(1566,2672,1)
ClassMethod GetQueueStatus(QueRowId, AdmID, DepID)
{
	s ExaBorDepID=$O(^User.DHCExaBorDepI("BordDepDrIndex",DepID,""))
	Set QueueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	s HospId=$p($g(^CTLOC(DepID)),"^",22)
	s ExaBorough=""
	s rtn="",CurrenFlag=0
	s DocPatientStatusPorioMaster=999
	k OutPatientConfigArry
	if (ExaBorDepID'=""){
		s ExaBorough=$lg(^User.DHCExaBorDepD(ExaBorDepID),6)
		if (ExaBorough'="")&&($d(^User.DHCExaBoroughD(ExaBorough))){
		    s RowID=""
			for {
			    s RowID=$O(^DHCDocOutPatientListConfigi("Exabor",ExaBorough,RowID))
			    q:RowID=""
			    s DocPatientDesc=$P(^DHCDocOutPatientListConfig(RowID),"^",1)
			    s DocPatientPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",2)
			    s DocPatientStatusPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",6)
			    s NowDesc=""
			    s DocPatientFunction=$g(^DHCDocOutPatientListConfig(RowID,"Function"))
			    s xfunction="if ("_DocPatientFunction_")  {s NowDesc="""_DocPatientDesc_"""}"
			    x xfunction
			    if ((NowDesc'="")&&(DocPatientStatusPorio<DocPatientStatusPorioMaster)){
				    s rtn=NowDesc
				}
			    s CurrenFlag=1
			}
		}
	
	}
	q:CurrenFlag=1 rtn
	s RowID=""
	for {
		s RowID=$O(^DHCDocOutPatientListConfigi("HospID",HospId,RowID))
		q:RowID=""
		s ExaBoroughdr=$P(^DHCDocOutPatientListConfig(RowID),"^",4)
		continue:ExaBoroughdr'=""
		s DocPatientDesc=$P(^DHCDocOutPatientListConfig(RowID),"^",1)
		s DocPatientStatusPorio=$P(^DHCDocOutPatientListConfig(RowID),"^",6)
	    s NowDesc=""
	    s DocPatientFunction=$g(^DHCDocOutPatientListConfig(RowID,"Function"))
	    s xfunction="if ("_DocPatientFunction_")  {s NowDesc="""_DocPatientDesc_"""}"
	    x xfunction
	    if ((NowDesc'="")&&(DocPatientStatusPorio<DocPatientStatusPorioMaster)){
		    s rtn=NowDesc
		}
	}
	q rtn
}

/// 新增的医院自动增加：优先-等候-复诊的排队规则
ClassMethod InsertNewHosp(HospID)
{
	q:HospID="" ""
	d ..Insert("", "优先", "1", "1", "", HospID, "QueueObj.QueFirstDr.FirstcName="""_"优先"_"""", "1")
	d ..Insert("", "等候", "2", "2", "", HospID, "QueueObj.QueStateDr.PersName="""_"等候"_"""", "2")
	d ..Insert("", "复诊", "3", "1", "", HospID, "QueueObj.QueStateDr.PersName="""_"复诊"_"""", "3")
	q 0
}

}
