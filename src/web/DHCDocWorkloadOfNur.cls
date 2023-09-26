Class web.DHCDocWorkloadOfNur Extends DHCDoc.Util.RegisteredObject
{

/// FindWorkloadOfNur
ClassMethod FindWorkloadOfNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWorkloadOfNurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocWorkloadOfNur","FindWorkloadOfNur","29/12/2020","29/12/2020")
ClassMethod FindWorkloadOfNurExecute(ByRef qHandle As %Binary, OpDate As %String, OpDate2 As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k ^WorkloadOfNur
	if (OpDate2="") {
		s OpDate2=..%SysDate()
	}else{
		s OpDate2=..%ZDH(OpDate2)
	}
	if (OpDate=""){
		s OpDate=OpDate2-30
	}else{
		s OpDate=..%ZDH(OpDate)
	}
	for QSDate=OpDate:1:OpDate2{
		s QueueId=0
		for {
			s QueueId=$o(^DHCQueueStatusi("Date",QSDate,QueueId)) Q:QueueId=""
			s ChildSub=0
			for{
				s ChildSub=$o(^DHCQueueStatusi("Date",QSDate,QueueId,ChildSub)) Q:ChildSub=""
				s QSStatusDr=$p($g(^DHCQueueStatus(QueueId,ChildSub)),"^",4)
				s QSStatus=$lg(^User.DHCPerStateD(QSStatusDr),4)
				continue:(QSStatus="报到")||(QSStatus="退号")||(QSStatus="到达")
				s QSUpUserID=$p($g(^DHCQueueStatus(QueueId,ChildSub)),"^",5)
				continue:QSUpUserID=""
				s GroupID=$p($g(^SSU("SSUSR",QSUpUserID)),"^",5)
				//s CareProvDR=$p($g(^SSU("SSUSR",QSUpUserID)),"^",14)
				//continue:CareProvDR=""
				s AddUserType=##class(web.DHCDocOrderCommon).GetCareProvType(QSUpUserID)
				continue:AddUserType'="NURSE"
				i $d(^WorkloadOfNur(QSUpUserID)){
					s ^WorkloadOfNur(QSUpUserID)=$g(^WorkloadOfNur(QSUpUserID))+1
				}else{
					s ^WorkloadOfNur(QSUpUserID)=1
				}
			}
		}
	}
	s UserID=0
	for{
		s UserID=$o(^WorkloadOfNur(UserID))
		q:UserID=""
		s Initials=$p($g(^SSU("SSUSR",UserID)),"^",1)
		s NurName=$p($g(^SSU("SSUSR",UserID)),"^",2)
		s Workload=$g(^WorkloadOfNur(UserID))
		do OutputRow
	}
		

	k ^WorkloadOfNur
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow      
	set Data=$lb(Initials,NurName,Workload)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindWorkloadOfNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWorkloadOfNurExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query FindWorkloadOfNur(OpDate As %String, OpDate2 As %String) As %Query(ROWSPEC = "Initials:%String:工号,NurName:%String:姓名,Workload:%String:分诊人数")
{
}

}
