Import SQLUSER

Class web.DHCBPPeritonealTubeChange Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPPeritonealTubeChange","FindPeritonealTubeChange")
Query FindPeritonealTubeChange(registerId As %String) As %Query(ROWSPEC = "Id:%String,RegisterId:%String,BuildingDate:%String,BuildingTime:%String,SystolicBP:%Float,DiastolicBP:%Float,Pulse:%Float,Reason:%String,Disconnect:%String,SmoothChange:%String,Input:%Float,Output:%Float,NormalDrainage:%String,Note:%String")
{
}

ClassMethod FindPeritonealTubeChangeExecute(ByRef qHandle As %Binary, registerId As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	q:registerId=""
 	s BPPTCRowId=0
	f  s BPPTCRowId=$o(^DHCBPPeritonealTubeChange(0,"PatRegister",registerId,BPPTCRowId)) q:BPPTCRowId=""  d
		.s Id=BPPTCRowId
	    .s RegisterId=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),1)
	    .s BuildingDate=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),2)
	    .i BuildingDate'="" s BuildingDate=$zd(BuildingDate,3)	    
	    .s BuildingTime=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),3)
	    .i BuildingTime'="" s BuildingTime=$zt(BuildingTime,2)
	    .s SystolicBP=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),4)
	    .s DiastolicBP=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),5)
	    .s Pulse=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),6)
	    .s Reason=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),7)
	    .s Disconnect=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),8)	    
	    .s SmoothChange=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),9)	    
	    .s Input=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),10)	     
	    .s Output=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),11)
	    .s NormalDrainage=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),12)	    
	    .s Note=$lg(^DHCBPPeritonealTubeChange(BPPTCRowId),13)	    
	    .d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,RegisterId,BuildingDate,BuildingTime,SystolicBP,DiastolicBP,Pulse,Reason,Disconnect,SmoothChange,Input,Output,NormalDrainage,Note)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindPeritonealTubeChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPeritonealTubeChangeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindPeritonealTubeChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPeritonealTubeChangeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

//w ##class(web.DHCBPPeritonealTubeChange).SavePeritonealTubeChange("")

ClassMethod SavePeritonealTubeChange(paraStr As %String) As %String
{
	s Id=$p(paraStr,$c(3),1)
	s obj=""
	q:(paraStr="") obj
	i Id="" s obj=##class(User.DHCBPPeritonealTubeChange).%New()
	e  s obj=##class(User.DHCBPPeritonealTubeChange).%OpenId(Id)
	s registerId=$p(paraStr,$c(3),2)	
	i registerId'="" s obj.BPPTCBPPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId(registerId)
	s obj.BPPTCSystolicBP=$p(paraStr,$c(3),3)
	s obj.BPPTCDiastolicBP=$p(paraStr,$c(3),4)
	s obj.BPPTCPulse=$p(paraStr,$c(3),5)
	s obj.BPPTCReason=$p(paraStr,$c(3),6)
	s obj.BPPTCIsDisconnect=$p(paraStr,$c(3),7)
	s obj.BPPTCIsSmoothChange=$p(paraStr,$c(3),8)
	s obj.BPPTCInput=$p(paraStr,$c(3),9)
	s obj.BPPTCOutput=$p(paraStr,$c(3),10)
	s obj.BPPTCIsNormalDrainage=$p(paraStr,$c(3),11)
	s obj.BPPTCNote=$p(paraStr,$c(3),12)
	s bpptcDate=$p(paraStr,$c(3),13)
	s obj.BPPTCDate=##class(web.DHCClinicCom).ConvertToDateH(bpptcDate)
	s bpptcTime=$p(paraStr,$c(3),14)
	s obj.BPPTCTime=##class(web.DHCClinicCom).ConvertToTimeH(bpptcTime)	
	d obj.%Save()	
	s result=obj.%Id()
	d obj.%Close()
	q result
}

}
