Import SQLUser

/// 分割分类
Class web.DHCBL.OPINVREP.SubHospAvailSeg Extends (%RegisteredObject, %XML.Adaptor, web.DHCBL.BLAbstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter EntityClassName = "web.DHCEntity.OPINVREP.SubHospAvailSeg";

Parameter PersistentClassName = "User.DHCSubHospAvailSeg";

/// 默认的利益代码
Parameter DefaultAvailCode = "YY";

/// 子利益体1
/// 利康药房
Parameter SubAvailCode1 = "LKYF";

/// s mySubHospDR =$o(^User.DHCSuAvailbHospitalI("SAHCodeIndex"," "_..#DefaultAvailCode,0))
ClassMethod GetDefaultAvailDR() As %String
{
	;w ##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	s mySubHospDR =$o(^User.DHCSuAvailbHospitalI("SAHCodeIndex"," "_..#DefaultAvailCode,0))
	;^User.DHCSuAvailbHospitalD(2)
	
	s myDefaultFlag=0
	s mySubRowID=0
	f  s mySubRowID=$o(^User.DHCSuAvailbHospitalD(mySubRowID))  q:((mySubRowID="")||(+myDefaultFlag))  d
	.s myobj=##class(User.DHCSuAvailbHospital).%OpenId(mySubRowID)
	.i myobj.SAHDefaultFlag="Y" d
	..s myDefaultFlag=1
	..s mySubHospDR=mySubRowID
	
	q mySubHospDR
}

/// 利用接收科室可以得到利益体
ClassMethod GetSubHospByRecDep(RecDepDR As %String) As %String
{
	;w ##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetSubHospByRecDep(15)
	s myrtn=""
	s mySubHospDR=""
	i RecDepDR'=""{
		;^User.DHCSubHospAvailSegI("AvLocIdx",3,3,5)=
		;SASCTLocDR, HospDR
		s mySubHospDR=$o(^User.DHCSubHospAvailSegI("AvLocIdx",RecDepDR,0))
	}
	
	i mySubHospDR=""{
		s mySubHospDR = ..GetDefaultAvailDR()
	}
	
	q mySubHospDR
}

/// 根据发票的RowID获取 利益RowID
ClassMethod GetSubHospByINVRowID(INVRowID As %String) As %String
{
	;w ##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetSubHospByINVRowID(15)
	s mySubHospDR=""
	i (INVRowID'=""){
		s mySubHospDR=$p($g(^DHCINVPRT(INVRowID)),"^", 38)
	}
	
	i mySubHospDR=""{
		s mySubHospDR=..GetDefaultAvailDR()
	}
	
	q mySubHospDR
}

/// 根据发票的RowID获取 利益RowID
ClassMethod GreSubHospByINVRowID(INVRowID As %String) As %String
{
	;w ##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GreSubHospByINVRowID(228)
	s mySubHospDR=..GetSubHospByINVRowID(INVRowID)
	
	q mySubHospDR
	
	s BillStr=""
	s mySubHospDR=..GetDefaultAvailDR()
	s myBIRowID=0
	s mystr=""
	f  s myBIRowID=$o(^DHCBCI(0,"INV", INVRowID,myBIRowID)) q:(myBIRowID="")  d
	.s myBPRowID=$p(^DHCBCI(myBIRowID),"^", 2)
	.s mystr=mystr_"^"_myBPRowID
	
	s BillStr=mystr
	s myLen=$l(BillStr,"^")
	s myINVSubHospDR=""
	for I=1:1:myLen  d
	.s myBillRowID=$p(BillStr,"^", I)
	.q:(myBillRowID="")
	.s myPBSub=0
	.f  s myPBSub=$o(^DHCPB(myBillRowID, "O",myPBSub))  q:(myPBSub="")!(mySubHospDR'="")  d
	..q:($d(^DHCPB(myBillRowID, "O",myPBSub))=10)
	..s myOEORIDR=$p(^DHCPB(myBillRowID, "O",myPBSub),"^", 4)
	..;^OEORD(myOEORIDR,"I",mySub, 3)
	..;下面加入条件, 根据条件  选择 医院的分类
	..s myRecDepDR=$p(^OEORD(+myOEORIDR,"I",$p(myOEORIDR,"||",2), 3),"^",6)			;OEORI_RecDep_DR_
	..s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetSubHospByRecDep(myRecDepDR)
	
	q mySubHospDR
}

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	i DTObj.SASRowID="" {
		s myPObj=##class(User.DHCSubHospAvailSeg).%New()
	}else{
		s myPObj=##class(User.DHCSubHospAvailSeg).%OpenId(DTObj.SASRowID)
	}
	
	if (DTObj.SASCTLocDR'=""){
		d myPObj.SASCTLocDRSetObjectId(DTObj.SASCTLocDR)
	}
	
	if DTObj.SASSubAvailHospDR'="" {
		d myPObj.SASSubAvailHospDRSetObjectId(DTObj.SASSubAvailHospDR)
	}
	
	q myPObj
}

Query SelectCTLocByCode(Code As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT CTLOC_Desc, CTLOC_RowID, CTLOC_Code
FROM CT_Loc
where CTLOC_Desc %STARTSWITH :Code or CTLOC_Code %STARTSWITH :Code
}

Query SelectAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,SAS_CTLoc_DR->%ID As SAS_CTLoc_DR,SAS_CTLoc_DR->CTLOC_Desc As CTLOC_Desc, SAS_SubAvailHosp_DR->%ID As SAS_SubAvailHosp_DR,SAS_SubAvailHosp_DR->SAH_Desc As SAH_Desc
FROM DHC_SubHospAvailSeg
order by SAS_CTLoc_DR
}

}
