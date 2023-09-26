/// 利益体的 支付模式
Class web.DHCEntity.OPC.SubHospPayModes Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 支付模式
Property TotalPayMode As list Of ReportsPayMode;

/// 利用Reports 的RowID 把支付模式赋给这个对象
/// 主要用来 查询时的界面显示
Method SetPayModeByRepRowID(ReportRowID As %String = "") As %Status
{
	s myCount=..TotalPayMode.Count()
	s mySelObj=""
	s mySub=0
	
	f  s mySub=$o(^DHCOPInsFoot(ReportRowID,"P", mySub)) q:(mySub="")  d
	.s mySubHospDR=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",22)
	.;q:(mySubHospDR'="")&&(mySubHospDR'=SubAvailHosp)
	.b	;
	.s myPMDR=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",2)
	.s myINVAcount=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",1)
	.s myINVRefSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",4)
	.s myPRDGetSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",7)
	.s myPRDParkSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",9)
	.s myLParkINVSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",16)
	.s myLStrikINVSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",18)
	.s myLogINVSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",20)
	.s mySubHospDR=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",22)
	.s myINVParkSum=$p(^DHCOPInsFoot(ReportRowID,"P", mySub),"^",10)
	.s myTSum=myINVAcount+myINVRefSum+myPRDGetSum+myPRDParkSum+myLParkINVSum+myLStrikINVSum+myLogINVSum+myINVParkSum
	.q:(myPMDR="")
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s myFFlag=0
	.f myIdx=1:1:myCount q:(+myFFlag=1)  d
	..s mySelObj=..TotalPayMode.GetAt(myIdx)
	..i mySelObj.SubAvailHospitlDR=mySubHospDR d
	...s myFFlag=1
	.b		;;zhaocz
	.q:('$IsObject(mySelObj))
	.d mySelObj.PutPayMode(myPMCode,myTSum,0)
	
	q $$$OK
}

Method %OnNew(initvalue As %String) As %Status [ Private ]
{
	s mySHospDR=0
	f  s mySHospDR=$o(^User.DHCSuAvailbHospitalD(mySHospDR))  q:(mySHospDR="")  d
	.s myobj=##class(User.DHCSuAvailbHospital).%OpenId(mySHospDR)
	.if $IsObject(myobj) d
	..s myTPMObj=##class(web.DHCEntity.OPC.ReportsPayMode).%New()
	..s myDesc=myobj.SAHDesc
	..s myCode=myobj.SAHCode
	..s myTPMObj.SubAvailHospitlDR =mySHospDR
	..s myTPMObj.SubAvailHospitlDesc=myDesc
	..s myTPMObj.SubAvailHospitlCode=myCode
	..;用来保存 不分作废，红冲，和正常的对象
	..d ..TotalPayMode.Insert(myTPMObj)
	..d myTPMObj.%Close()
	
	QUIT $$$OK
}

}
