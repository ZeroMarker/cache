Class web.DHCOPCashierIF Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.DHCOPCashierIF).CashierInsertOrdItem("3242","4730||1^1^55^1400.000000^次^1^","17275","3","1608","","")
ClassMethod CashierInsertOrdItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String, OSRID As %String = "", ExpStr As %String = "") As %Status
{
	set myrtn=##class(web.DHCOPCashier).CashierInsertOrdItem(Adm, OrdItemStr, User, Loc, DocUserId, OSRID)
	quit myrtn
}

ClassMethod CheckStockEnough(Arcim As %String, PackQty As %String, RecLoc As %String, ExpStr As %String = "") As %Status
{
	set myrtn=##class(web.DHCOPCashier).CheckStockEnough(Arcim, PackQty, RecLoc, ExpStr)
	quit myrtn
}

ClassMethod CreatePrescNo(Adm As %String, UserId As %String, ExpStr As %String = "") As %Status
{
	do ##class(web.DHCOPCashier).CreatePrescNo(Adm, UserId, ExpStr)
}

/// Debug: w ##class(web.DHCOPCashierIF).FormatPatientNo()
ClassMethod FormatPatientNo(PAPMINo As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).FormatPatientNo(PAPMINo)
	quit myrtn
}

/// w ##class(web.DHCOPCashierIF).GetAdmDetail("202^195^193","2")
ClassMethod GetAdmDetail(AdmStr As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetAdmDetail(AdmStr, ExpStr)
	quit myrtn
}

ClassMethod GetAdmInsCost(Adm As %String, InsType As %String, OrdItemStr As %String, ExpStr As %String = "") As %String
{
	set GroupId=$p(ExpStr,"^",1)
	set LocId=$p(ExpStr,"^",2)
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(LocId)
	set myULCTLocDR=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(GroupId, HospId, LocId)
	set myrtn=##class(web.DHCOPCashier1).GetAdmInsCost(Adm, InsType, OrdItemStr, myULCTLocDR)
	
	quit myrtn
}

ClassMethod GetInsTypeFromPat(PatDr As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetInsTypeFromPat(PatDr)
	quit myrtn
}

ClassMethod GetOPAdmBillSumBroker(AdmStr As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetOPAdmBillSumBroker(AdmStr)
	quit myrtn
}

ClassMethod GetOrderItemDetail(PatType As %String, InsType As %String, OEORI As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetOrderItemDetail(PatType, InsType, OEORI)
	quit myrtn
}

ClassMethod GetPAPMIByNo(PAPMINo As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetPAPMIByNo(PAPMINo)
	quit myrtn
}

ClassMethod GetPatPrescTypeList(PatDr As %String, AdmStr As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetPatPrescTypeList(PatDr, AdmStr, ExpStr)
	quit myrtn
}

ClassMethod GetPatientByRowId(PAPMI As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetPatientByRowId(PAPMI, ExpStr)
	quit myrtn
}

ClassMethod GetToBillSum(PAADM As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).GetToBillSum(PAADM)
	quit myrtn
}

/// w ##class(web.DHCOPCashierIF).GetToDayAdmStr(484,"12173^239^446^9^20")
ClassMethod GetToDayAdmStr(PAPMI As %String, SessionStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier7).GetToDayAdmStr(PAPMI, SessionStr)
	quit myrtn
}

ClassMethod ReturnItemStock(OEORI As %String, ExpStr As %String = "") As %String
{
	set myrtn=##class(web.DHCOPCashier).ReturnItemStock(OEORI)
	quit myrtn
}

/// Creator: wanghc
/// Description: 获取有未结算医嘱的费别
/// Input: adm, type("ALL"或"FIRST"), expStr：扩展串(安全组^科室)
/// Return: type=ALL时 返回adm下所有的insTypeId
///         type=FIRST时 返回adm下的第一个insTypeId
/// Debug: w ##class(web.DHCOPCashierIF).GetInsTypeIdStrOfHaveOrd()
ClassMethod GetInsTypeIdStrOfHaveOrd(adm As %String, type As %String, expStr As %String) As %String
{
	set myrtn=##class(web.DHCOPCashier).GetInsTypeIdStrOfHaveOrd(adm, type, expStr)
	quit myrtn
}

/// Creator: ZhYW
/// CreatDate: 2020-06-15
/// Description: 获取未确认完成的结算记录
/// Input: prtRowIdStr:DHC_INVPRT.RowId串
/// Return: prtRowId_"^"_insTypeDR_"^"_admSource_"^"_insuDivDR，多个之间以$c(2)分割
/// Debug: w ##class(web.DHCOPCashierIF).GetInvalidPrtIDStr(2725)
ClassMethod GetInvalidPrtIDStr(prtRowIdStr As %String) As %String
{
	set ^TMP("GetInvalidPrtIDStr")=prtRowIdStr
	set myrtn=##class(web.DHCOPCashier).GetInvalidPrtIDStr(prtRowIdStr)
	quit myrtn
}

}
