Class web.DHCAccErr17Repair Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

ClassMethod DDDDD() As %String
{
	;w ##class(web.DHCAccErr17Repair).DDDDD()
	;^TMP106CardInfo(2708
	;^TMP150CardInfo(197536
	s my106dr=0
	s my150dr=0
	
	k ^TMP200612FairDataPAPMIN($j)
	
	f  s my106dr=$o(^TMP106CardInfo(2708,my106dr)) q:(my106dr="")  d
	.s my106CardNo=$p(^TMP106CardInfo(2708,my106dr),"^",2)
	.s my150dr=0
	.s ^TMP200612FairDataPAPMIN($j,my106CardNo)=my106CardNo
	.f  s my150dr=$o(^TMP150CardInfo(197536,my150dr)) q:(my150dr="")  d
	..
	..s my150CardNo=$p(^TMP150CardInfo(197536,my150dr),"^",2)
	..;s ^TMP200612FairDataPAPMIN($j,my150CardNo)=my150CardNo
	..i my106CardNo=my150CardNo d
	...b	;;
	
	q 0
}

ClassMethod FFFFF() As %String
{
	;;新的比较人员
	;;w ##class(web.DHCAccErr17Repair).FFFFF()
	;^TMP200612FairDataPAPMINozhaocz
	;^TMP200612FairDataPAPMINozhaocz(,,00322978
	k ^TMP200612FairDataOldHIS
	
	s myJ=1440
	s myPAPMINo=""
	f  s myPAPMINo=$o(^TMP200612FairDataPAPMINo(myJ,myPAPMINo))  q:(myPAPMINo="")  d
	.s myCFRowID=0
	.s frtn=0
	.s myTMPCFRowID=0
	.f  s myCFRowID=$o(^TMP106CardInfo(2708,myCFRowID))  q:((myCFRowID="")!(frtn=1))  d
	..s myCFPAPMINO=$p(^TMP106CardInfo(2708,myCFRowID),"^",2)
	..i myPAPMINo=myCFPAPMINO d
	...s frtn=1
	...s myTMPCFRowID=myCFRowID
	.q:(frtn'=0)
	.s ^TMP200612FairDataOldHIS($j,myPAPMINo)=^TMP200612FairDataPAPMINo(myJ,myPAPMINo)
	
	
	q 0
}

ClassMethod FFFF() As %String
{

	.s myCFRowID=0
	.s frtn=0
	.s myTMPCFRowID=0
	.f  s myCFRowID=$o(^TMP106CardInfo(2708,myCFRowID))  q:((myCFRowID="")!(frtn=1))  d
	..s myCFPAPMINO=$p(^TMP106CardInfo(2708,myCFRowID),"^",2)
	..i myPAPMINo=myCFPAPMINO d
	...s frtn=1
	...s myTMPCFRowID=myCFRowID
	.q:(frtn'=0)
	.s ^TMP200612FairDataOldHIS($j,myPAPMINo)=^TMP106CardInfo(2708,myTMPCFRowID)
}

ClassMethod EEEE() As %String
{
	;;w ##class(web.DHCAccErr17Repair).EEEE()
	k ^TMP200612FairDataPAPMINozhaocz("PAPMI",$j)
	
	s myJ=2736
	s myPAPMINo=""
	f  s myPAPMINo=$o(^TMP200612FairDataPAPMINo(myJ,myPAPMINo))  q:(myPAPMINo="")  d
	.s ^TMP200612FairDataPAPMINozhaocz("PAPMI",$j,myPAPMINo)=^TMP200612FairDataPAPMINo(myJ,myPAPMINo)
	.
	b	;
	s myJ=197456
	s myPAPMINo=""
	f  s myPAPMINo=$o(^TMP200612FairDataPAPMINo(myJ,myPAPMINo))  q:(myPAPMINo="")  d
	.s ^TMP200612FairDataPAPMINozhaocz("PAPMI",$j,myPAPMINo)=^TMP200612FairDataPAPMINo(myJ,myPAPMINo)
	.
	
	q 0
}

}
