Include webimport

IncludeGenerator webimport

Class web.DHCDepMark Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 61;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

ClassMethod QueryDepMarkClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryDepMarkExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// ;d ##class(%ResultSet).RunQuery("web.DHCDepMark","QueryDepMark",7,2)
ClassMethod QueryDepMarkExecute(ByRef QHandle As %Binary, roomid As %String, HospId As %String = "", LocID As %String = "", MarkID As %String = "", SI As %String = "", ST As %String = "", Check As %String = "", locdesc As %String = "", markdesc As %String = "") As %Status
{
	New repid, ind
	New CTCode,CTDesc
	Set repid=$I(^CacheTemp)
	s ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	set myrowid=0
	i roomid="" {
		for  {
			s myrowid=$o(^User.DHCDepMarkD(myrowid)) q:myrowid=""  
			s rid=myrowid
			s borid=$List(^User.DHCDepMarkD(rid),7) ;4
			continue:borid=""
			s hosptdr=""
			if ('$d(^User.DHCExaBoroughD(borid))) {
				s borname=""
			}else{
				s borname=$List(^User.DHCExaBoroughD(borid),5)
				s hosptdr=$lg(^User.DHCExaBoroughD(borid),13)
			}
			s depid=$List(^User.DHCDepMarkD(myrowid),8)
			i depid="" {
				s depname=""
			}else {
				s depname=$p($g(^CTLOC(depid)),"^",2) ;$List(^CTLOC(depid),2) ;DHCRoomCompD(depid)
				if hosptdr="" s hosptdr=$p($g(^CTLOC(depid)),"^",22) 
			}
			continue:hosptdr'=HospId
			continue:((LocID'="")&&(LocID'=depid))
			continue:##class(web.DHCOPAdmReg).CheckLocDesc(depid,locdesc)'=1
			//continue:((locdesc'="")&&(depname'="")&&(depname'[locdesc))
			s markid=$List(^User.DHCDepMarkD(myrowid),3)
			continue:'$$checkRBAS(depid,markid)
			continue:((MarkID'="")&&(MarkID'=markid))
			s markname=$p($g(^CTPCP(markid,1)),"^",2)
			continue:((markdesc'="")&&(markname'[markdesc))
			s st=$List(^User.DHCDepMarkD(myrowid),6)
			i st="Y" s st=1
			continue:((ST'="")&&(ST'=st))
			i st="2"  s st="空值"
			e  s st="当前"
			s si=$List(^User.DHCDepMarkD(myrowid),5)
			continue:((SI'="")&&(SI'=si))
			i si="N" s si="否"
			e  s si="是"
			s Checkin=$List(^User.DHCDepMarkD(myrowid),10)
			continue:((Check'="")&&(Check'=Checkin))
			Do OutputRow
		}
	}else{
 		for {
	 		s myrowid=$o(^User.DHCDepMarkD(myrowid)) q:myrowid=""
			s rid=myrowid
			s borid=$List(^User.DHCDepMarkD(rid),7) 
			i borid=roomid {
				s borname=$List(^User.DHCExaBoroughD(borid),5)
				s depid=$List(^User.DHCDepMarkD(myrowid),8)
				s depname=""
				s:depid'="" depname=$p($g(^CTLOC(depid)),"^",2)
				continue:##class(web.DHCOPAdmReg).CheckLocDesc(depid,locdesc)'=1
				//continue:((locdesc'="")&&(depname'="")&&(depname'[locdesc))
				s hosptdr=$lg(^User.DHCExaBoroughD(borid),13)
				continue:hosptdr'=HospId
				continue:((LocID'="")&&(LocID'=depid))
				s markid=$List(^User.DHCDepMarkD(myrowid),3)
				continue:'$$checkRBAS(depid,markid)
				continue:((MarkID'="")&&(MarkID'=markid))
				s markname=$p($g(^CTPCP(markid,1)),"^",2)
				continue:((markdesc'="")&&(markname'[markdesc))
				s st=$List(^User.DHCDepMarkD(myrowid),6)
				i st="Y" s st=1
				continue:((ST'="")&&(ST'=st))
				i st="2"  s st="空值"
				e  s st="当前"
				s si=$List(^User.DHCDepMarkD(myrowid),5)
				continue:((SI'="")&&(SI'=si))
				i si="N" s si="否"
				e  s si="是"
				s Checkin=$List(^User.DHCDepMarkD(myrowid),10)
				continue:((Check'="")&&(Check'=Checkin))
				Do OutputRow
			}
		}
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
 ;,comname,markname,st,si,roomid,markid,rid
	set Data=$lb(borname,depname,markname,st,si,borid,depid,markid,rid,Checkin)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	set (borname,depname,markname,st,si,borid,depid,markid,rid,Checkin)=""
	quit
checkRBAS(depid,markid)
   n (depid,markid)
   s RESRowId=$o(^RB("RES",0,"CTPCP",markid,depid,""))
   q:(RESRowId="") 0
   s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
   Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h) 0
   s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
   Q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate()) 0
   s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
   Q:(ScheduleRequired'="Y") 0
   s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
   Q:(CTPCPDR="") 0
   Q:'$D(^CTPCP(CTPCPDR,1)) 0
   s ActiveFlag=$P(^CTPCP(CTPCPDR,1),"^",9)
   Q:(ActiveFlag'="Y") 0
   Q 1
}

ClassMethod QueryDepMarkFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepMarkExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
}
 Else {	// fetch row
 Set Row=^CacheTemp(repid,ind)
}
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryDepMark(roomid As %String, HospId As %String = "", LocID As %String = "", MarkID As %String = "", SI As %String = "", ST As %String = "", Check As %String = "", locdesc As %String = "", markdesc As %String = "") As %Query(ROWSPEC = "Tborname:%String,Tdepname:%String,Tmarkname:%String,Tst:%String,Tsi:%String,Tborid:%String,Tdepid:%String,Tmarkid:%String,Tid:%String,TCheckin:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDepMark","Findloc","","")
Query Findloc(depid, markname As %String = "", HospitalID As %String = "") As websys.Query(CONTAINID = 0, ROWSPEC = "Desc:%String,RowID:%String,code:%String")
{
}

ClassMethod FindlocExecute(ByRef qHandle As %Binary, depid, markname As %String = "", HospitalID As %String = "") As %Status
{
	if (HospitalID="")&&($d(%session)) s HospitalID=%session.Get("LOGON.HOSPID")
	Set repid=$I(^CacheTemp)
	Set ind=1
	if depid'=""{
		s RESRowId=""
		for {
			s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
			q:(RESRowId="")
			s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
			continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
			s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
			continue:(DateActiveTo'="")&&(DateActiveTo<+$h)
			s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
			continue:(ScheduleRequired'="Y")
			s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
			continue:(CTPCPDR="")
			continue:'$D(^CTPCP(CTPCPDR,1))
			
			s ActiveFlag=$P(^CTPCP(CTPCPDR,1),"^",9)
			continue:(ActiveFlag'="Y")
			s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
			continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,markname)
			Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
			d OutputRow3
		}
	}else{
		s depid=0
		s MarkStr=""
		for{
			s depid=$O(^RB("RES",0,"CTLOC",depid))
			q:depid=""
			s RESRowId=""
			for {
				s RESRowId=$O(^RB("RES",0,"CTLOC",depid,RESRowId))
				q:(RESRowId="")
				s RESCTLOCDR=$p(^RB("RES",RESRowId),"^",1)
				continue:($p(^CTLOC(RESCTLOCDR),"^",22)'=HospitalID)
				s DateActiveFrom=$P(^RB("RES",RESRowId),"^",22)
				continue:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
				s DateActiveTo=$P(^RB("RES",RESRowId),"^",23)
				continue:(DateActiveTo'="")&&(DateActiveTo<+$h)
				s ScheduleRequired=$P(^RB("RES",RESRowId),"^",6)
				continue:(ScheduleRequired'="Y")
				s CTPCPDR=$P(^RB("RES",RESRowId),"^",2)
				continue:(CTPCPDR="")
				continue:'$D(^CTPCP(CTPCPDR,1))
				
				s ActiveFlag=$P(^CTPCP(CTPCPDR,1),"^",9)
				continue:(ActiveFlag'="Y")
				s CTPCPDesc=$P(^CTPCP(CTPCPDR,1),"^",2)
				continue:0=##Class(web.DHCExaBorough).CheckDocAlias(CTPCPDR,markname)
				Set OtherName=$p(^CTPCP(CTPCPDR,3),"^",28)
				if (("^"_MarkStr_"^")[("^"_CTPCPDR_"^")) continue
				s MarkStr=MarkStr_"^"_CTPCPDR
				d OutputRow3
			}
		}
		
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow3
	Set ^CacheTemp(repid,ind)=$LB(CTPCPDesc,CTPCPDR,OtherName)
	Set ind=ind+1
	quit
}

}
