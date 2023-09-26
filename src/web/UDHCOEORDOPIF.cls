Class web.UDHCOEORDOPIF Extends %RegisteredObject
{

/// 门诊收费自动增加医嘱
/// w ##class(web.UDHCOEORDOPIF).AutoAddNewOrder()
ClassMethod AutoAddNewOrder(Paadminfo As %String, UnBillOrdStr As %String, Instype As %String, SFlag As %String, SessionStr As %String, ExpStr As %String) As %String
{
	set myrtn=0
	set myrtn=126_$c(1)_$c(1)			;默认没有写入医嘱
	
	set myVer=##class(web.DHCOPConfig).GetVersion()
	set myClsName="web.UDHCOEORDOP"_myVer
	set myflag=##class(websys.Conversions).IsValidMethodName(myClsName, "AutoAddNewOrder")
	if (myflag)	{
		set myrtn=$classmethod(myClsName, "AutoAddNewOrder", Paadminfo, UnBillOrdStr, Instype, SFlag, SessionStr, ExpStr)
	}
	
	;标志$c(1)医嘱RowID$c(1)价格
	quit myrtn
}

ClassMethod ReadLimitOrdItmStr(PAADMStr As %String, AdmInsType As %String, gLoc As %String, UloadDR As %String) As %String
{
	set myLOrdStr=##class(web.UDHCOEORDOP4).ReadLimitOrdItmStr(PAADMStr, AdmInsType, gLoc, UloadDR)	
	quit myLOrdStr
}

/// 返回组医嘱的符号和主医嘱的RowID
/// w ##class(web.UDHCOEORDOPIF).ReadOEGrpFlag()
ClassMethod ReadOEGrpFlag(OEItmRowID As %String) As %String
{
	set myrtn=##class(web.UDHCOEORDOP1).ReadOEGrpFlag(OEItmRowID)
	quit myrtn
}

/// Descripton: 不能办理结算的医嘱在此加以限制
/// Return: myFlag="" 表示可以收费，如果myFlag=Y  表示不能收费的
/// w ##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag("1162||21")
ClassMethod ReadSkinRtnFlag(OEItmRowID As %String) As %String
{
	set myFlag=""
	
	set myAdm=$p(^OEORD(+OEItmRowID),"^",1)
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(myAdm)
	set myConInfo=##class(web.DHCOPConfig).ReadOPSPConfig(myHospDR)
	set myOESkinRtnFlag=$p(myConInfo,"^",29)		//OPFC_OESkinRtnFlag(0:不限制皮试医嘱, 1:限制皮试医嘱)
	
	if (+myOESkinRtnFlag=1) {
		set myFlag=##class(web.UDHCOEORDOP4).ReadSkinRtnFlag(OEItmRowID)
		if (myFlag="Y") {
			quit myFlag
		}
	}
	
	//自备药医嘱不能结算
	set myPriorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(OEItmRowID)
	set myFlag=$s((+myPriorFlag=1):"Y",1:myFlag)
	
	quit myFlag
}

/// w ##class(web.UDHCOEORDOPIF).ReadDOCByPRTRowID("212967","")
ClassMethod ReadDOCByPRTRowID(PRTRowID As %String, ExpStr As %String) As %String
{
	set myDocName=##class(web.UDHCOEORDOP3).ReadDOCByPRTRowID(PRTRowID)	
	quit myDocName
}

/// 对于结算的医嘱=0
/// 对于不结算的医嘱=1,在收费时退出
ClassMethod ReadOECPriorityFlag(OEORIDR As %String, ExpStr As %String) As %String
{
	set myPRFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(OEORIDR)
	quit myPRFlag
}

/// 用来判断是否发药的标志
/// 主要是用来区分 账单版本
/// w ##class(web.UDHCOEORDOPIF).CheckPhDispRet()
ClassMethod CheckPhDispRet(orditm As %String)
{
	set myrtn=##class(web.UDHCOEORDOP1).CheckPhDispRet(orditm)
	quit myrtn
}

/// w ##class(web.UDHCOEORDOPIF).ReadOEORDExecQty()
ClassMethod ReadOEORDExecQty(PRTRowID As %String, OEORI As %String, ExpStr As %String) As %String
{
	set myrtn=##class(web.UDHCOEORDOP7).ReadOEORDExecQty(PRTRowID, OEORI, ExpStr)
	quit myrtn
}

/// 获取单位价格
/// w ##class(web.UDHCOEORDOPIF).GetOrderPrice(PBORowID, OEORI, SFlag, ExpStr)
ClassMethod GetOrderPrice(PBORowID As %String, OEORI As %String, SFlag As %String, ExpStr As %String) As %String
{
	set PB=+PBORowID
	set PBO=$p(PBORowID,"||",2)
	set PBOData=$g(^DHCPB(PB,"O",PBO))
	set $p(myOrderPrice,"^",1)=$p(PBOData,"^",7)    ;PBO_UnitPrice
	set $p(myOrderPrice,"^",2)=$p(PBOData,"^",17)   ;PBO_DiscPrice
	set $p(myOrderPrice,"^",3)=$p(PBOData,"^",18)   ;PBO_InsPrice
	set $p(myOrderPrice,"^",4)=$p(PBOData,"^",19)   ;PBO_PatPrice
	
	quit myOrderPrice
}

/// w ##class(web.UDHCOEORDOPIF).CheckOEORDChangeStatus(PRTRowID, StopOrdStr, ExpStr)
ClassMethod CheckOEORDChangeStatus(PRTRowID As %String, StopOrdStr As %String, ExpStr As %String) As %String
{
	set myrtn=##class(web.UDHCOEORDOP7).CheckOEORDChangeStatus(PRTRowID, StopOrdStr, ExpStr)
	quit myrtn
}

/// w ##class(web.UDHCOEORDOPIF).CancleStopOrdItemStatus(PRTRowID)
ClassMethod CancleStopOrdItemStatus(PRTRowID As %String, ExpStr As %String) As %String
{
	set myrtn=##class(web.UDHCOEORDOP7).CancleStopOrdItemStatus(PRTRowID)
	quit myrtn
}

/// w ##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag2("1162||21")
ClassMethod ReadSkinRtnFlag2(OEItmRowID As %String) As %String
{
	set myrtn=##class(web.UDHCOEORDOP4).ReadSkinRtnFlag2(OEItmRowID)
	quit myrtn
}

}
